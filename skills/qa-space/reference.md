# QA Space — Referência

Checklists, **matriz de auditoria do Design System** (seção a seção), anti-padrões detalhados e template do `REPORT.md`.

**Design System completo:** [design-system.md](design-system.md) — ler antes de usar esta referência.

---

## Matriz de auditoria — Design System (por seção)

Usar durante Fase 2 (browser). Para cada tela, marcar pass/fail e anotar evidência (print + § violado).

### §2 Filosofia

| Check | Pass? | Notas |
|-------|-------|-------|
| Parece profissional/corporativo/minimalista | | |
| **Não** parece gamer/neon/cyberpunk/dribbble | | |
| Densidade informativa sem poluição | | |
| Widget ≠ card de marketing | | |
| Um CTA Primary por seção | | |

### §3 Cores

| Check | Pass? | Notas |
|-------|-------|-------|
| Primary e Surface identificáveis e consistentes | | |
| Escala Background → Surface → Card → Elevated perceptível | | |
| Texto **não** é branco puro em tudo (dark) | | |
| Success/warning/destructive só para feedback | | |
| Secondary = ação secundária, **não** fundo | | |

### §4 Tipografia

| Check | Pass? | Notas |
|-------|-------|-------|
| Usa escala app (display→overline), não landing H1 em KPI | | |
| Máx ~3 pesos por tela | | |
| KPI/widget denso: 16/12/10 se Apêndice B aplicável | | |
| Hierarquia por size + weight + cor | | |
| Fonte UI = Inter (ou documentar exceção) | | |

### §5 Radius

| Token | Esperado | Pass? |
|-------|----------|-------|
| Botão / input / select | 8px | |
| Card / toast / widget | 12px | |
| Modal / dialog | 16px | |
| Badge pill | 9999px | |
| Nada >12px em card comum | | |

### §6 Spacing / Grid

| Check | Pass? | Notas |
|-------|-------|-------|
| Gaps/padding na escala 4·8·12·16·24·32·48·64 | | |
| Sem 13px, 18px, 22px inventados | | |
| Grid cards: gap coluna ~12px | | |

### §7 Bordas / Elevation / Motion

| Check | Pass? | Notas |
|-------|-------|-------|
| Preferência camada+borda vs sombra forte | | |
| Sem glow / neomorphism / multi-shadow | | |
| Animações ≤200ms em UI produtiva | | |

### §8 Ícones

| Check | Pass? | Notas |
|-------|-------|-------|
| Somente Lucide | | |
| Tamanhos 16 / 20 / 24 | | |
| Ativo / CTA = Primary | | |

### §9 Badges

| Check | Pass? | Notas |
|-------|-------|-------|
| Padding ≥ 5×12px | | |
| Título/categoria: Primary-soft (texto+borda+fundo subtom) | | |
| Evolução ±: success/destructive-soft (**não** Primary) | | |
| Font 10px / 600 | | |

### §10 Componentes

| Componente | Check | Pass? |
|------------|-------|-------|
| Button Primary | fundo Primary sólido, 1 por seção | |
| Button Secondary | transparente + borda Primary + texto Primary | |
| Input/Select | radius 8, height ~40 | |
| Card vs Widget | densidade correta ao contexto | |

### §11 Tabelas (CRÍTICO)

#### Infraestrutura base

| Check | Pass? | Notas |
|-------|-------|-------|
| Pagination (Anterior · páginas · Próximo) | | |
| **Per page** (10·25·50·100, default 25) | | |
| Zebra striping (tokens Primary/Surface) | | |
| Sort clicável + indicador Asc/Desc | | |
| Column picker **⋯** no headerRight do WidgetShell | | |
| Linha ~36–40px; padding 8×12 (`py-2 px-3`) | | |
| Paginação **server-side** em prod real | | |
| **Não** cards empilhados no lugar de tabela | | |
| Coluna ações: estreita, alinhada à esquerda | | |
| Sticky col sem “quadrado” no header | | |
| Histórico/listagens secundárias usam `SpaceDataTable` (não `<table>` ad-hoc) | | |

#### §11 — Hierarquia visual v7 (widget tabular)

Uma cor base (`#E2E2E2` ou equivalente do projeto) + ênfase por **peso** e **opacidade** — **não** cinzas `#8B90A0` / `#C4C7CF` em células.

