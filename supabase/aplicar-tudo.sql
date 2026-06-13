-- =============================================================================
--  Fishing Planet Info — Schema do Supabase
--  Rode este script no SQL Editor do seu projeto Supabase (uma vez).
--  Depois copie a Project URL e a chave anon para config.js.
--
--  Modelo compatível com o app fishingplanetvalores.netlify.app
--  (tabelas locais_pesca / peixes), acrescentando os campos novos:
--  isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs, nome_cientifico.
-- =============================================================================

create table if not exists public.locais_pesca (
  id           bigint generated always as identity primary key,
  nome         text not null,
  regiao       text,
  nivel        text,             -- nível/licença recomendada (ex: "Nível 1+")
  guia         text,             -- dicas/guia do local
  pais         text,             -- país (agrupamento no mapa)
  lat          double precision, -- latitude (mapa-múndi)
  lng          double precision, -- longitude
  preco_viagem integer,          -- custo da viagem (créditos)
  diaria       integer,          -- licença diária (créditos)
  criado_em    timestamptz not null default now()
);

create table if not exists public.peixes (
  id              bigint generated always as identity primary key,
  local_id        bigint not null references public.locais_pesca(id) on delete cascade,
  nome            text not null,
  nome_cientifico text,
  raridade        text default 'comum',
  periodo         text,           -- "diurno" | "noturno" | "ambos"
  valor_kg        numeric(10,2),
  xp_kg           integer,
  isca            text,
  tipo_vara       text,
  horario_inicio  text,           -- "HH:MM" no relógio do jogo
  horario_fim     text,           -- "HH:MM"
  profundidade    text,
  obs             text,
  criado_em       timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
--  MIGRAÇÃO (reaproveitar um projeto Supabase que JÁ existe)
--  Seguro rodar mesmo se as tabelas já tinham dados: 'add column if not exists'
--  só acrescenta o que falta, sem apagar nada. Cobre o esquema antigo do
--  fishingplanetvalores (locais_pesca: id/nome/criado_em; peixes:
--  id/local_id/nome/valor_kg/raridade/xp_kg).
-- ---------------------------------------------------------------------------
alter table public.locais_pesca add column if not exists regiao text;
alter table public.locais_pesca add column if not exists nivel  text;
alter table public.locais_pesca add column if not exists guia   text;
alter table public.locais_pesca add column if not exists pais   text;
alter table public.locais_pesca add column if not exists lat    double precision;
alter table public.locais_pesca add column if not exists lng    double precision;
alter table public.locais_pesca add column if not exists preco_viagem integer;
alter table public.locais_pesca add column if not exists diaria integer;
alter table public.locais_pesca add column if not exists criado_em timestamptz not null default now();

alter table public.peixes add column if not exists nome_cientifico text;
alter table public.peixes add column if not exists raridade        text default 'comum';
alter table public.peixes add column if not exists periodo         text;
alter table public.peixes add column if not exists valor_kg        numeric(10,2);
alter table public.peixes add column if not exists xp_kg           integer;
alter table public.peixes add column if not exists isca            text;
alter table public.peixes add column if not exists tipo_vara       text;
alter table public.peixes add column if not exists horario_inicio  text;
alter table public.peixes add column if not exists horario_fim     text;
alter table public.peixes add column if not exists profundidade    text;
alter table public.peixes add column if not exists obs             text;
alter table public.peixes add column if not exists criado_em       timestamptz not null default now();

create index if not exists peixes_local_id_idx on public.peixes (local_id);

-- ---------------------------------------------------------------------------
--  RLS — wiki comunitário PÚBLICO: qualquer pessoa (chave anon) pode ler,
--  adicionar e remover. É intencionalmente aberto, como pediram ("todos podem
--  colaborar e remover"). Se quiser exigir login depois, troque as policies
--  abaixo por regras baseadas em auth.uid().
-- ---------------------------------------------------------------------------
alter table public.locais_pesca enable row level security;
alter table public.peixes        enable row level security;

drop policy if exists locais_all on public.locais_pesca;
create policy locais_all on public.locais_pesca
  for all using (true) with check (true);

drop policy if exists peixes_all on public.peixes;
create policy peixes_all on public.peixes
  for all using (true) with check (true);


-- =============================================================================
--  SUBSTITUIR TUDO: apaga os pontos/peixes atuais e recarrega o seed completo.
--  (ARQUIVO GERADO por scripts/gen-sql.mjs — rode no SQL Editor do Supabase.)
-- =============================================================================
delete from public.peixes;
delete from public.locais_pesca;

insert into public.locais_pesca (nome, regiao, nivel, guia, pais, lat, lng, preco_viagem, diaria) values
  ('Rio Mudwater', 'Missouri, EUA', 'Nível 1+', 'Água inicial dos EUA, ótima para missões de bass e panfish. Boia leve com minhoca/maggot para os panfish; iscas artificiais com twitching rápido no amanhecer e entardecer para bass e pickerel.', 'EUA', 38.5, -92.5, 2000, 500),
  ('Pesqueiro Lesni Vila', 'República Tcheca', 'Nível 1+ (águas tchecas)', 'Pesqueiro tcheco para iniciantes. Bloodworm no anzol #10 pega quase todas as espécies. Boias deslizantes (slip bobber) ajudam muito em carpa, tenca e bagre.', 'República Tcheca', 49.8, 15.47, null, null),
  ('Emerald Lake', 'Nova York, EUA', 'Nível ~9–20', 'Lago de NY popular para subir de nível pegando Walleye (lance atrás das vitórias-régias, ~130–160 ft). Golden Shiner pega em qualquer lugar com spinners/spoons/shads. Pike perto das ervas com Shad 2" em stop-and-go (Dock of Peace).', 'EUA', 43, -75, null, 900),
  ('Lone Star Lake', 'Texas, EUA', 'Nível 1+', 'Lago do Texas com quase uma dúzia de espécies. Minhocas/stink bait pegam bem; Red Worm no anzol #6. Spotted Bass rende bom dinheiro; Channel Catfish é abundante (noite).', 'EUA', 31, -99, null, null),
  ('Quanchkin Lake', 'Louisiana, EUA', 'Nível ~10+', 'Pântano da Louisiana com predadores grandes. Alligator Gar exige leader de aço e anzol 6/0 com lagostim. Bagres (Channel/Flathead/Blue) à noite. Hotspots de Bowfin para troféu/único.', 'EUA', 30.5, -91.5, null, null),
  ('Rocky Lake', 'Colorado, EUA', 'Nível ~8–20', 'Lago de montanha no Colorado, famoso pelas trutas (Rainbow é a mais popular pra dinheiro). Trutas com fly/spinning e iscas pequenas/colheres; Brown no fundo com lagostim/minnow. Pike e Smallmouth com crankbaits perto de pedras e vegetação.', 'EUA', 39, -105.5, null, null),
  ('Neherrin River', 'Carolina do Norte, EUA', 'Nível 1+', 'Rio da Carolina do Norte com bass, panfish, carpa e shad. Iscas artificiais pra bass; minhocas/sanguessugas pros panfish; massa/milho pra carpa no fundo.', 'EUA', 35.5, -79, null, null),
  ('Everglades', 'Flórida, EUA', 'Nível ~15+ (alto XP)', 'Pântano da Flórida com espécies exóticas de alto XP. Peacock Bass exige tackle pesado na vegetação (spoons/jigs médios; iscas grandes e lentas perto da cobertura). Snook com isca-viva sob boia. Florida Gar rende muito XP no pico de alimentação.', 'EUA', 25.9, -80.9, null, null),
  ('Akhtuba River', 'Rússia', 'Nível ~20+ (avançado)', 'Rio russo com predadores grandes e esturjão. Wels Catfish e Beluga no fundo com anzol 4/0–7/0 e isca cortada grande. Zander à noite com jigs; Asp na superfície de dia.', 'Rússia', 48.7, 44.8, null, null);

-- Rio Mudwater
with l as (select id from public.locais_pesca where nome = 'Rio Mudwater')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Black Bass','Micropterus salmoides','jovem','ambos',118,16,'Iscas artificiais (spinnerbait, soft plastic, crankbait)','Spinning/Casting leve (linha 5–10 lb)','05:00','07:00','Margens e vegetação','Twitching rápido também rende ao entardecer (18:00–19:00).'),
  ('Esox Vermiculatus','Esox americanus vermiculatus','comum','ambos',161,60,'Spinners pequenos / iscas artificiais','Spinning leve','05:00','07:00','Águas rasas com vegetação','Predador agressivo; recolhimento com paradas.'),
  ('Esox Vermiculatus','Esox americanus vermiculatus','troféu','ambos',182,111,'Spinners pequenos / iscas artificiais','Spinning leve','05:00','07:00','Águas rasas com vegetação','Exemplares troféu rendem bem mais XP.'),
  ('Pomoxis Annularis','Pomoxis annularis','comum','diurno',100,54,'Minhocas / maggots / jigs pequenos','Vara de boia (OmniFloat 450, anzol #8)','06:00','10:00','Meia-água','White Crappie. Cardume — fisgue vários no mesmo ponto.'),
  ('Pomoxis Annularis','Pomoxis annularis','troféu','diurno',149,71,'Minhocas / maggots / jigs pequenos','Vara de boia (anzol #8)','06:00','10:00','Meia-água',null),
  ('Bluegill','Lepomis macrochirus','comum','diurno',null::numeric,null::int,'Minhocas, maggots','Boia leve (anzol #8–10)','08:00','17:00','Margens rasas','Panfish abundante; ótimo para missões iniciais.'),
  ('Pumpkinseed','Lepomis gibbosus','comum','diurno',null::numeric,null::int,'Minhocas, maggots','Boia leve (anzol #10)','08:00','17:00','Margens rasas',null),
  ('Bowfin','Amia calva','comum','ambos',null::numeric,null::int,'Isca cortada / minhocão no fundo','Bottom/feeder (linha 5–10 lb)','06:00','09:00','Fundo','Briga muito forte; pode passar de 2 kg.'),
  ('Channel Catfish','Ictalurus punctatus','troféu','noturno',null::numeric,null::int,'Isca cortada, fígado de galinha','Bottom/feeder reforçado','21:00','02:00','Fundo, canais','Troféu passa de 5 kg (12+ lb). Pesca noturna.')
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);

-- Pesqueiro Lesni Vila
with l as (select id from public.locais_pesca where nome = 'Pesqueiro Lesni Vila')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Common Roach','Rutilus rutilus','comum','diurno',null::numeric,null::int,'Sêmola, pão, milho (kukuruza), bloodworms, maggots','Vara de boia leve (anzol #10)','08:00','16:00','Meia-água','Pardelha.'),
  ('European Perch','Perca fluviatilis','comum','ambos',null::numeric,null::int,'Minhocas, spinners pequenos','Spinning leve / boia','06:00','09:00','Próximo a estruturas','Perca europeia. Também ativa ao entardecer (17:00–20:00).'),
  ('Northern Pike','Esox lucius','comum','ambos',null::numeric,null::int,'Iscas artificiais perto da superfície, colheres (spoons)','Spinning médio com leader de aço','05:00','08:00','Superfície / águas rasas','Lúcio. Pico no amanhecer e entardecer (18:00–20:00).'),
  ('Silver Bream','Blicca bjoerkna','comum','diurno',null::numeric,null::int,'Bloodworms, maggots','Vara de boia (anzol #10)','08:00','16:00','Fundo / meia-água','Brema-prateada.'),
  ('Tench','Tinca tinca','comum','diurno',null::numeric,null::int,'Cancer Meat, bloodworms, minhocas, dung worms, sanguessugas','Boia deslizante (slip bobber) no fundo','05:00','08:00','Fundo','Tenca. Mais ativa logo cedo.'),
  ('Common Carp','Cyprinus carpio','comum','ambos',null::numeric,null::int,'Sêmola, milho, massa (dough), queijo, minhocas','Slip bobber / feeder (linha forte)','04:00','07:00','Fundo','Carpa comum. Também ativa à noite (20:00–23:00). Massa é ótima.')
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);

-- Emerald Lake
with l as (select id from public.locais_pesca where nome = 'Emerald Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Walleye','Sander vitreus','comum','noturno',null::numeric,null::int,'Jigs, crankbaits fundos, shads','Spinning/Casting médio','21:00','04:00','Fundo, atrás das vitórias-régias (130–160 ft)','Bom alvo de XP/valor; melhor com pouca luz.'),
  ('Northern Pike','Esox lucius','comum','ambos',null::numeric,null::int,'Shad 2", colher de casting média','Spinning médio com leader de aço','05:00','08:00','Perto das ervas','Stop-and-go / lift-and-drop perto da Dock of Peace.'),
  ('Black Crappie','Pomoxis nigromaculatus','comum','diurno',null::numeric,null::int,'Boia com isca de panfish (leader 30")','Vara de boia leve','07:00','11:00','Meia-água','Use iscas que mirem só panfish.'),
  ('Yellow Perch','Perca flavescens','comum','diurno',null::numeric,null::int,'Minhocas, spinners pequenos','Boia / spinning leve','07:00','11:00','Próximo a estruturas',null),
  ('Grass Pickerel','Esox americanus vermiculatus','comum','ambos',null::numeric,null::int,'Spinners pequenos','Spinning leve','05:00','08:00','Vegetação rasa',null),
  ('Golden Shiner','Notemigonus crysoleucas','comum','diurno',null::numeric,null::int,'Spinners, spoons, shads (reel médio / #2)','Spinning leve','08:00','16:00','Meia-água','Isca-viva valiosa; pega em qualquer ponto do lago.')
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);

