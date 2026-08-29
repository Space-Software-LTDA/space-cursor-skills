> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro** (quem lê o quê e por quê). Editar no repo `space-cursor-skills/docs/`; destino Cursor é cópia (`npm run sync`).

# Catálogo de anti-padrões

[entry-point.md](entry-point.md) já cobre pass-through, god-file, `prepare`/`handle`, micro-arquivos, `runEverything` e SQL no entry. **Não repetimos esse texto** — apontamos o ID e seguimos para o que o entry point não cobre.

Como cada skill usa este arquivo: [README.md](README.md).

**PO** cita IDs nos critérios da task. **QA** usa sobretudo a seção Frontend (AP-FE-*) no código e no Network. **Contexto de produto** não cola o catálogo inteiro — um G-xxx aponta o ID quando o código do produto viola.

IDs de entry point (para citar em PR/task) — seções em [entry-point.md](entry-point.md):

| ID | Seção |
| --- | --- |
| AP-EP-01 | 8.1 Pass-through puro |
| AP-EP-02 | 8.2 God-file |
| AP-EP-03 | 8.3 Nomes genéricos |
| AP-EP-04 | 8.4 Comentário no lugar de nome |
| AP-EP-05 | 8.5 Micro-arquivos |
| AP-EP-06 | 8.6 Pasta `pipeline/` |
| AP-EP-07 | 8.7 Helper `runEverything` |
| AP-EP-08 | Controller gordo (HTTP + SQL + render no handler) — ver também §3 e §11 |
| AP-EP-09 | Função com 8+ parâmetros posicionais — virar `Ctx` (ver anatomia §6) |

Abaixo, cada item tem: cenário, por que dói, ouro, exemplo, erro comum, severidade.

## A. Nomenclatura (além da tabela da [entry-point.md](entry-point.md) §12)

### AP-NAM-01 — Nome que mente

**Cenário.** O júnior precisa falar com um serviço atrás de WAF. Ele encontra `axiosVendorProxy.ts`, instala `axios`, e todas as calls voltam 403. Por baixo, o arquivo antigo já era `fetch` nativo com opção de proxy — o **nome** que o fez instalar a lib errada.

Outro caso: a pasta no disco é `payments`, a chave no banco é `billing`, as classes são `PaySvc`. O roteador faz `platform.name.toLowerCase()` e 500 “não suportado”.

**Por que dói.** Nome é documentação ([entry-point.md](entry-point.md), regra 4). Nome mentiroso treina o time a desconfiar de *todos* os nomes. O próximo copy-paste replica o Axios de verdade.

**Ouro.** `vendorHttpClient.ts` se é HTTP do vendor. Pasta = chave = identificador persistido. Zero ` copy` no nome de arquivo. Rename de identificador persistido é **migração com alias**, não search-replace na cara — e só quando a task for de rename.

**Erro comum.** “Depois a gente renomeia.” Não renameia. Cinco módulos depois, ninguém sabe qual nome é o verdadeiro.

**Sev:** P1 · **ALL**

### AP-NAM-02 — Typo no contrato público

**Cenário.** O type de depósito tem `experiation` (expiration). O cliente (outro repo) já tipou igual. Um júnior “corrige a grafia” no hub. O cliente não lê mais o campo. PIX sem validade na tela.

**Por que dói.** Typo no JSON **público** vira contrato. Corrigir sem os dois lados juntos quebra produção.

**Ouro.** Type **novo**: inglês correto. Type legado público: não “limpe” a grafia nesta sprint; adicione o nome certo **além** e combine a virada. JSON sujo de terceiro: typo fica no type **interno** da integração, não vaza para o DTO global.

**Erro comum.** PR de “chore: typos” em campo que o mobile já parseia.

**Sev:** P1 no contrato · P2 se for variável local

### AP-NAM-03 — `id`, `id2`, `data`, mistura PT+EN

**Cenário.** Webhook chega com `player_id`. Por razões históricas isso é o id de **acesso**, não de jogador. O júnior grava em `players.id` e o funil inteiro atribui evento à pessoa errada.

**Por que dói.** `id` sem substantivo não diz *de quem*. Alias silencioso (`player_id` = access) só existe na cabeça de quem escreveu.

**Ouro.** `customerId`, `accessId`, `orderId`. Um idioma por codebase. Alias legado: comentário **e** campo no type com o nome verdadeiro (`accessId: body.player_id`).

**Erro comum.** “O body já vem assim, eu só repasso.” Repassar sem traduzir **espalha** o contrato ruim.

**Sev:** P2; P1 se o HTTP público ficou ambíguo

### AP-NAM-04 — Repo, branch ou commit fora da manufatura Space

**Cenário.** A task pede um serviço novo. O júnior cria `Space-Cardapius-Backend` (CamelCase, hífen, maiúscula). Ou a branch `feat/login` em vez de `PBI-2304`. Ou commit `"ajustes"` sem tipo. O próximo clone, o EasyPanel e o ClickUp não batem. Ninguém acha o repo pelo padrão `[cliente]_[projeto]_[tipo]`.

**Por que dói.** Nome de repo e de branch é como o time **encontra** o trabalho. Fora do padrão, o onboarding mente e o SuperAgente/ClickUp não amarra PBI ↔ git.

**Ouro.** [nomenclatura.md](nomenclatura.md) + [git-fluxo.md](git-fluxo.md):

