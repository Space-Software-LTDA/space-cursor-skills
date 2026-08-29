> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro** (quem lê o quê e por quê). Editar no repo `space-cursor-skills/docs/`; destino Cursor é cópia (`npm run sync`).

# Padrão ouro — princípios transversais

A história do fluxo está em [entry-point.md](entry-point.md). Isto aqui impede o júnior de, com o roteiro bonito, ainda assim ir na API externa buscar um ID que já está no token, devolver um type com tudo opcional, ligar um cron sem lock ou commitar `JWT_SECRET=secret`.

Cada princípio é **inviolável** até o PO dizer o contrário **por escrito na task**.

Como cada skill usa este arquivo: [README.md](README.md).

---

## GO-02 — Nome descreve intenção, não implementação

O arquivo `httpClient.ts` pode usar `fetch` por baixo. O arquivo **não** pode se chamar `axiosClient.ts` se não usa Axios — o próximo júnior vai `import axios` “porque o nome disse”.

Pasta do módulo, chave no dicionário de roteamento e nome no banco **são o mesmo identificador**. Três nomes para a mesma coisa = 500 “plataforma não suportada” no primeiro deploy.

Arquivo `validate-phone copy.ts` não existe. O Explorer do Windows não é versionamento.

**Ouro:** se o nome mente, o código está errado — mesmo que “funcione”.

---

## GO-03 — Tipagem é contrato, não saco de opcionais

Imagine o cliente da sua API:

```ts
const { data } = await api.post('/login', body)
const jwt = data.token  // precisa ser string. Sempre.
```

Se o type no **seu** serviço é `token?: string`, o compiler do seu repo aceita `return {}`. O cliente quebra em runtime: `Authorization: Bearer undefined`. **A interrogação matou o motivo de existir TypeScript.**

Campo que nenhuma operação usa (`url` no login, `gender` no wallet) **não entra** no type daquela operação. Type da integração suja (JSON do parceiro) pode ser largo. O `toDto()` / `replace()` é a fronteira: entra JSON sujo, sai contrato **fechado**.

Um type por operação. Login ≠ Me ≠ Wallet. Não existe `UserGlobal` com 20 `?`.

---

## GO-04 — Uma fonte de verdade por dado

O token/sessão já tem o `customerId`. O banco local já tem o `customerId`. A API do parceiro **não** precisa ser consultada “só para ter certeza” no caminho do pagamento.

Pense no crachá da empresa: o número já está impresso. Ligar para a recepção a cada ida ao caixa atrasa a fila, gasta a linha e, se a recepção estiver lenta, o caixa nem abre.

Regra: token → banco local → **só então** HTTP externo. E HTTP externo no caminho crítico só se o dado **não existir** nos dois primeiros.

---

## GO-05 — Caminho crítico curto

O usuário clicou “pagar”. Ele espera o QR / o recibo **agora**.

“É o primeiro pagamento da vida dele?” é métrica de dashboard. Pode ir:

- no `GET` de status que o client já consulta em polling; ou
- em background, com `.catch` **explícito** no log.

Não faça o QR esperar a métrica. Proxy, rate limit e Cloudflare já deixam o caminho lento. Não some mais um RTT por vaidade de dado.

---

## GO-06 — HTTP externo é caro

Cada call passa por rede, às vezes proxy, às vezes WAF. Uma call a menos é produto mais rápido e menos bloqueio.

Clone de client HTTP de 800 linhas em 16 pastas **não** é “padrão enterprise”. É 16 bugs de retry para consertar. Um módulo compartilhado: session, retry com teto, log. Adapters magros.

O runtime de **produção** é o que vale. Se `dev` não liga proxy / não usa o mesmo engine, o PR testado só no `dev` é falso positivo.

---

## GO-07 — Auth nossa vs auth do parceiro

Dois tokens diferentes:

| Token | Quem assina | Para que |
| --- | --- | --- |
| JWT **nosso** | `JWT_SECRET` do serviço | `userId` interno, session de infra, token do parceiro **embutido** |
| Token do **parceiro** | O parceiro | Bearer que a API deles exige |

Devolver o token cru do parceiro como se fosse o nosso = nas próximas calls você não tem `userId` interno nem session. Aí nasce o `GET /me` inútil.

Assinar com `expiresIn: '30d'` no token **interno** quando o produto diz “a sessão não cai por TTL nosso” é bug de produto. Token do parceiro pode expirar. O nosso, se a regra for eterna, assina **sem** `exp`.

`JWT_SECRET || "secret"` e Basic `admin`/`admin` são incidente de segurança, não “facilita o onboarding”.

---

