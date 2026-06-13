-- =============================================================================
--  Fishing Planet Info — seed EXTRA (só águas novas, sem duplicar as existentes)
--  ARQUIVO GERADO por scripts/gen-sql.mjs a partir de seed.js — NÃO edite à mão.
--  Rode DEPOIS do schema.sql.
-- =============================================================================

insert into public.locais_pesca (nome, regiao, nivel, guia, pais, lat, lng, preco_viagem, diaria) values
  ('Emerald Lake', 'Nova York, EUA', 'Nível ~9–20', 'Lago de NY popular para subir de nível pegando Walleye (lance atrás das vitórias-régias, ~130–160 ft). Golden Shiner pega em qualquer lugar com spinners/spoons/shads. Pike perto das ervas com Shad 2" em stop-and-go (Dock of Peace).', 'EUA', 43, -75, null, 900),
  ('Lone Star Lake', 'Texas, EUA', 'Nível 1+', 'Lago do Texas com quase uma dúzia de espécies. Minhocas/stink bait pegam bem; Red Worm no anzol #6. Spotted Bass rende bom dinheiro; Channel Catfish é abundante (noite).', 'EUA', 31, -99, null, null),
  ('Quanchkin Lake', 'Louisiana, EUA', 'Nível ~10+', 'Pântano da Louisiana com predadores grandes. Alligator Gar exige leader de aço e anzol 6/0 com lagostim. Bagres (Channel/Flathead/Blue) à noite. Hotspots de Bowfin para troféu/único.', 'EUA', 30.5, -91.5, null, null),
  ('Rocky Lake', 'Colorado, EUA', 'Nível ~8–20', 'Lago de montanha no Colorado, famoso pelas trutas (Rainbow é a mais popular pra dinheiro). Trutas com fly/spinning e iscas pequenas/colheres; Brown no fundo com lagostim/minnow. Pike e Smallmouth com crankbaits perto de pedras e vegetação.', 'EUA', 39, -105.5, null, null),
  ('Neherrin River', 'Carolina do Norte, EUA', 'Nível 1+', 'Rio da Carolina do Norte com bass, panfish, carpa e shad. Iscas artificiais pra bass; minhocas/sanguessugas pros panfish; massa/milho pra carpa no fundo.', 'EUA', 35.5, -79, null, null),
  ('Everglades', 'Flórida, EUA', 'Nível ~15+ (alto XP)', 'Pântano da Flórida com espécies exóticas de alto XP. Peacock Bass exige tackle pesado na vegetação (spoons/jigs médios; iscas grandes e lentas perto da cobertura). Snook com isca-viva sob boia. Florida Gar rende muito XP no pico de alimentação.', 'EUA', 25.9, -80.9, null, null),
  ('Akhtuba River', 'Rússia', 'Nível ~20+ (avançado)', 'Rio russo com predadores grandes e esturjão. Wels Catfish e Beluga no fundo com anzol 4/0–7/0 e isca cortada grande. Zander à noite com jigs; Asp na superfície de dia.', 'Rússia', 48.7, 44.8, null, null);

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
