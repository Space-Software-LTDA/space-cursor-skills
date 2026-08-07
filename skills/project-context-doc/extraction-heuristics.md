# Heuristicas de Extracao

Sinais no codigo → o que documentar. **Buscar sempre**; **incluir no doc so se encontrar** (ver [language-guide.md](language-guide.md)).

---

## Reconhecimento de repositorios (Fase 0a)

Classificar cada pasta **pelo codigo**, nunca pelo nome:

```
Para cada diretorio candidato:
  1. Manifesto de projeto? (package.json, go.mod, pyproject.toml, ...)
  2. Stack UI? (React, Vue, Next pages, Flutter, ...)
  3. Servidor HTTP? (express, fastify, nest, gin, axum, ...)
  4. Persistencia? (entities/, prisma/, migrations/, models/)
  5. Clients HTTP externos? (adapters/, providers/, clients/, lib/*Api)
  6. Monorepo? (apps/*, packages/* — mapear cada um)
```

Apresentar tabela inferida ao usuario. Pedir Apidog **so para repos com rotas API** (item 3).

| Achado no recon | Apidog? |
|-----------------|---------|
| Cliente UI | Nao (salvo usuario informar) |
| 1 API | 0 ou 1 link |
| N APIs | 0 a N links (virgula, linha ou unico) |
| So lib sem servidor | Nao |

---

## Fluxos end-to-end (FL-xxx)

| Buscar | Onde |
|--------|------|
| Page/form → API client → service | frontend features, `shared/lib/api` |
| Service → HTTP client outro repo | `$integration`, axios com baseURL de env |
| Controller → adapter → provider externo | modules, adapters/, integrations/ |
| Webhook inbound → service → outbound | routes webhook, entity webhooks fields |

Rastrear cadeia completa antes de documentar RN/RT isolados.

Um FL-xxx por jornada critica: login, cadastro, pagamento, webhook, job async.

Ver [template-flows.md](template-flows.md).

---

## Auth e tokens

| Buscar | Onde |
|--------|------|
| Middleware/guards de auth | `middleware/`, `guards/`, decorators |
| JWT, sessions, OAuth | helpers, services, `jsonwebtoken`, passport |
| Roles, permissions | enums, decorators, policy classes |
| Hash persistido vs compare em login | services — auth local vs delegada |

Documentar: tipos de token, roles, rotas publicas vs protegidas, fluxo login/signup.

Documentar ausencia **so** se API exposta sem auth for surpreendente/relevante.

---

## Multi-tenant / contexto

| Buscar | Onde |
|--------|------|
| Headers de contexto (tenant, org, account) | middleware, api clients |
| Filtros por FK de contexto | services, repositories |
| `@Unique` compostos com entidade de contexto | entities |
| JSON de config por tenant/org | entities, settings |

Documentar: como contexto e resolvido, headers, isolamento no banco.

---

## Integracoes externas (INT-xxx)

| Buscar | Onde |
|--------|------|
| Pastas `adapters/`, `providers/`, `clients/` | wrappers por servico externo |
| HTTP clients com baseURL de env | `*_API_URL`, axios.create, fetch wrapper |
| SDKs terceiros | package.json dependencies |

Um INT-xxx por servico/provider encontrado: **Repo (alias)**, para que, por que separado, quem consome, ENV, Fluxo (FL passo).

---

## Webhooks (WH-xxx)

| Buscar | Onde |
|--------|------|
| Rotas com `webhook` no path | routes, controllers |
| Middleware de assinatura/secret | middleware, HMAC validators |
| URLs outbound em config/entity | webhooks fields, POST dinamico |
| Env `WEBHOOK_*`, `*_SECRET` | .env.example |

WH-xxx: inbound/outbound, publica/protegida, para que, por que, o que atualiza.

---

## Crons / jobs / workers (CR-xxx)

| Buscar | Onde |
|--------|------|
| `*.worker.ts`, `*scheduler*`, `jobs/` | modules |
| `setInterval`, cron libs, queue workers | server bootstrap, Bull, sidekiq patterns |
| `start*Job`, `initialize*Worker` | entrypoints |

CR-xxx: frequencia, processa o que, arquivo, falha/retry, por que.

