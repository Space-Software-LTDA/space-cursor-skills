---
name: design-system-forge
description: >-
  Compõe um Design System de produto a partir de fonte visual (URL, Lovable, prints,
  código, brief): observar, interpretar intenção, questionar o humano, definir padrões
  pretendidos (não inventariar o mock), normalizar com Space DS + Laws of UX, gerar
  DESIGN_SYSTEM.md + tokens DTCG + EXTRACTION_NOTES sob `.docs/`. Gates: fonte insuficiente
  = PARAR; Q abertas = NÃO gravar DS final; GATE ACCEPT (mínimo big-tech) = REPROVADO se
  foundations/components/application patterns incompletos ou auto-contradição (ex. off-scale).
  Em dúvida: investigar e perguntar ao humano. STOP no chat = PASS | PASS COM RESSALVAS |
  REPROVADO (proibido “passou” omitindo ressalvas). Para na aprovação humana. NÃO aplica
  no produto (use design-system-apply). Use com /design-system-forge, "forjar DS", "extrair
  design system", "criar padrões P-".
disable-model-invocation: true
---

# Design System Forge

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/design-system-forge/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo). Sem Sync a copia nao atualiza.  
> Ver `00-COPIA-LEIA-ME.md`. Hub pack: **`/skill-update`**. Fluxo repo: **`AGENTS.md`**.

**Trigger:** `/design-system-forge`  
**Idioma:** português.  
**Par:** Apply / IKEA = skill `design-system-apply` — **Fase A** limpa o DS vs [`../docs/ui-gosto.md`](../docs/ui-gosto.md); **Fase B** aplica no front. Forge **não** aplica gosto SpaceBET no lugar da marca.

## Conteúdo genérico

Serve **qualquer produto**. Sem ID/URL/default de cliente nas regras. Hub: `/skill-update`.

## Onde gravar artefatos (`.docs/`)

**Toda documentação desta skill fica em `.docs/`** — sem exceção.

| Situação | O que fazer |
|----------|-------------|
| Workspace **fora** de um git repo | Criar `.docs/` e gravar ali |
| Workspace **dentro** de um git repo | Idem **e** garantir **`.docs/`** no **`.gitignore`** — **adicionar se faltar** |

| Artefato | Path |
|----------|------|
| DS do produto | `.docs/DESIGN_SYSTEM.md` |
| Tokens | `.docs/tokens.dtcg.json` |
| Notes | `.docs/design-system-forge/EXTRACTION_NOTES.md` |

Proibido: DS/notes na raiz, em `.task/` como verdade, ou fora de `.docs/`.  
Screenshots auxiliares em `.task/` só se o humano pedir mídia — a verdade continua em `.docs/`.

## Constituição (obrigatório)

1. Ler **[`../docs/README.md`](../docs/README.md)** — seção `design-system-forge`.  
2. Ler **[`../docs/design-system.md`](../docs/design-system.md)** **inteiro** como **método/gosto** (não copiar tokens do Space como se fossem do produto).  
3. Laws of UX: https://lawsofux.com/llms.txt (abrir; não resumir de memória).

| Arquivo da skill | Quando |
|------------------|--------|
| [template-design-system.md](template-design-system.md) | Wireframe a copiar/preencher — **todas** as seções |
| [reference-ux-psychology.md](reference-ux-psychology.md) | Mapear leis → decisões do DS |

**Não** resumir o Space DS neste `SKILL.md`. Specs concretas vivem **só** no `.docs/DESIGN_SYSTEM.md` do produto.

## Princípio #1 — Padrões

> **O que não tem padrão está errado *ou* o padrão ainda precisa ser definido.**  
> A fonte visual **não é constituição**. Inventariar mock/Lovable como lei = DS fotografia do erro.

Forge = **interpretar intenção + questionar + definir o padrão pretendido**. Fora-do-padrão → Apêndice (rejeitado / dívida), **não** catálogo.

