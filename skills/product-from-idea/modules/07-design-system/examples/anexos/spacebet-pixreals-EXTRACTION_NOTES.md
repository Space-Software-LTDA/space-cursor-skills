# EXTRACTION_NOTES — PixReals Design System Forge

Data: 2026-09-21  
Skill: `design-system-forge`  
Produto: PixReals (Lovable: Remix of Game Visuals Hub)

---

## 1. Fonte + GATE 0

| Campo | Valor |
|-------|-------|
| Preview publicado | https://aesthetic-play-hub.lovable.app |
| Preview id | https://id-preview--6c770339-3b36-499a-b653-775cb70dab53.lovable.app |
| Lovable project_id | `6c770339-3b36-499a-b653-775cb70dab53` |
| Commit | `4557e0447b675f2219b06b87c531ec0c0aba6750` |
| Memória interna | `mem/design/system.md` (notas do produto — evidência, não este DS) |
| Tokens CSS | `src/styles.css` (`:root` efetivo dark-only) |
| Método | Space UI DS v1.0 inteiro + Laws of UX `https://lawsofux.com/llms.txt` |
| Superfícies vistas | Home desktop 1440 · Home mobile 390 · Auth sheet cadastro · código Depósito/Sidebar/GameCard/Jackpot/Ticker |

**Nível GATE 0: A**

Critério: desktop + mobile + código/tokens + ≥3 superfícies (home, overlay auth, depósito no código) + Space DS + intenção de marca (logo gold, cassino PIX).

Não parou: fonte suficiente para DS.

---

## 2. Tabela Q1–Q15

| ID | Status | Resposta | Evidência | Confiança |
|----|--------|----------|-----------|-----------|
| Q1 | Inferido | Primary único `#CFA551` / `oklch(0.744 0.113 83)`. Accent-orange/yellow/brand = **aliases mortos** do mesmo hex. Sem segundo accent. | `styles.css`, logo, Cadastrar medido lab gold | alta |
| Q2 | Inferido | bg `#0C1015` → surface `#111419` → card `#15181F` → surface-2 `#171B21` → surface-3 `#20242C`. Nested = surface-2, nunca background. | CSS + mem + Auth/Deposit | alta |
| Q3 | **Humano** | Lei **Inter** 400/500/600/700. Humano confirmou Inter > system-ui. Preview atual = system-ui (**dívida Apply**). | chat 2026-09-21 + mem | alta |
| Q4 | Inferido | Radius 4/8/12/16 (card 8, modal desktop 12, sheet 16). Spacing 4…64. Breakpoints Tailwind; **lg 1024** = corte de shell. | `@theme`, Header `lg:`, BottomNav `lg:hidden` | alta |
| Q5 | **Humano** | Cadastro deslogado = **Primary sólido no header** (destaque canônico) **e** no FAB (atalho). Outline no Cadastrar = **rejeitado**. Código atual (`lg:bg-primary` só no desktop) = dívida. | chat 2026-09-21 | alta |
| Q6 | Extraído + humano | Desktop ≥ lg: nav texto, Entrar outline, Cadastrar **sólido** h-10. Alinhado ao Q5 (sólido também no mobile). | Header + humano | alta |
| Q7 | **Humano** | success `#3FC168` · destructive/live `#EE343B` · warning **`#FF7F3B` confirmado**. Warning ≠ CTA. `--warning` ainda não está no CSS. | chat 2026-09-21 | alta |
| Q8 | Extraído | Dívida: blobs PageShell, StickyMobileCTA morto, Welcome auto-open off, Inter não load, space-y-7, glow vars zeradas (ok), aliases de cor, Dialog kit bg-background, close 32px, hero 700ms, jackpot 110ms, `window.alert` demo. | código vs mem | alta |
| Q9 | Inferido | B2C cassino BR + PIX. Tom: confiança de depósito, não neon. Admin não na fonte → A–D/F pretendidos. | produto + Jakob mercado | alta |
| Q10 | Inferido | v1 = player (home, auth, depósito PIX, catálogo). Fora: app nativo, multi-método pagamento, admin UI. Admin **patterns** entram mesmo assim. | rotas + mem | alta |
| Q11 | Extraído | Lucide only; 16/20/24; stroke 2; ativo = primary; live/success semânticos; touch ícone-only ≥ 44. | lucide-react, Header, BottomNav | alta |
| Q12 | Extraído | 150 colors · 200 hover/overlay · 220 drawer · marquee 120s · reduced-motion mata marquee/pulse/chip expand. | styles.css | alta |
| Q13 | Pretendido | Nenhum ID A–D/F vetado pelo humano. Preenchidos como lei. | skill GATE ACCEPT | alta (processo) |
| Q14 | Extraído | Game 3:4 · hero/promo 16:6 · auth 42/58 md+ · FAB 48. | HeroBanners, GameCard, AuthCard | alta |
| Q15 | Extraído + normalizado | Exceções nomeadas: 40 control, 44 touch, 56 header mobile. Off-scale 28/10/36 **normalizados** (não lei). | Princípio #3 | alta |

---

## 3. GATE ACCEPT

