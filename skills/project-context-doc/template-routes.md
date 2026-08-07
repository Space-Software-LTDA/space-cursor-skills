# Template Rotas — RT-xxx

Catalogo de **referencia secundaria**. Rotas aparecem nos passos de **FL-xxx**; aqui o dev busca detalhe por repo.

**Regra:** didatico antes de exaustivo — rotas **criticas** nunca vao so em tabela de 1 linha.

Ver [pedagogical-examples.md](pedagogical-examples.md#tier-rt--classificar-na-fase-2).

---

## Tier 1 vs Tier 2

| Tier | Criterio | Formato no doc |
|------|----------|----------------|
| **Tier 1 — Criticas** | FL jornada critica OU erros classicos Fase 3 | **Corpo:** tabela resumo + link ficha · **Apendice:** ficha tecnica (curl) — **sem narrativa** (ver FL) |
| **Tier 2 — Referencia** | Demais rotas | **Lista agrupada por modulo** |

**Narrativa:** exclusiva em FL/RN — RT Apendice com `Ver [FL-xxx](#fl-xxx)`.

**Proibido:** `<details>` no indice; listar 200+ RT no topo.

**Proibido:** comprimir Tier 1 em celula de tabela. **Proibido:** Por que Tier 2 com 3 palavras genericas ("Operacao core").

Classificar Tier 1 na **Fase 2** e registrar lista antes da Fase 4.

Exemplos tipicos Tier 1: login, register, create deposit, webhook PIX, GET application config, triggers CRUD.

---

## RT-xxx — API HTTP (Tier 1 — expandido)

```markdown
<a id="rt-001"></a>
### RT-001: POST /players/login

#### Quando o dev usa esta rota

[Cenario: tela de login, quem chama, headers necessarios]

| Campo | Valor |
|-------|-------|
| Repo | `[core]` ([nome-da-pasta]) |
| Metodo | POST |
| Path | /players/login |
| Fluxo | [FL-001 Login](#fl-001) passo 2 |
| Apidog | [Ver endpoint](URL) ou — |
| Para que | [funcionalidade — frase completa] |
| Por que | [razao arquitetural/negocio — 2 frases se nao obvio] |
| Auth | Publico / JWT / role |
| Middleware | attachApplication, ... |
| Headers obrigatorios | x-application-domain: [exemplo] |
| Chama | playerService.signIn → integration |
| Retorno | { token, player } |
| Codigo | `src/modules/player/routes.ts` |

#### Exemplo de request

\`\`\`bash
curl -X POST 'https://api.exemplo.com/players/login' \
  -H 'Content-Type: application/json' \
  -H 'x-application-domain: app.expert-a.com' \
  -d '{"email":"joao@email.com","password":"***"}'
\`\`\`

#### Ver tambem

[FL-001](#fl-001) · [RN-002](#rn-002) · [G-002](#g-002)
```

---

## RT-xxx — Page (Tier 1 — expandido)

```markdown
<a id="rt-201"></a>
### RT-201: PAGE /auth/login

#### Cenario

[Usuario abre URL, o que ve, para onde vai apos sucesso]

| Campo | Valor |
|-------|-------|
| Repo | `[front]` ([nome-pasta]) |
| Tipo | Page |
| Path | /auth/login |
| Fluxo | [FL-001](#fl-001) passo 1 |
| Para que | Tela de login do jogador |
| Por que | Entrada do funil — tenant via ENV domain |
| Auth | Publica |
| Modulo | features/auth |
| Codigo | `app/auth/login/page.tsx` |
```

---

## RT-xxx — Route Handler / API no cliente

```markdown
<a id="rt-011"></a>
### RT-011: [METODO] /api/[path]

| Campo | Valor |
|-------|-------|
| Repo | `[front]` ([nome-pasta]) |
| Tipo | Route Handler |
| Fluxo | [FL-xxx](#fl-xxx) passo N |
| Para que | [proxy, BFF, agregacao] |
| Por que | [2 frases] |
| Codigo | [route.ts] |
```

---

## Tier 2 — Agrupado por modulo (referencia)

Agrupar por **primeiro segmento do path** — nao por metodo HTTP.

```markdown
#### core — Modulo players

Este grupo cobre autenticacao delegada e espelho local do **jogador** — login (FL-001), cadastro (FL-002). Nao confundir com `/admin/*`, que autentica localmente.

> **Exemplo white-label (adaptar paths/IDs ao produto):**

- [RT-071](#rt-071) POST /players/login — [FL-001](#fl-001)
- [RT-072](#rt-072) POST /players/register — [FL-002](#fl-002)

#### core — Modulo banners

Conjunto **CRUD** de banners promocionais no core — expert configura posicoes e conteudo via dashboard.

- [RT-019](#rt-019) GET /banners/
```

**Intro obrigatoria:** paragrafo ≥ 2 frases antes da lista — detectar CRUD (GET+POST+PUT+DELETE) ou link FL quando aplicavel. **Proibido** modulo Tier 2 com 1 rota isolada salvo Tier 1 (agrupar no modulo pai).

Titulos de grupo: texto plano (sem backticks no titulo do grupo).

---

## Campos obrigatorios

| Tier | Obrigatorio |
|------|-------------|
| Tier 1 | Repo, Para que, Por que (2 frases se contra-intuitivo), Codigo, Fluxo link, anchor, cenario ou "Quando o dev usa" |
| Tier 2 | Repo, intro modulo (2+ frases), Para que, Por que (1 frase), Codigo ou modulo, Fluxo link se aplicavel |

Apidog: quando existir link para aquele endpoint.

---

## Prioridade de fontes (API)

1. Apidog
2. Codigo
3. OpenAPI / swagger

---

## Agrupamento (ver index-grouping-guide.md)

Aplicar checklist **"Vale a pena agrupar?"** antes de renderizar indice RT. Dimensao tipica: repo + modulo de path — mas escolher conforme metadados do recon, nao por regra fixa.

```markdown
<a id="catalogo-de-rotas"></a>
## 🛣️ Catalogo de Rotas

### Indice RT

| Repo | Tier 1 | Tier 2 | Faixa RT |
|------|--------|--------|----------|
| `[core]` | N expandidas | M tabela | RT-001 … RT-NNN |
| `[front]` | 6 expandidas | 18 tabela | RT-201 … RT-224 |

### Tier 1 — Rotas criticas

[RT-001 expandido]
[RT-002 expandido]
...

### Tier 2 — Referencia por modulo

[tabelas compactas]
```

Incluir rotas Tier 1 no **Indice de artefatos** do documento master.

---

## Webhooks

Rotas webhook aparecem tambem como WH-xxx. Tier 1 sempre expandido.

Referenciar: `Ver tambem: [WH-001](#wh-001)`

---

## Proibido na Fase 4

- Gerar centenas de rotas via script com Por que generico identico ("Expert opera tenant")
- Listar Tier 1 apenas em tabela compacta
- Omitir links Fluxo na coluna Ref / Fluxo