- Repo na org Space: `cliente_projeto_tipo` (tudo minúsculo, underscore). Na org do cliente: `projeto_tipo`.
- Branch: `PBI-2304` a partir de `main`. Hotfix: `hotfix_descricao` a partir de `main`.
- PR: `PBI-2304 - O que está sendo ajustado`.
- Commit: `feat: …` / `fix: …`.

**Erro comum.** “É só um nome, depois a gente padroniza.” O remote já está criado; rename de repo quebra clone, CI e EasyPanel.

**Sev:** P1 · **ALL**

### AP-NAM-05 — Tabela/coluna de banco fora do padrão Space

**Cenário.** A task cria cadastro. O júnior faz `CREATE TABLE ClientePedidos` (CamelCase na tabela) e colunas `nome_cliente`, `created_at`. Ou esquece `createdAt`/`updatedAt`. Ou o usuário do Postgres é `admin`. O próximo júnior abre o onboarding, vê `snake_case` na tabela e `camelCase` na coluna, e acha que o código está “errado” — aí nasce o segundo padrão.

**Por que dói.** O banco é compartilhado entre APIs, dash, jobs e o olho humano no EasyPanel. Dois jeitos de nomear coluna = bug silencioso no TypeORM (`nomeCliente` vs `nome_cliente`). Sem `createdAt`/`updatedAt` não há auditoria.

**Ouro.** PostgreSQL. Detalhe e exemplo SQL em [nomenclatura.md](nomenclatura.md):

| Peça | Padrão |
| --- | --- |
| Usuário | `space_[nomedocliente]` |
| Senha | Aleatória, **sem** caracteres especiais |
| Tabela / database | `snake_case` (`cliente_pedidos`) |
| Coluna | **camelCase** (`nomeCliente`, `dataPedido`) |
| Auditoria | `createdAt` e `updatedAt` **obrigatórias** em toda tabela |

Entity, migration e trecho SQL da **mesma** task. TypeScript ≠ migration é AP-DB-04.

**Erro comum.** Copiar o hábito Nest/Prisma `created_at` em snake na coluna “porque o Postgres prefere”. Aqui a coluna é camelCase. O onboarding antigo escreveu `createAt` — o nome certo é **`createdAt`**.

**Sev:** P1 · **BE**

### AP-NAM-06 — EasyPanel / serviço com nome inventado

**Cenário.** O projeto no painel se chama `Cardapius PROD` com espaço e maiúscula. A app é `api-nova`. O runbook diz `space_cardapius` / `backend`. O plantão não acha o serviço às 3h.

**Por que dói.** Painel é inventário. Nome fora do padrão = dois sistemas de verdade na cabeça do time.

**Ouro.** Projeto EasyPanel: `[nome-do-cliente]_[nome-do-projeto]`. Aplicação: `[nome-do-servico]`. Backup de banco e arquivos em local seguro. Ver [nomenclatura.md](nomenclatura.md).

**Erro comum.** Batizar o serviço com o apelido do cliente no Slack.

**Sev:** P2; P1 se produção já está no nome errado e a task é de criar mais um serviço no mesmo padrão quebrado

---

## B. Loops, retry, N+1

### AP-LOOP-01 — `while (true)` / retry sem teto / cron TEMP eterno

**Cenário.** Login no parceiro às vezes cai em página HTML de WAF. O júnior põe `while (true) { try { login(); break } catch { trocaIp() } }`. Senha errada (401) também gira IP. A conta toma lockout. Ou: cron `* * * * *` com `// TEMP voltar para 0 8 * * *` que ficou um ano.

**Por que dói.** Loop sem teto come CPU, gasta proxy e **agride** o parceiro. Cron a cada minuto em dois pods é thundering herd. 401 não é “tenta de novo com outro IP” — é credencial.

**Ouro.**

```typescript
const MAX_ATTEMPTS = 3
for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
  const result = await callPartner(session)
  if (isCredentialError(result)) throw result // não retenta
  if (!isEdgeBlock(result)) return result     // 502/HTML challenge = retenta
  session = randomSession()
}
throw new ExternalServiceError('partner unavailable')
```

Backoff. Cron: intervalo honesto + lock (AP-JOB-01). Comentário TEMP **não** mergeia.

**Erro comum.** Retry em “qualquer erro” porque “fica mais resiliente”.

**Sev:** P0

### AP-LOOP-02 — `for` dentro de `for` + query ou HTTP no miolo (N+1)

**Cenário.** Job noturno: para cada evento do dia, `await accessRepo.getById(event.accessId)`. 8 mil eventos = 8 mil queries. O job passa de 1h, overlap com o cron seguinte (sem lock), duplica mensagem.

Outro: dashboard lista 40 experts e, **por linha**, chama a API de ads.

**Por que dói.** Banco e parceiro não foram desenhados para N ida-e-volta por item. Timeout, pool esgotado, rate limit. O júnior “não conhece `WHERE id IN`”.

**Ouro.** Uma query `WHERE id IN (...)`. Um batch HTTP. Depois, `Map` em memória. Se a API do parceiro não tem batch, **ainda assim** não faça N no request do usuário — fila, cache, ou endpoint agregado.

```typescript
// ❌
for (const event of events) {
  const access = await accessRepo.getById(event.accessId)
  // ...
}

// ✅
const ids = [...new Set(events.map((e) => e.accessId))]
const accesses = await accessRepo.getByIds(ids)
const byId = new Map(accesses.map((a) => [a.id, a]))
for (const event of events) {
  const access = byId.get(event.accessId)
  // ...
}
```

