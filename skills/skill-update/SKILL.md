---
name: skill-update
description: >-
  Hub central das skills Space (space-cursor-skills): sync, destino por ambiente
  (SKILLS_DEST_PATH / PC vs Coders), criar ou alterar skills, aviso de COPIA,
  .env ClickUp, catalogo e comunicacao padrao entre skills. Use com /skill-update,
  "atualizar skill", "sync skills", "nova skill", "onde editar skill" ou quando
  o usuario falar de manutencao do pack de skills do Cursor.
disable-model-invocation: true
---

# Skill Update — hub das skills Space

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/skill-update/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo). Sem Sync a copia nao atualiza.  
> Ver `00-COPIA-LEIA-ME.md`. Fluxo completo do repo: **`AGENTS.md`** na raiz do `space-cursor-skills`.

**Trigger:** `/skill-update`  
**Sempre responder em português.**

## Papel

Esta skill é o **ponto único de verdade operacional** do pack de skills:

- Onde editar (repo vs cópia)
- Como publicar mudanças (`npm run sync`)
- Destino por ambiente (`.env` / Coders)
- Catálogo do que existe e para que serve
- Como criar / alterar / deprecar uma skill
- Regras transversais (`.task/`, `.docs/`, gitignore, idioma)

Quando o usuário falar de **manutenção de skill**, **sync**, **nova skill** ou **“como funciona o pack”**, usar **esta** skill — não reinventar o fluxo em cada skill de produto.

## Wizard (perguntar se não estiver claro)

1. **Ação:** sync | alterar skill existente | criar skill nova | diagnosticar (cópia desatualizada / path errado) | explicar catálogo
2. **Skill alvo** (se alterar/criar): nome da pasta `skills/<nome>/`
3. **Máquina alvo do Sync:** PC local | Coders | ambas (lembrar: cada uma tem seu `.env`)

## Fonte da verdade

| Item | Onde |
|------|------|
| Repo | [Space-Software-LTDA/space-cursor-skills](https://github.com/Space-Software-LTDA/space-cursor-skills) |
| Clone típico (PC) | `G:\space\Documents\space\space-cursor-skills` (ou path do usuário) |
| Skills versionadas | `skills/<nome>/` **neste repo** |
| Destino Cursor | `SKILLS_DEST_PATH` no `.env` **da máquina** (não hardcodar) |
| Direcionamento agente no repo | `AGENTS.md` + `.cursor/rules/space-cursor-skills.mdc` |
| Credenciais ClickUp | `.env` na **raiz** do repo (sync gera `clickup.env` nas skills que usam) |

**Nunca** editar só a pasta de destino e considerar pronto.

## Comando Sync (obrigatório após mudança)

Na raiz do clone, **na máquina onde o Cursor lê as skills**:

```bash
npm run sync
# ou
npm run sync:dry
```

O Sync: `git pull` (se ligado) → copia `skills/` → destino → carimba `00-COPIA-LEIA-ME.md` → gera `clickup.env` onde couber.

Sem Sync, a cópia **não atualiza**. Após Sync, sugerir **reiniciar o chat** se a skill já estava carregada.

Detalhes: [playbook.md](playbook.md).

## Catálogo

Lista viva: [catalog.md](catalog.md). Manter atualizado ao criar/remover skill.

## Regras transversais (todas as skills de produto)

### Artefatos locais

| Pasta | Skills típicas |
|-------|----------------|
| `.task/` | `po-techlead-scrum`, `qa-space` |
| `.docs/` | `project-context-doc` |

| Situação | Regra |
|----------|--------|
| Fora de git repo | Criar `.task/` ou `.docs/` no workspace e gravar ali |
| Dentro de git repo | Idem **e** garantir a pasta no **`.gitignore`** (adicionar se faltar) |

Não commitar essas pastas sem o usuário pedir.

### Comunicação

- Respostas das skills Space: **português**
- Meta de manutenção de skill (sync, path, COPIA): falar **aqui** (`/skill-update`) ou apontar para esta skill
- Skills de produto focam no domínio; no topo delas fica só o banner COPIA + ponteiro para `AGENTS.md` / esta hub

## Fluxos rápidos

### A — Só sincronizar

1. Confirmar clone + `.env` da máquina (`SKILLS_DEST_PATH`)
2. `npm run sync`
3. Reportar skills copiadas + destino usado
4. Pedir restart do chat se necessário

### B — Alterar skill existente

1. Editar em `skills/<nome>/` no **repo** (não na cópia)
2. Se mudou catálogo/comportamento transversal → atualizar [catalog.md](catalog.md) e `AGENTS.md` se preciso
3. Commit/push **se o usuário pedir**
4. **`npm run sync`** na máquina alvo
5. Resumir o que mudou em 3–5 bullets

### C — Criar skill nova

Seguir [playbook.md](playbook.md#criar-skill-nova). Checklist mínimo:

- [ ] Pasta `skills/<kebab-name>/`
- [ ] `SKILL.md` com frontmatter (`name`, `description`, trigger `/…`)
- [ ] Banner **COPIA** + Sync obrigatório + ponteiro `AGENTS.md` / esta hub
- [ ] Seção artefatos (`.task/` / `.docs/` / N/A) se gravar arquivos
- [ ] Entrada em [catalog.md](catalog.md)
- [ ] Linha em `AGENTS.md` + README do repo
- [ ] `npm run sync`

### D — Diagnosticar

Sintomas comuns → [playbook.md](playbook.md#diagnóstico).

## Checklist final (qualquer ação desta skill)

- [ ] Mudança feita no **repo** `space-cursor-skills`, não só no destino
- [ ] `SKILLS_DEST_PATH` respeitado (PC ≠ Coders)
- [ ] **`npm run sync`** rodado (ou instruído) na máquina alvo
- [ ] Catálogo / AGENTS atualizados se skill nova ou removida
- [ ] Usuário avisado para reiniciar chat se skill já estava em uso
