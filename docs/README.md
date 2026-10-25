# Constituição Space — leia isto primeiro

Esta pasta **não é skill**. É a constituição do time: o que o código deve ser, o que não pode copiar, como o git e a stack funcionam, e o Design System visual.

**Regra de ouro para qualquer agente:** antes de abrir `entry-point.md`, `design-system.md` ou qualquer outro arquivo daqui, leia **este README**. Ele decide *qual* skill lê *o quê*, *por quê* e *como usar* o texto. As skills **não** inventam o mapa de leitura. As skills **não** resumem estes arquivos no `SKILL.md`.

Edite no repo `space-cursor-skills/docs/`. A pasta no Cursor (`SKILLS_DEST_PATH/docs/`) e a do Claude Code (`CLAUDE_SKILLS_DEST_PATH/docs/`, padrão `~/.claude/skills/docs/`) são cópia — rode `npm run sync`.

---

## Trabalho num projeto (fora de uma skill)

A constituição também vale para o dia a dia de qualquer projeto Space, não só quando uma skill é chamada. As **regras do projeto** (ex.: `.claude/CLAUDE.md` do repositório) começam mandando ler este README e guardam só o que é do projeto e as exceções a esta constituição, com o motivo.

```text
1. Este README
2. metodo-demandas.md   ← toda solicitação vira demanda (pedido literal, snapshot, dor/causa, etapas, reaproveitamento)
3. metodo-agentes.md    ← controlador + subagentes, roteador de correção, leis comuns
4. Conforme o trabalho:
   - banco, migration, dinheiro, datas, ids externos → banco.md (+ nomenclatura.md, padrao-ouro.md)
   - git, PR, deploy → git-fluxo.md
   - tela (desenho, admin, listas, skeleton) → ui-gosto.md §0.1, §3.5, §6.7–§6.9, §7.4–§7.5, §11.2
   - código de back → backend.md, entry-point.md, padrao-ouro.md, anti-padroes.md
5. As regras do projeto (exceções e o que é só dele)
```

Feature nova de ponta a ponta (do pedido ao PR) num projeto que já existe: a skill `create-feature` conduz a ordem acima em fases com gates — leitura dela no mapa abaixo.

Moldes do método: [`_moldes/`](_moldes/) (`demanda.md`, `snapshot.md`, `etapa.md`, `tarefa-subagente.md`).

---

## Por que cada skill lê diferente

PO, QA e contexto de produto **não** são o mesmo leitor. O mesmo arquivo serve a objetivos distintos. Confundir o uso é o bug que este README existe para impedir.

| Skill | Trabalho | O que a constituição faz para ela |
| --- | --- | --- |
| `po-techlead-scrum` | Escrever a task (ClickUp) que o júnior vai implementar | A constituição vira **critério, proibição e exemplo na task**. O PO não audita pixel no browser. |
| `qa-space` | Inspecionar o front **já feito** (browser + código) | A constituição vira **régua de auditoria**. O QA não publica ClickUp e não redesenha a arquitetura do back. |
| `design-system-forge` | Criar a base visual **do produto**: manual da marca, DS escrito e componentes no canvas (essencial; ouro opcional) | Space DS = **método**, não tokens do produto. Laws of UX + gates; grava `.docs/DESIGN_SYSTEM.md`; **confronta com [ui-gosto.md](ui-gosto.md)** antes de entregar. |
| `design-system-apply` | Aplicar o DS **já aprovado** nas telas (canvas por padrão; construtor ou código) | Régua = DS do produto + **[ui-gosto.md](ui-gosto.md)** (Fase A confronta DS; Fase B varre telas; Fase C corrige no canvas em loop). Space DS apoia gaps. Artefatos sob `.docs/`. |
| `project-context-doc` | Documentar o produto que **já existe** no código | A constituição vira **guardrail G-xxx** quando o código de fluxo/contrato importa. Não gera PBI. |
| `product-from-idea` | Definir um produto novo da ideia à tarefa (12 fases) | A constituição entra só nas fases do time (Setup, DS, Telas, Tarefas), pelas skills que ela chama. Nas fases de produto (1–5) não se lê constituição. |
| `create-feature` | Levar uma feature nova num produto que **já existe** do pedido ao PR para `HML` (12 fases com gates) | A constituição é a **regra de cada fase**: a skill guarda só a ordem, os gates e o "Pronto quando" e aponta arquivo + seção/ID. Quem executa a fase lê o trecho apontado, não um resumo. |
| `skill-update` | Manter o pack | Garante que o mapa deste README continue verdadeiro. Não usa a constituição para task nem para QA. |

