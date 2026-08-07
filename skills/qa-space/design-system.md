# Space UI Design System v1.0

> **Cópia embutida** na skill `qa-space` (`~/.cursor/skills/qa-space/design-system.md`).  
> Fonte canônica no boilerplate: `docs/SPACE_DESIGN_SYSTEM.md`.  
> **Sincronizado em:** 2026-07-24 (805 linhas — inclui §11 v7 hierarquia tabular, v8 alinhamento, reorder DnD).  
> Se o projeto validado tiver cópia local, **preferir a do repo** (pode estar mais atual que esta).  
> **Arquitetura de código:** ver `AGENTS.md` no boilerplate. **Visual / UI:** este arquivo.

---

## Índice

1. [Como usar](#1-como-usar)
2. [Filosofia e princípios](#2-filosofia-e-princípios)
3. [Cores (metodologia)](#3-cores-metodologia)
4. [Tipografia](#4-tipografia)
5. [Radius](#5-radius)
6. [Espaçamento, grid e breakpoints](#6-espaçamento-grid-e-breakpoints)
7. [Bordas, elevation e motion](#7-bordas-elevation-e-motion)
8. [Ícones](#8-ícones)
9. [Badges](#9-badges)
10. [Componentes (catálogo)](#10-componentes-catálogo)
11. [Tabelas e data display](#11-tabelas-e-data-display)
12. [Overlays e popups](#12-overlays-e-popups)
13. [Layouts (shell)](#13-layouts-shell)
14. [Contextos de tela](#14-contextos-de-tela)
15. [Mobile](#15-mobile)
16. [Estados (loading, empty, error)](#16-estados-loading-empty-error)
17. [Acessibilidade](#17-acessibilidade)
18. [O que é proibido / erros comuns de IA](#18-o-que-é-proibido--erros-comuns-de-ia)
19. [Checklist de aceite](#19-checklist-de-aceite)
20. [Apêndice A — Exemplo Space (boilerplate)](#apêndice-a--exemplo-space-boilerplate)
21. [Apêndice B — Receita KPI Widget (opcional)](#apêndice-b--receita-kpi-widget-opcional)
22. [Apêndice C — Mapa técnico do boilerplate](#apêndice-c--mapa-técnico-do-boilerplate)

---

## 1. Como usar

### Para humanos
1. Leia Filosofia → Cores → Tipografia → Componentes.
2. Defina **Primary** e **Surface** do produto (hex).
3. Implemente com **Shadcn** em `shared/components/ui/` — não invente componente paralelo.
4. Use o [Checklist de aceite](#19-checklist-de-aceite) antes do PR.

### Para IAs (Lovable, Cursor, v0, etc.)
Anexe este documento no contexto e ordene:

> Siga estritamente o Space UI Design System v1.0.  
> Não invente radius, tipografia, badges ou padrões fora deste doc.  
> Primary e Surface deste projeto são: `[HEX_PRIMARY]` e `[HEX_SURFACE]`.

### O que cada projeto pode mudar
| Pode mudar | Não pode mudar |
|------------|----------------|
| Hex de **Primary** e **Surface** (+ subtoms derivados) | Escala de radius, spacing, type app |
| Logo / nome do produto | Libs oficiais (Shadcn, Lucide) |
| Conteúdo e features | Regras de Badge, Table (Pagination + Per page), anti-padrões |

### Stack oficial
| Camada | Padrão |
|--------|--------|
| UI kit | Shadcn (`base-nova`) + Base UI → `shared/components/ui/` |
| CSS | Tailwind v4 + CSS variables |
| Ícones | `lucide-react` |
| Forms | React Hook Form + Zod |
| Server state | TanStack Query |
| Fonte UI | **Inter** · mono: livre (ex. Geist Mono / system mono) |
| Tabelas complexas | TanStack Table + Shadcn Table |

---

## 2. Filosofia e princípios

### A interface deve parecer
Profissional · corporativo · moderno · minimalista · limpo · organizado · previsível · consistente · rápido · elegante.

### A interface NÃO deve parecer
Gamer · neon · cyberpunk · infantil · futurista exagerado · dribbble · cheia de efeitos · cheia de brilho · carnaval de cores.

### Princípios
1. **Primeira leitura**, não primeiro impacto.
2. Densidade de informação **sem poluição**.
3. Antes de remover dados: reduzir espaçamento e tipografia.
4. **Widget** (painel compacto) ≠ **Card** de marketing.
5. Um CTA primário por seção.
6. Nunca criar componente próprio se o Shadcn cobre o caso.
7. Customizar só: cores (tokens), radius (dentro da escala), fontes, espaçamentos.
8. A interface trabalha para o usuário — não tenta impressioná-lo.

Referências de densidade/qualidade: GitHub, Grafana, Stripe, Linear, Datadog, JetBrains.

---

## 3. Cores (metodologia)

### Regra de ouro
Cada projeto define **duas âncoras**:

```
Primary  → identidade, CTA, ícone ativo, accent de ação
Surface  → família de fundos do sistema
```

Todo o resto são **subtoms** dessas âncoras + cores de **feedback**.

> Não chame o fundo de “Secondary”. Secondary (quando existir) é ação secundária / link / info — não o background.

### Escala de superfícies (obrigatória)

```
Background  →  Surface  →  Card  →  Elevated Card  →  Modal
```

- Contraste entre camadas adjacentes: **~4–6%** (perceptível em qualquer monitor).
- Preferir diferença de tom a sombra forte.
- Light e dark **espelham** a mesma estrutura de tokens.

### Tokens semânticos

| Token | Papel |
|-------|--------|
| `--primary` / `--primary-foreground` | CTA, accent ativo |
| `--background` | fundo da página |
| `--surface` | área intermediária (sidebar, faixas) |
| `--card` / `--card-foreground` | cards e widgets |
| `--popover` | menus, dropdowns |
| `--muted` / `--muted-foreground` | fundos sutis / texto auxiliar |
| `--secondary` | botão/ação secundária (não fundo) |
| `--accent` | hover/seleção leve |
| `--destructive` | erro / perigo / delta negativo |
| `--success` | sucesso / delta positivo |
| `--warning` | alerta |
| `--info` | informação (pode derivar de um azul de marca) |
| `--border` / `--input` / `--ring` | bordas, inputs, focus |

### Escala de texto (contraste)

| Nível | Uso | Dark (exemplo) | Light (exemplo) |
|-------|-----|----------------|-----------------|
| Text Primary | títulos, KPI principal | `#F5F5F7` | `#0A1C30` |
| Text Secondary | valores secundários | `#C4C7CF` | `#3F4B5A` |
| Text Tertiary | texto comum | `#A1A6B3` | `#5C6675` |
| Text Muted | labels, hints | `#8B90A0` | `#6B7280` |

**Proibido:** usar branco puro (`#FFFFFF`) em quase todos os elementos de um dashboard/app dark.

### Feedback
Success / Warning / Destructive / Info = **somente feedback**, não identidade de marca (exceto quando Primary do projeto já é o verde de sucesso — ex. Space).

### Como plugar um projeto novo

1. Escolher Primary hex e Surface/Background hex.
2. Gerar subtoms (opacity 8–16% para badges; +4–6% lightness para Card vs Background).
3. Mapear para CSS variables em `globals.css`.
4. **Não** alterar radius, type scale, spacing ou regras de componente.

Exemplo default do boilerplate: [Apêndice A](#apêndice-a--exemplo-space-boilerplate).

---

## 4. Tipografia

### Famílias
| Uso | Fonte |
|-----|--------|
| UI (padrão) | **Inter** |
| Código / mono | Sem padronização rígida (ex. Geist Mono, `ui-monospace`) |
| Logo Space | Neulis Cursive Bold — **somente wordmark**, nunca UI |

> No boilerplate, trocar a fonte do `app/layout.tsx` de Geist Sans para **Inter** (`next/font/google`) quando alinhar implementação ao DS. |

### Escala de aplicação (obrigatória)

Base: `1rem = 16px`. Pesos permitidos: **400 / 500 / 600 / 700**. Máximo **3 pesos** por tela.

| Token | rem | px | Weight típico | Uso |
|-------|-----|-----|---------------|-----|
| `display` | 2rem | 32 | 700 | raro; hero de app |
| `h1` | 1.75rem | 28 | 700 | título de página |
| `h2` | 1.5rem | 24 | 600 | seção |
| `h3` | 1.25rem | 20 | 600 | subseção |
| `h4` | 1.125rem | 18 | 600 | título de card (não-dashboard denso) |
| `body` | 1rem | 16 | 400 | texto corrido |
| `body-sm` | 0.875rem | 14 | 400 | texto secundário |
| `label` | 0.875rem | 14 | 500 | label de formulário |
| `caption` | 0.75rem | 12 | 400 | hints, metadados |
| `overline` | 0.625rem | 10 | 600 | badges, meta compacta |

### Line-height
| Contexto | LH |
|----------|-----|
| Títulos | 1.2–1.3 |
| Body | 1.5 |
| Labels / badges | 1.25 |
| KPIs densos | 1.1 |

### Regras
- Não usar escala de **landing / H1** em painéis analíticos.
- Hierarquia por **tamanho + peso + cor**, não só por bold.
- Em pares de métricas lado a lado: preferir **mesmo size**, diferenciar por peso/cor.

---

## 5. Radius

| Token | px | Uso |
|-------|-----|-----|
| `radius-xs` | 4 | chips mínimos |
| `radius-sm` | 6 | elementos compactos |
| `radius-md` | **8** | **botões, inputs, selects** |
| `radius-lg` | **12** | **cards, toasts, widgets** |
| `radius-xl` | **16** | **modais** |
| `radius-pill` | 9999 | badges pill, switches track |

Botão padrão de referência: altura ~40px, radius 8px, font 14px/600, padding horizontal ~20px.

**Proibido:** radius &gt; 12px em cards; “tudo rounded-full” sem ser pill explícito.

---

## 6. Espaçamento, grid e breakpoints

### Escala de spacing (obrigatória)
`4 · 8 · 12 · 16 · 24 · 32 · 48 · 64` (px)

Não inventar `13px`, `18px`, `22px` de gap/padding.

### Grid
- Conceito: **12 colunas**.
- Gap padrão de grid de cards: **12px** (column); row-gap pode ser maior se houver overflow (ex. badge flutuante → **24px**).
- Alinhamento de valores em listas tipo tabela: coluna da direita alinhada.

### Containers
Seguir max-widths Tailwind (`sm` → `2xl`). Conteúdo de app/dashboard costuma usar container fluido com padding lateral `16–24px`.

### Breakpoints
Defaults Tailwind: `sm` 640 · `md` 768 · `lg` 1024 · `xl` 1280 · `2xl` 1536.

---

## 7. Bordas, elevation e motion

### Bordas
| Contexto | Valor |
|----------|--------|
| Card / divider (dark) | `1px solid rgba(255,255,255,0.06)` (até `0.10` se sumir) |
| Card (light) | `1px solid` border token (~`oklch` muted) |
| Focus | `ring` 2–3px com `--ring` |

### Elevation
- Preferir **camada de superfície + borda** a sombra.
- No máximo **1** sombra suave (ex. modal).
- **Proibido:** multi-layer shadows, glow, neomorphism.

### Motion
| Token | Valor |
|-------|--------|
| Duração curta | 150ms |
| Duração média | 200ms |
| Easing | ease / ease-out |
| | Respeitar `prefers-reduced-motion` |

**Proibido:** bounce exagerado, animações longas (&gt;400ms) em UI de produtividade.

---

## 8. Ícones

| Regra | Valor |
|-------|--------|
| Lib | **somente** `lucide-react` |
| Sizes | **16 / 20 / 24** px |
| Stroke | padrão Lucide (não misturar filled/outline sem motivo) |
| Cor default | `currentColor` ou muted |
| Cor ativa / brand / CTA | **Primary** do projeto |
| Cor sucesso / erro em evolução | success / destructive (ver Badges) |

Ícone + label: gap **4–8px**. Touch target mínimo no mobile: **44px**.

---

## 9. Badges

Padrão visual tipo “Ask AI”: fundo em **subtom**, borda e texto na **mesma cor sólida**. Padding generoso — texto **nunca** apertado.

### Anatomia comum (ambas as variantes)

| Propriedade | Valor |
|-------------|--------|
| Padding | **mínimo `5px 12px`** |
| Gap ícone–texto | **4px** |
| Shape | pill (`9999px`) |
| Font | `10px` / `600` (`overline`) |
| Border | `1px solid` = cor do texto |

### Variante A — Título / categoria

Ex.: `FTD` + ícone de carteira.

| Parte | Cor |
|-------|-----|
| Texto + ícone + borda | **PRIMARY** |
| Fundo | subtom PRIMARY (~14% opacity) |

### Variante B — Evolução / delta

Ex.: `+15.2%` / `-12.4%`.

| Parte | Cor |
|-------|-----|
| Texto + ícone + borda | **Success (verde)** se ↑ · **Destructive (vermelho)** se ↓ |
| Fundo | subtom dessa cor (~14% opacity) |

**NÃO misturar:** evolução **não** usa Primary no texto/ícone/borda.  
O significado ± vem da cor semântica **e** do sinal/ícone de seta.

### CSS de referência (Título)

```css
.badge-title {
  padding: 5px 12px;
  gap: 4px;
  border-radius: 9999px;
  font-size: 10px;
  font-weight: 600;
  color: var(--primary);
  border: 1px solid var(--primary);
  background: color-mix(in oklab, var(--primary) 14%, transparent);
}
```

### CSS de referência (Evolução ↑)

```css
.badge-delta-up {
  padding: 5px 12px;
  gap: 4px;
  border-radius: 9999px;
  font-size: 10px;
  font-weight: 600;
  color: var(--success);
  border: 1px solid var(--success);
  background: color-mix(in oklab, var(--success) 14%, transparent);
}
```

---

## 10. Componentes (catálogo)

Regra: preferir Shadcn oficial copiado para `shared/components/ui/`.  
Já no boilerplate: `Button`, `Input`.

### 10.1 Button

| Item | Spec |
|------|------|
| Quando | ações explícitas |
| Radius | `8px` (md) |
| Height default | ~40px |
| Font | 14px / 600 |
| Padding horizontal | ~20px |
| Sizes | `xs`, `sm`, `default`, `lg`, `icon*` |
| Ícone | 16–20px; cor herda |
| Estados | default, hover, focus-visible (ring), disabled, loading (spinner) |

#### Variantes oficiais

| Variant | Fundo | Borda | Texto / ícone | Uso |
|---------|-------|-------|---------------|-----|
| **Primary** (`default`) | **Primary** sólido | Primary (ou nenhuma) | `--primary-foreground` (contraste no Primary) | CTA principal da seção |
| **Secondary** | **Transparente** | **1px solid Primary** | **Primary** | Ação secundária / alternativa ao CTA |
| `outline` | transparente | border token | foreground | terciário neutro (se precisar além do secondary) |
| `ghost` | transparente | nenhuma | foreground / muted | ações discretas |
| `destructive` | destructive | destructive | foreground no destructive | exclusão / perigo |
| `link` | transparente | nenhuma | Primary + underline | navegação inline |

**Secondary (especificação visual):**
```css
.btn-secondary {
  background: transparent;
  border: 1px solid var(--primary);
  color: var(--primary);
  border-radius: 8px;
}
.btn-secondary:hover {
  background: color-mix(in oklab, var(--primary) 10%, transparent);
}
```

**Proibido:** mais de um botão Primary por seção; secondary com fundo sólido ou texto que não seja Primary.

### 10.2 Input / Textarea / Select
| Item | Spec |
|------|------|
| Radius | 8px |
| Label | `label` 14px / 500 acima do campo |
| Helper | `caption` muted |
| Erro | texto `destructive`; borda inválida |
| Height input | ~40px |

### 10.3 Checkbox / Radio / Switch
Usar Shadcn. Cor checked = Primary. Não reinventar.

### 10.4 Card vs Widget
| | Card | Widget |
|--|------|--------|
| Uso | conteúdo genérico, settings, agrupamento | painel analítico / KPI |
| Radius | 12px | 12px |
| Densidade | confortável | compacta |
| Tipografia | escala app (`h4`, body) | pode usar escala densa (ver Apêndice B) |

### 10.5 Alert / Toast / Sonner
Feedback pontual. Toast não compete com Dialog. Cores de feedback semânticas.

### 10.6 Tabs / Breadcrumb / Pagination
Navegação estrutural. Tab ativa = Primary. Ver também [Tabelas](#11-tabelas-e-data-display) para Pagination de dados.

### 10.7 Sidebar / Header / Footer
Ver [Layouts](#13-layouts-shell).

### 10.8 Skeleton / Progress / Spinner
Loading states — ver [Estados](#16-estados-loading-empty-error).

### 10.9 Avatar / Separator / Accordion
Shadcn padrão; Separator usa border token.

---

## 11. Tabelas e data display

### Stack
| Papel | Lib |
|-------|-----|
| Markup / estilo | **Shadcn Table** |
| Sort, filter, row model, server state | **TanStack Table** |

**Proibido:** AG Grid, MUI DataGrid, tabelas HTML sem padrão DS.

### Obrigatório em toda listagem tabular
1. **Paginação** (Anterior · páginas · Próximo)
2. **Per page** — seletor de itens por página
3. **Zebra striping** — linhas alternadas com cores do projeto
4. **Sort** — cabeçalhos clicáveis nas colunas ordenáveis (ícone Asc/Desc)
5. **Column picker (⋯)** — menu “três pontinhos” no canto direito do header/toolbar para mostrar/ocultar colunas opcionais

| Item | Padrão |
|------|--------|
| Opções Per page | `10 · 25 · 50 · 100` |
| Default Per page | **25** |
| Preferência | paginação **server-side** em produtos reais |
| Zebra | obrigatória |
| Sort | clicável no header; indicador visual Asc/Desc |
| Column picker | ícone `MoreHorizontal` (⋯) · DropdownMenu com checkboxes por coluna |

Não existe, como padrão do DS, listagem tabular “infinita” ou sem controles de página.

### Column picker (⋯)
- Sempre presente em tabelas com **mais de 4 colunas** (ou quando houver colunas secundárias ocultáveis).
- Posição: **`headerRight` do WidgetShell** (título do card), ao lado dos botões de ação (Novo, filtros, Associar) — **nunca** uma coluna vazia no `thead` só para o ⋯, e **nunca** uma faixa/toolbar órfã acima da tabela.
- Colunas **obrigatórias** (ex.: nome/ID da entidade, ações) não podem ser desmarcadas.
- Estado de colunas: preferir persistir em `localStorage` por tabela (`tableId`).
- Menu: Shadcn `DropdownMenu` + `Checkbox` / `DropdownMenuCheckboxItem`.

### Coluna Ações
- Header e células alinhados à **esquerda** (`text-left` / `justify-start`) dentro da coluna.
- Largura: `w-[1%] whitespace-nowrap` (coluna estreita, colada à direita) — evita a coluna engordar em tabelas de 2 colunas e o botão “flutuar” no meio.

### Densidade e padding
| Elemento | Padrão |
|----------|--------|
| Padding célula (`td`/`th`) | **8px 12px** (`py-2 px-3`) — denso, sem “ar” vertical exagerado |
| Altura de linha | ~36–40px |
| Sticky primeira coluna | permitido; fundo **igual** à linha (zebra/hover), **sem** caixa/retângulo contrastante no header |

### Zebra (cores do projeto)

| Linha | Fundo |
|-------|--------|
| Par (`nth-child(even)`) | subtom de **Surface** / `muted` (~4–8% acima do fundo da tabela) |
| Ímpar | fundo da tabela = **Card** ou Surface limpo |
| Hover | subtom de **Primary** (~6–10% opacity) |
| Header | Surface um degrau acima + texto 600 · **sem** fundo de célula isolado |

Usar **tokens do projeto** (Primary/Surface), nunca cinzas soltos fora da metodologia.

```css
.table tbody tr:nth-child(even) {
  background: color-mix(in oklab, var(--muted) 60%, var(--card));
}
.table tbody tr:hover {
  background: color-mix(in oklab, var(--primary) 8%, var(--card));
}
```

### Anatomia
```
[ Toolbar: busca / filtros / ações / ⋯ column picker ]
[ Table: thead (sort) + tbody zebrado ]
[ Footer: "X–Y de Z" | Per page | Pagination ]
```

### Proibido em tabelas
- Cards empilhados no lugar de listagem tabular (Campanhas, Domínios, Usuários, Redirects, etc.)
- Header sticky com `bg-card` criando “quadrado” na primeira coluna
- Padding alto tipo marketing (`py-4`+ nas células)
- Listagem sem sort quando a coluna é numérica/comparável

### Estados
- Loading: Skeleton rows
- Empty: empty state com CTA
- Error: alert + retry

### Tipografia na tabela
| Elemento | Token |
|----------|--------|
| Header | `caption` / `body-sm` · 600 · muted→foreground |
| Célula | `body-sm` (14px) |
| Números | tabular-nums quando fizer sentido |

### Hierarquia visual em widget tabular (v7)
Quando a tabela vive dentro de um **WidgetShell**, a hierarquia segue o [Apêndice B](#apêndice-b--receita-kpi-widget-opcional). **Uma cor base** (`#E2E2E2`) com ênfase por **peso** (destaque) + **opacidade leve** (secundário) — sem cinzas `#8B90A0` / `#C4C7CF` em células de dados.

| Papel | Size | Weight | Opacidade | Token |
|-------|------|--------|-----------|-------|
| Título do widget | 14px | 600 | 100% `#E2E2E2` | `COLOR_TITLE` |
| Header de coluna | 12px | 600 | `#A0A5B3` | `TABLE_HEAD_CLS` · uppercase opcional |
| Célula **highlight** | 14px | 600 | 100% `#E2E2E2` | = título widget; identidade + métricas |
| Célula **normal** | 14px | 400 | ~75% `#E2E2E2` | coluna sem destaque + dados padrão |
| Célula **meta** | 12px | 400 | ~80% `#E2E2E2` | IDs, datas, Telegram |
| Badge (ROI, etapa) | 10px | 600 | §9 | não competir com 14px |

**Regras:**
- Ênfase via `cellVariant` centralizado (`highlight` · `normal` · `meta`) — **proibido** `font-medium`/`font-semibold` ad-hoc.
- **Proibido** cinza `#8B90A0` ou `#C4C7CF` em células — hierarquia via opacidade, não cor separada.
- Coluna “sem destaque”: `cellVariant: "normal"` (ex.: Experts → **Campanhas**; Campanhas → **Expert**).
- Colunas copiáveis (Telegram ID, nome de campanha): `CopyButton` / `CopyableCell` em `shared/` — ghost `h-6 w-6`, toast “Copiado”, `stopPropagation` no clique.
- **Players:** colunas **Nome** e **Campanha** = `highlight` (mesmo destaque).
- **Histórico do player:** obrigatoriamente `SpaceDataTable` (não `<table>` HTML ad-hoc).

**Checklist de aceite visual:**
- [ ] Título widget = highlight (100%) > normal (~75%) > meta (12px ~80%)
- [ ] Coluna sem destaque legível (não apagada como v6 `dim`)
- [ ] Header de coluna perceptível (`#A0A5B3`), menor que dado 14px
- [ ] Picker ⋯: checkbox compacto (`h-3 w-3`, ícone `size-2`)

### Alinhamento de colunas (v8)

Regra única via `meta.align` em `SpaceDataTable` — header e célula seguem o mesmo alinhamento (incl. botão de sort).

| Tipo de conteúdo | `meta.align` | Exemplos |
|------------------|--------------|----------|
| Texto / identidade | `left` (default) | Nome, Campanha, Expert, Gestor, Ad Set |
| Badge / status | `left` | Etapa, ROI badge, Status |
| Contagem / percentual | `center` | FTDs, Cadastros, Campanhas (count), CTR |
| Monetário (R$) | `center` | Depósito, Investimento, CPA, CPM |
| Meta (ID, data, Telegram) | `left` | IDs truncados, datas, Telegram |
| Duração formatada | `left` | Tempo (`2h 17min`) |
| Ações | `left` | coluna estreita à direita (§ Coluna Ações) |

Helper recomendado: `col.text()` · `col.numeric()` · `col.money()` · `col.meta()` · `col.deemphasis()` em `tableColumnMeta.ts`.

**Regras:**
- **Proibido** mix ad-hoc: coluna numérica/moeda sem `align: "center"`.
- Badge ROI permanece `left` (conteúdo badge, não número solto).
- Migrar legado `align: "right"` → `"center"` em métricas.

**Checklist de aceite visual:**
- [ ] Textos e badges sempre à esquerda
- [ ] Métricas e R$ centralizados (header + célula)
- [ ] Histórico do player com zebra/tokens v7

### Reorder de colunas (drag-and-drop)
Obrigatório em listagens tabular com column picker (⋯):

| Superfície | Comportamento |
|------------|---------------|
| **Header (thead)** | grip `GripVertical` + drag horizontal; colunas `locked` imóveis nas extremidades |
| **Menu ⋯** | lista sortable com grip + checkbox de visibilidade |

- Persistir ordem por `tableId` em `localStorage` (`sdt:{tableId}:order`).
- Colunas locked: identidade (esquerda) + ações (direita) — **nunca** draggable.
- Merge ordem salva com colunas novas (append ids desconhecidos).

---

## 12. Overlays e popups

| Necessidade | Componente | Quando |
|-------------|------------|--------|
| Confirmação / formulário modal | **Dialog** | foco total; ação destrutiva; form curto |
| Painel lateral / filtros / detalhe | **Sheet** | mobile e desktop; conteúdo mais longo |
| Menu contextual leve | **Dropdown Menu** / **Popover** | ações da linha, menus |
| Dica | **Tooltip** | só hover/focus; texto curto |
| Hover card rico | **Hover Card** | preview |

**Proibido:** modal/popup custom fora do Shadcn; múltiplos dialogs empilhados sem necessidade.

Radius do Dialog: **16px**. Sheet: edge-to-edge no mobile.

---

## 13. Layouts (shell)

### Sidebar
- Fundo: Surface (ou subtint de Surface).
- Item ativo: fundo Primary ~10–14% + texto/ícone Primary.
- Ícones 20px; label `body-sm`.

### Header
- Título de página = `h1` ou `h2` conforme hierarquia.
- Filtros à direita; controls densos.

### Footer (produto Space / boilerplate)
| Viewport | Conteúdo |
|----------|----------|
| ≥ `md` | Logo completo |
| Compacto | Ícone `</>` + “Space®” |
| Favicon | `/brand/icon.svg` |

Outros produtos: substituir assets; manter a lógica logo completo vs ícone.

---

## 14. Contextos de tela

| Contexto | Densidade | Notas |
|----------|-----------|--------|
| Dashboard analítico | Alta | widgets; ver Apêndice B se KPI denso |
| CRUD / backoffice | Média | tabelas com Pagination + Per page |
| Auth | Baixa | foco no form; Primary no CTA |
| Settings | Média | cards + forms |
| Marketing / landing | Baixa | display/h1 ok; **não** misturar com escala de widget |

---

## 15. Mobile

- Touch target mínimo: **44×44px**.
- Preferir **Sheet** a Dialog full-screen quando possível.
- Tipografia: mesma escala; reduzir padding de página (`16px`).
- Sidebar → drawer/Sheet.
- Tabelas: scroll horizontal permitido; Pagination permanece acessível.

---

## 16. Estados (loading, empty, error)

| Estado | Padrão |
|--------|--------|
| Loading | Skeleton no shape do conteúdo; spinner só em ações pontuais |
| Empty | Ícone muted + título `h4` + caption + CTA opcional |
| Error | Alert destructive + mensagem clara + retry |
| Disabled | opacity reduzida; cursor not-allowed; sem hover ativo |

---

## 17. Acessibilidade

- Contraste de texto: meta **WCAG AA**.
- Focus visible sempre (`ring`).
- Não depender só de cor para status (usar ícone + texto em deltas).
- `prefers-reduced-motion`.
- Labels associados a inputs (`Label` + `htmlFor` / aria).

---

## 18. O que é proibido / erros comuns de IA

### Visual
- Gradientes decorativos, glassmorphism, neomorphism, blur sem necessidade
- Sombras fortes / glow / neon
- Radius &gt; 12px em cards
- Branco puro em todos os textos
- 4+ pesos de fonte ou 6+ cores de accent na mesma tela
- Cards dentro de cards
- Padding/margin aleatórios fora da escala `4…64`
- KPI / número principal em escala de H1 de landing
- Badge com texto apertado (padding &lt; 5×12)
- Badge de evolução usando Primary no lugar de success/destructive

### Comportamento / estrutura
- Componente custom quando Shadcn resolve
- Tabela sem Pagination, sem Per page, sem zebra, sem sort ou sem column picker (⋯)
- Secondary button sem borda/texto Primary (ou com fundo sólido “falso primary”)
- Mais de um CTA Primary por seção
- Centralizar conteúdo de dashboard sem motivo
- Desperdiçar espaço vertical em painéis densos

---

## 19. Checklist de aceite

Antes de merge / entrega Lovable:

- [ ] Primary e Surface do projeto aplicados; subtoms consistentes
- [ ] Escala de superfícies Background → Card perceptível
- [ ] Tipografia só nos tokens da escala app (ou Apêndice B se widget KPI)
- [ ] Radius: botão/input 8 · card 12 · modal 16
- [ ] Spacing na escala 4–64
- [ ] Badges: padding ≥ 5×12; Título = Primary-soft; Evolução = success/destructive-soft
- [ ] Tabelas com Pagination + Per page (default 25) + **zebra** + **sort** + **column picker (⋯)** (cores do projeto)
- [ ] Button Primary sólido; Secondary = borda + texto Primary, fundo transparente
- [ ] Fonte UI = **Inter**
- [ ] Ícones só Lucide; ativo = Primary
- [ ] Dialog/Sheet/Popover conforme catálogo
- [ ] Sem gradiente/glass/glow/neon
- [ ] Focus ring e contraste AA
- [ ] Empty/loading/error tratados

---

## Apêndice A — Exemplo Space (boilerplate)

Valores default deste repositório. **Outros projetos trocam os hex**, mantêm a metodologia.

### Tokens de marca

| Token | Hex | Uso |
|-------|-----|-----|
| Primary | `#35C178` | CTA, brackets do logo, success alinhado à marca |
| Info / secondary accent | `#2F75BA` | slash do logo, links, info |
| Surface / Background dark | `#0A1C30` | fundo dark (ou subtoms) |
| Wordmark light-bg | `#0A1C30` | texto do logo em fundo claro |
| Wordmark dark-bg | `#FFFFFF` | texto do logo em fundo escuro |

### Assets

| Arquivo | Uso |
|---------|-----|
| [`/brand/logo-dark.svg`](../public/brand/logo-dark.svg) | logo em fundo escuro (wordmark branco) |
| [`/brand/logo-light.svg`](../public/brand/logo-light.svg) | logo em fundo claro (wordmark navy) |
| [`/brand/icon.svg`](../public/brand/icon.svg) | ícone `</>` — favicon, sidebar compacta, rodapé compacto |
| PNGs `logo-on-*.png` | exports raster |

### Rodapé Space
- Desktop: logo completo  
- Compacto: `icon.svg` + “Space®”  
- Favicon: `icon.svg`

---

## Apêndice B — Receita KPI Widget (opcional)

> **Não é regra universal do DS.**  
> Use só quando o produto precisar de **widgets de KPI densos** (ex. dashboard Action Acquisition).  
> O núcleo do DS continua sendo a [escala de aplicação](#4-tipografia).

### Quando usar
Grid de métricas analíticas B2B onde a hero não pode ser 100% consumida por cards altos.

### Tipografia densa do widget

| Papel | Size | Weight | Cor (dark) |
|-------|------|--------|------------|
| KPI principal | 16px | 700 | Text Primary |
| KPI secundário (par) | 16px | 500 | Text Secondary |
| Título (se não for badge) | 12px | 600 | — |
| Labels | 10px | 400 | Muted |
| Valores footer | 12px | 500 | Text Tertiary |
| Badges | 10px / 600 | ver §9 |

Par de KPIs: **mesmo size**; hierarquia por peso + cor. Footer **sempre menor** que KPIs.

### Densidade
- Padding interno ~12px  
- Gap grid: column 12px; row **24px** se badge flutuante  
- Altura alvo ~160–175px  
- Zonas: Header ~10% · KPIs ~35% · Detalhes ~55%

### Superfícies (exemplo dark analítico)
- Página `#0E0C12` · Card `#1C1826` · Border `rgba(255,255,255,0.06)` · Radius 12px

### Badges no widget
Seguir **§9 Badges** (Título = Primary-soft; Evolução = success/destructive-soft; padding 5×12).

---

## Apêndice C — Mapa técnico do boilerplate

| Item | Onde |
|------|------|
| Tokens CSS | [`app/globals.css`](../app/globals.css) |
| Shadcn config | [`components.json`](../components.json) |
| UI components | [`shared/components/ui/`](../shared/components/ui/) |
| Utils `cn()` | [`shared/lib/utils/utils.ts`](../shared/lib/utils/utils.ts) |
| Regras de arquitetura | [`AGENTS.md`](../AGENTS.md) |
| Docs internas | `/boilerplate-docs` |
| Brand assets | [`public/brand/`](../public/brand/) |

### Gap conhecido (implementação vs spec)
O boilerplate ainda pode ter `--radius: 0.625rem` (~10px) em `globals.css`.  
**Spec oficial deste DS:** base de botão/input = **8px**. Alinhar tokens na implementação como follow-up.

---

## Versionamento

| Versão | Data | Notas |
|--------|------|-------|
| 1.0 | 2026-07-16 | Constituição inicial: metodologia Primary/Surface, badges, tables Pagination+PerPage, apêndice KPI |

---

*Space Software — Space UI Design System v1.0*