-- Lone Star Lake
with l as (select id from public.locais_pesca where nome = 'Lone Star Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',null::numeric,null::int,'Iscas artificiais, minhocas','Casting médio (5–10 lb)','05:00','08:00','Vegetação e margens','Pode passar de 4 kg; briga forte.'),
  ('Spotted Bass','Micropterus punctulatus','comum','ambos',null::numeric,null::int,'Iscas artificiais, minhocas','Spinning médio','05:00','08:00','Estruturas','Melhor para dinheiro (~100 por exemplar de ~2 lb).'),
  ('Bluegill','Lepomis macrochirus','comum','diurno',null::numeric,null::int,'Minhocas, Red Worm (anzol #6)','Boia leve','08:00','17:00','Margens rasas',null),
  ('Redear Sunfish','Lepomis microlophus','comum','diurno',null::numeric,null::int,'Minhocas','Boia leve','08:00','17:00','Fundo raso',null),
  ('Black Crappie','Pomoxis nigromaculatus','comum','diurno',null::numeric,null::int,'Jigs pequenos, minhocas','Vara de boia leve','07:00','11:00','Meia-água',null),
  ('Smallmouth Buffalo','Ictiobus bubalus','comum','diurno',null::numeric,null::int,'Massa, minhocas no fundo','Feeder / bottom','08:00','16:00','Fundo',null),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',null::numeric,null::int,'Stink bait, isca cortada','Bottom/feeder','21:00','03:00','Fundo','Muito abundante; bom para grind noturno.'),
  ('Walleye','Sander vitreus','comum','noturno',null::numeric,null::int,'Jigs, crankbaits','Spinning médio','21:00','04:00','Fundo','Melhor com pouca luz.')
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);

