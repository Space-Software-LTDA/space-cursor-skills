# Constituição Space — leia isto primeiro

Esta pasta **não é skill**. É a constituição do time: o que o código deve ser, o que não pode copiar, como o git e a stack funcionam, e o Design System visual.

**Regra de ouro para qualquer agente:** antes de abrir `entry-point.md`, `design-system.md` ou qualquer outro arquivo daqui, leia **este README**. Ele decide *qual* skill lê *o quê*, *por quê* e *como usar* o texto. As skills **não** inventam o mapa de leitura. As skills **não** resumem estes arquivos no `SKILL.md`.

Edite no repo `space-cursor-skills/docs/`. A pasta no Cursor (`SKILLS_DEST_PATH/docs/`) é cópia — rode `npm run sync`.

---

## Por que cada skill lê diferente

PO, QA e contexto de produto **não** são o mesmo leitor. O mesmo arquivo serve a objetivos distintos. Confundir o uso é o bug que este README existe para impedir.

| Skill | Trabalho | O que a constituição faz para ela |
| --- | --- | --- |
| `po-techlead-scrum` | Escrever a task (ClickUp) que o júnior vai implementar | A constituição vira **critério, proibição e exemplo na task**. O PO não audita pixel no browser. |
| `qa-space` | Inspecionar o front **já feito** (browser + código) | A constituição vira **régua de auditoria**. O QA não publica ClickUp e não redesenha a arquitetura do back. |
| `project-context-doc` | Documentar o produto que **já existe** no código | A constituição vira **guardrail G-xxx** quando o código de fluxo/contrato importa. Não gera PBI. |
| `skill-update` | Manter o pack | Garante que o mapa deste README continue verdadeiro. Não usa a constituição para task nem para QA. |

**Proibido:** a skill de QA “completar” uma task de back com entry point. A skill de PO “aprovar visual” no lugar do QA. A skill de contexto inventar stack nova em vez de descrever o que o repo faz.

---

## Ordem de leitura obrigatória

```text
1. Este README          ← sempre, qualquer skill de produto
2. Os arquivos da linha "Sempre ler" da sua skill (tabela abaixo)
3. Os arquivos da linha "Se o trabalho tocar" — só se o escopo pedir
```

Não pule o passo 1. Não leia o Design System “de memória” no lugar do arquivo. Não cole um resumo das 16 seções do entry point no `SKILL.md`.

Após o sync, o path relativo a partir da pasta da skill é `../docs/<arquivo>.md`.

---

## Mapa skill → docs

### `po-techlead-scrum` — PO / Tech Lead / Scrum

**Objetivo com estas docs:** a task sair **implementável por um júnior** sem adivinhar padrão. Critérios descrevem comportamento. Anti-padrão vira `⚠️` e, quando couber, ID `AP-*` / `GO-*` nos critérios de aceite.

**Sempre ler (task com Backend, ou Front+Back):**

| Arquivo | Por quê | Como usar (não é o mesmo que o QA) |
| --- | --- | --- |
| [entry-point.md](entry-point.md) | Padrão central de fluxo Back | A task **exige** roteiro no `index.ts` da feature. Checklist da task incompleto se não citar o teste de ouro (“abri só o entry, sei o fluxo?”). **Não** auditar um PR no browser — isso não é QA. |
| [padrao-ouro.md](padrao-ouro.md) | Princípios GO-02…GO-12 | Viram decisão na task: type por operação, JWT, HTTP, jobs, **e nomes da empresa** (repo/tabela/coluna — GO-12). Escrever o **porquê** para o júnior. |
| [anti-padroes.md](anti-padroes.md) | Catálogo AP-* | O que a task **proíbe**. Critérios podem citar o ID (`AP-HTTP-01`, `AP-NAM-05` no banco). Tom professor: cenário + ouro. |
| [nomenclatura.md](nomenclatura.md) | Manufatura: GitHub, branch, commit, EasyPanel, **PostgreSQL** | **Sempre.** Toda task nomeia alguma coisa. Tabela `snake_case`, coluna camelCase, `createdAt`/`updatedAt`, usuário `space_[cliente]`. Não deixar isso só no onboarding. |

