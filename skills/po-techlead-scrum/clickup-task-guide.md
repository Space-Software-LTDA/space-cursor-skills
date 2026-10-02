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
| Status | `demanda` (`CLICKUP_STATUS_ESTEIRA_PBI`); **vai para a sprint já → `detalhar`** (`--status detalhar`) — conferir na lista se o workspace renomear |
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
| Execução | Script **1 arquivo → 1 task**. Estrutura conforme a lista (seção abaixo) |

## Estrutura no ClickUp (regra por lista)

| | **Esteira** | **Imediatas** |
| --- | --- | --- |
| Subtarefa | **PODE** — só quando precisar | **JAMAIS** |
| Front+Back | **1 task** com a spec completa (Backend e Frontend já separados por seção e no passo a passo; o Ritter vira PBI/Task). Subtarefa `[BACK]`/`[FRONT]` só se precisar | **2 tasks separadas** `[BACKEND] …` e `[FRONTEND] …`, **vinculadas** (linked task, `--link`), cada uma com seu checklist nativo |
| Várias entregas (sprint) | **1 MAIN da sprint** + cada entrega como **subtask** da MAIN (ver abaixo) | Uma task (ou par vinculado) por entrega, sem pai |
| Status inicial | `demanda` (`CLICKUP_STATUS_ESTEIRA_PBI`). **Vai para a sprint já → `detalhar`** (`--status detalhar`) na MAIN **e** em todas as subtasks | Padrão da lista |

**Não duplicar descrição.** Cada informação mora em **um** lugar: a MAIN da sprint não repete a spec das entregas; uma subtarefa não copia o corpo da task pai. Se precisar de subtarefa, o corpo dela é curto (escopo em 1–3 linhas + “leia a task pai: seções Backend, CA Backend e DDD Backend”), sem colar as seções.

Títulos: prefixo de camada no **início** (`[BACK]`/`[FRONT]` na Esteira; `[BACKEND]`/`[FRONTEND]` no par vinculado das Imediatas). Não usar sufixo `— Backend` / `— Frontend`: na listagem o ClickUp corta o fim do título.

### Esteira — sprint com várias entregas

1. Criar a **MAIN da sprint** (task normal da lista): objetivo da sprint, escopo (entra / fora), tabela das entregas com ordem e dependências entre elas (+ diagrama), decisões e regras que valem para **todas** as entregas, links (protótipo, contrato, repositórios). **Não** repete regra que está dentro de uma entrega.
2. Criar **cada entrega** com `--parent <id da MAIN>`: spec completa da entrega (grid, contexto, Backend, Frontend, CA, passo a passo com mermaid, DDD, NÃO DEVE). Sem `--layer`.
3. Dentro de uma entrega, subtarefa **só se precisar** (o ClickUp aceita subtarefa de subtarefa) — e com corpo curto, sem duplicar.
4. Mesma lista, campo Projeto e status em todas. Devolver o link da MAIN + a lista das entregas.

Para transformar tasks já publicadas em subtasks de uma MAIN nova, **mover** (`PUT /task/{id}` com `parent`), não recriar — mantém ID, anexos e histórico.

### Imediatas — Front+Back

1. Criar `[BACKEND] {título}`: `--mode imediatas --layer back` + checklist nativo do Back.
2. Criar `[FRONTEND] {título}`: `--mode imediatas --layer front --link <id da [BACKEND]>` + checklist nativo do Front.
3. Corpo de cada uma: grid + contexto + **a sua camada** + CA da camada + DDD da camada + NÃO DEVE. Contexto comum curto; o resto não se repete entre as duas.
4. O script **recusa** `--parent` no modo Imediatas.

| | Esteira | Imediatas |
| --- | --- | --- |
| Passo a passo PBI | Sim (Ritter) | **Não** |
| Checklist nativo ClickUp | Não (Ritter vira Task) | **Sim** — na task de cada dev |
| DDD | Provas; Imediatas nomeiam cada uma | Idem + prova só na camada que mudou código |

## Imediatas — checklist nativo do ClickUp

O SuperAgente **não** lê a lista Imediatas. Não existe PBI nem campo Dependência para o Ritter preencher. O dev abre a task e **tica**.

**O que é:** o módulo Checklist da task no ClickUp (`POST /task/{id}/checklist` + itens). **Não** é lista `- [ ]` no markdown da descrição.

**Onde entra (tarefa principal de cada dev):**

| Publicação | Onde criar o checklist |
| --- | --- |
| Uma camada | Na task |
| Front+Back (par vinculado) | **Um** checklist na `[BACKEND]` e **um** na `[FRONTEND]` |

**O que vai em cada item:** passo executável daquela camada (o que seria linha de PBI na Esteira) **e** as provas `P-*` daquela camada. Um item = uma coisa que o júnior marca.

