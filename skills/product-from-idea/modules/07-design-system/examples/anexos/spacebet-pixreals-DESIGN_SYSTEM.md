# Design System — PixReals

> Constituição visual do produto. Cada regra: **Valor · Uso · Porquê psicológico · Fonte**.  
> Tokens: `.docs/tokens.dtcg.json`. Skill: design-system-forge.  
> Fonte visual = evidência, **não** lei. Fora-do-padrão → Apêndice A.

---

## 0. Meta

| Campo | Valor |
|-------|-------|
| Produto | PixReals |
| Contexto (B2B / B2C / híbrido) | **B2C** cassino online BR (PIX). Admin/CRUD **não** existe na fonte visual; patterns A–D/F entram como **lei pretendida**. |
| Fonte visual (URL / Lovable id) | Preview `https://aesthetic-play-hub.lovable.app` · id-preview `https://id-preview--6c770339-3b36-499a-b653-775cb70dab53.lovable.app` · Lovable `6c770339-3b36-499a-b653-775cb70dab53` (commit `4557e044`) |
| DS de gosto/método | Space UI Design System v1.0 (`docs/design-system.md`) — **método**, não tokens Space |
| Versão | 0.2.1-apply-mini-a |
| Tokens DTCG path | `.docs/tokens.dtcg.json` |

### Prioridade de verdade

1. Decisões humanas / escopo / **marca PixReals** (`#CFA551`)  
2. Gosto Space (`ui-gosto.md`) — preenche buracos; **não** troca o gold da marca  
3. Código/tokens do produto (implementação pode estar atrasada = dívida Apply)  
4. Space DS (método, escalas, tabelas admin) — **admin ≠ energia cassino**  
5. Mock (hierarquia/campos — nunca glow/ruído como lei)

---

## 1. Filosofia

### Deve parecer
Cassino BR **premium e limpo**: dark frio, um dourado de marca, PIX confiável, catálogo denso sem carnaval. Profissional o bastante para depósito; rápido o bastante para jogar.

### Não deve parecer
Neon / cyberpunk / glow multi-camada / dribbble gamer / laranja+amarelo+verde competindo / “mais um CTA dourado por faixa”. Não copiar o verde Space nem o navy do boilerplate.

### Princípios (com porquê)

1. **Um Primary.** O dourado da logo (`#CFA551`) é o único brand. Von Restorff + Selective Attention.  
2. **Primeira leitura, não primeiro impacto.** Aesthetic-Usability via clareza, não via brilho.  
3. **Um CTA primary por seção de conteúdo / uma urgência por viewport.** Cadastro deslogado no chrome: **Header Cadastrar** é o destaque canônico (Primary sólido em todos os breakpoints); o FAB replica o mesmo variant como atalho de polegar — **não** outline. Hick, Serial Position, Fitts.  
4. **Camadas de superfície, não sombra.** Common Region. Glow = proibido.  
5. **Nested fill = `surface-2`, nunca `background` dentro de card/modal.** Prägnanz.  
6. **Touch ≥ 44 no chrome móvel.** Fitts.  
7. **Prova social parcimoniosa (global vs contextual):** máx. **1** superfície **global** por viewport (ticker **ou** painel Maiores ganhos). Lista **nested** dentro do Jackpot = contextual (`P-JACKPOT-WINNERS`) — **não** conta como segunda global. Cognitive Load + ui-gosto §5.5.  
8. **PIX e cadastro seguem o mental model do mercado BR** (chips de valor, CPF, sheet no mobile). Jakob.
9. **Admin ≠ cassino.** Tabelas A–D/F usam densidade corporativa Space (zebra, pagination) — sem tile 3:4, jackpot ou FAB na operação.

### Gosto Miguel vs este produto (Fase A)

| Gosto (`ui-gosto`) | Lei PixReals |
|--------------------|--------------|
| Cadastro deslogado = Primary sólido | **ALIGNED** (humano + gosto). Outline = rejeitado. |
| 1 Primary forte na dobra; anti header+FAB no mesmo papel | **Exceção nomeada (humano 2026-09-21):** ambos Primary; **destaque canônico = header**. FAB = atalho Fitts, não o isolado. Gosto P2 **não** rebaixa o header. |
| Inter + Lucide | **ALIGNED** (Inter ainda não carregada no preview = Apply) |
| Encaixe > glow; brand só em CTA | **ALIGNED** |
| Par Entrar/Cadastrar mesma altura/radius idle+hover | **Lei reforçada** — código Entrar `py-2` vs Cadastrar `h-10` = dívida |
| Auth mobile sheet; sem poço desktop | **ALIGNED** no DS |
| Seleção “borda comida” consistente | **Lei reforçada** (§7 Border) |
| Admin ≠ energia cassino | **ALIGNED** (P-COL-* pretendido) |
| Prova social global 1×; nested jackpot ≠ duplicata (§5.5) | **Mini-A 0.2.1:** `P-JACKPOT-WINNERS` + `P-WINS` global; ticker chrome off |

---

## 2. Fundamentos psicológicos

| Lei (Laws of UX) | Decisão neste produto |
|------------------|------------------------|
| Aesthetic-Usability | Dark frio + 1 dourado + radius 8 faz o cassino parecer “sério” (depósito) sem neon. |
| Jakob | Shell de iGaming BR: header + ticker + hero 16:6 + row de jogos + BottomNav FAB; auth em sheet; depósito PIX com chips. |
| Hick / Choice Overload | 8 categorias no rail; 6 chips de depósito; 3 bônus (1 featured no mobile + accordion). Sem 12 CTAs dourados. |
| Fitts | Cadastrar/Menu/Depositar `h-11` (44) no mobile; FAB 48 com ring; CTA de form `py-3` full-width. |
| Proximity / Common Region / Similarity | Card `border + radius 8 + bg-card`; sidebar item ativo = fill primary/15; nested = surface-2. |
| Von Restorff | Destaque canônico de cadastro = **Header Cadastrar** Primary sólido. FAB é o mesmo variant (exceção nomeada), não um segundo “único” isolado. Chip Popular no R$ 50; ribbon no GameCard (máx. 2). Faixa de bônus = urgência temporária, CTA inverso. |
| Peak-End / Goal-Gradient | Auth mostra bônus no topo; depósito mostra “Saldo total para jogar” no footer sticky antes do PIX. |
| Zeigarnik | **Uma** faixa de countdown (BonusCountdownBanner), dismissível, sem loop falso ao zerar. Sem Sticky CTA extra na Home. |
| Doherty | Hover/focus ≤ 200ms; marquee contínuo (reduzido se `prefers-reduced-motion`); jackpot tick 110ms = **dívida** (ver Apêndice A). |
| Cognitive Load / Miller / Chunking | Home em blocos (hero, jackpot, recomendados, rows). Sidebar ≤ 8 categorias. Badges de jogo ≤ 2. |
| Tesler / Mental Model / Postel | CPF mascara e auto-preenche nome/nascimento; valor PIX aceita digitação pt-BR e normaliza no blur; outputs limpos (BRL tabular). |