-- Quanchkin Lake
with l as (select id from public.locais_pesca where nome = 'Quanchkin Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',null::numeric,null::int,'Iscas artificiais','Casting médio','05:00','08:00','Vegetação',null),
  ('Spotted Bass','Micropterus punctulatus','comum','ambos',null::numeric,null::int,'Iscas artificiais','Spinning médio','05:00','08:00','Estruturas',null),
  ('Bowfin','Amia calva','troféu','ambos',null::numeric,null::int,'Isca cortada / lagostim no fundo','Bottom reforçado (com leader)','06:00','10:00','Fundo, vegetação','Hotspots conhecidos para troféu/único. Briga muito forte.'),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',null::numeric,null::int,'Isca cortada','Bottom/feeder','21:00','03:00','Fundo',null),
  ('Flathead Catfish','Pylodictis olivaris','comum','noturno',null::numeric,null::int,'Isca-viva, peixe cortado','Bottom pesado','21:00','03:00','Fundo, canais','Pode ficar enorme.'),
  ('Blue Catfish','Ictalurus furcatus','comum','noturno',null::numeric,null::int,'Isca cortada','Bottom pesado','21:00','03:00','Fundo',null),
  ('Alligator Gar','Atractosteus spatula','troféu','ambos',null::numeric,null::int,'Lagostim (anzol 6/0, leader de aço)','Casting pesado','18:00','23:00','Superfície / meia-água','Predador gigante; leader de aço obrigatório.')
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);

