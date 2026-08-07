# Layout do documento — ClickUp-first

Regra central para **qualquer produto** gerado pela skill `project-context-doc`.

**Destino:** Markdown colado no ClickUp — **nao** GitHub README.

---

## Principio rector (layout)

```text
Util primeiro, catalogo no apendice.
Didatico antes de exaustivo — FL/RN/G completos no corpo; TB/RT/DBML listados no apendice.
Uma narrativa por tema — FL/RN explicam por que; RT cataloga o que (link de volta).
ClickUp-safe — sem HTML acordeon (<details>), sem indice com centenas de linhas no topo.
```

---

## Regra dos 3 cliques

O dev deve encontrar **informacao acionavel** (contexto, URLs de teste, erros classicos, mapa de repos) em **menos de uma tela de scroll** (~80 linhas).

**Proibido no topo:**
- Listagem completa TB-001…N
- Listagem completa RT-001…N
- Tabela de artefatos com 200+ linhas
- Blocos DBML
- `<details>` / `<summary>` (nao renderiza no ClickUp)

---

## Estrutura: Corpo primario vs Apendice

### Corpo primario (ler primeiro)

| Ordem | Secao | Conteudo |
|-------|-------|----------|
| 1 | Aviso IA | Disclaimer |
| 2 | Titulo | Nome produto + validacao Fase 0b/3 |
| 3 | **Referencia rapida** | URLs teste, header tenant, credenciais teste (Fase 3), links Git por alias |
| 4 | **Indice curto** | ~15 links de secao — **sem** subitens TB/RT |
| 5 | Como ler | 1 paragrafo + tabela artefatos (FL/RN/G/TB/RT) |
| 6 | Contexto | Problema, usuarios, por que white-label |
| 7 | Erros classicos | Tabela com links RN/G — **cedo no doc** |
| 8 | Por que N repos | Tabela expandida professor (2+ frases por repo) |
| 9 | Apidog + servicos externos | Incluir explicacao PK Node / gateways quando existirem |
| 10 | Mapa sistema | Diagrama PNG + aliases + **URL Git** por repo |
| 11 | Glossario | Termo + significado + **por que importa** + link FL/RN |
| 12 | FL-xxx | Formato expandido completo (fonte canonica de narrativa) |
| 13 | RN-xxx | Formato expandido completo |
| 14 | G-xxx | Formato expandido completo |
| 15 | Banco de Dados | TB dicionario — **sem DBML inline**; link `#dbml-core` no apendice |
| 16 | Catalogo Rotas | Intro + Tier 1 **tabela resumo** + Tier 2 **agrupado por modulo** |
| 17 | Auth, Tenant, INT, WH, CR, ENV, DA, Setup | Condicionais |
| 18 | Revisao pendente | `[CONFIRMAR]` |

### Apendice (final, antes de Revisao pendente)

Anchor: `<a id="apendice"></a>`

| Bloco | Conteudo |
|-------|----------|
| Indice completo artefatos | Tabela FL + RN + G + TB + RT (todas as linhas) |
| Indice TB | Links TB-001…N |
| Indice RT | Agrupado por repo e **modulo de path** (banners, players, …) |
| DBML | Blocos colaveis dbdiagram.io — core + integration |
| RT Tier 1 expandido | Fichas tecnicas (curl, tabela) — **sem repetir cenario FL** |

Link no indice curto: `[Apendice — indices completos](#apendice)`

---

## Indice curto (template)

```markdown
<a id="indice"></a>
## 📑 Indice

- [Referencia rapida](#referencia-rapida)
- [Contexto](#contexto)
- [Erros classicos de dev novo](#erros-classicos)
- [Por que N repos](#por-que-n-repos)
- [Referencias Apidog](#referencias-apidog)
- [Mapa do Sistema](#mapa-do-sistema)
- [Glossario](#glossario)
- [Fluxos (FL-xxx)](#fluxos-end-to-end)
- [Regras de Negocio (RN-xxx)](#regras-de-negocio)
- [Guardrails (G-xxx)](#guardrails)
- [Banco de Dados (TB-xxx)](#banco-de-dados)
- [Catalogo de Rotas (RT-xxx)](#catalogo-de-rotas)
- [Autenticacao](#autenticacao)
- [Integracoes (INT-xxx)](#integracoes)
- [Webhooks (WH-xxx)](#webhooks)
- [Setup Rapido](#setup-rapido)
- [Apendice — indices completos](#apendice)
```

**Opcional:** subitens FL/RN/G no indice curto (11+16+10 linhas) — aceitavel. **Nunca** subitens TB/RT completos no topo.

---

## Sub-indice por modulo (ClickUp-safe)

Cada **modulo grande** do corpo tem indice local no inicio da secao — permite pular direto para FL-003, RN-008, etc. **sem** inflar o indice global.

| Modulo | Anchor sub-indice | Conteudo |
|--------|-------------------|----------|
| Fluxos | `#indice-fluxos` | FL-001 … FL-011 |
| Regras | `#indice-regras` | RN-001 … RN-018 |
| Guardrails | `#indice-guardrails` | G-001 … G-010 |
| Banco | `#indice-tb` | TB — agrupar se checklist passar (ver [index-grouping-guide.md](index-grouping-guide.md)) |
| Rotas (corpo) | `#indice-rotas-corpo` | Tier 1 resumo; Tier 2 agrupado se checklist passar |

**Agrupamento:** antes de cada sub-indice ou catalogo longo, aplicar checklist em [index-grouping-guide.md](index-grouping-guide.md). Nao e regra fixa por tipo — e decisao por contexto.

