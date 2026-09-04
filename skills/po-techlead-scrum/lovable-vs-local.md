# Lovable / protótipo vs código local — identificar lacunas

Antes de escrever a task, comparar **protótipo** (Lovable, Figma, staging) com **código local** para listar o que existe e o que falta.

Funciona para **qualquer projeto** da skill (ONESET, BATEU, SPACEBET…).

**Sempre responder em português.** Resultado em `{projeto-cliente}/.task/{projeto}/{task-slug}.md` + decomposição GLOBAL ([decomposicao-tom-professor.md](decomposicao-tom-professor.md)).

---

## Objetivo

**Matriz de lacunas:**

| Tela / feature | Protótipo | Código local | Lacuna | Camada |
| --- | --- | --- | --- | --- |
| … | ✅ / ❌ | ✅ / ⚠️ / ❌ | descrição | Back / Front / ambos |

A task descreve **lacunas**, não reimplementar o que já funciona.

**Prioridade visual (não inverter):** repo do produto (tema já definido) → Design System só no buraco → protótipo só **campos/ações**. Não listar “falta o neon do Lovable” como lacuna. Não listar “primary diferente do apêndice do DS” como lacuna se o produto já tem token.

**Exemplo preenchido (ONESET):** [exemplos/oneset-admin-lacunas-exemplo.md](exemplos/oneset-admin-lacunas-exemplo.md)

---

## Passo 1 — Inventariar o protótipo

1. Abrir URL do protótipo (grid da task).
2. Capturar prints ([playwright-capture.md](playwright-capture.md)).
3. **Mapa de telas** (adaptar colunas ao projeto):

| # | Rota / tela | Nome | Sub-seções (abas, modais) | Observações |
| --- | --- | --- | --- | --- |
| 1 | … | … | … | filtros, mocks, redirects |

4. Anotar decisões de produto (mocks 🎭, tooltips, tema visual do protótipo).

---

## Passo 2 — Inventariar código local

Adaptar buscas ao stack do repo (paths do grid da task).

### Frontend

```bash
glob: **/page.tsx
glob: **/pages/**
rg "<prefixo-rota>" src/
rg "<feature>" src/requests src/hooks
```

| Rota / tela local | Arquivo | Status |
| --- | --- | --- |
| … | … | existe / parcial / ❌ |

### Backend

```bash
glob: **/*controller*
rg "<prefixo-api>" src/
rg "<entidade>" migrations/ src/domain/
```

| Endpoint / módulo | Arquivo | Status |
| --- | --- | --- |
| … | … | … |

### Tema visual (se Front)

```bash
rg "dark-mode|data-theme|ThemeProvider|prefers-color-scheme" src/
# Ler globals.css / tokens de design (ex.: :root { --fundo })
```

Documentar: protótipo **dark** vs app **light** (ou vice-versa) — ver [screenshots.md](screenshots.md).

---

## Passo 3 — Comparar

Por **cada linha** do mapa do protótipo:

1. UI local existe?
2. API / schema suporta?
3. Comportamento alinhado?
4. Tema: copiar **layout/campos**, não paleta. Chrome = repo do produto; DS só no buraco; mock nunca manda cor/borda.

| Símbolo | Significado |
| --- | --- |
| ✅ | Alinhado |
| ⚠️ | Parcial |
| ❌ | Lacuna — entra na task |
| 🎭 | Mock no protótipo — marcar na task |

---

## Passo 4 — Priorizar escopo

1. Só **lacunas** na task
2. Back: comportamento; dev propõe schema/rotas
3. Front: prints + decomposição por bloco
4. Mocks 🎭 explícitos

---

## Passo 5 — Documentar na task

### Seção: **📊 Lacunas identificadas (Protótipo × Local)**

> Comparado ao protótipo em {URL} e ao código em {repo}, faltam: …

+ tabela + [decomposicao-tom-professor.md](decomposicao-tom-professor.md) por bloco.

---

## Ferramentas

| Ferramenta | Uso |
| --- | --- |
| Playwright | Prints ([playwright-capture.md](playwright-capture.md)) |
| rg / Glob | Rotas, controllers, migrations |
| MCP protótipo | Referência visual (não copiar código para prod) |
| Git diff | Baseline = branch acordada (ex.: `main`) |

---

## Edge cases

| Situação | Ação |
| --- | --- |
| Protótipo mais novo que prints | Recapturar |
| WIP local não mergeado | Observações; baseline clara |
| Monorepo / submodules | Inventariar **cada repo** |
| Só Back ou só Front | Matriz só da camada relevante |
| Protótipo dark, app light | Não implementar dark por causa do Lovable — validar grep na execução |
| Protótipo light, app dark | Idem — seguir o tema **já no app** |
| Print com glow/neon e o dash sem | **Não** é lacuna. Ganha o dash. |
| Primary do produto ≠ hex de exemplo do DS | **Não** é lacuna. Repo prevalece até o PO mandar mudar o tema. |

---

## Checklist

- [ ] Mapa de telas do protótipo
- [ ] Grep local (rotas, API, tema)
- [ ] Matriz ✅ / ⚠️ / ❌ / 🎭
- [ ] Task em `.task/{projeto}/{task-slug}.md`
- [ ] Decomposição GLOBAL aplicada
- [ ] Prints space-assets + legenda (incl. tema se divergir)