---

## 3. Cores (F1)

> App é **dark-only** (`color-scheme: dark` no `:root` efetivo). Light tokens do bloco Shadcn inicial são **legado morto** — não usar.

### Brand
| Token | Hex | OKLCH | Uso |
|-------|-----|-------|-----|
| primary | `#CFA551` | `oklch(0.744 0.113 83)` | CTA sólido, FAB, tab ativa, chip selecionado, ribbon default, focus ring |
| primary-foreground | `#0C121A` | `oklch(0.18 0.02 260)` | Texto/ícone **sobre** primary |

**Valor:** um hex. **Uso:** ação principal da seção e identidade da logo. **Porquê:** Von Restorff. **Fonte:** `src/styles.css` + `mem/design/system.md` + logo. Aliases `--brand`, `--accent-orange`, `--accent-yellow` **colapsam no mesmo hex** — ruído de nome, não segundo accent. Lei: usar só `primary`.

### Surfaces (hex **cada** degrau)
| Token | Hex | Uso |
|-------|-----|-----|
| background | `#0C1015` | Página, header/bottomNav translúcidos (`/85`–`/95`) |
| surface | `#111419` | Sidebar / coluna de bônus no depósito desktop / wash de auth |
| card | `#15181F` | Cards, jackpot, ticker (`card/60`), overlay form |
| surface-2 | `#171B21` | Inputs nested, provider tiles, segmented control track, resumo |
| surface-3 | `#20242C` | Hover de superfície (accent medido ~ este degrau) |
| muted | `#1B1F26` | Fill de secondary / item inativo |
| modal | `#15181F` | Painel do overlay (= card). Overlay escuro: `rgba(0,0,0,0.65)` + blur |

Empilhar **sempre** `background → surface → card → surface-2` (dentro) → overlay. Contraste adjacente perceptível (~4–8% L). **Proibido** `bg-background` dentro de card/modal.

### Texto / border
| Token | Hex | Uso |
|-------|-----|-----|
| foreground | `#F3F5F8` | Títulos, body, valores |
| muted-foreground | `#999FA6` | Labels auxiliares, placeholders compostos, nav inativa |
| border | `rgba(255,255,255,0.08)` | Cards, inputs, dividers. Hero pode usar `white/10` (mesmo papel) |

Contraste medido fg/bg ≈ **17:1**; muted/bg ≈ **7.1:1** (AA). Primary sobre primary-foreground ≈ **8.2:1**.

### Feedback (warning **obrigatório**)
> Warning **≠** CTA. Hue 45° vs primary 83° (∆ ≈ 38°) — não é o gold da marca.

| Token | Hex | Uso |
|-------|-----|-----|
| success | `#3FC168` | PIX, ganhos, Depositar soft, “Auto” CPF, saldo bônus |
| warning | `#FF7F3B` | Alerta / expiração / limite. Nunca botão de cadastro/depósito. |
| destructive | `#EE343B` | Erro de form, ação destrutiva, delete |
| live | `#EE343B` | Dot “Ao Vivo”, ribbon Hot, +18. **Mesmo hex** de destructive; papel distinto (status vs erro). Sempre ícone/texto + cor. |

**Fonte success/live/destructive:** `src/styles.css`. **Fonte warning:** inferido no Forge e **confirmado pelo humano** em 2026-09-21 (`#FF7F3B`). Token `--warning` ainda não existe no CSS (dívida de Apply).

### Do / Don’t · regra de aninhamento

**Do**
- Cadastro deslogado = **Primary sólido** (header e FAB). Outline primary **não** é o Cadastrar.
- Ganhos / PIX em **success**. Hot/live em **live** + ícone Flame/dot.
- Nested: `bg-surface-2` + `border-border`.
- Faixa de bônus: fill primary + CTA interno **inverso** (ver P-BONUS-STRIP).

**Don’t**
- Glow, `shadow-*-glow`, `live-pulse` visível, gradient de UI (só foto promocional).
- Texto primary em parágrafos (só CTA/accent de ação).
- Warning ≈ gold. Segundo accent laranja/amarelo (aliases mortos).
- Branco puro `#FFFFFF` como texto de UI (usar foreground).

---

## 4. Tipografia (F2)

**Família:** Inter (lei) · fallback `ui-sans-serif, system-ui`. **Mono:** system mono para jackpot/countdown.  
**Pesos permitidos:** **400 / 600 / 700** (gosto: máx. 3 por tela). Sem `500` como papel de UI.  
**Proibido:** `font-black`, `font-extrabold`, 4º peso, uppercase+tracking fora de ribbon/overline 10px.

> **Humano (2026-09-21):** Inter confirmada como família oficial (melhor que system-ui). **Dívida de implementação:** o preview ainda não carrega Inter.

| Papel | Size | Weight | Line-height | Tracking | Uso | Porquê |
|-------|------|--------|-------------|----------|-----|--------|
| Display | 32px | 700 | 1.2 | 0 | Hero de página / jackpot ≥ sm | Peak; raro |
| H1 | 28px (`text-2xl` → `sm:text-3xl` 30/32 ok) | 700 | 1.14–1.2 | tight | Título de overlay auth/depósito | Hierarquia |
| H2 | 20px (`text-lg` 18 → `sm:text-xl` 20) | 700 | 1.2 | tight | Seção da Home | Chunking |
| H3 | 16px | 600 | 1.25 | 0 | Subseção / título compacto | |
| Body | 14px | 400 | 20px (1.43) | 0 | Texto corrido, botão default | Jakob |
| Label | 12px | 600 | 1.25 | 0 | Label de form — **não** uppercase | Working Memory |
| Caption | 12px | 400 | 1.33 | 0 | Helper, subtítulo de row | |
| Ribbon | 10px | 700 | 1.2 | 0.04em | Badges, overline (Categorias, Hot, Popular) — **único** uppercase | Von Restorff |
| Money | 14px+ | 700 | 1.1–1.2 | 0 | BRL com `tabular-nums`; jackpot pode subir a 48px (`text-5xl`) só neste bloco | Mental Model PIX |