**Proibido:** a skill de QA “completar” uma task de back com entry point. A skill de PO “aprovar visual” no lugar do QA. A skill de contexto inventar stack nova em vez de descrever o que o repo faz. Forge inventariar mock como lei. Apply inventar `P-…` ausente (voltar ao Forge).

---

## Todas as skills — método de execução

[metodo-agentes.md](metodo-agentes.md) vale para **todas** as skills, inclusive `skill-update`: Controlador + um subagente por etapa, etapas com “Pronto quando” e exemplo real, revisor sem contexto, e toda correção registrada na skill pelo `/skill-update`. Cada `SKILL.md` tem uma seção **“Método de execução”** com a tabela das próprias etapas — não copia o método.

## Ordem de leitura obrigatória

```text
1. Este README          ← sempre, qualquer skill de produto
2. metodo-agentes.md    ← sempre, qualquer skill
3. Os arquivos da linha "Sempre ler" da sua skill (tabela abaixo)
4. Os arquivos da linha "Se o trabalho tocar" — só se o escopo pedir
```

Não pule o passo 1. Não leia o Design System “de memória” no lugar do arquivo. Não cole um resumo das 16 seções do entry point no `SKILL.md`.

Após o sync, o path relativo a partir da pasta da skill é `../docs/<arquivo>.md`.

---

## Mapa skill → docs

### `po-techlead-scrum` — PO / Tech Lead / Scrum

**Objetivo com estas docs:** a task sair **implementável por um júnior** sem adivinhar padrão. Critérios descrevem comportamento. Anti-padrão vira `⚠️` e, quando couber, ID `AP-*` / `GO-*` nos critérios de aceite.

**Sempre ler (qualquer task — didática):**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [tom-professor.md](tom-professor.md) | Tom compartilhado PO ↔ Context | Princípios: júnior não adivinha; explicativo ≠ redundante; professor vs ordenante no DDD. **Não** resumir aqui. Granularidade da spec (tela/aba/KPI) continua na skill: `decomposicao-tom-professor.md`. |

**Sempre ler (task com Backend, ou Front+Back):**

| Arquivo | Por quê | Como usar (não é o mesmo que o QA) |
| --- | --- | --- |
| [entry-point.md](entry-point.md) | Padrão central de fluxo Back | A task **exige** roteiro no `index.ts` da feature. Checklist da task incompleto se não citar o teste de ouro (“abri só o entry, sei o fluxo?”). **Não** auditar um PR no browser — isso não é QA. |
| [padrao-ouro.md](padrao-ouro.md) | Princípios GO-02…GO-13 | Viram decisão na task: type por operação, JWT, HTTP, jobs, **nomes da empresa** (repo/tabela/coluna — GO-12) e **escolha em runtime por dicionário** (GO-13). Escrever o **porquê** para o júnior. |
| [banco.md](banco.md) | BD-01…BD-13: dinheiro em centavos `…Cents`, UTC, id externo texto e `external…`, fornecedor como cadastro + `jsonb`, FK para o nosso id, transação, migrations (genérica, idempotente, banco compartilhado, trava), colação, cache versionado | Task que cria ou muda tabela, coluna, migration, dinheiro, data ou integração **cita os BD-* que valem**. Não resumir o arquivo na task. |
| [anti-padroes.md](anti-padroes.md) | Catálogo AP-* | O que a task **proíbe**. Critérios podem citar o ID (`AP-HTTP-01`, `AP-NAM-05` no banco). Forma pedagógica: cenário + ouro (ver [tom-professor.md](tom-professor.md)). |
| [nomenclatura.md](nomenclatura.md) | Manufatura: GitHub, branch, commit, EasyPanel, **PostgreSQL** | **Sempre.** Toda task nomeia alguma coisa. Tabela `snake_case`, coluna camelCase, `createdAt`/`updatedAt`, usuário `space_[cliente]`. Deploy: app = serviço EasyPanel via **`Dockerfile`**; banco = serviço separado (AP-NAM-07). |

