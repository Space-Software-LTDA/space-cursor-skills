> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro**. Editar no repo `space-cursor-skills/docs/`; destino Cursor é cópia (`npm run sync`).

# Frontend — como estruturar UI nova

Este arquivo diz **com o que** o time escreve Front novo e **qual contrato** a tela honra. A constituição **visual** (cores, tabela, shell, o que é proibido) está em [design-system.md](design-system.md) — **não resumida aqui**. Anti-padrões de UI/código Front: [anti-padroes.md](anti-padroes.md) seção AP-FE-*. Princípio GO-11: [padrao-ouro.md](padrao-ouro.md).

Como cada skill usa este arquivo: [README.md](README.md).

---

## Boilerplate oficial

Projeto **novo** de frontend **parte** deste repositório, não de pasta vazia nem de zip do Lovable:

[https://github.com/Space-Software-LTDA/boilerplate-front-nextjs](https://github.com/Space-Software-LTDA/boilerplate-front-nextjs)

O protótipo (Vite/Lovable) é **referência visual**, não a stack de entrega. Entrega = **Next.js**.

Quando o repo for o boilerplate FDD, as regras de pasta/hooks/client HTTP estão no `AGENTS.md` **daquele** repo. Não aplicar FDD em um Next legado que não segue esse `AGENTS.md`.

---

## Stack (código novo)

| Peça | Escolha |
| --- | --- |
| Framework | **Next.js** |
| CSS | **Tailwind CSS** |
| HTTP | O client do **boilerplate** (historicamente axios no onboarding; o que o template atual exportar manda — **não** inventar um segundo `fetch` espalhado nas pages) |
| Componentes | Libs de componente **permitidas**, com as restrições do Design System (ícone = Lucide, tabela = contrato do DS, sem copiar kit gamer/neon) |
| Design | Tokens e regras de [design-system.md](design-system.md) |

Biblioteca de componente não autoriza furar radius, glow, ou tabela ad-hoc. O DS manda.

---

## Contrato com a API

- Só chama endpoint que **existe** no back / OpenAPI / Apidog. Query inventada é P0 de produto.
- Detalhe é `GET /recurso/:id`, não `GET /lista` + `find` no client.
- Paginação e filtro **no servidor**. `limit=1000` + slice local é paginação falsa.
- Front fala com a **API nossa**. Token do parceiro não viaja no `Authorization` do browser ([AP-FE-14](anti-padroes.md), [GO-07](padrao-ouro.md)).
- Três estados em toda listagem/detalhe: loading, empty, error (erro da API visível — não `catch {}` + toast genérico).

---

## Onde mora o HTTP e a regra

- Sem `fetch` / `useQuery` / `useMutation` **na view** quando o projeto for FDD/boilerplate — client e hook na camada que o `AGENTS.md` do repo definir.
- Sem lógica de negócio no JSX. Sem `useEffect` em cascata para estado que já é derivável.
- Permissão: **guard de rota e** esconder botão. Só esconder o botão não é segurança de UX.

---

## Visual: o que este arquivo não substitui

`qa-space` lê [design-system.md](design-system.md) **inteiro** e preenche a matriz. `po-techlead-scrum` **aponta** o DS na task Front (“não copiar neon do Lovable; tabela §11; um CTA primary por seção”) e coloca prints no space-assets. Nenhum dos dois cola um resumo de 10 bullets no lugar das 19 seções.

Proibido de produto (lembrete, não substitui o DS):

- Identidade gamer / cyberpunk / dribbble no lugar de corporativo minimalista
- Hex do mock no lugar do token Primary/Surface do produto
- `<table>` HTML solta quando o DS exige o contrato de tabela (zebra, sort, ⋯, paginação)

---

## Coder e entrega

Mesma regra do back: desenvolver no [Coder](https://coder.spacedev.pro/). Env de API no Front (`NEXT_PUBLIC_*`) documentada na task; secrets não vão no git.

---

## O que a skill de QA faz com isto

- Wizard + browser + código da rota.
- DS inteiro + AP-FE no código + contrato na Network.
- REPORT em `.task/`. Não publica ClickUp.

## O que a skill de PO faz com isto

- Task Front: telas, estados, URL da API, prints, “seguir DS / boilerplate”.
- Não preencher veredito Aprovado/Reprovado de pixel — isso é o REPORT do QA.