**Fonte:** `mem/design/system.md` + medido em Header/Auth/Jackpot.  
**Jackpot `text-3xl/4xl/5xl`:** exceção de Display **só** no bloco JackpotCounter — não copiar para KPIs genéricos.

---

## 5. Radius (F5)

| Token | px | Uso |
|-------|----|-----|
| sm | 4 | Chip, ribbon, badge Popular, overline, rank fora do card |
| md | 8 | **Padrão:** botão, input, card, game tile, jackpot, provider, segmented |
| lg | 12 | Overlay **desktop** (Auth/Deposit `sm:rounded-[12px]`) |
| xl | 16 | Sheet **mobile** topo (`rounded-t-[16px]`); hero **não** usa 16 no produto atual (hero = 8) |
| full | 9999 | Só: FAB, dots de live, close circular, switch track |

`--radius` CSS efetivo = `0.5rem` (8px).

**Proibições:** `rounded-xl/2xl/3xl` genérico; card > 8px; “tudo pill”; radius 6 (`rounded-md` Shadcn) em control — **normalizar para 8** (provider tile `rounded-md` na sidebar = dívida).

**Porquê:** Similarity + Prägnanz. **Fonte:** `styles.css` `@theme` + `mem/design/system.md`. Hero radius 8 extraído (mem citava 16 “hero only” — **não** corresponde ao código; lei = 8 no tile/hero).

---

## 6. Spacing / grid / breakpoints / proporção (F3 + F4)

### Escala primitiva
`4 · 8 · 12 · 16 · 24 · 32 · 48 · 64` px — off-scale **proibido** no mapa semântico.

### Mapa semântico (só valores da escala)
| Contexto | Padding / gap | Token |
|----------|---------------|-------|
| Page | px 16 (`px-4`); py 16–24 | `space.page` 16 |
| Section | gap vertical 24 | `space.section` 24 |
| Card | padding 16–24 | `space.card` 24 |
| Control | px 16, gap ícone 8 | `space.control` 16 |
| Chip | px 8, py 8 | `space.chip` 8 |
| Grid jogos (row) | gap 12 | `space.12` |
| Container | `container` Tailwind + `max-w-6xl` em shells | — |

### Exceções nomeadas (inevitáveis)
| Token | px | Porquê | Fonte |
|-------|-----|--------|-------|
| `control.height` | 40 | Botão/input `h-10` — Fitts desktop, Space método | `button.tsx`, `input.tsx` |
| `touch.target` | 44 | WCAG/Fitts chrome móvel (`h-11` Menu/Cadastrar/Depositar) | `Header.tsx` |
| `header.height-sm` | 56 | `h-14` header < sm; ≥ sm = **64** (na escala) | `Header.tsx` |

> Medido off-scale **rejeitado** (não vira lei): `space-y-7` 28 → usar 24; `p-7` 28 → 24; `gap-2.5` 10 → 8 ou 12; `py-2.5` 10 → 8 ou 12. Ver Apêndice A.

### Breakpoints
Produto usa Tailwind default. Corte **estrutural** de shell = **`lg` 1024**.

| Token | px | O que muda neste breakpoint |
|-------|-----|------------------------------|
| sm | 640 | Header `h-16`; Entrar visível; recommended 2 colunas; overlay vira dialog centrado (`sm:items-center`, radius 12) |
| md | 768 | Auth/Deposit **split 42/58** com arte full-bleed; BiggestWins 3 col |
| lg | 1024 | **Shell desktop:** LeftSidebar; nav do header; some BottomNav, CategoryRail, Menu, Depositar-ícone; hero layout 2/3+1/3. Cadastrar já é sólido em todos os bp. |
| xl | 1280 | GameRow cards um pouco maiores; BiggestWins 4 col |
| 2xl | 1536 | Gap sidebar `gap-6` |

### Proporções de domínio
| Elemento | Ratio / split | Uso |
|----------|---------------|-----|
| Tile / GameCard | **3:4** | Thumb de jogo; miniatura de Maiores ganhos `w-12` |
| Hero / promo / recomendados | **16:6** | Banner home, depósito desktop topo, recommended |
| Auth split | **42% arte / 58% form** a partir de `md` | AuthCard / DepositCard |
| Hero desktop conjunto | ~2/3 carrossel + 1/3 dois banners empilhados, altura via `cqw` | `HeroBanners.tsx` |
| FAB | círculo 48 + `ring-4 ring-background` | BottomNav |
| BottomNav | 5 colunas iguais | Chrome mobile |

---

## 7. Bordas / elevation / motion (F6 + F7)

### Border
**Valor:** `1px solid rgba(255,255,255,0.08)` (`border-border`).  
**Onde:** card, input, overlay, rail, provider, ticker.  
**Focus input:** `border-primary`, **sem ring** (lei extraída do Input).  
**Focus button:** `ring-2 ring-primary/40` + offset 2 sobre background.  

**Seleção / “borda comida” (gosto P8 — 1 padrão, sem glow):**
- Default: borda neutra 1px `border`.
- Ativo/selecionado (chip valor, tab segmented, category chip, item sidebar): **substitui** a borda por `1px solid primary` **ou** fill `primary/15` + ícone/texto primary — nunca glow, nunca carpete 100% num card grande.
- Amount chip selecionado no depósito: fill **Primary sólido** (é CTA de valor, não carpete de página).
- Proibido misturar ring + fill brand + glow como “seleção”.

### Elevation
| Token | Valor | Uso |
|-------|-------|-----|
| shadow-card | `0 2px 8px -4px oklch(0 0 0 / 0.35)` | Card, game tile, banner |
| shadow-overlay | `shadow-2xl` neutro | Auth/Deposit/drawer |
| glow | **none** | `--shadow-orange-glow` e `--shadow-brand-glow` estão **zerados** — manter mortos |

**Proibido:** glow / multi-shadow colorido / neon / neomorphism. Preferir degrau de superfície + borda.