**Erro comum.** `Promise.all(rows.map(r => api.get(r.id)))` — ainda é N HTTP, só paralelo. Estoura rate limit mais rápido.

**Sev:** P0 no job/hot path · P1 senão

---

## C. Banco

### AP-DB-01 — Excesso de roundtrip por não conhecer o ORM

**Cenário.** Login: `findOne` pelo email; não achou, `save`; `findOne` de novo para pegar o id; `exist` no depósito; `save` o depósito; `findOne` o depósito para devolver. Sete viagens. O token **já tinha** o id.

**Por que dói.** Cada roundtrip é latência + conexão do pool. No caminho de login/pagamento, isso é produto lento **antes** do parceiro.

**Ouro.** Pergunte: “eu já tenho esse dado no token / no `ctx`?” Se sim, **zero** query. Se precisa persistir: um `upsert` / `save` que devolve a entidade. `exist` + `save` do mesmo registro quase sempre é um `save`.

**Erro comum.** Copiar o `getOrCreate` de um módulo em todo adapter “para ficar igual”.

**Sev:** P1

### AP-DB-02 — SQL concatenado / raw no service / SQL no `utils/`

**Cenário.**

```typescript
await db.query("SELECT * FROM users WHERE email = '" + email + "'")
```

Ou `sql\`select ...\`` no **use case**, ou `utils/attribution.ts` com `SELECT`.

**Por que dói.** Concatenar string = SQL injection. Raw no use case quebra a [entry-point.md](entry-point.md) (SQL não é roteiro). Util com I/O deixa de ser puro: teste vira integração, e ninguém acha a query.

**Ouro.** Repository + parâmetros bound (`$1`, `:email`). QueryBuilder quando o ORM não expressa o filtro. Um helper `searchOrdersByExternalIds(ids)` **no repo**, não 16 cópias de `LOWER()`. `utils/` só formata/calcula.

**Erro comum.** “É query admin, ninguém injeta.” O endpoint será público na próxima sprint.

**Sev:** P0 se concatenar · P1 se camada errada

### AP-DB-03 — Trazer a tabela e filtrar na aplicação

**Cenário.** `const all = await repo.find()`; `all.filter(x => x.status === 'paid').slice(0, 25)`. Front: `?limit=1000` e pagina no client. A página 1 “funciona” com 40 rows de teste. Em produção são 200 mil.

**Por que dói.** Memória, timeout, UX mentirosa (usuário acha que viu tudo).

**Ouro.** `WHERE` + `LIMIT`/`OFFSET` (ou cursor). Front manda `page` e `limit`. Paginação **server-side** em dado real.

**Erro comum.** “Depois a gente põe paginação.” O client já desenhou a tabela inteira.

**Sev:** P1

### AP-DB-04 — TypeScript ≠ migration

**Cenário.** `amount_cents: string` no type da tabela; a migration é integer. Ou: `AccessUpdate` tem `space_fbclid` que **não** está nas colunas do `SELECT`. Ou: tabela `ftds` dropada, `ftd.repo.ts` ainda no tree só com `throw`.

**Por que dói.** O compiler dá uma segurança falsa. Runtime: valor errado, campo ignorado, ou import de stub que sempre falha.

**Ouro.** Type da tabela atualizado **no mesmo PR** da migration. Coluna que o update manda existe no schema. Stub de tabela morta: apagar.

**Erro comum.** “O Kysely reclama, eu pus `as any` no repo.”

**Sev:** P1

---

## D. HTTP e integração

### AP-HTTP-01 — Call extra só para ler o que já está no token

**Cenário.** `POST /deposits` faz `GET /users/me` no parceiro **só** para ler `user.id`. O login já devolveu. O JWT nosso já tem `partnerUserId`. A call extra atravessa proxy (300ms–2s). O QR atrasa. Em retry, vira 3 hits.

Variante: a variável `me` é atribuída e **nunca usada**. A call é 100% morta.

**Por que dói.** GO-04. Proxy e WAF cobram por request. O usuário não pediu o perfil; pediu o PIX.

**Ouro.** Ler `partnerUserId` do JWT. Fallback: coluna no banco. `GET /me` só se **ambos** vazios (legado), e isso vira log de “token incompleto” — não o caminho feliz.

**Erro comum.** “Pode ter mudado o id no parceiro.” Se o id mudou, o token interno está inválido: **relogin**, não um `/me` escondido no depósito.

**Sev:** P1; P0 no caminho de pagamento

### AP-HTTP-02 — Operação A busca dados da operação B

**Cenário.** Contrato de login do cliente: `{ token: string }`. O adapter **sempre** chama `/me` no login “para já ter CPF caso alguém precise”. O cliente **não** manda flag. CPF vai no JSON e ninguém lê. A rota `GET /me` existe para isso.

**Por que dói.** Login fica um RTT mais lento. Você acoplou duas operações. O type global incha (AP-TYPE-01).

**Ouro.** Login devolve login. Perfil devolve perfil. Flag opcional **só** se o cliente realmente envia e o contrato documenta.

**Erro comum.** “É o mesmo adapter, uma call a mais não mata.” Mata na proxy. Mata no WAF. Mata no p95.

**Sev:** P1

### AP-HTTP-03 — Métrica no caminho crítico