-- Rocky Lake
with l as (select id from public.locais_pesca where nome = 'Rocky Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Rainbow Trout','Oncorhynchus mykiss','comum','ambos',null::numeric,null::int,'Fly, spincast, colheres, spinners','Spinning leve / fly','05:00','09:00','Meia-água','Truta mais popular pra dinheiro no lago.'),
  ('Brook Trout','Salvelinus fontinalis','comum','ambos',null::numeric,null::int,'Iscas pequenas, minhocas','Spinning leve','05:00','08:00','Margem / águas rasas',null),
  ('Brown Trout','Salmo trutta','comum','ambos',null::numeric,null::int,'Iscas maiores, lagostim, minnow','Spinning médio','05:00','08:00','Águas profundas',null),
  ('Cutthroat Trout','Oncorhynchus clarkii','comum','ambos',null::numeric,null::int,'Spinners, colheres','Spinning leve','05:00','08:00','Afloramentos rochosos','Nativa do lago.'),
  ('Northern Pike','Esox lucius','comum','ambos',null::numeric,null::int,'Crankbaits, colheres','Spinning médio com leader de aço','05:00','08:00','Todo o lago',null),
  ('Smallmouth Bass','Micropterus dolomieu','comum','ambos',null::numeric,null::int,'Jigs, crankbaits','Spinning médio','05:00','08:00','Pedras e vegetação',null),
  ('Yellow Perch','Perca flavescens','comum','diurno',null::numeric,null::int,'Iscas pequenas, minhocas','Boia leve','08:00','16:00','Estruturas na margem',null),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',null::numeric,null::int,'Isca cortada','Bottom/feeder','21:00','03:00','Fundo',null)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);

