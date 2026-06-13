// =============================================================================
//  Fishing Planet Info — app principal (vanilla ES module, sem build)
//  Camada de dados plugável:
//    • Supabase configurado  -> modo COLABORATIVO (todos compartilham os dados)
//    • Sem config            -> modo LOCAL (localStorage, só neste navegador)
// =============================================================================

import { createStore } from "./store.js";

// ---- helpers -----------------------------------------------------------------
const $ = (sel) => document.querySelector(sel);

const esc = (s) =>
  String(s ?? "").replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));

const fmtMoney = (n) =>
  n == null || n === "" ? "—" : "US$ " + Number(n).toLocaleString("pt-BR");
const fmtXp = (n) => (n == null || n === "" ? "—" : Number(n).toLocaleString("pt-BR"));
const fmtTime = (a, b) => (a && b ? `${a}–${b}` : a || b || "—");

const rarityClass = (r) => {
  const k = (r || "").toLowerCase().trim();
  if (k.startsWith("trof")) return "trofeu";
  if (k.startsWith("jov")) return "jovem";
  if (k.startsWith("com")) return "comum";
  return k.replace(/[^a-z0-9]/g, "");
};
const rarityTag = (r) =>
  r ? `<span class="tag ${rarityClass(r)}">${esc(r)}</span>` : "";

// ---- estado / boot -----------------------------------------------------------
let store = null;

async function main() {
  wireHandlers();
  try {
    store = await createStore();
    setMode(store.mode);
  } catch (e) {
    console.error(e);
    setMode("error", e?.message || String(e));
    store = null;
  }
  render();
  scrollToHash(); // pousa no ponto certo quando vier um link do mapa (#loc-...)
}

function scrollToHash() {
  const hash = window.location?.hash || "";
  if (!hash) return;
  const el = document.getElementById(hash.slice(1));
  if (el) { el.scrollIntoView({ behavior: "smooth", block: "start" }); el.classList.add("flash"); setTimeout(() => el.classList.remove("flash"), 900); }
}

function setMode(mode, message) {
  const banner = $("#modeBanner");
  const foot = $("#footMode");
  const toolbar = $(".toolbar");
  banner.hidden = false;
  banner.className = "mode-banner " + (mode === "error" ? "error" : mode);
  if (mode === "cloud") {
    banner.textContent = "☁️ Modo colaborativo — conectado ao Supabase. Suas edições são compartilhadas com todos.";
    foot.textContent = "Modo colaborativo (Supabase)";
    toolbar.hidden = true; // "restaurar exemplo" não faz sentido no banco compartilhado
  } else if (mode === "error") {
    banner.textContent = "⚠️ Supabase configurado mas inacessível: " + message;
    foot.textContent = "Erro de conexão";
    toolbar.hidden = true;
  } else {
    banner.textContent = "🗄️ Modo local — os dados ficam só neste navegador. Para colaborar (todos veem o mesmo), configure o Supabase em config.js.";
    foot.textContent = "Modo local (localStorage)";
    toolbar.hidden = false;
  }
}