**Cenário.** “Primeiro pagamento do cliente” (FTD / first paid). O adapter chama `/me` **await** para ler `first_deposit` **antes** de devolver o QR. O dashboard do afiliado agradece. O cliente na fila do PIX não.

**Por que dói.** GO-05. Métrica não gera o QR.

**Ouro.** Calcule local (`payments.isPaid` já existentes). Confirme no parceiro: (1) no `GET /payments/:id` que o front já faz polling, ou (2) fire-and-forget com log:

```typescript
void confirmFirstPaymentOnPartner(payment.id).catch((err) =>
  logError('ftd_confirm_failed', { paymentId: payment.id, err }),
)
return { qrCode, copyPaste }
```

**Erro comum.** `this.confirmFtd()` sem `await` **e** sem `.catch` — a promise falha silent (AP-HTTP-06).

**Sev:** P1

### AP-HTTP-04 — Client HTTP errado / clone de 800 linhas / `dev` ≠ produção

**Cenário.** O WAF bloqueia fingerprint de Axios/Node fetch. O projeto já tem `fetch` nativo do runtime de produção com `proxy:`. O júnior “conhece Axios” e cria `axios.create()`. 403 em tudo. Horas debugando credencial.

Ou: o proxy **só liga** no `start` do engine certo. `npm run dev` passa. Produção quebra.

**Por que dói.** Falso positivo. Integração “fora do ar”. 16 clones do client = 16 políticas de retry.

**Ouro.** Um client em `shared/`. Nome honesto (`partnerFetch`, não `axiosX` se não é Axios). Teste no comando que produção usa (`build && start` quando isso for o que liga proxy). Documente na task: “não feche o PR só com `dev`”.

**Erro comum.** Copiar o arquivo de 890 linhas da integração “boa” para a pasta nova em vez de extrair o módulo.

**Sev:** P0 se produção diverge

### AP-HTTP-05 — Retry que muda identidade no meio da sessão

**Cenário.** Cada request ao parceiro nasce com IP/session aleatória. O parceiro invalida a sessão. Login funciona, depósito 401. Ou: retry de WAF gera session nova, **não grava** no JWT, o depósito sai com o IP antigo (queimado) ou com outro IP de novo.

**Por que dói.** Identidade sticky existe para o parceiro achar que é o mesmo dispositivo. Sem persistir a session vencedora, o retry **não** ajudou o próximo request.

**Ouro.**

1. Primeira tentativa: session derivada do `userId` (tamanho que a proxy aceita — documente o máximo, ex. 12 caracteres).
2. Bloqueio de borda (502, HTML challenge): session aleatória, teto 2.
3. A session que funcionou **entra no JWT**.
4. Requests seguintes **leem** o JWT. Não geram session nova “por request”.
5. 401 de senha **não** retenta.

**Erro comum.** Retry no client HTTP **sem** devolver a session ao caller — o login nem fica sabendo qual IP venceu.

**Sev:** P0

### AP-HTTP-06 — Fire-and-forget sem observabilidade

**Cenário.** `AdsApi.emitEvent(payload)` sem `await` e sem `.catch`, no meio do webhook de pagamento. A promise rejeita. Ninguém vê. O afiliado jura que o pixel não disparou. Ou dispara **duas** vezes no retry do webhook e ninguém tem log.

**Por que dói.** Falha invisível. Duplicata invisível. GO-05 permite background; **não** permite sumir com o erro.

**Ouro.**

```typescript
// precisa do resultado
await AdsApi.emitEvent(payload)

// de propósito assíncrono
void AdsApi.emitEvent(payload).catch((err) =>
  logError('ads_emit_failed', { event: payload.name, err }),
)
```

Nunca `fn()` solto “para não atrasar”.

**Erro comum.** “É só telemetria.” Telemetria que o comercial usa para cobrar campanha **é dinheiro**.

**Sev:** P0

---

## E. Auth e token

### AP-JWT-01 — Token de terceiro como se fosse o nosso

**Cenário.** Login devolve `access_token` cru do parceiro. O nosso backend guarda isso e manda de volta no `Authorization`. O adapter da próxima call não tem `userId` interno nem session de proxy. Solução do júnior: `GET /me`. Bola de neve.

**Por que dói.** GO-07. Sem payload nosso, cada módulo inventa um jeito de “descobrir quem é o usuário”.

**Ouro.** `generateAppToken({ userId, partnerUserId, partnerAccessToken, sessionId })` / `decodeAppToken(authorization)` — **um** par, em `shared/`. Campos extras de um parceiro (segundo cookie, JWE) são extensão do mesmo JWT, não `generateVendorXToken` copiado.

**Erro comum.** Sete funções `generateCactusToken`, `generateLottusToken`… quase iguais. É o germe da duplicação.

**Sev:** P0

### AP-JWT-02 — TTL interno derruba sessão de produto

**Cenário.** Produto: “o jogador não reloga por relógio nosso.” Código: `expiresIn: '30d'`. Dia 31 o app 401. O parceiro ainda aceitaria o token embutido.

**Por que dói.** TTL nosso e TTL deles são relógios diferentes. O produto escolheu um. O código implementou outro.

**Ouro.** Se a regra é sessão interna eterna: `jwt.sign(payload, secret)` **sem** `expiresIn`. Decode de token legado com `exp`: `ignoreExpiration: true` enquanto houver base instalada. Token do **parceiro** continua sujeito à regra **deles**.