| Camada | Conteúdo |
|--------|----------|
| **Skill** (genérica) | Método + gates + Q + **GATE ACCEPT** → IDs `P-…` → DS em `.docs/` |
| **DESIGN_SYSTEM.md do produto** | Specs concretas — **não** hardcodar na skill |

## Princípio #2 — Em dúvida: investigar + perguntar

> **Caso dúvida, sempre investigar e perguntar para confirmar.**  
> Não inventar lei. Não “quase pronto”. Não colapsar seções para parecer completo.

1. Buscar evidência (CSS, componentes, ≥3 repetições, Space DS método).  
2. Se ainda ambíguo / conflito / 1× / escopo incerto → **perguntar ao humano** antes de gravar como lei.  
3. Hipótese só em `EXTRACTION_NOTES` até confirmação.

## Princípio #3 — Consistência interna (anti-auto-contradição)

> O DS **não pode** proibir X e ao mesmo tempo transformar X em lei.

Exemplos de **FAIL automático** (corrigir antes do STOP ou REPROVAR):

| Contradição | Correção obrigatória |
|-------------|----------------------|
| Escala `4…64` + “off-scale proibido”, mas mapa usa **28 / 14 / 20 / 36**… | **Normalizar** ao degrau mais próximo (24/32, 12/16…) **ou** tabela **Exceções nomeadas** (token + px + porquê + fonte). Nunca os dois mundos. |
| “1 Primary por chrome” + dois Primary sólidos medidos | **Perguntar.** Se humano confirmar ambos (ex. header + FAB = mesma ação, papéis distintos) → **exceção nomeada = lei**, não ressalva eterna. Se não confirmar → um Primary + o outro outline/dívida. |
| Warning hex visualmente ≈ Primary (mesmo ângulo OKLCH ±25°) | Escolher warning **distinto** (ex. âmbar mais vermelho/laranja) **ou perguntar**; warning **nunca** é CTA |
| Tokens: shadow dentro de `motion` | `elevation` / `shadow` no topo; `motion` = duration/easing só |
| Lei no MD ≠ valor no `tokens.dtcg.json` | Alinhar os dois |

**Auto-auditoria pré-STOP:** releia o próprio `DESIGN_SYSTEM.md` procurando essas contradições. Se achar → corrigir no draft **antes** de dizer PASS.

---

## Papel

1. `.docs/DESIGN_SYSTEM.md` (foundations + componentes com **states** + **application patterns**)  
2. `.docs/tokens.dtcg.json` (espelho F1–F8)  
3. `.docs/design-system-forge/EXTRACTION_NOTES.md` (GATE 0 + Q + GATE ACCEPT + fonte vs decidido)  
4. Apêndice: extraído → normalizado → rejeitado  

**Não faz:** corrigir produto / Lovable · QA de aceite · Apply · ClickUp · sync do pack.

## Fontes (multi)

URL publicada · Lovable · prints/Figma · código local · doc de gosto (Space DS) · brief.  
Segmento-agnóstico: B2B admin, B2C, marketing, híbrido.

---

## GATE 0 — Fonte suficiente (antes de interpretar)

Se falhar → **PARAR**. Não inventar DS “completo” com evidência fraca.

| Nível | Critério | Pode gerar DS? |
|-------|----------|----------------|
| **F** | Só brief / 1 print / 1 tela sem código | **Não** — pedir mais fonte |
| **D** | URL/Lovable sem mobile e sem tokens/código | Rascunho parcial **só** se o humano autorizar |
| **C** | Desktop + mobile **ou** desktop + CSS/tokens | Sim, com Q abertas fechadas depois |
| **B** | Desktop + mobile + código/tokens + ≥3 superfícies | Sim |
| **A** | B + Space DS + brief de intenção | Sim (melhor caso) |

**Superfície distinta** = lista/home + 1 fluxo crítico + 1 overlay — ou equivalente no segmento.

### PARAR e pedir