// ---- handlers estáticos ------------------------------------------------------
function wireHandlers() {
  $("#addLocalForm").addEventListener("submit", async (e) => {
    e.preventDefault();
    if (!store) return;
    const nome = $("#localName").value.trim();
    const regiao = $("#localRegion").value.trim();
    const nivel = $("#localNivel").value.trim();
    const guia = $("#localGuia").value.trim();
    if (!nome) return;
    await guard(() => store.addLocal({ nome, regiao, nivel, guia }));
    for (const id of ["#localName", "#localRegion", "#localNivel", "#localGuia"]) $(id).value = "";
    render();
  });

  $("#search").addEventListener("input", render);
  $("#sort").addEventListener("change", (e) => {
    const [key, dir] = e.target.value.split(":");
    if (key) sortState = { key, dir: dir || "asc" };
    render();
  });

  $("#viewToggle").addEventListener("click", (e) => {
    const b = e.target.closest("button[data-view]");
    if (!b) return;
    viewMode = b.dataset.view;
    for (const btn of $("#viewToggle").querySelectorAll("button")) btn.classList.toggle("active", btn === b);
    render();
  });

  $("#localIndex").addEventListener("click", (e) => {
    const chip = e.target.closest("[data-goto]");
    if (!chip) return;
    const target = document.getElementById(chip.dataset.goto);
    if (target) {
      target.scrollIntoView({ behavior: "smooth", block: "start" });
      target.classList.add("flash");
      setTimeout(() => target.classList.remove("flash"), 900);
    }
  });

  $("#resetBtn").addEventListener("click", async () => {
    if (!store || store.mode !== "local") return;
    if (!confirm("Restaurar os dados de exemplo? Isso apaga suas alterações locais.")) return;
    await store.reset();
    render();
  });

  // delegação para botões e formulários gerados dinamicamente
  const locais = $("#locais");
  locais.addEventListener("click", async (e) => {
    // cancelar edição em andamento -> re-renderiza limpando o formulário
    if (e.target.closest('[data-role="cancelEdit"]')) { render(); return; }
    // ordenar ao clicar no cabeçalho da coluna
    const th = e.target.closest("th[data-sort-key]");
    if (th) { setSort(th.dataset.sortKey); render(); return; }
    const btn = e.target.closest("[data-action]");
    if (!btn || !store) return;
    const { action, local, id } = btn.dataset;
    if (action === "delLocal") {
      if (!confirm("Remover este ponto de pesca e todos os peixes dele?")) return;
      await guard(() => store.delLocal(local));
      render();
    } else if (action === "delFish") {
      await guard(() => store.delPeixe(local, id));
      render();
    } else if (action === "editFish") {
      const loc = store.getLocais().find((l) => String(l.id) === String(local));
      const fish = loc?.peixes.find((p) => String(p.id) === String(id));
      const form = btn.closest(".spot")?.querySelector('form[data-role="addFish"]');
      if (fish && form) startEditFish(form, fish);
    }
  });
  locais.addEventListener("submit", async (e) => {
    const form = e.target.closest('form[data-role="addFish"]');
    if (!form || !store) return;
    e.preventDefault();
    const fish = readFishForm(form);
    if (!fish.nome) return;
    const submitBtn = form.querySelector("button[type=submit]");
    if (submitBtn) submitBtn.disabled = true;
    const editId = form.dataset.editId;
    if (editId) await guard(() => store.updatePeixe(form.dataset.local, editId, fish));
    else await guard(() => store.addPeixe(form.dataset.local, fish));
    render();
  });
}

// pré-preenche o formulário do ponto com os dados do peixe para edição in-place
function startEditFish(form, fish) {
  form.dataset.editId = String(fish.id);
  const set = (n, v) => { if (form.elements[n]) form.elements[n].value = v ?? ""; };
  set("nome", fish.nome); set("nome_cientifico", fish.nome_cientifico);
  set("raridade", fish.raridade || "comum"); set("periodo", fish.periodo || "");
  set("valor_kg", fish.valor_kg); set("xp_kg", fish.xp_kg);
  set("isca", fish.isca); set("tipo_vara", fish.tipo_vara);
  set("horario_inicio", fish.horario_inicio); set("horario_fim", fish.horario_fim);
  set("profundidade", fish.profundidade); set("obs", fish.obs);
  form.classList.add("editing");
  const submitBtn = form.querySelector("button[type=submit]");
  if (submitBtn) submitBtn.textContent = "Salvar alterações";
  const cancel = form.querySelector('[data-role="cancelEdit"]');
  if (cancel) cancel.hidden = false;
  form.scrollIntoView({ behavior: "smooth", block: "center" });
  form.elements["nome"]?.focus();
}

async function guard(fn) {
  try { await fn(); }
  catch (e) { console.error(e); alert("Falhou: " + (e?.message || e)); }
}

function readFishForm(form) {
  const g = (name) => (form.elements[name]?.value ?? "").trim();
  const numOrNull = (v) => { const n = parseFloat(v); return Number.isFinite(n) ? n : null; };
  const intOrNull = (v) => { const n = parseInt(v, 10); return Number.isFinite(n) ? n : null; };
  return {
    nome: g("nome"),
    nome_cientifico: g("nome_cientifico") || null,
    raridade: g("raridade") || "comum",
    periodo: g("periodo") || null,
    valor_kg: numOrNull(g("valor_kg")),
    xp_kg: intOrNull(g("xp_kg")),
    isca: g("isca") || null,
    tipo_vara: g("tipo_vara") || null,
    horario_inicio: g("horario_inicio") || null,
    horario_fim: g("horario_fim") || null,
    profundidade: g("profundidade") || null,
    obs: g("obs") || null,
  };
}