| Papel | Esperado | Pass? |
|-------|----------|-------|
| Título widget | 14px / 600 / 100% | |
| Header coluna | 12px / 600 / `#A0A5B3` (ou token meta) | |
| Célula `highlight` | 14px / 600 / 100% | |
| Célula `normal` | 14px / 400 / ~75% opacidade | |
| Célula `meta` | 12px / 400 / ~80% opacidade | |
| Badge ROI/etapa | 10px / 600 (§9) | |

| Regra v7 | Pass? | Notas |
|----------|-------|-------|
| `cellVariant` centralizado (`highlight` · `normal` · `meta`) | | |
| **Proibido** `font-medium`/`font-semibold` ad-hoc em células | | |
| **Proibido** cinza `#8B90A0` / `#C4C7CF` em dados | | |
| Coluna sem destaque = `normal` (legível, não apagada) | | |
| Colunas copiáveis: `CopyButton`/`CopyableCell` + toast + `stopPropagation` | | |
| Players: **Nome** e **Campanha** = `highlight` | | |
| Picker ⋯: checkbox compacto (`h-3 w-3`, ícone `size-2`) | | |

#### §11 — Alinhamento v8 (`meta.align`)

| Tipo | `align` esperado | Pass? |
|------|------------------|-------|
| Texto / identidade / badge / meta / ações | `left` | |
| Contagem / percentual / monetário (R$) | `center` | |
| Header e célula com **mesmo** alinhamento | | |
| **Proibido** mix ad-hoc (métrica sem `center`) | | |
| Legado `align: "right"` migrado → `"center"` em métricas | | |

Helpers esperados: `col.text()` · `col.numeric()` · `col.money()` · `col.meta()` · `col.deemphasis()`.

#### §11 — Reorder de colunas (DnD)

| Check | Pass? | Notas |
|-------|-------|-------|
| Grip `GripVertical` no header + drag horizontal | | |
| Menu ⋯ com lista sortable + checkbox visibilidade | | |
| Ordem persistida: `localStorage` `sdt:{tableId}:order` | | |
| Colunas locked (identidade esq. + ações dir.) imóveis | | |
| Merge ordem salva + colunas novas (append ids) | | |

### §12 Overlays

| Check | Pass? | Notas |
|-------|-------|-------|
| Dialog para confirmação/form curto | | |
| Sheet para painel lateral / mobile | | |
| Sem modal custom fora Shadcn | | |

### §13 Layouts (shell)

| Check | Pass? | Notas |
|-------|-------|-------|
| Sidebar: Surface, item ativo Primary ~10–14% | | |
| Header: título h1/h2, filtros à direita | | |
| Footer: logo completo vs ícone conforme viewport | | |

### §14–§17 Contextos / Mobile / Estados / A11y

| Check | Pass? | Notas |
|-------|-------|-------|
| Densidade correta ao contexto (dashboard vs auth) | | |
| Touch target ≥44px no mobile | | |
| Loading / empty / error tratados | | |
| Focus ring visível; contraste AA | | |

### §18 Proibidos (caçar ativamente)

- Gradientes decorativos, glass, blur desnecessário
- Glow / neon / sombras fortes
- KPI em escala H1 landing
- Cards dentro de cards
- Tabela sem Pagination / Per page / zebra / sort / ⋯
- Secondary com fundo sólido falso-primary
- Badge evolução com Primary
- Stats/cards consumindo hero inteiro
- Cinza `#8B90A0` / `#C4C7CF` em células de tabela (usar opacidade v7)
- `font-medium`/`font-semibold` ad-hoc em células (usar `cellVariant`)
- Métricas/R$ sem `align: "center"` (v8)
- `<table>` HTML ad-hoc onde DS exige `SpaceDataTable`
- Column picker em coluna vazia do thead ou toolbar órfã

### §19 Checklist de aceite (copiar para REPORT)

Reproduzir a checklist do §19 de [design-system.md](design-system.md) no REPORT com `[x]` / `[ ]` por item.

### Apêndice B — KPI Widget (se aplicável)

| Check | Pass? | Notas |
|-------|-------|-------|
| KPI principal 16px/700; secundário 16px/500 | | |
| Labels 10px; footer 12px | | |
| Altura alvo ~160–175px (não 220+) | | |
| Padding ~12px; gap col 12 / row 24 | | |

