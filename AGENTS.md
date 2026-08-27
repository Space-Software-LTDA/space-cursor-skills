# Direcionamento para o agente (Cursor)

Este repositório é a **fonte da verdade** das skills pessoais Space.  
`~/.cursor/skills` é só **cópia** gerada por sync — não é onde se edita.

## Fluxo obrigatório

1. Editar em `skills/<nome-da-skill>/` **neste repo**
2. Commit + push (quando o usuário pedir)
3. Na raiz deste repo: `npm run sync`
4. Reiniciar o chat do Cursor se a skill já estiver carregada

## O que o sync faz

- `git pull` (se `GIT_PULL=true`)
- Copia `skills/` → `SKILLS_DEST_PATH` (default `~/.cursor/skills`)
- Escreve `00-COPIA-LEIA-ME.md` em cada skill do destino
- Gera `clickup.env` em skills que usam ClickUp (a partir do `.env` da **raiz**)

## Credenciais

- Fonte: `.env` na raiz deste repo (não versionar)
- Exemplo: `.env.example`
- Nunca colocar tokens só em `~/.cursor/skills/...` — o sync sobrescreve

## Skills neste repo

| Pasta | Função |
|-------|--------|
| `skills/po-techlead-scrum` | Tasks ClickUp (Esteira / Imediatas) |
| `skills/project-context-doc` | Doc de contexto + Docs ClickUp |
| `skills/qa-space` | QA front / Design System |

## Regras curtas

- Alterar skill → sempre no path `skills/...` deste clone
- Se o usuário estiver em `~/.cursor/skills/...`, avisar que é cópia e apontar para este repo + `npm run sync`
- Não inventar segundo fluxo de deploy; sync é o único espelhamento
- Responder em português quando trabalhar nestas skills (padrão Space)

## Docs humanas

- Setup e tabela de env: [README.md](README.md)
- Detalhe ClickUp (po-techlead): `skills/po-techlead-scrum/clickup-task-guide.md`
