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
