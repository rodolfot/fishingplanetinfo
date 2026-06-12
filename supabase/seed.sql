-- =============================================================================
--  Fishing Planet Info — Dados de exemplo para o Supabase (opcional)
--  Rode DEPOIS do schema.sql. Mesma base do seed.js (modo local).
--  Valores da comunidade; campos sem dado confiável ficam NULL para preencher.
-- =============================================================================

insert into public.locais_pesca (nome, regiao) values
  ('Rio Mudwater', 'Missouri, EUA'),
  ('Pesqueiro Lesni Vila', 'República Tcheca');

-- ---- Rio Mudwater ----------------------------------------------------------
insert into public.peixes
  (local_id, nome, nome_cientifico, raridade, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
select l.id, x.nome, x.nome_cientifico, x.raridade, x.valor_kg::numeric, x.xp_kg::int,
       x.isca, x.tipo_vara, x.horario_inicio, x.horario_fim, x.profundidade, x.obs
from public.locais_pesca l,
(values
  ('Black Bass','Micropterus salmoides','jovem',118,16,'Iscas artificiais (spinnerbait, soft plastic, crankbait)','Spinning/Casting leve (linha 5–10 lb)','05:00','07:00','Margens e vegetação','Twitching rápido funciona bem no amanhecer e ao entardecer (18:00–19:00).'),
  ('Esox Vermiculatus','Esox americanus vermiculatus','comum',161,60,'Spinners pequenos / iscas artificiais','Spinning leve','05:00','07:00','Águas rasas com vegetação','Predador agressivo; recolhimento com paradas.'),
  ('Esox Vermiculatus','Esox americanus vermiculatus','troféu',182,111,'Spinners pequenos / iscas artificiais','Spinning leve','05:00','07:00','Águas rasas com vegetação','Exemplares troféu rendem bem mais XP.'),
  ('Pomoxis Annularis','Pomoxis annularis','comum',100,54,'Minhocas / maggots / jigs pequenos','Vara de boia (OmniFloat 450, anzol #8)','06:00','10:00','Meia-água','White Crappie. Cardume — fisgue vários no mesmo ponto.'),
  ('Pomoxis Annularis','Pomoxis annularis','troféu',149,71,'Minhocas / maggots / jigs pequenos','Vara de boia (anzol #8)','06:00','10:00','Meia-água',null),
  ('Bluegill','Lepomis macrochirus','comum',null,null,'Minhocas, maggots','Boia leve (anzol #8–10)','08:00','17:00','Margens rasas','Panfish abundante; ótimo para missões iniciais.'),
  ('Pumpkinseed','Lepomis gibbosus','comum',null,null,'Minhocas, maggots','Boia leve (anzol #10)','08:00','17:00','Margens rasas',null),
  ('Bowfin','Amia calva','comum',null,null,'Isca cortada / minhocão no fundo','Bottom/feeder (linha 5–10 lb)','06:00','09:00','Fundo','Briga muito forte; pode passar de 2 kg.'),
  ('Channel Catfish','Ictalurus punctatus','troféu',null,null,'Isca cortada, fígado de galinha','Bottom/feeder reforçado','21:00','02:00','Fundo, canais','Troféu passa de 5 kg (12+ lb). Pesca noturna.')
) as x(nome, nome_cientifico, raridade, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
where l.nome = 'Rio Mudwater';

-- ---- Pesqueiro Lesni Vila --------------------------------------------------
insert into public.peixes
  (local_id, nome, nome_cientifico, raridade, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
select l.id, x.nome, x.nome_cientifico, x.raridade, x.valor_kg::numeric, x.xp_kg::int,
       x.isca, x.tipo_vara, x.horario_inicio, x.horario_fim, x.profundidade, x.obs
from public.locais_pesca l,
(values
  ('Common Roach','Rutilus rutilus','comum',null::numeric,null::int,'Sêmola, pão, milho (kukuruza), bloodworms, maggots','Vara de boia leve (anzol #10)','08:00','16:00','Meia-água','Pardelha. Bloodworm no anzol #10 pega quase tudo no local.'),
  ('European Perch','Perca fluviatilis','comum',null,null,'Minhocas, spinners pequenos','Spinning leve / boia','06:00','09:00','Próximo a estruturas','Perca europeia. Também ativa ao entardecer (17:00–20:00).'),
  ('Northern Pike','Esox lucius','comum',null,null,'Iscas artificiais perto da superfície, colheres (spoons)','Spinning médio com leader de aço','05:00','08:00','Superfície / águas rasas','Lúcio. Pico no amanhecer e entardecer (18:00–20:00).'),
  ('Silver Bream','Blicca bjoerkna','comum',null,null,'Bloodworms, maggots','Vara de boia (anzol #10)','08:00','16:00','Fundo / meia-água','Brema-prateada.'),
  ('Tench','Tinca tinca','comum',null,null,'Cancer Meat, bloodworms, minhocas, dung worms, sanguessugas','Boia deslizante (slip bobber) no fundo','05:00','08:00','Fundo','Tenca. Boias deslizantes ajudam muito aqui.'),
  ('Common Carp','Cyprinus carpio','comum',null,null,'Sêmola, milho, massa (dough), queijo, minhocas','Slip bobber / feeder (linha forte)','04:00','07:00','Fundo','Carpa comum. Também ativa à noite (20:00–23:00). Massa é ótima.')
) as x(nome, nome_cientifico, raridade, valor_kg, xp_kg, isca, tipo_vara, horario_inicio, horario_fim, profundidade, obs)
where l.nome = 'Pesqueiro Lesni Vila';
