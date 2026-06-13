// =============================================================================
//  Adiciona águas extras ao seed.js (decisão do usuário: "máximo volume").
//  ⚠️ Estas águas e suas listas de peixes são as ESPÉCIES TÍPICAS da região/
//  clima — NÃO confirmadas peixe a peixe no jogo. Cada água recebe
//  `estimado: true` (a UI mostra um aviso) e os valores entram via
//  scripts/fill-values.mjs (todos com aprox:true / "~").
//  Isca/vara/horário/período são derivados por categoria da espécie.
//  Idempotente: se a água já existe no seed, não duplica.
// =============================================================================
import { readFileSync, writeFileSync } from "node:fs";

const FILE = new URL("../seed.js", import.meta.url);

// Defaults de pesca por categoria da espécie (heurística pelo nome em inglês).
function tackle(nome) {
  const n = nome.toLowerCase();
  if (/(sturgeon|beluga)/.test(n))
    return { periodo: "ambos", isca: "Isca cortada grande no fundo", vara: "Bottom pesadíssimo", hi: "18:00", hf: "06:00", prof: "Fundo" };
  if (/(catfish|bullhead|wels|burbot)/.test(n))
    return { periodo: "noturno", isca: "Isca cortada / minhocão no fundo", vara: "Bottom/feeder", hi: "21:00", hf: "03:00", prof: "Fundo" };
  if (/(salmon|halibut|cod|saithe|coalfish|haddock|pollock|wolffish|ling|tusk|mackerel|drum|seatrout|flounder|sheepshead|croaker|tarpon|snook|redfish)/.test(n))
    return { periodo: "ambos", isca: "Isca-viva, jigs pesados, peixe cortado", vara: "Boat / casting pesado", hi: "06:00", hf: "18:00", prof: "Fundo / coluna d'água" };
  if (/(trout|char|grayling|whitefish|cisco)/.test(n))
    return { periodo: "ambos", isca: "Spinners, colheres, fly, iscas pequenas", vara: "Spinning leve / fly", hi: "05:00", hf: "09:00", prof: "Meia-água" };
  if (/(bass)/.test(n))
    return { periodo: "ambos", isca: "Iscas artificiais (soft plastic, crankbait, spinnerbait)", vara: "Casting médio", hi: "05:00", hf: "08:00", prof: "Vegetação e estruturas" };
  if (/(pike|musk|zander|walleye|asp|ide)/.test(n))
    return { periodo: "ambos", isca: "Jigs, shads, colheres", vara: "Spinning médio (leader de aço p/ esócideos)", hi: "05:00", hf: "08:00", prof: "Estruturas / vegetação" };
  if (/(perch|crappie|sunfish|bluegill|ruffe)/.test(n))
    return { periodo: "diurno", isca: "Minhocas, maggots, jigs pequenos", vara: "Vara de boia leve", hi: "08:00", hf: "16:00", prof: "Margens / meia-água" };
  if (/(carp|bream|roach|tench)/.test(n))
    return { periodo: "diurno", isca: "Massa, milho, minhocas, bloodworms", vara: "Feeder / boia", hi: "06:00", hf: "12:00", prof: "Fundo / meia-água" };
  return { periodo: "ambos", isca: "Iscas variadas conforme a espécie", vara: "Spinning médio", hi: "06:00", hf: "12:00", prof: "Variada" };
}

// Espécies marcadas como troféu (icônicas/grandes).
const TROFEU = new Set(["White Sturgeon", "Muskellunge", "Chinook Salmon", "Tarpon", "Atlantic Halibut", "Wels Catfish"]);