### Motion
| Token | ms / easing | Uso |
|-------|-------------|-----|
| instant | 0 | reduced-motion |
| fast | 150ms ease-out | cores (`transition-colors`) |
| base | 200ms ease | hover tile (`-translate-y-0.5`), overlay fade, badge chip max-width |
| slow | 220ms ease-out | drawer `slide-in-from-left` |
| marquee | 120s linear infinite | WinnersTicker apenas |
| hero fade | 700ms opacity | troca de slide — **teto 400ms pretendido** (Doherty); 700 = dívida a normalizar |

`prefers-reduced-motion`: desliga `animate-marquee`, `live-pulse`, `pulse`, `fade-in`; chip de jogo **não** expande no hover.

**Proibido:** bounce, confete, pulse luminoso, animação > 400ms em UI de ação (hero 700 e jackpot 110ms = Apêndice A).

---

## 8. Ícones (F8)

| Campo | Valor |
|-------|-------|
| Família | **somente** `lucide-react` |
| Stroke | 2 (default Lucide); Gift do welcome pode 2.2 — não misturar filled/outline sem motivo. Play no overlay do GameCard pode `fill-current`. |
| Sizes | **16** em botão/form; **20** nav/header/FAB; **24** só ênfase (ícone jackpot 24 dentro de hit 48) |
| Default | `currentColor` ou `muted-foreground` |
| Active / brand | `primary` (`#CFA551`) |
| Success / live | success / live tokens |
| Disabled | opacity 50 + muted |
| Touch ícone-only | ≥ 44 (Menu, Depositar, close de sheet no mobile usa 32 no X — **dívida**: close deve ≥ 44) |
| Proibido | emoji como ícone de sistema; segundo pack; `live-pulse` |

Gap ícone–label: 4–8px.

---

## 9. Componentes

### 9.1 Button

**Anatomia:** label obrigatório (exceto icon-only com `aria-label`) · ícone 16 opcional · radius 8 · altura 40 (desktop) / 44 (chrome mobile).

| Variant | Fundo | Borda | Texto | Uso |
|---------|-------|-------|-------|-----|
| **Primary** | `#CFA551` | none | `#0C121A` | CTA da seção; **Cadastrar header** (todos os breakpoints); FAB Cadastre-se; tab ativa; chip valor selecionado |
| **Outline primary** | transparent | 1px primary | primary | Ação secundária de marca (não é Cadastro). Hover `bg-primary/10` |
| **Outline neutral** | `card` / transparent | `border` | foreground | **Entrar** desktop |
| **Ghost** | none | none | muted | ícones busca/sino/menu; hover `muted/60` |
| **Success soft** | `success/15` | `success/30` | success | Depositar ícone (só mobile, deslogado) |
| **Destructive** | destructive | none | foreground no destructive | perigo |
| **Secondary fill** | `secondary`/`surface-2` | `border` | foreground | Google / terciário. **Não** é o secondary Space (outline primary). |

**States**
| State | Spec |
|-------|------|
| default | conforme variant |
| hover | primary → `/90`; outline primary → `bg-primary/10`; ghost → `bg-muted/60` + foreground |
| focus-visible | `ring-2 ring-primary/40 ring-offset-2 ring-offset-background` |
| active | pressed; overlay CTA `Criar conta` permanece primary |
| disabled | opacity 50, `pointer-events-none`, sem hover |
| loading | spinner 16 + label inalterado; botão disabled |

**Sizes:** `sm` h-8 · `default` h-10 · `lg` h-11 · `icon` 40. Chrome mobile força h-11. Font 14/600 no kit; chrome Cadastrar 14/700 extraído — **lei: 14/600 no kit, 14/700 só no CTA de overlay full-width** (auth/depósito).

**Par Entrar / Cadastrar (gosto P5):** mesma altura **40** desktop (`h-10`), radius **8**, mesmo padding horizontal de referência. Hover **não** altera box (sem scale, sem borda que “cresce”). Mobile: Cadastrar `h-11` (44); Entrar some (`sm+`).

**Google / social:** mesmo envelope do secondary fill (`h-10`/`h-11`, radius 8, Inter 12–14/600). **Proibido** Roboto/tipo solto diferente do form.

**A11y:** não só cor; ícone+texto no FAB.  
**Do:** 1 primary por **seção de conteúdo**. Cadastro no chrome: Header + FAB ambos Primary (exceção nomeada vs gosto P2). **Don’t:** Cadastrar outline; Cadastrar ghost; Sticky CTA extra; par Entrar/Cadastrar desalinhado.

**Porquê:** Von Restorff + Fitts. **Fonte:** `button.tsx`, `Header.tsx`, `AuthCard.tsx`.

### 9.2 Input / Select

**Anatomia:** label 12/600 acima · ícone left 16 muted · campo · helper 10–12 muted.

| Spec | Valor |
|------|-------|
| Height | 40 (`h-10`); auth fields `py-2` + ícone — **normalizar h-10** |
| Radius | 8 |
| Fundo | `color-mix(card 92%, transparent)` ou `surface-2` / `input/50` |
| Borda | `border`; focus = `border-primary` **sem ring** |
| Placeholder | muted-foreground ~75% |
| Erro | borda destructive + texto destructive 12px |
| Disabled | opacity 50, `not-allowed` |

**States:** default / hover (borda um pouco mais visível) / focus (`border-primary`) / error / disabled. Select = mesmo envelope.

**Máscaras (Postel):** CPF `000.000.000-00`; telefone `(11) 90000-0000`; dinheiro pt-BR com centavos.

**A11y:** `label` associado; `inputMode` numérico em CPF/PIX.

### 9.3 Badge / Ribbon

**Ribbon de jogo (`.game-badge-chip`):** 10/700 uppercase tracking 0.04em · radius 4 · altura 20 · **ícone-only** (max-width 20) no idle/mobile · expande até 120 no hover/focus **do chip** em desktop. Máx. **2** empilhados **top-left**.

| Nome | Fundo | Texto |
|------|-------|-------|
| default (Lançamento, Popular…) | primary | primary-foreground |
| Hot | live | foreground |
| Cashback | success | success-foreground |
| Popular (depósito R$ 50) | primary (ou invertido se chip já é primary) | inverse |
| demo (ticker) | muted | muted-foreground · **não** uppercase pesado |
| +18 | live/15 | live |

**Shadcn `Badge` default** (pill marketing 12px) **não** é o ribbon de jogo — não misturar.

**States:** default / hover-expand (desktop) / focus-visible expand / reduced-motion = sem expand.  
**Don’t:** overlay de texto HTML em foto full-bleed de hero; 3º badge; emoji.

### 9.4 Card / Tile de domínio

