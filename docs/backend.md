> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro**. Editar no repo `space-cursor-skills/docs/`; destino Cursor é cópia (`npm run sync`).

# Backend — como estruturar código novo

Este arquivo diz **com o que** o time escreve API nova e **onde** mora o fluxo. A história do fluxo (roteiro no `index.ts`) está em [entry-point.md](entry-point.md) — leia esse arquivo inteiro quando a task for de Back. Princípios GO-* em [padrao-ouro.md](padrao-ouro.md). Catálogo AP-* em [anti-padroes.md](anti-padroes.md).

Como cada skill usa este arquivo: [README.md](README.md).

---

## Boilerplate oficial

Projeto **novo** de backend **parte** deste repositório, não de pasta vazia:

[https://github.com/Space-Software-LTDA/boilerplate-back-elysia](https://github.com/Space-Software-LTDA/boilerplate-back-elysia)

Copiar o template, ajustar nome/env, e só então escrever a primeira feature. Não “montar Elysia na mão” e depois tentar parecer o boilerplate.

APIs **antigas** (Express, Nest, outro runtime) existem no mundo Space. Código **novo** e PBI de feature nova seguem Bun + Elysia + este padrão, salvo o PO escrever o contrário na task.

---

## Stack (código novo)

| Peça | Escolha |
| --- | --- |
| Runtime | **Bun** |
| HTTP | **Elysia** |
| Validação | **Zod v4** |
| ORM / queries / migrations | **TypeORM** |
| Banco | **PostgreSQL** (`pg`) |
| Auth | JWT (`@elysiajs/jwt`) + bcrypt quando houver senha |
| Telemetria | OpenTelemetry (`@elysiajs/opentelemetry`) |
| Blockchain (quando o produto pedir) | viem |
| Testes | **Vitest** no boilerplate Elysia |
| Git hooks | Husky (build no pre-commit) |
| Lint | ESLint + Prettier |

Jest e Supertest aparecem em **legado**. Não vender Supertest na task se o template daquele repo for Vitest. E2E de produto, quando existir, é Playwright — isso não substitui teste de capítulo no back.

---

## Pastas: feature-based

Organização por **feature / módulo de produto**, não por tipo técnico solto (`controllers/`, `services/`, `helpers/` globais como casa de tudo).

Dentro da feature:

- **Entry** = `index.ts` no topo do módulo (preferência do time). Abrir esse arquivo e entender o fluxo do início ao fim. Detalhe: [entry-point.md](entry-point.md) §6.
- HTTP do vendor / cliente externo em arquivo de client, SQL no repository, util **puro** (sem `fetch` e sem `SELECT`).
- Sem pasta `pipeline/` só para parecer enterprise. Sem `prepare.ts` + `handle.ts` vazios.

O setup com a stack já está no boilerplate para agentes. A skill de PO **aponta** o boilerplate + o entry-point; não inventa uma terceira árvore de pastas na task.

---

## Entry point (obrigatório em fluxo novo)

Norte: um júnior abre **um** arquivo e responde “o que acontece quando X”.

- Roteiro no topo: nomes que são a história (`debitWallet`, `callPartnerPay`, `saveReceipt`) — não `prepare` / `handle`.
- Função interna = o **como**. Só se abre para ver implementação, não para descobrir se o passo existe.
- Pass-through vazio é proibido. SQL e payload pesado fora do entry; a **chamada** permanece no entry.
- Teste de ouro (colar nos critérios Back): *Abri só o entry. Sei o que esse fluxo faz do início ao fim?*

Texto integral: [entry-point.md](entry-point.md). A task Back **está incompleta** se o agente de PO não leu esse arquivo.

---

## Contrato, HTTP, auth, jobs, nomes (resumo de apontadores)

Não substituem [padrao-ouro.md](padrao-ouro.md) nem [nomenclatura.md](nomenclatura.md):

- Um type **por operação**, campos obrigatórios no que o cliente precisa (`token: string`, não `token?: string`).
- HTTP externo é caro; session/identidade no JWT nosso quando a regra do produto for essa; token do parceiro ≠ JWT interno.
- Runtime de produção é o que vale (`bun start` vs `dev` se forem diferentes).
- Cron: `startJobs()` depois do listen, lock, sem side-effect no `import`, sem tenant hardcoded.
- **Banco na task:** PostgreSQL; tabela `snake_case`; coluna camelCase; `createdAt`/`updatedAt` obrigatórias; usuário `space_[cliente]` — GO-12 / AP-NAM-05.

---

## Apidog

Toda API entregue precisa estar documentada no **Apidog** (rotas, params, body, respostas, erros) **antes** da entrega. Convite e permissão: o líder libera o projeto.

Link de convite usado no onboarding: [https://app.apidog.com/invite/user?token=EbW6GkmQVWacuXqzHMos9](https://app.apidog.com/invite/user?token=EbW6GkmQVWacuXqzHMos9)

A skill de contexto cruza código com Apidog quando o humano informar o projeto. A skill de PO, em task de endpoint novo, inclui “atualizar Apidog” nos critérios.

---

## Coder

Desenvolvimento no [Coder](https://coder.spacedev.pro/) é **obrigatório**. Ambiente controlado, parecido com produção. Não usar a máquina local como ambiente principal. Credenciais: o líder.

---

## O que a skill de PO faz com isto

- Grid da task: repo backend + `.env.example`.
- Alterações Back: schema coluna a coluna, DBML, payloads, **e** “o fluxo vive no `index.ts` da feature X seguindo entry-point”.
- Critérios podem citar `GO-*` e `AP-*`.
- Não colar as 16 seções do entry-point na task — apontar o arquivo e exigir o teste de ouro + o que for específico daquela PBI.

## O que a skill de QA **não** faz com isto

QA não redesenha o módulo Elysia. Se o REPORT achar contrato REST quebrado no Front, documenta esperado × feito e devolve ao PO.
