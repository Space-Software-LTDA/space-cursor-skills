# space-cursor-skills

Repositório central das **skills pessoais** do Cursor, sincronizadas entre PCs e servidor.

## Setup (em qualquer máquina)

```bash
git clone git@github.com:Space-Software-LTDA/space-cursor-skills.git
cd space-cursor-skills
cp .env.example .env
# Edite .env: SKILLS_DEST_PATH + CLICKUP_* + APIDOG_* (tokens, workspace, listas, projeto Apidog)
npm install
npm run sync
```

## Uso diário

```bash
npm run sync          # git pull + copia skills/ e docs/ → SKILLS_DEST_PATH + gera clickup.env / apidog.env
npm run sync:dry      # simula sem alterar nada
```

## .env (por máquina)

Cada ambiente (PC, Coders, etc.) tem o **próprio** `.env`. Destino e credenciais vêm daí.

Uma única fonte de credenciais ClickUp para **project-context-doc** e **po-techlead-scrum** **nessa máquina**. Apidog (`APIDOG_*`) alimenta `po-techlead-scrum`.

| Variável | Descrição |
|----------|-----------|
| `SKILLS_DEST_PATH` | Onde o Cursor **desta máquina** lê skills. **Obrigatório no Coders** (path ≠ home). Vazio → fallback `$HOME/.cursor/skills` |
| `CLICKUP_API_TOKEN` | Personal token ClickUp |
| `CLICKUP_WORKSPACE_ID` | Workspace (SPACE DEV = `90131082033`) |
| `CLICKUP_LIST_ESTEIRA` / `CLICKUP_LIST_IMEDIATAS` | List IDs (criar tasks) |
| `CLICKUP_ASSIGNEE_RICARDO` | Default assignee Esteira |
| `CLICKUP_CUSTOM_TYPE_IMEDIATA` | Tipo custom Imediatas |
| `CLICKUP_STATUS_ESTEIRA_PBI` | Status na Esteira |
| `CLICKUP_CF_PROJETO*` | Campo dropdown Projeto no ClickUp (workspace Space) |
| `APIDOG_ACCESS_TOKEN` | Token OpenAPI Apidog da **conta** (`adgp_…`) — [docs](https://openapi.apidog.io/) |
| `APIDOG_API_BASE` / `APIDOG_API_VERSION` | Default `https://api.apidog.com` / `2024-03-28` |
| `GIT_PULL` | `true` (default) — pull antes de copiar |

Project ID e moduleId Apidog **não** entram no `.env` — o agente pergunta por produto.

## Estrutura

```
space-cursor-skills/
├── docs/                   ← constituição (README = mapa PO vs QA vs contexto)
├── skills/                 ← fonte versionada
│   ├── skill-update/       ← hub /skill-update
│   ├── po-techlead-scrum/
│   ├── qa-space/
│   └── project-context-doc/
├── AGENTS.md               ← direcionamento do agente no repo
├── src/
│   └── sync.ts             ← npm run sync
├── .env.example
└── package.json
```

## O que o sync faz

1. Detecta Windows / Linux / macOS
2. `git pull` (se configurado)
3. Copia `skills/` → `SKILLS_DEST_PATH`
4. Copia `docs/` → `SKILLS_DEST_PATH/docs/`
5. Escreve `00-COPIA-LEIA-ME.md` em cada skill do destino **e** em `docs/` (**nao edite a copia**)
6. Gera `clickup.env` em `project-context-doc/` **e** `po-techlead-scrum/` a partir do `.env`
7. Gera `apidog.env` em `po-techlead-scrum/` a partir do `.env`

Cada `SKILL.md` tambem tem um aviso **COPIA** no topo.


## Skills

| Skill | Uso |
|-------|-----|
| `skill-update` | **Hub** do pack (`/skill-update`): sync, catálogo, nova/alterar skill, PC vs Coders |
| `po-techlead-scrum` | Tasks ClickUp (Esteira / Imediatas) em tom professor — pipeline Objetivo → regra → DB → Apidog → task |
| `qa-space` | QA / design system — constituição via `docs/README.md` (audita o feito; lê DS inteiro) |
| `project-context-doc` | Doc de contexto + sync Docs ClickUp — constituição via `docs/README.md` (G-xxx) |

Constituição (não é skill): pasta [`docs/`](docs/). **Toda skill de produto lê [`docs/README.md`](docs/README.md) primeiro** — PO, QA e contexto não usam os arquivos do mesmo jeito.

## O que NÃO entra no repo

| Excluir | Motivo |
|---------|--------|
| `.env` | Credenciais locais |
| `clickup.env` | Gerado pelo sync |
| `apidog.env` | Gerado pelo sync |
| `node_modules/` | npm |
| Skills de plugin | Gerenciadas pelo Cursor |

## Regra de ouro para o agente

Editar skills **neste repo** (`skills/...`), commit/push, depois `npm run sync` **na máquina alvo**.  
Não tratar a pasta de destino (`SKILLS_DEST_PATH`) como fonte da verdade — e não assumir o mesmo path em PC e Coders.

**Cursor:** leia [AGENTS.md](AGENTS.md) e a rule em `.cursor/rules/space-cursor-skills.mdc`. Cada `SKILL.md` e o `00-COPIA-LEIA-ME.md` no destino repetem o fluxo.
