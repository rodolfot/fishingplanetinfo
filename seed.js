// =============================================================================
//  Dados de exemplo (seed) — Fishing Planet
//  Compilado de pesquisa na comunidade (Fishing Planet Wiki, guias Steam/YouTube).
//  Valores em US$/kg e XP/kg são da comunidade; onde não há dado confiável o
//  campo fica em branco para ser preenchido por quem joga. Colabore e corrija!
//
//  Estrutura espelha as tabelas do Supabase (locais_pesca / peixes).
//  raridade: "comum" | "jovem" | "troféu" (extensível)
//  horario_inicio / horario_fim: "HH:MM" no relógio do jogo (24h)
// =============================================================================

export const SEED = [
  {
    nome: "Rio Mudwater",
    regiao: "Missouri, EUA",
    peixes: [
      {
        nome: "Black Bass", nome_cientifico: "Micropterus salmoides",
        raridade: "jovem", valor_kg: 118, xp_kg: 16,
        isca: "Iscas artificiais (spinnerbait, soft plastic, crankbait)",
        tipo_vara: "Spinning/Casting leve (linha 5–10 lb)",
        horario_inicio: "05:00", horario_fim: "07:00",
        profundidade: "Margens e vegetação",
        obs: "Twitching rápido funciona bem no amanhecer e novamente ao entardecer (18:00–19:00).",
      },
      {
        nome: "Esox Vermiculatus", nome_cientifico: "Esox americanus vermiculatus",
        raridade: "comum", valor_kg: 161, xp_kg: 60,
        isca: "Spinners pequenos / iscas artificiais",
        tipo_vara: "Spinning leve",
        horario_inicio: "05:00", horario_fim: "07:00",
        profundidade: "Águas rasas com vegetação",
        obs: "Predador agressivo; recolhimento com paradas.",
      },
      {
        nome: "Esox Vermiculatus", nome_cientifico: "Esox americanus vermiculatus",
        raridade: "troféu", valor_kg: 182, xp_kg: 111,
        isca: "Spinners pequenos / iscas artificiais",
        tipo_vara: "Spinning leve",
        horario_inicio: "05:00", horario_fim: "07:00",
        profundidade: "Águas rasas com vegetação",
        obs: "Exemplares troféu rendem bem mais XP.",
      },
      {
        nome: "Pomoxis Annularis", nome_cientifico: "Pomoxis annularis",
        raridade: "comum", valor_kg: 100, xp_kg: 54,
        isca: "Minhocas / maggots / jigs pequenos",
        tipo_vara: "Vara de boia (OmniFloat 450, anzol #8)",
        horario_inicio: "06:00", horario_fim: "10:00",
        profundidade: "Meia-água",
        obs: "White Crappie. Cardume — fisgue vários no mesmo ponto.",
      },
      {
        nome: "Pomoxis Annularis", nome_cientifico: "Pomoxis annularis",
        raridade: "troféu", valor_kg: 149, xp_kg: 71,
        isca: "Minhocas / maggots / jigs pequenos",
        tipo_vara: "Vara de boia (anzol #8)",
        horario_inicio: "06:00", horario_fim: "10:00",
        profundidade: "Meia-água",
        obs: "",
      },
      {
        nome: "Bluegill", nome_cientifico: "Lepomis macrochirus",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Minhocas, maggots",
        tipo_vara: "Boia leve (anzol #8–10)",
        horario_inicio: "08:00", horario_fim: "17:00",
        profundidade: "Margens rasas",
        obs: "Panfish abundante; ótimo para missões iniciais.",
      },
      {
        nome: "Pumpkinseed", nome_cientifico: "Lepomis gibbosus",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Minhocas, maggots",
        tipo_vara: "Boia leve (anzol #10)",
        horario_inicio: "08:00", horario_fim: "17:00",
        profundidade: "Margens rasas",
        obs: "",
      },
      {
        nome: "Bowfin", nome_cientifico: "Amia calva",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Isca cortada / minhocão no fundo",
        tipo_vara: "Bottom/feeder (linha 5–10 lb)",
        horario_inicio: "06:00", horario_fim: "09:00",
        profundidade: "Fundo",
        obs: "Briga muito forte; pode passar de 2 kg.",
      },
      {
        nome: "Channel Catfish", nome_cientifico: "Ictalurus punctatus",
        raridade: "troféu", valor_kg: null, xp_kg: null,
        isca: "Isca cortada, fígado de galinha",
        tipo_vara: "Bottom/feeder reforçado",
        horario_inicio: "21:00", horario_fim: "02:00",
        profundidade: "Fundo, canais",
        obs: "Troféu passa de 5 kg (12+ lb). Pesca noturna.",
      },
    ],
  },
  {
    nome: "Pesqueiro Lesni Vila",
    regiao: "República Tcheca",
    peixes: [
      {
        nome: "Common Roach", nome_cientifico: "Rutilus rutilus",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Sêmola, pão, milho (kukuruza), bloodworms, maggots",
        tipo_vara: "Vara de boia leve (anzol #10)",
        horario_inicio: "08:00", horario_fim: "16:00",
        profundidade: "Meia-água",
        obs: "Pardelha. Bloodworm no anzol #10 pega quase tudo no local.",
      },
      {
        nome: "European Perch", nome_cientifico: "Perca fluviatilis",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Minhocas, spinners pequenos",
        tipo_vara: "Spinning leve / boia",
        horario_inicio: "06:00", horario_fim: "09:00",
        profundidade: "Próximo a estruturas",
        obs: "Perca europeia. Também ativa ao entardecer (17:00–20:00).",
      },
      {
        nome: "Northern Pike", nome_cientifico: "Esox lucius",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Iscas artificiais perto da superfície, colheres (spoons)",
        tipo_vara: "Spinning médio com leader de aço",
        horario_inicio: "05:00", horario_fim: "08:00",
        profundidade: "Superfície / águas rasas",
        obs: "Lúcio. Pico no amanhecer e entardecer (18:00–20:00).",
      },
      {
        nome: "Silver Bream", nome_cientifico: "Blicca bjoerkna",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Bloodworms, maggots",
        tipo_vara: "Vara de boia (anzol #10)",
        horario_inicio: "08:00", horario_fim: "16:00",
        profundidade: "Fundo / meia-água",
        obs: "Brema-prateada.",
      },
      {
        nome: "Tench", nome_cientifico: "Tinca tinca",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Cancer Meat, bloodworms, minhocas, dung worms, sanguessugas",
        tipo_vara: "Boia deslizante (slip bobber) no fundo",
        horario_inicio: "05:00", horario_fim: "08:00",
        profundidade: "Fundo",
        obs: "Tenca. Boias deslizantes ajudam muito aqui.",
      },
      {
        nome: "Common Carp", nome_cientifico: "Cyprinus carpio",
        raridade: "comum", valor_kg: null, xp_kg: null,
        isca: "Sêmola, milho, massa (dough), queijo, minhocas",
        tipo_vara: "Slip bobber / feeder (linha forte)",
        horario_inicio: "04:00", horario_fim: "07:00",
        profundidade: "Fundo",
        obs: "Carpa comum. Também ativa à noite (20:00–23:00). Massa é ótima.",
      },
    ],
  },
];