**Card genérico:** radius 8 · `bg-card` · `border-border` · `shadow-card` · padding 16–24.

**GameCard (tile)**
- Thumb 3:4, `overflow-hidden`, radius 8.
- Clique no **tile inteiro** = jogar (abre auth login na v1 demo).
- Skeleton `surface-2` até `onLoad`.
- Hover desktop: overlay `bg-black/60` + CTA “Jogar” primary; scale img 1.05 / 300ms.
- Footer da thumb: counters 10px (jogadores success-dot + pago success) — **não** substituem o ticker da Home.
- Título 11–12/600 + provider 10 muted abaixo.

**States:** default / hover (desktop) / focus (ring no button) / loading (opacity 0 img) / disabled N/A.

**Don’t:** sombra colorida; glow; badge no canto direito; overflow hidden no card de Maiores ganhos (rank fica **fora**).

### 9.5 Dialog / Sheet / Drawer

| Superfície | Mobile | Desktop |
|------------|--------|---------|
| Auth | Sheet bottom `rounded-t-16`, handle 36×4, max 92vh, overlay `black/65` | Dialog centrado radius 12, split 42/58, `min(920px,95vw)` |
| Depósito | Idem sheet | Split + banner 16:6 na coluna esquerda |
| Menu categorias | Drawer left 82vw max 320, `bg-card`, slide 220ms | **Não** — LeftSidebar |
| Confirm delete (admin pretendido) | Dialog | Dialog |
| Welcome bonus | Dialog radius 12 — **auto-open desligado** (dívida/produto: promo já está na faixa) | |

**States overlay:** closed / open (fade 200) / dragging-to-dismiss (`useSheetDrag`) / Escape fecha.  
**Nested fills** no overlay: `surface-2`. Sticky header/footer: `bg-card/95 backdrop-blur` + border — nunca `bg-card` sólido sobre `bg-card`.  
**Don’t:** Dialog Shadcn `bg-background` (kit genérico) para auth; dois dialogs empilhados; Welcome auto-open bloqueando o header.

### 9.6 Header / Nav / Sidebar / BottomNav / Footer

**Header** sticky, `h-14`/`h-16`, `bg-background/85 backdrop-blur`, border-b. Logo à esquerda.

| Viewport | Chrome |
|----------|--------|
| `< lg` | Menu 44 · Logo · **Cadastrar Primary sólido 44** (destaque canônico) · **Depositar success-soft 44**. Sem Entrar. |
| `≥ lg` | Logo · nav (Cassino, Ao Vivo, Esportes, Promoções) · busca/sino 36 (dívida → 40) · **Entrar outline** · **Cadastrar primary sólido h-10** |

**BottomNav** `lg:hidden`, 5 slots, `bg-background/95`. Slot central **FAB primary 48** “Cadastre-se” = atalho de polegar, **mesmo variant Primary** do header (não substitui o destaque do topo). Logado (pretendido): FAB vira Depositar.

> **Lei vs código atual:** `Header.tsx` ainda pinta Cadastrar como outline abaixo de `lg`. Isso é **dívida** — a lei humana é sólido em todos os breakpoints. `mem/design/system.md` (outline no header) fica no Apêndice A como rejeitado.

**LeftSidebar** `hidden lg:block` w-60 sticky. Item ativo `bg-primary/15` + ícone primary. Live = dot live. Providers 2 col `h-10` `bg-surface-2`, logo invertida `h-5 max-w-[72px] opacity-80`.

**CategoryRail** só `< lg`, chips horizontais, ativo = borda/fundo primary/15.

**Footer** `bg-card/60`, 4 grupos de links, faixa +18 live, logos de provedores.

**States nav:** default / hover muted / active primary-soft / current route.

### 9.7 Outros do inventário

**WinnersTicker** — componente de prova social **global** (marquee full-bleed sob Header). **Não montado** na Home pós-Apply Align (duplicata vs P-WINS). Se remontar no chrome → mini-A + OK. Chip `demo` se seed. Marquee 120s.

**BonusCountdownBanner (P-BONUS-STRIP)** — superfície de **campanha**, não chrome persistente.

| Campo | Lei |
|-------|-----|
| Fill | `bg-primary` + texto `primary-foreground` |
| Vida | Dismissível (X + sessionStorage); some ao zerar o timer; auto-hide 30s permitido. **Sem loop falso.** |
| Quantidade | **Máx. 1** faixa de urgência por viewport |
| CTA interno (“Resgatar”) | **Sempre inverso:** `bg-background` (ou `card`) + `text-primary` + radius 8. Nunca Primary sólido (sumiria no fill **ou** viraria 2º botão gold de chrome) |
| Relação com Header Cadastrar | Papéis diferentes. Header = cadastro persistente (Primary). Faixa = oferta temporária. **Podem coexistir.** A faixa **não** rebaixa o Cadastrar do header para outline. |
| Relação com FAB | FAB continua Primary de cadastro. A faixa não ganha 3º botão gold sólido. |
| Proibido | 2 faixas; Resgatar Primary sólido; faixa permanente; countdown que reinicia; StickyMobileCTA extra; WelcomeBonus auto-open |

**JackpotCounter** — card; ícone Crown em primary/15; valor mono Display; “aumentando agora” success. **Não** usa fill primary (não é faixa de urgência).  
**Nested (humano 2026-09-21):** abaixo da linha título+valor, lista estática “Últimos ganhadores” (`P-JACKPOT-WINNERS`) — **não** marquee, **não** chip demo no meio do valor.

**Segmented (Hoje/Semana/Mês, Entrar/Cadastrar):** track `surface-2` radius 8; item ativo primary.

**Toast (Sonner):** radius 8, `bg-background`, border, máx. 2 visíveis; action = primary.

**Checkbox:** `accent-primary`, 16px.

---

## 10. Patterns de tela (`P-…`)

> O que não tem padrão está **errado** ou o padrão **ainda precisa ser definido**.  
> Mock/Lovable = evidência. Admin A–D/F = lei pretendida (fonte = constituição).

### 10.0 Decision tree (sempre)

```text
COLLECTION
  muitos + comparar colunas? → TABLE
  poucos + visual / metadata irregular? → CARDS
  precisa preview sem sair? → + SPLIT (opcional)

CLICK no item
  URL / análise / muitos campos? → DETAIL PAGE
  inspeção rápida + volta lista? → DRAWER
  comparar vários? → SPLIT

CREATE / EDIT
  1–3 campos, sem ref da lista? → MODAL
  form médio, lista como ref? → DRAWER
  steps / nested / URL própria? → PAGE
  1 campo na página de detalhe? → INLINE
  form dentro de célula de tabela? → PROIBIDO

DELETE → sempre MODAL de confirmação
```