**Proibido:**

- Subtarefa nas Imediatas (Front+Back = duas tasks separadas e vinculadas)
- Duplicar o mesmo checklist nas duas tasks
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
  --attach .task/proj/assets/feature/diagram-a.png \
  --attach .task/proj/assets/feature/01-listagem.png

# Esteira, sprint indo já para a sprint: MAIN + entregas como subtask
python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file .task/proj/sprint.md --project {PROJETO} --status detalhar
python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode esteira --file .task/proj/tasks/01-entrega.md --project {PROJETO} \
  --status detalhar --parent 86abc123

# Imediatas Front+Back: duas tasks separadas e vinculadas (nunca subtarefa)
python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode imediatas --file task/hotfix-back.md --assignee 106175112 --project {PROJETO} \
  --layer back --checklist-name "Execução" \
  --checklist-item "Migration + endpoint" \
  --checklist-item "Anexar P-BACK-1"
python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --mode imediatas --file task/hotfix-front.md --assignee 106175113 --project {PROJETO} \
  --layer front --link <id da [BACKEND]> --checklist-name "Execução" \
  --checklist-item "Anexar P-FRONT-1"

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --checklist-only --task-id 86abc123 --checklist-name "Frontend" \
  --checklist-item "Conferir modal" \
  --checklist-item "Anexar P-FRONT-1"

python ~/.cursor/skills/po-techlead-scrum/scripts/clickup_create_task.py \
  --update-description --task-id 86abc123 --file .task/proj/feature.md --no-banner
```

Imagens **não** precisam de push em repositório: o PNG fica em `.task/{projeto}/assets/{task-slug}/` e vai direto como anexo. Imagem referenciada no `.md` por caminho relativo (`assets/{task-slug}/01-listagem.png`) é resolvida a partir da pasta do `.md` e anexada sozinha; `--attach <png>` também funciona (casa pelo nome do arquivo). O script:

1. Cria a task (`--parent` se for subtask — só Esteira; `--status` se não for o padrão)
2. Anexa os arquivos
3. Reescreve cada imagem (caminho local, `mermaid.ink` ou `raw.githubusercontent`) para `![](attachment-url)` e grava em **`markdown_content`** (não `markdown_description`). Imagem local não encontrada só gera `WARN` — conferir o publicado
4. Atualiza a descrição (`PUT`)
5. Imediatas: cria o checklist nativo se `--checklist-item` foi passado

Blocos ` ```mermaid ` (fonte para o Ritter no passo a passo da Esteira) **não** são reescritos.

---

## Estruturador de Tarefas (ClickUp AI Skill)

Prompt versionado (colar na AI Skill do ClickUp): **[estruturador-clickup.md](estruturador-clickup.md)**. Espelho na raiz do repo: `skill.md`.

Não é skill Cursor — reorganiza task bruta **dentro** do ClickUp. Prefixo de subtarefas alinhado a este guia: `[BACK]` / `[FRONT]` no início (não `[BACKEND]` / `[FRONTEND]`).

Banners `<banner>`: OK no Estruturador (UI ClickUp). A API deste script usa blockquote (`>`) — ver seção abaixo.

## Imagens inline no ClickUp (crítico)

Alinhado ao **Estruturador de Tarefas** ([estruturador-clickup.md](estruturador-clickup.md)). O ClickUp só renderiza imagem inline com markdown apontando para attachment **da própria task**.

| Fonte no `.md` local | No corpo ClickUp |
| --- | --- |
| `![](assets/{task-slug}/01-tela.png)` (relativo ao `.md`) | **Padrão** — script anexa e reescreve |
| `![](raw.githubusercontent.com/…/space-assets/…)` | Legado — reescreve se a URL existir; quebra se o push não aconteceu |
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

## Destaque no ClickUp (aviso de IA / anexos)

A API **não** cria Banner nativo. Tag `<banner …>` no `markdown_content` aparece **crua** na UI. O que a API pinta é o **blockquote** (`>`). Ver [evidencias-dod.md](evidencias-dod.md).

O script **não** injeta `<banner>`. Mantém (ou garante) o quote do `.md` local:

```markdown
> ⚠️ Esta tarefa foi estruturada com auxílio de Inteligência Artificial …
```

Se houver imagens, acrescenta um segundo quote:

```markdown
> 📎 Esta tarefa contém imagens e/ou anexos que fazem parte do requisito e devem ser analisados com atenção.
```

`--no-banner` desliga esse acréscimo (não mexe no quote de IA que já está no arquivo).

Opcional **depois** de publicar: no editor, selecionar o quote → Turn into → Banner. Não fazer isso via API.
