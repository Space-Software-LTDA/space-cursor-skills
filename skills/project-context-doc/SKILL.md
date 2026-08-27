---
name: project-context-doc
description: >-
  Gera documentacao de contexto de produto para ClickUp com fluxos end-to-end,
  regras de negocio, guardrails, DBML dbdiagram, dicionario de banco, catalogo
  de rotas, auth, multi-tenant, integracoes externas, webhooks, crons/jobs e
  variaveis de ambiente. Workflow em fases: recon do codigo, confirmacao com
  usuario (0b + entrevista), geracao local (README + docs/NN-*.md), e opcional
  Fase 5 publicacao ClickUp via API (pede token pk_, workspace_id). Vasculha
  repos antes de perguntar na Fase 0a; valida com humano na Fase 3 antes de
  gravar. Cruza codigo com Apidog quando informado.
disable-model-invocation: true
---

# Project Context Doc

> ⚠️ **COPIA:** os arquivos em `~/.cursor/skills/project-context-doc` sao gerados pelo sync.  
> **Altere em** `space-cursor-skills/skills/project-context-doc/` → depois rode `npm run sync` na raiz do repo.  
> Ver `00-COPIA-LEIA-ME.md` nesta pasta. Credenciais ClickUp: `.env` na raiz do `space-cursor-skills`.  
> No repo fonte: **`AGENTS.md`** (raiz) explica o fluxo completo para o agente.

Gera documento de contexto para devs: foco em **por que**, **para que** e **fluxo end-to-end**.

**Sempre responder em portugues (PT-BR).**

**Output:** Markdown em `.docs/contexto-[slug-produto].md` (monolito) + `README.md` + `docs/01-*.md` … `docs/NN-*.md` (subpaginas numeradas por prioridade). Formato compativel com ClickUp. **Nao commitar automaticamente.**

**Gate obrigatorio:** so gravar o arquivo na **Fase 4**, apos **Fase 0b confirmada** e **Fase 3 respondida** pelo usuario (ver secao Gates abaixo).

## Principio rector

```text
Util primeiro, catalogo no apendice — ver document-layout.md.
Didatico antes de exaustivo — RN/FL/G bem escritos valem mais que catalogo comprimido.
Fluxo end-to-end e o eixo de leitura.
Uma narrativa por tema — FL/RN explicam por que; RT aponta de volta (nao repete cenario).
ClickUp-first — sem <details>; indice curto no topo; listas longas no Apendice.
Tom professor: cenario, exemplo, erro comum — ver pedagogical-examples.md.
Indices longos: checklist "Vale a pena agrupar?" — ver index-grouping-guide.md.
```

Toda decisao de escopo vem do **recon do codigo**:

| Achou no codigo | Documentar |
|-----------------|------------|
| Jornada multi-repo | FL-xxx (fluxo end-to-end) |
| Rotas HTTP | Catalogo RT-xxx por repo (+ Apidog se informado) |
| Entities / ORM | DBML + dicionario TB-xxx por repo |
| Clients/adapters a servicos externos | INT-xxx |
| Webhooks inbound/outbound | WH-xxx |
| Schedulers / workers / crons | CR-xxx |
| Auth, tenant, ENV | Secoes correspondentes |
| Nao achou | **Omite a secao** (sem dizer que nao existe) |

## Arquivos de referencia

| Arquivo | Uso |
|---------|-----|
| [document-layout.md](document-layout.md) | **Layout ClickUp** — indice curto, apendice, referencia rapida, anti-duplicacao FL/RT |
| [language-guide.md](language-guide.md) | Tom professor, anchors, anti-enxugamento |
| [pedagogical-examples.md](pedagogical-examples.md) | Casos de uso, exemplos RN/FL/G, checklist |
| [template-clickup.md](template-clickup.md) | Estrutura master + Indice global |
| [template-flows.md](template-flows.md) | FL-xxx end-to-end |
| [template-dbml.md](template-dbml.md) | DBML + TB-xxx |
| [template-routes.md](template-routes.md) | RT-xxx por repo |
| [template-rn-guardrail.md](template-rn-guardrail.md) | RN, G, DA |
| [template-mandatory-domains.md](template-mandatory-domains.md) | Auth, tenant, INT, WH, CR, ENV |
| [apidog-guide.md](apidog-guide.md) | Links Apidog |
| [extraction-heuristics.md](extraction-heuristics.md) | Onde buscar no codigo |
| [interview-questions.md](interview-questions.md) | Fase 3 |
| [index-grouping-guide.md](index-grouping-guide.md) | **Checklist agrupamento** de indices e catalogos |
| [clickup-sync-guide.md](clickup-sync-guide.md) | **Fase 5** — API ClickUp, credenciais, sync 1 Doc + subpaginas |
| [clickup-markdown-guide.md](clickup-markdown-guide.md) | **Render ClickUp** — erros visuais, o omitir no README/subpaginas |

