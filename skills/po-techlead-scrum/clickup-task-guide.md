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
| **Checklist nativo** | Obrigatório na tarefa principal de cada dev (não é `- [ ]` no markdown) |

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
| Execução | Script **1 arquivo → 1 task**. Front+Back: **1 MAIN + 2 subtasks** (agente recorta 3 bodies; Back/Front com `--parent`) |

## Front+Back: 1 MAIN + 2 subtasks

O Python **não** fatia markdown. Quem recorta é o agente.

**Não** criar 3 tasks irmãs na lista. Hierarquia:

1. Criar a **MAIN** (MASTER) — task normal da lista.
2. Criar **Backend** com `--parent <id da MAIN>`.
3. Criar **Frontend** com `--parent <id da MAIN>`.

| Task | Tipo | Título | Corpo (Esteira) | Corpo (Imediatas) | Anexos |
| --- | --- | --- | --- | --- | --- |
| MAIN | Task (pai) | `{título}` | Spec completa + **passo a passo inteiro** (PBI + mermaid imagem e fonte). Ritter lê **esta**. | Spec completa **sem** PBI/Espera/Bloqueia. **Sem** checklist nativo (os checklists vivem nas subtasks). | `.md` completo + OpenAPI/DBML se houver |
| Backend | **Subtask** | `{título} — Backend` | Grid + Back + CA Back + linhas BACK do passo a passo + DDD Back + NÃO DEVE | Idem **sem** linhas PBI. **Checklist nativo Back** (itens = o que o dev tica, incl. `P-BACK-*`) | OpenAPI/DBML |
| Frontend | **Subtask** | `{título} — Frontend` | Grid + Front + CA Front + linhas FRONT + DDD Front + NÃO DEVE | Idem **sem** PBI. **Checklist nativo Front** (incl. `P-FRONT-*` só de tela que o Front **altera**) | prints se houver |

Uma camada só → um create, spec inteira (sem subtask). Imediatas: o checklist nativo vai **nessa** task pai.

Mesma lista, modo e campo Projeto nas três. Assignee: o que o PO mandou (pode diferir Back vs Front). Devolver **o link da MAIN**.

Esteira e Imediatas: o mesmo ritual de **1 MAIN + 2 subtasks**. Corpo e quebra **não** são iguais:

| | Esteira | Imediatas |
| --- | --- | --- |
| Passo a passo PBI | Sim (Ritter) | **Não** |
| Checklist nativo ClickUp | Não (Ritter vira Task) | **Sim** — na tarefa de cada dev |
| DDD | Provas; Imediatas nomeiam cada uma | Idem + prova só na camada que mudou código |

## Imediatas — checklist nativo do ClickUp

O SuperAgente **não** lê a lista Imediatas. Não existe PBI nem campo Dependência para o Ritter preencher. O dev abre a task e **tica**.

**O que é:** o módulo Checklist da task no ClickUp (`POST /task/{id}/checklist` + itens). **Não** é lista `- [ ]` no markdown da descrição.

**Onde entra (tarefa principal de cada dev):**

| Publicação | Onde criar o checklist |
| --- | --- |
| Uma task só (sem subtask Back/Front) | Na **pai** |
| Front+Back (MAIN + 2 subtasks) | **Um** checklist na subtask Backend e **um** na subtask Frontend. A MAIN **não** leva checklist |

**O que vai em cada item:** passo executável daquela camada (o que seria linha de PBI na Esteira) **e** as provas `P-*` daquela camada. Um item = uma coisa que o júnior marca.

**Proibido:**

- Checklist na MAIN quando há subtasks Back e Front
- Duplicar o mesmo checklist nas três tasks
- Inventar `P-FRONT` para superfície com **zero** alteração de Front (prova é item `P-BACK` no checklist do Back)
- Usar markdown `- [ ]` / `## 🚀 Ordem de Execução` numerada **no lugar** do checklist nativo

Script: `--checklist-name` + `--checklist-item` (repetir) no **mesmo** create da task que deve ter o checklist. Para task já criada: `--checklist-only --task-id …`.

---

## Comandos

```bash
python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file task/cms-central-ajuda.md --project BATEU --dry-run

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file task/cms-central-ajuda.md --project BATEU

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file task/cms-backend.md --project BATEU --parent 86abc123

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode imediatas --file task/hotfix.md --assignee 106175112 --project BATEU \
  --checklist-name "Execução" \
  --checklist-item "Migration + endpoint" \
  --checklist-item "Anexar P-BACK-1"

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --checklist-only --task-id 86abc123 --checklist-name "Frontend" \
  --checklist-item "Conferir modal" \
  --checklist-item "Anexar P-FRONT-1"
```
