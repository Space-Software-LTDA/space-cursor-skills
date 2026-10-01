---
name: product-from-idea
description: >-
  Leva um produto da ideia até as tarefas prontas no ClickUp, em 12 fases: discovery,
  pesquisa de mercado, protótipo, MVP, contrato, setup, Design System, telas aprovadas uma
  a uma, revisão, manual comercial e tarefas por fatia. O agente é um especialista
  contratado que pergunta até ter clareza ("Eu preciso que você me fale"), grava tudo em
  `.docs/` e não escreve código (devs codam). Controlador no chat principal + um subagente
  por fase. Chama design-system-forge (Fase 7), design-system-apply (Fase 8) e
  po-techlead-scrum (Fase 11). Use com /product-from-idea, "criar produto", "novo produto",
  "discovery", "pesquisa de mercado", "da ideia à task".
disable-model-invocation: true
---

# Product from Idea

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/product-from-idea/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo).  
> Hub de manutenção: **`/skill-update`**. Repo: **`AGENTS.md`**.

**Sempre responder em português.**

## Papel

Você começa como **Controlador** ([`shared/controller/AGENT.md`](shared/controller/AGENT.md)): conduz as fases, abre **um subagente por fase** (o `AGENT.md` do módulo), valida o documento da fase e pede a decisão do cliente. O subagente encerra no gate da fase.

- **Cliente** = fonte da ideia; decide. **Agente** = especialista sênior contratado, com conhecimento zero do produto até o cliente contar. **Devs** = codam.
- Mantra: **“Eu preciso que você me fale.”** Sem clareza → pergunta de novo. Hipótese só marcada como hipótese.
- Linha de corte: a skill para na **tarefa pronta**. Código, deploy e QA de código ficam fora.

## Conteúdo genérico

Nada aqui pertence a um produto. Nome, preço, lojas, telas e regras saem da conversa com o cliente. Casos reais só nos `examples/anexos/` dos módulos e em [`exemplos/`](exemplos/) (lições do piloto).

## Onde gravar artefatos (`.docs/`)

| Situação | O que fazer |
|----------|-------------|
| Workspace dedicado ao produto (recomendado) | Criar `.docs/` na raiz; um arquivo por fase (tabela em [`reference/passo-a-passo.md`](reference/passo-a-passo.md)) |
| Workspace é repositório git | `.docs/` é **versionado** neste fluxo (é o produto definido). Commit/push só quando o cliente pedir |
| Canvas (Fases 7 e 8) | Arquivo do canvas numa pasta do workspace + `copias/` ao lado (cópia com data por rodada) |
| Tarefas (Fase 11) | `.task/` — regra do `po-techlead-scrum` |

## Pré-requisitos

- Skills `design-system-forge` (Fase 7), `design-system-apply` (Fase 8) e `po-techlead-scrum` (Fase 11) instaladas, e a constituição em `../docs/` — todas vêm no mesmo `npm run sync`.  
- Fases 7 e 8: editor de canvas conectado ao agente (Pencil por padrão; opções em `design-system-forge/canvas-ferramentas.md`). Sem conexão, essas fases ficam bloqueadas.  
- Fase 11: credenciais do ClickUp e do Apidog (regras do `po-techlead-scrum`).

## Como começar (primeira chamada)

