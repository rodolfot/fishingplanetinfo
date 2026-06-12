// =============================================================================
//  Fishing Planet Info — app principal (vanilla ES module, sem build)
//  Camada de dados plugável:
//    • Supabase configurado  -> modo COLABORATIVO (todos compartilham os dados)
//    • Sem config            -> modo LOCAL (localStorage, só neste navegador)
// =============================================================================

import { SUPABASE_URL, SUPABASE_ANON_KEY } from "./config.js";
import { SEED } from "./seed.js";

const STORE_KEY = "fpInfo.v1";

// ---- helpers -----------------------------------------------------------------
const $ = (sel) => document.querySelector(sel);
const uid = () =>
  (crypto?.randomUUID?.() ?? "id" + Date.now() + Math.random().toString(36).slice(2, 8));

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

// ---- camada de dados ---------------------------------------------------------
class LocalStore {
  mode = "local";
  constructor() { this.locais = this.load(); }

  load() {
    try {
      const raw = localStorage.getItem(STORE_KEY);
      if (raw) return JSON.parse(raw);
    } catch (e) { /* ignora */ }
    return this.seedClone();
  }
  seedClone() {
    return SEED.map((l) => ({
      id: uid(), nome: l.nome, regiao: l.regiao ?? null, nivel: l.nivel ?? null, guia: l.guia ?? null,
      criado_em: new Date().toISOString(),
      peixes: l.peixes.map((p) => ({ id: uid(), local_id: null, ...p })),
    }));
  }
  persist() { localStorage.setItem(STORE_KEY, JSON.stringify(this.locais)); }

  async init() { return this.locais; }
  getLocais() { return this.locais; }

  async addLocal({ nome, regiao, nivel, guia }) {
    this.locais.push({ id: uid(), nome, regiao: regiao || null, nivel: nivel || null, guia: guia || null, criado_em: new Date().toISOString(), peixes: [] });
    this.persist();
  }
  async delLocal(id) {
    this.locais = this.locais.filter((l) => String(l.id) !== String(id));
    this.persist();
  }
  async addPeixe(localId, fish) {
    const loc = this.locais.find((l) => String(l.id) === String(localId));
    if (!loc) return;
    loc.peixes.push({ id: uid(), local_id: localId, criado_em: new Date().toISOString(), ...fish });
    this.persist();
  }
  async delPeixe(localId, fishId) {
    const loc = this.locais.find((l) => String(l.id) === String(localId));
    if (loc) loc.peixes = loc.peixes.filter((p) => String(p.id) !== String(fishId));
    this.persist();
  }
  async reset() {
    this.locais = this.seedClone();
    this.persist();
  }
}

class SupabaseStore {
  mode = "cloud";
  constructor(client) { this.client = client; this.locais = []; }

  static async create() {
    const { createClient } = await import("https://esm.sh/@supabase/supabase-js@2");
    return new SupabaseStore(createClient(SUPABASE_URL, SUPABASE_ANON_KEY));
  }

  async init() {
    const { data: locais, error: e1 } = await this.client.from("locais_pesca").select("*").order("id");
    if (e1) throw new Error("Erro ao ler 'locais_pesca': " + e1.message + " (rodou o schema.sql?)");
    const { data: peixes, error: e2 } = await this.client.from("peixes").select("*").order("id");
    if (e2) throw new Error("Erro ao ler 'peixes': " + e2.message + " (rodou o schema.sql?)");
    const byLocal = {};
    for (const p of peixes ?? []) (byLocal[p.local_id] ??= []).push(p);
    this.locais = (locais ?? []).map((l) => ({ ...l, peixes: byLocal[l.id] ?? [] }));
    return this.locais;
  }
  getLocais() { return this.locais; }

  async addLocal({ nome, regiao, nivel, guia }) {
    const { data, error } = await this.client
      .from("locais_pesca").insert({ nome, regiao: regiao || null, nivel: nivel || null, guia: guia || null }).select().single();
    if (error) throw new Error(error.message);
    this.locais.push({ ...data, peixes: [] });
  }
  async delLocal(id) {
    const { error } = await this.client.from("locais_pesca").delete().eq("id", id);
    if (error) throw new Error(error.message);
    this.locais = this.locais.filter((l) => String(l.id) !== String(id));
  }
  async addPeixe(localId, fish) {
    const { data, error } = await this.client
      .from("peixes").insert({ ...fish, local_id: localId }).select().single();
    if (error) throw new Error(error.message);
    this.locais.find((l) => String(l.id) === String(localId))?.peixes.push(data);
  }
  async delPeixe(localId, fishId) {
    const { error } = await this.client.from("peixes").delete().eq("id", fishId);
    if (error) throw new Error(error.message);
    const loc = this.locais.find((l) => String(l.id) === String(localId));
    if (loc) loc.peixes = loc.peixes.filter((p) => String(p.id) !== String(fishId));
  }
  async reset() { throw new Error("local-only"); }
}

// ---- estado / boot -----------------------------------------------------------
let store = null;

async function main() {
  wireHandlers();
  const wantsCloud = !!(SUPABASE_URL && SUPABASE_ANON_KEY);
  try {
    store = wantsCloud ? await SupabaseStore.create() : new LocalStore();
    await store.init();
    setMode(store.mode);
  } catch (e) {
    console.error(e);
    setMode("error", e?.message || String(e));
    store = null;
  }
  render();
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
    await guard(() => store.addPeixe(form.dataset.local, fish));
    render();
  });
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

// ---- render ------------------------------------------------------------------
function render() {
  const locais = store?.getLocais() ?? [];
  renderBest(locais);
  renderStats(locais);
  renderIndex(locais);

  const q = $("#search").value.trim().toLowerCase();
  const sorter = cmpFactory(sortState.key, sortState.dir);
  const container = $("#locais");
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
        <td class="num"><button class="del" data-action="delFish" data-local="${esc(loc.id)}" data-id="${esc(f.id)}" title="Remover">✕</button></td>
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
export { esc, fmtMoney, fmtXp, fmtTime, rarityClass, rarityRank, LocalStore,
         cmpFactory, sortValue, timeToMin, periodoBadge };
