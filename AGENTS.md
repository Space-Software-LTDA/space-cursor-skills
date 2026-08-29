# Direcionamento para o agente (Cursor)

Este repositório é a **fonte da verdade** das skills pessoais Space **e** da constituição (`docs/`).  
A pasta de destino no Cursor é só **cópia** gerada por `npm run sync` — não é onde se edita.

## Destino depende do ambiente (por isso o `.env`)

Cada máquina tem o **próprio** `.env` na raiz deste clone. O path de destino **não é fixo**:

| Variável | Papel |
|----------|--------|
| `SKILLS_DEST_PATH` | Onde o Cursor **desta máquina** lê as skills |

Exemplos típicos (valores reais ficam no `.env` local, não no git):

- PC Windows / home: costuma ser `~/.cursor/skills` (ou path absoluto equivalente)
- **Coders** (servidor): path **diferente** — configurar `SKILLS_DEST_PATH` no `.env` daquela máquina

Se `SKILLS_DEST_PATH` estiver vazio, o sync usa o default da plataforma (`$HOME/.cursor/skills`). Em ambiente compartilhado (coders), **sempre** defina o path correto no `.env`.

## Fluxo obrigatório

1. Editar em `skills/<nome-da-skill>/` **neste repo** (ou `docs/` se for constituição)
2. Commit + push (quando o usuário pedir)
3. **OBRIGATÓRIO — rodar o Sync** na raiz deste repo, **na máquina onde o Cursor lê as skills**:

```bash
npm run sync
```

   Sem esse comando a cópia no destino **não atualiza**. Usa o `.env` **daquela** máquina (`SKILLS_DEST_PATH`).
4. Reiniciar o chat do Cursor se a skill já estiver carregada

**Lembrete ao agente:** depois de alterar qualquer skill, **avise / execute** `npm run sync` — não encerrar só com o commit.

## O que o sync faz

- `git pull` (se `GIT_PULL=true`)
- Copia `skills/` → **`SKILLS_DEST_PATH` do `.env` local**
- Copia `docs/` → **`SKILLS_DEST_PATH/docs/`** (constituição; skills leem `../docs/README.md` primeiro)
- Escreve `00-COPIA-LEIA-ME.md` em cada skill do destino (com o path real desta máquina)
- Gera `clickup.env` em skills que usam ClickUp (a partir do mesmo `.env`)

## Credenciais

- Fonte: `.env` na raiz deste repo (não versionar; **um por ambiente**)
- Exemplo: `.env.example`
- Não colocar tokens só na pasta de destino — o sync sobrescreve

## Skills neste repo

| Pasta | Função |
|-------|--------|
| `skills/skill-update` | **Hub** — sync, catálogo, criar/alterar skills, constituição (`/skill-update`) |
| `skills/po-techlead-scrum` | Tasks ClickUp (Esteira / Imediatas) — lê `docs/README.md` como **PO** (escreve task) |
| `skills/project-context-doc` | Doc de contexto + Docs ClickUp — lê `docs/README.md` como **contexto** (G-xxx apontam ouro/entry) |
| `skills/qa-space` | QA front / Design System — lê `docs/README.md` como **QA** (audita o feito; DS inteiro) |
| `docs/` | Constituição (não é skill). Índice obrigatório: `docs/README.md` |

Manutenção do pack: skill **`skill-update`** (não espalhar o fluxo só nas skills de produto).

## Regras curtas

- Alterar skill → sempre no path `skills/...` deste clone
- Alterar constituição → `docs/` + mapa em `docs/README.md` (PO ≠ QA ≠ contexto)
- **Depois de alterar: `npm run sync`** — passo obrigatório, não opcional
- Pasta de destino (home ou Coders) = **cópia**; apontar para este repo + Sync
- Não assumir destino fixo `~/.cursor/skills` — ler `SKILLS_DEST_PATH` / `00-COPIA-LEIA-ME.md`
- Não inventar segundo fluxo de deploy; Sync é o único espelhamento
- Responder em português quando trabalhar nestas skills (padrão Space)

## Docs humanas

- Setup e tabela de env: [README.md](README.md)
- Constituição (agentes leem o README primeiro): [docs/README.md](docs/README.md)
- Detalhe ClickUp (po-techlead): `skills/po-techlead-scrum/clickup-task-guide.md`
