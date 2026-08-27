# Playbook — skill-update

## Sync

```bash
cd <clone-space-cursor-skills>
# conferir .env: SKILLS_DEST_PATH (+ CLICKUP_* se for usar)
npm run sync
```

Dry-run:

```bash
npm run sync:dry
```

Após sync bem-sucedido: listar skills copiadas, path de destino, e lembrar restart do chat.

## Criar skill nova

1. Nome em **kebab-case** (`skills/minha-skill/`)
2. Criar `SKILL.md` com:

```yaml
---
name: minha-skill
description: >-
  Uma linha clara + triggers ("Use com /minha-skill, ...")
disable-model-invocation: true
---
```

3. Banner no topo (igual às outras):

```markdown
> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/minha-skill/` → **obrigatorio rodar** `npm run sync` …  
> Hub de manutenção: **`/skill-update`**. Repo: **`AGENTS.md`**.
```

4. Se a skill grava arquivos no workspace do usuário:

```markdown
## Onde gravar artefatos (`.task/` ou `.docs/`)

| Situação | O que fazer |
|----------|-------------|
| Fora de git repo | Criar a pasta e gravar ali |
| Dentro de git repo | Idem + garantir no `.gitignore` |
```

5. Atualizar:
   - [catalog.md](catalog.md)
   - `AGENTS.md` (tabela Skills)
   - `README.md` (tabela Skills)
6. `npm run sync`
7. Commit/push só se o usuário pedir

## Alterar skill existente

1. Abrir `skills/<nome>/` no **repo**
2. Editar
3. Se mudou responsabilidade no pack → [catalog.md](catalog.md)
4. `npm run sync` na máquina alvo
5. Resumo curto ao usuário

## Diagnóstico

| Sintoma | Checagem |
|---------|----------|
| Skill “não mudou” no Cursor | Rodou `npm run sync` **nesta** máquina? Restart do chat? |
| Path errado / skill some no Coders | `.env` local tem `SKILLS_DEST_PATH` certo? |
| `clickup.env` ausente | `.env` raiz tem `CLICKUP_API_TOKEN` + `CLICKUP_WORKSPACE_ID`? Sync regenera |
| Editou e perdeu mudança | Editou a **cópia**? Voltar ao repo e reaplicar |
| Arquivos da skill no git do produto | Falta `.task/` / `.docs/` no `.gitignore` |

## Comunicação padrão (respostas ao usuário)

- Manutenção: “Isso é do pack — uso `/skill-update`: editar em `skills/…` → `npm run sync`.”
- Produto (task/QA/doc): apontar a skill de domínio; se perguntarem de sync/path, redirecionar para esta hub.
