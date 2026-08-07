# Guia de agrupamento de indices

Regra transversal da skill **project-context-doc**. Aplica-se a **qualquer** indice, sub-indice ou catalogo longo — TB, RT, Apendice, listas futuras — independente de quantos repos ou bancos existam.

---

## Pergunta central (Fase 4)

Antes de renderizar um indice, responder:

**"Vale a pena agrupar este indice para melhorar a visualizacao?"**

Nao e regra fixa por tipo de artefato. E decisao por contexto, documentada quando aplicada.

---

## Checklist — agrupar SIM se 2 ou mais forem verdadeiros

| Criterio | O que observar |
| -------- | -------------- |
| Lista longa | Orientacao: ~12+ itens (ajustar ao produto) |
| Cluster natural nos metadados | repo, schema, modulo de path, tier, dominio de negocio |
| Corpo ja usa essa estrutura | Agrupar indice alinha com secoes existentes |
| Homonimos entre clusters | `player` vs `players`, `deposit` vs `deposits` |
| Scan visual falha | Leitor busca por contexto antes de ID sequencial |

## Checklist — agrupar NAO se

- Poucos itens **e** sem ambiguidade (ex.: FL ~11, G ~10)
- Um unico cluster — cabecalhos so adicionam ruido
- Dimensao de cluster seria inventada (nao veio do recon)

---

## Escolher a dimensao de agrupamento

Ordem de preferencia:

1. **Mesma dimensao do corpo** do catalogo (consistencia visual)
2. Metadado dominante do artefato (repo, modulo, tier, dominio)
3. Dimensao que **dissolve ambiguidade** (homonimos)

Exemplos validos (projeto-agnostico):

| Contexto | Dimensao tipica | Nota |
| -------- | --------------- | ---- |
| TB / entities | repo ou schema | Quando dicionario body ja separa por repo |
| RT Tier 2 | repo + modulo (path) | Primeiro segmento do path |
| RN (lista grande) | dominio (auth, pagamentos) | So se checklist passar |
| Apendice artefatos | tipo (FL/RN/G/TB/RT) | So se tabela unica ficar ilegivel |

**Proibido:** prescrever "sempre agrupar por repo" ou "sempre flat" sem passar pelo checklist.

---

## Consistencia

Quando agrupar, usar a **mesma arvore de clusters** em:

- Sub-indice do modulo (`#indice-tb`, `#indice-rotas-corpo`, …)
- Catalogo no corpo (Tier 2, secoes TB, …)
- Indice dedicado no Apendice (`### Indice TB`, `### Indice RT`, …)

Onde o checklist disser **nao**, lista plana e aceitavel — inclusive no Apendice, se indices dedicados agrupados ja cobrirem TB/RT e FL/RN/G forem curtos.

---

## Formato ClickUp-safe

```markdown
<a id="indice-tb"></a>
#### Indice deste modulo — Tabelas (TB)

##### `[core]` — nome-pasta (TB-001–024)

- [TB-001 `application`](#tb-001)
- [TB-002 `player`](#tb-002)

##### `[integration]` — nome-pasta (TB-025–032)

- [TB-027 `players`](#tb-027)
```

Rotas (dois niveis):

```markdown
#### core — Modulo players

> **Exemplo white-label:** [RT-071](#rt-071) POST `/players/login`
```

**Proibido:** `<details>`. **Permitido:** listas markdown com cabecalhos `#####` ou `####`.

---

## Validacao Fase 4

- [ ] Cada indice longo passou pelo checklist (sim/nao documentado mentalmente)
- [ ] Dimensao escolhida existe no recon — nao inventada
- [ ] Sub-indice, corpo e Apendice usam mesma arvore quando agrupado
- [ ] Listas curtas sem ambiguidade permanecem flat (FL, RN, G tipicamente)
