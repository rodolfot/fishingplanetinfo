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

// Projeto Supabase próprio (criado em jun/2026). A chave anon é pública por
// design (vai no front-end), protegida pelo RLS. O schema + seed já foram
// aplicados via supabase/aplicar-tudo.sql. Para voltar ao modo local, deixe as
// duas strings "".
export const SUPABASE_URL = "https://mafgcgitiysvnbmruyea.supabase.co";
export const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hZmdjZ2l0aXlzdm5ibXJ1eWVhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEzNTk0NzksImV4cCI6MjA5NjkzNTQ3OX0.YP1KQ0VYnKrBuvVYEJL0dZaDf00WOSOZgrXH5gKZsFY";
