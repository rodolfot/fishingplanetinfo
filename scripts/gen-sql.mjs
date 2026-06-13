// =============================================================================
//  Gerador de SQL a partir de seed.js (fonte única da verdade).
//  Uso:  node scripts/gen-sql.mjs
//  Gera:  supabase/seed.sql        (todas as águas — projeto novo/vazio)
//         supabase/seed-extra.sql  (só as águas que NÃO existem no projeto
//                                   reaproveitado do fishingplanetvalores)
// =============================================================================
import { writeFileSync, readFileSync } from "node:fs";
import { SEED } from "../seed.js";

// águas que já existem no projeto Supabase reaproveitado (não duplicar)
const JA_EXISTEM = new Set(["Rio Mudwater", "Pesqueiro Lesni Vila"]);

const q = (s) => (s == null || s === "" ? "null" : `'${String(s).replace(/'/g, "''")}'`);
const numeric = (n) => (n == null ? "null::numeric" : String(n));
const inteiro = (n) => (n == null ? "null::int" : String(n));
const numlit = (n) => (n == null ? "null" : String(n));

const COLS = "nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs";

function locaisInsert(locais) {
  return (
    "insert into public.locais_pesca (nome, regiao, nivel, guia, pais, lat, lng, preco_viagem, diaria) values\n" +
    locais.map((l) =>
      `  (${q(l.nome)}, ${q(l.regiao)}, ${q(l.nivel)}, ${q(l.guia)}, ${q(l.pais)}, ` +
      `${numlit(l.lat)}, ${numlit(l.lng)}, ${numlit(l.preco_viagem)}, ${numlit(l.diaria)})`
    ).join(",\n") +
    ";"
  );
}

function peixesBlock(loc) {
  if (!loc.peixes.length) return `-- (${loc.nome}: sem peixes)`;
  const rows = loc.peixes
    .map((f) =>
      `  (${q(f.nome)},${q(f.nome_cientifico)},${q(f.raridade)},${q(f.periodo)},` +
      `${numeric(f.valor_kg)},${inteiro(f.xp_kg)},${q(f.isca)},${q(f.tipo_vara)},` +
      `${q(f.horario_inicio)},${q(f.horario_fim)},${q(f.profundidade)},${q(f.obs)})`
    )
    .join(",\n");
  return (
    `-- ${loc.nome}\n` +
    `with l as (select id from public.locais_pesca where nome = ${q(loc.nome)})\n` +
    `insert into public.peixes (local_id, ${COLS})\n` +
    `select l.id, v.* from l cross join (values\n${rows}\n) as v(${COLS});`
  );
}

function gerar(locais, titulo) {
  return (
    `-- =============================================================================\n` +
    `--  ${titulo}\n` +
    `--  ARQUIVO GERADO por scripts/gen-sql.mjs a partir de seed.js — NÃO edite à mão.\n` +
    `--  Rode DEPOIS do schema.sql.\n` +
    `-- =============================================================================\n\n` +
    locaisInsert(locais) +
    "\n\n" +
    locais.map(peixesBlock).join("\n\n") +
    "\n"
  );
}

const full = gerar(SEED, "Fishing Planet Info — dados de exemplo (todas as águas)");
const extra = gerar(
  SEED.filter((l) => !JA_EXISTEM.has(l.nome)),
  "Fishing Planet Info — seed EXTRA (só águas novas, sem duplicar as existentes)"
);

writeFileSync(new URL("../supabase/seed.sql", import.meta.url), full);
writeFileSync(new URL("../supabase/seed-extra.sql", import.meta.url), extra);

// Arquivo "tudo em um": schema (cria colunas) + WIPE + seed completo.
// Cole UMA vez no SQL Editor do Supabase para zerar e recarregar as 9 águas.
const schema = readFileSync(new URL("../supabase/schema.sql", import.meta.url), "utf8");
const aplicarTudo =
  schema +
  "\n\n-- =============================================================================\n" +
  "--  SUBSTITUIR TUDO: apaga os pontos/peixes atuais e recarrega o seed completo.\n" +
  "--  (ARQUIVO GERADO por scripts/gen-sql.mjs — rode no SQL Editor do Supabase.)\n" +
  "-- =============================================================================\n" +
  "delete from public.peixes;\n" +
  "delete from public.locais_pesca;\n\n" +
  locaisInsert(SEED) + "\n\n" +
  SEED.map(peixesBlock).join("\n\n") + "\n";
writeFileSync(new URL("../supabase/aplicar-tudo.sql", import.meta.url), aplicarTudo);

const nFish = SEED.reduce((a, l) => a + l.peixes.length, 0);
console.log(`OK: ${SEED.length} águas / ${nFish} peixes -> supabase/seed.sql, seed-extra.sql e aplicar-tudo.sql`);
