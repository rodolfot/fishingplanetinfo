-- =============================================================================
--  Fishing Planet Info — Dados de exemplo para o Supabase (opcional)
--  Rode DEPOIS do schema.sql. Mesma base do seed.js (modo local).
--  Valores da comunidade; campos sem dado confiável ficam NULL para preencher.
-- =============================================================================

insert into public.locais_pesca (nome, regiao, nivel, guia) values
  ('Rio Mudwater', 'Missouri, EUA', 'Nível 1+',
   'Água inicial dos EUA, ótima para missões de bass e panfish. Boia leve com minhoca/maggot para os panfish; iscas artificiais com twitching rápido no amanhecer e entardecer para bass e pickerel.'),
  ('Pesqueiro Lesni Vila', 'República Tcheca', 'Nível 1+ (águas tchecas)',
   'Pesqueiro tcheco para iniciantes. Bloodworm no anzol #10 pega quase todas as espécies. Boias deslizantes (slip bobber) ajudam muito em carpa, tenca e bagre.'),
  ('Emerald Lake', 'Nova York, EUA', 'Nível ~9–20',
   'Lago de NY popular para subir de nível pegando Walleye (lance atrás das vitórias-régias, ~130–160 ft). Golden Shiner pega em qualquer lugar com spinners/spoons/shads. Pike perto das ervas com Shad 2" em stop-and-go.'),
  ('Lone Star Lake', 'Texas, EUA', 'Nível 1+',
   'Lago do Texas com quase uma dúzia de espécies. Minhocas/stink bait pegam bem; Red Worm no anzol #6. Spotted Bass rende bom dinheiro; Channel Catfish é abundante (noite).'),
  ('Quanchkin Lake', 'Louisiana, EUA', 'Nível ~10+',
   'Pântano da Louisiana com predadores grandes. Alligator Gar exige leader de aço e anzol 6/0 com lagostim. Bagres (Channel/Flathead/Blue) à noite. Hotspots de Bowfin para troféu/único.');

-- helper: insere peixes de um local a partir de uma lista VALUES
-- (repetido por local; valor_kg/xp_kg convertidos; NULL onde não há dado)