- Sem URL **e** sem Lovable **e** sem prints **e** sem path de código  
- Sem cor/token mensurável **e** humano não define Primary/Surface  
- Fonte errada para o job (ex.: só marketing estático para app/dashboard)  
- Bloqueio de acesso (auth, link morto, MCP) → reportar, não inventar  

Ao parar: (1) o que falta (2) o que já dá para ver (3) **não** entregar DS completo.  
Pode gravar só notes com `FONTE_INSUFICIENTE`.

---

## Wizard (contexto)

1. Fonte(s)  
2. Path do Space DS / gosto (default constituição após sync)  
3. Contexto: B2B | B2C | híbrido — se **dúvida** se há admin/CRUD → **perguntar**  
4. Path de saída (default sob `.docs/`)  
5. Incluir mobile? (se não → documentar risco)  
6. Rigor P2/P3 na dívida?

Primary/Surface → **GATE Q**, não opcional do wizard.

## Loop cognitivo

```text
0. GATE 0 — fonte suficiente? Senão PARAR
1. Visualizar (desktop + mobile quando o gate exigir)
2. Repetição vs ruído / exceção / bug visual
3. Hipótese de padrão (Space DS + Laws = método, não cópia)
4. GATE Q — checklist; sem resposta = NÃO gravar DS final
5. Padrão pretendido → lei; fora → Apêndice rejeitado
6. Preencher template INTEIRO (sem colapsar §6–8)
7. GATE ACCEPT + Princípio #3 (auto-contradição); falhou = REPROVADO
8. Gerar sob .docs/ + EXTRACTION_NOTES com Q1–Q17 + Accept
9. STOP no chat com veredito PASS | PASS COM RESSALVAS | REPROVADO (+ bullets)
10. Só então: `design-system-apply` / knowledge / etc.
```

---

## GATE Q — Perguntas obrigatórias

Cada item: **humano** **ou** **inferido** com evidência (token/código / repetição ≥3×) e confiança alta.  
Ambíguo → **investigar + perguntar**. Checklist incompleto → **proibido** `DESIGN_SYSTEM.md` / tokens “finais”.