const AGUAS = [
  { nome: "Falcon Lake", pais: "EUA", regiao: "Oregon, EUA", lat: 43.8, lng: -121.4, nivel: "Nível ~5–20",
    guia: "Lago de Oregon com trutas e black bass.",
    sp: ["Rainbow Trout", "Cutthroat Trout", "Brown Trout", "Brook Trout", "Smallmouth Bass", "Largemouth Bass", "Black Crappie", "Bluegill", "Channel Catfish"] },
  { nome: "San Joaquin Delta", pais: "EUA", regiao: "Califórnia, EUA", lat: 38.0, lng: -121.5, nivel: "Nível ~10–25",
    guia: "Delta da Califórnia: bass, bagres e o gigante White Sturgeon.",
    sp: ["Largemouth Bass", "Smallmouth Bass", "Spotted Bass", "Striped Bass", "Channel Catfish", "White Catfish", "Bluegill", "Black Crappie", "White Sturgeon"] },
  { nome: "Saint Croix Lake", pais: "EUA", regiao: "Michigan, EUA", lat: 45.5, lng: -84.5, nivel: "Nível ~10–30",
    guia: "Lago de Michigan com walleye, pike e o troféu Muskellunge.",
    sp: ["Walleye", "Northern Pike", "Muskellunge", "Smallmouth Bass", "Largemouth Bass", "Yellow Perch", "Bluegill", "Black Crappie", "Lake Trout"] },
  { nome: "White Moose Lake", pais: "Canadá", regiao: "Alberta, Canadá", lat: 52.5, lng: -114.0, nivel: "Nível ~15–30",
    guia: "Lago canadense frio: trutas grandes, pike e whitefish.",
    sp: ["Lake Trout", "Rainbow Trout", "Brook Trout", "Northern Pike", "Walleye", "Yellow Perch", "Lake Whitefish", "Burbot", "Mountain Whitefish"] },
  { nome: "Kaniq Creek", pais: "EUA", regiao: "Alasca, EUA", lat: 60.5, lng: -151.0, nivel: "Nível ~20–35",
    guia: "Rio do Alasca na corrida dos salmões; trutas e char no meio.",
    sp: ["Chinook Salmon", "Coho Salmon", "Sockeye Salmon", "Pink Salmon", "Chum Salmon", "Rainbow Trout", "Dolly Varden", "Arctic Grayling", "Arctic Char"] },
  { nome: "Blue Crab Island", pais: "EUA", regiao: "Mississippi, EUA (Golfo)", lat: 30.3, lng: -88.9, nivel: "Nível ~20–35",
    guia: "Água salgada do Golfo do México: drum, trout e o troféu Tarpon.",
    sp: ["Red Drum", "Black Drum", "Spotted Seatrout", "Southern Flounder", "Sheepshead", "Atlantic Croaker", "Sea Catfish", "Snook", "Tarpon"] },
  { nome: "Lago Ladoga", pais: "Rússia", regiao: "Carélia, Rússia", lat: 61.0, lng: 31.5, nivel: "Nível ~20–35",
    guia: "Maior lago da Europa: pike, zander, salmão e truta marrom.",
    sp: ["Northern Pike", "Zander", "European Perch", "Common Bream", "Common Roach", "Atlantic Salmon", "Brown Trout", "Burbot", "Ruffe"] },
  { nome: "Rio Volkhov", pais: "Rússia", regiao: "Rússia", lat: 58.5, lng: 31.3, nivel: "Nível ~20–35",
    guia: "Rio russo com zander, asp e o gigante Wels Catfish.",
    sp: ["Zander", "Wels Catfish", "Asp", "Ide", "Common Bream", "Northern Pike", "European Perch", "Common Roach", "Burbot"] },
  { nome: "Mar da Noruega", pais: "Noruega", regiao: "Noruega (mar)", lat: 69.5, lng: 18.0, nivel: "Nível ~25–40",
    guia: "Pesca de barco no mar da Noruega: bacalhau, saithe e halibut troféu.",
    sp: ["Atlantic Cod", "Coalfish (Saithe)", "Haddock", "Atlantic Halibut", "Atlantic Mackerel", "Pollock", "Atlantic Wolffish", "Ling", "Tusk"] },
];

const S = (v) => JSON.stringify(v); // string JS segura

function fishLine(nome) {
  const t = tackle(nome);
  const rar = TROFEU.has(nome) ? "troféu" : "comum";
  return `      { nome: ${S(nome)}, nome_cientifico: null, raridade: ${S(rar)}, periodo: ${S(t.periodo)}, ` +
    `valor_kg: null, xp_kg: null, isca: ${S(t.isca)}, tipo_vara: ${S(t.vara)}, ` +
    `horario_inicio: ${S(t.hi)}, horario_fim: ${S(t.hf)}, profundidade: ${S(t.prof)}, obs: "Espécie típica da região — não confirmada no jogo." }`;
}

function waterBlock(a) {
  const peixes = a.sp.map(fishLine).join(",\n");
  return `  {\n` +
    `    nome: ${S(a.nome)},\n` +
    `    pais: ${S(a.pais)}, lat: ${a.lat}, lng: ${a.lng}, preco_viagem: null, diaria: null, estimado: true,\n` +
    `    regiao: ${S(a.regiao)},\n` +
    `    nivel: ${S(a.nivel)},\n` +
    `    guia: ${S(a.guia + " (Lista de espécies estimada pela região — confirme e corrija no jogo.)")},\n` +
    `    peixes: [\n${peixes},\n    ],\n` +
    `  },`;
}

let src = readFileSync(FILE, "utf8");
const novas = AGUAS.filter((a) => !src.includes(`nome: ${S(a.nome)},\n    pais:`) && !src.includes(`nome: "${a.nome}"`));
if (!novas.length) { console.log("Nada a adicionar (águas já existem)."); process.exit(0); }

const bloco = novas.map(waterBlock).join("\n");
const idx = src.lastIndexOf("\n];");
if (idx < 0) { console.error("Não achei o fechamento do SEED (\\n];)."); process.exit(1); }
src = src.slice(0, idx) + "\n" + bloco + src.slice(idx);
writeFileSync(FILE, src);
const nFish = novas.reduce((s, a) => s + a.sp.length, 0);
console.log(`OK: +${novas.length} águas / +${nFish} peixes (estimado:true). Rode fill-values.mjs e gen-sql.mjs.`);