**Erro comum.** “30 dias é bastante.” Até o usuário viajar e abrir o app no dia 31.

**Sev:** P1

### AP-JWT-03 — Secret default / Basic `admin`/`admin`

**Cenário.** `const secret = process.env.JWT_SECRET || "secret"`. Staging sobe sem env. Produção um dia também. Ou basic auth default no dashboard interno.

**Por que dói.** Qualquer um forja JWT. Onboarding “fácil” vaza para a internet.

**Ouro.** Fail fast na boot se env obrigatória faltar. Sem default de credencial. `.env.example` sem valor real.

**Erro comum.** “É só para o `npm start` local.” O mesmo binário vai para o container.

**Sev:** P0

### AP-JWT-04 — Mandar o JWT do app para o parceiro

**Cenário.** Debug no DevTools: copia `Authorization` do browser (JWT **nosso**) e cola no client que fala com o parceiro. 401. O usuário “está logado” na UI.

**Por que dói.** Duas camadas de auth. O parceiro nunca assinou o nosso JWT.

**Ouro.** Authorization para o parceiro = campo `partnerAccessToken` (ou cookie) extraído do **nosso** JWT. Nunca o bearer cru do browser.

**Erro comum.** Middleware que “repassa Authorization” sem olhar o destinatário.

**Sev:** P0

---

## F. Tipagem e contrato

### AP-TYPE-01 — Type global com tudo `?`

**Cenário.**

```ts
export interface UserGlobal {
  id?: string
  token?: string
  url?: string
  gender?: string
  cpf?: string
  digits?: number
}
```

Login devolve `{ token }`. TypeScript aceita `{ url: "http://lixo" }` como login. O cliente faz `data.token` e explode.

Segundo problema: `cpf: phone` no mapper. Compila, porque `cpf?` aceita qualquer string. Dado errado segue a vida.

Terceiro: um adapter preenche `url`, outro não. O cliente “depende” de `url` num tenant. Bug de uma integração só, impossível de tipar.

**Por que dói.** GO-03. Type frouxo é pior que `any`: dá uma **sensação** de segurança.

**Ouro.** Types **por operação**, obrigatórios, iguais ao consumidor:

```ts
export type LoginResult = { token: string }
export type ProfileResult = {
  phoneNumber: string
  email: string
  name: string
  registrationDate: string
  cpf: string
  birthday: string
}
export type WalletResult = {
  totalBalance: number
  balanceBonus: number
  balanceWithdrawal: number
}
```

Envelope HTTP `{ success, message, data }` é outra camada. O `data` é o type acima.

**Erro comum.** “Deixa opcional que cada vendor manda um subset.” Então o type **não é global**. São 16 types internos + 1 DTO fechado na saída.

**Sev:** P0

### AP-TYPE-02 — `any` / `z.any()` / `as any` na fronteira

**Cenário.** Webhook `function handle(body: any)`. Schema `payload: z.any()`. Repo de redirect: `as any` em toda query porque o type da tabela atrasou.

**Por que dói.** A borda HTTP é onde o dado **desconhecido** entra. Se ali é `any`, o `any` infecta o módulo inteiro.

**Ouro.** Zod/DTO na borda. Parse falha = 400 com lista de campos. Erro de domínio (`ValidationError`), não `throw new Error("falhou")`. `as any` no repo = o type da tabela está errado (AP-DB-04), não o contrário.

**Erro comum.** `z.any()` “só no custom_data do pixel”. Esse custom_data vira SQL JSON e alguém faz relatório em cima.

**Sev:** P1

### AP-TYPE-03 — Front inventa campo / lista para montar detalhe

**Cenário.** Tela `/orders/123`. O front faz `GET /orders?limit=1000` e `find(o => o.id === '123')`. Ou mostra `order.vipLevel` que a API nunca mandou — `undefined` vira layout quebrado.

**Por que dói.** Overfetch, dado stale, campo fantasma. Em produção a lista não contém o id (paginação).

**Ouro.** `GET /orders/:id`. Campo só existe se o contrato tem. OpenAPI/back primeiro.

**Erro comum.** “A lista já está no cache do React Query.” Cache não é a ficha do recurso.

**Sev:** P1 · **FE**

### AP-TYPE-04 — Non-null assertion no lugar de guard

**Cenário.** Webhook: `const accessId = resolveAccessId(body)!` na primeira linha. Body sem id. Crash com stack inútil no meio do mapper.

**Por que dói.** `!` é “eu sei mais que o compiler”. No webhook, você **não** sabe.

**Ouro.**

```typescript
const accessId = resolveAccessId(body)
if (!accessId) throw new ValidationError('accessId required')
```

**Erro comum.** Encadear `a!.b!.c!` porque o Zod “já validou” — e o schema tem tudo `.optional()`.

**Sev:** P1

---

## G. Camadas, duplicação, overengineering

### AP-LAY-01 — Service pass-through

**Cenário.**

```typescript
export class DashboardService {
  static list(...) { return DashboardRepository.list(...) }
  static get(...) { return DashboardRepository.get(...) }
}
```

Controller chama Service chama Repo. O Service não tem uma linha de regra.

**Por que dói.** [entry-point.md](entry-point.md) §13: wrapper sem Trace/guard/transform é proibido. Hop extra. O júnior procura a regra no service e não acha.

