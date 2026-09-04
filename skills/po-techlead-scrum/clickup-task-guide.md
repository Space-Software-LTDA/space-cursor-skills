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
| Task local pronta | **Um** `.task/{projeto}/{slug}.md` |
| Aprovação | PO: **“pode publicar no ClickUp”** |
| Confirmar lista | Esteira vs Imediatas |
| Onboard | Responsável + Projeto |
| Execução | Script **1 arquivo → 1 task**. Front+Back: agente recorta 3 bodies e roda o script **3 vezes** |

## Front+Back: três tasks no ClickUp

O Python **não** fatia markdown. Quem recorta é o agente.

| Task | Título | Corpo | Anexos |
| --- | --- | --- | --- |
| MASTER | `{título}` | Aviso IA, grid, contexto, objetivo, **passo a passo inteiro** (tabelas + mermaid imagem e fonte), REGRAS DE DDD, observações curtas, **NÃO DEVE** (último bloco). Ritter lê **esta**. | `.md` completo + OpenAPI/DBML se houver |
| Backend | `{título} — Backend` | Grid + alterações Back + CA Back + linhas `BACK` do passo a passo (Espera/Bloqueia intactos) + DDD (prova Back + paralelos) + **NÃO DEVE** | OpenAPI/DBML |
| Frontend | `{título} — Frontend` | Grid + alterações Front + CA Front + linhas `FRONT` + DDD (vídeo HML + paralelos de UI) + **NÃO DEVE** | prints se houver |

Uma camada só → um create, spec inteira.

Mesma lista, modo, assignee e campo Projeto nas três. Devolver **3 links**.

Esteira e Imediatas: o mesmo ritual. Imediatas: DDD com cada prova nomeada.

## Comandos

```bash
python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file task/cms-central-ajuda.md --project BATEU --dry-run

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file task/cms-central-ajuda.md --project BATEU

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode imediatas --file task/hotfix.md --assignee 106175112 --project BATEU
```