-- ---- Rio Mudwater ----------------------------------------------------------
insert into public.peixes (local_id, nome, nome_cientifico, raridade, periodo, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
select l.id, x.nome, x.nome_cientifico, x.raridade, x.periodo, x.valor_kg::numeric, x.xp_kg::int, x.isca, x.tipo_vara, x.hi, x.hf, x.prof, x.obs
from public.locais_pesca l, (values
  ('Black Bass','Micropterus salmoides','jovem','ambos',118,16,'Iscas artificiais (spinnerbait, soft plastic, crankbait)','Spinning/Casting leve (linha 5–10 lb)','05:00','07:00','Margens e vegetação','Twitching rápido também rende ao entardecer (18:00–19:00).'),
  ('Esox Vermiculatus','Esox americanus vermiculatus','comum','ambos',161,60,'Spinners pequenos / iscas artificiais','Spinning leve','05:00','07:00','Águas rasas com vegetação','Predador agressivo; recolhimento com paradas.'),
  ('Esox Vermiculatus','Esox americanus vermiculatus','troféu','ambos',182,111,'Spinners pequenos / iscas artificiais','Spinning leve','05:00','07:00','Águas rasas com vegetação','Exemplares troféu rendem bem mais XP.'),
  ('Pomoxis Annularis','Pomoxis annularis','comum','diurno',100,54,'Minhocas / maggots / jigs pequenos','Vara de boia (OmniFloat 450, anzol #8)','06:00','10:00','Meia-água','White Crappie. Cardume — fisgue vários no mesmo ponto.'),
  ('Pomoxis Annularis','Pomoxis annularis','troféu','diurno',149,71,'Minhocas / maggots / jigs pequenos','Vara de boia (anzol #8)','06:00','10:00','Meia-água',null),
  ('Bluegill','Lepomis macrochirus','comum','diurno',null,null,'Minhocas, maggots','Boia leve (anzol #8–10)','08:00','17:00','Margens rasas','Panfish abundante; ótimo para missões iniciais.'),
  ('Pumpkinseed','Lepomis gibbosus','comum','diurno',null,null,'Minhocas, maggots','Boia leve (anzol #10)','08:00','17:00','Margens rasas',null),
  ('Bowfin','Amia calva','comum','ambos',null,null,'Isca cortada / minhocão no fundo','Bottom/feeder (linha 5–10 lb)','06:00','09:00','Fundo','Briga muito forte; pode passar de 2 kg.'),
  ('Channel Catfish','Ictalurus punctatus','troféu','noturno',null,null,'Isca cortada, fígado de galinha','Bottom/feeder reforçado','21:00','02:00','Fundo, canais','Troféu passa de 5 kg (12+ lb). Pesca noturna.')
) as x(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,hi,hf,prof,obs)
where l.nome = 'Rio Mudwater';

-- ---- Pesqueiro Lesni Vila --------------------------------------------------
insert into public.peixes (local_id, nome, nome_cientifico, raridade, periodo, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
select l.id, x.nome, x.nome_cientifico, x.raridade, x.periodo, x.valor_kg::numeric, x.xp_kg::int, x.isca, x.tipo_vara, x.hi, x.hf, x.prof, x.obs
from public.locais_pesca l, (values
  ('Common Roach','Rutilus rutilus','comum','diurno',null::numeric,null::int,'Sêmola, pão, milho (kukuruza), bloodworms, maggots','Vara de boia leve (anzol #10)','08:00','16:00','Meia-água','Pardelha.'),
  ('European Perch','Perca fluviatilis','comum','ambos',null,null,'Minhocas, spinners pequenos','Spinning leve / boia','06:00','09:00','Próximo a estruturas','Perca europeia. Também ativa ao entardecer (17:00–20:00).'),
  ('Northern Pike','Esox lucius','comum','ambos',null,null,'Iscas artificiais perto da superfície, colheres (spoons)','Spinning médio com leader de aço','05:00','08:00','Superfície / águas rasas','Lúcio. Pico no amanhecer e entardecer (18:00–20:00).'),
  ('Silver Bream','Blicca bjoerkna','comum','diurno',null,null,'Bloodworms, maggots','Vara de boia (anzol #10)','08:00','16:00','Fundo / meia-água','Brema-prateada.'),
  ('Tench','Tinca tinca','comum','diurno',null,null,'Cancer Meat, bloodworms, minhocas, dung worms, sanguessugas','Boia deslizante (slip bobber) no fundo','05:00','08:00','Fundo','Tenca. Mais ativa logo cedo.'),
  ('Common Carp','Cyprinus carpio','comum','ambos',null,null,'Sêmola, milho, massa (dough), queijo, minhocas','Slip bobber / feeder (linha forte)','04:00','07:00','Fundo','Carpa comum. Também ativa à noite (20:00–23:00). Massa é ótima.')
) as x(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,hi,hf,prof,obs)
where l.nome = 'Pesqueiro Lesni Vila';

-- ---- Emerald Lake ----------------------------------------------------------
insert into public.peixes (local_id, nome, nome_cientifico, raridade, periodo, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
select l.id, x.nome, x.nome_cientifico, x.raridade, x.periodo, x.valor_kg::numeric, x.xp_kg::int, x.isca, x.tipo_vara, x.hi, x.hf, x.prof, x.obs
from public.locais_pesca l, (values
  ('Walleye','Sander vitreus','comum','noturno',null::numeric,null::int,'Jigs, crankbaits fundos, shads','Spinning/Casting médio','21:00','04:00','Fundo, atrás das vitórias-régias (130–160 ft)','Bom alvo de XP/valor; melhor com pouca luz.'),
  ('Northern Pike','Esox lucius','comum','ambos',null,null,'Shad 2", colher de casting média','Spinning médio com leader de aço','05:00','08:00','Perto das ervas','Stop-and-go / lift-and-drop perto da Dock of Peace.'),
  ('Black Crappie','Pomoxis nigromaculatus','comum','diurno',null,null,'Boia com isca de panfish (leader 30")','Vara de boia leve','07:00','11:00','Meia-água','Use iscas que mirem só panfish.'),
  ('Yellow Perch','Perca flavescens','comum','diurno',null,null,'Minhocas, spinners pequenos','Boia / spinning leve','07:00','11:00','Próximo a estruturas',null),
  ('Grass Pickerel','Esox americanus vermiculatus','comum','ambos',null,null,'Spinners pequenos','Spinning leve','05:00','08:00','Vegetação rasa',null),
  ('Golden Shiner','Notemigonus crysoleucas','comum','diurno',null,null,'Spinners, spoons, shads (reel médio / #2)','Spinning leve','08:00','16:00','Meia-água','Isca-viva valiosa; pega em qualquer ponto do lago.')
) as x(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,hi,hf,prof,obs)
where l.nome = 'Emerald Lake';

-- ---- Lone Star Lake --------------------------------------------------------
insert into public.peixes (local_id, nome, nome_cientifico, raridade, periodo, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
select l.id, x.nome, x.nome_cientifico, x.raridade, x.periodo, x.valor_kg::numeric, x.xp_kg::int, x.isca, x.tipo_vara, x.hi, x.hf, x.prof, x.obs
from public.locais_pesca l, (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',null::numeric,null::int,'Iscas artificiais, minhocas','Casting médio (5–10 lb)','05:00','08:00','Vegetação e margens','Pode passar de 4 kg; briga forte.'),
  ('Spotted Bass','Micropterus punctulatus','comum','ambos',null,null,'Iscas artificiais, minhocas','Spinning médio','05:00','08:00','Estruturas','Melhor para dinheiro (~100 por exemplar de ~2 lb).'),
  ('Bluegill','Lepomis macrochirus','comum','diurno',null,null,'Minhocas, Red Worm (anzol #6)','Boia leve','08:00','17:00','Margens rasas',null),
  ('Redear Sunfish','Lepomis microlophus','comum','diurno',null,null,'Minhocas','Boia leve','08:00','17:00','Fundo raso',null),
  ('Black Crappie','Pomoxis nigromaculatus','comum','diurno',null,null,'Jigs pequenos, minhocas','Vara de boia leve','07:00','11:00','Meia-água',null),
  ('Smallmouth Buffalo','Ictiobus bubalus','comum','diurno',null,null,'Massa, minhocas no fundo','Feeder / bottom','08:00','16:00','Fundo',null),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',null,null,'Stink bait, isca cortada','Bottom/feeder','21:00','03:00','Fundo','Muito abundante; bom para grind noturno.'),
  ('Walleye','Sander vitreus','comum','noturno',null,null,'Jigs, crankbaits','Spinning médio','21:00','04:00','Fundo','Melhor com pouca luz.')
) as x(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,hi,hf,prof,obs)
where l.nome = 'Lone Star Lake';

-- ---- Quanchkin Lake --------------------------------------------------------
insert into public.peixes (local_id, nome, nome_cientifico, raridade, periodo, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
select l.id, x.nome, x.nome_cientifico, x.raridade, x.periodo, x.valor_kg::numeric, x.xp_kg::int, x.isca, x.tipo_vara, x.hi, x.hf, x.prof, x.obs
from public.locais_pesca l, (values
  ('Largemouth Bass','Micropterus salmoides','comum','ambos',null::numeric,null::int,'Iscas artificiais','Casting médio','05:00','08:00','Vegetação',null),
  ('Spotted Bass','Micropterus punctulatus','comum','ambos',null,null,'Iscas artificiais','Spinning médio','05:00','08:00','Estruturas',null),
  ('Bowfin','Amia calva','troféu','ambos',null,null,'Isca cortada / lagostim no fundo','Bottom reforçado (com leader)','06:00','10:00','Fundo, vegetação','Hotspots conhecidos para troféu/único. Briga muito forte.'),
  ('Channel Catfish','Ictalurus punctatus','comum','noturno',null,null,'Isca cortada','Bottom/feeder','21:00','03:00','Fundo',null),
  ('Flathead Catfish','Pylodictis olivaris','comum','noturno',null,null,'Isca-viva, peixe cortado','Bottom pesado','21:00','03:00','Fundo, canais','Pode ficar enorme.'),
  ('Blue Catfish','Ictalurus furcatus','comum','noturno',null,null,'Isca cortada','Bottom pesado','21:00','03:00','Fundo',null),
  ('Alligator Gar','Atractosteus spatula','troféu','ambos',null,null,'Lagostim (anzol 6/0, leader de aço)','Casting pesado','18:00','23:00','Superfície / meia-água','Predador gigante; leader de aço obrigatório.')
) as x(nome,nome_cientifico,raridade,periodo,valor_kg,xp_kg,isca,tipo_vara,hi,hf,prof,obs)
where l.nome = 'Quanchkin Lake';
