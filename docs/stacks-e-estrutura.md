> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro**. Editar no repo `space-cursor-skills/docs/`; destino Cursor é cópia (`npm run sync`).

# Stacks e estrutura — onboarding

Este é o documento de orientação para quem chega no time: repositórios, git, servidores, banco, stack, testes, Coder e Apidog. A **manufatura de nomes** (repo, branch, tabela, coluna, EasyPanel) é padrão obrigatório — texto normativo em [nomenclatura.md](nomenclatura.md), princípio GO-12, anti-padrões AP-NAM-04…06.

Onboarding humano (Doc com subpáginas): **Bíblia da Space** — https://app.clickup.com/90131082033/docs/2ky3path-37093

Doc antigo (“Staks e Estruturas”): https://doc.clickup.com/90131082033/d/h/2ky3path-17153/368dc66a198e994

O título antigo “Staks e Estruturas” estava grafado errado. O nome correto é **Stacks e estrutura**.

Arquivos irmãos (não copiar o conteúdo inteiro de novo aqui):

| Tema | Arquivo |
| --- | --- |
| Git detalhado (sem contradição) | [git-fluxo.md](git-fluxo.md) |
| Nomes (repo, branch, DB, commit) | [nomenclatura.md](nomenclatura.md) |
| API nova (Elysia + entry) | [backend.md](backend.md) |
| UI nova (Next + DS) | [frontend.md](frontend.md) |
| Roteiro no `index.ts` | [entry-point.md](entry-point.md) |
| Visual | [design-system.md](design-system.md) |

Como cada skill usa a constituição: [README.md](README.md).

---

## Estrutura do GitHub

Cada cliente e projeto têm repositórios separados. Nomenclatura:

```text
[nome-do-cliente]_[nome-do-projeto]_[tipo-do-projeto]
```

Exemplo: `space_cardapius_backend`.

Se o repositório for na organização do cliente:

```text
[nome-do-projeto]_[tipo-do-projeto]
```

**Nunca** letra maiúscula ou CamelCase no nome do repo. Detalhe: [nomenclatura.md](nomenclatura.md).

---

## Git — fluxo de branches e PRs

Resumo. Texto normativo completo: [git-fluxo.md](git-fluxo.md).

- Branch da tarefa: a partir de `main`, nome `PBI-2304` (ID do ClickUp).
- **`dev`:** merge da branch do PBI + push (teste / stage). Isso **não** é commit solto em cima de `dev`.
- **`hml`:** só Pull Request da PBI, com code review.
- **`main`:** só Pull Request a partir de `hml`, Tech Lead / Release Manager.
- `hml` e `main` protegidas. Proibido commit direto (editar arquivos e commitar) em `dev`, `hml` ou `main`.
- Hotfix: branch `hotfix_*` a partir de `main` → PR para `main` → back-merge em `hml` e `dev`.
- Commit: `tipo: mensagem` (exemplo `feat: adicionar filtro de status`).

```text
PBI-xxxx (a partir de main)
    ├── merge + push → dev
    └── PR → hml → PR → main
```

Diagramas no Doc ClickUp: usar **PNG** (anexo) ou imagem mermaid.ink. Não colar bloco `mermaid` cru se o Doc quebrar o render.

---

## Boilerplates oficiais (projeto novo)

Não começar API ou Front do zero.

| Camada | Repositório |
| --- | --- |
| Backend | [boilerplate-back-elysia](https://github.com/Space-Software-LTDA/boilerplate-back-elysia) |
| Frontend | [boilerplate-front-nextjs](https://github.com/Space-Software-LTDA/boilerplate-front-nextjs) |

---

## Servidores (EasyPanel)

Gerenciamos servidores com **EasyPanel**.

- Projeto: `[nome-do-cliente]_[nome-do-projeto]`
- Aplicação: `[nome-do-servico]`

Sempre backup de banco e arquivos em local seguro.

---

## Banco de dados

- Tecnologia: **PostgreSQL**
- Usuário: `space_[nomedocliente]`
- Senha aleatória **sem** caracteres especiais
- Tabelas: `snake_case`
- Colunas: **camelCase**
- `createdAt` e `updatedAt` **obrigatórias**

Exemplo e anti-typo (`createdAt`, não `createAt`): [nomenclatura.md](nomenclatura.md). Isso é **padrão de código** (GO-12 / AP-NAM-05), não só texto de boas-vindas.

---

## Stacks de desenvolvimento

### Frontend

- **Next.js** + **Tailwind CSS**
- HTTP: client do boilerplate (não inventar um segundo client nas pages)
- Protótipo Lovable = referência visual; entrega = Next
- Design System: [design-system.md](design-system.md) — **não** copiar neon/gamer do mock
- FDD / `AGENTS.md`: só quando o repo for o boilerplate Next FDD

Texto normativo: [frontend.md](frontend.md).

### Backend

- Runtime **Bun**, HTTP **Elysia**, validação **Zod v4**, ORM **TypeORM**, Postgres, JWT + bcrypt, OpenTelemetry, Husky, ESLint/Prettier, testes **Vitest**
- Pastas **feature-based**
- Fluxo novo: roteiro no `index.ts` da feature — [entry-point.md](entry-point.md)
- APIs antigas (Express etc.) existem; código **novo** segue Elysia + este padrão, salvo a task dizer o contrário

Texto normativo: [backend.md](backend.md).

---

## Testes

| Tipo | Ferramenta |
| --- | --- |
| Unitário / capítulo no boilerplate Elysia | **Vitest** |
| Unitário em legado | Jest pode aparecer |
| Integração | O que o **boilerplate daquele repo** usar — não assumir Supertest se o template for outro |
| E2E | **Playwright** |

Teste de back de feature: comportamento do capítulo (dado fake de HTTP/repo, assert no efeito), não “assert Promise”. Ver checklist em [padrao-ouro.md](padrao-ouro.md).

---

## Ferramentas obrigatórias

### Apidog (documentação de API)

A API precisa estar completa no Apidog **antes** de qualquer entrega: rota, parâmetro, body, resposta, erros.

Convite: [https://app.apidog.com/invite/user?token=EbW6GkmQVWacuXqzHMos9](https://app.apidog.com/invite/user?token=EbW6GkmQVWacuXqzHMos9) — peça ao líder a permissão do projeto.

### Coder (ambiente de desenvolvimento)

Uso do [Coder](https://coder.spacedev.pro/) é **obrigatório**. Ambiente controlado, semelhante à produção. **Não** use a máquina local como ambiente principal. Credenciais: o líder.

---

## Constituição de código (além deste onboarding)

Quem for implementar fluxo de backend ou revisar PBI de API: [entry-point.md](entry-point.md), [padrao-ouro.md](padrao-ouro.md), [anti-padroes.md](anti-padroes.md).

Quem for implementar ou auditar UI: [design-system.md](design-system.md) e a seção Front de [anti-padroes.md](anti-padroes.md).

Agentes de Cursor: o mapa “qual skill lê o quê” está só no [README.md](README.md).