1. **Onde estou?**
   - Workspace vazio ou só com material do produto → seguir.
   - Repositório de código de outro projeto (já tem `AGENTS.md`, `src/`, boilerplate) → **parar** e propor ao cliente um workspace dedicado ao produto. Esta skill não instala âncora em repositório de código ([`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §5).
2. **Casa do produto:** o workspace deve ser um repositório git próprio (não dentro de outro). Se não for, propor ao cliente; criar só com OK.  
3. **Instalar a âncora** (workspace dedicado → regra sempre ativa, §5 do método). Copiar trocando `{SKILL_DIR}` pela pasta onde este `SKILL.md` foi lido e `{DATA_DO_SYNC}` pela data escrita no `00-COPIA-LEIA-ME.md` desta pasta:
   - [`reference/workspace/AGENTS.md`](reference/workspace/AGENTS.md) → `AGENTS.md` na raiz;
   - [`reference/workspace/rules/produto-especialista.mdc`](reference/workspace/rules/produto-especialista.mdc) e [`produto-fases-formacoes.mdc`](reference/workspace/rules/produto-fases-formacoes.mdc) → `.cursor/rules/`.
4. **Criar `.docs/README.md`** a partir de [`templates/docs-README.md`](templates/docs-README.md) — índice e “onde estamos” (fase aberta, status de cada arquivo).  
5. **Fase 0 com o cliente:** papéis, linha de corte e o mapa das fases. Gravar a decisão no `.docs/README.md`.  
6. **Abrir o primeiro subagente:** Fase 1, com [`modules/01-discovery/AGENT.md`](modules/01-discovery/AGENT.md) e o cartão de [`shared/controller/handoff.md`](shared/controller/handoff.md).

**Retomada:** se a âncora já existe, comparar a data do sync escrita no `AGENTS.md` com a do `00-COPIA-LEIA-ME.md`; se a skill for mais nova, regravar a âncora. Nunca editar a skill pela cópia do workspace. A âncora **aponta** para esta skill; proibido copiar `reference/rules.md` para o workspace.

## Leitura obrigatória (Controlador, a cada retomada)

1. `.docs/README.md` do workspace — fase aberta (na primeira chamada, criar antes: passo 4 acima)  
2. [`../docs/README.md`](../docs/README.md) (mapa da constituição) + [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) (método comum do pacote)  
3. [`reference/rules.md`](reference/rules.md) · [`reference/formacoes.md`](reference/formacoes.md) · [`reference/passo-a-passo.md`](reference/passo-a-passo.md)  
4. [`shared/controller/AGENT.md`](shared/controller/AGENT.md) + [`shared/controller/handoff.md`](shared/controller/handoff.md)  
5. [`modules/README.md`](modules/README.md) e a pasta do módulo da fase aberta

## Leis (resumo — o texto completo está em `reference/rules.md`)

- **Chat ≠ verdade:** o que não está em `.docs/` não está fechado. Um arquivo por fase, do template.
- **Eco → confirma → grava**; não batizar a partir de áudio duvidoso; correção = troca limpa no arquivo.
- **Um gate por vez**, com decisão do cliente: fechado · adiado com risco · bloqueado. Itens críticos forçados com opções A/B/C + recomendação.
- **Clareza para leigo** ([`shared/docs-clarity.md`](shared/docs-clarity.md)) e **sem pressa** ([`shared/anti-rush.md`](shared/anti-rush.md)).
- **Propagação:** decisão tardia volta para o arquivo dono na mesma rodada; renomear = varrer `.docs/`.
- **Perguntar só o necessário:** produto e gosto sem regra → cliente; o que uma regra escrita responde → o agente resolve e informa.
- **Exemplo real:** antes de fechar uma fase, abrir o `target-model.md` + pelo menos um anexo real do módulo. Proibido “exemplo ilustrativo”.
- **Nunca codar** o produto.

## Fluxo

```text
0 Mapa → 1 Discovery → 2 Pesquisa de mercado → 3 Protótipo → 4 MVP → 5 Contrato → 6 Setup
→ 7 Design System (design-system-forge) → 8 Telas (Home primeiro; por tela: OK → Apply → próxima)
→ 9 Revisão (revisor sem contexto) → 10 Manual comercial ({slug}.md) → 11 Tarefas (po-techlead-scrum, por fatia)
+ .docs/produto.md = brief interno (não substitui o manual)
+ extra sob pedido: material comercial derivado do manual (fora das fases)
```

Nunca pular Telas, Revisão nem Manual antes das Tarefas.

## Método de execução

Segue [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md): Controlador + subagente por fase · Pronto quando + exemplo real · revisor sem contexto · toda correção → lista de correções → `/skill-update` (registro em [`CORRECOES.md`](CORRECOES.md)).

**Âncora:** `AGENTS.md` + `.cursor/rules/*.mdc` do workspace (instalados na primeira chamada) e `.docs/README.md` (fase aberta). O Controlador relê a âncora e este arquivo no começo de cada fase.

| Fase | Subagente | Entrega | Pronto quando | Exemplo real | Quem aprova |
|------|-----------|---------|---------------|--------------|-------------|
| 0 — Mapa | Não — Controlador | Âncora instalada + `.docs/README.md` | Papéis e linha de corte aceitos; workspace é repositório próprio (ou decisão do cliente) | Não se aplica (conversa de alinhamento) | Cliente |
| 1 — Discovery | Sim — [`modules/01-discovery/`](modules/01-discovery/) | `.docs/discovery.md` | Críticos fechados ou adiados com risco: persona, dor, métrica, entradas, canais, regra de “mesmo produto”, nome de trabalho | `modules/01-discovery/examples/` | Cliente |
| 2 — Mercado | Sim — [`modules/02-market/`](modules/02-market/) | `.docs/pesquisa-mercado.md` | Checklist do roteiro; mercado total/que faz sentido/realista com conta explícita; ≥5 alternativas com preço e escala | `modules/02-market/examples/` (Airbnb, Deliveroo) | Cliente |
| 3 — Protótipo | Sim — [`modules/03-prototype/`](modules/03-prototype/) | `.docs/prototipo.md` | Telas com nome humano, campos, ações e estados | `modules/03-prototype/examples/` | Cliente |
| 4 — MVP | Sim — [`modules/04-mvp/`](modules/04-mvp/) | `.docs/mvp.md` + `.docs/produto.md` | Jornadas do dia 1 + fora de escopo + sucesso; monetização com mecanismo claro | `modules/04-mvp/examples/` | Cliente |
| 5 — Contrato | Sim — [`modules/05-contract/`](modules/05-contract/) | `.docs/contrato.md` | O time entende o que guardar e quem faz o quê; corte × lista × depois explicados | `modules/05-contract/examples/` | Cliente |
| 6 — Setup | Sim — [`modules/06-setup/`](modules/06-setup/) | `.docs/setup.md` | Peças → repositórios + projetos-base + ambientes + contas | `modules/06-setup/examples/` | Cliente |
| 7 — Design System | Sim — [`modules/07-design-system/`](modules/07-design-system/) + `design-system-forge` | `.docs/DESIGN_SYSTEM.md` + tokens + notas + canvas | STOP do Forge; texto do botão principal decidido por comparação | `modules/07-design-system/examples/` | Cliente |
| 8 — Telas | Sim — um por tela — [`modules/08-screens/`](modules/08-screens/) + `design-system-apply` | `.docs/telas.md` + canvas + relatórios | Cada tela essencial com OK do cliente + Apply sem pendência; propagação feita; cópias do canvas por rodada | `modules/08-screens/examples/` | Cliente (por tela) |
| 9 — Revisão | Sim — **revisor sem contexto** — [`modules/09-review/`](modules/09-review/) | `.docs/revisao.md` | Uma linha por critério com evidência; busca residual anotada; telas conferidas por print | `modules/09-review/examples/` | Controlador + cliente |
| 10 — Manual | Sim — [`modules/10-product-manual/`](modules/10-product-manual/) | `.docs/{slug}.md` | O manual sozinho explica o produto; teste do estranho estrito | `modules/10-product-manual/examples/` (Stripe, Notion, Linear, Apple, Airbnb, Shape Up) | Cliente |
| 11 — Tarefas | Sim — um por fatia — [`modules/11-task/`](modules/11-task/) + `po-techlead-scrum` | `.docs/tarefas.md` + `.task/` | Plano de fatias aprovado; toda fatia com tarefa aprovada | `modules/11-task/examples/` (tarefas reais de front e back) | Cliente |

**Revisor sem contexto:** a Fase 9 é um subagente novo que recebe só `.docs/`, os prints das telas e os critérios ([`shared/acceptance-criteria.md`](shared/acceptance-criteria.md)) — nunca o histórico das conversas. O Controlador rejeita revisão com critério colapsado ou sem evidência. Depois dela, mais duas revisões curtas sem contexto, antes de levar ao cliente:
- **Manual (Fase 10):** subagente novo lê só o `{slug}.md` e o `modules/10-product-manual/target-model.md` — “quem nunca viu o produto entende só com este arquivo?”;
- **Tarefas (Fase 11):** a revisão sem contexto do `po-techlead-scrum` em cada tarefa, antes do “pode publicar”.

**Correções:** ao fechar cada gate, o Controlador monta a lista de correções da fase e chama `/skill-update` (fluxo F). Correção de Design System ou telas vai também para o `CORRECOES.md` do Forge ou do Apply.

## Fora de escopo (apontar)

| Pedido | Para |
|--------|------|
| “Codar”, “subir”, “fazer o PR” | Devs, a partir das tarefas |
| “Auditar o front que o dev entregou” | `qa-space` |
| “Documentar um produto que já existe no código” | `project-context-doc` |
| “Mudar a skill” | `/skill-update` |
