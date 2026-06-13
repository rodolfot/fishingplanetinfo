-- =============================================================================
--  Fishing Planet Info — seed EXTRA (só águas novas, sem duplicar as existentes)
--  ARQUIVO GERADO por scripts/gen-sql.mjs a partir de seed.js — NÃO edite à mão.
--  Rode DEPOIS do schema.sql.
-- =============================================================================

insert into public.locais_pesca (nome, regiao, nivel, guia, pais, lat, lng, preco_viagem, diaria, lic_3dias, lic_7dias, lic_ilimitada, estimado) values
  ('Emerald Lake', 'Nova York, EUA', 'Nível ~9–20', 'Lago de NY popular para subir de nível pegando Walleye (lance atrás das vitórias-régias, ~130–160 ft). Golden Shiner pega em qualquer lugar com spinners/spoons/shads. Pike perto das ervas com Shad 2" em stop-and-go (Dock of Peace).', 'EUA', 43, -75, null, 900, null, null, null, false),
  ('Lone Star Lake', 'Texas, EUA', 'Nível 1+', 'Lago do Texas com quase uma dúzia de espécies. Minhocas/stink bait pegam bem; Red Worm no anzol #6. Spotted Bass rende bom dinheiro; Channel Catfish é abundante (noite).', 'EUA', 31, -99, null, null, null, null, null, false),
  ('Quanchkin Lake', 'Louisiana, EUA', 'Nível ~10+', 'Pântano da Louisiana com predadores grandes. Alligator Gar exige leader de aço e anzol 6/0 com lagostim. Bagres (Channel/Flathead/Blue) à noite. Hotspots de Bowfin para troféu/único.', 'EUA', 30.5, -91.5, null, null, null, null, null, false),
  ('Rocky Lake', 'Colorado, EUA', 'Nível ~8–20', 'Lago de montanha no Colorado, famoso pelas trutas (Rainbow é a mais popular pra dinheiro). Trutas com fly/spinning e iscas pequenas/colheres; Brown no fundo com lagostim/minnow. Pike e Smallmouth com crankbaits perto de pedras e vegetação.', 'EUA', 39, -105.5, null, null, null, null, null, false),
  ('Neherrin River', 'Carolina do Norte, EUA', 'Nível 1+', 'Rio da Carolina do Norte com bass, panfish, carpa e shad. Iscas artificiais pra bass; minhocas/sanguessugas pros panfish; massa/milho pra carpa no fundo.', 'EUA', 35.5, -79, null, null, null, null, null, false),
  ('Everglades', 'Flórida, EUA', 'Nível ~15+ (alto XP)', 'Pântano da Flórida com espécies exóticas de alto XP. Peacock Bass exige tackle pesado na vegetação (spoons/jigs médios; iscas grandes e lentas perto da cobertura). Snook com isca-viva sob boia. Florida Gar rende muito XP no pico de alimentação.', 'EUA', 25.9, -80.9, null, null, null, null, null, false),
  ('Akhtuba River', 'Rússia', 'Nível ~20+ (avançado)', 'Rio russo com predadores grandes e esturjão. Wels Catfish e Beluga no fundo com anzol 4/0–7/0 e isca cortada grande. Zander à noite com jigs; Asp na superfície de dia.', 'Rússia', 48.7, 44.8, null, null, null, null, null, false),
  ('Falcon Lake', 'Oregon, EUA', 'Nível ~5–20', 'Lago de Oregon com trutas e black bass. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'EUA', 43.8, -121.4, null, null, null, null, null, true),
  ('San Joaquin Delta', 'Califórnia, EUA', 'Nível ~10–25', 'Delta da Califórnia: bass, bagres e o gigante White Sturgeon. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'EUA', 38, -121.5, null, null, null, null, null, true),
  ('Saint Croix Lake', 'Michigan, EUA', 'Nível ~10–30', 'Lago de Michigan com walleye, pike e o troféu Muskellunge. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'EUA', 45.5, -84.5, null, null, null, null, null, true),
  ('White Moose Lake', 'Alberta, Canadá', 'Nível ~15–30', 'Lago canadense frio: trutas grandes, pike e whitefish. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'Canadá', 52.5, -114, null, null, null, null, null, true),
  ('Kaniq Creek', 'Alasca, EUA', 'Nível ~20–35', 'Rio do Alasca na corrida dos salmões; trutas e char no meio. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'EUA', 60.5, -151, null, null, null, null, null, true),
  ('Blue Crab Island', 'Mississippi, EUA (Golfo)', 'Nível ~20–35', 'Água salgada do Golfo do México: drum, trout e o troféu Tarpon. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'EUA', 30.3, -88.9, null, null, null, null, null, true),
  ('Lago Ladoga', 'Carélia, Rússia', 'Nível ~20–35', 'Maior lago da Europa: pike, zander, salmão e truta marrom. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'Rússia', 61, 31.5, null, null, null, null, null, true),
  ('Rio Volkhov', 'Rússia', 'Nível ~20–35', 'Rio russo com zander, asp e o gigante Wels Catfish. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'Rússia', 58.5, 31.3, null, null, null, null, null, true),
  ('Mar da Noruega', 'Noruega (mar)', 'Nível ~25–40', 'Pesca de barco no mar da Noruega: bacalhau, saithe e halibut troféu. (Lista de espécies estimada pela região — confirme e corrija no jogo.)', 'Noruega', 69.5, 18, null, null, null, null, null, true);

-- Emerald Lake
with l as (select id from public.locais_pesca where nome = 'Emerald Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Walleye','Sander vitreus','comum','noturno',200,30,'Jigs, crankbaits fundos, shads','Spinning/Casting médio','21:00','04:00','Fundo, atrás das vitórias-régias (130–160 ft)','Bom alvo de XP/valor; melhor com pouca luz.',true),
  ('Northern Pike','Esox lucius','comum','ambos',150,30,'Shad 2", colher de casting média','Spinning médio com leader de aço','05:00','08:00','Perto das ervas','Stop-and-go / lift-and-drop perto da Dock of Peace.',true),
  ('Black Crappie','Pomoxis nigromaculatus','comum','diurno',115,30,'Boia com isca de panfish (leader 30")','Vara de boia leve','07:00','11:00','Meia-água','Use iscas que mirem só panfish.',true),
  ('Yellow Perch','Perca flavescens','comum','diurno',120,30,'Minhocas, spinners pequenos','Boia / spinning leve','07:00','11:00','Próximo a estruturas',null,true),
  ('Grass Pickerel','Esox americanus vermiculatus','comum','ambos',150,30,'Spinners pequenos','Spinning leve','05:00','08:00','Vegetação rasa',null,true),
  ('Golden Shiner','Notemigonus crysoleucas','comum','diurno',80,30,'Spinners, spoons, shads (reel médio / #2)','Spinning leve','08:00','16:00','Meia-água','Isca-viva valiosa; pega em qualquer ponto do lago.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Lone Star Lake
with l as (select id from public.locais_pesca where nome = 'Lone Star Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',150,30,'Iscas artificiais, minhocas','Casting médio (5–10 lb)','05:00','08:00','Vegetação e margens','Pode passar de 4 kg; briga forte.',true),
  ('Spotted Bass','Micropterus punctulatus','comum','ambos',170,30,'Iscas artificiais, minhocas','Spinning médio','05:00','08:00','Estruturas','Melhor para dinheiro (~100 por exemplar de ~2 lb).',true),
  ('Bluegill','Lepomis macrochirus','comum','diurno',100,30,'Minhocas, Red Worm (anzol #6)','Boia leve','08:00','17:00','Margens rasas',null,true),
  ('Redear Sunfish','Lepomis microlophus','comum','diurno',100,30,'Minhocas','Boia leve','08:00','17:00','Fundo raso',null,true),
  ('Black Crappie','Pomoxis nigromaculatus','comum','diurno',115,30,'Jigs pequenos, minhocas','Vara de boia leve','07:00','11:00','Meia-água',null,true),
  ('Smallmouth Buffalo','Ictiobus bubalus','comum','diurno',80,30,'Massa, minhocas no fundo','Feeder / bottom','08:00','16:00','Fundo',null,true),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',45,30,'Stink bait, isca cortada','Bottom/feeder','21:00','03:00','Fundo','Muito abundante; bom para grind noturno.',true),
  ('Walleye','Sander vitreus','comum','noturno',200,30,'Jigs, crankbaits','Spinning médio','21:00','04:00','Fundo','Melhor com pouca luz.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Quanchkin Lake
with l as (select id from public.locais_pesca where nome = 'Quanchkin Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',150,30,'Iscas artificiais','Casting médio','05:00','08:00','Vegetação',null,true),
  ('Spotted Bass','Micropterus punctulatus','comum','ambos',170,30,'Iscas artificiais','Spinning médio','05:00','08:00','Estruturas',null,true),
  ('Bowfin','Amia calva','troféu','ambos',69,90,'Isca cortada / lagostim no fundo','Bottom reforçado (com leader)','06:00','10:00','Fundo, vegetação','Hotspots conhecidos para troféu/único. Briga muito forte.',true),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',45,30,'Isca cortada','Bottom/feeder','21:00','03:00','Fundo',null,true),
  ('Flathead Catfish','Pylodictis olivaris','comum','noturno',45,30,'Isca-viva, peixe cortado','Bottom pesado','21:00','03:00','Fundo, canais','Pode ficar enorme.',true),
  ('Blue Catfish','Ictalurus furcatus','comum','noturno',45,30,'Isca cortada','Bottom pesado','21:00','03:00','Fundo',null,true),
  ('Alligator Gar','Atractosteus spatula','troféu','ambos',81,90,'Lagostim (anzol 6/0, leader de aço)','Casting pesado','18:00','23:00','Superfície / meia-água','Predador gigante; leader de aço obrigatório.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Rocky Lake
with l as (select id from public.locais_pesca where nome = 'Rocky Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Rainbow Trout','Oncorhynchus mykiss','comum','ambos',169,30,'Fly, spincast, colheres, spinners','Spinning leve / fly','05:00','09:00','Meia-água','Truta mais popular pra dinheiro no lago.',true),
  ('Brook Trout','Salvelinus fontinalis','comum','ambos',150,30,'Iscas pequenas, minhocas','Spinning leve','05:00','08:00','Margem / águas rasas',null,true),
  ('Brown Trout','Salmo trutta','comum','ambos',150,30,'Iscas maiores, lagostim, minnow','Spinning médio','05:00','08:00','Águas profundas',null,true),
  ('Cutthroat Trout','Oncorhynchus clarkii','comum','ambos',164,30,'Spinners, colheres','Spinning leve','05:00','08:00','Afloramentos rochosos','Nativa do lago.',true),
  ('Northern Pike','Esox lucius','comum','ambos',150,30,'Crankbaits, colheres','Spinning médio com leader de aço','05:00','08:00','Todo o lago',null,true),
  ('Smallmouth Bass','Micropterus dolomieu','comum','ambos',160,30,'Jigs, crankbaits','Spinning médio','05:00','08:00','Pedras e vegetação',null,true),
  ('Yellow Perch','Perca flavescens','comum','diurno',120,30,'Iscas pequenas, minhocas','Boia leve','08:00','16:00','Estruturas na margem',null,true),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',45,30,'Isca cortada','Bottom/feeder','21:00','03:00','Fundo',null,true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Neherrin River
with l as (select id from public.locais_pesca where nome = 'Neherrin River')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',150,30,'Iscas artificiais','Casting médio','05:00','08:00','Vegetação e margens',null,true),
  ('Smallmouth Bass','Micropterus dolomieu','comum','ambos',160,30,'Jigs, crankbaits','Spinning médio','05:00','08:00','Pedras',null,true),
  ('Black Crappie','Pomoxis nigromaculatus','comum','diurno',115,30,'Jigs pequenos, sanguessugas','Vara de boia leve','07:00','11:00','Meia-água','Sanguessuga ajuda a pegar os Únicos.',true),
  ('Redear Sunfish','Lepomis microlophus','comum','diurno',100,30,'Minhocas','Boia leve','08:00','17:00','Fundo raso',null,true),
  ('Bluegill','Lepomis macrochirus','comum','diurno',100,30,'Minhocas, maggots','Boia leve','08:00','17:00','Margens',null,true),
  ('Redfin Pickerel','Esox americanus americanus','comum','ambos',150,30,'Spinners pequenos','Spinning leve','05:00','08:00','Vegetação',null,true),
  ('American Shad','Alosa sapidissima','comum','diurno',120,30,'Shad darts, colheres pequenas','Spinning leve','07:00','12:00','Correnteza','Migratório; forma cardumes na corrente.',true),
  ('Common Carp','Cyprinus carpio','comum','ambos',90,30,'Massa, milho, minhocas','Feeder / slip bobber','04:00','07:00','Fundo',null,true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Everglades
with l as (select id from public.locais_pesca where nome = 'Everglades')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',150,30,'Iscas artificiais','Casting médio','05:00','08:00','Vegetação',null,true),
  ('Butterfly Peacock Bass','Cichla ocellaris','comum','diurno',180,30,'Spoons/jigs médios, iscas grandes','Casting pesado','08:00','16:00','Perto das vitórias-régias','Caçador visual diurno; briga forte.',true),
  ('Peacock Bass','Cichla sp.','troféu','diurno',230,90,'Iscas grandes e lentas perto da cobertura','Casting pesado','08:00','16:00','Vegetação densa','Alvo de alto valor e XP.',true),
  ('Snook','Centropomus undecimalis','comum','ambos',150,30,'Isca-viva sob boia','Casting médio-pesado','05:00','09:00','Estruturas',null,true),
  ('Florida Gar','Lepisosteus platyrhincus','comum','ambos',70,30,'Isca-viva (leader de aço)','Casting médio','18:00','23:00','Superfície','Alto XP no pico de alimentação.',true),
  ('Bluegill','Lepomis macrochirus','comum','diurno',100,30,'Minhocas','Boia leve','08:00','17:00','Margens',null,true),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',45,30,'Isca cortada','Bottom/feeder','21:00','03:00','Fundo',null,true),
  ('Brown Bullhead','Ameiurus nebulosus','comum','noturno',45,30,'Minhocão, isca cortada','Bottom','21:00','02:00','Fundo',null,true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Akhtuba River
with l as (select id from public.locais_pesca where nome = 'Akhtuba River')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Wels Catfish','Silurus glanis','troféu','noturno',57,90,'Isca cortada grande (anzol 4/0–7/0)','Bottom pesado','21:00','04:00','Fundo, fossas','Gigante; pode passar de 50 kg.',true),
  ('Beluga','Huso huso','troféu','ambos',69,90,'Isca cortada grande no fundo','Bottom pesadíssimo','18:00','06:00','Fundo','Esturjão enorme.',true),
  ('Zander','Sander lucioperca','comum','noturno',180,30,'Jigs, shads','Spinning médio','21:00','04:00','Fundo / estruturas','Lúcio-perca; ativa com pouca luz.',true),
  ('Asp','Leuciscus aspius','comum','diurno',140,30,'Iscas de superfície, colheres','Spinning médio','07:00','12:00','Superfície / correnteza',null,true),
  ('Northern Pike','Esox lucius','comum','ambos',150,30,'Iscas artificiais','Spinning médio com leader de aço','05:00','08:00','Vegetação',null,true),
  ('Common Bream','Abramis brama','comum','diurno',80,30,'Minhocas, massa','Feeder','08:00','16:00','Fundo',null,true),
  ('Caspian Roach','Rutilus caspicus','comum','diurno',70,30,'Minhocas, massa','Boia leve','08:00','16:00','Meia-água',null,true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Falcon Lake
with l as (select id from public.locais_pesca where nome = 'Falcon Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Rainbow Trout',null,'comum','ambos',169,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Cutthroat Trout',null,'comum','ambos',164,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Brown Trout',null,'comum','ambos',150,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Brook Trout',null,'comum','ambos',150,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Smallmouth Bass',null,'comum','ambos',160,30,'Iscas artificiais (soft plastic, crankbait, spinnerbait)','Casting médio','05:00','08:00','Vegetação e estruturas','Espécie típica da região — não confirmada no jogo.',true),
  ('Largemouth Bass',null,'comum','ambos',150,30,'Iscas artificiais (soft plastic, crankbait, spinnerbait)','Casting médio','05:00','08:00','Vegetação e estruturas','Espécie típica da região — não confirmada no jogo.',true),
  ('Black Crappie',null,'comum','diurno',115,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Bluegill',null,'comum','diurno',100,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Channel Catfish',null,'comum','noturno',45,30,'Isca cortada / minhocão no fundo','Bottom/feeder','21:00','03:00','Fundo','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- San Joaquin Delta
with l as (select id from public.locais_pesca where nome = 'San Joaquin Delta')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Largemouth Bass',null,'comum','ambos',150,30,'Iscas artificiais (soft plastic, crankbait, spinnerbait)','Casting médio','05:00','08:00','Vegetação e estruturas','Espécie típica da região — não confirmada no jogo.',true),
  ('Smallmouth Bass',null,'comum','ambos',160,30,'Iscas artificiais (soft plastic, crankbait, spinnerbait)','Casting médio','05:00','08:00','Vegetação e estruturas','Espécie típica da região — não confirmada no jogo.',true),
  ('Spotted Bass',null,'comum','ambos',170,30,'Iscas artificiais (soft plastic, crankbait, spinnerbait)','Casting médio','05:00','08:00','Vegetação e estruturas','Espécie típica da região — não confirmada no jogo.',true),
  ('Striped Bass',null,'comum','ambos',150,30,'Iscas artificiais (soft plastic, crankbait, spinnerbait)','Casting médio','05:00','08:00','Vegetação e estruturas','Espécie típica da região — não confirmada no jogo.',true),
  ('Channel Catfish',null,'comum','noturno',45,30,'Isca cortada / minhocão no fundo','Bottom/feeder','21:00','03:00','Fundo','Espécie típica da região — não confirmada no jogo.',true),
  ('White Catfish',null,'comum','noturno',45,30,'Isca cortada / minhocão no fundo','Bottom/feeder','21:00','03:00','Fundo','Espécie típica da região — não confirmada no jogo.',true),
  ('Bluegill',null,'comum','diurno',100,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Black Crappie',null,'comum','diurno',115,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('White Sturgeon',null,'troféu','ambos',115,90,'Isca cortada grande no fundo','Bottom pesadíssimo','18:00','06:00','Fundo','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Saint Croix Lake
with l as (select id from public.locais_pesca where nome = 'Saint Croix Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Walleye',null,'comum','ambos',200,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Northern Pike',null,'comum','ambos',150,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Muskellunge',null,'troféu','ambos',115,90,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Smallmouth Bass',null,'comum','ambos',160,30,'Iscas artificiais (soft plastic, crankbait, spinnerbait)','Casting médio','05:00','08:00','Vegetação e estruturas','Espécie típica da região — não confirmada no jogo.',true),
  ('Largemouth Bass',null,'comum','ambos',150,30,'Iscas artificiais (soft plastic, crankbait, spinnerbait)','Casting médio','05:00','08:00','Vegetação e estruturas','Espécie típica da região — não confirmada no jogo.',true),
  ('Yellow Perch',null,'comum','diurno',120,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Bluegill',null,'comum','diurno',100,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Black Crappie',null,'comum','diurno',115,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Lake Trout',null,'comum','ambos',160,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- White Moose Lake
with l as (select id from public.locais_pesca where nome = 'White Moose Lake')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Lake Trout',null,'comum','ambos',160,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Rainbow Trout',null,'comum','ambos',169,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Brook Trout',null,'comum','ambos',150,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Northern Pike',null,'comum','ambos',150,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Walleye',null,'comum','ambos',200,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Yellow Perch',null,'comum','diurno',120,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Lake Whitefish',null,'comum','ambos',100,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Burbot',null,'comum','noturno',100,30,'Isca cortada / minhocão no fundo','Bottom/feeder','21:00','03:00','Fundo','Espécie típica da região — não confirmada no jogo.',true),
  ('Mountain Whitefish',null,'comum','ambos',100,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Kaniq Creek
with l as (select id from public.locais_pesca where nome = 'Kaniq Creek')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Chinook Salmon',null,'troféu','ambos',184,90,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Coho Salmon',null,'comum','ambos',160,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Sockeye Salmon',null,'comum','ambos',160,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Pink Salmon',null,'comum','ambos',160,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Chum Salmon',null,'comum','ambos',160,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Rainbow Trout',null,'comum','ambos',169,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Dolly Varden',null,'comum','ambos',100,30,'Iscas variadas conforme a espécie','Spinning médio','06:00','12:00','Variada','Espécie típica da região — não confirmada no jogo.',true),
  ('Arctic Grayling',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Arctic Char',null,'comum','ambos',100,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Blue Crab Island
with l as (select id from public.locais_pesca where nome = 'Blue Crab Island')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Red Drum',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Black Drum',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Spotted Seatrout',null,'comum','ambos',160,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Southern Flounder',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Sheepshead',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Atlantic Croaker',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Sea Catfish',null,'comum','noturno',45,30,'Isca cortada / minhocão no fundo','Bottom/feeder','21:00','03:00','Fundo','Espécie típica da região — não confirmada no jogo.',true),
  ('Snook',null,'comum','ambos',150,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Tarpon',null,'troféu','ambos',115,90,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Lago Ladoga
with l as (select id from public.locais_pesca where nome = 'Lago Ladoga')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Northern Pike',null,'comum','ambos',150,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Zander',null,'comum','ambos',180,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('European Perch',null,'comum','diurno',120,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Common Bream',null,'comum','diurno',80,30,'Massa, milho, minhocas, bloodworms','Feeder / boia','06:00','12:00','Fundo / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Common Roach',null,'comum','diurno',70,30,'Massa, milho, minhocas, bloodworms','Feeder / boia','06:00','12:00','Fundo / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Atlantic Salmon',null,'comum','ambos',160,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Brown Trout',null,'comum','ambos',150,30,'Spinners, colheres, fly, iscas pequenas','Spinning leve / fly','05:00','09:00','Meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Burbot',null,'comum','noturno',100,30,'Isca cortada / minhocão no fundo','Bottom/feeder','21:00','03:00','Fundo','Espécie típica da região — não confirmada no jogo.',true),
  ('Ruffe',null,'comum','diurno',100,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Rio Volkhov
with l as (select id from public.locais_pesca where nome = 'Rio Volkhov')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Zander',null,'comum','ambos',180,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Wels Catfish',null,'troféu','noturno',57,90,'Isca cortada / minhocão no fundo','Bottom/feeder','21:00','03:00','Fundo','Espécie típica da região — não confirmada no jogo.',true),
  ('Asp',null,'comum','ambos',140,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Ide',null,'comum','ambos',100,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('Common Bream',null,'comum','diurno',80,30,'Massa, milho, minhocas, bloodworms','Feeder / boia','06:00','12:00','Fundo / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Northern Pike',null,'comum','ambos',150,30,'Jigs, shads, colheres','Spinning médio (leader de aço p/ esócideos)','05:00','08:00','Estruturas / vegetação','Espécie típica da região — não confirmada no jogo.',true),
  ('European Perch',null,'comum','diurno',120,30,'Minhocas, maggots, jigs pequenos','Vara de boia leve','08:00','16:00','Margens / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Common Roach',null,'comum','diurno',70,30,'Massa, milho, minhocas, bloodworms','Feeder / boia','06:00','12:00','Fundo / meia-água','Espécie típica da região — não confirmada no jogo.',true),
  ('Burbot',null,'comum','noturno',100,30,'Isca cortada / minhocão no fundo','Bottom/feeder','21:00','03:00','Fundo','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Mar da Noruega
with l as (select id from public.locais_pesca where nome = 'Mar da Noruega')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Atlantic Cod',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Coalfish (Saithe)',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Haddock',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Atlantic Halibut',null,'troféu','ambos',115,90,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Atlantic Mackerel',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Pollock',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Atlantic Wolffish',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Ling',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true),
  ('Tusk',null,'comum','ambos',100,30,'Isca-viva, jigs pesados, peixe cortado','Boat / casting pesado','06:00','18:00','Fundo / coluna d''água','Espécie típica da região — não confirmada no jogo.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);
