# Direcionamento para o agente (Cursor)

Este repositório é a **fonte da verdade** das skills pessoais Space **e** da constituição (`docs/`).  
A pasta de destino no Cursor é só **cópia** gerada por `npm run sync` — não é onde se edita.

## Destino depende do ambiente (por isso o `.env`)

Cada máquina tem o **próprio** `.env` na raiz deste clone. O path de destino **não é fixo**:

| Variável | Papel |
|----------|--------|
| `SKILLS_DEST_PATH` | Onde o Cursor **desta máquina** lê as skills |
| `CLAUDE_SKILLS_DEST_PATH` | Onde o Claude Code **desta máquina** lê as skills (padrão `~/.claude/skills`; `off` desliga) |

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
- Copia `skills/` → **`SKILLS_DEST_PATH` do `.env` local** (Cursor) **e** `CLAUDE_SKILLS_DEST_PATH` (Claude Code)
- Copia `docs/` → **`<destino>/docs/`** nos dois destinos (constituição; skills leem `../docs/README.md` primeiro)
- Escreve `00-COPIA-LEIA-ME.md` em cada skill do destino (com o path real desta máquina)
- Gera `clickup.env` em skills que usam ClickUp (a partir do mesmo `.env`)
- Gera `apidog.env` em `po-techlead-scrum` (a partir do mesmo `.env`)

## Credenciais

- Fonte: `.env` na raiz deste repo (não versionar; **um por ambiente**)
- Exemplo: `.env.example`
- Não colocar tokens só na pasta de destino — o sync sobrescreve

## Skills neste repo

| Pasta | Função |
|-------|--------|
| `skills/skill-update` | **Hub** — sync, catálogo, criar/alterar skills, constituição (`/skill-update`) |
| `skills/create-feature` | **Feature nova** num projeto existente, do pedido ao PR para `HML` (`/create-feature`): demanda, snapshot, impactos, regras, canvas, "pode codar", banco, código, lado a lado em 3 larguras, revisor sem contexto, validação do dono. Guarda só ordem, gates e critérios; as regras são da constituição |
| `skills/po-techlead-scrum` | Tasks ClickUp (Esteira / Imediatas) + contrato Apidog — lê `docs/README.md` como **PO**. Inclui prompt do **Estruturador** ClickUp: `estruturador-clickup.md` (espelho `skill.md` na raiz; colar na AI Skill do ClickUp — não é skill Cursor) |
| `skills/project-context-doc` | Doc de contexto + Docs ClickUp — lê `docs/README.md` como **contexto** (G-xxx apontam ouro/entry) |
| `skills/qa-space` | QA front / Design System Space — lê `docs/README.md` como **QA** (audita o feito; DS inteiro) |
| `skills/design-system-forge` | **Cria** o DS do produto: diagnóstico, manual da marca (prancha), `.docs/DESIGN_SYSTEM.md` + tokens, Fundamentos + componentes no canvas (Pencil padrão). Modos Extrair/Criar; Q1–Q19; GATE ACCEPT; confronto com ui-gosto; entrega essencial e pergunta se evolui para ouro |
| `skills/design-system-apply` | **Aplica** o DS nas telas: diagnóstico; A DS×ui-gosto + OK; B varredura + espelho no canvas + OK; C correção/redesenho no canvas em loop até ALIGNED + `DIFERENCAS_PARA_DEVS.md`. Construtor = secundário; nunca edita código |
| `skills/product-from-idea` | **Cria produto** da ideia à tarefa em 12 fases (Controlador + subagente por fase; `.docs/` = verdade; não coda). Instala âncora no workspace dedicado. Chama Forge (7), Apply (8), PO (11). Fase 8.5: protótipo navegável a partir de um molde (`prototipo/` fora do `.docs/`, `npm run prototipo:start`) |
| `skills/replicar-mysql` | **Monta réplica MySQL** (origem → destino, Docker/EasyPanel, GTID) com script `ssh` / `listar` / `verificar` / `ponte` / `montar` / `status` / `bloquear-porta`; senha nunca na tela; OK do usuário antes de montar (`/replicar-mysql`) |
| `skills/subir-bet-easypanel` | **Sobe uma casa (bet) nova no EasyPanel** de ponta a ponta com serviços nativos (modelo, imagens, banco/redis/apps pela API, inicialização, domínios, Tailscale, réplica via `replicar-mysql`); usa os scripts do repo do bet (`deploy/casa-nova/`); só casas novas, modelo só leitura, nunca publica a 3306 (`/subir-bet-easypanel`) |
| `docs/` | Constituição (não é skill). Índice obrigatório: `docs/README.md` |

Manutenção do pack: skill **`skill-update`** (não espalhar o fluxo só nas skills de produto).

## Regras curtas

- Alterar skill → sempre no path `skills/...` deste clone
- Alterar constituição → `docs/` + mapa em `docs/README.md` (PO ≠ QA ≠ contexto)
- **Depois de alterar: `npm run sync`** — passo obrigatório, não opcional
- Pasta de destino (home ou Coders) = **cópia**; apontar para este repo + Sync
- Não assumir destino fixo `~/.cursor/skills` — ler `SKILLS_DEST_PATH` / `00-COPIA-LEIA-ME.md`
- Não inventar segundo fluxo de deploy; Sync é o único espelhamento
- Skills e constituição **genéricas**: sem IDs/URLs/defaults de um cliente; perguntar na conversa
- **Método de execução** de toda skill: [`docs/metodo-agentes.md`](docs/metodo-agentes.md) — Controlador + subagente por etapa, etapas com “Pronto quando” e exemplo real, revisor sem contexto. Cada `SKILL.md` tem a seção “Método de execução” e cada pasta um `CORRECOES.md`
- **Toda correção vira atualização da skill:** lista de correções → `/skill-update` (fluxo F) → edição genérica + registro no `CORRECOES.md` + sync
- Responder em português quando trabalhar nestas skills (padrão Space)
- Regra geral que nasceu num projeto (método de demandas, banco, git, telas) entra na constituição de forma genérica; o projeto guarda só o particular e as exceções ([`docs/metodo-agentes.md`](docs/metodo-agentes.md) §4, roteador)

## Docs humanas

- Setup e tabela de env: [README.md](README.md)
- Constituição (agentes leem o README primeiro): [docs/README.md](docs/README.md)
- Detalhe ClickUp (po-techlead): `skills/po-techlead-scrum/clickup-task-guide.md`