| ID | Pergunta |
|----|----------|
| **Q1** | Primary único (hex/token)? Accent secundário ou ruído? |
| **Q2** | Surfaces (bg / card / surface-2…) com **hex cada** e regra de empilhar? |
| **Q3** | Tipografia: famílias + hierarquia com **size · weight · line-height**? |
| **Q4** | Radius + espaçamento base + **breakpoints** (produto usa; senão Tailwind default)? |
| **Q5** | Chrome **mobile:** onde está o **único** Primary da ação principal? Se header outline **e** FAB Primary coexistirem → **perguntar** (não decidir sozinho). Se gosto/marca disser “Cadastro = Primary”, outline no Cadastro = dívida até humano confirmar. |
| **Q6** | Chrome **desktop:** o que muda vs mobile? |
| **Q7** | Feedback: **success · warning · destructive** (+ live se produto). Warning **obrigatório**. Se ausente no CSS → inferir; se hue ≈ Primary → **perguntar** ou afastar o hue. Warning ≠ CTA. |
| **Q8** | O que na fonte é acidente / dívida vs lei? |
| **Q9** | Segmento/tom e implicação no DS? |
| **Q10** | Escopo v1: o que entra vs fora? Inclui admin/CRUD? |
| **Q11** | Ícones: família · stroke · sizes · cor ativo/inativo? |
| **Q12** | Motion: durações + easing + reduced-motion? |
| **Q13** | Application patterns A–D/F: **sempre lei pretendida** (mesmo sem admin na fonte); humano vetou algum ID? |
| **Q14** | Proporções de domínio (tile, hero, auth split, grids)? |
| **Q15** | Valores medidos **fora** da escala de spacing/radius: normalizar **ou** exceção nomeada? (ver Princípio #3) |
| **Q16** | Prova social (se o domínio tiver): **global** (ticker **ou** painel) vs **contextual** (lista nested em card)? IDs sugeridos `P-WINS` / `P-TICKER` / `P-JACKPOT-WINNERS` — [ui-gosto.md](../docs/ui-gosto.md) §5.5. Se **não** houver prova social no produto → N/A justificado |
| **Q17** | Overlays (auth, depósito, sheets): lei na **Home/chrome** ou só modal? Ordem pretendida de entrega (modais → Home) se for player |

Se Q16/Q17 forem N/A, justificar em EXTRACTION_NOTES (domínio sem jackpot/overlays). Não inventar `P-WINS` em produto sem prova social.

### Inferência

- Inferir só com token/código **ou** ≥3 repetições alinhadas ao gosto.  
- **Warning:** se ausente → inferir hex + uso e marcar `inferido`. Checar distância perceptual do Primary (hue OKLCH): se ∆hue &lt; ~25° e ambos saturados → **não** aceitar cego — afastar (âmbar/alerta mais quente ou menos “gold”) **ou perguntar**.  
- **Breakpoints:** 1º os do produto; senão Tailwind default com tabela do que muda.  
- **Spacing off-scale na fonte:** preferir **normalizar** ao degrau da escala na lei; se o ritmo visual exigir o valor exato → **Exceções nomeadas** + origem (ex. `space-y-7` → documentar `section.exception` ou mudar lei para 24/32).  
- **Chrome dual (outline + FAB):** **perguntar** qual é o Primary canônico da ação principal. Não gravar outline como lei definitiva sem OK humano se a ação principal for a mesma (ex. Cadastro).  
- Perguntar se 1×, conflito entre telas, Primary/CTA ambíguo, warning≈brand, ou escopo admin incerto.  
- Nunca inventar Primary/Surface se código/humano já definiu.  
- **ABERTO** → não promover a lei (hipótese só no notes).

---

## GATE ACCEPT — Mínimo big-tech (bloqueante)

Barra: DS pelo qual um eng/desig **implementa sem adivinhar** no CSS.  
**Patterns bonitos + foundations pobres = REPROVADO.**

Antes do STOP humano, auditar. Qualquer fail → **não** apresentar como draft aprovável; corrigir ou marcar `REPROVADO` + lista de buracos no notes.

### Camada 0 — Artefato

- [ ] Template **todas** as seções presentes (vazio só `TBD` + motivo — **proibido** colapsar §6–8 num bullet)  
- [ ] Cada regra: **Valor · Uso · Porquê · Fonte**  
- [ ] `tokens.dtcg.json` espelha foundations (cor, type, space, radius, breakpoint, icon, motion, **elevation/shadow**)  
- [ ] `EXTRACTION_NOTES` com GATE 0 + Q + Accept + rejeitado  

### Camada 1 — Foundations (F1–F8)

| ID | Obrigatório | Fail se |
|----|-------------|---------|
| **F1 Cor** | Brand + surfaces hex · texto · border · **success/warning/destructive** (+ live) · Do/Don’t · warning **≠** Primary (hue distinto) | Feedback sem hex; warning≈gold de marca sem pergunta |
| **F2 Tipo** | Família · papéis · size+weight+**line-height** · pesos proibidos | Só size/weight |
| **F3 Space** | Escala primitiva + mapa semântico **só com valores da escala** (ou tabela Exceções nomeadas) | Off-scale virar lei **sem** exceção; “proibido” + 28/14 na mesma página |
| **F4 Layout** | Breakpoints com px + o que muda · proporções | Breakpoint ausente |
| **F5 Radius** | Tokens + mapping + proibições | — |
| **F6 Elevation** | Shadows em token **`elevation`/`shadow`** (não dentro de motion) · glow proibido | Shadow só em motion; sem valor |
| **F7 Motion** | Durações + easing + reduced-motion | Só “Doherty” na tabela de leis |
| **F8 Ícones** | Família · stroke · sizes · cores estado · touch ícone-only | “Lucide” numa linha |

### Camada 2 — Componentes (com states)

Mínimo do inventário do produto; cada um: anatomia · variants · **states** (default/hover/focus/active/disabled/loading) · specs · a11y · do/don’t.

Checklist base (marcar N/A só com motivo):

- [ ] Button (primary / outline / ghost se existir)  
- [ ] Input / Select  
- [ ] Badge / Ribbon  
- [ ] Card / Tile de domínio  
- [ ] Dialog / Sheet / Drawer  
- [ ] Header / Nav / Sidebar / BottomNav / Footer (os que existirem)  

**Fail:** tabela de uma linha sem states.

### Camada 3 — Application patterns (`P-…`) — obrigatória

Referência de mercado (método): Cloudscape resource views · Carbon create flows · Polaris index/details · Marigold table records.

**Seção sempre presente e preenchida como lei pretendida** — inclusive em produto **só B2C player** sem tela admin na fonte.  
Não usar `N/A escopo` para A–D/F: definir o padrão admin/CRUD com a decision tree + defaults de mercado (Cloudscape / Carbon / Polaris / Marigold), marcar fonte = `pretendido (constituição)` e registrar nas notes que a UI admin ainda não existe na fonte.  
`N/A` só para um ID pontual se o humano **explicitamente** vetar aquele padrão. Dúvida de regra → investigar + perguntar.

#### Decision tree (lei — imprimir no DS)

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

Thresholds default (Cloudscape-inspired; ajustar só com evidência ou OK humano): tabela se coleção tipicamente ≥9; cards se ≤5 com visual.

#### Catálogo mínimo de IDs (preencher como lei — B2C sem admin na fonte **não** isenta)

**A — Collection:** `P-COL-TABLE` · `P-COL-FILTER` · `P-COL-BULK` · `P-COL-EMPTY` · `P-COL-PAGINATION`  
**B — Object:** `P-OBJ-OPEN` · `P-OBJ-DETAIL` · `P-OBJ-SPLIT`  
**C — CRUD:** `P-CRUD-CREATE` · `P-CRUD-EDIT` · `P-CRUD-INLINE` · `P-CRUD-DELETE` · `P-CRUD-FEEDBACK`  
**D — Surface:** `P-SURF-PAGE` · `P-SURF-DRAWER` · `P-SURF-MODAL` · `P-SURF-SHEET` · `P-SURF-SPLIT`  
**E — Player/domínio** (se B2C): chrome, nest, ticker, hero, gamecard, auth, deposit… conforme inventário  
**F — Operação:** `P-NAV-IA` · `P-FORM-LAYOUT` · `P-FORM-SAVE` · `P-STATUS-BADGE` · `P-PERMISSION` · `P-DANGER-ZONE` · `P-TOAST`

Cada `P-…`: **spec canônica · anti-padrão · fonte** (`extraído` | `inferido` | `pretendido (constituição)` | `humano`). Mock errado → Apêndice, não lei.

**Fail:** só patterns de player/marketing **sem** A–D/F preenchidos como lei pretendida.

### Camada 4 — Operação

- [ ] Mobile (touch 44, sheet vs dialog)  
- [ ] Estados de tela (loading/empty/error/disabled)  
- [ ] A11y (contraste, focus, labels, reduced-motion)  
- [ ] Anti-padrões IA (tabela)  
- [ ] Checklist de aceite espelhando as seções  
- [ ] Versionamento  

### Regra de ouro

```text
FOUNDATIONS F1–F8 OK (sem auto-contradição)
  + COMPONENTES com states OK
  + APPLICATION P-… A–D/F como lei pretendida OK
  + tokens espelho OK (elevation ≠ motion)
  + Princípio #3 limpo
→ pode STOP humano
Senão → REPROVADO (listar buracos; não vender como DS)
```

### Vereditos de STOP (obrigatório no chat)

| Veredito | Quando | Como falar no chat |
|----------|--------|-------------------|
| **PASS** | GATE ACCEPT + Princípio #3 OK **e** Qs humanas fechadas (ou justificadas). Exceção nomeada **já confirmada** pelo humano conta como **lei**, não como ressalva. | Pode haver bloco **Dívida Apply** (código/preview ≠ lei). Isso **não** impede PASS. |
| **PASS COM RESSALVAS** | Aceite estrutural OK, mas ainda há **decisão humana aberta** (chrome dual sem OK, warning hex sem OK, exceção de spacing sem escolher normalizar vs nomear). | Listar **só** o que o humano ainda precisa decidir. **Proibido** chamar de ressalva: (a) exceção já confirmada; (b) front ainda não aplicado. |
| **REPROVADO** | Falta foundation/states/P-…/contradição interna não resolvida | Listar buracos; corrigir no draft ou parar sem fingir completo |

**Separar sempre (não misturar no veredito):**

| Bloco | É? | Exemplo |
|-------|-----|---------|
| **Ressalva** | Pergunta ainda aberta para o humano | “Header outline ou sólido?” |
| **Exceção nomeada (lei)** | Humano já confirmou; documentada no DS | Header Cadastrar + FAB ambos Primary |
| **Dívida Apply** | Lei pronta; código/preview atrasado | Cadastrar ainda outline no build; Inter não carregada; `--warning` ausente no CSS |

> Depois que o humano fecha as Qs → STOP = **PASS** (+ Dívida Apply se houver).  
> **Proibido** manter **PASS COM RESSALVAS** só porque o front não foi aplicado ou porque existe exceção nomeada já aprovada.

**Template mínimo do STOP no chat:**

```text
1. Paths dos 3 artefatos
2. GATE 0 nível
3. Veredito: PASS | PASS COM RESSALVAS | REPROVADO
4. Se PASS COM RESSALVAS: bullets do que o humano ainda decide
5. Se PASS: opcional “Dívida Apply” (bullets) — não rebaixa o veredito
6. Lembrete: não é Apply (próximo = design-system-apply se humano aprovar o DS)
```

---

## EXTRACTION_NOTES — blocos obrigatórios

1. Fonte + nível GATE 0 (F–A)  
2. Tabela Q1–Q17  
3. GATE ACCEPT (pass/fail **por camada** + buracos + **auto-contradições encontradas**)  
4. Fonte vs decidido/questionado  
5. Rejeitado / dívida  
6. Perguntas feitas ao humano + respostas (se “nenhuma”, justificar por que Q5/Q7/Q15/Q16/Q17 não precisaram — senão **falha de processo**)  

## Prioridade de verdade

1. Decisões humanas / escopo  
2. Código/tokens do produto  
3. Space DS + Laws of UX (método)  
4. Mock/fonte visual (hierarquia/campos — não neon/ruído como lei)

## O que NÃO fazer

- Inventário Lovable = DS final  
- DS “completo” com GATE 0 insuficiente, Q abertas ou **GATE ACCEPT fail**  
- Colapsar foundations (§6–8) em bullets  
- Declarar **PASS limpo** omitindo Qs humanas ainda abertas  
- Manter **PASS COM RESSALVAS** depois que o humano já fechou as Qs (por “exceção nomeada” ou “front não aplicado”)  
- Gravar off-scale como lei **e** “off-scale proibido” sem tabela de exceções  
- Aceitar warning ≈ Primary sem pergunta  
- Decidir sozinho chrome outline+FAB quando a ação principal é a mesma (perguntar; se humano pedir ambos Primary → exceção nomeada)  
- “Tudo que vi” sem hipótese + pergunta quando ambíguo  
- Inventar lei sob dúvida (investigar + perguntar)  
- Corrigir o produto (isso é `design-system-apply`)  
- Hardcodar cliente na skill  
- Resumir Laws of UX de memória  
- Pular mobile sem documentar risco  