**Sempre ler (task com Frontend):**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [frontend.md](frontend.md) | Stack e contrato HTTP do Front | A task manda usar o client do boilerplate, três estados, endpoint que existe. **Não** substituir o Design System: para tokens/tabela/shell, apontar [design-system.md](design-system.md) **sem resumir** as 19 seções. |
| [design-system.md](design-system.md) | Constituição visual | PO **referencia** sem resumir as 19 seções. **Prioridade:** repo/tema BO → DS do produto (`P-…`) se a task for Apply → Space DS no buraco → mock só campos/ações. Player/Home: ordem **modais → Home**; prova social ui-gosto §11.1.5 se o produto for cassino. Prints + “não copiar neon do Lovable”. PO **não** preenche matriz §19 — isso é `qa-space`. |

**Sempre (qualquer camada — entrega):**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [git-fluxo.md](git-fluxo.md) | HML 1:1 com `main` (banco); prova de pronto | A task inclui `## REGRAS DE DDD` (tom **ordenante**: Faça/Abra/Confirme), `## ⛔ NÃO DEVE` no **final**, e, se houver mais de um passo, `## Passo a passo sugerido`. Molde na skill: `evidencias-dod.md`. **Não** resumir git-fluxo no `SKILL.md`. |

**Se o trabalho tocar:**