Thresholds: tabela se coleção típica ≥ 9; cards se ≤ 5 com visual.

### 10.1 Application — Collection (A)

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-COL-TABLE | Listagens admin (jogadores, transações, jogos, provedores) em **tabela**: pagination + per page 10/25/50/100 default **25** + zebra + sort + column picker ⋯. Toolbar: busca + filtros + ação primária. Célula 14; header 12/600 muted. Números tabular; R$ center. | Cards empilhados no lugar de CRUD; tabela infinita sem per page; editar na célula | pretendido (constituição) |
| P-COL-FILTER | Filtros na toolbar; muitos filtros → Drawer. Chips ativos removíveis. Mobile: filtros em Sheet. | Filtro só no `select` nativo sem padrão; 12 controles sempre visíveis | pretendido |
| P-COL-BULK | Checkbox na linha + barra bulk (N selecionados · ações). Ação destrutiva pede P-CRUD-DELETE. | Bulk sem contagem; delete em massa sem modal | pretendido |
| P-COL-EMPTY | Ícone muted 24 + H3 + caption + CTA opcional (primary se a ação cria o 1º item). | Tela em branco; ilustração neon | pretendido; empty de catálogo B2C ainda fraco na fonte |
| P-COL-PAGINATION | Footer: “X–Y de Z” · Per page · Anterior/números/Próximo. Server-side no produto real. | Infinite scroll como padrão de backoffice | pretendido |

**Catálogo B2C (player):** coleção de jogos = **CARDS em row horizontal** (P-GAME-ROW), não tabela.

### 10.2 Application — Object (B)

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-OBJ-OPEN | Clique na **linha** da tabela → Detail page se URL/campos muitos; **Drawer** se inspeção rápida. Clique no **GameCard** → inicia jogo (ou auth se deslogado). | Click só no ícone “olho”; hover-card como navegação | pretendido / extraído (GameCard) |
| P-OBJ-DETAIL | Página: H1 identidade · status badge · metadados · abas se > 1 grupo · ações no header (1 primary). | Detail = mesmo layout da lista; 3 primaries | pretendido |
| P-OBJ-SPLIT | Split lista|preview opcional em desktop ≥ lg quando comparar. **Não** substitui detail completo. | Split no mobile; split como único lugar do objeto | pretendido |

### 10.3 Application — CRUD (C)

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-CRUD-CREATE | 1–3 campos → Modal. Form médio com lista visível → Drawer. Steps/KYC/URL → Page. Auth player **já** é overlay/page (`/cadastro`). | Create só via prompt; form na célula | pretendido; player extraído |
| P-CRUD-EDIT | Mesma decision tree. Drawer se a lista é referência. | Rota diferente sem motivo; dois formulários | pretendido |
| P-CRUD-INLINE | Só **1 campo** no detail (ex. toggle status). | Form na célula da tabela | pretendido |
| P-CRUD-DELETE | Modal confirm **critical** (título + consequência + Destuctive + Cancel outline). | Delete imediato; confirm no `window.confirm` | pretendido |
| P-CRUD-FEEDBACK | Toast Sonner sucesso/erro após save; inline error no campo. Não usar toast no lugar de dialog. | Alert JS; toast empilhando 6 | pretendido; Sonner extraído |

### 10.4 Application — Surface (D)

| ID | Quando usar | Quando não |
|----|-------------|------------|
| P-SURF-PAGE | Fluxo com URL própria, steps, ou detalhe rico. Home, `/cadastro` deep-link. | Trocar toda a home por modal. |
| P-SURF-DRAWER | Menu mobile; filtros admin; detalhe rápido. Largura max 320–400. | Form de cadastro player (isso é sheet/dialog). |
| P-SURF-MODAL | Confirm, form curto, foco total. Desktop auth/depósito. | Mobile auth (usar sheet); marketing popup auto-open. |
| P-SURF-SHEET | Auth e Depósito no mobile (`items-end`, handle, drag). | Desktop ≥ sm (vira dialog). |
| P-SURF-SPLIT | md+ auth/depósito 42/58; split admin opcional. | Mobile; poço vazio na coluna de arte. |

### 10.5 Domínio / player (E)

| ID | Spec | Anti-padrão |
|----|------|-------------|
| P-CHROME-MOBILE | **Header Cadastrar = Primary sólido** (destaque canônico, Serial Position). FAB Cadastre-se = **mesmo variant Primary** (atalho Fitts). Depositar = success-soft ícone. Sem Sticky CTA extra. Logado: FAB → Depositar. | Header Cadastrar outline; FAB como “único” primary; Cadastro ghost; sticky + FAB |
| P-CHROME-DESKTOP | Nav texto · Entrar outline · Cadastrar primary sólido. Sem FAB, sem CategoryRail, com LeftSidebar. | Cadastrar outline no desktop; dois primaries **no header** (Entrar não é primary) |
| P-BONUS-STRIP | Fill primary; máx. 1; dismissível; timer zera e some. CTA “Resgatar” **inverso**. Coexiste com Header Cadastrar sólido — papéis distintos (campanha vs chrome). | Countdown eterno; 2 faixas; Resgatar Primary sólido; rebaixar Cadastrar do header para outline por causa da faixa |
| P-TICKER | Prova social **global** opcional: um ticker/home full-bleed; chip `demo` se seed; reduced-motion pausa. **Estado Align:** não montado (P-WINS é a global). | Ticker no chrome **e** P-WINS; remountar ticker após Align sem mini-A |
| P-HERO | 16:6; radius 8; mobile snap+dots; desktop 2/3+1/3. Sem HTML sobre a foto. | Banner 16:9; texto HTML no bleed; autoplay sem pause |
| P-GAMECARD | 3:4; tile inteiro clica; ≤2 badges top-left; skeleton surface-2; hover Jogar só ≥ sm | 1:1; 4 badges; glow; card não clicável |
| P-GAME-ROW | H2 + “Ver todos” texto primary · row horizontal no-scrollbar. CategoryRail só < lg | Grid denso no mobile no lugar do row (exceto Maiores ganhos) |
| P-JACKPOT | Um card; topo = título + valor Display; sem fill primary | Jackpot = faixa de urgência; glow; valor fora do card |
| P-JACKPOT-WINNERS | Lista **contextual** de últimos ganhadores **abaixo** do topo do Jackpot (mesmo card). Estática, legível, text-xs; surface-2 ou linha quieta; **sem** marquee / animate-marquee / chip demo no meio do valor. Coexiste com P-WINS. | Marquee no meio título↔valor; remountar WinnersTicker sob Header; muro ilegível |
| P-WINS | Prova social **global** da Home: rank **fora** do card (`-left-1.5 -top-1.5`); thumb 3:4; tabs período segmented; valor never truncate | Rank sobre a foto; overflow hidden cortando o badge; ticker chrome + este painel |
| P-AUTH | Sheet mobile: bônus compacto + form; desktop arte full-bleed + card de oferta na base (`from-surface`). 1 CTA primary no footer sticky. CPF auto-fill. | Banner 16:6 no sheet; poço vazio; 2 primaries |
| P-DEPOSIT | Só PIX. Chips iguais; default **R$ 50** + chip Popular **inline**. Termos/rollover **antes** do CTA. Nested surface-2. Footer sticky com saldo + “Depositar via PIX”. | Vários métodos sem hierarquia; Popular grudado na borda inflando altura |
| P-PROVIDER | Tile surface-2; logo `h-5 max-w-[72px] object-contain opacity-80 brightness-0 invert` | Logo colorida misturada; alturas diferentes |

