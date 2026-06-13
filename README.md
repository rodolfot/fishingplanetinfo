# 🎣 Fishing Planet Info

Repositório **colaborativo** de informações do jogo **Fishing Planet**: pontos de
pesca, peixes, **valor (US$/kg)**, **XP/kg**, **raridade**, **período (☀️ dia / 🌙 noite)**,
**isca**, **tipo de vara** e o **range de horário** em que cada peixe é mais fácil de
pegar. Qualquer pessoa pode **adicionar** e **remover** informações.

É um site estático (HTML + CSS + JS puro, **sem build**) que junta:

- o app **[fishingplanetvalores.netlify.app](https://fishingplanetvalores.netlify.app/)** — backend colaborativo em **Supabase** (tabelas `locais_pesca` / `peixes`, com `raridade` e `xp_kg`);
- o **HTML em anexo** — UI escura e o ranking "qual compensa mais" (US$/kg);

e acrescenta: **período diurno/noturno, isca, tipo de vara, horário (de–até),
profundidade, observações, nome científico**, além de **nível/licença e guia por
ponto de pesca**.

## Recursos

- **Ordenação por coluna**: clique no cabeçalho (Peixe, US$/kg, XP/kg, Período,
  Isca, Vara, Horário) para ordenar — alterna ▲/▼. Vazios sempre por último.
  Também há um seletor (inclui ordenar por raridade).
- **Busca** por peixe, ponto, isca, vara ou período.
- **Adicionar / editar / remover** peixes (✎ edita o registro in-place; ✕ remove).
- **Barra de estatísticas** (pontos, peixes, espécies, troféus) e **índice** de
  pontos para navegação rápida.
- **Destaque "compensa mais"** (maior US$/kg).
- **Mapa-múndi** (`mapa.html`): pontos no mapa (Leaflet), **preço da viagem**,
  **diária** e um guia de **como funcionam as licenças**.

## Cobertura atual dos dados de exemplo

**9 águas / 67 peixes**: Rio Mudwater (MO), Pesqueiro Lesni Vila (CZ), Emerald
Lake (NY), Lone Star Lake (TX), Quanchkin Lake (LA), Rocky Lake (CO), Neherrin
River (NC), Everglades (FL) e Akhtuba River (Rússia). O jogo tem ~26+ águas e
~170+ espécies — o objetivo é a **comunidade preencher o resto**. Valores de
US$/kg confiáveis foram preenchidos; onde não havia dado, o campo fica em branco
(em vez de inventar número).

> Os SQLs de seed são **gerados** de `seed.js` (fonte única) por
> `node scripts/gen-sql.mjs` — não edite os `.sql` à mão.

---

## ▶️ Como rodar

### Modo local (na hora, sem nada)

Como usa ES modules, sirva a pasta por HTTP (não abra via `file://`):

```bash
# qualquer um destes, dentro da pasta do projeto:
npx serve .
# ou
python -m http.server 8000
```

Abra `http://localhost:8000`. Já vem com **dados de exemplo pesquisados** (5 águas).
Nesse modo os dados ficam **só no seu navegador** (`localStorage`).

> **Dica:** mesmo com o Supabase configurado, adicione **`?local`** na URL
> (`http://localhost:8000/?local`) para ver a demo offline com os 5 lagos de exemplo.
>
> No VS Code dá pra usar a extensão **Live Server** também.

### Modo colaborativo (todos compartilham os dados) — Supabase

Este repositório já vem **apontando para um projeto Supabase existente** (em
`config.js`). Para deixar 100% funcional, rode a migração uma vez:

1. Abra o projeto no Supabase → **SQL Editor**.
2. Rode **`supabase/schema.sql`** — é **idempotente**: cria as tabelas se não
   existirem e faz `add column if not exists` das colunas novas (`periodo`,
   `nivel`, `guia`, `isca`, `tipo_vara`, etc.) **sem apagar dados**.
3. (Opcional) Popular dados de exemplo:
   - Projeto **novo/vazio** → `supabase/seed.sql` (as 5 águas).
   - Projeto que **já tem** "Rio Mudwater"/"Pesqueiro Lesni Vila" →
     `supabase/seed-extra.sql` (só as 3 águas novas, **sem duplicar**).
4. Recarregue. O site mostra **"☁️ Modo colaborativo"** e passa a ler/gravar no
   banco compartilhado.

Para usar **outro** projeto, troque `SUPABASE_URL`/`SUPABASE_ANON_KEY` em
`config.js` (deixe `""`/`""` para voltar ao modo local).

> Quer apontar para um Supabase **que já existe**? Basta colocar a URL/chave dele
> em `config.js` — desde que as tabelas tenham as colunas do `schema.sql`.

---

## 🌐 Publicar

Por ser estático, sobe direto em **GitHub Pages**, **Netlify** ou **Vercel** sem
configuração. Para colaboração de verdade, preencha o `config.js` antes (ou use
variáveis no seu fluxo de deploy).

---

## 🗂️ Estrutura

```text
index.html          página de peixes (pontos / enciclopédia)
mapa.html           mapa-múndi + viagem/diária/licenças
styles.css          tema escuro (compartilhado)
store.js            camada de dados plugável (Supabase | localStorage) — compartilhada
app.js              lógica da página de peixes
map.js              lógica da página do mapa (Leaflet)
config.js           credenciais do Supabase (vazio/⁠?local = modo local)
seed.js             dados de exemplo (FONTE ÚNICA — modo local)
scripts/gen-sql.mjs gera os .sql a partir de seed.js
supabase/schema.sql tabelas + RLS + migração idempotente
supabase/seed.sql        dados de exemplo (projeto novo) — GERADO
supabase/seed-extra.sql  só as águas novas (projeto reaproveitado) — GERADO
```

### Modelo de dados

- **locais_pesca**: `id`, `nome`, `regiao`, `nivel`, `guia`, `pais`, `lat`, `lng`,
  `preco_viagem`, `diaria`, `criado_em`
- **peixes**: `id`, `local_id`, `nome`, `nome_cientifico`, `raridade`
  (`comum`/`jovem`/`troféu`), `periodo` (`diurno`/`noturno`/`ambos`), `valor_kg`,
  `xp_kg`, `isca`, `tipo_vara`, `horario_inicio`, `horario_fim`, `profundidade`,
  `obs`, `criado_em`

> Atualizando de uma versão anterior do banco? O `schema.sql` traz os
> `ALTER TABLE ... add column if not exists` para `nivel`, `guia` e `periodo`.

---

## ⚠️ Sobre segurança (leia se for publicar colaborativo)

O `schema.sql` deixa o RLS **aberto** para a chave anon (qualquer um lê, adiciona e
**remove**) — foi o que você pediu: "todos podem colaborar e remover". É ótimo para
um wiki aberto, mas significa que alguém mal-intencionado também pode apagar tudo.
Se isso preocupar, dá pra evoluir para **login** (Supabase Auth) e trocar as
policies por regras com `auth.uid()`, mantendo leitura pública e escrita só para
logados. A chave **anon** é pública por design (vai no front-end), protegida pelo RLS.

---

## 📚 Fontes dos dados de exemplo

Compilado de guias da comunidade (sujeito a erros — **corrija colaborando!**):

- Fishing Planet Wiki — Mudwater River (Missouri) e Lesni Vila Fishery (Czech Republic)
- Guias de Mudwater River e Lesni Vila no Steam Community e YouTube

Os valores de **US$/kg** confiáveis vieram da base do app original; onde não havia
dado, o campo ficou em branco para a comunidade preencher.