### Camada 0 — Artefato
- [x] Template todas as seções (0–15 + apêndices)
- [x] Valor · Uso · Porquê · Fonte
- [x] `tokens.dtcg.json` espelha F1–F8; elevation ≠ motion
- [x] Estas notes: GATE 0 + Q + Accept + rejeitado

**Pass**

### Camada 1 — Foundations F1–F8
| ID | Resultado | Buraco |
|----|-----------|--------|
| F1 | Pass | warning `#FF7F3B` confirmado humano; CSS ainda sem token (Apply) |
| F2 | Pass | Inter confirmada; preview system-ui = dívida Apply |
| F3 | Pass | exceções 40/44/56 nomeadas; 28 rejeitado |
| F4 | Pass | |
| F5 | Pass | mem “hero 16” rejeitado em favor do código 8 |
| F6 | Pass | shadow-card; glow none |
| F7 | Pass | |
| F8 | Pass | close 32 = dívida, não lei |

**Pass** (dívidas de implementação, não de lei)

### Camada 2 — Componentes
Button, Input, Badge/Ribbon, GameCard/Card, Dialog/Sheet/Drawer, Header/Nav/Sidebar/BottomNav/Footer — todos com states.  
N/A: Select Shadcn genérico coberto no bloco Input.

**Pass**

### Camada 3 — Application P-…
A–D/F preenchidos como pretendido. E (player) extraído. Humano não vetou IDs.

**Pass**

### Camada 4 — Operação
Mobile, estados, a11y, anti-padrões IA, checklist, versionamento.

**Pass**

### Auto-contradições encontradas e corrigidas no draft

| Risco | Correção |
|-------|----------|
| Escala 4…64 + 28/14/20/36 como lei | 28/10/36 no Apêndice A; mapa só escala; 40/44/56 na tabela de exceções |
| 1 Primary + banner gold + Cadastrar gold | **P-BONUS-STRIP** (humano): faixa = campanha, CTA inverso; Header Cadastrar permanece Primary. Não é o mesmo papel. |
| Header outline + FAB único Primary | **Vetado.** Lei = ambos Primary; destaque = header |
| Warning ≈ primary | Warning hue 45° `#FF7F3B` confirmado |
| Shadow em motion | elevation no topo do JSON |
| Mem hero radius 16 vs código 8 | Lei = 8 (código) |
| live === destructive hex | Aceito como extraído; papéis distintos (não dois tokens inventados) |
| Button secondary Space (outline primary) vs kit `bg-secondary` | Lei do **produto**: outline primary é variant própria; secondary fill = terciário |

Nenhuma auto-contradição residual no MD vs tokens.

**Veredito estrutural:** PASS COM RESSALVAS — Qs fechadas; ressalva restante = **exceção nomeada** (dois Primary de cadastro: header + FAB) e **código** ainda outline no mobile (Apply).

---

## 4. Fonte vs decidido / questionado

| Tema | Fonte | Decidido | Questionado |
|------|-------|----------|-------------|
| Primary gold logo | CSS + logo + mem | `#CFA551` | — |
| Dark surfaces | CSS último `:root` | hex medidos canvas | — |
| Chrome mobile dual | mem outline+FAB | **Humano:** Header Cadastrar Primary sólido + FAB Primary | fechado 2026-09-21 |
| Inter | mem + Space método | **Humano: Inter** | preview system-ui = Apply |
| Warning | ausente no CSS | **Humano: `#FF7F3B`** | token CSS = Apply |
| Faixa de bônus | código fill + Resgatar inverso | **P-BONUS-STRIP** lei | fechado 2026-09-21 |
| Spacing 28 | `space-y-7` | normalizar 24 | — |
| Glow | CSS none + skill | proibido | — |
| Admin tables | não na UI | P-COL-* pretendido | — |
| Sticky CTA | componente órfão | rejeitado na Home | — |

---

## 5. Rejeitado / dívida

**Rejeitado como lei (Apêndice A do DS)**
- Header Cadastrar outline (`< lg`) e mem “FAB = único strong Primary”
- Glow / blobs PageShell / `live-pulse` visível
- StickyMobileCTA na Home
- WelcomeBonus auto-open
- 2ª cor brand (aliases)
- Light theme Shadcn
- Off-scale 28/10/36 como token
- Hero radius 16 (mem desatualizado)
- system-ui como família oficial
- `window.alert` como feedback
- HTML sobre hero bleed
- Rank inset

**Dívida de implementação (não é este Forge aplicar)**
- Header Cadastrar: outline → Primary sólido em `< lg`
- Carregar Inter
- Close overlay 44px
- Busca/sino 40px
- space-y-7 → 24
- Hero fade ≤ 400ms
- Remover blobs PageShell
- Apagar ou isolar StickyMobileCTA
- `--warning` no CSS
- Provider `rounded-md` (6) → 8

---

## 6. Perguntas ao humano

