-- =============================================================================
--  Fishing Planet Info — dados de exemplo (todas as águas)
--  ARQUIVO GERADO por scripts/gen-sql.mjs a partir de seed.js — NÃO edite à mão.
--  Rode DEPOIS do schema.sql.
-- =============================================================================

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
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Black Bass','Micropterus salmoides','jovem','ambos',118,16,'Iscas artificiais (spinnerbait, soft plastic, crankbait)','Spinning/Casting leve (linha 5–10 lb)','05:00','07:00','Margens e vegetação','Twitching rápido também rende ao entardecer (18:00–19:00).',false),
  ('Esox Vermiculatus','Esox americanus vermiculatus','comum','ambos',161,60,'Spinners pequenos / iscas artificiais','Spinning leve','05:00','07:00','Águas rasas com vegetação','Predador agressivo; recolhimento com paradas.',false),
  ('Esox Vermiculatus','Esox americanus vermiculatus','troféu','ambos',182,111,'Spinners pequenos / iscas artificiais','Spinning leve','05:00','07:00','Águas rasas com vegetação','Exemplares troféu rendem bem mais XP.',false),
  ('Pomoxis Annularis','Pomoxis annularis','comum','diurno',100,54,'Minhocas / maggots / jigs pequenos','Vara de boia (OmniFloat 450, anzol #8)','06:00','10:00','Meia-água','White Crappie. Cardume — fisgue vários no mesmo ponto.',false),
  ('Pomoxis Annularis','Pomoxis annularis','troféu','diurno',149,71,'Minhocas / maggots / jigs pequenos','Vara de boia (anzol #8)','06:00','10:00','Meia-água',null,false),
  ('Bluegill','Lepomis macrochirus','comum','diurno',100,30,'Minhocas, maggots','Boia leve (anzol #8–10)','08:00','17:00','Margens rasas','Panfish abundante; ótimo para missões iniciais.',true),
  ('Pumpkinseed','Lepomis gibbosus','comum','diurno',95,30,'Minhocas, maggots','Boia leve (anzol #10)','08:00','17:00','Margens rasas',null,true),
  ('Bowfin','Amia calva','comum','ambos',60,30,'Isca cortada / minhocão no fundo','Bottom/feeder (linha 5–10 lb)','06:00','09:00','Fundo','Briga muito forte; pode passar de 2 kg.',true),
  ('Channel Catfish','Ictalurus punctatus','troféu','noturno',52,90,'Isca cortada, fígado de galinha','Bottom/feeder reforçado','21:00','02:00','Fundo, canais','Troféu passa de 5 kg (12+ lb). Pesca noturna.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

-- Pesqueiro Lesni Vila
with l as (select id from public.locais_pesca where nome = 'Pesqueiro Lesni Vila')
insert into public.peixes (local_id, nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox)
select l.id, v.* from l cross join (values
  ('Common Roach','Rutilus rutilus','comum','diurno',70,30,'Sêmola, pão, milho (kukuruza), bloodworms, maggots','Vara de boia leve (anzol #10)','08:00','16:00','Meia-água','Pardelha.',true),
  ('European Perch','Perca fluviatilis','comum','ambos',120,30,'Minhocas, spinners pequenos','Spinning leve / boia','06:00','09:00','Próximo a estruturas','Perca europeia. Também ativa ao entardecer (17:00–20:00).',true),
  ('Northern Pike','Esox lucius','comum','ambos',150,30,'Iscas artificiais perto da superfície, colheres (spoons)','Spinning médio com leader de aço','05:00','08:00','Superfície / águas rasas','Lúcio. Pico no amanhecer e entardecer (18:00–20:00).',true),
  ('Silver Bream','Blicca bjoerkna','comum','diurno',70,30,'Bloodworms, maggots','Vara de boia (anzol #10)','08:00','16:00','Fundo / meia-água','Brema-prateada.',true),
  ('Tench','Tinca tinca','comum','diurno',110,30,'Cancer Meat, bloodworms, minhocas, dung worms, sanguessugas','Boia deslizante (slip bobber) no fundo','05:00','08:00','Fundo','Tenca. Mais ativa logo cedo.',true),
  ('Common Carp','Cyprinus carpio','comum','ambos',90,30,'Sêmola, milho, massa (dough), queijo, minhocas','Slip bobber / feeder (linha forte)','04:00','07:00','Fundo','Carpa comum. Também ativa à noite (20:00–23:00). Massa é ótima.',true)
) as v(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,horario_inicio,horario_fim,profundidade,obs,aprox);

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