---

## Variaveis de ambiente

| Buscar | Onde |
|--------|------|
| `.env.example` | raiz (prioridade) |
| `process.env`, `os.Getenv`, `ENV[]` | grep no src |

Tabela: nome, repo, obrigatoria, para que, por que. **Nunca** valor de secret.

---

## Heuristicas RN (regras de negocio)

| Sinal | RN candidata |
|-------|--------------|
| HTTP externo antes de acao local | Delegacao para servico externo |
| Persistencia de credencial sem validacao local | Cache/espelho; auth em outro lugar |
| Sync condicional por data | Politica de sincronizacao |
| Unique composto com entidade de contexto | Isolamento multi-tenant |
| Soft delete | Comportamento de exclusao |
| Transacao + rollback | Atomicidade |
| Hardcode por tenant/domain | Excecao por cliente |
| Token externo embutido em JWT/session | Auth hibrida |
| Event/trigger pos-acao | Automacao pos-evento |
| Gate antes de acao (KYC, verificacao) | Compliance / pre-condicao |

Marcar `[CONFIRMAR]` quando inferencia nao for obvia.

---

## Heuristicas G (guardrails)

| Sinal | G candidato |
|-------|-------------|
| Middleware throw se header/campo ausente | Obrigatoriedade enforced |
| CLAUDE.md / AGENTS.md / rules | Convencao confirmada |
| Comentarios NEVER/IMPORTANT/HACK | Revisar |
| `@Exclude`, `@JsonIgnore` | Nao expor em API |
| Schema validation obrigatoria | Payload invalido rejeitado |

---

## Rotas (RT-xxx)

| Tipo repo | Buscar |
|-----------|--------|
| API HTTP | router methods, controllers, OpenAPI |
| Cliente UI | pages, routes file-based |
| API routes no client | `app/api`, server handlers |

Extrair: middleware chain, auth, headers, servico chamado. Apidog quando disponivel.

**Agrupamento Tier 2:** primeiro segmento do path (`/players/*` → modulo `players`, `/banners/*` → `banners`). Pages front/dashboard: primeiro segmento apos `/`.

**Normalizacao catalogo (obrigatoria antes de agrupar):** tupla canonica `(rt_id, method, path, para_que, repo, fluxo)`. Corrigir entradas onde method contem path (`GET /applications/config` → method=`GET`, path=`/applications/config`). Se path parece descricao (sem `/`), trocar com para_que. Regenerar JSON apos fix.

**Git remotes (Fase 4):** por repo mapeado na Fase 0b:

```bash
git -C [pasta-repo] remote get-url origin
```

Incluir URL na Referencia rapida e na tabela Mapa (coluna Git). Se falhar: `[CONFIRMAR]`.

---

## Banco (TB-xxx)

| Fonte | Acao |
|-------|------|
| Entity/model class | 1 TB por tabela |
| Cada coluna/campo | Para que + Por que |
| Relations | Ref DBML + FK explicada |
| JSON columns | Sub-tabela de chaves |
| Virtual/computed | Note runtime |

Ordem: core → transacional → config → auxiliar.

---

## Convencoes (G-xxx)

| Arquivo | Acao |
|---------|------|
| CLAUDE.md, AGENTS.md | Extrair regras como G-xxx |
| .cursor/rules, CONTRIBUTING | Idem |

---

## Fluxo pos-busca

```
Para cada dominio:
  1. Buscar no codigo
  2. Achou >= 1 → rascunho para doc (Fase 2 — nao gravar arquivo)
  3. Nao achou → omitir secao
  4. Inferencias → [CONFIRMAR]
  5. Fase 3 → apresentar entrevista; aguardar usuario
  6. Fase 4 → gravar .docs/contexto-[slug].md
```

---

## Checklist Fase 1 (interno)

- [ ] Repos classificados pelo codigo; aliases propostos
- [ ] Entities mapeadas por repo
- [ ] Rotas mapeadas (+ Apidog se houver)
- [ ] Cadeias cross-repo identificadas (candidatos FL-xxx)
- [ ] Auth, tenant, INT, WH, CR, ENV rascunhados
- [ ] Convencoes lidas
- [ ] FL/RN/G iniciados