-- Neherrin River
with l as (select id from public.locais_pesca where nome = 'Neherrin River')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',null::numeric,null::int,'Iscas artificiais','Casting médio','05:00','08:00','Vegetação e margens',null),
  ('Smallmouth Bass','Micropterus dolomieu','comum','ambos',null::numeric,null::int,'Jigs, crankbaits','Spinning médio','05:00','08:00','Pedras',null),
  ('Black Crappie','Pomoxis nigromaculatus','comum','diurno',null::numeric,null::int,'Jigs pequenos, sanguessugas','Vara de boia leve','07:00','11:00','Meia-água','Sanguessuga ajuda a pegar os Únicos.'),
  ('Redear Sunfish','Lepomis microlophus','comum','diurno',null::numeric,null::int,'Minhocas','Boia leve','08:00','17:00','Fundo raso',null),
  ('Bluegill','Lepomis macrochirus','comum','diurno',null::numeric,null::int,'Minhocas, maggots','Boia leve','08:00','17:00','Margens',null),
  ('Redfin Pickerel','Esox americanus americanus','comum','ambos',null::numeric,null::int,'Spinners pequenos','Spinning leve','05:00','08:00','Vegetação',null),
  ('American Shad','Alosa sapidissima','comum','diurno',null::numeric,null::int,'Shad darts, colheres pequenas','Spinning leve','07:00','12:00','Correnteza','Migratório; forma cardumes na corrente.'),
  ('Common Carp','Cyprinus carpio','comum','ambos',null::numeric,null::int,'Massa, milho, minhocas','Feeder / slip bobber','04:00','07:00','Fundo',null)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);

