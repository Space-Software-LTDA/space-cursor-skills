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
6. Se a skill de produto usar a constituição: ponteiro para `../docs/README.md` (não copiar o texto)
7. `npm run sync`
8. Commit/push só se o usuário pedir

## Alterar skill existente

1. Abrir `skills/<nome>/` no **repo**
2. Editar
3. Se mudou responsabilidade no pack → [catalog.md](catalog.md)
4. `npm run sync` na máquina alvo
5. Resumo curto ao usuário

## Atualizar constituição

1. Ler `docs/README.md` (mapa skill → arquivo → por quê / como)
2. Editar o arquivo temático em `docs/` (`entry-point.md`, `design-system.md`, …)
3. Se mudou **quem lê o quê** ou o objetivo PO vs QA: atualizar **só** o `docs/README.md` — não resumir o conteúdo nas skills
4. Conferir que os `SKILL.md` de produto ainda apontam `../docs/README.md` primeiro
5. `npm run sync` (copia `docs/` → `{SKILLS_DEST_PATH}/docs/`)
6. Avisar restart do chat

**Proibido:** duplicar GO/AP/DS dentro de `po-techlead-scrum` ou `qa-space`. Uma fonte em `docs/`.

## Diagnóstico

| Sintoma | Checagem |
|---------|----------|
| Skill “não mudou” no Cursor | Rodou `npm run sync` **nesta** máquina? Restart do chat? |
| Path errado / skill some no Coders | `.env` local tem `SKILLS_DEST_PATH` certo? |
| `clickup.env` ausente | `.env` raiz tem `CLICKUP_API_TOKEN` + `CLICKUP_WORKSPACE_ID`? Sync regenera |
| Editou e perdeu mudança | Editou a **cópia**? Voltar ao repo e reaplicar |
| Constituição “não apareceu” no Cursor | Sync copiou `docs/`? Existe `{SKILLS_DEST_PATH}/docs/README.md`? |

## Comunicação padrão (respostas ao usuário)

- Manutenção: “Isso é do pack — uso `/skill-update`: editar em `skills/…` ou `docs/` → `npm run sync`.”
- Produto (task/QA/doc): apontar a skill de domínio **e** `docs/README.md` (PO ≠ QA); se perguntarem de sync/path, redirecionar para esta hub.