### 10.6 Operação (F)

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-NAV-IA | Item ativo = primary/15 + ícone primary. Ícone 20 + label 14/600. Sem inventar 3ª nav. | Nav arco-íris; item ativo só bold | pretendido + extraído sidebar |
| P-FORM-LAYOUT | Label acima; 1 coluna; grupos ≤ 7 campos visíveis; helper caption. Auth: CPF → tel → email → senha. | Placeholder no lugar de label; 2 colunas no mobile | extraído / pretendido |
| P-FORM-SAVE | CTA primary no footer sticky do overlay. Secondary ao lado só se cancel. Disabled até válido. | Save escondido no scroll; 2 saves | extraído |
| P-STATUS-BADGE | Status = ribbon 10px + ícone + texto (não só cor). Hot=live, success=ok, warning=alerta, destructive=erro. | Semáforo só cor; warning dourado | pretendido |
| P-PERMISSION | Ação sem permissão: esconder **ou** disabled + tooltip. Nunca 404 mudo. | Botão que falha depois | pretendido |
| P-DANGER-ZONE | Bloco no detail: borda destructive/30, título, consequência, CTA destructive. Confirm = P-CRUD-DELETE. | Delete no meio do form | pretendido |
| P-TOAST | Sonner, máx. 2, 4–6s, radius 8. Sucesso/erro. Não para confirm. | Toast = dialog; spam | extraído |

### Rotas v1

| Rota | Patterns |
|------|----------|
| `/` Home | P-CHROME-* · P-BONUS-STRIP · P-HERO · P-JACKPOT · P-JACKPOT-WINNERS · P-GAME-ROW · P-WINS · P-PROVIDER |
| Overlay auth / `/cadastro` `/login` | P-AUTH · P-SURF-SHEET/MODAL · P-FORM-* |
| Overlay depósito / `/deposito` (redirect) | P-DEPOSIT · P-SURF-SHEET/MODAL |
| Menu mobile | P-SURF-DRAWER · P-NAV-IA |
| Admin (futuro) | P-COL-* · P-OBJ-* · P-CRUD-* · P-DANGER-ZONE · P-PERMISSION |

### Decisões com o humano (Forge)

| Tema | Pergunta | Decisão | Data |
|------|----------|---------|------|
| Chrome dual mobile | FAB sólido + header Cadastrar outline? | **Vetado.** Cadastro = Primary sólido **no header** (destaque) e no FAB (atalho). Outline no Cadastrar = dívida. | 2026-09-21 |
| Warning hex | Aceitar `#FF7F3B`? | **Sim.** Warning ≠ CTA. | 2026-09-21 |
| Inter vs system-ui | Qual família? | **Inter.** Preview system-ui = dívida. | 2026-09-21 |
| Faixa de bônus + Cadastrar desktop | Estabelecer regra? | **P-BONUS-STRIP:** campanha temporária, fill primary, CTA inverso; não compete com Header Cadastrar. | 2026-09-21 |

---

## 11. Mobile

- Touch **≥ 44** no chrome (Menu, Cadastrar, Depositar, FAB 48). Close 32 no overlay = dívida.
- Auth/Depósito = **Sheet** (não dialog full-screen).
- Padding página 12–16; `pb-32` reserva BottomNav.
- Sidebar → drawer 82vw.
- CategoryRail só `< lg`.
- Hero e recomendados: snap carousel + dots (dots 6px = exceção visual, não spacing de layout).
- Tabelas admin (futuro): scroll X + pagination acessível.
- Breakpoint de shell: **1024**.

**Risco se ignorar mobile:** Cadastrar outline (código atual) vs lei sólida; StickyCTA + BottomNav (`StickyMobileCTA` **não** entra na Home).

---

## 12. Estados

| Superfície | Loading | Empty | Error | Disabled |
|------------|---------|-------|-------|----------|
| GameCard | img opacity 0 sobre `surface-2` | N/A no tile | fallback surface (sem broken-image) | N/A |
| GameRow | skeletons 3:4 | caption + “Ver todos” ainda visível; empty state + CTA se catálogo 0 | Alert + retry (pretendido) | — |
| Auth/Depósito | CTA loading spinner | — | texto destructive no campo; toast se rede | CTA opacity 50 |
| Ticker | — | esconder ticker | — | reduced-motion = estático |
| Tabela admin | Skeleton rows | P-COL-EMPTY | Alert destructive + retry | row actions opacity 50 |
| Overlay | fade 200 | — | — | overlay click fecha |

Disabled genérico: opacity 50, `cursor-not-allowed`, sem hover ativo.

---

## 13. Acessibilidade

- Contraste AA: fg/bg 17:1; muted 7.1:1; primary/on-primary 8.2:1 (texto no botão gold OK).
- `focus-visible` ring em botões; inputs com `border-primary`.
- Labels associadas; `aria-label` em ícone-only (Menu, Depositar, Fechar, slides).
- `prefers-reduced-motion` obrigatório (ver F7).
- Status nunca só cor (Flame + HOT, dot + “Ao Vivo”, sinal + valor).
- `lang="pt-BR"`.
- Overlay: `aria-modal`, Escape, lock scroll.
- Ticker seedado: rótulo `demo` + `aria-label` de demonstração.
- FAB: nome “Cadastre-se” visível (não só ícone).

