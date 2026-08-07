# space-cursor-skills

Repositório central das **skills pessoais** do Cursor, sincronizadas entre PCs e servidor.

## Setup (em qualquer máquina)

```bash
git clone git@github.com:SEU_USER/space-cursor-skills.git
cd space-cursor-skills
cp .env.example .env
# Edite .env com SKILLS_DEST_PATH e credenciais ClickUp
npm install
npm run sync
```

## Uso diário

```bash
npm run sync          # git pull + copia skills/ → ~/.cursor/skills
npm run sync:dry      # simula sem alterar nada
```

## .env

| Variável | Descrição |
|----------|-----------|
| `SKILLS_DEST_PATH` | Onde o Cursor lê skills (default: `~/.cursor/skills`) |
| `CLICKUP_API_TOKEN` | Token ClickUp (skill project-context-doc) |
| `CLICKUP_WORKSPACE_ID` | Workspace ID ClickUp |
| `GIT_PULL` | `true` (default) — faz pull antes de copiar |

## Estrutura

```
space-cursor-skills/
├── skills/              ← fonte das skills (versionada no Git)
│   ├── po-techlead-scrum/
│   ├── qa-space/
│   └── project-context-doc/
├── src/
│   └── sync.ts          ← script de sincronização
├── .env.example
└── package.json
```

## O que o sync faz

1. Detecta Windows / Linux / macOS
2. `git pull` (se configurado)
3. Copia `skills/` → `SKILLS_DEST_PATH` (cria pasta se não existir)
4. Gera `clickup.env` em `project-context-doc/` a partir do `.env`

## Skills consolidadas

| Skill | Arquivos |
|-------|----------|
| `po-techlead-scrum` | SKILL.md, templates, diagrams, super-agente-clickup, screenshots.md, script |
| `qa-space` | SKILL.md, reference.md, design-system.md |
| `project-context-doc` | SKILL.md + templates/guias + scripts Python |

## O que NÃO entra no repo

| Excluir | Motivo |
|---------|--------|
| `.env` | Credenciais locais |
| `clickup.env` | Gerado pelo sync |
| `skills-cursor/` | Interno do Cursor |
| Skills de plugin | Gerenciadas pelo Cursor |
