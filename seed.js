// =============================================================================
//  Dados de exemplo (seed) — Fishing Planet
//  Compilado de pesquisa na comunidade (Fishing Planet Wiki, guias Steam/YouTube).
//  Valores em US$/kg e XP/kg são da comunidade; onde não há dado confiável o
//  campo fica em branco para ser preenchido por quem joga. Colabore e corrija!
//
//  Estrutura espelha as tabelas do Supabase (locais_pesca / peixes).
//    raridade: "comum" | "jovem" | "troféu" (extensível)
//    periodo:  "diurno" | "noturno" | "ambos"  (melhor período de captura)
//    horario_inicio / horario_fim: "HH:MM" no relógio do jogo (24h)
//    locais: nivel (nível/licença recomendada) e guia (dicas do local)
// =============================================================================

export const SEED = [
  {
    nome: "Rio Mudwater",
    regiao: "Missouri, EUA",
    nivel: "Nível 1+",
    guia: "Água inicial dos EUA, ótima para missões de bass e panfish. Boia leve com minhoca/maggot para os panfish; iscas artificiais com twitching rápido no amanhecer e entardecer para bass e pickerel.",
    peixes: [
      { nome: "Black Bass", nome_cientifico: "Micropterus salmoides", raridade: "jovem", periodo: "ambos", valor_kg: 118, xp_kg: 16, isca: "Iscas artificiais (spinnerbait, soft plastic, crankbait)", tipo_vara: "Spinning/Casting leve (linha 5–10 lb)", horario_inicio: "05:00", horario_fim: "07:00", profundidade: "Margens e vegetação", obs: "Twitching rápido também rende ao entardecer (18:00–19:00)." },
      { nome: "Esox Vermiculatus", nome_cientifico: "Esox americanus vermiculatus", raridade: "comum", periodo: "ambos", valor_kg: 161, xp_kg: 60, isca: "Spinners pequenos / iscas artificiais", tipo_vara: "Spinning leve", horario_inicio: "05:00", horario_fim: "07:00", profundidade: "Águas rasas com vegetação", obs: "Predador agressivo; recolhimento com paradas." },
      { nome: "Esox Vermiculatus", nome_cientifico: "Esox americanus vermiculatus", raridade: "troféu", periodo: "ambos", valor_kg: 182, xp_kg: 111, isca: "Spinners pequenos / iscas artificiais", tipo_vara: "Spinning leve", horario_inicio: "05:00", horario_fim: "07:00", profundidade: "Águas rasas com vegetação", obs: "Exemplares troféu rendem bem mais XP." },
      { nome: "Pomoxis Annularis", nome_cientifico: "Pomoxis annularis", raridade: "comum", periodo: "diurno", valor_kg: 100, xp_kg: 54, isca: "Minhocas / maggots / jigs pequenos", tipo_vara: "Vara de boia (OmniFloat 450, anzol #8)", horario_inicio: "06:00", horario_fim: "10:00", profundidade: "Meia-água", obs: "White Crappie. Cardume — fisgue vários no mesmo ponto." },
      { nome: "Pomoxis Annularis", nome_cientifico: "Pomoxis annularis", raridade: "troféu", periodo: "diurno", valor_kg: 149, xp_kg: 71, isca: "Minhocas / maggots / jigs pequenos", tipo_vara: "Vara de boia (anzol #8)", horario_inicio: "06:00", horario_fim: "10:00", profundidade: "Meia-água", obs: "" },
      { nome: "Bluegill", nome_cientifico: "Lepomis macrochirus", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Minhocas, maggots", tipo_vara: "Boia leve (anzol #8–10)", horario_inicio: "08:00", horario_fim: "17:00", profundidade: "Margens rasas", obs: "Panfish abundante; ótimo para missões iniciais." },
      { nome: "Pumpkinseed", nome_cientifico: "Lepomis gibbosus", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Minhocas, maggots", tipo_vara: "Boia leve (anzol #10)", horario_inicio: "08:00", horario_fim: "17:00", profundidade: "Margens rasas", obs: "" },
      { nome: "Bowfin", nome_cientifico: "Amia calva", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Isca cortada / minhocão no fundo", tipo_vara: "Bottom/feeder (linha 5–10 lb)", horario_inicio: "06:00", horario_fim: "09:00", profundidade: "Fundo", obs: "Briga muito forte; pode passar de 2 kg." },
      { nome: "Channel Catfish", nome_cientifico: "Ictalurus punctatus", raridade: "troféu", periodo: "noturno", valor_kg: null, xp_kg: null, isca: "Isca cortada, fígado de galinha", tipo_vara: "Bottom/feeder reforçado", horario_inicio: "21:00", horario_fim: "02:00", profundidade: "Fundo, canais", obs: "Troféu passa de 5 kg (12+ lb). Pesca noturna." },
    ],
  },
  {
    nome: "Pesqueiro Lesni Vila",
    regiao: "República Tcheca",
    nivel: "Nível 1+ (águas tchecas)",
    guia: "Pesqueiro tcheco para iniciantes. Bloodworm no anzol #10 pega quase todas as espécies. Boias deslizantes (slip bobber) ajudam muito em carpa, tenca e bagre.",
    peixes: [
      { nome: "Common Roach", nome_cientifico: "Rutilus rutilus", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Sêmola, pão, milho (kukuruza), bloodworms, maggots", tipo_vara: "Vara de boia leve (anzol #10)", horario_inicio: "08:00", horario_fim: "16:00", profundidade: "Meia-água", obs: "Pardelha." },
      { nome: "European Perch", nome_cientifico: "Perca fluviatilis", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Minhocas, spinners pequenos", tipo_vara: "Spinning leve / boia", horario_inicio: "06:00", horario_fim: "09:00", profundidade: "Próximo a estruturas", obs: "Perca europeia. Também ativa ao entardecer (17:00–20:00)." },
      { nome: "Northern Pike", nome_cientifico: "Esox lucius", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Iscas artificiais perto da superfície, colheres (spoons)", tipo_vara: "Spinning médio com leader de aço", horario_inicio: "05:00", horario_fim: "08:00", profundidade: "Superfície / águas rasas", obs: "Lúcio. Pico no amanhecer e entardecer (18:00–20:00)." },
      { nome: "Silver Bream", nome_cientifico: "Blicca bjoerkna", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Bloodworms, maggots", tipo_vara: "Vara de boia (anzol #10)", horario_inicio: "08:00", horario_fim: "16:00", profundidade: "Fundo / meia-água", obs: "Brema-prateada." },
      { nome: "Tench", nome_cientifico: "Tinca tinca", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Cancer Meat, bloodworms, minhocas, dung worms, sanguessugas", tipo_vara: "Boia deslizante (slip bobber) no fundo", horario_inicio: "05:00", horario_fim: "08:00", profundidade: "Fundo", obs: "Tenca. Mais ativa logo cedo." },
      { nome: "Common Carp", nome_cientifico: "Cyprinus carpio", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Sêmola, milho, massa (dough), queijo, minhocas", tipo_vara: "Slip bobber / feeder (linha forte)", horario_inicio: "04:00", horario_fim: "07:00", profundidade: "Fundo", obs: "Carpa comum. Também ativa à noite (20:00–23:00). Massa é ótima." },
    ],
  },
  {
    nome: "Emerald Lake",
    regiao: "Nova York, EUA",
    nivel: "Nível ~9–20",
    guia: "Lago de NY popular para subir de nível pegando Walleye (lance atrás das vitórias-régias, ~130–160 ft). Golden Shiner pega em qualquer lugar com spinners/spoons/shads. Pike perto das ervas com Shad 2\" em stop-and-go (Dock of Peace).",
    peixes: [
      { nome: "Walleye", nome_cientifico: "Sander vitreus", raridade: "comum", periodo: "noturno", valor_kg: null, xp_kg: null, isca: "Jigs, crankbaits fundos, shads", tipo_vara: "Spinning/Casting médio", horario_inicio: "21:00", horario_fim: "04:00", profundidade: "Fundo, atrás das vitórias-régias (130–160 ft)", obs: "Bom alvo de XP/valor; melhor com pouca luz." },
      { nome: "Northern Pike", nome_cientifico: "Esox lucius", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Shad 2\", colher de casting média", tipo_vara: "Spinning médio com leader de aço", horario_inicio: "05:00", horario_fim: "08:00", profundidade: "Perto das ervas", obs: "Stop-and-go / lift-and-drop perto da Dock of Peace." },
      { nome: "Black Crappie", nome_cientifico: "Pomoxis nigromaculatus", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Boia com isca de panfish (leader 30\")", tipo_vara: "Vara de boia leve", horario_inicio: "07:00", horario_fim: "11:00", profundidade: "Meia-água", obs: "Use iscas que mirem só panfish." },
      { nome: "Yellow Perch", nome_cientifico: "Perca flavescens", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Minhocas, spinners pequenos", tipo_vara: "Boia / spinning leve", horario_inicio: "07:00", horario_fim: "11:00", profundidade: "Próximo a estruturas", obs: "" },
      { nome: "Grass Pickerel", nome_cientifico: "Esox americanus vermiculatus", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Spinners pequenos", tipo_vara: "Spinning leve", horario_inicio: "05:00", horario_fim: "08:00", profundidade: "Vegetação rasa", obs: "" },
      { nome: "Golden Shiner", nome_cientifico: "Notemigonus crysoleucas", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Spinners, spoons, shads (reel médio / #2)", tipo_vara: "Spinning leve", horario_inicio: "08:00", horario_fim: "16:00", profundidade: "Meia-água", obs: "Isca-viva valiosa; pega em qualquer ponto do lago." },
    ],
  },
  {
    nome: "Lone Star Lake",
    regiao: "Texas, EUA",
    nivel: "Nível 1+",
    guia: "Lago do Texas com quase uma dúzia de espécies. Minhocas/stink bait pegam bem; Red Worm no anzol #6. Spotted Bass rende bom dinheiro; Channel Catfish é abundante (noite).",
    peixes: [
      { nome: "Largemouth Bass", nome_cientifico: "Micropterus salmoides", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Iscas artificiais, minhocas", tipo_vara: "Casting médio (5–10 lb)", horario_inicio: "05:00", horario_fim: "08:00", profundidade: "Vegetação e margens", obs: "Pode passar de 4 kg; briga forte." },
      { nome: "Spotted Bass", nome_cientifico: "Micropterus punctulatus", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Iscas artificiais, minhocas", tipo_vara: "Spinning médio", horario_inicio: "05:00", horario_fim: "08:00", profundidade: "Estruturas", obs: "Melhor para dinheiro (~100 por exemplar de ~2 lb)." },
      { nome: "Bluegill", nome_cientifico: "Lepomis macrochirus", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Minhocas, Red Worm (anzol #6)", tipo_vara: "Boia leve", horario_inicio: "08:00", horario_fim: "17:00", profundidade: "Margens rasas", obs: "" },
      { nome: "Redear Sunfish", nome_cientifico: "Lepomis microlophus", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Minhocas", tipo_vara: "Boia leve", horario_inicio: "08:00", horario_fim: "17:00", profundidade: "Fundo raso", obs: "" },
      { nome: "Black Crappie", nome_cientifico: "Pomoxis nigromaculatus", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Jigs pequenos, minhocas", tipo_vara: "Vara de boia leve", horario_inicio: "07:00", horario_fim: "11:00", profundidade: "Meia-água", obs: "" },
      { nome: "Smallmouth Buffalo", nome_cientifico: "Ictiobus bubalus", raridade: "comum", periodo: "diurno", valor_kg: null, xp_kg: null, isca: "Massa, minhocas no fundo", tipo_vara: "Feeder / bottom", horario_inicio: "08:00", horario_fim: "16:00", profundidade: "Fundo", obs: "" },
      { nome: "Channel Catfish", nome_cientifico: "Ictalurus punctatus", raridade: "comum", periodo: "noturno", valor_kg: null, xp_kg: null, isca: "Stink bait, isca cortada", tipo_vara: "Bottom/feeder", horario_inicio: "21:00", horario_fim: "03:00", profundidade: "Fundo", obs: "Muito abundante; bom para grind noturno." },
      { nome: "Walleye", nome_cientifico: "Sander vitreus", raridade: "comum", periodo: "noturno", valor_kg: null, xp_kg: null, isca: "Jigs, crankbaits", tipo_vara: "Spinning médio", horario_inicio: "21:00", horario_fim: "04:00", profundidade: "Fundo", obs: "Melhor com pouca luz." },
    ],
  },
  {
    nome: "Quanchkin Lake",
    regiao: "Louisiana, EUA",
    nivel: "Nível ~10+",
    guia: "Pântano da Louisiana com predadores grandes. Alligator Gar exige leader de aço e anzol 6/0 com lagostim. Bagres (Channel/Flathead/Blue) à noite. Hotspots de Bowfin para troféu/único.",
    peixes: [
      { nome: "Largemouth Bass", nome_cientifico: "Micropterus salmoides", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Iscas artificiais", tipo_vara: "Casting médio", horario_inicio: "05:00", horario_fim: "08:00", profundidade: "Vegetação", obs: "" },
      { nome: "Spotted Bass", nome_cientifico: "Micropterus punctulatus", raridade: "comum", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Iscas artificiais", tipo_vara: "Spinning médio", horario_inicio: "05:00", horario_fim: "08:00", profundidade: "Estruturas", obs: "" },
      { nome: "Bowfin", nome_cientifico: "Amia calva", raridade: "troféu", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Isca cortada / lagostim no fundo", tipo_vara: "Bottom reforçado (com leader)", horario_inicio: "06:00", horario_fim: "10:00", profundidade: "Fundo, vegetação", obs: "Hotspots conhecidos para troféu/único. Briga muito forte." },
      { nome: "Channel Catfish", nome_cientifico: "Ictalurus punctatus", raridade: "comum", periodo: "noturno", valor_kg: null, xp_kg: null, isca: "Isca cortada", tipo_vara: "Bottom/feeder", horario_inicio: "21:00", horario_fim: "03:00", profundidade: "Fundo", obs: "" },
      { nome: "Flathead Catfish", nome_cientifico: "Pylodictis olivaris", raridade: "comum", periodo: "noturno", valor_kg: null, xp_kg: null, isca: "Isca-viva, peixe cortado", tipo_vara: "Bottom pesado", horario_inicio: "21:00", horario_fim: "03:00", profundidade: "Fundo, canais", obs: "Pode ficar enorme." },
      { nome: "Blue Catfish", nome_cientifico: "Ictalurus furcatus", raridade: "comum", periodo: "noturno", valor_kg: null, xp_kg: null, isca: "Isca cortada", tipo_vara: "Bottom pesado", horario_inicio: "21:00", horario_fim: "03:00", profundidade: "Fundo", obs: "" },
      { nome: "Alligator Gar", nome_cientifico: "Atractosteus spatula", raridade: "troféu", periodo: "ambos", valor_kg: null, xp_kg: null, isca: "Lagostim (anzol 6/0, leader de aço)", tipo_vara: "Casting pesado", horario_inicio: "18:00", horario_fim: "23:00", profundidade: "Superfície / meia-água", obs: "Predador gigante; leader de aço obrigatório." },
    ],
  },
];