-- Everglades
with l as (select id from public.locais_pesca where nome = 'Everglades')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',null::numeric,null::int,'Iscas artificiais','Casting médio','05:00','08:00','Vegetação',null),
  ('Butterfly Peacock Bass','Cichla ocellaris','comum','diurno',null::numeric,null::int,'Spoons/jigs médios, iscas grandes','Casting pesado','08:00','16:00','Perto das vitórias-régias','Caçador visual diurno; briga forte.'),
  ('Peacock Bass','Cichla sp.','troféu','diurno',null::numeric,null::int,'Iscas grandes e lentas perto da cobertura','Casting pesado','08:00','16:00','Vegetação densa','Alvo de alto valor e XP.'),
  ('Snook','Centropomus undecimalis','comum','ambos',null::numeric,null::int,'Isca-viva sob boia','Casting médio-pesado','05:00','09:00','Estruturas',null),
  ('Florida Gar','Lepisosteus platyrhincus','comum','ambos',null::numeric,null::int,'Isca-viva (leader de aço)','Casting médio','18:00','23:00','Superfície','Alto XP no pico de alimentação.'),
  ('Bluegill','Lepomis macrochirus','comum','diurno',null::numeric,null::int,'Minhocas','Boia leve','08:00','17:00','Margens',null),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',null::numeric,null::int,'Isca cortada','Bottom/feeder','21:00','03:00','Fundo',null),
  ('Brown Bullhead','Ameiurus nebulosus','comum','noturno',null::numeric,null::int,'Minhocão, isca cortada','Bottom','21:00','02:00','Fundo',null)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);

-- Akhtuba River
with l as (select id from public.locais_pesca where nome = 'Akhtuba River')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs)
select l.id, v.* from l cross join (values
  ('Wels Catfish','Silurus glanis','troféu','noturno',null::numeric,null::int,'Isca cortada grande (anzol 4/0–7/0)','Bottom pesado','21:00','04:00','Fundo, fossas','Gigante; pode passar de 50 kg.'),
  ('Beluga','Huso huso','troféu','ambos',null::numeric,null::int,'Isca cortada grande no fundo','Bottom pesadíssimo','18:00','06:00','Fundo','Esturjão enorme.'),
  ('Zander','Sander lucioperca','comum','noturno',null::numeric,null::int,'Jigs, shads','Spinning médio','21:00','04:00','Fundo / estruturas','Lúcio-perca; ativa com pouca luz.'),
  ('Asp','Leuciscus aspius','comum','diurno',null::numeric,null::int,'Iscas de superfície, colheres','Spinning médio','07:00','12:00','Superfície / correnteza',null),
  ('Northern Pike','Esox lucius','comum','ambos',null::numeric,null::int,'Iscas artificiais','Spinning médio com leader de aço','05:00','08:00','Vegetação',null),
  ('Common Bream','Abramis brama','comum','diurno',null::numeric,null::int,'Minhocas, massa','Feeder','08:00','16:00','Fundo',null),
  ('Caspian Roach','Rutilus caspicus','comum','diurno',null::numeric,null::int,'Minhocas, massa','Boia leve','08:00','16:00','Meia-água',null)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs);
