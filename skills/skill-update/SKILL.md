---
name: skill-update
description: >-
  Hub central das skills Space (space-cursor-skills): sync, destino por ambiente
  (SKILLS_DEST_PATH / PC vs Coders), criar ou alterar skills, aviso de COPIA,
  .env ClickUp / Apidog, catalogo e comunicacao padrao entre skills. Use com /skill-update,
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
- Regras transversais (`.task/`, `.docs/`, gitignore, idioma, imagens e estrutura de tasks no ClickUp)
- Constituição do time (`docs/` na raiz — **não** é skill; mapa em `docs/README.md`)
- **Skills 100% genéricas** — nenhum cliente/produto hardcoded (BATEU, SPACEBET, …)

Quando o usuário falar de **manutenção de skill**, **sync**, **nova skill** ou **“como funciona o pack”**, usar **esta** skill — não reinventar o fluxo em cada skill de produto.

## Skills são genéricas (obrigatório)

O pack roda em **vários produtos**. `SKILL.md`, playbooks, scripts, templates e `.env.example` descrevem **processo**, não um cliente.

| Pode | Não pode |
|------|----------|
| Token da **conta** (ClickUp, Apidog) | Project ID / moduleId Apidog de um produto |
| Listas/workspace ClickUp da Space | URL de staging, repo, docs Apidog de um cliente |
| Placeholder `{projeto}`, `{ID}` | Default silencioso “usar BATEU / Data lake” |
| Pasta `exemplos/` com caso de um produto | Copiar esse caso para regra global |

IDs, URLs e nomes de um produto: **perguntar na conversa** (ou inferir do workspace aberto **e validar**).  
Ao criar/alterar skill: se o texto só fizer sentido para um cliente, **generalizar** antes do sync.

## Wizard (perguntar se não estiver claro)

1. **Ação:** sync | alterar skill existente | criar skill nova | diagnosticar (cópia desatualizada / path errado) | explicar catálogo | **atualizar constituição** (`docs/` na raiz do repo) | **registrar correção** (lista de correções vinda de outra skill)
2. **Skill alvo** (se alterar/criar): nome da pasta `skills/<nome>/`
3. **Máquina alvo do Sync:** PC local | Coders | ambas (lembrar: cada uma tem seu `.env`)
4. **Constituição** (se a ação for atualizar constituição): qual arquivo em `docs/` muda; **atualizar `docs/README.md` primeiro** (mapa skill → arquivo → por quê)

## Fonte da verdade

