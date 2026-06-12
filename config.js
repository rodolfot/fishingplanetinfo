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

export const SUPABASE_URL = "";
export const SUPABASE_ANON_KEY = "";
