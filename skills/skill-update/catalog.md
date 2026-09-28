# Catálogo das skills Space

Fonte: repo `space-cursor-skills` → pasta `skills/`.  
Destino no Cursor: `SKILLS_DEST_PATH` (por máquina). Hub: **`/skill-update`**.

Atualizar **este arquivo** sempre que criar, renomear ou remover uma skill.

| Skill (pasta) | Trigger | Função | Artefatos locais | ClickUp env |
|---------------|---------|--------|------------------|-------------|
| `skill-update` | `/skill-update` | Hub: sync, manutenção, catálogo, regras transversais | N/A (só docs da skill) | Não |
| `po-techlead-scrum` | anexar / PO-task | Tasks ClickUp + contrato Apidog (Objetivo → regra → DB → rotas → task) | `.task/` | Sim (`clickup.env` + `apidog.env`) |
| `project-context-doc` | anexar / contexto produto | Doc de contexto + Docs ClickUp | `.docs/` (+ multipágina se aplicável) | Sim |
| `qa-space` | `/qa-space` | QA front + Space DS + DS produto/`P-…` se houver + ui-gosto (geral + tipo §11) + REPORT | `.task/` | Não |
| `design-system-forge` | `/design-system-forge` | Cria: diagnóstico · manual da marca (prancha) · DS doc + tokens · Fundamentos + componentes no canvas (Pencil padrão). Modos Extrair/Criar · Q1–Q19 · GATE ACCEPT · confronto com gosto · essencial → pergunta ouro | `.docs/` + canvas | Não |
| `design-system-apply` | `/design-system-apply` | Aplica: diagnóstico das telas · A DS×gosto→OK · B varredura + espelho no canvas→OK · C correção/redesenho no canvas em loop até ALIGNED + `DIFERENCAS_PARA_DEVS.md`. Construtor = secundário; código nunca | `.docs/` + canvas | Não |

Skills de produto **leem `docs/README.md` primeiro**. Conteúdo das skills = **genérico** (qualquer produto); dado de cliente só na conversa ou em `exemplos/`.

## Quem chama quem

```text
/skill-update          → mantém o pack (sync, nova skill, path, .env)
po-techlead-scrum      → Objetivo → regra → DB → Apidog → task ClickUp
qa-space               → grava .task/; NÃO publica ClickUp (passa pro PO)
project-context-doc    → grava .docs/; publica Doc ClickUp após aprovação
design-system-forge    → diagnóstico → manual → DS + canvas (essencial) → confronto gosto → STOP; pergunta ouro
design-system-apply    → diagnóstico → A (DS×gosto)+OK → B (varredura + espelho canvas)+OK → C (loop no canvas) → ALIGNED + DIFERENCAS_PARA_DEVS
```

## Docs do repo (não são skills)

| Arquivo / pasta | Papel |
|-----------------|--------|
| `docs/` | **Constituição** (entry-point, ouro, anti-padrões, DS, git, stack). Mapa: `docs/README.md` — cada skill lê esse README primeiro |
| `AGENTS.md` | Direcionamento do agente ao abrir o repo |
| `.cursor/rules/space-cursor-skills.mdc` | Rule always-on no repo |
| `README.md` | Setup humano + tabela `.env` |
| `src/sync.ts` | Implementação do `npm run sync` (copia `skills/` **e** `docs/`) |
| `skills/po-techlead-scrum/estruturador-clickup.md` (+ espelho `skill.md` na raiz) | **Prompt ClickUp** (AI Skill Estruturador) — não é skill Cursor; colar no ClickUp após editar |
