# ClickUp — publicacao via API (Fase 5)

Publica o contexto local como **um unico Doc ClickUp** com pagina principal (`README.md`) e subpaginas (`docs/*.md`).

## Pre-requisitos

1. Fase 4 concluida — arquivos locais gerados e **aprovados pelo usuario**
2. Personal API Token do ClickUp ([Authentication](https://developer.clickup.com/docs/authentication.md))
3. Script generico da skill:

```bash
python3 ~/.cursor/skills/project-context-doc/scripts/clickup_sync.py --workspace /path/projeto
```

Projetos podem ter wrapper `.docs/clickup_sync.py` que delega para o script acima.

## Credenciais

| Variavel | Obrigatoria | Onde configurar |
| -------- | ----------- | --------------- |
| `CLICKUP_API_TOKEN` | Sim | `~/.cursor/skills/project-context-doc/clickup.env` (global) |
| `CLICKUP_WORKSPACE_ID` | Sim | Idem |
| `CLICKUP_DOC_NAME` | Nao | `.docs/clickup.env` no projeto (default script: `[Produto] — Contexto`) |
| `CLICKUP_DOC_ID` | Nao | `.docs/clickup.env` ou `.docs/clickup_sync_state.json` apos 1o sync |
| `CLICKUP_DOC_PARENT_ID` | Nao | `.docs/clickup.env` ou env — default: mesmo `CLICKUP_WORKSPACE_ID` |
| `CLICKUP_DOC_PARENT_TYPE` | Nao | Default `12`=Workspace (pagina Documentos). `4`=Space, `5`=Folder, `6`=List |
| `CLICKUP_DOC_VISIBILITY` | Nao | `PRIVATE` (default) ou `PUBLIC` |

**Setup (1x):** copiar `clickup.env.example` → `clickup.env` na pasta da skill e preencher token + workspace_id. **Nunca commitar** `clickup.env`.

Overrides por projeto em `.docs/clickup.env` (doc_name, doc_id). Env vars da sessao (`export CLICKUP_*`) tem prioridade sobre arquivos.

Se credenciais ausentes, o agente pede ao usuario na Fase 5 antes de executar sync.

**Nao pedir OAuth** para este fluxo — Personal Token basta para teste e uso interno.

## Gate Fase 5

| Transicao | Gate |
| --------- | ---- |
| 4 → 5 | Usuario aprovou README + `docs/` localmente ("pode publicar no ClickUp") |
| 5 → entrega | `clickup_sync.py` executou sem erro; link do Doc informado |

**Proibido na Fase 5:** publicar antes da aprovacao local; commitar token no repositorio.

## Fluxo da API

1. **Create a Doc** — `POST /api/v3/workspaces/{workspace_id}/docs` com `create_page: true` ([ref](https://developer.clickup.com/reference/createdocpublic))
2. **Page listing** — `GET .../docs/{doc_id}/page_listing` para obter ID da pagina raiz
3. **Edit a Page** — `PUT .../pages/{page_id}` com conteudo do `README.md` (`content_format: text/md`)
4. **Create a Page** — `POST .../docs/{doc_id}/pages` para cada `docs/NN-*.md` (ordenado), com `parent_page_id` = pagina raiz. Titulo no ClickUp: **`NN — Titulo`** (prefixo do arquivo).

Opcional: **Search for Docs** — `GET .../workspaces/{workspace_id}/docs` para evitar duplicata ([ref](https://developer.clickup.com/reference/searchdocspublic)).

## Pre-processamento do markdown

Antes do upload, o script remove:

- Tags `<a id="..."></a>` (ClickUp as exibe como texto)
- Cabecalho `> Subpagina **...**`
- Rodape `**Navegacao:**`
- Secao "Publicar no ClickUp" do README

Anchors markdown (`#fl-001`) continuam funcionando **dentro** de cada pagina.

## Validacao pedagogica (obrigatoria antes do sync)

```bash
python3 ~/.cursor/skills/project-context-doc/scripts/validate_pedagogy.py docs/
```

Falha bloqueante — corrigir RN/FL/G/RT antes de `--update-existing`.

## Comandos

```bash
# Ver plano (sem API) — script da skill
python3 ~/.cursor/skills/project-context-doc/scripts/clickup_sync.py --workspace . --dry-run

# Ou wrapper do projeto
python3 .docs/clickup_sync.py --dry-run

# Criar Doc + subpaginas (credenciais em clickup.env — ver secao Credenciais)
python3 .docs/clickup_sync.py

# Atualizar Doc existente
python3 .docs/clickup_sync.py --doc-id 8cht190-831 --update-existing
```

Estado salvo em `.docs/clickup_sync_state.json` (doc_id, page_ids).

## Estrutura local esperada

```text
README.md              # pagina principal do Doc ClickUp
docs/
  01-contexto.md
  02-fluxos.md
  03-regras.md
  ...
.docs/
  clickup_sync.py      # wrapper opcional (delega para skill)
  clickup.env          # overrides projeto (doc_name, doc_id) — gitignored
  clickup_sync_state.json
  contexto-[slug].md   # monolito backup opcional
```

## Limitacoes conhecidas

- Links `[texto](docs/NN-*.md#ancora)` entre arquivos locais **nao** viram links clicaveis entre subpaginas no ClickUp. O sync converte **globalmente** para texto pesquisavel (ex. `RN-001 · 03 Regras`, `FL-001 Login · 02 Fluxos`) — use busca do Doc ou sidebar para navegar.
- Paginas muito grandes (ex. apendice) podem demorar ou falhar — testar com `--dry-run` e publicar apendice por ultimo.
- Re-sync com `--update-existing` faz match por **nome** da subpagina.
