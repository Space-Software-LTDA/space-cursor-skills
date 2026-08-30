# ClickUp — criar task a partir do markdown local

Publica a descrição gerada pela skill **po-techlead-scrum** como **task** no ClickUp (não Doc).

Espelha o gate do `project-context-doc`: **só após aprovação local**.

## Onde editar esta skill (obrigatório)

| O quê | Onde |
| --- | --- |
| **Fonte versionada** | Repo [Space-Software-LTDA/space-cursor-skills](https://github.com/Space-Software-LTDA/space-cursor-skills) → `skills/po-techlead-scrum/` |
| **Clone típico** | `G:\space\Documents\space\space-cursor-skills` (ou equivalente na máquina) |
| **Destino Cursor** | `SKILLS_DEST_PATH` / `po-techlead-scrum` (path do `.env` **desta** máquina — PC ≠ Coders) |
| **Credenciais ClickUp** | `.env` na **raiz do repo** `space-cursor-skills` (compartilhado com `project-context-doc`) |
| **Credenciais Apidog** | Mesmo `.env` (`APIDOG_*`) — sync gera `apidog.env` nesta skill |

**Nunca** editar só em `~/.cursor/skills/...` e esquecer o repo — a próxima `npm run sync` **sobrescreve** com o que está em `skills/`.

```bash
cd /path/to/space-cursor-skills
# edite skills/po-techlead-scrum/...
git add skills/po-techlead-scrum
git commit -m "..."
git push
npm run sync          # copia skills/ → SKILLS_DEST_PATH + gera clickup.env
```

O sync gera `clickup.env` em **project-context-doc** e **po-techlead-scrum** a partir do `.env` do repo.  
O sync gera `apidog.env` em **po-techlead-scrum**. Contrato de rotas: [apidog.md](apidog.md).

## Listas

| Modo no chat | Lista | List ID (env) |
| --- | --- | --- |
| SuperAgente / Scrum | [Esteira PBI e Tasks](https://app.clickup.com/90131082033/v/li/901326818223) | `CLICKUP_LIST_ESTEIRA` |
| Direto pro dev | [Tarefas IMEDIATAS](https://app.clickup.com/90131082033/v/l/6-901326981587-1) | `CLICKUP_LIST_IMEDIATAS` |

Workspace: `90131082033` (SPACE DEV).

## O que a API aplica em cada modo

### Esteira (Scrum)

| Campo | Valor |
| --- | --- |
| **Tipo** | **Task padrão** (sem `custom_item_id` — **não** usar `3- PBI`) |
| Status | `pbi (bugs) e tasks` (`CLICKUP_STATUS_ESTEIRA_PBI`) |
| Assignee | Ricardo Paes por default (`CLICKUP_ASSIGNEE_RICARDO`) — **ainda perguntar no onboard** |
| Campo **Projeto** | Dropdown (`CLICKUP_CF_PROJETO`) — BATEU → `BateuBET \| Dashbaord` |
| Anexo | `.md` da task |

### Imediatas

| Campo | Valor |
| --- | --- |
| Tipo custom | `0- IMEDIATA` (`CLICKUP_CUSTOM_TYPE_IMEDIATA=1016`) |
| Assignee | **Obrigatório perguntar** no onboard |
| Campo **Projeto** | Recomendado (`--project BATEU`) |
| Anexo | `.md` da task |

⚠️ “TAG do projeto” = custom field **Projeto**, não Tag nativa do ClickUp.

## Credenciais

Fonte única: **`.env` do repo `space-cursor-skills`**.

Ver `.env.example` na raiz do repo (token, workspace, listas, assignee, campo Projeto).

Após `npm run sync`, cada skill recebe `clickup.env` gerado (gitignored).

## Gate

| Passo | Gate |
| --- | --- |
| Task local pronta | `task/*.md` escrito |
| Aprovação | PO: **“pode publicar no ClickUp”** |
| Confirmar lista | Esteira vs Imediatas |
| Onboard | Responsável + Projeto (BATEU etc.) |
| Execução | `scripts/clickup_create_task.py` → link |

## Comandos

```bash
python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file task/cms-central-ajuda.md --project BATEU --dry-run

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file task/cms-central-ajuda.md --project BATEU

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode imediatas --file task/hotfix.md --assignee 106175112 --project BATEU
```