---

## Template REPORT.md

Copiar para `.task/qa-{data}-{slug}/REPORT.md` e ir preenchendo **durante** a inspeção.

```markdown
# QA Report — {feature / módulo}

**Data:** {YYYY-MM-DD}  
**Veredito:** {Aprovado | Aprovado com ressalvas | Reprovado}  
**Projeto:** {MONITOR | ACTION | …}  
**Front validado:** {URL}  
**Mock:** {URL ou "não informado"}  
**Task:** {link ou "conteúdo colado no chat"}  
**Escopo navegação:** {task only | task + relacionadas | módulo}  
**Rigor visual:** {P0/P1 only | inclui P2/P3}  

---

## Resumo executivo

{3–5 frases para leigos: o que foi testado, principal problema, pode ir pra prod?}

---

## Escopo validado

- [ ] Rotas visitadas: …
- [ ] Inputs recebidos: front ✓ mock ✓ task ✓ back ✓
- [ ] Lacunas: …

---

## Visual — feito × proposto

### {Tela 1 — ex.: /experts}

**Esperado (mock/task):** …  
**Encontrado:** …  
**Prints:** `screenshots/feito-….png` · `screenshots/proposto-….png`  
**Severidade:** P…  

---

## Design System

Referência: [design-system.md](design-system.md) (skill) · `docs/SPACE_DESIGN_SYSTEM.md` (repo se existir)

**Primary do produto:** {hex} · **Surface:** {hex}

### §19 — Checklist de aceite

{Copiar checklist §19 com pass/fail}

### Achados DS por tela

| Tela | § violado | Esperado (DS) | Encontrado | Sev |
|------|-----------|---------------|------------|-----|
| /experts | §11 ⋯ | column picker no headerRight | ausente | P1 |
| /players | §11 v7 | Nome+Campanha highlight 14/600 | normal 400 | P1 |
| /campanhas | §11 v8 | FTD/Investimento center | left ad-hoc | P2 |
| … | | | | |

### §11 v7 — Hierarquia tabular (se aplicável)

- [ ] Título widget = highlight (100%) > normal (~75%) > meta (12px ~80%)
- [ ] Sem cinza `#8B90A0` / `#C4C7CF` em células
- [ ] `cellVariant` centralizado; sem bold ad-hoc

### §11 v8 — Alinhamento (se aplicável)

- [ ] Textos/badges à esquerda; métricas/R$ centralizados
- [ ] Header e célula com mesmo `meta.align`

---

## Console / Network

| Tipo | Detalhe | Rota | Sev |
|------|---------|------|-----|
| console.error | … | /… | P0 |
| GET 404 | … | /api/… | P1 |
| limit=1000 | paginação fake | /… | P1 |

---

## Código Front

### {Achado 1 — título curto}

**Onde:** `path/to/file.tsx` (linhas ~X–Y)  
**Problema (leigo):** …  
**Por que está errado:** …  
**Como deveria ser:** …  

```tsx
// trecho problemático — copiar para snippets/ se longo
```

**Severidade:** P…  

---

## Contrato API / Back

**Fonte usada:** {OpenAPI | back | Network | prod}

| Esperado | Feito | Evidência | Sev |
|----------|-------|-----------|-----|
| GET /games/:id | GET /games + filter client | Network tab | P1 |

---

## Achados consolidados

### P0
1. …

### P1
1. …

### P2
1. …

### P3
1. …

---

## Próximos passos