## GO-08 — Util compartilhada, não clone

JWT, HTTP client, formatter de response, money, uuid — **um** lugar. Copiar o arquivo para a pasta do módulo novo é a dívida que esta bíblia existe para impedir.

Service que só faz `return repo.list()` é camada a mais. Apague.

Util que faz `fetch` ou `SELECT` não é util. É client ou repository com nome errado.

---

## GO-09 — Erro explícito, log limpo, secret fora do git

- `catch {}` = bug que você escolheu não ver.
- `"caiu aqui é doidera"` = o on-call às 3h da manhã não debuga.
- `log(req.body)` no login = senha no Datadog = LGPD.
- Password de produção em comentário no `.env.example` = rotacionar secret amanhã.

`.env.example` lista **nomes**. Valores fictícios (`changeme`). Fail fast se secret obrigatório faltar.

---

## GO-10 — Jobs não são “script que sobe junto”

Cron registra **depois** do `listen`, com função `startJobs()`. Import do módulo **não** dispara cron (senão teste e script disparam produção).

Dois pods = dois crons, a menos que exista lock. `* * * * *` com comentário `TEMP` não entra no `main`.

Tenant/domínio **nunca** tem default de produção no código (`?? 'app.cliente.com'`). Sem tenant, **falha**. Default cria dado fantasma no tenant errado.

---

## GO-11 — Frontend: contrato real, DS, três estados

Endpoint que existe. Paginação no servidor. Guard de rota **e** botão escondido. Sem `fetch` no JSX. Loading / empty / error. Tokens de cor, não hex do mock. Tabela do Design System, não `<table>` ad-hoc.

---

## GO-12 — Nomenclatura da empresa é contrato (repo, branch, banco, painel)

O onboarding (“Stacks e estrutura”) não é texto de RH. É **manufatura**: como a coisa se chama no GitHub, no ClickUp, no Postgres e no EasyPanel. O júnior que inventa `MinhaTabela`, coluna `created_at` ou repo `SpaceCardapiusBackend` está fora do padrão — mesmo que o fluxo no `index.ts` esteja bonito.

Texto normativo, com exemplos: [nomenclatura.md](nomenclatura.md). Não resumir aquele arquivo aqui.

O que é **inviolável** até o PO escrever o contrário na task:

| Onde | Padrão |
| --- | --- |
| Repo GitHub | `cliente_projeto_tipo` em **minúsculas** + underscore. Zero CamelCase. |
| Branch de feature | `PBI-{id}` a partir de `main`. |
| Commit | `tipo: mensagem` |
| EasyPanel | projeto `cliente_projeto`; app = nome do serviço |
| Banco | **PostgreSQL**. Usuário `space_[cliente]`. Tabela `snake_case`. Coluna **camelCase**. `createdAt` e `updatedAt` em **toda** tabela. |

Entity TypeORM / migration / SQL da task têm que contar a **mesma** história (AP-DB-04). Task que cria tabela sem esse grid está incompleta.

---

## Checklist de PR — Backend (colar)

Responder em voz alta a pergunta da [entry-point.md](entry-point.md) §9 **e** esta lista:

- [ ] Abri **só** o entry: sei o fluxo do início ao fim? ([entry-point.md](entry-point.md))
- [ ] Entry no topo; 10–40 linhas de ordem de grandeza; nomes Intention-Revealing
- [ ] Zero `prepare` / `handle` / `process` / `persist` como nome de passo
- [ ] Zero pass-through vazio
- [ ] SQL / payload / loop pesado **fora** do entry; chamada **no** entry
- [ ] Sem HTTP externo só para reler ID/token que já está no JWT/banco
- [ ] Sem N+1; sem SQL concatenado; SQL no repository; util puro
- [ ] Type de saída obrigatório, **por operação**
- [ ] JWT nosso (não token cru de terceiro); secret sem default
- [ ] Retry com teto; 401 não retenta; session/identidade persistida se existir
- [ ] Fire-and-forget com `.catch` visível
- [ ] Cron: lock + sem TEMP + sem side-effect no import
- [ ] Sem tenant/URL/expert hardcoded
- [ ] PII redactada; `.env.example` sem secret real
- [ ] Sem `catch {}`; sem mensagem de piada
- [ ] Teste de comportamento do capítulo, não “assert Promise”
- [ ] Validado no runtime que produção usa quando isso importa (`start` ≠ `dev`)
- [ ] Nomes da empresa: repo/branch/commit/tabela/coluna segundo [nomenclatura.md](nomenclatura.md) (GO-12) — tabela `snake_case`, coluna camelCase, `createdAt`/`updatedAt`
