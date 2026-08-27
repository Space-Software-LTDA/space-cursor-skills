# Catálogo das skills Space

Fonte: repo `space-cursor-skills` → pasta `skills/`.  
Destino no Cursor: `SKILLS_DEST_PATH` (por máquina). Hub: **`/skill-update`**.

Atualizar **este arquivo** sempre que criar, renomear ou remover uma skill.

| Skill (pasta) | Trigger | Função | Artefatos locais | ClickUp env |
|---------------|---------|--------|------------------|-------------|
| `skill-update` | `/skill-update` | Hub: sync, manutenção, catálogo, regras transversais | N/A (só docs da skill) | Não |
| `po-techlead-scrum` | anexar / PO-task | Tasks ClickUp (Esteira / Imediatas), tom professor | `.task/` | Sim (`clickup.env` via sync) |
| `project-context-doc` | anexar / contexto produto | Doc de contexto + Docs ClickUp | `.docs/` (+ multipágina se aplicável) | Sim |
| `qa-space` | `/qa-space` | QA front + Design System + REPORT | `.task/` | Não |

## Quem chama quem

```text
/skill-update          → mantém o pack (sync, nova skill, path, .env)
po-techlead-scrum      → gera task; após QA pode consumir .task/ do qa-space
qa-space               → grava .task/; NÃO publica ClickUp (passa pro PO)
project-context-doc    → grava .docs/; publica Doc ClickUp após aprovação
```

## Docs do repo (não são skills)

| Arquivo | Papel |
|---------|--------|
| `AGENTS.md` | Direcionamento do agente ao abrir o repo |
| `.cursor/rules/space-cursor-skills.mdc` | Rule always-on no repo |
| `README.md` | Setup humano + tabela `.env` |
| `src/sync.ts` | Implementação do `npm run sync` |