**Ouro.** Controller → entry (se houver regra) ou repo. Crie service **quando** houver regra.

**Erro comum.** “Arquitetura em camadas manda ter service.” Camada vazia não é arquitetura.

**Sev:** P2

### AP-LAY-02 — Util faz HTTP ou SQL

**Cenário.** `src/utils/ads-metrics.ts` dá `fetch` na API de anúncios. `src/utils/resolve-access.ts` faz `SELECT`. O entry parece limpo; o I/O está escondido num “util”.

**Por que dói.** [entry-point.md](entry-point.md) §11: HTTP em `*-api.ts`, SQL em repository, util **puro**. Teste de util vira teste de rede. Ninguém acha a query no grep de `repository`.

**Ouro.** Mova. O util fica com `formatCents`, `normalizeCpf`, `toIsoDate`.

**Erro comum.** “É só um getzinho.” O getzinho cresce um `if` de tenant hardcoded (AP-JOB-03).

**Sev:** P1

### AP-LAY-03 — God-service / job monólito

**Cenário.** `tracking-event.service.ts` com 570 linhas: grava access, dispara ads, dispara outro ads, cria registro “fantasma” se não achou tenant, muta o payload. `daily.job.ts` com 460: SQL + WhatsApp + métrica + mensagem HTML.

**Por que dói.** [entry-point.md](entry-point.md) §8.2, só que em “service” em vez de “entry”. Abrir o arquivo é labirinto. Duplicar um bloco “criar access default” quatro vezes (AP-LAY-04).

**Ouro.** Entry do job/caso de uso no topo ([entry-point.md](entry-point.md)). Capítulos nomeados. Arquivo novo **só** se o capítulo passou de ~150–200 linhas **e** o entry ainda lista a chamada.

**Erro comum.** Extrair `helpers.ts` de 400 linhas — o labirinto mudou de nome.

**Sev:** P0–P1

### AP-LAY-04 — Clone de fluxo quase igual

**Cenário.** `deposit.service`, `first-payment.service`, `withdraw.service`: 90% o mesmo roteiro (fila → valida id → persiste → emite evento). Bug de fila corrigido num, os outros dois continuam errados.

**Por que dói.** Correção em N lugares. A **diferença** (é depósito vs saque) fica invisível no meio do copy-paste.

**Ouro.** Capítulo compartilhado (`enqueueByCustomer`, `persistLedgerEntry`) e entry **por** operação onde a diferença é uma linha visível (`chargePaymentIfNew` vs `recordWithdrawIfNew`). Não um `runEverything(type: 'deposit' | 'ftd' | 'withdraw')` opaco (AP-EP-07).

**Erro comum.** Abstrair cedo demais com um `type: string` e um `switch` de 80 linhas.

**Sev:** P1

### AP-LAY-05 — Overengineering de IA / júnior “enterprise”

**Cenário.** Factory de factory. Decorator de tracing com 270 linhas e exemplo com `any`. Client HTTP clonado. `@Trace` em todo handler que só loga o body (com senha).

**Por que dói.** Ninguém debuga. A IA replica o monstro. A [entry-point.md](entry-point.md) pede roteiro de 10–40 linhas, não um framework interno.

**Ouro.** Extraia o **mínimo** que 2+ callers precisam. Tracing no controller/entry. Sem nova camada “porque vi num blog”.

**Erro comum.** “Vamos deixar genérico para a próxima integração.” A próxima integração copia o arquivo inteiro.

**Sev:** P1

### AP-LAY-06 — Mutação do payload de entrada

**Cenário.** `req.body.cookies = JSON.parse(req.body.cookies)`. `Object.assign(tracking, parsed)`. Outro middleware ainda lê `req.body` e vê cookies já virados objeto — ou string quebrada no meio do parse.

**Por que dói.** Objeto compartilhado. Ordem de middleware vira bug heisenbug.

**Ouro.**

```typescript
const tracking = {
  ...input,
  cookies: parseCookies(input.cookies),
}
```

Não mutar `req.body`. Não mutar o `eventData` depois que o builder devolveu.

**Erro comum.** “É mais barato mutar do que copiar.” Uma cópia rasa não é o custo do seu produto.

**Sev:** P1

### AP-LAY-07 — Função com 8+ parâmetros posicionais

**Cenário.** `sendRegisterEvent(id, email, phone, fbc, ip, ua, expertId, eventName, extra)` na linha do controller. Quem lê não sabe o que é o 7º argumento. Trocar ordem = bug silencioso.

**Por que dói.** [entry-point.md](entry-point.md) §6: o fluxo carrega um `Ctx`. Posicional demais é história opaca.

**Ouro.** Um objeto `RegisterEventInput`. O entry recebe `params` e monta `ctx`.

**Erro comum.** Adicionar o 10º parâmetro “opcional no final”.

**Sev:** P1

---

## H. Jobs, cron, processo

### AP-JOB-01 — Cron sem lock / intervalo TEMP / default ligado

**Cenário.** `cron.schedule('* * * * *', runReport)` com `// TEMP`. Dois réplicas no Kubernetes. O relatório dispara duas vezes por minuto. Ou: job de 70 minutos no cron horário, overlap.

Flag: `if (process.env.JOBS_OFF === 'false')` — ausência da env **liga** o cron.

**Por que dói.** Duplicata de mensagem, de cobrança, de snapshot. TEMP eterno é feature acidental.

