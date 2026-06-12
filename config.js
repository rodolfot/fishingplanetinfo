// =============================================================================
//  Configuração do backend colaborativo (Supabase)
//
//  • Deixe os dois valores VAZIOS  -> o site roda em MODO LOCAL (localStorage,
//    só neste navegador). Funciona na hora, sem instalar nada.
//
//  • Preencha os dois valores       -> o site roda em MODO COLABORATIVO: todos
//    veem e editam os mesmos dados (igual ao fishingplanetvalores.netlify.app).
//
//  Como obter:
//    1. Crie um projeto grátis em https://supabase.com
//    2. Rode o SQL de  supabase/schema.sql  (e, opcional, supabase/seed.sql)
//       no SQL Editor do projeto.
//    3. Em Project Settings -> API, copie a "Project URL" e a chave "anon public".
//    4. Cole abaixo. A chave anon é pública por design (protegida por RLS).
//
//  Dica: para apontar para um projeto já existente, basta trocar os valores.
// =============================================================================

// Projeto Supabase reaproveitado (o mesmo do fishingplanetvalores).
// A chave anon é pública por design (vai no front-end), protegida pelo RLS.
// IMPORTANTE: rode supabase/schema.sql neste projeto ANTES (adiciona as colunas
// novas sem apagar dados). Para voltar ao modo local, deixe as duas strings "".
export const SUPABASE_URL = "https://pnlukzinpompepqfsqvk.supabase.co";
export const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBubHVremlucG9tcGVwcWZzcXZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEyNzIxMTUsImV4cCI6MjA5Njg0ODExNX0.DhVxj1Wl9is3zmsgNJ_SwoXp-5rEJLWMQX5lx5awDfs";
