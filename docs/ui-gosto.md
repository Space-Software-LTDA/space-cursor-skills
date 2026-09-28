# Gosto visual Space (Miguel) — constituição para Apply

> Guarda-corpo de **gosto** para a skill `design-system-apply`.  
> **Não** substitui [`design-system.md`](design-system.md) (metodologia/tokens Space B2B) nem o `.docs/DESIGN_SYSTEM.md` do produto (Forge).  
> Skills leem [README.md](README.md) primeiro.  
> **Escopo:** visual / UX. Código Front (AP-FE, FDD) **fora** — isso é `qa-space`. Lovable = referência visual.  
> **Marcas:** `[AS-IS Miguel]` = travado em reviews / glossário / page_06 / Figma BetSpace / decisões 2026-09-21.  
> `[INFERIDO]` = consolidado de hubs/QA — alinhar com o humano se houver dúvida.  
> **Origem:** guia 33 (`uiux-miguel-pack`) + decisões Miguel 2026-09-21 + AI tells compatíveis ([Taste Skill](https://github.com/Leonxlnx/taste-skill) — método, não estética).

---

## 0. Como a Apply usa isto

```text
1. DS do produto (.docs/DESIGN_SYSTEM.md)   ← CORE forjado (P-…, Primary da MARCA)
2. Este arquivo (ui-gosto.md)              ← o que Miguel gosta / odeia (preenche buracos)
3. design-system.md                        ← método, escalas, §18 (admin/tabelas)
4. Mock / Lovable                          ← hierarquia/campos — NÃO glow/ruído como lei
```

### Prioridade de verdade (travado 2026-09-21)

1. **Cor / tokens da MARCA do produto** (repo, brief, Figma de marca) — **sempre prevalece**.  
2. **Este gosto** — só o que a marca **ainda não** define.  
3. Space DS boilerplate — método nos buracos (radius, anti-glow, tabelas admin).  
4. Mock Lovable — campos e fluxos; **nunca** Primary/glow do mock contra a marca.

### Contexto admin vs player

| Contexto | O que aplicar deste guia |
|----------|---------------------------|
| **Admin / dashboard / B2B** | Método: 1 Primary, anti-glow, encaixe, Inter, Lucide, densidade corporativa. **Proibido** puxar energia cassino / tiles 3:4 / jackpot language. **Obrigatório** ler §5.6 (padrões/anti-padrões admin). |
| **Player / bet home / marketing** | Princípios P1–P10 + checklist §10 (abaixo). |

### Job da Apply

1. **Fase A:** confrontar DS do produto com este gosto → **alterar o DS** (remover fora-do-gosto).  
2. **Fase B:** Scan → Diagnose → Fix no front até ALIGNED (ver skill Apply).  
3. **Review humano no workspace** (notas, prints, clip): se existir, é checklist ALTA — **não** ALIGNED enquanto bullet ALTA falhar no preview. Conflito DS × review → mini-A, não PASS silencioso.

---

## 1. Propósito

Evitar que o agente improvise “deixe bonito”, “mais premium” ou “cassino neon”. Anti-exemplo genérico: **tudo com cara de IA** (sem URL canônica de ódio ainda — anti-padrões novos = review humano).

### Como DEVE usar

1. Ler **este arquivo inteiro** antes de normalizar DS ou refatorar UI player/bet (ou a seção admin acima se for dashboard).  
2. Respeitar a prioridade de verdade §0.  
3. Separar contextos de **marca** (purple SpaceBET / gold hub / verde B2B) — hex vem do **produto**, não deste guia.  
4. Entregar checklist §10 com **PASS/FAIL** explícito.  
5. Lacunas §11 → TBD, não inventar.

### O que NÃO fazer

- Resumir em 3 bullets vagos.  
- Stripe light home, glass/glow multi, pill em CTA form/jogo.  
- Linear como template de home bet (Linear = **polish**).  
- Trocar Inter/Lucide (Taste Skill desencoraja — **Space exige** Inter + Lucide).  
- Forçar “borda comida 2px” em todo botão (ver P8 atualizado).

---

## 2. Princípios

Cada princípio: **regra / por quê / exemplo bom / anti-exemplo**.

### P1 — Dark first; brand só em CTA/acentos
- **Regra `[AS-IS Miguel]`:** Superfícies **neutras** (navy/charcoal/near-black). Cor de marca **somente** em CTA primário, item ativo, ring de foco, chevron/accent pontual. **Nunca** carpete full-bleed da brand no background.
- **Por quê:** Selective Attention — se tudo é brand, nada é ação. Guia visual some; o olho não sabe onde clicar. Reviews do Miguel rejeitam “fundo verde-brand full (Betão)” e carpete laranja/lime.
- **Bom:** Background `#0C1015`–navy · Card um pouco mais claro · botão Cadastrar filled brand.
- **Anti:** Página inteira verde Betão / laranja B1 / lime IA SAGA como fundo; hero com wash da marca cobrindo 60% da dobra.

### P2 — Uma guia visual por viewport + Primary na ação real
- **Regra `[AS-IS Miguel]` (atualizado 2026-09-21):** Em cada viewport, **um** caminho visual dominante. Máximo **1** urgência e **1** Primary forte no chrome da dobra — e esse Primary está na **ação principal real**.
- **Deslogado (player):** sem Depositar, a ação principal é **Cadastro** → Cadastro = **Primary sólido da marca** (header e/ou FAB). **Proibido** deixar Cadastro só outline “por conceito” se a ação principal for cadastrar.
- **Logado:** Primary tipicamente Depositar / jogar conforme o DS do produto.
- **Por quê:** Von Restorff + Goal-Gradient — o olho deve achar a conversão.
- **Bom:** Header Cadastrar Primary (deslogado); **uma** prova social **global** (ticker **ou** painel); hero estático. Lista nested **dentro** de um card nomeado (ex. jackpot) ≠ segunda superfície global — ver §5.5.
- **Anti:** Dois Primaries competindo (header sólido + FAB sólido no mesmo papel); Cadastro outline no header deslogado “porque o FAB é Primary”; ticker **no chrome** + painel + sticky + BottomNav todos gritando; remountar ticker full-bleed sob o Header depois de removê-lo no Apply “só porque pediram lista de ganhadores”.

### P3 — Hero estático > motion theater
- **Regra `[AS-IS Miguel]`:** Hero pode ter carrossel **discreto**, mas **não** overload de parallax, partículas, glow pulse, texto ilegível em degradê, chips HTML soltos sobre arte.
- **Por quê:** Peak-End: o pico deve ser **legível e confiante**, não um show de IA. Motion sem guia = “dói”.
- **Bom:** Banner com arte forte, tipografia legível, CTA claro; troca de slide sem teatro.
- **Anti:** Hero quebrado (layout colapsado); texto branco em degradê fraco; chip “Em alta” HTML por cima da foto; animate-live-pulse.

### P4 — Densidade de cassino nos cards; tipografia/arte carregam o nome
- **Regra `[AS-IS Miguel]`:** Cards de jogo **compactos/densos**. O nome do jogo se lê pela **hierarquia tipográfica + arte**, não por moldura marketing arejada tipo SaaS.
- **Por quê:** Jakob (cassino BR) + Common Region. Card arejado tipo Stripe/Cardapius “workspace” parece outro produto.
- **Bom:** Tile ~3:4 `[INFERIDO hub]`, nome 11–14 semibold, provider caption muted, gap 8–12 entre tiles.
- **Anti:** Card com padding generoso, título fraco (mesmo peso do meta), muralha GameGrid sem ritmo de rows.

### P5 — CTAs em par alinhados (idle + hover)
- **Regra `[AS-IS Miguel]`:** Pares como **Entrar / Cadastrar** (e equivalentes outline + primary) devem ter **mesma altura, mesmo radius, alinhamento baseline**, e estados hover que **não desalinhém** (outline não “cresce” diferente do filled).
- **Por quê:** Similarity + polish Linear. Desalinhamento idle/hover é agonia citada explicitamente.
- **Bom:** Entrar `outline` h-10 radius-8 · Cadastrar `primary` h-10 radius-8 · hover só troca cor/brightness, box estável.
- **Anti:** Um pill e outro retângulo; um h-9 e outro h-12; hover com scale diferente que “pula” o par.

### P6 — Radius médio Space ~8; encaixado; NÃO pill/IA
- **Regra `[AS-IS Miguel]`:** Controles e game cards em família **~8px**. Nested/encaixado (camadas de superfície + borda). **Proibido** look pill em CTA de form/jogo.
- **Por quê:** Similarity familiar sem “brinquedo/IA”. Pill = assinatura de genérico Lovable/AI.
- **Bom:** Button/input/game card `8px`; modal desktop `12px`; sheet mobile top `16px` `[INFERIDO hub/Space DS]`.
- **Anti:** `rounded-full` no “Jogar”; `rounded-3xl` em tudo; cards com glow em vez de encaixe.

### P7 — Encaixe > glow
- **Regra `[AS-IS Miguel]`:** Hierarquia por **delta de superfície (~4–6%) + borda 1px**, não por sombra multi-layer, neon ou glow.
- **Por quê:** Aesthetic-Usability por clareza; Space §7/§18; Miguel odeia “cara de IA”.
- **Bom:** Card `#15181F` sobre bg `#0C1015` + `border #FFFFFF14`.
- **Anti:** `box-shadow` colorido, `animate-live-pulse`, glass blur decorativo no chrome.

### P8 — Seleção e bordas (contexto > dogma)
- **Regra `[AS-IS Miguel]` (atualizado 2026-09-21):** Seleção/ativo deve ser **consistente no produto**. Referência Betão “borda comida” é válida quando o sistema quer essa linguagem — **não** é lei universal de 2px.
- **Botões:** em geral **borda fina elegante** **ou** **subtons** (como o Space DS boilerplate descreve bem). Contexto e tom do produto mandam.
- **Por quê:** Similarity de seleção = produto sério; over-spec de borda vira dogma e quebra admin vs player.
- **Bom:** Um padrão de seleção escolhido e repetido (chips, amounts, tabs, sidebar); botões Secondary com borda/texto da marca.
- **Anti:** Misturar ring + fill brand + glow como “seleção”; carpete Primary full no tile; glow externo como seleção.

### P9 — Linear = quality bar; Stripe ≠ home bet; Betão = referência de segmento
- **Regra `[AS-IS Miguel]`:**
  - **Linear:** espelhar **nível de polish** (alinhamento, idle/hover, densidade limpa, tipografia).
  - **Stripe:** botões/controles ok como referência de craft; **home light marketing Stripe NÃO** é home de bet.
  - **Betão** (`https://betao.bet.br/`): referência de **segmento bet** (seleção, densidade, linguagem cassino BR) — **respeitar**, mas **não** copiar fundo verde-brand full.
- **Por quê:** Miguel separa “qualidade” de “layout de produto”. Copiar Stripe home = light errado; copiar Betão fundo = perde guia.
- **Bom:** Polish Linear + shell cassino Betão (sem carpete) + Primary do **produto**.
- **Anti:** Landing branca Stripe; dashboard Grafana frio na home player; Betão green wash.

### P10 — Mobile auth sheet = ouro; signup “padrão celular”
- **Regra `[AS-IS Miguel]`:** Auth mobile em **sheet** (não dialog desktop encolhido). Cadastro mobile = fluxo **padrão celular** (campos nativos mentais: celular, CPF, e-mail, senha) com card de oferta **compacto**, sem banner 16:6 / poço vazio.
- **Por quê:** Mental Model + Fitts; reviews e hub marcaram auth mobile como referência ouro.
- **Bom:** Sheet `h-auto` / max 92vh, CTA sticky, Google consistente, sem coluna vazia.
- **Anti:** Overlay fade pobre; Google button tipografia inconsistente; CTA oversize mobile; poço 92vh vazio.

---

## 3. Cor e superfície

### 3.1 Metodologia (sempre)
1. Definir **Primary** do produto (hex já no repo **ou** BetSpace purple **ou** hub gold — não misturar).
2. Definir família **Surface** dark neutra.
3. Feedback (success/destructive/warning) **nunca** vira brand carpet.

### 3.2 SpaceBET / BetSpace `[AS-IS Miguel]`
| Papel | Direção |
|-------|---------|
| Surface base | Dark **navy / indigo / charcoal** |
| Brand accent | **Purple / magenta elétrico** — CTA, sidebar ativo, chevrons |
| Texto | Branco / off-white primário; lavanda-cinza muted secundário |
| Status | Verde ok · âmbar pendente · badges extras pontuais |

### 3.3 Hub aesthetic (só referência de estrutura) `[INFERIDO]`
| Token | Hex |
|-------|-----|
| background | `#0C1015` |
| surface / sidebar | `#111419` |
| card | `#15181F` |
| surface-2 (inputs / nested) | `#171B21` |
| surface-3 hover | `#20242C` |
| border | `#FFFFFF14` (~8%) |
| primary (hub gold) | `#F2BC00` — **não forçar em SpaceBET purple** |
| success | `#3FC168` |
| destructive/live | `#EE343B` |

### 3.4 Escala obrigatória
```
Background → Surface → Card → Elevated/Surface-2 → Modal
```
Contraste adjacente perceptível (~4–6%). Preferir tom a sombra.

### 3.5 Aninhamento / encaixe `[INFERIDO hub]`
Dentro de card/modal: fills internos usam **surface-2 + border**, nunca `background` (some o delta) nem `card` sobre `card` sem outline.

### 3.6 Proibido
- Carpete brand (verde Betão, lime SAGA, laranja B1 full-surface).
- 4+ accents competindo.
- Branco puro `#FFFFFF` em quase todo texto dark.
- Gradiente decorativo em chrome (ok só em **arte** promo).

---

## 4. Tipografia e hierarquia

### 4.1 Família
- UI: **Inter** (Space DS + hub). `[AS-IS Space DS / INFERIDO player]`
- Logo/wordmark: nunca como fonte de UI.
- Máx **3 pesos** por tela: 400 / 600 / 700. Proibido `font-black` / extrabold.

### 4.2 Hierarquia em cards de jogo `[AS-IS Miguel]` (dor = título fraco)
| Elemento | Direção |
|----------|---------|
| Nome do jogo | Mais pesado/maior que meta (ex. 11–14 / 600–700) — **deve carregar** |
| Provider | Caption 10–12 muted |
| Ribbon | 10px / 700 / uppercase — único uppercase sistemático `[INFERIDO]` |
| Money R$ | tabular-nums + success |

### 4.3 Google / social auth `[AS-IS Miguel]` (dor = tipo inconsistente)
Botão Google: tipografia alinhada ao sistema (Inter / tamanhos do form), **não** misturar Roboto solto com pesos estranhos vs resto do modal. Ícone oficial ok; o **tipo** deve parecer do produto.

### 4.4 Anti
- Título de jogo com mesmo peso/cor do provider.
- Display 32px no chrome de lista.
- 9px ad-hoc em ribbon.
- Uppercase em labels de form.

---

## 5. Layout e viewport

### 5.1 Home bet — ordem mental `[INFERIDO hub]` + gosto Miguel
```
[Banner urgência opcional — máx 1]
[Header — Primary = Cadastrar]
[Prova social GLOBAL — UMA superfície (ticker OU painel) — ou ausente]
[Hero — estático / carrossel discreto]
[Category rail + Sidebar conforme breakpoint]
[Jackpot — pode incluir strip CONTEXTUAL de últimos ganhadores (nested)]
[Game rows densos]
[Painel Maiores ganhos / top winners — se for a prova social GLOBAL escolhida]
[Providers / trust COM logos]
[Footer estruturado — responsável + +18]
[Mobile: BottomNav; sem segundo Primary competindo]
```

> **Global** = faixa/painel full-bleed ou seção própria sob o chrome.  
> **Contextual** = lista dentro do card de um componente (jackpot etc.). Não contar contextual como “segunda prova social global”.

### 5.2 Sidebar `[AS-IS Miguel]` (gosta desktop + mobile)
- Desktop: sidebar de categorias/navegação com item ativo = accent brand (purple SpaceBET).
- Mobile: vira drawer/Sheet — **mesmo modelo mental**, não inventar IA nav.
- Evitar **duplicar** categorias sidebar + CategoryRail com o mesmo conteúdo na dobra (agonia QA).

### 5.3 Hero
- Estático prioritário; legibilidade do texto **sem** depender de degradê fraco.
- Sem chip HTML solto sobre foto promocional.

### 5.4 Densidades
| Contexto | Densidade |
|----------|-----------|
| Home jogos | Alta (tiles densos, gaps 8–12) |
| Auth | Média-baixa (foco no form) |
| Depósito | Média (quick amounts, 1 Popular) |
| Marketing Stripe-like | **Proibido** como home bet |

### 5.5 Jackpot / prova social `[AS-IS Miguel]` (atualizado 2026-09-21)

**Prova social GLOBAL** (chrome / faixa sob header / seção própria):

- Máximo **1** superfície contínua por viewport: ticker **ou** painel “maiores ganhos” (ou equivalente).
- **Anti:** ticker no chrome **e** painel de ranking na mesma Home competindo como duas faixas globais.
- Se o Apply removeu o ticker global para sanar FAIL de duplicata → **não** remountar o mesmo ticker no chrome sem mini-A + OK.

**Prova social CONTEXTUAL** (dentro de um componente nomeado):

- Lista de “últimos ganhadores” **dentro** do card Jackpot (ou equivalente) = **encaixe do componente**, não segunda superfície global.
- Pode coexistir com painel “Maiores ganhos” **se** o DS do produto nomear um `P-…` contextual e **não** houver ticker full-bleed sob o Header.
- Relocar dados do antigo ticker **para dentro** do card pedido pelo humano = caminho certo; remountar o componente global = caminho errado.

**IDs sugeridos no DS do produto** (quando o domínio tiver esses papéis — Forge §10.5):

| Papel | ID sugerido |
|-------|-------------|
| Ranking / maiores ganhos (**global**) | `P-WINS` |
| Ticker full-bleed (**global**, só se for a única) | `P-TICKER` |
| Card jackpot | `P-JACKPOT` |
| Lista nested no jackpot (**contextual**) | `P-JACKPOT-WINNERS` |

**Jackpot / painel:**

- Jackpot: valor + (opcional) lista nested legível **sem** glow; polish > teatro; mobile sem muro ilegível.
- Top winners / maiores ganhos (quando for a prova social global): thumbs 3:4, rank consistente.

### 5.6 Admin / B2B dashboard — padrões e anti-padrões `[AS-IS Miguel 2026-09-22]`

> Genérico (ex.: gateway admin, backoffice, fintech). Hex de marca = **produto**. Este § nomeia **forma**.  
> IDs `GP-…` / `AP-…` são gosto transversal; o DS do produto mapeia para `P-…`.  
> **Não** confundir com §5.5 (jackpot / prova social player).

#### Viewport de QA

- Desktop admin default: **~1300×800** (notebook), **mais** mobile. 1440 sozinho **esconde** crush de KPI/tabela (`GP-QA-NOTEBOOK`).

#### Padrões bons (`GP-…`)

| ID | Regra |
|----|--------|
| GP-AUTH-CARD | Auth: card denso, inputs h-10 radius ~8, nested surface, sem orbe/glow |
| GP-CTA-PAIR | Primary + outline mesma altura/radius; um Primary por seção |
| GP-FILTER-COLLAPSE | Filtros em card colapsável ok; header = título+chevron, **sem** faixa morta |
| GP-PAGE-PERIOD-IN-HEADER | Período/contexto no **header**, não em faixa que come 10–20% da dobra |
| GP-BADGE-ONE-SHAPE | **Um** radius/anatomia para status, delta e “conta ativa” |
| GP-TABLE-CANON | Texto L · número/R$ R · status L · ações R; ID **não** Primary; `⋯` se muitas colunas; **Total** em lista financeira; paginação **no** card |
| GP-FORM-LABEL-14 | Label ≥14/500, legível |
| GP-FORM-DENSE-ROW | Em grid form 2+ cols: **toda célula da row preenchida** ou o campo **span full**; CTAs Primary+outline **agrupados** (`gap` 8–12), nunca espalhados nas bordas; meta (ID, badge) **topo-alinhada** ou **empilhada** sob o valor — nunca `items-end` criando poço em cima |
| GP-SHEET-448 | Drawer create/edit ~448px |
| GP-PAGINATION-NESTED | Contador + per page + nav dentro do bloco da tabela |
| GP-GRAPH-OK | Chart com Primary + no máx. um accent de série (não no chrome) |

#### Anti-padrões (`AP-…`) — FAIL em Apply

| ID | Crime |
|----|--------|
| AP-NEON-PRIMARY | Primary hipersaturado/neon no navy (marca deve escolher chroma sóbrio) |
| AP-DUAL-BRAND | Segunda cor de marca no wordmark competindo com Primary |
| AP-CHROME-WASTE | Faixa só com subtítulo/filtro/breadcrumb inchado |
| AP-KPI-VOID | Poço vazio em KPI/card (“equalizar” colunas) |
| AP-BADGE-DRIFT | Vários shapes de badge na mesma UI |
| AP-TABLE-RAINBOW | >2 tintas de marca/dados na grade além do badge de status |
| AP-TABLE-ALIGN-CHAOS | Align L/C/R sem regra por tipo de coluna |
| AP-TABLE-NO-OVERFLOW | Sem picker `⋯` com grade larga |
| AP-TABLE-NO-TOTAL | Lista financeira sem rodapé de soma quando somável |
| AP-LABEL-MICRO | Label de form &lt; 14px |
| AP-FILTER-STRIP | Linha-título vazia (“Filtros”) |
| AP-PAGINATION-ORPHAN | Paginação entre seções / fora do card |
| AP-METRIC-CRUSH | 5–7 KPIs numa row rígida quebrando texto em ~1300 |
| AP-ID-AS-PRIMARY | ID/TXN pintado de Primary |
| AP-FORM-VOID | Stretch vazio em meia página form\|side (vão entre colunas de layout) |
| AP-GRID-HOLE | **Buraco intra-card:** última row do form em grid 2-col com **só 1 campo** e célula vizinha vazia (parece campo faltando) |
| AP-CTA-SPREAD | Par de CTAs com `justify-between` / um em cada borda — **deserto horizontal** entre Primary e outline |
| AP-META-BASELINE | Valor alto + meta (ID) com `items-end` / baseline inferior — **poço acima** da meta |
| AP-TWO-FONTS | Display/duas famílias dentro de célula de tabela |

#### Checklist admin (PASS/FAIL)

- [ ] Primary sóbrio (não neon) · um hue de ação  
- [ ] Wordmark sem segunda marca competindo  
- [ ] Sem faixa chrome morta; período no header  
- [ ] KPI/cards sem poço; métricas wrap em 1300  
- [ ] Um shape de badge  
- [ ] Tabela: align, sem rainbow, `⋯`, total se financeiro, paginação nested  
- [ ] Labels ≥14  
- [ ] Forms: sem AP-GRID-HOLE / AP-CTA-SPREAD / AP-META-BASELINE (caçar **dentro** do card, não só entre seções)  
- [ ] Scan feito em **1300** + mobile  
- [ ] Prints/círculos do humano no chat → cada um PASS/FAIL com evidência (proibido “mitigado” sem reabrir a rota)  

---

## 6. Componentes

### 6.1 Game cards `[AS-IS Miguel]` + specs hub
- Compactos; aspect **3:4** `[INFERIDO]`.
- Radius **8**; border neutra.
- Hover desktop: overlay escuro + CTA **Jogar** Primary radius 8 (**não pill**).
- Mobile: tile **inteiro tappable** (não depender só de hover).
- Badges: máx 2 (ribbon + Hot), sempre top-left, stack; ícone→expand no hover do chip.
- Contadores: jogadores + R$ success.

### 6.2 CTAs pares (Entrar / Cadastrar)
- Mesma altura (~40px / h-10), mesmo radius 8.
- Idle e hover **alinhados** (sem jump de box).
- 1 Primary por seção; outline = secondary.
- Mobile: **não** oversize (evitar botões que comem a dobra). Touch mínimo 44×44, mas visual **compacto** — Fitts ≠ botão monstro.

### 6.3 Auth overlay `[AS-IS Miguel]`
| Viewport | Spec |
|----------|------|
| Desktop | Dialog; split arte/form quando md+; arte **full-bleed** + card overlay na base; **zero poço** |
| Mobile | Sheet padrão celular; cadastro sem banner 16:6; card bônus compacto; login form-first + trust PIX/+18 |
| Overlay | Escurecimento polido (`black/65` + blur leve) — **não** fade pobre / flash |
| Segmented | Entrar \| Cadastrar alinhados |
| Social | Google consistente (ver §4.3) |

### 6.4 Footer `[AS-IS Miguel]` (dor = sem estrutura)
Obrigatório estruturar:
- Colunas/links claros (ajuda, termos, responsável).
- **Jogo responsável** + **+18** visíveis.
- Não é um amontoado de texto solto nem só logo.

### 6.5 Providers `[AS-IS Miguel]` (dor = sem logo)
- Rail/lista de provedores **com logo** (`object-contain`, altura consistente, ex. h-5).
- Nunca só nome texto quebrado / placeholder genérico.

### 6.6 Chrome / bordas `[AS-IS Miguel]` (dor = chrome borda errada)
- Header/sidebar/footer: borda 1px token (`#FFFFFF14` ou equivalente produto).
- Não misturar border “clara demais”, “sumida”, ou glow no lugar de borda.
- Nested: ver §3.5.

### 6.7 Deposit (referência de card, não de coluna vazia) `[INFERIDO hub]`
- Quick amounts; **1** chip Popular (default justo, não o máximo).
- Rollover legível antes do PIX.
- Sucesso seco (check + valor) — sem confetti.

---

## 7. Motion e feedback

### 7.1 Permitido
| Motion | Spec |
|--------|------|
| Hover UI | 150–200ms ease |
| Overlay open/close | ≤ 220ms |
| Hover tile | translate leve + scale img ≤ 1.05 · ≤300ms |
| Marquee winners | Lento; `prefers-reduced-motion` → estático |

### 7.2 Proibido `[AS-IS Miguel]` + Space DS
- Motion-overload / theater sem guia visual.
- Glow pulse (`animate-live-pulse`), flash a cada clique, bounce exagerado, confetti.
- Animações >400ms em chrome de produtividade/conversão.
- Hero com efeitos que destroem legibilidade.

### 7.3 Feedback
- Success/destructive só semânticos.
- Toasts curtos; empty/loading/error tratados (skeleton no shape do conteúdo).

---

## 8. Radius, borda, seleção (borda comida)

### 8.1 Escala Space / player `[AS-IS Miguel]` + DS
| Token | px | Uso |
|-------|-----|-----|
| sm | 4 | ribbon/chip |
| md controles | **8** | button, input, game card, amount |
| lg | 12 | modal desktop / card elevado (Space B2B cards) |
| xl | 16 | sheet mobile top / hero media |
| pill 9999 | **só** badge status / switch — **nunca** CTA form/jogo |

**Nota:** Glossário SpaceBET fala radius **8–12**. Space DS B2B: botão 8 · card 12 · modal 16. Em player hub: game card **8**. Em dúvida no SpaceBET player: **priorizar 8 em controles e tiles**; 12 em contêineres maiores.

### 8.2 Borda
- Default: `1px solid` border token (~8–10% white em dark).
- Focus: ring Primary suave + border Primary.
- Chrome errado = FAIL (ver checklist).

### 8.3 Borda comida (seleção) `[AS-IS Miguel]` conceito · `[INFERIDO]` implementação
**Definição operacional para agentes:**
1. Estado default: borda neutra 1px.
2. Estado selected/active: borda **Primary** mais presente (tipicamente 2px **ou** 1px Primary substituindo a neutra), “comendo” o contorno do componente — visual de peça **encaixada/selecionada**, não de halo.
3. Mesmo padrão em: category chip, quick amount, segmented tab, card selecionável, item sidebar ativo (sidebar pode somar fill Primary ~10–14% + texto Primary — ainda assim **sem** glow).
4. Proibido: glow externo colorido como “seleção”; fill brand 100% do card grande (vira carpete).

**Referência de segmento:** Betão — estudar seleção/tiles; **não** copiar fundo verde full.

---

## 9. Referências (o que copiar e o que NÃO)

| Referência | COPIAR | NÃO COPIAR |
|------------|--------|------------|
| **Linear** | Polish, alinhamento idle/hover, densidade limpa, tipografia, sensação de qualidade | Layout de issue tracker como home bet; monocromia fria demais se matar energia de cassino |
| **Stripe** | Craft de botões/controles, clareza de form | Home light/branca; marketing landing como shell do bet |
| **Betão** | Densidade cassino BR, seleção “borda comida”, linguagem de segmento | Fundo verde-brand full; qualquer coisa que mate a guia visual |
| **aesthetic-play-hub** | Estrutura Home, GameCard, Auth sheet, Jackpot, Winners, anti-glow | Primary gold se o produto for purple SpaceBET; badge Lovable host |
| **BetSpace Figma** | Navy + purple CTA, cards densos, radius médio | — |
| **B1 Bet** | — | Hero Fortune oversized, theater, carpete laranja |
| **IA SAGA** | Densidade dark ok | Lime/neon carpet, pills de status em excesso |
| **Cardapius** | — | Light/orange workspace como baseline SpaceBET |

Monocromia útil citada por Miguel: 1 accent + dark (SpaceBatch, dangpt, SHER AI) — válida para produtos monocromáticos; SpaceBET player usa purple como accent core.

---

## 10. Checklist de review (PASS / FAIL explícito)

Usar em toda entrega Lovable/PR visual SpaceBET ou hub bet. Marcar **PASS** ou **FAIL**. Qualquer FAIL bloqueia “ALIGNED”.

### Cor e superfície
- [ ] **PASS/FAIL** — Background/surface neutros dark; **sem** carpete de marca.
- [ ] **PASS/FAIL** — Primary/accent **só** em CTA/ativo/ring (hex do produto).
- [ ] **PASS/FAIL** — Escala Background→Card perceptível; nested com surface-2 + border.
- [ ] **PASS/FAIL** — Sem glow/neon/glass decorativo no chrome.

### Tipografia
- [ ] **PASS/FAIL** — Nome do jogo com hierarquia forte vs provider/meta.
- [ ] **PASS/FAIL** — ≤3 pesos; sem black/extrabold; Inter (ou stack aprovada).
- [ ] **PASS/FAIL** — Botão Google com tipo consistente com o form.

### Layout / viewport
- [ ] **PASS/FAIL** — **Uma** guia visual por viewport (1 Primary forte no chrome da dobra).
- [ ] **PASS/FAIL** — Hero estático/legível; sem motion theater / layout quebrado.
- [ ] **PASS/FAIL** — Prova social **GLOBAL**: ticker **ou** painel (não os dois). Strip nested em componente (ex. jackpot) **não** conta como duplicata global se o DS nomeou o padrão.
- [ ] **PASS/FAIL** — Sidebar presente no modelo desktop; mobile = drawer/sheet coerente.
- [ ] **PASS/FAIL** — Jackpot / top winners legíveis (gosto Miguel), sem muro ilegível; lista contextual no jackpot sem glow/teatro.

### Componentes
- [ ] **PASS/FAIL** — Game cards densos; radius ~8; CTA Jogar não-pill; mobile tappable.
- [ ] **PASS/FAIL** — Par Entrar/Cadastrar alinhado idle **e** hover (mesma altura/radius).
- [ ] **PASS/FAIL** — Deslogado: Cadastro = **Primary sólido** da marca (não outline “por conceito”).
- [ ] **PASS/FAIL** — CTA mobile compacto (não oversize), touch ≥44.
- [ ] **PASS/FAIL** — Auth: overlay polido; desktop sem poço; mobile sheet padrão celular.
- [ ] **PASS/FAIL** — Providers **com logo**.
- [ ] **PASS/FAIL** — Footer estruturado + jogo responsável + +18.
- [ ] **PASS/FAIL** — Chrome com borda token correta (não “errada”/sumida/glow).

### Radius / seleção / motion
- [ ] **PASS/FAIL** — Controles ~8; pill só status; sem look IA.
- [ ] **PASS/FAIL** — Seleção “borda comida” **consistente** em chips/tabs/cards/sidebar.
- [ ] **PASS/FAIL** — Encaixe > glow.
- [ ] **PASS/FAIL** — Motion ≤220ms overlays; sem pulse glow; prefers-reduced-motion respeitado.

### Referências (sanity)
- [ ] **PASS/FAIL** — Não parece Stripe home light.
- [ ] **PASS/FAIL** — Não parece Betão green carpet.
- [ ] **PASS/FAIL** — Polish no nível Linear (alinhamentos, estados).

---

## 11. Lacunas — o que ainda precisa Miguel confirmar

Itens abertos nos docs (`07-glossario`, `page_06`, inventário B1). Agente **não inventa** resposta:

1. **URL explícita que Miguel odeia** (anti-exemplo canônico além dos já listados B1/SAGA/Stripe home) — ainda pendente.
2. **Áudios de review** (“áudios de ontem” no glossário) → regras finas de home bet / jogos / auth que o Figma não cobre — não transcritos neste box.
3. **Figma Design file BetSpace com tokens nomeados** — proto ok; design file historicamente **403** / login.
4. **Definição pixel-perfect de “borda comida”** (espessura 1 vs 2px, inset vs replace, radius da borda) — conceito AS-IS; medida exata **INFERIDA** até Miguel validar com print Betão anotado.
5. **Primary hex oficial SpaceBET player em produção** vs purple Figma vs gold hub — qual token manda em cada white-label / tenant.
6. **Aprovação humana** para promover aesthetic-play-hub DS 0.1.0-draft e este guia a skill/pack (ainda rascunho operacional).
7. **Figma SpaceBatch** citado como faltante no inventário de problemas B1.
8. **Depósito mobile sheet** — parcialmente coberto no hub; validar gosto Miguel em white-label SpaceBET real.
9. ~~BottomNav vs header Primary~~ — **RESOLVIDO 2026-09-21:** deslogado → Cadastro = Primary da marca (não outline “por conceito”). Ainda evitar dois Primaries competindo no mesmo papel.
10. **Monocromia dangpt/SHER** — quando aplicar vs purple BetSpace em produtos irmãos.

---

## Apêndice A — Mapa rápido GOSTA / DÓI

### GOSTA `[AS-IS Miguel]`
- Combo de cores dark + 1 accent (quando bem feito)
- Cards de jogo compactos
- Sidebar desktop **e** mobile (modelo coerente)
- Auth overlays bem resolvidos
- Mobile signup “padrão celular”
- Top winners
- Jackpot mobile (informação clara)

### DÓI `[AS-IS Miguel]`
- Hero layout quebrado
- Motion-overload sem guia visual
- Type hierarchy fraca no título do jogo
- CTA Entrar/Cadastrar desalinhado
- Overlay fade pobre
- Google com tipografia inconsistente
- Chrome com borda errada
- CTA mobile oversized
- Providers sem logo
- Footer sem estrutura
- Fundo brand full; light Stripe home; texto de hero ilegível com degradê

---

## Apêndice B — Frase de ordem para colar no Lovable/Cursor

> Siga `docs/ui-gosto.md` (pack space-cursor-skills). Marca do produto manda no Primary (**sem neon**). Dark surface neutra; brand só em CTA/ativo. Wordmark sem segunda cor competindo. Radius ~8, sem pill/glow. Admin: §5.6 (tabela canônica, badge único, sem chrome waste / KPI void / **grid-hole / CTA-spread / meta-baseline** / pagination órfã). QA admin ~1300px. Cadastro deslogado = Primary. Checklist PASS/FAIL. Admin ≠ energia cassino.

---

## 12. Anti-slop (AI tells) — Space-compatible

Adaptado de [Taste Skill](https://github.com/Leonxlnx/taste-skill) (método). **Não** importar bans Inter/Lucide/glass-as-upgrade.

| Tell (matar) | Preferir |
|--------------|----------|
| Gradient purple / mesh “AI default” | Neutrals + 1 accent da **marca** |
| Multi-accent / carnaval | Color consistency lock — 1 Primary |
| Glow / neon / live-pulse / glass no chrome | Encaixe + border + delta de surface |
| 3 feature cards idênticos (marketing) | Ritmo assimétrico ou rows do produto |
| Cards dentro de cards / fill igual empilhado | surface-2 + border |
| Fake UI de divs como “screenshot” | Arte real ou omitir |
| Pill em CTA form/jogo | Radius ~8 |
| Motion theater / scroll cue / hero ilegível | Hero estático, legível |
| Chip HTML sobre foto hero | Arte comunica |

**Output completo (patches):** proibido `// ...`, “resto igual”, skeleton no lugar de implementação — ver `design-system-apply/reference-anti-slop.md`.

---

## Versionamento

| Versão | Data | Notas |
|--------|------|-------|
| 2.0.0 | 2026-09-21 | Guia 33 canônico + decisões Miguel (marca>gosto, admin≠cassino, borda contextual, Cadastro deslogado=Primary) + AI tells Taste |
| 2.1.0 | 2026-09-22 | §5.6 admin GP/AP (tabela, badge, chrome waste, KPI void, QA 1300); anti-neon Primary; wordmark sem dual-brand; §5.5 permanece jackpot |
| 2.1.1 | 2026-09-22 | Admin movido para §5.6 (evita colisão com jackpot §5.5); mapa README |
| 2.2.0 | 2026-09-23 | §5.6: GP-FORM-DENSE-ROW; AP-GRID-HOLE / AP-CTA-SPREAD / AP-META-BASELINE; checklist caça **intra-card** + prints humanos |