**Ouro.** Lock distribuído (advisory lock Postgres, Redis `SET NX`). Intervalo real no `main`. Ligar cron só com `JOBS_ENABLED === 'true'` (default **off** se a dúvida existir). TEMP não mergeia.

**Erro comum.** “No EasyPanel só tem um pod.” Até o dia do deploy blue-green.

**Sev:** P0

### AP-JOB-02 — Side-effect no `import`

**Cenário.** `src/index.ts` importa `./jobs/daily` e o arquivo do job, no load, chama `cron.schedule`. `npm test` que importa o app registra cron. Script de migration dispara WhatsApp.

**Por que dói.** Import não é ciclo de vida da aplicação.

**Ouro.**

```typescript
server.listen(port, () => {
  startJobs()
})
```

`startJobs` é função. Teste não chama.

**Erro comum.** `console.log` no topo de `dateTime.ts` — todo import polui log.

**Sev:** P1

### AP-JOB-03 — Tenant / domínio / “expert padrão” hardcoded

**Cenário.** `const domain = input.domain ?? 'app.cliente-x.com'`. Access sem tenant vira row no tenant X. Relatório do expert Y some. Ou: `expertName = 'Fulano'` no histórico quando o join falha.

**Por que dói.** Dado fantasma. Métrica de um cliente no painel de outro. Multi-tenant não admite default de produção.

**Ouro.** Sem tenant no input: **400/422** ou skip com log. Nunca inserir row “para o fluxo não quebrar”.

**Erro comum.** “Em local a gente precisa de um default.” Use `.env` `DEV_TENANT_DOMAIN`, não literal no service.

**Sev:** P0

---

## I. Segurança, log, git

### AP-SEC-01 — Secret no exemplo / na task / no comentário

**Cenário.** `.env.example` com bloco comentado de senha de produção “para o júnior conectar”. Markdown da task com token. Screenshot no ClickUp com `.env` aberto.

**Por que dói.** Git history não esquece. Rotação de JWT derruba todo mundo logado.

**Ouro.** Só **nomes** de variáveis. `changeme`. Task ClickUp sem secret. G-010 do produto, quando existir.

**Erro comum.** “Está comentado, o parser não lê.” O humano lê. O scraper lê.

**Sev:** P0

### AP-SEC-02 — Log de PII / body completo

**Cenário.** `log('login', { body: JSON.stringify(req.body) })` — senha. `log(access)` — fingerprint, cookie, IP. `console.log('response', partnerResponse)` — token do parceiro.

**Por que dói.** LGPD. Datadog vira banco de senha. Incidente = vazamento contínuo, não um dump.

**Ouro.** Allowlist: `userId`, `status`, `durationMs`. Redact `password`, `cpf`, `token`, `cookie`, `authorization`. Nunca logar body cru de login/register/webhook de pagamento.

**Erro comum.** `@Trace` que serializa o input inteiro “para debugar”.

**Sev:** P0

### AP-SEC-03 — CORS `*` + auth fraca

**Cenário.** API com cookie de sessão e `origin: '*'`. Ou dashboard com basic `admin`/`admin` (AP-JWT-03).

**Por que dói.** Qualquer site lê a API no browser da vítima.

**Ouro.** Origins explícitos. Credencial sem default. Rotas públicas **só** as que o produto exige (webhook com HMAC, pixel) — decisão explícita, não acidente ([entry-point.md](entry-point.md) §15).

**Sev:** P0–P1

### AP-GIT-01 — Código morto / arquivo comentado / métrica fake

**Cenário.** `bot.channels.ts` inteiro comentado. `// console.log` no controller. Job monta mensagem de funil com `leads = 0` hardcoded “até a query ficar pronta” — a UI mostra funil zerado como se fosse verdade.

**Por que dói.** Git guarda histórico: código morto só atrapalha grep. Métrica fake **mente** para o negócio (P1).

**Ouro.** Apagar. `@deprecated` com data e sem callers. Feature flag explícita se o funil ainda não existe — não número 0 disfarçado.

**Sev:** P2; P1 se mente dado de negócio

---

## J. Erros e testes

### AP-ERR-01 — `catch {}` / throw genérico / 500 sem body

**Cenário.** Parse de cookie: `try { JSON.parse } catch {}` — cookie inválido vira “sem cookie”, tracking segue errado. `throw new Error("Não foi possível efetuar")` no saque. Controller `catch { res.status(500).end() }`.

**Por que dói.** Sem tipo de erro, o client não distingue validação de parceiro fora. Catch vazio **escolhe** perder o sinal.

**Ouro.** `ValidationError` / `AuthenticationError` / `ExternalServiceError` com mensagem para humano **e** código. Catch loga contexto e rethrow ou mapeia 4xx. 500 tem id de correlação, não body vazio.

**Erro comum.** Engolir erro de WhatsApp “para o job não parar” **sem** log — o comercial acha que mandou.

**Sev:** P1

### AP-ERR-02 — Mensagem de piada

**Cenário.** `throw new ResFailedException(["caiu aqui é doidera"])`. Produção. Cliente vê. On-call vê.

**Por que dói.** Zero ação. Quebra confiança.

**Ouro.** Mensagem que o suporte lê: o que falhou e o que o usuário pode fazer. Detalhe técnico no log, não no JSON público.

**Sev:** P1

### AP-TEST-01 — Teste que não testa o sistema