| Item | Onde |
|------|------|
| Repo | [Space-Software-LTDA/space-cursor-skills](https://github.com/Space-Software-LTDA/space-cursor-skills) |
| Clone típico (PC) | `G:\space\Documents\space\space-cursor-skills` (ou path do usuário) |
| Skills versionadas | `skills/<nome>/` **neste repo** |
| Destino Cursor | `SKILLS_DEST_PATH` no `.env` **da máquina** (não hardcodar) |
| Constituição | `docs/` na raiz deste repo → sync copia para `{SKILLS_DEST_PATH}/docs/` |
| Direcionamento agente no repo | `AGENTS.md` + `.cursor/rules/space-cursor-skills.mdc` |
| Credenciais ClickUp | `.env` na **raiz** do repo (sync gera `clickup.env` nas skills que usam) |
| Credenciais Apidog | Mesmo `.env` (`APIDOG_*`) — sync gera `apidog.env` em `po-techlead-scrum` |

**Nunca** editar só a pasta de destino e considerar pronto.

## Comando Sync (obrigatório após mudança)

Na raiz do clone, **na máquina onde o Cursor lê as skills**:

```bash
npm run sync
# ou
npm run sync:dry
```

O Sync: `git pull` (se ligado) → copia `skills/` **e** `docs/` → destino → carimba `00-COPIA-LEIA-ME.md` → gera `clickup.env` / `apidog.env` onde couber.

Sem Sync, a cópia **não atualiza**. Após Sync, sugerir **reiniciar o chat** se a skill já estava carregada.

Detalhes: [playbook.md](playbook.md).

## Catálogo

Lista viva: [catalog.md](catalog.md). Manter atualizado ao criar/remover skill.

### Constituição (`docs/`)

Não é skill. Fonte: `space-cursor-skills/docs/`. Destino após sync: `{SKILLS_DEST_PATH}/docs/`.

**Antes de qualquer alteração nos arquivos temáticos:** ler e, se o mapa mudou, atualizar [`docs/README.md`](../../docs/README.md). Esse README é o que **todas** as skills de produto leem primeiro — PO, QA e contexto **não** usam os mesmos arquivos do mesmo jeito.

Skills de produto só têm ponteiro (`../docs/README.md` + tabela curta). **Proibido** colar resumo do entry-point ou do DS no `SKILL.md`.

Fluxo: editar `docs/` → conferir README → `npm run sync`. Detalhe: [playbook.md](playbook.md#atualizar-constituição).

## Regras transversais (todas as skills de produto)

### Artefatos locais

| Pasta | Skills típicas |
|-------|----------------|
| `.task/` | `po-techlead-scrum`, `qa-space` |
| `.docs/` | `project-context-doc`, `design-system-forge`, `design-system-apply` (e espelho OpenAPI/DBML do PO antes do Apidog) |

| Situação | Regra |
|----------|--------|
| Fora de git repo | Criar `.task/` ou `.docs/` no workspace e gravar ali |
| Dentro de git repo | Idem **e** garantir a pasta no **`.gitignore`** (adicionar se faltar) |

Não commitar essas pastas sem o usuário pedir.

**Exceção — workspace dedicado do `product-from-idea`:** ali `.docs/` **é o produto definido** e é versionado (não vai para o `.gitignore`). Commit/push continuam só quando o usuário pedir.

### Imagens para o ClickUp

Imagem (print, diagrama) de task no ClickUp **anexa direto na task** — **não** precisa de push em repositório (space-assets ou repo do projeto). O PNG fica na pasta de artefatos (`.task/{projeto}/assets/{task-slug}/`), o `.md` usa caminho relativo e o script de publicação anexa e troca pela URL do attachment. Repo de imagens só quando a imagem precisa de URL pública **fora** do ClickUp. Depois de publicar, conferir que nenhuma imagem ficou com link externo ou caminho local. Detalhe: `skills/po-techlead-scrum/screenshots.md`.

### Estrutura de tasks no ClickUp

| Lista | Subtarefa | Front+Back | Status inicial |
|-------|-----------|------------|----------------|
| **Esteira** | **Pode**, só quando precisar | 1 task com a spec completa (camadas separadas por seção e no passo a passo). Sprint com várias entregas = **1 MAIN da sprint** + cada entrega como subtask | `demanda`; **vai para a sprint já → `detalhar`** |
| **Imediatas** | **Jamais** | 2 tasks **separadas** `[BACKEND]` e `[FRONTEND]`, **vinculadas** (linked task), checklist nativo em cada | Padrão da lista |

**Não duplicar descrição:** cada informação mora em um lugar só (MAIN da sprint não repete a spec das entregas; subtarefa não copia o corpo da pai). Para reorganizar tasks já publicadas, **mover** (trocar o pai), não recriar. Detalhe: `skills/po-techlead-scrum/clickup-task-guide.md`.

### Pipeline PO (task com API)

Na skill `po-techlead-scrum`: **Objetivo → regra de negócio → DB → rotas no Apidog → task ClickUp**.  
Project ID, moduleId e pasta: **descobrir pelo nome** com o `apidog-cli` (`scripts/apidog_resolve_ids.py`); perguntar só se ambíguo (não ficam no `.env`). Detalhe: `skills/po-techlead-scrum/apidog.md`.

### Método de execução (todas as skills)

Fonte única: [`../docs/metodo-agentes.md`](../../docs/metodo-agentes.md). Toda skill tem no `SKILL.md` uma seção **“Método de execução”** com:

- tabela de etapas: Etapa · Subagente · Entrega · **Pronto quando** · **Exemplo real** (ou “falta exemplo real”) · Quem aprova;
- onde entra o **revisor sem contexto**;
- a regra “toda correção → lista de correções → `/skill-update`”;
- um `CORRECOES.md` na pasta da skill (registro dos erros corrigidos);
- a **âncora** que a skill cria no projeto ao ser chamada (`docs/metodo-agentes.md` §5): regra + `AGENTS.md` curtos só em workspace dedicado; em repositório de código, só `ANCORA.md` na pasta de artefatos.

Skill nova sem essa seção não está pronta. Ao alterar uma skill, manter a tabela de etapas verdadeira.

### Comunicação

- Respostas das skills Space: **português**
- Meta de manutenção de skill (sync, path, COPIA): falar **aqui** (`/skill-update`) ou apontar para esta skill
- Skills de produto focam no domínio; leem **`../docs/README.md` primeiro** (PO ≠ QA ≠ contexto); banner COPIA + ponteiro `AGENTS.md` / esta hub

## Método de execução (desta skill)

Segue [`../docs/metodo-agentes.md`](../../docs/metodo-agentes.md). Registro: [`CORRECOES.md`](CORRECOES.md).

| Etapa | Subagente | Entrega | Pronto quando | Exemplo real | Quem aprova |
|-------|-----------|---------|---------------|--------------|-------------|
| Wizard | Não — Controlador | Ação + skill alvo + máquina | As perguntas do wizard respondidas | — | Humano |
| Edição | Sim — um por skill quando a mudança toca várias | Arquivos editados no repo | Mudança no repo (não na cópia); texto genérico; tabela de etapas da skill verdadeira | Falta exemplo real | Controlador |
| Revisão sem contexto | Sim — subagente novo | Lista de achados | Zero dado de cliente fora de `exemplos/`; links relativos resolvem; skill com “Método de execução” + `CORRECOES.md` | — | Controlador |
| Sync | Não | Cópia no destino | `npm run sync` rodado; destino informado | — | — |

---

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
- [ ] Seção **“Método de execução”** (tabela de etapas com Pronto quando + exemplo real; revisor sem contexto; correções → `/skill-update`) + `CORRECOES.md` vazio no formato do playbook
- [ ] Pasta `exemplos/` com caso real, ou “falta exemplo real” declarado na tabela
- [ ] **Âncora** definida: onde a skill grava a âncora no projeto (workspace dedicado × repositório de código) e o modelo dela
- [ ] Entrada em [catalog.md](catalog.md)
- [ ] Linha em `AGENTS.md` + README do repo
- [ ] Conteúdo **genérico** (sem IDs/URLs/defaults de um cliente)
- [ ] **Revisão sem contexto** (subagente novo) antes do sync: genericidade, links, caminhos antigos, “como começar” claro
- [ ] `npm run sync`

### D — Diagnosticar

Sintomas comuns → [playbook.md](playbook.md#diagnóstico).

### F — Registrar correção (vinda de qualquer skill)

Gatilho: uma skill entregou a **lista de correções** (o humano corrigiu, o revisor achou falha, o agente viu erro próprio, ou o humano deu diretriz que vale além da tarefa). Método: [`../docs/metodo-agentes.md`](../../docs/metodo-agentes.md) §4.

1. Receber a lista: o que estava errado · causa · correção no artefato · o que muda na skill.  
2. **Filtrar:** dado de produto (preço, nome, ID, URL) e preferência pontual **não** entram; só o que vale para qualquer produto.  
3. **Eco → confirma:** mostrar ao humano, em português claro, que regra nova ou ajuste entra em qual arquivo da skill (ou da constituição, se vale para várias skills). Esperar o OK.  
4. Editar no **repo** (`skills/<nome>/` ou `docs/`), de forma genérica. Se a correção mexe na tabela de etapas, atualizar o “Pronto quando”.  
5. Registrar no `skills/<nome>/CORRECOES.md` (formato em [playbook.md](playbook.md#registrar-correção)).  
6. `npm run sync`. Commit/push só se o humano pedir.  
7. Resumo: correção → regra → arquivo.

### E — Atualizar constituição

1. Ler `docs/README.md` (quem lê o quê — PO ≠ QA)
2. Editar `docs/<arquivo>.md` no **repo**
3. Se o mapa mudou, atualizar só o README — skills de produto continuam com ponteiro fino
4. **`npm run sync`** (precisa copiar `docs/` para o destino)
5. Pedir restart do chat

## Checklist final (qualquer ação desta skill)

- [ ] Mudança feita no **repo** `space-cursor-skills`, não só no destino
- [ ] Constituição: mapa em `docs/README.md` ainda verdadeiro (se mexeu em `docs/`)
- [ ] `SKILLS_DEST_PATH` respeitado (PC ≠ Coders)
- [ ] **`npm run sync`** rodado (ou instruído) na máquina alvo
- [ ] Catálogo / AGENTS atualizados se skill nova ou removida
- [ ] Nada específico de um produto nas regras globais (IDs/URLs/defaults de cliente)
- [ ] Skill alterada ou nova com seção **“Método de execução”** verdadeira (etapas · Pronto quando · exemplo real · revisor sem contexto) e `CORRECOES.md`
- [ ] Correção registrada no `CORRECOES.md` da skill (fluxo F)
- [ ] `apidog.env` / `clickup.env` gerados no destino se os tokens existem no `.env` (nunca commitados)
- [ ] Usuário avisado para reiniciar chat se skill já estava em uso
