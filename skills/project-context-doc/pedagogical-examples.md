# Exemplos Pedagogicos — project-context-doc

Guia de preenchimento para documento **esclarecedor** — dev junior entende sem ler codigo.

Referencia: [language-guide.md](language-guide.md) (tom professor) · [template-rn-guardrail.md](template-rn-guardrail.md) · [template-flows.md](template-flows.md)

---

## Checklist "este trecho esta esclarecedor?"

Antes de entregar Fase 4, passar cada RN/FL/G critico:

| Pergunta | Se "nao" → corrigir |
|----------|---------------------|
| Um junior que nunca viu o produto entenderia **sem abrir o codigo**? | Adicionar cenario + exemplo |
| Tem **caso de uso concreto** (persona, acao, resultado)? | Escrever secao Cenario |
| O **Por que** explica motivacao de negocio **e** tecnica? | Expandir para 2+ frases |
| Tem **erro comum** documentado (o que dev faz errado)? | Adicionar secao Erro comum |
| Links para artefatos relacionados sao **clicaveis**? | Usar `[RN-008](#rn-008)` |
| Parece telegrafico / "informacao jogada"? | Reescrever no tom professor |

---

## Estrutura obrigatoria por tipo

### FL-xxx — Fluxo end-to-end

Ver [template-flows.md](template-flows.md). Resumo:

1. Anchor `<a id="fl-001"></a>`
2. **Por que este fluxo importa** (2–3 frases)
3. **Cenario** narrativo (usuario + app + acao)
4. **Pre-condicoes** (headers, ENV, estado)
5. Diagrama PNG
6. Tabela — coluna **Por que** = frase completa, nunca fragmento

### RN-xxx — Regra de negocio

Ver [template-rn-guardrail.md](template-rn-guardrail.md). Secoes obrigatorias:

1. Anchor
2. Fluxo relacionado (link)
3. Cenario (caso de uso)
4. O que o sistema faz (comportamento)
5. Regra em uma frase
6. Por que existe assim (2+ frases)
7. Exemplo concreto
8. Erro comum de dev novo
9. Onde esta no codigo
10. Ver tambem (links)

### G-xxx — Guardrail

1. Anchor
2. Aplica-se em (FL + repo, com link)
3. Proibido (acao concreta)
4. Cenario de violacao (o que o dev tenta fazer)
5. Por que (2+ frases)
6. Se violar (consequencia observavel)
7. Enforced em (arquivo)
8. Ver tambem (RN relacionada)

### TB-xxx — Coluna de tabela