// ---- ordenação ---------------------------------------------------------------
const rarityRank = (r) => ({ trofeu: 0, comum: 1, jovem: 2 }[rarityClass(r)] ?? 3);
const collator = new Intl.Collator("pt-BR", { numeric: true, sensitivity: "base" });

// colunas da tabela (key = chave de ordenação; null = coluna não ordenável)
const COLUMNS = [
  { key: null,        label: "#",        cls: "rank" },
  { key: "name",      label: "Peixe" },
  { key: "valor_kg",  label: "US$/kg",   cls: "num" },
  { key: "xp_kg",     label: "XP/kg",    cls: "num" },
  { key: "periodo",   label: "Período" },
  { key: "isca",      label: "Isca" },
  { key: "tipo_vara", label: "Vara" },
  { key: "horario",   label: "Horário" },
  { key: null,        label: "" },
];

let sortState = { key: "valor_kg", dir: "desc" };
let viewMode = "locais"; // "locais" (por ponto) | "peixes" (enciclopédia por espécie)
const DEFAULT_DIR = { valor_kg: "desc", xp_kg: "desc", raridade: "asc" }; // resto: asc

const timeToMin = (t) => {
  const m = /^(\d{1,2}):(\d{2})$/.exec(t || "");
  return m ? +m[1] * 60 + +m[2] : null;
};
function sortValue(f, key) {
  switch (key) {
    case "name":      return f.nome || "";
    case "raridade":  return rarityRank(f.raridade);
    case "valor_kg":  return f.valor_kg;
    case "xp_kg":     return f.xp_kg;
    case "periodo":   return f.periodo || "";
    case "isca":      return f.isca || "";
    case "tipo_vara": return f.tipo_vara || "";
    case "horario":   return timeToMin(f.horario_inicio);
    default:          return f[key];
  }
}
const isEmpty = (v) => v == null || v === "";
function cmpFactory(key, dir) {
  const mul = dir === "asc" ? 1 : -1;
  return (a, b) => {
    const va = sortValue(a, key), vb = sortValue(b, key);
    const ea = isEmpty(va), eb = isEmpty(vb);
    if (ea && eb) return 0;
    if (ea) return 1;   // vazios sempre por último, independente da direção
    if (eb) return -1;
    const r = typeof va === "number" && typeof vb === "number"
      ? va - vb : collator.compare(String(va), String(vb));
    return r * mul;
  };
}
function setSort(key) {
  if (!key) return;
  if (sortState.key === key) sortState.dir = sortState.dir === "asc" ? "desc" : "asc";
  else sortState = { key, dir: DEFAULT_DIR[key] || "asc" };
  syncSortSelect();
}
function syncSortSelect() {
  const sel = document.getElementById("sort");
  if (!sel) return;
  const v = `${sortState.key}:${sortState.dir}`;
  sel.value = [...sel.options].some((o) => o.value === v) ? v : "";
}
function thead() {
  return "<tr>" + COLUMNS.map((c) => {
    if (!c.key) return `<th class="${c.cls || ""}">${c.label}</th>`;
    const active = sortState.key === c.key;
    const arrow = active ? (sortState.dir === "asc" ? " ▲" : " ▼") : "";
    const cls = `${c.cls ? c.cls + " " : ""}sortable${active ? " active" : ""}`;
    return `<th class="${cls}" data-sort-key="${c.key}" title="Ordenar por ${c.label}">${c.label}${arrow}</th>`;
  }).join("") + "</tr>";
}
function periodoBadge(p) {
  const k = (p || "").toLowerCase();
  if (k.startsWith("diur"))  return '<span class="per per-dia" title="Diurno">☀️ dia</span>';
  if (k.startsWith("notur")) return '<span class="per per-noite" title="Noturno">🌙 noite</span>';
  if (k.startsWith("amb"))   return '<span class="per per-ambos" title="Dia e noite">🌓 ambos</span>';
  return p ? esc(p) : "—";
}

// ---- enciclopédia (agrega por espécie em todas as águas) ---------------------
function aggregateSpecies(locais) {
  const map = new Map();
  for (const loc of locais)
    for (const f of loc.peixes) {
      const key = (f.nome || "").toLowerCase().trim();
      if (!key) continue;
      let e = map.get(key);
      if (!e) { e = { nome: f.nome, sci: "", locais: new Set(), periodos: new Set(), iscas: new Set(), raridades: new Set(), best: null }; map.set(key, e); }
      if (!e.sci && f.nome_cientifico) e.sci = f.nome_cientifico;
      e.locais.add(loc.nome);
      if (f.periodo) e.periodos.add(f.periodo);
      if (f.isca) e.iscas.add(f.isca);
      if (f.raridade) e.raridades.add(f.raridade);
      if (f.valor_kg != null && (e.best == null || Number(f.valor_kg) > e.best)) e.best = Number(f.valor_kg);
    }
  return [...map.values()];
}