Exemplo **flat** (checklist = nao — poucos itens, sem ambiguidade):

```markdown
<a id="indice-fluxos"></a>
#### Indice deste modulo — Fluxos

- [FL-001 Login](#fl-001)
- [FL-002 Cadastro](#fl-002)
```

Exemplo **agrupado** (checklist = sim — lista longa, cluster natural, homonimos):

```markdown
<a id="indice-tb"></a>
#### Indice deste modulo — Tabelas (TB)

##### `[core]` — nome-pasta (TB-001–NNN)

- [TB-002 `player`](#tb-002)

##### `[integration]` — nome-pasta (TB-0XX–NNN)

- [TB-027 `players`](#tb-027)
```

Mesma arvore de clusters no corpo, sub-indice e Apendice quando agrupado. Apendice "artefatos": flat OK para FL/RN/G curtos se TB/RT tiverem indices dedicados agrupados.

**Proibido:** `<details>`. **Permitido:** lista markdown simples ou cabecalhos `#####`/`####` por cluster.

Indice global curto linka a secao (`#fluxos-end-to-end`); sub-indice fica **dentro** da secao.

---

## Referencia rapida (template)

Dados da **Fase 3** — bloco 1b obrigatorio.

```markdown
<a id="referencia-rapida"></a>
## ⚡ Referencia rapida

| Item | Valor |
|------|-------|
| App / tenant teste | `https://[domain]` |
| API principal | `https://[api]` |
| Header tenant | `x-application-domain: [domain]` |
| Integration / outros | URLs da Fase 3 |
| Credenciais teste | [usuario] / [CONFIRMAR senha] |
| Repo `core` | [git remote URL] |
| Repo `front` | [git remote URL] |
```

---

## Anti-duplicacao FL vs RT

| Artefato | Papel narrativo |
|----------|-----------------|
| **FL-xxx** | Cenario Maria/Joao, pre-condicoes, tabela passos — **unica explicacao longa** |
| **RN-xxx** | Regra inviolavel — unica explicacao da regra |
| **RT Tier 1 (corpo)** | Tabela resumo: RT, path, caso de uso, link FL, link ficha `#rt-071` |
| **RT Tier 1 (apendice)** | Ficha tecnica: curl, headers, codigo — **Ver [FL-001](#fl-001) para narrativa** |

**Proibido:** paragrafo "Maria abre login…" no RT quando FL-001 ja existe.

---

## Agrupamento RT Tier 2 por modulo

Agrupar por **primeiro segmento do path**, nao por metodo HTTP:

```markdown
### core — Modulo players
> **Exemplo:** [RT-071](#rt-071) POST /players/login — [FL-001](#fl-001)
- [RT-072](#rt-072) POST /players/register — [FL-002](#fl-002)

### core — Modulo banners
- [RT-019](#rt-019) GET /banners/
```

Para pages front/dashboard: modulo = primeiro segmento apos `/` (ex. `/dashboard/jogos` → modulo `dashboard/jogos` ou `jogos` conforme profundidade).

**Titulos de grupo:** texto plano — **sem backticks** no titulo (`core — Modulo banners`, nao `` `core` ``).

---

## DBML

- **Corpo TB:** link `[DBML completo no Apendice](#dbml-core)`
- **Apendice:** blocos ` ```dbml ` completos por repo

---

## Entrega multipagina (Fase 4) — local + ClickUp

Alem do monolito `.docs/contexto-[slug].md`, gerar **versao dividida** para publicacao no ClickUp como **1 Doc** com hierarquia nativa:

| Arquivo | Papel |
| ------- | ----- |
| `README.md` (raiz do workspace) | Pagina principal — indice, referencia rapida, como ler |
| `docs/01-contexto.md` | Subpagina 1 — contexto, mapa, glossario |
| `docs/02-fluxos.md` | Subpagina 2 — FL-xxx |
| `docs/03-regras.md` | ... |
| `docs/NN-*.md` | Demais secoes por ordem de **prioridade de leitura** |

### Convencao de numeracao (obrigatoria)

- Prefixo **`NN-`** (dois digitos: `01`, `02`, … `08`) no nome do arquivo
- Ordem numerica = ordem na sidebar do ClickUp e na navegacao local
- No ClickUp, subpaginas recebem titulo **`NN — Titulo`** (ex.: `02 — Fluxos End To End`)
- Links cruzados entre arquivos: `docs/02-fluxos.md#fl-001`

Ordem sugerida (adaptar ao produto):

```text
01-contexto → 02-fluxos → 03-regras → 04-guardrails → 05-banco-dados
→ 06-rotas → 07-dominios (auth, INT, WH, ENV) → 08-apendice
```

Monolito `.docs/contexto-[slug].md` permanece como backup e diff.

---

## Checklist layout (Fase 4)

- [ ] Referencia rapida nas primeiras ~40 linhas uteis
- [ ] Contexto + erros classicos antes de FL (nao depois de 2000 linhas de indice)
- [ ] Indice curto sem listagem RT/TB individual
- [ ] Zero `<details>` no markdown
- [ ] Apendice com tabela artefatos + indices TB/RT + DBML
- [ ] RT Tier 1 apendice sem repetir cenario FL
- [ ] Mapa com URL Git por alias (Fase 0b / `git remote`)
- [ ] Glossario com coluna "Por que importa"
- [ ] `README.md` + `docs/01-*.md` … `docs/NN-*.md` gerados (numeracao = prioridade)
