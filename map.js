// =============================================================================
//  Mapa-múndi de pontos de pesca + viagem/diária/licenças.
//  Reaproveita a mesma camada de dados (store.js). Usa Leaflet (global L).
// =============================================================================
import { createStore } from "./store.js";

const esc = (s) => String(s ?? "").replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));
const cr = (n) => (n == null || n === "" ? "—" : Number(n).toLocaleString("pt-BR") + " cr");
const FLAG = { "EUA": "🇺🇸", "República Tcheca": "🇨🇿", "Rússia": "🇷🇺" };
const flag = (p) => FLAG[p] || "🌍";

async function main() {
  let store;
  try { store = await createStore(); setBanner(store.mode); }
  catch (e) { setBanner("error", e?.message || String(e)); return; }
  const locais = store.getLocais();
  initMap(locais);
  renderCountries(locais);
}

function setBanner(mode, msg) {
  const b = document.getElementById("modeBanner");
  if (!b) return;
  b.hidden = false;
  b.className = "mode-banner " + (mode === "error" ? "error" : mode);
  b.textContent = mode === "cloud"
    ? "☁️ Modo colaborativo (Supabase)."
    : mode === "error"
      ? "⚠️ Supabase inacessível: " + msg + " — adicione ?local na URL para a demo offline."
      : "🗄️ Modo local (demo). Viagem/diária/licenças são valores aproximados da comunidade.";
}

function initMap(locais) {
  const withGeo = locais.filter((l) => l.lat != null && l.lng != null);
  const map = L.map("map", { scrollWheelZoom: false }).setView([35, -40], 2);
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: "© OpenStreetMap", maxZoom: 12,
  }).addTo(map);
  const pts = [];
  for (const l of withGeo) {
    L.marker([l.lat, l.lng]).addTo(map).bindPopup(popupHtml(l));
    pts.push([l.lat, l.lng]);
  }
  if (pts.length) map.fitBounds(pts, { padding: [40, 40], maxZoom: 5 });
}

function popupHtml(l) {
  return `<div class="map-pop">
    <b>${flag(l.pais)} ${esc(l.nome)}</b>
    <div class="muted">${esc(l.regiao || l.pais || "")}${l.nivel ? " · " + esc(l.nivel) : ""}</div>
    <div>🧳 Viagem: <b>${cr(l.preco_viagem)}</b> · 📅 Diária: <b>${cr(l.diaria)}</b></div>
    <div>🐟 ${l.peixes.length} peixe(s)</div>
    <a href="index.html#loc-${esc(l.id)}">Ver peixes →</a>
  </div>`;
}

function renderCountries(locais) {
  const el = document.getElementById("countries");
  if (!el) return;
  const byPais = {};
  for (const l of locais) (byPais[l.pais || "Outros"] ??= []).push(l);
  el.innerHTML = Object.entries(byPais).sort((a, b) => a[0].localeCompare(b[0], "pt-BR")).map(([pais, ls]) => `
    <div class="country">
      <h3>${flag(pais)} ${esc(pais)} <span class="muted small">${ls.length} ponto(s)</span></h3>
      <div class="table-scroll"><table>
        <thead><tr><th>Ponto</th><th>Nível</th><th class="num">Viagem</th><th class="num">Diária</th><th class="num">Peixes</th></tr></thead>
        <tbody>${ls.map((l) => `
          <tr>
            <td><a href="index.html#loc-${esc(l.id)}">${esc(l.nome)}</a><div class="muted small">${esc(l.regiao || "")}</div></td>
            <td>${esc(l.nivel || "—")}</td>
            <td class="num">${cr(l.preco_viagem)}</td>
            <td class="num">${cr(l.diaria)}</td>
            <td class="num">${l.peixes.length}</td>
          </tr>`).join("")}</tbody>
      </table></div>
    </div>`).join("");
}

if (typeof document !== "undefined") main();
