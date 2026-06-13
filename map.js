// =============================================================================
//  Mapa-múndi de pontos de pesca + viagem/diária/licenças.
//  Reaproveita a mesma camada de dados (store.js). Usa Leaflet (global L).
//  O popup de cada pin é um "detonado": melhores peixes + isca/vara/horário.
// =============================================================================
import { createStore } from "./store.js";

const esc = (s) => String(s ?? "").replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));
const cr = (n) => (n == null || n === "" ? "—" : Number(n).toLocaleString("pt-BR") + " cr");
const money = (n) => (n == null || n === "" ? null : Number(n).toLocaleString("pt-BR") + " cr/kg");
const aprx = (f) => (f.aprox ? "~" : ""); // estimativa da comunidade
const fmtTime = (a, b) => (a && b ? `${a}–${b}` : a || b || "");
const FLAG = { "EUA": "🇺🇸", "República Tcheca": "🇨🇿", "Rússia": "🇷🇺", "Canadá": "🇨🇦", "Noruega": "🇳🇴" };
const flag = (p) => FLAG[p] || "🌍";

// Período do peixe -> badge curto (mesma convenção da página de peixes).
function periodoBadge(p) {
  const k = (p || "").toLowerCase();
  if (k.startsWith("diur")) return '<span class="per per-dia" title="Diurno">☀️</span>';
  if (k.startsWith("notur")) return '<span class="per per-noite" title="Noturno">🌙</span>';
  if (k.startsWith("amb")) return '<span class="per per-ambos" title="Dia e noite">🌓</span>';
  return p ? esc(p) : "";
}

// Link para a fonte (Fishing Planet Wiki). Usa a busca do fandom, que não quebra
// mesmo se o título exato da página mudar. nome_en quando houver, senão nome.
function wikiUrl(l) {
  const q = encodeURIComponent(l.nome_en || l.nome);
  return `https://fishingplanet.fandom.com/wiki/Special:Search?query=${q}`;
}

// Ordena os peixes do ponto pra destacar os melhores: maior US$/kg primeiro
// (sem valor por último), e dentro disso troféu na frente.
const rarRank = (r) => (String(r || "").toLowerCase().startsWith("trof") ? 0 : 1);
function topFish(peixes, n = 4) {
  return [...peixes].sort((a, b) => {
    const va = a.valor_kg == null ? -Infinity : Number(a.valor_kg);
    const vb = b.valor_kg == null ? -Infinity : Number(b.valor_kg);
    if (vb !== va) return vb - va;
    if (rarRank(a.raridade) !== rarRank(b.raridade)) return rarRank(a.raridade) - rarRank(b.raridade);
    return String(a.nome).localeCompare(String(b.nome), "pt-BR");
  }).slice(0, n);
}

async function main() {
  let store;
  try { store = await createStore(); setBanner(store.mode); }
  catch (e) { setBanner("error", e?.message || String(e)); return; }
  const locais = store.getLocais();
  initMap(locais);
  renderCountries(locais);
}

function setBanner(mode, msg) {
  const p = document.getElementById("modePill");
  if (!p) return;
  p.className = "mode-pill " + (mode === "error" ? "error" : mode);
  p.textContent = mode === "cloud" ? "☁️ Colaborativo" : mode === "error" ? "⚠️ Sem conexão" : "🗄️ Local";
  p.title = mode === "cloud"
    ? "Conectado ao Supabase — dados compartilhados."
    : mode === "error"
      ? "Supabase inacessível: " + msg + " — adicione ?local na URL para a demo offline."
      : "Modo local (demo). Viagem/diária/licenças são valores aproximados da comunidade.";
}

function initMap(locais) {
  const withGeo = locais.filter((l) => l.lat != null && l.lng != null);
  const map = L.map("map", { scrollWheelZoom: false }).setView([35, -40], 2);
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: "© OpenStreetMap", maxZoom: 12,
  }).addTo(map);
  const pts = [];
  for (const l of withGeo) {
    L.marker([l.lat, l.lng]).addTo(map).bindPopup(popupHtml(l), { maxWidth: 320, minWidth: 260 });
    pts.push([l.lat, l.lng]);
  }
  if (pts.length) map.fitBounds(pts, { padding: [40, 40], maxZoom: 5 });
}