**Cenário.** Arquivo `flows.test.ts`: “idempotência mental do gap” — comentário, zero I/O. Outro: `expect(result instanceof Promise).toBe(false)` como prova de que o decorator de tracing “não quebrou”. Utils com 90% de coverage; webhook de pagamento com zero.

**Por que dói.** Barra verde, produção vermelha. O júnior acha que o fluxo está testado.

**Ouro.** Teste do **capítulo**: dado um repo fake / HTTP fake, assert no efeito (row criada, segundo call **não** cobra de novo, evento não duplica). [entry-point.md](entry-point.md) §9: testes cobrem comportamento, não pasta.

**Erro comum.** Snapshot de 400 linhas de HTML de mensagem WhatsApp — quebra a cada vírgula, não prova regra.

**Sev:** P1

---

# Frontend (júnior + IA)

O Design System visual (tabela, badge, densidade) vive na skill `qa-space`. Aqui está o **ouro de código e contrato** que o QA também caça. Cada item: cenário, ouro, sev.

### AP-FE-01 — Rota ou query inventada

Tela chama `GET /v2/orders/search` que não existe no back. Funciona no mock. Produção 404.

**Ouro.** Conferir OpenAPI / código do back / Network de staging **antes** de escrever o service.

**Sev:** P0

### AP-FE-02 — `GET /lista` para montar `/lista/:id`

Ver AP-TYPE-03.

**Sev:** P1

### AP-FE-03 — Paginação só no client

`limit=1000`, `data.slice(page * 25)`. A UI tem “página 2”. O servidor mandou um recorte mentiroso.

**Ouro.** `page` + `limit` (ou cursor) de verdade. Per page 10/25/50/100.

**Sev:** P1

### AP-FE-04 — Filtro só local quando a API tem query

Status “pago” filtra o array já baixado. Itens pagos da página 2 nunca entram.

**Ouro.** Query param na API. Refetch.

**Sev:** P1

### AP-FE-05 — `fetch` / `useQuery` na view

Componente de página instancia axios, monta URL, trata erro. Impossível testar. Viola FDD quando o projeto é FDD.

**Ouro.** Service + hook da feature. View só renderiza.

**Sev:** P1

### AP-FE-06 — Lógica no JSX / `useEffect` em cascata

Três `useEffect` sincronizando o mesmo estado. Loop. Flicker. Estado que podia ser `const total = items.reduce(...)`.

**Ouro.** Derivar no render. Um efeito só para I/O.

**Sev:** P1

### AP-FE-07 — Permissão só escondendo o botão

Usuário cola a URL `/admin/users`. A tela abre. O botão “excluir” estava `hidden`.

**Ouro.** Guard de rota + UI. Back **também** autoriza (o front nunca é a única trava).

**Sev:** P0

### AP-FE-08 — Copiar mock literal / cor hardcoded

Roxo neon do Lovable. `bg-red-500` no botão de pagar. White-label: o expert muda a cor no painel e nada acontece.

**Ouro.** Tokens Primary/Surface. CSS variables de tenant. DS §3/§18 na skill de QA.

**Sev:** P1; P0 se o produto é white-label e a cor é a marca

### AP-FE-09 — `catch {}` / toast genérico

Erro 422 com lista de campos. Toast: “Algo deu errado”.

**Ouro.** Mensagem da API. Campo vermelho no form.

**Sev:** P1

### AP-FE-10 — URL / token / id hardcoded

`fetch('https://api.prod.empresa.com/...')`. Token de staging no client bundle.

**Ouro.** `NEXT_PUBLIC_*`. Token só de sessão, nunca no git.

**Sev:** P0

### AP-FE-11 — Tabela ad-hoc / sem o contrato de tabela do DS

`<table>` sem pagination, per page, zebra, sort, ⋯. Cards empilhados no lugar de listagem. Células cinza `#8B90A0`, bold ad-hoc, métrica sem `align: center`.

**Ouro.** Data table do DS (§11). QA-space é a constituição visual — esta bíblia só lembra: **não improvise tabela**.

**Sev:** P1

### AP-FE-12 — Sem loading / empty / error

Tela branca. Spinner eterno. Lista vazia igual “zero clientes” sem copy.

**Ouro.** Três estados. Empty com CTA.

**Sev:** P1

### AP-FE-13 — Polling ignorado / webhook imaginário

Produto: depósito confirma por **polling** 8s no `GET /deposits/:id` porque o parceiro não garante webhook. Júnior espera webhook e a tela nunca atualiza. Ou dispara 30 polls/s.

**Ouro.** Seguir a regra do produto. Poll com intervalo combinado. Não inventar canal.

**Sev:** P0 se financeiro

### AP-FE-14 — Confundir JWT do app com token do parceiro

Front manda o JWT nosso em chamada que deveria ir ao **nosso** BFF; o BFF precisa do token do parceiro por baixo. Ou o contrário.

**Ouro.** Front só fala com a API nossa. Quem traduz é o backend (AP-JWT-04).

**Sev:** P0

---

## Checklist de PR — Frontend (colar)

- [ ] Endpoint existe no back; detalhe é `GET /:id`
- [ ] Paginação e filtro server-side
- [ ] Sem fetch na view; guard de rota + UI
- [ ] Três estados; erro da API visível
- [ ] Tokens de cor / DS; tabela do DS
- [ ] Nada hardcoded (URL, token, id)
- [ ] Canal de confirmação = o do produto (poll vs webhook)