| # | Pergunta | Resposta (2026-09-21) |
|---|----------|------------------------|
| Q5 | Manter FAB único sólido + Cadastrar outline? | **Não.** Dois botões de cadastro na Home: o de **cima** é a ação primária e deve ir **Primary sólido**. FAB também Primary (“tudo primário”), como atalho — não o único destaque. |
| Q7 | Warning `#FF7F3B`? | **Confirmado.** |
| Inter | Inter vs system-ui? | **Inter é melhor.** |
| Faixa dourada | Estabelecer regra vs Cadastrar desktop? | **Sim** → P-BONUS-STRIP. |

Q15 não precisou de pergunta: off-scale normalizado ou exceção 40/44/56.

**Não há Q aberta.** Próximo passo de produto = Apply (Forge não pinta o front).

---

## Medições (canvas / CDP)

| Token | OKLCH fonte | Hex canvas |
|-------|-------------|------------|
| background | 0.17 0.012 260 | `#0C1015` |
| surface | 0.19 0.012 260 | `#111419` |
| card | 0.21 0.014 260 | `#15181F` |
| surface-2 | 0.22 0.014 260 | `#171B21` |
| surface-3 | 0.26 0.016 260 | `#20242C` |
| foreground | 0.97 0.004 250 | `#F3F5F8` |
| muted-fg | 0.70 0.012 255 | `#999FA6` |
| primary | 0.744 0.113 83 | `#CFA552` (lei logo `#CFA551`) |
| primary-fg | 0.18 0.02 260 | `#0C121A` |
| success | 0.72 0.17 150 | `#3FC168` |
| destructive/live | 0.62 0.22 25 | `#EE343B` |
| warning | 0.74 0.18 45 | `#FF7F3B` (**humano**) |

Contraste: fg/bg 17.47 · muted/bg 7.15 · primary/on-primary 8.20.

Desktop 1440: Cadastrar sólido 40×96, radius 8, weight 700.  
Mobile 390: Cadastrar **ainda outline no preview** (dívida vs lei 0.1.1: deve ser Primary sólido). FAB Primary. Depositar verde.

Auth sheet: segmented Entrar/Cadastrar, bônus compacto, form CPF, 1 CTA no footer (parcialmente abaixo da dobra no screenshot — código `sticky footer`).

---

## 7. Normalizado pelo gosto (Fase A) — 2026-09-21

Skill: `design-system-apply`. DS → **0.2.0-apply-a**.  
Scan Fase B (redo, pedido humano): `.docs/design-system-forge/QA_REPORTS/2026-09-21-pixreals-r2.md`.  
Re-Scan C2 (pós-Fix `90d18ddd`): `.docs/design-system-forge/QA_REPORTS/2026-09-21-pixreals-r3.md` — não ALIGNED (prova social duplicada).  
Re-Scan C2 (pós-Fix `0bcb922` ticker off): `.docs/design-system-forge/QA_REPORTS/2026-09-21-pixreals-r4.md` — **ALIGNED** id-preview.  
Publish 2026-09-21: `aesthetic-play-hub.lovable.app` republicado (`deploy_project`) e fold 390 validado = Fix.  
`2026-09-21-pixreals-r1.md` = B anterior (não usar como OK B desta redo).  
Relatório `2026-09-21-pixreals.md` = A + diagnose incompleto (não usar como GATE SCAN).

| Saiu / rebaixou | Entrou / reforçou |
|-----------------|-------------------|
| Peso `500` como papel de UI (caption) | Pesos **400 / 600 / 700** (gosto P4.1) |
| Código como prioridade #2 acima do gosto | Prioridade: marca/humano → **ui-gosto** → código (dívida) → Space método |
| Warning ainda rotulado “inferido” na tabela F1 | Warning humano `#FF7F3B` |
| Breakpoint lg implicando “aí o Cadastrar vira sólido” | Cadastrar sólido em **todos** os bp |
| Seleção ad-hoc | **Borda comida** 1px primary ou fill `/15` (gosto P8) |
| Par Entrar/Cadastrar sem spec de caixa | **h-10 / radius 8 / hover sem jump** (gosto P5) |
| Google sem spec de tipo | Envelope + Inter alinhado ao form |
| — | Admin ≠ energia cassino (princípio 9) |
| — | Tabela **Gosto vs produto**: dual FAB+header permanece **exceção humana** (gosto P2 waived, não apagado) |

**Não revertido (humano PixReals insistiu):** Header + FAB ambos Primary; destaque canônico = header.

**Não inventado:** Primary continua `#CFA551` (marca).

---

## 8. Mini-A (pós-ALIGNED) — 2026-09-21 / 22

Humano pediu lista de últimos ganhadores **dentro** do Jackpot (não remountar ticker sob Header).  
DS → **0.2.1-apply-mini-a**. Validação Scan: `QA_REPORTS/2026-09-21-pixreals-r5.md` (esta rodada).

| Saiu / rebaixou | Entrou / reforçou |
|-----------------|-------------------|
| P-JACKPOT “sem lista de winners” / anti “repetindo ticker” | `P-JACKPOT-WINNERS` — lista **contextual** abaixo do topo |
| P-TICKER como lei da Home ativa | P-TICKER = global opcional **não montado**; P-WINS = global |
| Princípio 7 “um ticker/tela” sem §5.5 | Global vs contextual alinhado a ui-gosto §5.5 |

**OK humano pendente** neste mini-A (PARAR Apply).