**Sempre ler (task com Frontend):**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [frontend.md](frontend.md) | Stack e contrato HTTP do Front | A task manda usar o client do boilerplate, três estados, endpoint que existe. **Não** substituir o Design System: para tokens/tabela/shell, apontar [design-system.md](design-system.md) **sem resumir** as 19 seções. |
| [design-system.md](design-system.md) | Constituição visual | PO **referencia** sem resumir as 19 seções. **Prioridade:** repo do produto (tema já definido) → DS só no buraco → mock só campos/ações. Prints + “não copiar neon do Lovable”. PO **não** preenche matriz §19 — isso é `qa-space`. |

**Sempre (qualquer camada — entrega):**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [git-fluxo.md](git-fluxo.md) | HML 1:1 com `main` (banco); prova de pronto | A task inclui `## REGRAS DE DDD` (tom **ordenante**: Faça/Abra/Confirme), `## ⛔ NÃO DEVE` no **final**, e, se houver mais de um passo, `## Passo a passo sugerido`. Molde na skill: `evidencias-dod.md`. **Não** resumir git-fluxo no `SKILL.md`. |

**Se o trabalho tocar:**

| Arquivo | Quando | Como usar |
| --- | --- | --- |
| [git-fluxo.md](git-fluxo.md) | Branch, PR, hotfix, “pra qual branch?” (além da leitura **Sempre** de HML/DDD) | Escrever o fluxo **corrigido** na task (merge PBI→`dev` permitido; `hml`/`main` só PR). |
| [backend.md](backend.md) | Projeto novo ou stack da task | Mandar partir do [boilerplate-back-elysia](https://github.com/Space-Software-LTDA/boilerplate-back-elysia), feature-based, entry no `index.ts`. |
| [stacks-e-estrutura.md](stacks-e-estrutura.md) | Onboarding, Coder, Apidog | Só quando a task for de setup/ambiente — a **nomenclatura** em si já está em `nomenclatura.md` (leitura sempre). |

Task com **API nova/alterada:** o contrato vai ao **Apidog** no pipeline da skill. **Project ID e moduleId: perguntar** (não ficam no env). Operação: `apidog.md`. Constituição: [backend.md](backend.md#apidog).

**Esta skill não lê para:** pixel-perfect, REPORT.md, veredito Aprovado/Reprovado de tela. Se o PO pediu inspeção do feito, redirecionar para `qa-space` e depois gerar a task de correção a partir do `.task/` do QA.

---

### `qa-space` — QA de front

**Objetivo com estas docs:** dizer se o **feito** (Next no browser + código da rota) respeita o Design System, o contrato da API e os anti-padrões de Front. Entrega = `.task/.../REPORT.md`. **Não** publica ClickUp.

**Sempre ler:**

| Arquivo | Por quê | Como usar (não é o mesmo que o PO) |
| --- | --- | --- |
| [design-system.md](design-system.md) | Constituição visual **integral** (~805 linhas) | Ler **o arquivo inteiro** antes da Fase 2. Auditar tela a tela contra §§. Matriz em `qa-space/reference.md`. **Proibido** validar visual só com memória ou com 10 bullets do `SKILL.md`. **Prioridade:** chrome/tokens **já no repo do produto** prevalecem; DS preenche o que o repo não define; mock **não** é régua de cor/borda. Não reprovar o produto por manter o primary que já está no código. Se o repo tiver `docs/SPACE_DESIGN_SYSTEM.md` mais novo, preferir o do repo e registrar a versão no REPORT. |
| [anti-padroes.md](anti-padroes.md) — **Parte Frontend (AP-FE-*)** e, se o código Front tocar contrato, AP-TYPE-03 | O que o júnior/IA copia no UI | Caçar no código da rota e no Network. Cada achado: esperado × feito + evidência. **Não** reescrever a task de Back nem exigir `index.ts` de um módulo de API — isso é PO + entry-point. |

**Se o trabalho tocar:**

| Arquivo | Quando | Como usar |
| --- | --- | --- |
| [frontend.md](frontend.md) | Stack Next, client HTTP, FDD | Conferir se o projeto é o boilerplate FDD (`AGENTS.md` local). Não aplicar FDD em repo que não é esse boilerplate. |
| [padrao-ouro.md](padrao-ouro.md) — só **GO-11** | Contrato real, três estados | Apoio à Fase 4 (API). O restante dos GO-* é para task de Back, não para o REPORT visual. |

**Esta skill não lê para:** montar PBI, critério de aceite de um fluxo novo de backend, publicar Doc ClickUp. Depois do REPORT, o humano chama `po-techlead-scrum`.

---

### `project-context-doc` — contexto de produto

**Objetivo com estas docs:** o doc de contexto ensina o **produto que o código faz hoje**. Guardrails (G-xxx) sobre *como o time escreve código* apontam para a constituição em vez de inventar uma segunda bíblia.

**Sempre ler (quando o recon achar código de fluxo / API / jobs):**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [padrao-ouro.md](padrao-ouro.md) | Princípios que o time já decidiu | G-xxx pode **referenciar** `GO-03` (type por operação), `GO-07` (dois tokens), etc. Não copiar o catálogo GO inteiro no doc do produto. |
| [entry-point.md](entry-point.md) | Se o back do produto tem (ou deveria ter) roteiro no entry | Documentar **o que o código faz** nos FL/RN. Se o entry atual for pass-through, o G pode apontar o padrão — sem transformar o contexto numa task ClickUp. |

**Se o trabalho tocar:**

| Arquivo | Quando | Como usar |
| --- | --- | --- |
| [git-fluxo.md](git-fluxo.md) / [stacks-e-estrutura.md](stacks-e-estrutura.md) | Onboarding do time no doc | Só se o pedido for documentar práticas da empresa. O doc de produto **não** substitui o Staks. |
| [anti-padroes.md](anti-padroes.md) | Código claramente no anti-padrão | G-xxx com cenário do **produto**, não lista genérica AP-*. |

**Esta skill não lê para:** Design System pixel a pixel (não é QA), nem para gerar task na Esteira.

---

### `skill-update` — hub do pack

**Objetivo com estas docs:** a constituição continuar **uma fonte**. Skills de produto só têm ponteiro.

**Sempre ler:**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| **Este README** | Mapa oficial | Qualquer mudança em `docs/` ou no “quem lê o quê” **atualiza este arquivo primeiro**. Depois o `SKILL.md` da skill de produto (5–10 linhas de ponteiro). |

**Se o trabalho tocar:** o arquivo temático que o usuário pediu para alterar (`entry-point.md`, `design-system.md`, …). Wizard: ação **atualizar constituição**.

**Não** duplicar listas GO/AP/DS dentro de `skill-update`. Não resumir entry-point no catálogo.  
**Não** colocar ID/URL/default de um cliente nas skills — o pack é genérico (`/skill-update`).

---

## Índice dos arquivos (o que cada um é)

| Arquivo | Tema | Integral? |
| --- | --- | --- |
| [entry-point.md](entry-point.md) | Roteiro no topo do `index.ts`; 16 seções; proibido `prepare`/`handle` | Sim — não resumir |
| [padrao-ouro.md](padrao-ouro.md) | GO-02 … GO-11 | Sim |
| [anti-padroes.md](anti-padroes.md) | Catálogo AP-* (cenário / por quê / ouro / exemplo / erro comum) + Front | Sim |
| [design-system.md](design-system.md) | Space UI DS v1.0 | Sim — QA lê inteiro |
| [stacks-e-estrutura.md](stacks-e-estrutura.md) | Onboarding empresa (git, stack, Coder, Apidog, EasyPanel) | Sim |
| [git-fluxo.md](git-fluxo.md) | PBI → dev / PR hml / PR main, hotfix; HML ≈ main (banco); evidência de pronto | Sim — sem contradizer “commit direto” vs merge em `dev` |
| [backend.md](backend.md) | Bun + Elysia + TypeORM + boilerplate | Sim |
| [frontend.md](frontend.md) | Next + Tailwind + DS + boilerplate | Sim |
| [nomenclatura.md](nomenclatura.md) | Repos, branches, commits, EasyPanel, **banco** (tabela/coluna/user) | Sim — padrão de manufatura (GO-12) |

Não existe `codigo-ouro.md` monolítico. Este README **é** o mapa (o que antes seria “Parte V”).

---

## Manutenção

1. Texto da constituição → `space-cursor-skills/docs/`
2. Mapa skill → arquivo → **este README**
3. Ponteiro fino no `SKILL.md` da skill de produto
4. `npm run sync` na máquina onde o Cursor lê as skills
5. Reiniciar o chat se a skill já estava carregada
