# po-techlead-scrum — índice da skill

Skill para PO / Tech Lead / Scrum Master gerar **tasks ClickUp** em tom professor.

## Fluxo do agente (ordem)

1. Confirmar projeto, modo de entrega, **responsável** e camadas **no chat** (não na task)
2. **Onde gravar:** sempre `.task/` — fora de repo: criar `.task/`; dentro de repo: `.task/` + garantir no **`.gitignore`** (`.task/`, `.playwright-capture/`, `.skill/`)
3. [lovable-vs-local.md](lovable-vs-local.md) — matriz lacunas (se protótipo ou UI)
4. [playwright-capture.md](playwright-capture.md) — prints → space-assets (se Front)
5. [decomposicao-tom-professor.md](decomposicao-tom-professor.md) — **1 bloco por unidade mínima** (GLOBAL)
6. Salvar em `.task/{projeto}/{task-slug}.md`
7. Checklist em [SKILL.md](SKILL.md)
8. Após PO aprovar → [clickup-task-guide.md](clickup-task-guide.md) (`clickup_create_task.py`)

**Manutenção:** editar em [space-cursor-skills](https://github.com/Space-Software-LTDA/space-cursor-skills) (`skills/po-techlead-scrum/`) → `git push` → `npm run sync`. ENV ClickUp fica no `.env` da raiz do repo (compartilhado).

## Arquivos

| Arquivo | Escopo | Genérico? |
| --- | --- | --- |
| [SKILL.md](SKILL.md) | Regras principais, checklist | ✅ |
| [decomposicao-tom-professor.md](decomposicao-tom-professor.md) | Tom professor GLOBAL (tela/aba/KPI/endpoint) | ✅ |
| [templates.md](templates.md) | Template markdown da task | ✅ |
| [lovable-vs-local.md](lovable-vs-local.md) | Protótipo × código local | ✅ |
| [screenshots.md](screenshots.md) | space-assets, legendas, tema | ✅ |
| [playwright-capture.md](playwright-capture.md) | Scripts Playwright | ✅ |
| [diagrams.md](diagrams.md) | mermaid.ink | ✅ |
| [super-agente-clickup.md](super-agente-clickup.md) | Calibragem SuperAgente | ✅ |
| [clickup-task-guide.md](clickup-task-guide.md) | Publicar task via API + onde editar/sync | ✅ |
| [clickup.env.example](clickup.env.example) | Keys (geradas no sync a partir do `.env` do repo) | ✅ |
| [exemplos/](exemplos/) | Casos concretos por projeto | 📎 referência |

## Regras transversais (sempre)

- **Decomposição GLOBAL** — nunca 1 parágrafo por módulo
- **Protótipo ≠ implementação literal** — layout sim, tema/cores validar no repo
- **Back crítico** flexibiliza schema — **não** flexibiliza didática
- **Exemplos de projeto** ficam em `exemplos/` — não copiar ONESET/BATEU para regras globais

## Scripts

| Path | Uso |
| --- | --- |
| `scripts/playwright-capture/` | Genérico — copiar para `.playwright-capture/` do projeto |
| `scripts/render-mermaid.sh` | Diagramas para task |
| `scripts/clickup_create_task.py` | Criar task no ClickUp (Esteira / Imediatas) + anexos |
| `exemplos/*/playwright/` | Configs específicas de projeto (opcional) |
