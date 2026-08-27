# Direcionamento para o agente (Cursor)

Este repositório é a **fonte da verdade** das skills pessoais Space.  
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

1. Editar em `skills/<nome-da-skill>/` **neste repo**
2. Commit + push (quando o usuário pedir)
3. Na raiz deste repo (na máquina alvo): `npm run sync` — usa o `.env` **daquela** máquina
4. Reiniciar o chat do Cursor se a skill já estiver carregada

## O que o sync faz

- `git pull` (se `GIT_PULL=true`)
- Copia `skills/` → **`SKILLS_DEST_PATH` do `.env` local**
- Escreve `00-COPIA-LEIA-ME.md` em cada skill do destino (com o path real desta máquina)
- Gera `clickup.env` em skills que usam ClickUp (a partir do mesmo `.env`)

## Credenciais

- Fonte: `.env` na raiz deste repo (não versionar; **um por ambiente**)
- Exemplo: `.env.example`
- Não colocar tokens só na pasta de destino — o sync sobrescreve

## Skills neste repo

| Pasta | Função |
|-------|--------|
| `skills/po-techlead-scrum` | Tasks ClickUp (Esteira / Imediatas) |
| `skills/project-context-doc` | Doc de contexto + Docs ClickUp |
| `skills/qa-space` | QA front / Design System |

## Regras curtas

- Alterar skill → sempre no path `skills/...` deste clone
- Pasta de destino (seja home ou coders) = **cópia**; apontar para este repo + `npm run sync`
- Não assumir que o destino é sempre `~/.cursor/skills` — ler `SKILLS_DEST_PATH` / `00-COPIA-LEIA-ME.md`
- Não inventar segundo fluxo de deploy; sync é o único espelhamento
- Responder em português quando trabalhar nestas skills (padrão Space)

## Docs humanas

- Setup e tabela de env: [README.md](README.md)
- Detalhe ClickUp (po-techlead): `skills/po-techlead-scrum/clickup-task-guide.md`