function speciesCard(s) {
  const locs = [...s.locais];
  const periodos = [...s.periodos].sort().map(periodoBadge).join(" ") || "—";
  const rar = [...s.raridades].map(rarityTag).join("");
  const iscas = [...s.iscas].slice(0, 6).map(esc).join(" · ");
  return `<div class="species">
    <div class="species-head">
      <span class="species-name">${esc(s.nome)}</span>${rar}
      ${s.sci ? `<span class="species-sci">${esc(s.sci)}</span>` : ""}
    </div>
    <div class="species-meta">Aparece em <b>${locs.length}</b> ponto(s) · melhor
      <span class="price">${fmtMoney(s.best)}</span>/kg · ${periodos}</div>
    <div class="species-locais">📍 ${locs.map(esc).join(", ")}</div>
    ${iscas ? `<div class="species-iscas">🪱 ${iscas}</div>` : ""}
  </div>`;
}

function renderEncyclopedia(container, locais, q) {
  let species = aggregateSpecies(locais);
  if (q) species = species.filter((s) =>
    [s.nome, s.sci, ...s.iscas].some((x) => (x || "").toLowerCase().includes(q)) ||
    [...s.periodos].some((p) => p.toLowerCase().includes(q)) ||
    [...s.locais].some((l) => l.toLowerCase().includes(q)));
  const v = (x) => (x == null ? -Infinity : x);
  const byValue = sortState.key === "valor_kg" || sortState.key === "xp_kg";
  species.sort((a, b) => byValue ? (v(b.best) - v(a.best)) || collator.compare(a.nome, b.nome) : collator.compare(a.nome, b.nome));
  container.innerHTML = species.length
    ? `<div class="species-grid">${species.map(speciesCard).join("")}</div>`
    : `<div class="empty">Nada encontrado para "${esc(q)}".</div>`;
}

// ---- render ------------------------------------------------------------------
function render() {
  const locais = store?.getLocais() ?? [];
  renderBest(locais);
  renderStats(locais);

  const q = $("#search").value.trim().toLowerCase();
  const container = $("#locais");
  // controles que só fazem sentido no modo "por ponto"
  const porPonto = viewMode === "locais";
  $("#localIndex").hidden = !porPonto;
  const hint = document.getElementById("sortHint");
  if (hint) hint.style.visibility = porPonto ? "visible" : "hidden";

  if (porPonto) renderIndex(locais);
  else { renderEncyclopedia(container, locais, q); return; }

  const sorter = cmpFactory(sortState.key, sortState.dir);
  container.innerHTML = "";
  const matchFish = (f) =>
    [f.nome, f.nome_cientifico, f.isca, f.tipo_vara, f.periodo].some((x) => (x || "").toLowerCase().includes(q));

  let shown = 0;
  for (const loc of locais) {
    const matchLocal = (loc.nome + " " + (loc.regiao || "")).toLowerCase().includes(q);
    let fishes = q && !matchLocal ? loc.peixes.filter(matchFish) : loc.peixes;
    if (q && !matchLocal && fishes.length === 0) continue;
    fishes = [...fishes].sort(sorter);
    container.appendChild(renderSpot(loc, fishes));
    shown++;
  }

  if (!locais.length) {
    container.innerHTML = `<div class="empty">Nenhum ponto de pesca ainda. Adicione um acima. 🎣</div>`;
  } else if (!shown) {
    container.innerHTML = `<div class="empty">Nada encontrado para "${esc(q)}".</div>`;
  }
}

function renderStats(locais) {
  const el = document.getElementById("stats");
  if (!el) return;
  const peixes = locais.flatMap((l) => l.peixes);
  const especies = new Set(peixes.map((f) => (f.nome || "").toLowerCase().trim()).filter(Boolean));
  const comValor = peixes.filter((f) => f.valor_kg != null).length;
  const trofeus = peixes.filter((f) => rarityClass(f.raridade) === "trofeu").length;
  const stat = (n, label) => `<span class="stat"><b>${n}</b> ${label}</span>`;
  el.innerHTML =
    stat(locais.length, "pontos") +
    stat(peixes.length, "peixes") +
    stat(especies.size, "espécies") +
    stat(trofeus, "troféus") +
    stat(comValor, "com US$/kg");
}

