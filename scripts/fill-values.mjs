// =============================================================================
//  Preenche valor_kg / xp_kg dos peixes que estavam em branco no seed.js.
//  Estratégia (decisão do usuário): "mix fonte + estimativa".
//    • Valores confirmados na comunidade (Steam "Profit Database" / FP Wiki)
//      entram nos SOURCED/BASE abaixo;
//    • o restante é estimado por espécie/categoria e raridade.
//  TODO peixe preenchido aqui recebe `aprox: true` (valores aproximados da
//  comunidade). Edição é em nível de TEXTO: só substitui o token
//  `valor_kg: null, xp_kg: null,` na própria linha — preserva todo o resto.
//  Idempotente: rodar de novo não muda nada (não há mais `null` a trocar).
//  Unidade: créditos por kg (cr/kg), o "dinheiro" do Fishing Planet.
// =============================================================================
import { readFileSync, writeFileSync } from "node:fs";

const FILE = new URL("../seed.js", import.meta.url);

// cr/kg (raridade "comum") confirmados em fontes da comunidade.
const SOURCED = {
  "Rainbow Trout": 169, "Brown Trout": 150, "Cutthroat Trout": 164,
  "Smallmouth Bass": 160, "Spotted Bass": 170,
};
// cr/kg (raridade "comum") estimados por espécie dentro das faixas conhecidas.
const BASE = {
  "Brook Trout": 150, "Largemouth Bass": 150,
  "Butterfly Peacock Bass": 180, "Peacock Bass": 200,
  "Bluegill": 100, "Pumpkinseed": 95, "Redear Sunfish": 100,
  "Black Crappie": 115, "Yellow Perch": 120, "European Perch": 120,
  "Northern Pike": 150, "Grass Pickerel": 150, "Redfin Pickerel": 150,
  "Walleye": 200, "Zander": 180, "Asp": 140, "Snook": 150,
  "Channel Catfish": 45, "Flathead Catfish": 45, "Blue Catfish": 45,
  "Brown Bullhead": 45, "Wels Catfish": 50, "Bowfin": 60,
  "Alligator Gar": 70, "Florida Gar": 70, "Beluga": 60,
  "Common Carp": 90, "Common Roach": 70, "Caspian Roach": 70,
  "Silver Bream": 70, "Common Bream": 80, "Tench": 110,
  "Smallmouth Buffalo": 80, "Golden Shiner": 80, "American Shad": 120,
};
// fallback por palavra-chave no nome (cr/kg, raridade "comum").
function categoria(nome) {
  const n = nome.toLowerCase();
  if (/(catfish|bullhead|wels)/.test(n)) return 45;
  if (/(trout|salmon)/.test(n)) return 160;
  if (/(peacock)/.test(n)) return 190;
  if (/(bass)/.test(n)) return 150;
  if (/(walleye|zander|pike|pickerel|asp|snook|gar)/.test(n)) return 150;
  if (/(perch|crappie|sunfish|bluegill|pumpkinseed|bream|roach|shiner|shad|carp|tench|buffalo|bowfin|beluga)/.test(n)) return 95;
  return 100;
}
const MULT = { jovem: 0.85, "comum": 1, "troféu": 1.15, trofeu: 1.15 };
const XP = { jovem: 15, "comum": 30, "troféu": 90, trofeu: 90 };

function valores(nome, raridade) {
  const base = SOURCED[nome] ?? BASE[nome] ?? categoria(nome);
  const mult = MULT[raridade] ?? 1;
  return { valor: Math.round(base * mult), xp: XP[raridade] ?? 30 };
}

const lines = readFileSync(FILE, "utf8").split(/\r?\n/);
const TOKEN = "valor_kg: null, xp_kg: null,";
let n = 0;
const out = lines.map((line) => {
  if (!line.includes(TOKEN)) return line;
  const nome = (line.match(/nome:\s*"([^"]+)"/) || [])[1] || "";
  const raridade = (line.match(/raridade:\s*"([^"]+)"/) || [])[1] || "comum";
  const { valor, xp } = valores(nome, raridade);
  n++;
  return line.replace(TOKEN, `valor_kg: ${valor}, xp_kg: ${xp}, aprox: true,`);
});
writeFileSync(FILE, out.join("\n"));
console.log(`OK: ${n} peixes preenchidos (valor_kg/xp_kg + aprox).`);