| Arquivo | Quando | Como usar |
| --- | --- | --- |
| [git-fluxo.md](git-fluxo.md) | Branch, PR, hotfix, “pra qual branch?” (além da leitura **Sempre** de HML/DDD) | Escrever o fluxo **corrigido** na task: branch a partir da `HML`, PR para `HML`, `HML` → `main` por PR; não existe `dev`. |
| [backend.md](backend.md) | Projeto novo ou stack da task | Mandar partir do [boilerplate-back-elysia](https://github.com/Space-Software-LTDA/boilerplate-back-elysia), feature-based, entry no `index.ts`. |
| [stacks-e-estrutura.md](stacks-e-estrutura.md) | Onboarding, Coder, Apidog, **ou** task Docker/README/EasyPanel | Setup/ambiente: app sobe com **`Dockerfile`** no EasyPanel; banco/cache = serviço separado (AP-NAM-07). Caminho no **afirmativo**. |

Task com **API nova/alterada:** o contrato vai ao **Apidog** no pipeline da skill. **Project ID e moduleId: descobrir pelo nome do produto** com o `apidog-cli` (perguntar só se ambíguo; não ficam no env). Operação: `apidog.md`. Constituição: [backend.md](backend.md#apidog).

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
| [tom-professor.md](tom-professor.md) | Só no texto “Como deveria ser” | Explicar o esperado citando § DS / `AP-FE-*`. **Não** copiar decomposição de task do PO. |
| **DS do produto** (`.docs/DESIGN_SYSTEM.md` ou anexo da task) | Task / produto tem `P-…` forjados (Forge/Apply) | Auditar o feito contra esses `P-…` **além** do Space DS. Prioridade: repo/tema BO → `P-…` do produto → Space DS no buraco → mock só campos/ações. **Não** rodar o loop Apply (mini-A / Fix no canvas ou construtor) — isso é `design-system-apply`. |
| [ui-gosto.md](ui-gosto.md) parte geral (§1–§10) | Toda tela | Checklist geral §10 como apoio visual (o Space DS continua a régua principal do QA). |
| [ui-gosto.md](ui-gosto.md) §11.1.5 | Produto cassino: home/player com prova social, jackpot, ticker, “maiores ganhos” | Régua **global ≠ contextual**. FAIL se ticker **e** painel globais; PASS se nested no card (`P-JACKPOT-WINNERS` ou equivalente) + no máx. 1 global (`P-WINS` / `P-TICKER`). |
| [ui-gosto.md](ui-gosto.md) §11.2 | Admin / dashboard / B2B (ex.: gateway admin) | Checklist `GP-…` / `AP-…`: tabela canônica, badge único, anti chrome-waste / KPI void / metric crush / **grid-hole / CTA-spread / meta-baseline** (caça **intra-card**); Scan default **~1300×800**. Hex = DS do produto. |

**Esta skill não lê para:** montar PBI, critério de aceite de um fluxo novo de backend, publicar Doc ClickUp, **nem** limpar DS / patch Lovable (Forge/Apply). Depois do REPORT, o humano chama `po-techlead-scrum`.

**Não confundir com:** `design-system-forge` / `design-system-apply` (DS **do produto** sob `.docs/`, loop IKEA). `qa-space` **audita o feito** (browser + código + task) e grava `.task/`. Se o produto já tem DS forjado, o QA **usa** esse DS como régua — não o reescreve.

---

### `design-system-forge` — criar a base visual do produto

**Objetivo com estas docs:** criar (ou extrair de um projeto existente) a **constituição visual do produto**: manual da marca, `.docs/DESIGN_SYSTEM.md` + tokens e componentes no canvas, com padrões `P-…` pretendidos — não inventário do mock. Entrega o **essencial** e oferece o **ouro**. Barra = **mínimo big-tech** (GATE ACCEPT).

**Sempre ler:**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [design-system.md](design-system.md) | Método Space | Ler **inteiro** como referência de *como* decidir — **não** copiar primary/surfaces do Space para o produto. Tokens e `P-…` saem da marca + fonte + Q1–Q19 + humano. |
| [ui-gosto.md](ui-gosto.md) | Confronto antes do STOP | Parte geral **inteira** + seção do tipo do produto em §11 (cassino §11.1 · admin/B2B §11.2). Tipo sem seção = só geral; outros tipos “não se aplica” com motivo. |
| Laws of UX (`lawsofux.com/llms.txt`) | Porquê psicológico | Abrir o arquivo; mapear ≥10 leis no §2 do template da skill. |

**Artefatos:** só sob `.docs/` (ver skill); peças visuais no canvas do produto. Gates: fonte insuficiente → parar; Q abertas → não gravar DS final; **GATE ACCEPT fail** ou **auto-contradição** → **REPROVADO**. STOP: **PASS** se Qs humanas fechadas (exceção nomeada confirmada = lei; código atrasado = **Dívida Apply**, não ressalva); **PASS COM RESSALVAS** só com decisão humana ainda aberta. Warning obrigatório (hue ≠ Primary). Breakpoints = produto ou Tailwind. Application A–D/F = lei pretendida mesmo sem admin na fonte.

**Esta skill não lê para:** corrigir telas do produto, REPORT `.task/`, task ClickUp. Depois da aprovação humana → `design-system-apply`.

---

### `design-system-apply` — confrontar DS + varrer telas + corrigir no canvas

**Objetivo com estas docs:** (A) confrontar o DS do produto com o gosto; (B) varredura completa das telas (site, construtor, canvas) + relatório de gaps + telas recriadas no canvas; (C) corrigir/redesenhar no canvas em loop até ALIGNED + lista de diferenças para devs. **OK humano entre A→B e B→C.** Proibido pular B.

**Sempre ler:**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| **DS do produto** (`.docs/DESIGN_SYSTEM.md`) | CORE forjado | Sem `P-…` → Forge. Fase A **edita** este arquivo. |
| [ui-gosto.md](ui-gosto.md) | DO / DON’T Space | Parte geral **inteira** + seção do tipo em §11. Marca > gosto; Primary na ação real; tipos não se misturam; cassino §11.1 (prova social **global vs contextual** §11.1.5); **admin/B2B** §11.2 (`GP-…`/`AP-…`, QA ~1300, voids **intra-card**). |
| [design-system.md](design-system.md) | Apoio metodológico | Escalas / §18 / tabelas admin; **não** sobrescrever marca do produto. |

**Artefatos:** Fase A → DS + EXTRACTION_NOTES (**PARAR OK A**); Fase B → inventário **URLs + popups/overlays** + Scan + `QA_REPORTS/` (**PARAR OK B**); Fase C → Fix + re-Scan `…-rN` até ALIGNED. **Pós-ALIGNED** que muda pattern → mini-A + OK antes do Fix (método na skill).

**Gates anti-ALIGNED-falso:** Scan **só** com evidência desta sessão (browser no site; prints via MCP no canvas); se existir review humano (`observacoes.md` / prints / chat), tabela PASS/FAIL obrigatória; affordance (⋯/menu) sem click = FAIL; ALIGNED final exige OK humano explícito (candidato ≠ final). Detalhe: `skills/design-system-apply/VISUAL_QA_METHOD.md` §1.1 / §3.2 / §5.0.

**Esta skill não lê para:** criar DS do zero (Forge), REPORT `qa-space`, ClickUp, AP-FE no código.

---

### `project-context-doc` — contexto de produto

**Objetivo com estas docs:** o doc de contexto ensina o **produto que o código faz hoje**. Guardrails (G-xxx) sobre *como o time escreve código* apontam para a constituição em vez de inventar uma segunda bíblia.

**Sempre ler (didática — qualquer doc):**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [tom-professor.md](tom-professor.md) | Mesmo princípio do PO | Júnior não adivinha; explicativo ≠ redundante. **Artefato diferente:** aqui é FL/RN/G, não task. Layout/mínimos do doc ficam em `language-guide.md` e `pedagogical-examples.md` na skill. |

**Sempre ler (quando o recon achar código de fluxo / API / jobs):**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [padrao-ouro.md](padrao-ouro.md) | Princípios que o time já decidiu | G-xxx pode **referenciar** `GO-03` (type por operação), `GO-07` (dois tokens), etc. Não copiar o catálogo GO inteiro no doc do produto. |
| [entry-point.md](entry-point.md) | Se o back do produto tem (ou deveria ter) roteiro no entry | Documentar **o que o código faz** nos FL/RN. Se o entry atual for pass-through, o G pode apontar o padrão — sem transformar o contexto numa task ClickUp. |

**Se o trabalho tocar:**

| Arquivo | Quando | Como usar |
| --- | --- | --- |
| [git-fluxo.md](git-fluxo.md) / [stacks-e-estrutura.md](stacks-e-estrutura.md) | Onboarding do time **ou** recon achou Dockerfile/EasyPanel/deploy | Documentar o que o produto faz. App = serviço EasyPanel via `Dockerfile`; DB/cache = serviço separado (AP-NAM-07). Caminho no **afirmativo**. |
| [anti-padroes.md](anti-padroes.md) | Código claramente no anti-padrão | G-xxx com cenário do **produto**, não lista genérica AP-*. |

**Esta skill não lê para:** Design System pixel a pixel (não é QA), nem para gerar task na Esteira.

---

### `product-from-idea` — criar produto da ideia à tarefa

**Objetivo com estas docs:** definir um produto novo até a tarefa pronta. A constituição entra nas fases que tocam o time: Setup (6), Design System (7, via Forge), Telas (8, via Apply) e Tarefas (11, via PO). Nas fases 1–5 a skill não lê a constituição — é conversa de produto com o cliente.

**Sempre ler:**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [metodo-agentes.md](metodo-agentes.md) | Controlador + subagente por fase; revisor sem contexto; âncora | É a arquitetura da skill inteira; a âncora em workspace dedicado é regra sempre ativa |

**Se o trabalho tocar:**

| Arquivo | Quando | Como usar |
| --- | --- | --- |
| [nomenclatura.md](nomenclatura.md) · [stacks-e-estrutura.md](stacks-e-estrutura.md) · [git-fluxo.md](git-fluxo.md) | Fase 6 (Setup) | Nome dos repositórios, projetos-base, ambientes. Escrever no `setup.md` em português, sem colar o texto |
| [design-system.md](design-system.md) · [ui-gosto.md](ui-gosto.md) | Fases 7 e 8 | Pelas skills Forge e Apply — a leitura é a delas |
| [tom-professor.md](tom-professor.md) e o resto do mapa do PO | Fase 11 | Pela skill `po-techlead-scrum` |

**Esta skill não lê para:** auditar código, escrever task fora da Fase 11, nem criar o DS sem o Forge.

---

### `create-feature` — feature nova, do pedido ao PR

**Objetivo com estas docs:** cada fase da feature seguir a regra escrita sem que a skill vire uma segunda constituição. A skill tem a ordem, os gates (regras aprovadas · "pode codar" · validação do dono) e o "Pronto quando"; o subagente de cada fase lê **só** o trecho apontado.

**Sempre ler:**

| Arquivo | Por quê | Como usar |
| --- | --- | --- |
| [metodo-agentes.md](metodo-agentes.md) | Controlador + subagente por fase, revisor sem contexto, roteador de correção, leis comuns (impactos, métrica num dicionário) | Arquitetura da skill; Fase 10 = §3 |
| [metodo-demandas.md](metodo-demandas.md) + [_moldes/](_moldes/) | A feature é uma demanda: pedido literal, snapshot, dor/causa, impactos, decisões, etapas, fechamento | Fases 1–4 e 12; cada fase executada vira uma etapa do molde |
| As regras do projeto | Exceções à constituição, lista de áreas de impacto, canvas e DS do produto, dicionário de métricas, ambiente local | Antes da Fase 1; exceção do projeto vence a regra genérica |

**Se o trabalho tocar:**

| Arquivo | Quando | Como usar |
| --- | --- | --- |
| [ui-gosto.md](ui-gosto.md) §0, §0.1, §3, §3.5, §4, §6.5–§6.9, §7, §8, §10, §11 do tipo, §12 | Tela (Fases 5, 8, 9) | Pelo `checklist-front.md` da skill (item → seção). §0.1 é o gate "pode codar" |
| [design-system.md](design-system.md) §3–§11, §16–§19 | Tela (Fases 5, 8, 9) | Método nos buracos do DS do produto (cores, tipografia, cantos, espaçamento, tabela, estados, acessibilidade) |
| [frontend.md](frontend.md) | Código de front (Fase 8) | Prioridade visual, contrato com a API, onde mora o HTTP |
| [banco.md](banco.md) + [nomenclatura.md](nomenclatura.md) "Banco de dados" | Banco e migrations (Fase 7) | Modelo com o `BD-xx` de cada coluna; checklist de PR marcado |
| [padrao-ouro.md](padrao-ouro.md) · [anti-padroes.md](anti-padroes.md) · [backend.md](backend.md) · [entry-point.md](entry-point.md) | Código (Fase 8) | GO-08/GO-11/GO-13; AP-FE-* e as partes de back tocadas |
| [git-fluxo.md](git-fluxo.md) | Branch, validação do dono, PR (Fases 8, 11, 12) | Branch da `HML`, nada no git antes da validação, PR para `HML` sem juntar |

**Esta skill não lê para:** escrever task para outro dev (é o `po-techlead-scrum`), auditar front de terceiros (`qa-space`), criar o DS do produto (`design-system-forge`).

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
| [metodo-agentes.md](metodo-agentes.md) | Como toda skill executa: subagentes por etapa, modelo pela tarefa, checkpoints, “Pronto quando” + exemplo real, revisor sem contexto, roteador de correções, leis comuns | Sim — todas as skills e todo projeto |
| [metodo-demandas.md](metodo-demandas.md) | Como toda solicitação vira registro num projeto: demanda, pedido literal, snapshot antes/depois, dor → causa, já existe?, impactos, decisões, etapas, reaproveitamento, tags, status | Sim — todo projeto com `docs/` versionado |
| [_moldes/](_moldes/) | Moldes do método: `demanda.md`, `snapshot.md`, `etapa.md`, `tarefa-subagente.md` | Copiar para o `docs/_moldes/` do projeto (ou apontar) |
| [banco.md](banco.md) | BD-01…BD-13: modelagem, dinheiro, datas, ids externos, fornecedores, migrations, cache | Sim |
| [tom-professor.md](tom-professor.md) | Didática para júnior (PO + Context; QA opcional) | Sim — princípios; moldes de artefato ficam nas skills |
| [entry-point.md](entry-point.md) | Roteiro no topo do `index.ts`; 16 seções; proibido `prepare`/`handle` | Sim — não resumir |
| [padrao-ouro.md](padrao-ouro.md) | GO-02 … GO-13 | Sim |
| [anti-padroes.md](anti-padroes.md) | Catálogo AP-* (cenário / por quê / ouro / exemplo / erro comum) + Front | Sim |
| [design-system.md](design-system.md) | Space UI DS v1.0 | Sim — QA lê inteiro |
| [ui-gosto.md](ui-gosto.md) | DO / DON’T visual Space: do desenho ao código (§0.1), parte geral (multi-cliente, botão pelo significado, datas, skeleton, lista lembra o estado) + regras por tipo de produto (cassino, admin/B2B com estrutura de tela) | Sim — Forge e Apply leem; todo trabalho de tela segue §0.1; não resumir na skill |
| [stacks-e-estrutura.md](stacks-e-estrutura.md) | Onboarding empresa (git, stack, Coder, Apidog, EasyPanel) | Sim |
| [git-fluxo.md](git-fluxo.md) | Tarefa (a partir da `HML`) → PR `HML` → PR `main`, sem `dev`; nome de branch; validação do dono antes do git; migration junto; deploy EasyPanel; hotfix; HML ≈ main (banco); evidência de pronto | Sim |
| [backend.md](backend.md) | Bun + Elysia + TypeORM + boilerplate | Sim |
| [frontend.md](frontend.md) | Next + Tailwind + DS + boilerplate | Sim |
| [nomenclatura.md](nomenclatura.md) | Repos, branches (`PBI-xxxx-descricao`, `tipo/AAAA-MM-DD-slug`), commits, EasyPanel, **banco** (tabela/coluna/user) | Sim — padrão de manufatura (GO-12) |

Não existe `codigo-ouro.md` monolítico. Este README **é** o mapa (o que antes seria “Parte V”).

---

## Manutenção

1. Texto da constituição → `space-cursor-skills/docs/`
2. Mapa skill → arquivo → **este README**
3. Ponteiro fino no `SKILL.md` da skill de produto
4. `npm run sync` na máquina onde o Cursor e o Claude Code leem as skills (copia para os dois destinos)
5. Reiniciar o chat se a skill já estava carregada
6. Regra que nasceu num projeto e vale para todos: entra aqui, genérica, e sai das regras do projeto (roteador em [metodo-agentes.md](metodo-agentes.md) §4)