function renderIndex(locais) {
  const el = document.getElementById("localIndex");
  if (!el) return;
  el.innerHTML = locais.length
    ? locais.map((l) => `<button class="chip" data-goto="loc-${esc(l.id)}">${esc(l.nome)} <span class="chip-n">${l.peixes.length}</span></button>`).join("")
    : "";
}

function renderBest(locais) {
  let best = null;
  for (const loc of locais)
    for (const f of loc.peixes)
      if (f.valor_kg != null && (!best || Number(f.valor_kg) > Number(best.f.valor_kg))) best = { f, loc };
  $("#best").innerHTML = best
    ? `<div class="label">💰 Compensa mais</div>
       <div class="name">${esc(best.f.nome)}${rarityTag(best.f.raridade)}</div>
       <div>Vale <span class="price">${fmtMoney(best.f.valor_kg)}</span> por kg
         <span class="where">— ${esc(best.loc.nome)}</span></div>`
    : `<div class="label">💰 Compensa mais</div>
       <div class="where">Adicione peixes com valor (US$/kg) para ver o ranking.</div>`;
}

function renderSpot(loc, fishes) {
  const el = document.createElement("div");
  el.className = "spot";
  el.id = "loc-" + loc.id;
  const region = loc.regiao ? ` · <span class="region">${esc(loc.regiao)}</span>` : "";
  const nivel = loc.nivel ? ` · <span class="nivel">${esc(loc.nivel)}</span>` : "";
  const guia = loc.guia ? `<div class="spot-guia">📖 ${esc(loc.guia)}</div>` : "";
  const rows = fishes.length
    ? fishes.map((f, i) => `
      <tr>
        <td class="rank num">${i + 1}</td>
        <td>
          <div class="fish-name">${esc(f.nome)}${rarityTag(f.raridade)}</div>
          ${f.nome_cientifico ? `<div class="fish-sub">${esc(f.nome_cientifico)}</div>` : ""}
          ${f.profundidade ? `<div class="fish-obs">📍 ${esc(f.profundidade)}</div>` : ""}
          ${f.obs ? `<div class="fish-obs">${esc(f.obs)}</div>` : ""}
        </td>
        <td class="num price-cell">${fmtMoney(f.valor_kg)}</td>
        <td class="num xp-cell">${fmtXp(f.xp_kg)}</td>
        <td class="per-cell">${periodoBadge(f.periodo)}</td>
        <td class="cell-isca">${esc(f.isca) || "—"}</td>
        <td class="cell-vara">${esc(f.tipo_vara) || "—"}</td>
        <td class="time">${fmtTime(f.horario_inicio, f.horario_fim)}</td>
        <td class="num acoes">
          <button class="edit" data-action="editFish" data-local="${esc(loc.id)}" data-id="${esc(f.id)}" title="Editar">✎</button>
          <button class="del" data-action="delFish" data-local="${esc(loc.id)}" data-id="${esc(f.id)}" title="Remover">✕</button>
        </td>
      </tr>`).join("")
    : `<tr><td colspan="${COLUMNS.length}" class="empty">Nenhum peixe cadastrado ainda.</td></tr>`;

  el.innerHTML = `
    <div class="spot-head">
      <div>
        <h2>🌊 ${esc(loc.nome)}</h2>
        <span class="meta">${loc.peixes.length} peixe(s)${region}${nivel}</span>
      </div>
      <button class="btn ghost small" data-action="delLocal" data-local="${esc(loc.id)}">Remover ponto</button>
    </div>
    ${guia}
    <div class="table-scroll">
      <table>
        <thead>${thead()}</thead>
        <tbody>${rows}</tbody>
      </table>
    </div>`;

  // formulário de adicionar peixe (clonado do <template>)
  const form = $("#addFishTpl").content.firstElementChild.cloneNode(true);
  form.dataset.local = String(loc.id);
  el.appendChild(form);
  return el;
}

// Só executa no navegador (permite importar este módulo em testes Node).
if (typeof document !== "undefined") main();

// Exportado para testes (ignorado pelo navegador).
export { esc, fmtMoney, fmtXp, fmtTime, rarityClass, rarityRank,
         cmpFactory, sortValue, timeToMin, periodoBadge, aggregateSpecies };