- PO: usar este REPORT + prints em `.task/` para gerar task via `@po-techlead-scrum`
- Dev: priorizar P0 → P1 → P2
```

---

## Checklist — Wizard (antes de começar)

- [ ] URL front feito
- [ ] Mock (URL/prints) ou explicitamente ausente
- [ ] Task (texto ou link) ou explicitamente ausente
- [ ] Path front / back no workspace
- [ ] Login resolvido ou credenciais
- [ ] Escopo de navegação definido
- [ ] Rigor visual (nitpicks sim/não)
- [ ] Mobile sim/não
- [ ] Fonte da API definida
- [ ] Conflito mock vs DS resolvido (se houver)

---

## Checklist — Browser por rota

- [ ] Rota carrega sem tela branca
- [ ] Sem errors no console (ou documentados)
- [ ] Requests falhos documentados
- [ ] Screenshot feito salvo
- [ ] Screenshot proposto (se mock)
- [ ] Filtros/paginação disparam request correto (não só state local)
- [ ] Empty / loading / error states existem quando aplicável
- [ ] Links e botões principais funcionam
- [ ] Permissões: rota protegida, não só botão escondido

---

## Checklist — Design System

Usar a **Matriz de auditoria** (topo deste arquivo) + §19 de design-system.md.

Atalho mínimo (não substituir matriz completa):

- [ ] Tabela: Pagination + "Por página" + zebra + sort + ⋯ + reorder DnD (se picker)
- [ ] §11 v7: `cellVariant` highlight/normal/meta; sem cinzas soltos em células
- [ ] §11 v8: métricas/R$ com `align: center`; textos/badges à esquerda
- [ ] Linha tabela ~36px; badges compactos; sem quebra de texto
- [ ] Button Primary / Secondary corretos (§10.1)
- [ ] Tipografia escala app (§4) — não hero H1 em KPI
- [ ] Radius: input/button 8, card 12, modal 16 (§5)
- [ ] Badges §9: padding 5×12; evolução success/destructive
- [ ] Sem §18 proibidos (glow, gradiente, stats no hero, etc.)
- [ ] Ícones Lucide; ativo Primary
- [ ] Focus visível; contraste legível

---

## Checklist — Código (boilerplate Next / FDD)

- [ ] Services em `features/*/services/` ou `services/`
- [ ] Hooks encapsulam React Query
- [ ] Componentes “dumb” (sem fetch direto)
- [ ] Sem `any` desnecessário
- [ ] Nomenclatura clara (sem `data2`, `handleClick2`)
- [ ] Query keys centralizadas no hook
- [ ] Tipos alinhados ao retorno da API

---

## Checklist — REST / API

- [ ] Listagem usa endpoint de listagem com paginação server-side
- [ ] Detalhe usa `GET /recurso/:id` (não filtra lista inteira)
- [ ] Query params existem na doc/back (não inventados)
- [ ] Envelope de resposta respeitado (`data`, `total`, `page`, etc.)
- [ ] Status HTTP tratados (401, 403, 404, 422, 500)
- [ ] Nenhuma rota front-only que simula API inexistente

---

## Anti-padrões estendidos (júnior + IA)

### Rede e dados
- Inventar `/dashboard/foo/bar` que não está na OpenAPI
- `perPage=9999` ou `limit=1000` + paginação UI fake
- Filtrar array em memória quando API aceita `?expert=` / `?status=`
- Mapear campo que API não retorna (ex.: `name` em player quando só `telegram_id`)
- Tratar `{ data: [] }` como objeto
- Ignorar `totalPages` da API

### React / arquitetura
- `useQuery` no componente de página (boilerplate)
- Service nunca criado — axios espalhado
- Feature A importa hook de feature B (deveria ir pra `shared/`)
- Modal dentro de modal; ESC não fecha
- Optimistic update sem rollback

### Visual / Lovable
- Copiar purple glow / card decorativo do protótipo
- Tabela sem ⋯ quando listagem tem colunas opcionais na API
- Link azul permanente em célula quando DS pede texto normal + row click
- Alturas de linha inconsistentes entre tabelas (badges altos, botões h-7)
- Hierarquia v6/v5 legada: cinzas soltos, `dim` apagado, bold manual em KPI
- `cellVariant` ignorado — peso/cor hardcoded no JSX
- Colunas numéricas/moeda alinhadas à esquerda ou direita ad-hoc (v8)
- Histórico player ou listagem secundária com `<table>` em vez de `SpaceDataTable`
- Column reorder ausente quando picker ⋯ existe

### Segurança UX
- Botão admin escondido mas rota `/admin` aberta
- Token em constante no código

---

## Fluxo P0 (regra fixa)

```
achou P0 → pausa mental na tela → append REPORT.md + screenshot
         → snippet se relevante → continua próxima rota
```

Não abortar o tour inteiro por um P0 (salvo impossibilidade de login).

---

## Integração com PO

Após QA:

1. Usuário revisa `.task/qa-…/REPORT.md` e prints
2. Usuário chama `@po-techlead-scrum` com REPORT + contexto
3. PO skill gera task professor para dev (sem meta Scrum no corpo)

QA **não** substitui PO skill.
