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
- **Barra de estatísticas** (pontos, peixes, espécies, troféus) e **índice** de
  pontos para navegação rápida.
- **Destaque "compensa mais"** (maior US$/kg).

## Cobertura atual dos dados de exemplo

**5 águas / ~36 peixes**: Rio Mudwater (MO), Pesqueiro Lesni Vila (CZ), Emerald
Lake (NY), Lone Star Lake (TX) e Quanchkin Lake (LA). O jogo tem ~26+ águas e
~170+ espécies — o objetivo é a **comunidade preencher o resto**. Valores de
US$/kg confiáveis foram preenchidos; onde não havia dado, o campo fica em branco
(em vez de inventar número).

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

Abra `http://localhost:8000`. Já vem com **dados de exemplo pesquisados** (Rio
Mudwater e Pesqueiro Lesni Vila). Nesse modo os dados ficam **só no seu navegador**
(`localStorage`).

> No VS Code dá pra usar a extensão **Live Server** também.

### Modo colaborativo (todos compartilham os dados) — Supabase
1. Crie um projeto grátis em **https://supabase.com**.
2. No **SQL Editor**, rode **`supabase/schema.sql`** (e, se quiser os dados de
   exemplo, **`supabase/seed.sql`**).
3. Em **Project Settings → API**, copie a **Project URL** e a chave **anon public**.
4. Cole as duas em **`config.js`**:
   ```js
   export const SUPABASE_URL = "https://SEUPROJ.supabase.co";
   export const SUPABASE_ANON_KEY = "eyJhbGci...";
   ```
5. Recarregue. O site mostra **"☁️ Modo colaborativo"** e passa a ler/gravar no
   banco compartilhado.

> Quer apontar para um Supabase **que já existe**? Basta colocar a URL/chave dele
> em `config.js` — desde que as tabelas tenham as colunas do `schema.sql`.

---

## 🌐 Publicar

Por ser estático, sobe direto em **GitHub Pages**, **Netlify** ou **Vercel** sem
configuração. Para colaboração de verdade, preencha o `config.js` antes (ou use
variáveis no seu fluxo de deploy).

---

## 🗂️ Estrutura

```
index.html          estrutura da página
styles.css          tema escuro
app.js              lógica + camada de dados plugável (Supabase | localStorage)
config.js           credenciais do Supabase (vazio = modo local)
seed.js             dados de exemplo (modo local)
supabase/schema.sql tabelas + RLS
supabase/seed.sql   dados de exemplo (modo colaborativo)
```

### Modelo de dados

- **locais_pesca**: `id`, `nome`, `regiao`, `nivel`, `guia`, `criado_em`
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