---

## Workflow

```
Fase 0a Recon → Fase 0b Config (+ aliases) → Fase 1 Descoberta → Fase 2 Extracao → Fase 3 Entrevista → Fase 4 Geracao → Fase 5 ClickUp (opcional, apos aprovacao)
```

**Regra de ouro:** cada fase so avanca quando a anterior cumpriu seu gate. **Nunca** pular 0b ou 3 por pedido generico de "implementar plano", "testar agora" ou "gerar doc".

---

## Gates entre fases

| Transicao | Gate — so avancar quando |
|-----------|--------------------------|
| 0a → 0b | Recon apresentado ao usuario |
| 0b → 1 | Usuario confirmou repos + aliases + Apidog (ou "sem apidog") + nome do produto |
| 1 → 2 | Descoberta concluida internamente (sem output de doc) |
| 2 → 3 | Extractions rascunhadas (FL, RN, G, lista `[CONFIRMAR]`) — **nao gravar `.docs/`** |
| 3 → 4 | Usuario respondeu entrevista (blocos 1 e 2 obrigatorios) |
| 4 → entrega local | Doc montado + checklist completo + `README.md` + `docs/` gravados |
| 4 → 5 | Usuario aprovou versao local ("pode publicar no ClickUp") |
| 5 → entrega | Doc ClickUp criado/atualizado; link informado ao usuario |

**Proibido na Fase 2:** criar ou sobrescrever `.docs/contexto-*.md`.

**Unica excecao para pular Fase 3:** usuario escreve explicitamente `"pular Fase 3"`, `"gerar doc sem entrevista"` ou `"nao precisa entrevista"`. Nesse caso: listar todos os `[CONFIRMAR]` na secao Revisao pendente e avisar que o doc e preliminar.

**Nao sao excecao** (Fase 3 continua obrigatoria): "implemente o plano", "teste agora", "crie o contexto", "execute", urgencia implicita.

---

## Fase 0a — Reconhecimento (sempre primeiro)

Antes de perguntar, analisar pastas locais (workspace, paths do usuario):

1. Identificar diretorios-repos (`package.json`, `.git`, `go.mod`, `Cargo.toml`, etc.)
2. Classificar cada um **pelo codigo**, nunca pelo nome da pasta:

| Sinal | Papel inferido |
|-------|----------------|
| UI framework + pages/components | Cliente (frontend/mobile) |
| Servidor HTTP + rotas/controllers | API |
| Wrappers HTTP a dominios externos (`adapters/`, `providers/`, `clients/`) | Servico de integracao externa |
| ORM entities, migrations, schemas DB | Persistencia |
| Monorepo (`apps/`, `packages/`) | Mapear cada pacote |

3. Registrar: rotas HTTP, entities, workers, `.env.example`, docs de convencao (`CLAUDE.md`, `AGENTS.md`)
4. Montar mapa provisorio para Fase 0b

---

## Fase 0b — Config (so o que falta)

Apresentar recon e pedir confirmacao:

```markdown
Reconhecimento do workspace:

| # | Pasta | Inferencia | Stack |
|---|-------|------------|-------|
| 1 | [caminho] | [papel inferido] | [stack] |

Aliases propostos:

| Alias | Repo (pasta) | Papel |
|-------|--------------|-------|
| `[front]` | [pasta] | Cliente UI |
| `[core]` | [pasta] | API principal |

1. **Nome do produto** — [inferido ou "?"]
2. **Repos corretos?** Falta algum? Papel errado?
3. **Aliases OK?** Ajustar se necessario
4. **Links Apidog** — para cada repo com **API HTTP** detectada:
   - Virgula: `https://..., https://...`
   - Ou linha: `nome-repo: https://...`
   - Link unico cobrindo tudo: um URL
   - Sem Apidog: **"sem apidog"**
