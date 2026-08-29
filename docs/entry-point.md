> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro** (quem lê o quê e por quê). Editar no repo `space-cursor-skills/docs/`; destino Cursor é cópia (`npm run sync`).

# Entry Point conta a história

Guia de estilo para construir fluxos de backend legíveis por qualquer pessoa do time — inclusive quem acabou de chegar.

**Norte:** abrir **um** arquivo de entrada, ler de cima a baixo, e entender o fluxo inteiro — sem precisar abrir nenhuma função interna.

Se você precisou abrir uma função só para saber **se** o passo existe, o entry point falhou.  
Só se abre função interna para saber **como** aquele passo funciona.

---

## Para quem é este guia

Imagine que um júnior abre o projeto pela primeira vez e precisa entender “o que acontece quando um pedido é pago”.

- Se o entry estiver bem feito, ele lê **um** arquivo e responde sozinho.
- Se estiver mal feito, ele pula de arquivo em arquivo, adivinha nomes (`prepare`, `handle`) e perde o fio da meada.

Este documento ensina a escrever o primeiro caso. O restante do time só copia o padrão.

---

## Índice

1. [Frase-norte](#1-frase-norte)
2. [É um Design Pattern?](#2-é-um-design-pattern)
3. [Camadas de um backend](#3-camadas-de-um-backend)
4. [As 5 regras](#4-as-5-regras)
5. [Produto vs capítulo vs “como”](#5-produto-vs-capítulo-vs-como)
6. [Anatomia de um entry point](#6-anatomia-de-um-entry-point)
7. [Exemplos bons (genéricos)](#7-exemplos-bons-genéricos)
8. [Exemplos ruins (anti-padrões)](#8-exemplos-ruins-anti-padrões)
9. [Checklist de PR](#9-checklist-de-pr)
10. [Como criar um fluxo novo](#10-como-criar-um-fluxo-novo)
11. [Onde colocar cada tipo de código](#11-onde-colocar-cada-tipo-de-código)
12. [Nomes: tabela de referência](#12-nomes-tabela-de-referência)
13. [Pass-through: quando é ok e quando não](#13-pass-through-quando-é-ok-e-quando-não)
14. [Refatorando um god-file](#14-refatorando-um-god-file)
15. [Backend saudável (visão rápida)](#15-backend-saudável-visão-rápida)
16. [Perguntas frequentes](#16-perguntas-frequentes)

---

## 1. Frase-norte

> **Entry point conta a história completa.**  
> Ler de cima para baixo = entender o fluxo inteiro, sem abrir função interna.  
> Cada função interna repete o mesmo padrão no seu nível: roteiro curto, nomes que explicam, zero pass-through vazio.  
> Se precisou abrir código para saber **o que** acontece, falhou; só abre para saber **como** acontece.

Padrões da indústria que descrevem a mesma ideia (não é um único GoF):

| Nome | O que emprestamos |
|------|-------------------|
| **Application Service / Use Case** (Clean Architecture) | Um entry por caso de uso |
| **Orchestrator** | Coordena passos; não faz o detalhe |
| **Transaction Script** (Fowler) | Roteiro procedural legível |
| **Intention-Revealing Names** (DDD) | Nome = documentação |

No dia a dia chamamos de: **entry-point-as-screenplay** (o entry é o roteiro do filme).

---

## 2. É um Design Pattern?

Não é **um** pattern do GoF com um nome só. É um **estilo de orquestração** composto.

### O que é

- Um **caso de uso** com um arquivo/função de entrada
- Que **orquestra** passos nomeados em ordem cronológica
- Onde o detalhe (“como”) fica em helpers / builders / repos / clients de API

### O que **não** é

| Pattern | Por que não confundir |
|---------|------------------------|
| **Facade (GoF)** | Facade bom simplifica um subsistema. Facade **pass-through** (`return outroArquivo(input)`) é proibido. |
| **Pipeline (pasta genérica)** | Sequência de steps ok; pasta `pipeline/` sem nome de história não ajuda a ler o fluxo. Prefira arquivo com nome de história (`charge-payment-if-new.ts`). |
| **Template Method** | Esqueleto com herança. Aqui usamos funções nomeadas, sem classe base obrigatória. |
| **Saga** | Compensação entre serviços. Overkill para a maioria dos fluxos de um módulo. |

---

## 3. Camadas de um backend

Pense em um filme: o roteiro lista as cenas; cada cena tem detalhes de câmera; a câmera não é o roteiro.

```
┌─────────────────────────────────────────────────────────┐
│  ROTA / CONTROLLER                                      │
│  Só HTTP: valida request, chama o entry, devolve JSON   │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────┐
│  ENTRY (index.ts do módulo — preferência)               │
│  Roteiro: resolve → cobra? → grava → notifica → return  │
└──────────────────────────┬──────────────────────────────┘
                           │ chama
┌──────────────────────────▼──────────────────────────────┐
│  PASSOS NOMEADOS (mesmo arquivo ou capítulo ao lado)    │
│  Cada um conta UM capítulo                              │
└──────────────────────────┬──────────────────────────────┘
                           │ chama
┌──────────────────────────▼──────────────────────────────┐
│  COMO: builders / helpers / API clients / repositories  │
│  Montagem de payload, HTTP, SQL, hash, filas…           │
└─────────────────────────────────────────────────────────┘
```

| Camada | Pergunta que responde | Exemplo genérico |
|--------|----------------------|------------------|
| **Controller** | Como a internet chega aqui? | `OrdersController.create` |
| **Entry (produto)** | O que este fluxo de negócio faz? | `createPaidOrder` em `orders/index.ts` |
| **Capítulo** | O que este passo faz? | `chargePaymentIfNew` |
| **Como** | Como montamos payload / HTTP / SQL? | `PaymentPayloadBuilder`, `PaymentApi`, `OrderRepository` |

**Erro comum:** misturar as quatro no mesmo bloco. Aí abrir o arquivo vira labirinto.

---

## 4. As 5 regras

### Regra 1 — Entry point = roteiro completo

O entry **não** é um gancho. É o **roteiro**.

Cada linha (ou bloco curto) é um capítulo. O nome já explica o passo.

```typescript
// ✅ Abrir só isto = entender o pedido pago do início ao fim
export async function createPaidOrder(params: CreatePaidOrderParams) {
  const ctx = await resolveOrderContext(params)
  const paymentId = createPaymentId()

  if (ctx.shouldNotifyPartner) await notifyPartner(ctx)
  await chargePaymentIfNew({ ...ctx, paymentId })
  await saveOrder({ ...ctx, paymentId })
  await saveOrderHistory(ctx)

  return { id: ctx.order.id }
}
```

Lendo só isso você conclui: resolve → parceiro? → cobra (condicional) → grava pedido → history → retorno.

### Regra 2 — Funções internas = mesmo padrão, um nível abaixo

Cada função chamada pelo entry conta a história **daquela responsabilidade**, não do fluxo global.

```typescript
// ✅ Capítulo pagamento — sozinho já conta: dedupe → montar → cobrar
export async function chargePaymentIfNew(input: ChargePaymentInput): Promise<boolean> {
  return playerQueue.enqueue(queueKey(input), async () => {
    if (await alreadyCharged(input)) return false
    const payload = PaymentPayloadBuilder.buildCharge(input)
    await PaymentApi.charge(payload, input.merchantId)
    return true
  })
}
```

**Regra recursiva:** em qualquer nível, abrir o arquivo deve bastar para entender **aquela camada**. Só desce um nível para debugar **como**, nunca para descobrir **se** o passo existe.

### Regra 3 — Proibido pass-through vazio

```typescript
// ❌ Não conta história — só repassa
static createOrder(input) {
  return createPaidOrder(input)
}
```

Ou o entry **é** o roteiro, ou o wrapper adiciona algo **visível** (ex.: tracing, guard, transformação). Só renomear não conta.

### Regra 4 — Nome = documentação

Quem lê o entry **não** precisa de comentário linha a linha se os nomes forem bons.

| Bom | Ruim |
|-----|------|
| `resolveOrderContext` | `prepare` |
| `chargePaymentIfNew` | `handlePayment` |
| `saveOrderHistory` | `persist` |
| `createPaymentId` | `genId` |
| `alreadyCharged` | `check` |

### Regra 5 — Tamanho do entry point

- **Ideal:** 10–40 linhas, só chamadas nomeadas + early returns
- **Alerta:** SQL, montagem de payload de integração, loops, regra de negócio **inline** no entry → extrair, mas **manter a chamada no entry**

```typescript
// ❌ Entry inchado — história escondida no meio do SQL
export async function createPaidOrder(...) {
  let order = await OrderRepository.getById(...)
  if (!order) {
    // 30 linhas criando order...
  }
  // 20 linhas montando payload do gateway...
  await OrderRepository.insert({ /* 15 campos */ })
  // ...
}

// ✅ Entry fino — detalhe em resolveOrderContext / saveOrder
export async function createPaidOrder(...) {
  const ctx = await resolveOrderContext(...)
  // ...
  await saveOrder(...)
}
```

---

## 5. Produto vs capítulo vs “como”

```
┌─────────────────────────────────────────────────────────┐
│  PRODUTO (você abre primeiro)                           │
│  modules/orders/index.ts                                │
│  resolve → parceiro? → cobrança → pedido → history      │
└──────────────────────────┬──────────────────────────────┘
                           │ chama
┌──────────────────────────▼──────────────────────────────┐
│  CAPÍTULO PAGAMENTO (um passo da história)              │
│  charge-payment-if-new.ts (ou função no mesmo arquivo)  │
│  dedupe → montar → cobrar                               │
└──────────────────────────┬──────────────────────────────┘
                           │ chama
┌──────────────────────────▼──────────────────────────────┐
│  COMO (só abre se for debugar o passo)                  │
│  PaymentPayloadBuilder / PaymentApi / OrderRepository   │
│  hash, campos do gateway, HTTP, SQL                     │
└─────────────────────────────────────────────────────────┘
```

| Nível | Pergunta | Exemplo |
|-------|----------|---------|
| **Produto** | O que este fluxo de negócio faz? | `createPaidOrder` |
| **Capítulo** | O que este passo de integração/persistência faz? | `chargePaymentIfNew` |
| **Como** | Como montamos o payload / HTTP / SQL? | `PaymentPayloadBuilder.buildCharge` |

**Erro comum:** misturar os três no mesmo bloco. Aí abrir o arquivo vira labirinto.

---

## 6. Anatomia de um entry point

### Preferência do time: `index.ts` do módulo

Quando o módulo tem **um** caso de uso principal (ou poucos exportados), o entry vive no **`index.ts`** da pasta do módulo.

Exemplos de layout:

```
modules/orders/
  index.ts              ← entry(s) no topo — o que o humano lê primeiro
  charge-payment-if-new.ts   ← capítulo só se ficar grande / reutilizado
  order-repository.ts
  payment-api.ts
```

Se o módulo tiver **vários** casos de uso grandes, pode haver `send-*.ts` / `run-*.ts` / `create-*.ts` ao lado — cada um com a **própria** história no topo. O `index.ts` só reexporta o que for API pública do módulo.

Não exija nomes tipo `bootstrap-*.ts`. O importante é: **um arquivo conta uma história**.

### Ordem sugerida **dentro do mesmo arquivo**

```typescript
// 1. Imports
// 2. Types do fluxo (Ctx, Params)
// 3. ENTRY POINT exportado (roteiro no topo — o que o humano lê primeiro)
// 4. Separador: // --- passos ---
// 5. Funções nomeadas (resolve*, send*, save*, charge*)
```

### Esqueleto genérico

```typescript
type OrderCtx = { /* o que todos os passos precisam */ }

/**
 * Entry createPaidOrder — resolve → parceiro? → cobra se novo → grava → history.
 */
export async function createPaidOrder(params: CreatePaidOrderParams) {
  const ctx = await resolveOrderContext(params)

  if (shouldSkip(ctx)) return { skipped: true }

  if (ctx.shouldNotifyPartner) await notifyPartner(ctx)
  await chargePaymentIfNew(ctx)
  await saveOrder(ctx)
  await saveOrderHistory(ctx)

  return { id: ctx.order.id }
}

// --- passos ---

async function resolveOrderContext(params: CreatePaidOrderParams): Promise<OrderCtx> { ... }
async function notifyPartner(ctx: OrderCtx): Promise<void> { ... }
async function chargePaymentIfNew(ctx: OrderCtx): Promise<boolean> { ... }
async function saveOrder(ctx: OrderCtx): Promise<void> { ... }
async function saveOrderHistory(ctx: OrderCtx): Promise<void> { ... }
```

**Por que o entry no topo?** Quem abre o arquivo vê a história na primeira tela. O detalhe fica abaixo — não o contrário.

---

## 7. Exemplos bons (genéricos)

Os exemplos abaixo são **inventados** de propósito. Copie a *forma*, não o domínio.

### 7.1 Produto — criar pedido pago

```typescript
/**
 * Entry createPaidOrder — resolve → parceiro? → cobrança se nova → pedido → history.
 */
export async function createPaidOrder(params: CreatePaidOrderParams) {
  const ctx = await resolveOrderContext(params)
  const paymentId = createPaymentId()
  const flow = { ...ctx, paymentId }

  if (flow.shouldNotifyPartner) await notifyPartner(flow)
  await chargePaymentIfNew(flow)
  await saveOrder(flow)
  await saveOrderHistory(flow)

  return { id: flow.order.id }
}
```

**Por que é bom:**
- Capítulos claros na ordem do negócio
- Condicional de parceiro **visível** no roteiro (não escondida dentro de “charge”)
- `paymentId` criado **antes** da cobrança — e isso fica **visível**

### 7.2 Produto — cancelar pedido

```typescript
/**
 * Entry cancelOrder — resolve → já cancelado? → estorna se pago → marca cancelado → history.
 */
export async function cancelOrder(params: CancelOrderParams) {
  const ctx = await resolveCancelContext(params)

  if (ctx.alreadyCanceled) return { id: ctx.order.id, skipped: true }

  if (ctx.wasPaid) await refundPayment(ctx)
  await markOrderCanceled(ctx)
  await saveCancelHistory(ctx)

  return { id: ctx.order.id }
}
```

**Por que é bom:**
- Early return explícito (“já estava cancelado”)
- Estorno só aparece se `wasPaid` — a regra de negócio está no roteiro

### 7.3 Capítulo — cobrança com dedupe

```typescript
/**
 * Entry chargePaymentIfNew — dedupe → monta payload → cobra (ou pula se já cobrado).
 */
export async function chargePaymentIfNew(input: ChargePaymentInput): Promise<boolean> {
  const queueKey = input.customerId ?? input.order.id

  return workQueue.enqueue(queueKey, async () => {
    if (await alreadyCharged(input)) return false

    const payload = PaymentPayloadBuilder.buildCharge(input)
    await PaymentApi.charge(payload, input.merchantId)
    return true
  })
}
```

**Por que é bom:**
- Early return `false` = “já tinha cobrança, não mandei” — explícito
- Fila visível (serialização por cliente/pedido)
- `alreadyCharged` nomeado — não é `if (await repo.has...)` solto sem intenção

### 7.4 Wrapper com Trace (pass-through aceitável)

```typescript
@Trace({ spanName: 'OrdersService.createPaidOrder' })
static createPaidOrder(...) {
  return createPaidOrder(...)
}
```

**Por que é ok:** o `@Trace` adiciona valor observável. Não é rename vazio. O **roteiro** continua em `createPaidOrder`.

---

## 8. Exemplos ruins (anti-padrões)

### 8.1 Pass-through puro

```typescript
// ❌
export class OrdersFacade {
  static create(input) {
    return createPaidOrder(input)
  }
}
```

**Problema:** duas formas de chamar a mesma coisa; quem lê o facade não aprende o fluxo.

**Correção:** callers importam `createPaidOrder` (do `index.ts`) direto.

### 8.2 God-file / labirinto inline

```typescript
// ❌ Abrir o arquivo = 200 linhas misturando tudo
export async function createPaidOrder(customerId, amountCents, ...) {
  let order = await OrderRepository.getById(customerId)
  if (!order) {
    const merchant = await MerchantRepository.getById(merchantId)
    const newOrder = { id: ..., customer: ..., /* 15 campos */ }
    const insertedId = await OrderRepository.insert(newOrder)
    order = await OrderRepository.getById(insertedId)
  }
  // 40 linhas linkando customer / external_id...
  if (order.partner === 'acme') {
    await PartnerApi.notify({ ... })
  }
  const payload = { amount: ..., currency: ..., /* montagem gateway */ }
  await PaymentApi.charge(payload, ...)
  await OrderRepository.insert({ /* ... */ })
  await HistoryRepository.insert({ ... })
  return { id: order.id }
}
```

**Problema:** a história existe, mas está **diluída**. Quem abre não vê capítulos — vê implementação.

**Correção:** extrair `resolveOrderContext`, `notifyPartner`, `chargePaymentIfNew`, `saveOrder`, `saveOrderHistory` e deixar o entry só com as chamadas.

### 8.3 Nomes genéricos

```typescript
// ❌
await prepare(ctx)
await handle(ctx)
await process(ctx)
await persist(ctx)
```

**Problema:** preparar o quê? handle o quê? Abrir cada uma é obrigatório.

```typescript
// ✅
await resolveOrderContext(params)
await chargePaymentIfNew(input)
await saveOrderHistory(ctx)
```

### 8.4 Comentários que substituem nomes ruins

```typescript
// ❌
// 1. resolve customer
await prepare(ctx)
// 2. send to payment gateway
await handle(ctx)
// 3. save db
await persist(ctx)
```

Se precisa do comentário numerado, o **nome da função** está errado.

```typescript
// ✅ — o nome já é o comentário
await resolveOrderContext(params)
await chargePaymentIfNew(input)
await saveOrderHistory(ctx)
```

(Um comentário **de uma linha no entry** resumindo a história é bem-vindo.)

### 8.5 Extrair demais (micro-arquivos)

```
// ❌ Piora hop — para entender o fluxo abre 8 arquivos
orders/
  step-1-resolve.ts
  step-2-partner.ts
  step-3-payment.ts
  step-4-save.ts
  ...
```

**Problema:** contradiz “abrir **um** arquivo e entender”.

**Correção:** entry + passos **no mesmo arquivo** (ou no máximo um capítulo ao lado se passar de ~150–200 linhas).

### 8.6 Pasta abstrata sem história

```
// ❌
orders/pipeline/bootstrap.ts
orders/pipeline/index.ts
orders/pipeline/resolve-context.ts
orders/pipeline/build-payload.ts
orders/pipeline/send.ts
```

**Problema:** “pipeline” não conta o que o fluxo faz. Você abre a pasta e ainda não sabe a história.

```
// ✅
orders/index.ts                 // createPaidOrder, cancelOrder…
orders/charge-payment-if-new.ts // cobrança com dedupe
orders/payment-payload-builder.ts // como montar
```

### 8.7 Lógica de negócio escondida no helper

```typescript
// ❌ Entry “limpo” demais — a história sumiu
export async function createPaidOrder(params) {
  return OrderHelper.runEverything(params)
}
```

**Problema:** o entry não conta nada; o labirinto só mudou de arquivo.

**Correção:** o entry **lista** os capítulos. O helper faz um capítulo (`buildCharge`), não o fluxo inteiro.

### 8.8 SQL / HTTP soltos no entry “porque é rápido”

Uma linha trivial de guard pode ficar. Quinze campos de insert + montagem de payload **não**.

---

## 9. Checklist de PR

Quem revisa responde **em voz alta**:

### Pergunta 1 (obrigatória)

> Abri **só** o entry point. Sei o que esse fluxo faz do início ao fim sem abrir mais nada?

- **Sim** → ok
- **Não** → entry incompleto, nomes ruins, ou lógica inline demais

### Pergunta 2 (se abriu uma interna)

> Essa função, sozinha, conta a história **dela** em poucas linhas?

- **Sim** → ok
- **Não** → quebrar ou renomear

### Checklist rápido

- [ ] Entry no **topo** do arquivo (não enterrado no final)
- [ ] Preferência: `index.ts` do módulo (ou arquivo com nome de história claro)
- [ ] 10–40 linhas no roteiro (ordem de grandeza)
- [ ] Só chamadas nomeadas + early returns no entry
- [ ] Sem SQL / payload de integração / loops pesados no entry
- [ ] Sem pass-through vazio (`return outroArquivo(input)` sem Trace/guard)
- [ ] Nomes Intention-Revealing (`sendX`, `saveY`, `resolveZ`, `chargeXIfNew`)
- [ ] Condicionais importantes **visíveis** no roteiro (`if (shouldNotifyPartner)`, `if (alreadyCharged)`)
- [ ] Helpers só para montagem / infra (“como”), não para o fluxo inteiro
- [ ] Testes cobrem o comportamento (não a estrutura de pastas)

---

## 10. Como criar um fluxo novo

### Passo a passo

1. **Escreva o roteiro em português** (3–7 linhas):
   > Resolver pedido/cliente → se parceiro notifica → cobra se ainda não cobrou → grava pedido → grava history → retorna id

2. **Transforme cada linha em nome de função:**
   - `resolveOrderContext`
   - `notifyPartner`
   - `chargePaymentIfNew`
   - `saveOrder`
   - `saveOrderHistory`

3. **Crie (ou abra) o `index.ts` do módulo** com o roteiro no topo (pode ser stub `throw new Error('todo')` nos passos).

4. **Implemente os passos** abaixo do separador `// --- passos ---`.

5. **Extraia para helper** só o que for montagem reutilizável (ex.: `PaymentPayloadBuilder`), não o fluxo.

6. **Rode o checklist da seção 9.**

### Template copy-paste

```typescript
type FlowCtx = {
  // preencha
}

/**
 * Entry <NOME> — <capítulo1> → <capítulo2> → <capítulo3>.
 */
export async function runXxxFlow(params: /* ... */): Promise<{ id: string }> {
  const ctx = await resolveXxxContext(params)

  await doStepOne(ctx)
  await doStepTwo(ctx)
  await doStepThree(ctx)

  return { id: ctx./* ... */ }
}

// --- passos ---

async function resolveXxxContext(params: /* ... */): Promise<FlowCtx> {
  // ...
}

async function doStepOne(ctx: FlowCtx): Promise<void> {
  // ...
}

async function doStepTwo(ctx: FlowCtx): Promise<void> {
  // ...
}

async function doStepThree(ctx: FlowCtx): Promise<void> {
  // ...
}
```

**Renomeie** `doStepOne` etc. para nomes reais antes do merge.

---

## 11. Onde colocar cada tipo de código

| Tipo | Onde | Aparece no entry? | Exemplo |
|------|------|-------------------|---------|
| Roteiro do caso de uso | `index.ts` do módulo (preferência) ou `send-*.ts` / `create-*.ts` | **é** o entry | `createPaidOrder` |
| Passo do fluxo | Mesmo arquivo do entry (abaixo) | **sim**, como uma linha | `saveOrderHistory` |
| Montagem de payload / hash / atribuição | Helper no módulo | não (só a chamada no capítulo) | `PaymentPayloadBuilder` |
| HTTP client de integração | `*-api.ts` (um gateway por integração) | não | `PaymentApi.charge` |
| Persistência | `*-repository.ts` / `*.repo.ts` | não (chamada via `save*`) | `OrderRepository` |
| Tipos de domínio | `domain/` ou `types/` do módulo | não | `Order`, `PaymentStatus` |
| Infra transversal | helpers de errors, tracing, auth | transparente | `@Trace`, filas |
| Controller / rota | `*.controller.ts` / routes | não — só despacha | `OrdersController` |

### Helpers: sim ou não?

**Sim**, quando:
- O código é “como montar X”
- É reutilizado por mais de um entry
- Tirar do entry **melhora** a leitura do roteiro

**Não**, quando:
- O helper vira `runEverything` e o entry some
- Você cria 10 arquivos de 5 linhas e perde o roteiro em um lugar só

---

## 12. Nomes: tabela de referência

### Prefixo por tipo de passo

| Prefixo | Significado | Exemplo |
|---------|-------------|---------|
| `resolve*` | Junta contexto (pedido, cliente, merchant…) | `resolveOrderContext` |
| `create*` | Gera id / valor simples | `createPaymentId` |
| `send*` / `notify*` | Envia para integração externa | `notifyPartner` |
| `charge*` / `refund*` | Operação financeira nomeada | `chargePaymentIfNew` |
| `*IfNew` / `already*` / `has*` | Guard / dedupe | `alreadyCharged` |
| `save*` / `mark*` | Persiste no banco | `saveOrder`, `markOrderCanceled` |
| `build*` | Monta payload (helper) | `buildCharge` |
| `run*` / `create*` (entry) | Entry de produto no módulo | `createPaidOrder`, `runXxxFlow` |

Evite: `prepare`, `handle`, `process`, `doStuff`, `execute`, `manager`, `helper` como **nome do passo de negócio**.

---

## 13. Pass-through: quando é ok e quando não

### ❌ Proibido

```typescript
// Só renomeia
function emitOrder(input) {
  return createPaidOrder(input)
}
```

```typescript
// Fachada vazia
class OrdersFacade {
  static create(input) {
    return createPaidOrder(input)
  }
}
```

### ✅ Ok

```typescript
// Adiciona observabilidade visível
@Trace({ spanName: 'OrdersService.createPaidOrder' })
static createPaidOrder(...) {
  return createPaidOrder(...)
}
```

```typescript
// Adiciona guard visível
async function chargeOrSkip(input) {
  if (!input.merchantId) {
    log('skip: missing merchant_id')
    return null
  }
  return chargePaymentIfNew(input)
}
```

```typescript
// Adiciona transformação visível
function createWithDefaults(input) {
  return createPaidOrder({
    ...input,
    currency: input.currency ?? 'BRL',
  })
}
```

**Teste:** se remover o wrapper e o caller importar o entry direto, **perdeu** Trace/guard/transform? Se não perdeu nada → wrapper inútil → delete.

---

## 14. Refatorando um god-file

Ordem prática (sem mudar comportamento):

### 1. Identifique a história em português

Escreva 5–7 linhas do que o fluxo **já faz** hoje.

### 2. Extraia o entry sem mudar lógica

```typescript
export async function createPaidOrder(...) {
  // cole o código antigo aqui temporariamente
}
```

### 3. Extraia o primeiro bloco óbvio

Ex.: tudo que monta `order`/`customer` → `resolveOrderContext`.  
O entry passa a ter **uma linha** no lugar.

### 4. Repita bloco a bloco

Parceiro → `notifyPartner`  
Pagamento → `chargePaymentIfNew`  
Pedido → `saveOrder`  
History → `saveOrderHistory`

### 5. Rode testes

Mesmo comportamento. Só legibilidade.

### 6. Checklist da seção 9

Se ainda precisar abrir funções para saber **o que** acontece, continue extraindo/renomeando.

---

## 15. Backend saudável (visão rápida)

O entry-point-as-screenplay fica frágil se o resto do módulo estiver bagunçado. Use como bússola (não como checklist rígido de um repo específico):

| Prática | Por quê |
|---------|---------|
| **Hierarquia clara** | Controller fino → entry → passos → repo/API |
| **Tipos em `domain/` (ou equivalente)** | Contratos explícitos; menos `any` e shapes inventados no meio do fluxo |
| **Um gateway por integração externa** | Um `*Api` / client por provedor; não espalhar HTTP cru em 10 arquivos |
| **Select / projeção consciente** | Não trazer o mundo inteiro do banco “porque é mais fácil” |
| **Auth consciente** | Rotas admin protegidas; rotas públicas **só** quando o produto exige (webhook, pixel, tracking) — e isso deve ser decisão explícita, não acidente |
| **Erros e tracing** | Infra transversal, não misturada no meio do roteiro |

Se o entry estiver limpo mas o módulo inteiro for um “saco de funções”, o júnior ainda se perde — o roteiro ajuda, mas a pasta precisa contar a mesma história.

---

## 16. Perguntas frequentes

### “Posso deixar SQL no entry se for uma linha?”

Sim, se for **trivial** e o nome não ficar pior. Ex.:

```typescript
if (await HistoryRepository.hasCharge(...)) return false
```

Melhor ainda:

```typescript
if (await alreadyCharged(input)) return false
```

### “E se o fluxo tiver 15 passos?”

Ainda lista os 15 no entry (pode passar um pouco de 40 linhas). Se muitos passos forem sub-rotinas de um capítulo, agrupe:

```typescript
await notifyIntegrations(ctx)  // parceiro A + B — só se for UM capítulo mental
await persistOrder(ctx)        // order + history
```

Cuidado: não agrupe demais a ponto de o entry voltar a ser opaco.

### “Onde fica o controller?”

Controller valida HTTP e chama o entry. **Não** é o roteiro do domínio. O roteiro está no `index.ts` (ou no arquivo de caso de uso).

### “Helpers na pasta do módulo ou em `helpers/` global?”

O que importa é o **roteiro legível**. Preferência:

- Integração / montagem de domínio → no **módulo**
- Infra transversal (errors, tracing, jwt) → helpers compartilhados
- Utils puros (money, uuid, datas) → `utils/`

### “Preciso de pasta `pipeline/`?”

Não. Prefira arquivos com nome de história. Pastas genéricas (`pipeline/`, `managers/`, `handlers/`) escondem o que o fluxo faz.

### “Por que preferir `index.ts`?”

Porque é o arquivo que o editor e o import naturally abrem primeiro. Quem entra no módulo já cai no roteiro — sem caçar `bootstrap-foo-bar.ts`.

### “E testes?”

Teste comportamento (ids, dedupe, side effects). A estrutura de pastas não é o que o teste valida. Entries legíveis **facilitam** testes focados por passo.

---

## Resumo de uma tela

```
ENTRY (topo do index.ts / arquivo de caso de uso)
  resolve…
  send… / save… / charge… / notify…
  return

PASSOS (mesmo arquivo, abaixo)
  cada um conta o próprio nível

HELPERS / API / REPO (outro arquivo)
  só “como” montar / HTTP / SQL

PROIBIDO
  pass-through vazio
  god-file inline
  nomes prepare/handle/process
  micro-arquivos que forçam hop para entender o fluxo
  helper runEverything que engole o roteiro
```

**Teste de ouro:** *Abri só o entry. Sei o que esse fluxo faz do início ao fim?*  
Sim → merge. Não → ainda não está pronto.
