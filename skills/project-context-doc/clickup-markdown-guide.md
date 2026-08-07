# ClickUp — regras visuais do markdown publicado

Validado com Doc real de projeto piloto. Ajustes aplicados no conteudo local e no **`clickup_sync.py`** (pre-processamento antes do upload).

## Erros visuais encontrados

| Problema | Causa | Correcao |
| -------- | ----- | -------- |
| Titulo duplicado | Nome da subpagina ClickUp (`02 — Fluxos`) + `## 🔄 Fluxos End-to-End` no corpo | Subpaginas: **nao** repetir H2 de secao — titulo fica so na sidebar ClickUp |
| Muitos separadores `---` vazios | Gerador junta blocos com `\n\n---\n\n` em excesso | Colapsar 2+ `---` consecutivos no sync |
| Links indice `#fl-001` quebrados | ClickUp converte para `http://#fl-001` | No upload: `[FL-001 Login](#fl-001)` → `FL-001 Login` (texto). Outline nativo do ClickUp usa headings `### FL-001` |
| **Links cross-page `#` quebrados** | ClickUp nao suporta links entre subpaginas; `[#fl-001](docs/02-fluxos.md#fl-001)` vira `#fl-001` na pagina errada | Sync: **todo** `[texto](docs/NN-*.md#ancora)` → texto pesquisavel `FL-001 Login · 02 Fluxos`. Gerador: label com ID + pagina destino |
| **`####` titulo + linha vazia + texto** | ClickUp cria **bloco separado** por heading — aparece placeholder "Escreva..." entre titulo e conteudo | Usar `**Proibido** — paragrafo` na mesma linha logica; nunca `#### Proibido` + linha vazia + 1 frase |
| **Linha pos-tabela colada no texto** | `flatten_h4` junta `#### Referencias` com links na linha seguinte — ClickUp le como linha extra da tabela → HTTP 400 | Sync: `ensure_blank_line_after_tables` apos flatten; gerador: `**Referencias** — links` (nunca `#### Referencias` apos tabela) |
| Tom telegrafico em G/RN | Gerador entregou 1 frase por secao | G: cenario 4+ frases; RN: cenario 5+ frases — ver template-rn-guardrail.md |
| Tags `<a id="...">` visiveis | HTML nao suportado | Remover no sync (ja existia) |
| Meta de tooling no README | Texto sobre `clickup_sync.py`, coluna "Arquivo local" | **Nunca** incluir no conteudo publicavel — fica so na skill |
| Blockquote `> Subpagina **...**` | Wrapper local dev | Remover no sync |
| Referencias cruzadas viram texto morto | Links `docs/03-regras.md#rn-001` nao clicam entre subpaginas | Sync converte globalmente para texto pesquisavel (`RN-001 · 03 Regras`); sidebar do Doc para navegar |
| Emoji no H2 vira icone solto | ClickUp renderiza emoji de heading de forma estranha | Evitar H2 com emoji em subpaginas (titulo ja na sidebar) |
| **FL sem hierarquia no outline** | `flatten_h4` achata secoes narrativas FL/WH em bold | Manter `####` para secoes narrativas (lista de exclusao no sync) |
| **Buracos verticais entre secoes** | 2+ linhas vazias ou `---` orfaos no gerador | `collapse_excessive_blank_lines` no sync |

## Matriz de headings (obrigatorio)

Dois perfis — **nao misturar**:

| Tipo de conteudo | Formato markdown | Sync ClickUp |
| ---------------- | ---------------- | ------------ |
| **G / RN — campos curtos** (Proibido, Se violar, Regra em uma frase, Cenario de violacao inline) | `**Label** — paragrafo` | Mantém como esta |
| **FL / WH / DA — secoes narrativas** (Por que importa, Cenario, Pre-condicoes, O que acontece passo a passo) | `#### Titulo` + 1a frase **na linha seguinte** (sem linha vazia entre titulo e texto) | **Nao achatar** — preserva H4 no outline |
| **Indice de modulo** | `#### Indice deste modulo — ...` | Nao achatar |
| **Referencias pos-tabela** | linha em branco + `**Referencias** — links` | `ensure_blank_line_after_tables` antes |
| **RT — intro de modulo Tier 2** | `#### repo — Modulo X` + paragrafo intro (2+ frases) + lista | Nao achatar titulo de modulo |

**Regra anti-bloco-vazio:** o placeholder "Escreva..." aparece quando ha `\n\n` logo apos `#### Titulo`. Secoes narrativas usam `\n` simples entre titulo e 1o paragrafo.

**Proibido em FL:** `**Por que este fluxo importa**` como bold solto — perde hierarquia visual no ClickUp.


**Incluir:**
- Aviso IA, referencia rapida, indice de secoes (tabela `# | Secao |` com links)
- Contexto, como ler, erros classicos, mapa, glossario

**Nao incluir:**
- Instrucoes de publicacao (`python3 .docs/clickup_sync.py`)
- Coluna "Arquivo local" ou paths `docs/01-*.md` como metadado
- Paragrafo "Este contexto esta dividido em 8 arquivos..."

## Subpaginas (`docs/NN-*.md`)

**Estrutura recomendada (corpo):**

```markdown
#### Indice deste modulo — Fluxos

- FL-001 Login
- FL-002 Cadastro
...

> **Como usar:** ...

### FL-001: Login
...
```

**Evitar no corpo:**
- `## 🔄 Fluxos End-to-End (FL-xxx)` — redundante com titulo ClickUp
- Links `[texto](#ancora)` no indice do modulo — quebram no ClickUp
- Multiplos `---` seguidos sem conteudo entre eles

## Pre-processamento (`prepare_for_clickup`)

Ordem aplicada no sync:

1. Remove `<a id="..."></a>`
2. Remove cabecalho `> Subpagina **...**`
3. Remove rodape `**Navegacao:**`
4. Subpagina: remove `---` iniciais + primeiro `## ...`
5. Converte `[texto](docs/NN-*.md#ancora)` → texto pesquisavel (`RN-001 · 03 Regras`)
6. Converte `[texto](#ancora)` same-page → `texto`
7. `flatten_h4_for_clickup` — achata `####` **exceto** secoes narrativas FL/WH/RT (lista `H4_PRESERVE_TITLES`)
8. `ensure_blank_line_after_tables` — linha em branco obrigatoria apos ultima linha `| ... |`
9. `collapse_excessive_blank_lines` — max 1 linha vazia consecutiva; remove `---` orfaos
10. Colapsa `---` repetidos

**Exemplo Apendice (coluna Link):**

| Antes (local) | Depois (ClickUp) |
| ------------- | ---------------- |
| `[FL-001 Login · 02 Fluxos](02-fluxos.md#fl-001)` | `FL-001 Login · 02 Fluxos` |
| `[#fl-001](docs/02-fluxos.md#fl-001)` (legado) | `FL-001 · 02 Fluxos` |

## Checklist Fase 4 (antes do upload)

- [ ] README sem meta de tooling ou sync
- [ ] Subpaginas sem H2 duplicando titulo ClickUp
- [ ] Indice de modulo com lista plain (ou aceitar demote no sync)
- [ ] Zero `<a id>` no markdown enviado
- [ ] Dry-run: `clickup_sync.py --dry-run`

## Checklist pos-upload (Fase 5)

- [ ] Doc aparece em Documentos workspace (parent type **12**, nao Everything/7)
- [ ] Subpaginas ordenadas `01`…`NN` na sidebar
- [ ] Indice FL clicavel substituido por outline lateral do ClickUp
- [ ] Tabelas e imagens mermaid.ink renderizam
- [ ] Sem blocos vazios entre separadores