5. **Idioma** — PT-BR (default)
```

| Item | Comportamento |
|------|---------------|
| Repos | Confirmar mapa do recon |
| Aliases | Definir tags estaveis por papel (`[front]`, `[core]`, `[adapters]`, etc.) |
| Apidog | So para repos API detectados; N links para N APIs |
| Frontend UI | Apidog so se usuario informar |
| Produto | Perguntar se nao inferivel |

Nao iniciar Fase 1 sem repos confirmados + aliases + Apidog associado ou "sem apidog".

**Parar aqui e aguardar resposta do usuario.** Nao assumir "sim" silencioso.

Se usuario ja informou tudo no chat, validar explicitamente e registrar o que foi confirmado antes de seguir.

---

## Fase 1 — Descoberta

Por **cada repo confirmado**:

- Entities: `@Entity()`, Prisma schema, migrations
- Rotas: routers, controllers, `app/**/page.tsx`, `app/api/**/route.ts`
- Middlewares, guards, auth
- Cadeias de chamada cross-repo (para FL-xxx)
- `.env.example` + `process.env.*`
- Convencoes: `CLAUDE.md`, `AGENTS.md`, `.cursor/rules`
- Apidog: associar link ao repo (ver [apidog-guide.md](apidog-guide.md))

Checklist de dominios: [extraction-heuristics.md](extraction-heuristics.md)

---

## Fase 2 — Extracao

Ordem sugerida: **Mapa/aliases → FL-xxx → RN/G → TB/RT por repo → dominios**

| Tipo | Prefixo | Fonte |
|------|---------|-------|
| Fluxo end-to-end | FL-xxx | Cadeia page → API → adapter → externo → retorno |
| Regra de negocio | RN-xxx | Fluxos contra-intuitivos (linkar FL) |
| Guardrail | G-xxx | Middlewares, convencoes (linkar FL passo) |
| Rota | RT-xxx | Codigo + Apidog + OpenAPI/swagger fallback |
| Tabela | TB-xxx | Cada entity, agrupada por repo |
| Decisao | DA-xxx | Separacao repos, padroes |
| Integracao externa | INT-xxx | Adapters, clients HTTP terceiros |
| Webhook | WH-xxx | Rotas webhook, configs outbound |
| Cron/job | CR-xxx | Workers, schedulers |
| ENV | Tabela | `.env.example`, process.env |

- DBML por repo com banco — [template-dbml.md](template-dbml.md)
- Fluxos — [template-flows.md](template-flows.md)
- **Toda coluna TB:** Para que + Por que (frase completa, sem coluna Tipo)
- **Rotas RT:** classificar Tier 1 (criticas) vs Tier 2 (referencia) — ver [template-routes.md](template-routes.md)
- **RN/G:** rascunhar no formato expandido (Cenario + Exemplo + Erro comum) — ver [template-rn-guardrail.md](template-rn-guardrail.md)

**Output desta fase:** rascunho interno (mental ou notas) — **nao** e o documento final. Apresentar resumo na Fase 3 para validacao.

**Proibido na Fase 2/4:** comprimir RN/G/FL para formato telegrafico (Fluxo + Regra + Por que de 1 linha).

---

## Fase 3 — Entrevista (obrigatoria)

Executar [interview-questions.md](interview-questions.md) **no chat**, antes de qualquer gravacao em `.docs/`.

### O que apresentar ao usuario

1. **Bloco 1 — Negocio** (5 perguntas): problema, usuarios, repos, jornadas criticas, erros de dev novo
2. **Bloco 2 — Validacao** (obrigatorio): listar FL/RN/G/INT/WH/CR extraidos + itens `[CONFIRMAR]` + perguntas de correcao
3. **Blocos 3–6** — somente se relevante (TB gerados, multi-tenant, Apidog, ambientes)

### Como apresentar

- Usar perguntas diretas no chat ou ferramenta de formulario
- Incluir tabela de FL/RN/G encontrados com "— correto?"
- **Aguardar resposta** antes de iniciar Fase 4

### Apos respostas

- Incorporar respostas na secao Contexto e nos FL/RN/G
- Reduzir `[CONFIRMAR]` onde o usuario confirmou
- Manter `[CONFIRMAR]` apenas no que ficou em aberto

**Nao iniciar Fase 4** sem respostas do usuario (excao explicita documentada acima).

---

## Fase 4 — Geracao

**Pre-requisito:** Fase 0b confirmada + Fase 3 respondida (ou excecao explicita "pular Fase 3").

[template-clickup.md](template-clickup.md) · [pedagogical-examples.md](pedagogical-examples.md)

Secoes fixas (com conteudo): Aviso IA, **Referencia rapida** (Fase 3), **Indice curto**, Contexto, Erros classicos, Por que N repos, Apidog (se houver), Mapa (+ aliases + Git), Glossario, **Fluxos (FL-xxx)**, RN, G, DB (TB dicionario, **sem DBML inline**), RT (Tier 1 resumo + Tier 2 agrupado por modulo), **Apendice** (indices + DBML + RT Tier 1 expandido).

Secoes condicionais (achou inclui): Auth, Multi-tenant, INT, WH, CR, ENV — coluna Repo obrigatoria + anchor na secao.

Finais: DA, Referencia por repo, Ambientes, Setup rapido, Observacoes, Revisao `[CONFIRMAR]`.

**Ordem de montagem:** ver [document-layout.md](document-layout.md) e [template-clickup.md](template-clickup.md).

```text
1. Listar IDs e anchors (fl-001, rn-008, tb-001, rt-001, apendice, ...)
2. Referencia rapida (URLs Fase 3 + git remote por repo)
3. Indice curto (~15 links de secao) — sem listagem TB/RT no topo
4. Escrever FL/RN/G no formato expandido (fonte canonica de narrativa)
5. TB dicionario no corpo; DBML somente no Apendice
6. RT corpo: Tier 1 tabela resumo + Tier 2 agrupado por modulo/recurso
7. Apendice: tabela artefatos, indices TB/RT, DBML, RT Tier 1 expandido (link FL, sem repetir cenario)
8. Validar checklist layout + pedagogico abaixo
9. `python3 ~/.cursor/skills/project-context-doc/scripts/validate_pedagogy.py docs/` — **bloqueante** antes do sync
10. mkdir -p .docs docs && Write → `.docs/contexto-[slug].md` + `README.md` + `docs/01-*.md` … (ver [document-layout.md](document-layout.md#entrega-multipagina-fase-4--local--clickup))
```

**Subpaginas:** prefixo `NN-` obrigatorio; ordem = prioridade de leitura; titulo ClickUp = `NN — Titulo`.

**Utilitarios de build (opcional por projeto):** [`scripts/doc_build_utils.py`](scripts/doc_build_utils.py) — links multipagina, catalogo RT, DBML, agrupamento de indices. Conteudo de produto (FL/RN/G, TB catalog, Tier 1) fica no repo do projeto (ex.: `.docs/build_*_sections.py`).

---

## Fase 5 — Publicacao ClickUp (apos aprovacao local)

**Pre-requisito:** usuario aprovou `README.md` e arquivos `docs/NN-*.md` gerados na Fase 4.

Guia completo: [clickup-sync-guide.md](clickup-sync-guide.md)

### Credenciais ClickUp

**Preferencia:** carregar de `~/.cursor/skills/project-context-doc/clickup.env` (token + workspace_id globais) e overrides em `.docs/clickup.env` do projeto (doc_name, doc_id). Ver [clickup-sync-guide.md](clickup-sync-guide.md).

Se arquivos ausentes ou incompletos, o agente **pede ao usuario** (no chat, antes de executar):

1. **`CLICKUP_API_TOKEN`** — Personal API Token (`pk_...`)
2. **`CLICKUP_WORKSPACE_ID`** — ID numerico do Workspace
3. Opcional: **`CLICKUP_DOC_PARENT_ID`** + **`CLICKUP_DOC_PARENT_TYPE`** — onde criar o Doc

**Nao executar sync sem credenciais.** Nunca commitar `clickup.env`.

### Execucao

```bash
python3 ~/.cursor/skills/project-context-doc/scripts/clickup_sync.py --workspace . --dry-run
python3 .docs/clickup_sync.py --dry-run   # wrapper no projeto (se existir)
python3 .docs/clickup_sync.py             # publicar
```

Subpaginas no ClickUp usam o **mesmo prefixo numerico** dos arquivos locais (`01 — Contexto`, `02 — Fluxos`, …).

**Nunca** gravar token no repo. Informar link final: `https://app.clickup.com/{workspace_id}/docs/{doc_id}`

**Proibido na Fase 5:** publicar sem aprovacao explicita do usuario; pular remocao de `<a id>` antes do upload; incluir instrucoes de sync ou paths locais no README publicado.

Validar render visual: [clickup-markdown-guide.md](clickup-markdown-guide.md)

---

**Proibido na Fase 4:**

- Gerar doc via script em massa com Por que generico de 1 linha para RN/FL/G
- Entregar RN/G no formato compacto (so Regra + Por que telegrafico)
- Omitir Indice global ou cross-links clicaveis entre artefatos
- Comprimir rotas Tier 1 em tabela compacta para "caber" catalogo

---

## Diagramas

```bash
~/.cursor/skills/project-context-doc/scripts/render-mermaid.sh 'flowchart LR
  Client-->ApiA
  ApiA-->Db'
```

C4 e sequencias refletem **repos reais do recon**. Inserir PNG mermaid.ink — nunca bloco mermaid inline.

---

## Checklist antes de entregar

**Gates humanos:**
- [ ] Fase 0b confirmada pelo usuario (repos, aliases, Apidog ou "sem apidog", produto)
- [ ] Fase 3 apresentada; respostas recebidas e incorporadas (ou excecao "pular Fase 3" registrada)

**Layout ClickUp (ver [document-layout.md](document-layout.md)):**
- [ ] Referencia rapida nas primeiras ~80 linhas uteis
- [ ] Indice curto no topo — sem listagem individual TB/RT
- [ ] Apendice com indices completos + DBML + RT Tier 1 expandido
- [ ] Zero `<details>` / acordeon HTML
- [ ] RT Tier 1 apendice nao repete paragrafo de cenario ja narrado em FL

**Indice e navegacao:**
- [ ] Indice curto apos Referencia rapida; link `#apendice` para catalogos completos
- [ ] Anchors `<a id="fl-001">` etc. em FL/RN/G/TB Tier 1/RT Tier 1/WH/DA
- [ ] Cross-links usam markdown `[RN-008](#rn-008)` — nao texto morto

**Didatica (bloqueante — ver [pedagogical-examples.md](pedagogical-examples.md)):**
- [ ] Tom professor **verboso** — cenario passo a passo; anti-telegrafico (sem `;` encadeando fluxo)
- [ ] Ordem narrativa: explicacao → tabela/diagrama → bloco **Referencias** (sem coluna Ref na tabela FL)
- [ ] Sub-indices por modulo: Fluxos, RN, G, TB, RT corpo (ver [document-layout.md](document-layout.md))
- [ ] Checklist agrupamento aplicado a cada indice longo (ver [index-grouping-guide.md](index-grouping-guide.md))
- [ ] Cada RN: Cenario 5+ frases + Comportamento + Por que (2+ frases) + Exemplo + Erro comum + Referencias
- [ ] Cada G: Cenario de violacao 4+ frases + Se violar + Por que (2+ frases)
- [ ] Cada FL critico: Por que importa + Cenario + Passo a passo + Pre-condicoes antes da tabela
- [ ] Coluna Por que em FL/TB = frase completa, nao fragmento telegrafico
- [ ] RT Tier 1 formato expandido; Tier 2 Por que ≥ 1 frase + link Fluxo
- [ ] RN/G/FL: labels como `**Proibido** — paragrafo` — **nunca** `#### Label` + linha vazia + 1 frase (ClickUp cria bloco vazio)
- [ ] Pos-tabela: linha em branco antes de `**Referencias** —` (sync aplica `ensure_blank_line_after_tables`)
- [ ] Exemplos concretos do produto (URLs/domains da Fase 3 quando informados)

**Conteudo:**
- [ ] Recon feito; aliases definidos no Mapa
- [ ] FL-xxx para jornadas criticas multi-repo
- [ ] Apidog associado por repo API real ou secao omitida
- [ ] Secoes condicionais so com conteudo encontrado
- [ ] DBML + TB agrupados por repo; toda coluna documentada (sem Tipo)
- [ ] RN/G referenciam FL-xxx com link quando aplicavel
- [ ] RN/G/INT/WH/CR numerados; Repo (alias) em INT/WH/CR/ENV
- [ ] ENV sem secrets
- [ ] Diagramas PNG only
- [ ] Aviso IA no topo
- [ ] Lista `[CONFIRMAR]` no final (somente o que ficou em aberto)
- [ ] Arquivo gravado em `.docs/contexto-[slug].md` **somente na Fase 4**
- [ ] `README.md` + `docs/01-*.md` … `docs/NN-*.md` gerados para publicacao ClickUp
- [ ] README **sem** meta de tooling (sync, coluna "Arquivo local", paragrafo "8 arquivos em docs/")
- [ ] Subpaginas **sem** H2 duplicando titulo da sidebar ClickUp

**ClickUp (Fase 5 — se solicitado):**
- [ ] Usuario aprovou versao local antes do sync
- [ ] `validate_pedagogy.py docs/` passou sem violacoes
- [ ] Token e workspace_id recebidos (nao commitados)
- [ ] `clickup_sync.py --dry-run` ok; sync executado; link do Doc entregue