// Popup "detonado": cabeçalho + viagem/diária + melhores peixes (isca/vara/horário) + fonte.
function popupHtml(l) {
  const top = topFish(l.peixes);
  const fishRows = top.map((f) => {
    const val = money(f.valor_kg);
    const hora = fmtTime(f.horario_inicio, f.horario_fim);
    const meta = [
      f.isca ? `🪱 ${esc(f.isca)}` : "",
      f.tipo_vara ? `🎣 ${esc(f.tipo_vara)}` : "",
      hora ? `🕑 ${esc(hora)}` : "",
    ].filter(Boolean).join("<br>");
    return `<div class="pop-fish">
      <div class="pop-fish-top">
        <b>${esc(f.nome)}</b> ${periodoBadge(f.periodo)}
        ${val ? `<span class="pop-val">${aprx(f)}${val}</span>` : ""}
      </div>
      ${meta ? `<div class="pop-fish-meta">${meta}</div>` : ""}
    </div>`;
  }).join("");

  const guia = l.guia ? `<div class="pop-guia">📖 ${esc(l.guia)}</div>` : "";
  const licParts = [];
  if (l.preco_viagem != null) licParts.push(`🧳 Viagem <b>${cr(l.preco_viagem)}</b>`);
  if (l.diaria != null) licParts.push(`📅 1 dia <b>${cr(l.diaria)}</b>`);
  if (l.lic_3dias != null) licParts.push(`3 dias <b>${cr(l.lic_3dias)}</b>`);
  if (l.lic_7dias != null) licParts.push(`7 dias <b>${cr(l.lic_7dias)}</b>`);
  if (l.lic_ilimitada != null) licParts.push(`♾️ <b>${Number(l.lic_ilimitada).toLocaleString("pt-BR")} baitcoin</b>`);
  const lic = licParts.length ? `<div class="pop-lic">${licParts.join(" · ")}</div>` : "";

  return `<div class="map-pop">
    <div class="pop-head">
      <b>${flag(l.pais)} ${esc(l.nome)}</b>
      <div class="muted small">${esc(l.regiao || l.pais || "")}${l.nivel ? " · " + esc(l.nivel) : ""}</div>
      ${l.estimado ? '<div class="pop-estimado">⚠️ Espécies estimadas pela região — não confirmadas no jogo.</div>' : ""}
    </div>
    ${lic}
    ${guia}
    <div class="pop-fish-title">🐟 Melhores capturas (${l.peixes.length} no total)</div>
    ${fishRows || '<div class="muted small">Sem peixes cadastrados.</div>'}
    <div class="pop-links">
      <a href="index.html#loc-${esc(l.id)}">Ver todos →</a>
      <a href="${wikiUrl(l)}" target="_blank" rel="noopener">🔗 Fishing Planet Wiki</a>
    </div>
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
        <thead><tr><th>Ponto</th><th>Nível</th><th class="num">Viagem</th><th class="num">Diária</th><th>Melhor captura (isca)</th><th class="num">Peixes</th></tr></thead>
        <tbody>${ls.map((l) => {
          const best = topFish(l.peixes, 1)[0];
          const bestTxt = best
            ? `${esc(best.nome)}${best.valor_kg != null ? ` <span class="muted small">${aprx(best)}${money(best.valor_kg)}</span>` : ""}${best.isca ? `<div class="muted small">🪱 ${esc(best.isca)}</div>` : ""}`
            : "—";
          return `
          <tr>
            <td><a href="index.html#loc-${esc(l.id)}">${esc(l.nome)}</a>${l.estimado ? ' <span class="badge-est" title="Espécies estimadas pela região, não confirmadas">est.</span>' : ""}<div class="muted small">${esc(l.regiao || "")} · <a href="${wikiUrl(l)}" target="_blank" rel="noopener">fonte</a></div></td>
            <td>${esc(l.nivel || "—")}</td>
            <td class="num">${cr(l.preco_viagem)}</td>
            <td class="num">${cr(l.diaria)}</td>
            <td>${bestTxt}</td>
            <td class="num">${l.peixes.length}</td>
          </tr>`;
        }).join("")}</tbody>
      </table></div>
    </div>`).join("");
}

if (typeof document !== "undefined") main();