| Coluna | Para que | Por que |
|--------|----------|---------|
| email | Identificador de login do jogador neste app | Unique composto com applicationId — mesmo email em apps diferentes sao contas distintas (ver [RN-008](#rn-008)) |

Evitar: Por que = "auditoria" ou "ORM" sem contexto do produto.

### RT Tier 1 — Rota critica

Formato expandido em [template-routes.md](template-routes.md) — tabela completa + cenario de quando o dev chama esta rota.

### RT Tier 2 — Catalogo referencia

Tabela compacta permitida, mas **Por que ≥ 1 frase** + coluna Fluxo com link `[FL-001](#fl-001)`.

---

## Casos de uso — como escrever

**Formula:** Persona + contexto + acao + o que o sistema faz + resultado esperado.

**Ruim:**
> Login delegado na bet.

**Bom:**
> Maria abre o app white-label do expert (`app.expert-a.com`), digita email e senha na tela de login. O front envia POST `/players/login` com header `x-application-domain: app.expert-a.com`. O core **nao compara** a senha no banco local — delega para o integration, que autentica na bet parceira. Se a bet aceitar, o core emite JWT com token embutido e Maria entra no app.

Usar dados da **Fase 3** quando o time informar tenant/URL de teste reais.

---

## Exemplos concretos — o que incluir

| Tipo | Incluir |
|------|---------|
| HTTP | Metodo, path, headers obrigatorios (anonimizados) |
| Multi-tenant | Domain real de teste, valor de `x-application-domain` |
| Auth | Trecho payload JWT (campos, sem secret) |
| DB | Valores exemplo de linha (email ficticio, UUID truncado) |
| Erro | Codigo HTTP ou mensagem que o dev ve |
| Certo vs errado | Bloco "❌ Errado" / "✅ Certo" quando conceito e contra-intuitivo |

### Exemplo curl (quando rota e critica)

```bash
curl -X POST 'https://app-api.exemplo.com/players/login' \
  -H 'Content-Type: application/json' \
  -H 'x-application-domain: app.expert-a.com' \
  -d '{"email":"joao@email.com","password":"***"}'
```

---

## Analogias — quando usar

Para conceitos que **contradizem intuicao SaaS**:

| Conceito | Analogia util |
|----------|---------------|
| Auth delegada | "O core e a recepcionista — quem valida documento e a bet, nao o espelho local" |
| Multi-tenant white-label | "Cada Application e um predio diferente — mesmo CPF pode morar em dois predios com chaves diferentes" |
| Proxy sticky | "Como manter a mesma fila no banco — se trocar IP, a bet 'desconfia' e desloga" |
| Polling vs webhook | "Ficar perguntando 'ja pagou?' a cada 8s porque a bet nao manda aviso confiavel" |

Uma analogia por RN critica — nao exagerar.

---

## Exemplo RN-008 {#exemplo-rn-008}

Modelo completo para copiar/adaptar:

```markdown
<a id="rn-008"></a>
### RN-008: Mesmo email, senhas diferentes por Application

**Fluxo relacionado:** [FL-001 Login](#fl-001) passos 2–7

#### Cenario (caso de uso)

Joao e afiliado de dois experts diferentes. Ele se cadastra com `joao@gmail.com` no App do Expert A (`app.expert-a.com`) e, semanas depois, com o **mesmo email** no App do Expert B (`app.expert-b.com`). Para a plataforma, sao **dois jogadores distintos** — cada um com sua senha, seu historico de depositos e seu tracking. Joao pode usar senha `abc123` no App A e `xyz789` no App B; nao ha conflito.

#### O que o sistema faz (comportamento)

- Ao registrar ou logar, o core resolve o tenant via `x-application-domain` → `Application`
- Busca ou cria `Player` com FK `applicationId` daquele tenant
- Constraint unique no banco: `(email, applicationId)` — nao apenas `email`
- Senha hash no core e **cache** pos-login — validacao real ocorre na bet ([RN-002](#rn-002))

#### Regra em uma frase

O mesmo endereco de email pode existir em N Applications, mas cada par (email, applicationId) e um Player unico e independente.

#### Por que existe assim

Cada Application e uma **marca separada** para o jogador — white-label real. O expert A e o expert B nao compartilham base de leads; unificar contas quebraria isolamento de tenant e tracking do afiliado. Arquiteturalmente, o core nao e um IdP central — e espelho por tenant da conta que vive na bet.

#### Exemplo concreto

| App | Domain | email | Player no banco |
|-----|--------|-------|-----------------|
| Expert A | `app.expert-a.com` | joao@gmail.com | Player uuid-aaa |
| Expert B | `app.expert-b.com` | joao@gmail.com | Player uuid-bbb |

Headers no login Expert A:
`x-application-domain: app.expert-a.com`

#### Erro comum de dev novo

Assumir SSO ou "conta unica" e implementar:
- Busca global `SELECT * FROM player WHERE email = ?` sem `applicationId`
- Merge de Players cross-tenant
- Mensagem "email ja cadastrado" bloqueando cadastro em outro app

**Consequencia:** vazamento de dados entre tenants, login no app errado, ou bloqueio indevido de cadastro.

#### Onde esta no codigo

`[core]/src/database/entities/player.entity.ts` — unique `(email, applicationId)`

`[core]/src/modules/player/player.service.ts` — signIn/signUp escopados por Application

#### Ver tambem

[FL-001](#fl-001) · [TB-002 player](#tb-002) · [RN-002 Login delegado](#rn-002) · [G-001 x-application-domain](#g-001)
```

---

## Exemplo RN-014 — analytics dual-pipeline (contraste ruim/bom)

**Ruim (telegrafico — nao aceitar):**

```markdown
**Cenario (caso de uso)** — A plataforma mede agregado via GA4_PROPERTY_ID no core; expert mede campanhas via GTM.

**O que o sistema faz**
- Dashboard metricas → GA4 backend
- Front injeta GTM/FB do config tenant
```

**Bom (tom professor):**

```markdown
**Cenario (caso de uso)** — Expert A configura GTM-AAA no dashboard; Expert B usa GTM-BBB. Maria deposita no app do Expert A — evento purchase dispara no container do expert via tagManangerId em Application.config, **nao** no GA4 agregado da plataforma. O time de produto usa GA4_PROPERTY_ID no core para LTV cross-tenant.

**O que o sistema faz**
- O core envia metricas agregadas ao GA4 via GA4_PROPERTY_ID (dashboard interno da plataforma)
- O front injeta GTM e Facebook Pixel lidos de Application.config no bootstrap do tenant
- Eventos purchase pos-PAID usam pipeline tenant (RN-015); GA4 core permanece separado
```

---

## Exemplo FL-001 (trecho — cenario antes da tabela)

```markdown
<a id="fl-001"></a>
### FL-001: Login

#### Por que este fluxo importa

Se o dev nao entender que login e **delegado**, vai implementar auth local no core (Bcrypt no Player) — bug grave que parece funcionar em testes isolados mas quebra integracao com a bet.

#### Cenario

Maria abre `https://app.expert-a.com/auth/login`, preenche email/senha e clica Entrar. O front chama o core com domain do tenant; o core repassa credenciais ao integration; a bet valida; o core sincroniza espelho local e devolve JWT. Maria ve a home do app.

#### Pre-condicoes

- `NEXT_PUBLIC_APPLICATION` ou domain correto no front
- Header `x-application-domain` em toda call ao core
- Header `x-platform-id` quando core chama integration
- Application.casinoUrl mapeado para Casinos/Platform no integration

[diagrama PNG]

| Passo | Repo | O que acontece | Para que | Por que | Ref |
...
```

---

## Exemplo G-002 (guardrail expandido)

```markdown
<a id="g-002"></a>
### G-002: Nunca validar senha de player localmente

**Aplica-se em:** [FL-001 Login](#fl-001) passo 3 · `[core]`

#### Proibido

Chamar `Bcrypt.compare(senhaDigitada, player.password)` para decidir se login de **player** e valido.

#### Cenario de violacao

Dev novo copia fluxo de login do Admin (que usa Bcrypt local) e aplica no Player. Teste passa porque hash foi salvo no ultimo login — mas senha mudou na bet e app continua aceitando senha antiga do cache local.

#### Por que

A conta real do jogador vive na bet parceira. O hash em `player.password` e espelho/cache pos-login, nao fonte de verdade. Validar localmente cria auth falso e diverge da bet.

#### Se violar

Login aceita senha desatualizada; jogador entra no app mas falha ao jogar/depositar (token bet invalido). Bug silencioso dificil de reproduzir.

#### Enforced em

Convencao — nao ha middleware que bloqueie; depende do dev seguir [RN-002](#rn-002)

#### Ver tambem

[RN-002](#rn-002) · [FL-001](#fl-001)
```

---

## Anti-padroes de layout (ClickUp)

| Anti-padrao | Problema | Correto |
|-------------|----------|---------|
| Indice com 213 RT no topo | Scroll imenso antes do conteudo util | Indice curto + [Apendice](#apendice) |
| `<details>` acordeon | Nao renderiza no ClickUp | Listas longas no final + hyperlinks no inicio |
| RT Tier 1 repete FL | Maria abre login... duas vezes | RT Apendice: `Ver [FL-001](#fl-001)` + ficha tecnica |
| DBML antes das TB | Atrapalha leitura do dicionario | DBML so no Apendice |
| Mapa sem Git URL | Dev nao acha repo | `git remote get-url origin` na geracao |

Ver [document-layout.md](document-layout.md).

---

## Anti-padrao telegrafico (grosseiro)

Pergunta de validacao: **"Parece nota de reuniao / sprint?"** → reescrever no tom professor.

### Ruim — FL-008 KYC no jogo (telegrafico)

```markdown
#### Cenario

Maria clica em jogo em /game/[id]. Pre-launch verifica KYC; bet retorna necessidade; front abre modal iframe; apos completar, retry launch.
```

**Problemas:** uma frase; `;` encadeando passos; dev conclui que KYC roda *antes* do clique; referencias misturadas no meio.

### Bom — FL-008 KYC no jogo (professor verboso)

```markdown
#### Cenario

Maria escolhe um jogo no catalogo do app white-label e e enviada para a pagina `/game/[id]`, onde o iframe do jogo deveria carregar.

#### O que acontece passo a passo

1. Maria clica no jogo e o front navega para `/game/[id]`.
2. O front tenta carregar o jogo; se o iframe nao inicializa corretamente, dispara a verificacao de KYC.
3. O front chama a API de status KYC do jogo (via core → integration → bet).
4. Se a resposta indicar que o jogador **precisa** completar KYC, o front chama a rota de start-kyc do jogo.
5. O backend retorna a URL/conteudo do iframe de KYC; o front anexa esse iframe em um modal na UI.
6. Maria conclui o KYC dentro do modal; o front fecha o modal e **tenta novamente** o launch do jogo.

#### Referencias

[RT-204](#rt-204) · [RT-049](#rt-049) · [RT-050](#rt-050) · [RN-011](#rn-011) · [FL-007](#fl-007)
```

---

## Tier RT — classificar na Fase 2

| Tier | Criterio | Formato no doc |
|------|----------|----------------|
| **Tier 1** | Participa de FL jornada critica OU listada em "erros de dev novo" (Fase 3) | `### RT-xxx` expandido |
| **Tier 2** | Demais rotas | Tabela compacta |

Exemplos Tier 1 tipicos: login, register, deposit create, webhook PIX, config Application.

---

## Dados reais da Fase 3

Priorizar exemplos informados pelo time na entrevista:

- URL de app de teste
- Domain de tenant exemplo
- Email/CPF ficticio usado em QA
- Nome de platform/bet de staging

Se nao informado, usar placeholders realistas (`app.expert-a.com`, `joao@gmail.com`) e marcar `[CONFIRMAR]` se critico.