---

## 14. Anti-padrões IA

| Proibido | Preferir |
|----------|----------|
| Glow, neon, glass pesado, blobs (`PageShell` ainda tem blur orbs) | Superfície + borda |
| `bg-gradient-*` em UI | Sólido primary / card |
| `font-black` / extrabold | 400–700 |
| Uppercase+tracking em label de form | Ribbon 10px somente |
| 2+ Primary sólidos na **mesma seção de conteúdo** | 1 primary; resto outline/ghost. **Exceção nomeada:** Header Cadastrar + FAB (mesma ação, papéis topo vs polegar) |
| Cadastrar do header em outline | Primary sólido em todos os breakpoints |
| Warning = gold da marca | `#FF7F3B` (alerta) — confirmado humano |
| Sticky CTA + FAB na Home | Só FAB + Header Cadastrar; sem sticky extra |
| Resgatar da faixa como Primary sólido | CTA inverso na faixa (P-BONUS-STRIP) |
| Emoji como ícone | Lucide |
| HTML sobre hero full-bleed | Imagem com CTA desenhado |
| Rank inset no thumb | Rank fora, card `relative` sem overflow hidden |
| Nested `bg-background` | `surface-2` |
| Editar na célula | P-CRUD-INLINE só no detail |
| Tabela admin sem pagination/per page/zebra/sort/⋯ | P-COL-TABLE |
| Inter não carregada | `next/font` ou equivalente Inter |
| `window.alert("Demo visual")` como feedback | Toast / estado real |
| Auto-open WelcomeBonus bloqueando header | Faixa dismissível |

---

## 15. Checklist de aceite

- [ ] F1: Primary `#CFA551` único; surfaces com hex; success/warning/destructive/live; warning ≠ gold
- [ ] F2: Inter; papéis com size+weight+line-height; sem font-black
- [ ] F3: spacing só 4…64 no mapa; exceções 40/44/56 nomeadas
- [ ] F4: breakpoints + o que muda; 16:6 e 3:4
- [ ] F5: 4/8/12/16; card 8; overlay desktop 12; sheet 16
- [ ] F6: `elevation.shadow-card`; glow none
- [ ] F7: 150/200/220 + reduced-motion
- [ ] F8: Lucide 16/20/24; touch 44
- [ ] Button/Input/Badge/Card/Overlay/Header com **states**
- [ ] P-COL/OBJ/CRUD/SURF/NAV/FORM/TOAST preenchidos
- [ ] P-CHROME-MOBILE: Header Cadastrar **Primary sólido**; FAB Primary (atalho); sem outline no Cadastro
- [ ] P-BONUS-STRIP: fill primary; CTA inverso; máx. 1; coexiste com Header Cadastrar
- [ ] P-DEPOSIT: PIX, R$ 50 Popular, rollover antes do CTA
- [ ] A11y AA, focus, labels, demo ticker
- [ ] Sem glow/gradient UI/emoji-ícone
- [ ] tokens.dtcg.json espelha F1–F8 (elevation ≠ motion)

---

## Apêndice A — Extraído / Normalizado / Rejeitado

| Item | Extraído | Normalizado | Rejeitado |
|------|----------|-------------|-----------|
| Primary | oklch 0.744 0.113 83 → `#CFA551` | `#CFA551` (logo; canvas `#CFA552`) | aliases brand/accent-orange/yellow como 2ª cor |
| space-y-7 Home | 28px | **24** section | 28 como lei |
| p-7 PageShell | 28px | **24** | 28 |
| gap-2.5 | 10px | 8 ou 12 | 10 |
| py-2.5 ticker/nav | 10px | 8 ou 12 | 10 |
| busca/sino h-9 | 36px | **40** | 36 |
| close overlay h-8 | 32px | **44** no mobile | 32 |
| Hero fade 700ms | 700 | **200–400** | 700 como lei |
| Jackpot interval 110ms | tick contínuo | feedback <400; **não** animar dinheiro a 9fps como lei | “ao vivo” agressivo |
| PageShell blobs blur | orbs primary/15 | — | **rejeitado** (anti-glow) |
| StickyMobileCTA | componente existe | — | **não usar na Home** |
| WelcomeBonus auto-open | código desligado | faixa BonusCountdown | popup bloqueante |
| `--radius` 0.625rem no 1º bloco | 10px | **8** (2º `:root`) | 10 |
| Light theme Shadcn | bloco morto | dark-only | tema light |
| Dialog kit `bg-background` | shadcn | overlay = **card** | background no modal |
| font-bold chrome vs semibold kit | 700 / 600 | kit 600; overlay CTA 700 | 800+ |
| live = destructive hex | mesmo oklch | papéis distintos | segundo vermelho sem necessidade |
| Inter | mem + humano | Inter lei | system-ui como lei |
| Header Cadastrar outline (`< lg`) | `Header.tsx` + mem | **Primary sólido todos os breakpoints** | outline como lei; FAB como “único” primary |
| Faixa bônus fill + Cadastrar header | código | P-BONUS-STRIP (campanha + CTA inverso) | Resgatar Primary sólido; rebaixar header por causa da faixa |
| `text-[11px]` nomes | 11 | 12 caption | 11 como token |

## Apêndice B — tokens.dtcg.json

Espelho em `.docs/tokens.dtcg.json`: `color` · `typography` · `space` · `space.exception` · `radius` · `breakpoint` · `icon.size` · `motion` · **`elevation`** (fora de motion).

## Versionamento

| Versão | Data | Notas |
|--------|------|-------|
| 0.2.0-apply-a | 2026-09-21 | Fase A Apply: gosto Miguel. Cadastro Primary reforçado; pesos 400/600/700; par Entrar/Cadastrar; seleção borda comida; Google Inter; admin ≠ cassino. Dual FAB+header = exceção humana (gosto P2 waived). |
| 0.1.1-draft | 2026-09-21 | Humano: Cadastrar header Primary sólido; warning `#FF7F3B`; Inter; P-BONUS-STRIP. Outline+FAB-único rejeitado. |
| 0.1.0-draft | 2026-09-21 | Forge inicial PixReals. GATE 0 A. Warning inferido. Chrome dual extraído, pendente OK humano. |
