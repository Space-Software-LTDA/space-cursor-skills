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
| Anexo | `.md` da task + PNGs (diagramas/prints); o script reescreve imagens para attachment |

### Imediatas

| Campo | Valor |
| --- | --- |
| Tipo custom | `0- IMEDIATA` (`CLICKUP_CUSTOM_TYPE_IMEDIATA=1016`) |
| Assignee | **Obrigatório perguntar** no onboard |
| Campo **Projeto** | Recomendado (`--project BATEU`) |
| Anexo | `.md` da task + PNGs; o script reescreve imagens para attachment |
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
2. Criar **Backend** com `--parent <id da MAIN> --layer back`.
3. Criar **Frontend** com `--parent <id da MAIN> --layer front`.

`--parent` **exige** `--layer`. Não usar sufixo `— Backend` / `— Frontend` no lugar do prefixo: na listagem o ClickUp corta o fim do título; `[BACK]` / `[FRONT]` no começo é o que dá para ler ao abrir.

| Task | Tipo | Título | Corpo (Esteira) | Corpo (Imediatas) | Anexos |
| --- | --- | --- | --- | --- | --- |
| MAIN | Task (pai) | `{título}` — **sem** `[BACK]`/`[FRONT]` | Spec completa + **passo a passo inteiro** (PBI + mermaid imagem e fonte). Ritter lê **esta**. | Spec completa **sem** PBI/Espera/Bloqueia. **Sem** checklist nativo (os checklists vivem nas subtasks). | `.md` completo + OpenAPI/DBML + PNGs de diagramas |
| Backend | **Subtask** | `[BACK] {título}` — prefixo no **início**, mesmo se o título ficar longo. `--layer back` | Grid + Back + CA Back + linhas BACK do passo a passo + DDD Back + NÃO DEVE | Idem **sem** linhas PBI. **Checklist nativo Back** (itens = o que o dev tica, incl. `P-BACK-*`) | OpenAPI/DBML |
| Frontend | **Subtask** | `[FRONT] {título}` — prefixo no **início**, mesmo se o título ficar longo. `--layer front` | Grid + Front + CA Front + linhas FRONT + DDD Front + NÃO DEVE | Idem **sem** PBI. **Checklist nativo Front** (incl. `P-FRONT-*` só de tela que o Front **altera**) | prints (PNG anexados) |

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
  --mode esteira --file .task/proj/feature.md --project ONESET \
  --attach .task/proj/feature.md \
  --attach .task/proj/attachments/openapi.yaml \
  --attach /path/to/space-assets/proj/feature/diagram-a.png \
  --attach /path/to/space-assets/proj/feature/01-listagem.png

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file task/cms-backend.md --project BATEU --parent 86abc123 --layer back

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode imediatas --file task/hotfix.md --assignee 106175112 --project BATEU \
  --checklist-name "Execução" \
  --checklist-item "Migration + endpoint" \
  --checklist-item "Anexar P-BACK-1"

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --checklist-only --task-id 86abc123 --checklist-name "Frontend" \
  --checklist-item "Conferir modal" \
  --checklist-item "Anexar P-FRONT-1"

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --update-description --task-id 86abc123 --file .task/proj/feature.md --no-banner
```

Anexe **todos** os PNGs (diagramas + prints) junto com o `.md` / OpenAPI / DBML. O script:

1. Cria a task (`--parent` se for subtask)
2. Anexa os arquivos
3. Reescreve `![](mermaid.ink|raw.githubusercontent)` para `![](attachment-url)` e grava em **`markdown_content`** (não `markdown_description`)
4. Atualiza a descrição (`PUT`)
5. Imediatas: cria o checklist nativo se `--checklist-item` foi passado

Blocos ` ```mermaid ` (fonte para o Ritter no passo a passo da Esteira) **não** são reescritos.

---

## Imagens inline no ClickUp (crítico)

Alinhado ao **Estruturador de Tarefas**. O ClickUp só renderiza imagem inline com markdown apontando para attachment **da própria task**.

| Fonte no `.md` local | No corpo ClickUp |
| --- | --- |
| `![](raw.githubusercontent.com/…/space-assets/…)` | **Reescrever** para attachment |
| `![](mermaid.ink/…)` | Baixar PNG → anexar → attachment URL |
| `![](https://….p.clickup-attachments.com/…)` | Já ok |

Sintaxe (editor, Estruturador **e** API):

```markdown
![](https://t….p.clickup-attachments.com/t…/uuid/arquivo.png)
```

Linha em branco **antes e depois**. Alt vazio — o Estruturador usa exatamente `![](url)`.

O script **não** injeta `\n\n` extra em volta da imagem (isso abria um vão enorme entre `**Print:**` e o print). A linha em branco do `.md` local já basta.

### Campo da API (não confundir)

| Campo | Papel |
| --- | --- |
| **`markdown_content`** | **Escrita** (POST create / PUT update). É o que o ClickUp documenta e o que vira bloco nativo de imagem. |
| **`markdown_description`** | **Leitura** (`GET ?include_markdown_description=true`). **Não** gravar neste campo. |

O script antigo gravava `markdown_description` + `<img>` / `<p><img>`. A UI mostra as tags como texto. `![]()` nesse campo errado não vira imagem.

Detalhes: [diagrams.md](diagrams.md), [screenshots.md](screenshots.md).

---

## Banners ClickUp (opcional, recomendado)

No corpo publicado, o aviso de IA pode usar banner nativo (sem emoji duplicado no texto):

```markdown
<banner background-color="yellow" icon="⚠️">Esta tarefa foi estruturada com auxílio de Inteligência Artificial com base nas informações fornecidas. Embora o conteúdo tenha sido organizado para facilitar o entendimento, podem existir interpretações incorretas ou incompletas. Em caso de dúvida, valide com o solicitante antes de iniciar o desenvolvimento.</banner>
```

Se houver imagens/anexos relevantes:

```markdown
<banner background-color="blue" icon="📎">Esta tarefa contém imagens e/ou anexos que fazem parte do requisito e devem ser analisados com atenção.</banner>
```

O script converte o blockquote `> ⚠️ Esta tarefa foi estruturada…` do markdown local para o banner amarelo na publicação. `--no-banner` desliga isso.
