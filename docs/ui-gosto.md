# Gosto visual Space — constituição para Forge e Apply

> Guarda-corpo de **gosto** para as skills `design-system-forge` (confronto antes de entregar) e `design-system-apply` (confronto na Fase A + régua do Scan).  
> **Não** substitui [`design-system.md`](design-system.md) (metodologia/tokens Space B2B) nem o `.docs/DESIGN_SYSTEM.md` do produto.  
> Skills leem [README.md](README.md) primeiro.  
> **Escopo:** visual / UX. Código Front (AP-FE, FDD) **fora** — isso é `qa-space`.  
> **Estrutura:** §1–§10 = **parte geral** (vale para todo produto). §11 = **regras por tipo de produto** (cassino, admin…). §12 = anti-slop (geral).  
> **Marcas:** `[AS-IS]` = decisão travada pelo dono do gosto (reviews, glossário, Figma, decisões 2026-09-21/22). `[INFERIDO]` = consolidado de hubs/QA — alinhar com o humano se houver dúvida.  
> **Origem:** guia 33 (`uiux-miguel-pack`) + decisões 2026-09-21/22 + AI tells compatíveis ([Taste Skill](https://github.com/Leonxlnx/taste-skill) — método, não estética).

---

## 0. Como Forge e Apply usam isto

```text
1. Marca do produto (manual da marca / tokens)   ← sempre prevalece na cor e na fonte
2. DS do produto (.docs/DESIGN_SYSTEM.md)        ← P-…, Primary da MARCA
3. Este arquivo: parte geral (§1–§10, §12)       ← o que a Space gosta / odeia (preenche buracos)
4. Este arquivo: §11 do tipo do produto          ← só as seções do(s) tipo(s) do produto
5. design-system.md                              ← método, escalas, §18 (admin/tabelas)
6. Fonte visual (site, construtor, canvas)       ← hierarquia/campos — NÃO glow/ruído como lei
```

### Prioridade de verdade (travado 2026-09-21)

1. **Cor / tokens / fonte da MARCA do produto** (manual, repo, brief) — **sempre prevalece**.  
2. **Este gosto** — só o que a marca **ainda não** define.  
3. Space DS boilerplate — método nos buracos (radius, anti-glow, tabelas admin).  
4. Fonte visual (mock, construtor, telas antigas) — campos e fluxos; **nunca** Primary/glow do mock contra a marca.

### Tipo de produto

| Situação | O que aplicar |
|----------|---------------|
| Todo produto | Parte geral (§1–§10) + anti-slop (§12) |
| Tipo com seção em §11 (ex.: cassino, admin/B2B) | Geral + a seção do tipo |
| Produto com mais de um tipo (ex.: área do jogador + backoffice) | Geral + cada seção, por superfície |
| Tipo sem seção em §11 | Só a parte geral. As seções de outros tipos ficam **"não se aplica"**, com motivo, no relatório / EXTRACTION_NOTES |

Proibido puxar regra de um tipo para outro (ex.: energia de cassino em admin; tiles 3:4 em catálogo de loja).

### Job de cada skill

| Skill | Uso |
|-------|-----|
| **Forge** | Antes do STOP: confrontar o DS (documento + canvas) com geral + tipo. Fora do gosto → corrigir **ou** exceção nomeada com OK humano. |
| **Apply** | Fase A: confrontar de novo (o DS pode ter mudado) e alterar o DS. Fases B/C: régua do Scan e do Fix. |
| **Ambos** | **Review humano no workspace** (notas, prints, clip) = checklist ALTA — **não** ALIGNED / PASS enquanto bullet ALTA falhar. Conflito DS × review → mini-A, não PASS silencioso. |

---

## 1. Propósito

Evitar que o agente improvise “deixe bonito”, “mais premium” ou “neon”. Anti-exemplo genérico: **tudo com cara de IA** (anti-padrões novos = review humano).

### Como DEVE usar

1. Ler **a parte geral inteira** + a(s) seção(ões) do tipo em §11 antes de normalizar DS ou refatorar UI.  
2. Respeitar a prioridade de verdade §0.  
3. Hex e fonte vêm do **produto** (manual da marca), não deste guia.  
4. Entregar checklist §10 (+ checklist do tipo) com **PASS/FAIL** explícito.  
5. Lacunas → registrar como aberto, não inventar.

### O que NÃO fazer

- Resumir em 3 bullets vagos.  
- Home light marketing tipo Stripe como shell de produto dark; glass/glow multi; pill em CTA de form.  
- Linear como template de layout (Linear = **polish**).  
- Trocar a família de ícones / fonte da marca por gosto pessoal (Taste Skill desencoraja Inter/Lucide — **Space aceita** Inter + Lucide como padrão quando a marca não define).  
- Forçar “borda comida 2px” em todo botão (ver G7).

---

## 2. Princípios gerais

Cada princípio: **regra / por quê / exemplo bom / anti-exemplo**.

### G1 — Tema principal com superfícies neutras; marca só em ação e acentos
- **Regra `[AS-IS]`:** Superfícies **neutras** (no dark: navy/charcoal/near-black; no claro: cinzas frios). Cor de marca **somente** em CTA primário, item ativo, anel de foco, acento pontual. **Nunca** carpete full-bleed da marca no background. Dark é o padrão da casa quando a marca não decide o tema principal.
- **Por quê:** Selective Attention — se tudo é marca, nada é ação. O olho não sabe onde clicar.
- **Bom:** Background escuro neutro · card um pouco mais claro · botão principal preenchido com a cor da marca.
- **Anti:** Página inteira na cor da marca como fundo; hero com wash da marca cobrindo 60% da dobra.

### G2 — Uma guia visual por viewport + Primary na ação real
- **Regra `[AS-IS]` (atualizado 2026-09-21):** Em cada viewport, **um** caminho visual dominante. Máximo **1** urgência e **1** Primary forte no chrome da dobra — e esse Primary está na **ação principal real** do estado atual (deslogado, logado, sem saldo…).
- **Por quê:** Von Restorff + Goal-Gradient — o olho deve achar a conversão.
- **Bom:** Deslogado: a ação principal (ex.: criar conta) é Primary sólido. Logado: a ação principal do produto é o Primary.
- **Anti:** Dois Primaries competindo no mesmo papel (header sólido + FAB sólido); ação principal só em outline “por conceito” quando é ela que converte; várias faixas globais gritando ao mesmo tempo.

### G3 — Hero estático > motion theater
- **Regra `[AS-IS]`:** Hero pode ter carrossel **discreto**, mas **não** overload de parallax, partículas, glow pulse, texto ilegível em degradê, chips HTML soltos sobre arte.
- **Por quê:** Peak-End: o pico deve ser **legível e confiante**, não um show de IA.
- **Bom:** Banner com arte forte, tipografia legível, CTA claro; troca de slide sem teatro.
- **Anti:** Hero quebrado; texto branco em degradê fraco; chip “Em alta” HTML por cima da foto; pulse.

### G4 — CTAs em par alinhados (idle + hover)
- **Regra `[AS-IS]`:** Pares como **Entrar / Criar conta** (outline + primary) têm **mesma altura, mesmo radius, alinhamento baseline**, e hover que **não desalinha**.
- **Por quê:** Similarity + polish Linear. Desalinhamento idle/hover é agonia citada explicitamente.
- **Bom:** Entrar `outline` h-10 radius-8 · Criar conta `primary` h-10 radius-8 · hover só troca cor/brilho, caixa estável.
- **Anti:** Um pill e outro retângulo; um h-9 e outro h-12; hover com scale diferente que “pula” o par.

### G5 — Radius médio ~8; encaixado; NÃO pill/IA
- **Regra `[AS-IS]`:** Controles e cards em família **~8px** (salvo marca que defina outra escala). Nested/encaixado (camadas de superfície + borda). **Proibido** look pill em CTA de form.
- **Por quê:** Similarity familiar sem “brinquedo/IA”. Pill = assinatura de genérico de IA.
- **Bom:** Button/input/card `8px`; modal desktop `12px`; sheet mobile top `16px` `[INFERIDO]`.
- **Anti:** `rounded-full` em CTA; `rounded-3xl` em tudo; cards com glow em vez de encaixe.

### G6 — Encaixe > glow
- **Regra `[AS-IS]`:** Hierarquia por **delta de superfície (~4–6%) + borda 1px**, não por sombra multi-layer, neon ou glow.
- **Por quê:** Aesthetic-Usability por clareza; Space §7/§18.
- **Bom:** Card um degrau mais claro que o fundo + borda branca ~8%.
- **Anti:** `box-shadow` colorido, pulse, glass blur decorativo no chrome.

### G7 — Seleção e bordas (contexto > dogma)
- **Regra `[AS-IS]` (atualizado 2026-09-21):** Seleção/ativo **consistente no produto**. “Borda comida” (§8.3) é válida quando o sistema quer essa linguagem — **não** é lei universal de 2px.
- **Botões:** em geral **borda fina elegante** **ou** **subtons**. Contexto e tom do produto mandam.
- **Por quê:** Similarity de seleção = produto sério; over-spec de borda vira dogma.
- **Bom:** Um padrão de seleção escolhido e repetido (chips, tabs, sidebar, cards selecionáveis).
- **Anti:** Misturar ring + fill marca + glow como “seleção”; carpete Primary no card; glow externo como seleção.

### G8 — Referências de qualidade ≠ referências de layout
- **Regra `[AS-IS]`:**
  - **Linear:** espelhar **nível de polish** (alinhamento, idle/hover, densidade limpa, tipografia).
  - **Stripe:** botões/controles como referência de craft; **home light marketing Stripe NÃO** é shell de produto dark.
  - Referência de **segmento** (concorrente do mesmo mercado): respeitar densidade e linguagem do segmento, **sem** copiar cor/fundo. Ver §11 do tipo.
- **Por quê:** separar “qualidade” de “layout de produto”.
- **Anti:** Landing branca Stripe como shell; dashboard frio onde o segmento pede energia; copiar fundo de concorrente.

---

## 3. Cor e superfície

### 3.1 Metodologia (sempre)
1. **Primary** vem da marca do produto (manual / repo). Não misturar com Primary de outro produto.
2. Família **Surface** neutra no tema principal.
3. Feedback (success/destructive/warning) **nunca** vira carpete de marca.

### 3.2 Escala obrigatória
```
Background → Surface → Card → Elevated/Surface-2 → Modal
```
Contraste adjacente perceptível (~4–6%). Preferir tom a sombra.

### 3.3 Aninhamento / encaixe `[INFERIDO]`
Dentro de card/modal: fills internos usam **surface-2 + border**, nunca `background` (some o delta) nem `card` sobre `card` sem outline.

### 3.4 Proibido
- Carpete de marca (cor da marca como fundo full-surface).
- 4+ acentos competindo.
- Branco puro `#FFFFFF` em quase todo texto no dark.
- Gradiente decorativo em chrome (ok só em **arte** promocional).

---

## 4. Tipografia e hierarquia

### 4.1 Família
- UI: a fonte da **marca**; se a marca não define, **Inter** (Space DS). `[AS-IS Space DS]`
- Logo/wordmark: nunca como fonte de UI.
- Máx **3 pesos** por tela (ex.: 400 / 600 / 700). Proibido `font-black` / extrabold.

### 4.2 Hierarquia em cards de conteúdo `[AS-IS]` (dor = título fraco)
O nome do item principal (produto, anúncio, jogo…) é **mais pesado/maior** que a meta (quem vende, fornecedor, categoria). Meta em legenda muted.

### 4.3 Login social `[AS-IS]` (dor = tipo inconsistente)
Botão Google/Apple: tipografia alinhada ao sistema (mesma família e tamanhos do form), **não** misturar fonte solta com pesos estranhos. Ícone oficial ok; o **tipo** deve parecer do produto.

### 4.4 Anti
- Título do item com mesmo peso/cor da meta.
- Display 32px no chrome de lista.
- Tamanho ad-hoc fora da escala (ex.: 9px).
- Uppercase em labels de form.

---

## 5. Layout e viewport

### 5.1 Hero
- Estático prioritário; legibilidade do texto **sem** depender de degradê fraco.
- Sem chip HTML solto sobre foto promocional.

### 5.2 Navegação lateral `[AS-IS]`
- Desktop: sidebar (quando o produto tiver) com item ativo = acento da marca.
- Mobile: vira drawer/sheet — **mesmo modelo mental**, não inventar navegação nova.
- Evitar **duplicar** o mesmo conteúdo em sidebar + barra de categorias na mesma dobra.

### 5.3 Densidades
| Contexto | Densidade |
|----------|-----------|
| Listas / catálogo / grade de itens | Alta ou média, conforme o segmento (§11) |
| Auth | Média-baixa (foco no form) |
| Pagamento / compra | Média (valores rápidos, 1 destaque) |
| Marketing light tipo Stripe | **Proibido** como shell de produto dark |

---

## 6. Componentes (geral)

### 6.1 CTAs pares
- Mesma altura (~40px / h-10), mesmo radius.
- Idle e hover **alinhados** (sem jump de caixa).
- 1 Primary por seção; outline = secondary.
- Mobile: **não** oversize. Touch mínimo 44×44, mas visual **compacto** — Fitts ≠ botão monstro.

### 6.2 Auth overlay `[AS-IS]`
| Viewport | Spec |
|----------|------|
| Desktop | Dialog; split arte/form quando md+; **zero poço** (coluna vazia) |
| Mobile | **Sheet** (não dialog desktop encolhido); fluxo “padrão celular”; CTA sticky |
| Overlay | Escurecimento polido (ex.: preto ~65% + blur leve) — **não** fade pobre / flash |
| Alternância | Entrar \| Criar conta alinhados |
| Social | Consistente com o form (§4.3) |

### 6.3 Rodapé `[AS-IS]` (dor = sem estrutura)
- Colunas/links claros (ajuda, termos, privacidade, avisos legais do segmento).
- Não é um amontoado de texto solto nem só logo.

### 6.4 Logos de terceiros `[AS-IS]` (dor = sem logo)
- Parceiros, lojas, fornecedores, meios de pagamento: **com logo** (`object-contain`, altura consistente).
- Nunca só nome em texto quebrado / placeholder genérico.

### 6.5 Chrome / bordas `[AS-IS]` (dor = borda errada)
- Header/sidebar/footer: borda 1px token do produto.
- Não misturar borda “clara demais”, “sumida”, ou glow no lugar de borda.
- Nested: ver §3.3.

---

## 7. Motion e feedback

### 7.1 Permitido
| Motion | Spec |
|--------|------|
| Hover UI | 150–200ms ease |
| Overlay open/close | ≤ 220ms |
| Hover card | translate leve + scale de imagem ≤ 1.05 · ≤300ms |
| Faixa rolante (se o tipo permitir) | Lenta; `prefers-reduced-motion` → estática |

### 7.2 Proibido `[AS-IS]` + Space DS
- Motion-overload / teatro sem guia visual.
- Glow pulse, flash a cada clique, bounce exagerado, confetti.
- Animações >400ms em chrome de produtividade/conversão.
- Hero com efeitos que destroem legibilidade.

### 7.3 Feedback
- Success/destructive só semânticos.
- Toasts curtos; empty/loading/error tratados (skeleton no formato do conteúdo).
- Sucesso seco (check + valor) — sem confetti.

---

## 8. Radius, borda, seleção

### 8.1 Escala padrão (quando a marca não define) `[AS-IS]` + DS
| Token | px | Uso |
|-------|-----|-----|
| sm | 4 | ribbon/chip |
| md controles | **8** | button, input, card, valor rápido |
| lg | 12 | modal desktop / card elevado |
| xl | 16 | sheet mobile top / mídia de hero |
| pill 9999 | **só** badge de status / switch — **nunca** CTA de form |

### 8.2 Borda
- Default: `1px solid` border token (~8–10% branco no dark).
- Focus: ring Primary suave + borda Primary.
- Chrome errado = FAIL.

### 8.3 Borda comida (seleção) — conceito `[AS-IS]` · implementação `[INFERIDO]`
**Definição operacional para agentes:**
1. Default: borda neutra 1px.
2. Selected/active: borda **Primary** mais presente (tipicamente 2px **ou** 1px Primary substituindo a neutra), “comendo” o contorno — peça **encaixada/selecionada**, não halo.
3. Mesmo padrão em: chip, valor rápido, aba segmentada, card selecionável, item ativo da sidebar (sidebar pode somar fill Primary ~10–14% + texto Primary — **sem** glow).
4. Proibido: glow externo colorido como seleção; fill da marca em 100% de card grande (vira carpete).

---

## 9. Referências gerais (o que copiar e o que NÃO)

| Referência | COPIAR | NÃO COPIAR |
|------------|--------|------------|
| **Linear** | Polish, alinhamento idle/hover, densidade limpa, tipografia | Layout de issue tracker como home de produto de consumo |
| **Stripe** | Craft de botões/controles, clareza de form | Home light/branca como shell de produto dark |

Monocromia útil: 1 acento + dark — válida para produtos monocromáticos. Referências de segmento ficam em §11.

---

## 10. Checklist geral (PASS / FAIL explícito)

Usar em toda entrega visual (canvas, construtor ou código). Marcar **PASS** ou **FAIL**. Qualquer FAIL bloqueia “ALIGNED”. Somar o checklist do tipo em §11.

### Cor e superfície
- [ ] **PASS/FAIL** — Superfícies neutras no tema principal; **sem** carpete de marca.
- [ ] **PASS/FAIL** — Primary/acento **só** em CTA/ativo/ring (hex do produto).
- [ ] **PASS/FAIL** — Escala Background→Card perceptível; nested com surface-2 + border.
- [ ] **PASS/FAIL** — Sem glow/neon/glass decorativo no chrome.

### Tipografia
- [ ] **PASS/FAIL** — Título do item com hierarquia forte vs meta.
- [ ] **PASS/FAIL** — ≤3 pesos; sem black/extrabold; fonte da marca (ou Inter).
- [ ] **PASS/FAIL** — Login social com tipo consistente com o form.

### Layout / viewport
- [ ] **PASS/FAIL** — **Uma** guia visual por viewport (1 Primary forte no chrome da dobra, na ação real).
- [ ] **PASS/FAIL** — Hero estático/legível; sem motion theater / layout quebrado.
- [ ] **PASS/FAIL** — Navegação desktop e mobile com o mesmo modelo mental.

### Componentes
- [ ] **PASS/FAIL** — Par de CTAs alinhado idle **e** hover (mesma altura/radius).
- [ ] **PASS/FAIL** — CTA mobile compacto (não oversize), touch ≥44.
- [ ] **PASS/FAIL** — Auth: overlay polido; desktop sem poço; mobile em sheet.
- [ ] **PASS/FAIL** — Logos de terceiros **com logo**.
- [ ] **PASS/FAIL** — Rodapé estruturado.
- [ ] **PASS/FAIL** — Chrome com borda token correta.

### Radius / seleção / motion
- [ ] **PASS/FAIL** — Controles ~8 (ou escala da marca); pill só status; sem look IA.
- [ ] **PASS/FAIL** — Seleção **consistente** em chips/tabs/cards/sidebar.
- [ ] **PASS/FAIL** — Encaixe > glow.
- [ ] **PASS/FAIL** — Motion ≤220ms em overlays; sem pulse glow; `prefers-reduced-motion` respeitado.

### Referências (sanity)
- [ ] **PASS/FAIL** — Não parece Stripe home light (se o produto é dark).
- [ ] **PASS/FAIL** — Polish no nível Linear (alinhamentos, estados).

---

## 11. Regras por tipo de produto

Cada seção soma à parte geral. Tipo que não se aplica ao produto = **“não se aplica”** com motivo (ex.: “produto de comparação de preços — sem jogos nem apostas”).

### 11.1 Cassino / apostas (área do jogador, home de apostas, marketing de bet)

#### 11.1.1 Princípios do tipo `[AS-IS]`
- **Cadastro deslogado = Primary sólido** da marca (header e/ou FAB). **Proibido** deixar Cadastro só outline “por conceito”. Logado: Primary tipicamente Depositar / jogar conforme o DS do produto. (Aplicação de G2.)
- **Densidade de cassino nos cards:** cards de jogo **compactos/densos**; o nome do jogo se lê pela **hierarquia tipográfica + arte**, não por moldura arejada tipo SaaS. Por quê: Jakob (cassino BR) + Common Region. Bom: tile ~3:4 `[INFERIDO]`, nome 11–14 semibold, provedor em legenda muted, gap 8–12. Anti: card com padding generoso, título fraco, muralha de jogos sem ritmo de linhas.
- **Auth mobile = ouro; cadastro “padrão celular”:** campos mentais de celular (celular, CPF, e-mail, senha), card de oferta **compacto**, sem banner 16:6 / poço vazio. Bom: sheet `h-auto` / máx. 92vh, CTA sticky. Anti: poço 92vh vazio; CTA oversize.
- **Referência de segmento:** Betão (`https://betao.bet.br/`) — seleção, densidade, linguagem cassino BR. **Não** copiar fundo verde full.

#### 11.1.2 Cor (marcas da casa) `[AS-IS]`
| Marca | Direção |
|-------|---------|
| SpaceBET / BetSpace | Surface navy / indigo / charcoal · acento **purple / magenta** em CTA, sidebar ativo, chevrons · texto off-white + lavanda-cinza muted · status verde ok, âmbar pendente |

Hub aesthetic (só referência de estrutura) `[INFERIDO]`:

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

Proibido: carpete verde Betão, lime SAGA, laranja B1 full-surface.

#### 11.1.3 Tipografia do tipo `[AS-IS]`
| Elemento | Direção |
|----------|---------|
| Nome do jogo | Mais pesado/maior que meta (ex. 11–14 / 600–700) — **deve carregar** |
| Provedor | Legenda 10–12 muted |
| Ribbon | 10px / 700 / uppercase — único uppercase sistemático `[INFERIDO]` |
| Dinheiro R$ | tabular-nums + success |

#### 11.1.4 Home de apostas — ordem mental `[INFERIDO]` + gosto
```
[Banner urgência opcional — máx 1]
[Header — Primary = Cadastrar]
[Prova social GLOBAL — UMA superfície (ticker OU painel) — ou ausente]
[Hero — estático / carrossel discreto]
[Barra de categorias + Sidebar conforme breakpoint]
[Jackpot — pode incluir strip CONTEXTUAL de últimos ganhadores (nested)]
[Linhas de jogos densas]
[Painel Maiores ganhos — se for a prova social GLOBAL escolhida]
[Provedores / confiança COM logos]
[Rodapé estruturado — jogo responsável + +18]
[Mobile: BottomNav; sem segundo Primary competindo]
```

> **Global** = faixa/painel full-bleed ou seção própria sob o chrome.  
> **Contextual** = lista dentro do card de um componente (jackpot etc.). Não contar contextual como “segunda prova social global”.

Densidades: home de jogos alta (tiles densos, gaps 8–12); depósito média (valores rápidos, 1 Popular).

#### 11.1.5 Prova social — global × contextual `[AS-IS]` (atualizado 2026-09-21)

**Prova social GLOBAL** (chrome / faixa sob header / seção própria):

- Máximo **1** superfície contínua por viewport: ticker **ou** painel “maiores ganhos” (ou equivalente).
- **Anti:** ticker no chrome **e** painel de ranking na mesma Home competindo como duas faixas globais.
- Se o Apply removeu o ticker global para sanar FAIL de duplicata → **não** remountar o mesmo ticker no chrome sem mini-A + OK.

**Prova social CONTEXTUAL** (dentro de um componente nomeado):

- Lista de “últimos ganhadores” **dentro** do card Jackpot (ou equivalente) = **encaixe do componente**, não segunda superfície global.
- Pode coexistir com painel “Maiores ganhos” **se** o DS do produto nomear um `P-…` contextual e **não** houver ticker full-bleed sob o Header.
- Relocar dados do antigo ticker **para dentro** do card pedido pelo humano = caminho certo; remountar o componente global = caminho errado.

**IDs sugeridos no DS do produto** (quando o domínio tiver esses papéis):

| Papel | ID sugerido |
|-------|-------------|
| Ranking / maiores ganhos (**global**) | `P-WINS` |
| Ticker full-bleed (**global**, só se for a única) | `P-TICKER` |
| Card jackpot | `P-JACKPOT` |
| Lista nested no jackpot (**contextual**) | `P-JACKPOT-WINNERS` |

**Jackpot / painel:** valor + (opcional) lista nested legível **sem** glow; polish > teatro; mobile sem muro ilegível. Maiores ganhos: thumbs 3:4, rank consistente.

**Apply — situações:**

| Situação | Ação |
|----------|------|
| Ticker **global** + painel “maiores ganhos” na mesma Home | P1 / FAIL gosto — sanar (escolher **uma** superfície global) |
| Remover ticker global no Fix para ALIGNED | OK |
| Remountar ticker full-bleed sob Header sem mini-A | **Proibido** |
| Humano pede lista de ganhadores **dentro** de card (ex. jackpot) | Mini-A: nomear contextual no DS (`P-JACKPOT-WINNERS`) → OK → Fix nested; **não** remountar ticker no chrome |
| Strip nested no jackpot + painel Maiores ganhos | **PASS** se não houver ticker global e o DS nomeou o nested |

#### 11.1.6 Componentes do tipo `[AS-IS]`
- **Game cards:** compactos; aspect **3:4** `[INFERIDO]`; radius **8**; borda neutra; hover desktop = overlay escuro + CTA **Jogar** Primary radius 8 (**não pill**); mobile = tile **inteiro tocável**; badges máx. 2 (ribbon + Hot) top-left; contadores jogadores + R$ success.
- **Auth:** desktop com arte **full-bleed** + card overlay na base; mobile login form-first + confiança PIX / +18; overlay `black/65` + blur leve.
- **Rodapé:** **Jogo responsável** + **+18** visíveis.
- **Provedores:** rail com logo (`object-contain`, ex. h-5).
- **Depósito** `[INFERIDO hub]`: valores rápidos; **1** chip Popular (default justo, não o máximo); rollover legível antes do PIX; sucesso seco.
- **Motion:** marquee de ganhadores lento; `prefers-reduced-motion` → estático.
- **Radius:** glossário SpaceBET fala 8–12. Em dúvida no player: **8 em controles e tiles**; 12 em contêineres maiores.
- **Sidebar:** item ativo = purple SpaceBET (ou acento da marca do tenant).

#### 11.1.7 Referências do segmento
| Referência | COPIAR | NÃO COPIAR |
|------------|--------|------------|
| **Betão** | Densidade cassino BR, seleção “borda comida”, linguagem de segmento | Fundo verde-brand full |
| **aesthetic-play-hub** | Estrutura Home, GameCard, Auth sheet, Jackpot, Winners, anti-glow | Primary gold se o produto for purple; badge de host do construtor |
| **BetSpace Figma** | Navy + purple CTA, cards densos, radius médio | — |
| **B1 Bet** | — | Hero oversized, teatro, carpete laranja |
| **IA SAGA** | Densidade dark ok | Lime/neon carpet, pills de status em excesso |
| **Cardapius** | — | Light/orange workspace como baseline de bet |
| **Linear** (no bet) | Polish | Monocromia fria demais se matar energia de cassino |

Monocromia (SpaceBatch, dangpt, SHER AI): válida para produtos monocromáticos; SpaceBET player usa purple como acento core.

#### 11.1.8 Checklist do tipo (PASS / FAIL)
- [ ] **PASS/FAIL** — Nome do jogo com hierarquia forte vs provedor.
- [ ] **PASS/FAIL** — Deslogado: Cadastro = **Primary sólido** da marca.
- [ ] **PASS/FAIL** — Prova social **GLOBAL**: ticker **ou** painel (não os dois). Strip nested nomeado no DS não conta como duplicata.
- [ ] **PASS/FAIL** — Sidebar no desktop; mobile = drawer/sheet coerente.
- [ ] **PASS/FAIL** — Jackpot / maiores ganhos legíveis, sem muro ilegível; lista contextual sem glow/teatro.
- [ ] **PASS/FAIL** — Game cards densos; radius ~8; CTA Jogar não-pill; mobile tocável.
- [ ] **PASS/FAIL** — Auth mobile padrão celular; cadastro sem banner 16:6.
- [ ] **PASS/FAIL** — Provedores **com logo**.
- [ ] **PASS/FAIL** — Rodapé com jogo responsável + +18.
- [ ] **PASS/FAIL** — Seleção “borda comida” consistente em chips/tabs/cards/sidebar.
- [ ] **PASS/FAIL** — Não parece Betão green carpet.

#### 11.1.9 Mapa rápido GOSTA / DÓI `[AS-IS]`
**GOSTA:** dark + 1 acento (quando bem feito) · cards de jogo compactos · sidebar desktop **e** mobile coerente · auth overlays bem resolvidos · cadastro mobile “padrão celular” · maiores ganhos · jackpot mobile claro.

**DÓI:** hero quebrado · motion-overload · título de jogo fraco · CTA Entrar/Cadastrar desalinhado · overlay fade pobre · Google com tipografia inconsistente · chrome com borda errada · CTA mobile oversize · provedores sem logo · rodapé sem estrutura · fundo de marca full; light Stripe home; texto de hero ilegível com degradê.

#### 11.1.10 Lacunas do tipo (não inventar resposta)
1. URL explícita de anti-exemplo canônico além de B1/SAGA/Stripe home.
2. Áudios de review → regras finas de home bet / jogos / auth não transcritas.
3. Figma BetSpace com tokens nomeados (historicamente 403).
4. Medida pixel-perfect da “borda comida” (1 vs 2px, inset vs replace) — **INFERIDA** até validação com print anotado.
5. Primary hex oficial SpaceBET player em produção vs purple Figma vs gold hub — por white-label / tenant.
6. Aprovação para promover aesthetic-play-hub DS 0.1.0-draft.
7. Figma SpaceBatch faltante no inventário B1.
8. Depósito mobile sheet — validar em white-label SpaceBET real.
9. ~~BottomNav vs header Primary~~ — **RESOLVIDO 2026-09-21:** deslogado → Cadastro = Primary.
10. Monocromia dangpt/SHER — quando aplicar vs purple BetSpace em produtos irmãos.

### 11.2 Admin / B2B / dashboard `[AS-IS 2026-09-22]`

> Genérico (ex.: gateway admin, backoffice, fintech). Hex de marca = **produto**. Esta seção nomeia **forma**.  
> IDs `GP-…` / `AP-…` são gosto transversal; o DS do produto mapeia para `P-…`.  
> **Proibido** puxar energia de cassino / tiles 3:4 / linguagem de jackpot para admin.

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
| GP-GRAPH-OK | Chart com Primary + no máx. um acento de série (não no chrome) |

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

### 11.3 Novo tipo

Ao aparecer um tipo recorrente (ex.: e-commerce, comparador, SaaS de produtividade), criar `11.N` com: princípios do tipo, cor/tipografia se houver padrão da casa, ordem mental das telas, componentes do tipo, referências do segmento, checklist, lacunas. Até existir a seção, o tipo usa só a parte geral.

---

## 12. Anti-slop (AI tells) — Space-compatible

Adaptado de [Taste Skill](https://github.com/Leonxlnx/taste-skill) (método). **Não** importar bans Inter/Lucide/glass-as-upgrade.

| Tell (matar) | Preferir |
|--------------|----------|
| Gradient purple / mesh “AI default” | Neutros + 1 acento da **marca** |
| Multi-accent / carnaval | Color consistency lock — 1 Primary |
| Glow / neon / pulse / glass no chrome | Encaixe + border + delta de surface |
| 3 feature cards idênticos (marketing) | Ritmo assimétrico ou rows do produto |
| Cards dentro de cards / fill igual empilhado | surface-2 + border |
| Fake UI de divs como “screenshot” | Arte real ou omitir |
| Pill em CTA de form | Radius ~8 |
| Motion theater / scroll cue / hero ilegível | Hero estático, legível |
| Chip HTML sobre foto hero | Arte comunica |

**Output completo (edições):** proibido `// ...`, “resto igual”, skeleton no lugar de implementação — ver `design-system-apply/reference-anti-slop.md`.

---

## Apêndice — Frase de ordem para colar no construtor / canvas / Cursor

> Siga `docs/ui-gosto.md` (pack space-cursor-skills): parte geral + seção do tipo do produto (§11). Marca do produto manda no Primary e na fonte (**sem neon**). Superfície neutra; marca só em CTA/ativo. Wordmark sem segunda cor competindo. Radius ~8, sem pill/glow. Primary na ação real do estado. Checklist PASS/FAIL. Admin: §11.2. Cassino: §11.1.

---

## Versionamento

| Versão | Data | Notas |
|--------|------|-------|
| 2.0.0 | 2026-09-21 | Guia 33 canônico + decisões (marca>gosto, admin≠cassino, borda contextual, Cadastro deslogado=Primary) + AI tells Taste |
| 2.1.0 | 2026-09-22 | Admin GP/AP (tabela, badge, chrome waste, KPI void, QA 1300); anti-neon Primary; wordmark sem dual-brand |
| 2.1.1 | 2026-09-22 | Admin separado da prova social; mapa README |
| 2.2.0 | 2026-09-23 | Admin: GP-FORM-DENSE-ROW; AP-GRID-HOLE / AP-CTA-SPREAD / AP-META-BASELINE; caça **intra-card** + prints humanos |
| 3.0.0 | 2026-09-28 | **Generalizado:** parte geral (G1–G8, §3–§10, §12) vale para todo produto; regras de cassino → §11.1 (prova social = §11.1.5); admin/B2B → §11.2; §11.3 para novos tipos. Usado por **Forge** (confronto antes do STOP) e **Apply** (Fase A + Scan). |
