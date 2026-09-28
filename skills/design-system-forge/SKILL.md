---
name: design-system-forge
description: >-
  Cria a base visual de um produto: diagnostica o que existe (tem × falta), cria ou espelha
  o manual da marca, escreve DESIGN_SYSTEM.md + tokens DTCG + EXTRACTION_NOTES sob `.docs/`
  e constrói variáveis, prancha Fundamentos e componentes no canvas (Pencil por padrão).
  Dois modos: Extrair (projeto existente — site, código, construtor) e Criar (projeto novo —
  manual + protótipo). Entrega o nível ESSENCIAL e oferece evoluir para o nível OURO.
  Gates: fonte insuficiente = PARAR; Q abertas = NÃO gravar DS final; GATE ACCEPT (mínimo
  big-tech) = REPROVADO se foundations/componentes/estados/patterns incompletos ou
  auto-contradição; confronto com ui-gosto obrigatório antes do STOP. Em dúvida: investigar
  e perguntar. STOP = PASS | PASS COM RESSALVAS | REPROVADO. NÃO corrige telas do produto
  (use design-system-apply). Use com /design-system-forge, "forjar DS", "criar design system",
  "manual da marca", "componentes no canvas", "criar padrões P-".
disable-model-invocation: true
---

# Design System Forge

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/design-system-forge/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo). Sem Sync a copia nao atualiza.  
> Ver `00-COPIA-LEIA-ME.md`. Hub pack: **`/skill-update`**. Fluxo repo: **`AGENTS.md`**.

**Trigger:** `/design-system-forge`  
**Idioma:** português.  
**Par:** `design-system-apply` — pega o que o Forge criou e **aplica nas telas** (canvas, construtor ou código). Forge **cria a base**; Apply **corrige telas**.

## Conteúdo genérico

Serve **qualquer produto**. Sem ID/URL/default de cliente nas regras. Casos reais só em `exemplos/`. Hub: `/skill-update`.

## Onde gravar artefatos

**Toda documentação desta skill fica em `.docs/`** — sem exceção. Peças visuais ficam no **arquivo de canvas do produto** (path perguntado no diagnóstico).

| Situação | O que fazer |
|----------|-------------|
| Workspace **fora** de um git repo | Criar `.docs/` e gravar ali |
| Workspace **dentro** de um git repo | Idem **e** garantir **`.docs/`** no **`.gitignore`** — **adicionar se faltar** |

| Artefato | Path |
|----------|------|
| DS do produto | `.docs/DESIGN_SYSTEM.md` |
| Tokens | `.docs/tokens.dtcg.json` |
| Notes (diagnóstico, Q, Accept, confronto gosto, nível) | `.docs/design-system-forge/EXTRACTION_NOTES.md` |
| Manual da marca (PDF, nível ouro) | `.docs/brand/` |
| Pranchas e componentes | Arquivo de canvas do produto (ex.: `.pen`) |

Proibido: DS/notes na raiz, em `.task/` como verdade, ou fora de `.docs/`.

## Constituição (obrigatório)

1. Ler **[`../docs/README.md`](../docs/README.md)** — seção `design-system-forge`.  
2. Ler **[`../docs/design-system.md`](../docs/design-system.md)** **inteiro** como **método** (não copiar tokens do Space como se fossem do produto).  
3. Ler **[`../docs/ui-gosto.md`](../docs/ui-gosto.md)**: parte geral **inteira** + seção do tipo do produto em §11 (confronto antes do STOP).  
4. Laws of UX: https://lawsofux.com/llms.txt (abrir; não resumir de memória).

| Arquivo da skill | Quando |
|------------------|--------|
| [roteiro.md](roteiro.md) | **Passo a passo** — Partes A (marca), B (documento), C (canvas). Seguir na ordem |
| [catalogo-componentes.md](catalogo-componentes.md) | Montar a lista fechada de componentes por faixa (Parte B) |
| [nivel-ouro.md](nivel-ouro.md) | O que entra no essencial × ouro; checklist de cada nível |
| [canvas-ferramentas.md](canvas-ferramentas.md) | Conectar a ferramenta de canvas (Pencil padrão; outras opções) |
| [template-design-system.md](template-design-system.md) | Wireframe do `DESIGN_SYSTEM.md` — **todas** as seções |
| [reference-ux-psychology.md](reference-ux-psychology.md) | Mapear leis → decisões do DS |
| [exemplos/deck-referencia-estrutura.md](exemplos/deck-referencia-estrutura.md) | Deck de referência: ordem de capítulos + 13 grupos de componentes (só estrutura) |

**Não** resumir o Space DS neste `SKILL.md`. Specs concretas vivem **só** no `.docs/DESIGN_SYSTEM.md` do produto.

---

## Princípios

### #1 — Padrões

> **O que não tem padrão está errado *ou* o padrão ainda precisa ser definido.**  
> A fonte visual **não é constituição**. Inventariar mock/construtor como lei = DS fotografia do erro.

Forge = **interpretar intenção + questionar + definir o padrão pretendido**. Fora-do-padrão → Apêndice (rejeitado / dívida), **não** catálogo.

### #2 — Em dúvida: investigar + perguntar

1. Buscar evidência (manual, CSS, componentes, ≥3 repetições, Space DS método).  
2. Se ambíguo / conflito / 1× / escopo incerto → **perguntar ao humano** antes de gravar como lei.  
3. Hipótese só em `EXTRACTION_NOTES` até confirmação. Nome de peça/produto só depois de eco → confirma.

### #3 — Consistência interna (anti-auto-contradição)

> O DS **não pode** proibir X e ao mesmo tempo transformar X em lei. Documento e canvas dizem a mesma coisa.

| Contradição | Correção obrigatória |
|-------------|----------------------|
| Escala `4…64` + “off-scale proibido”, mas mapa usa **28 / 14 / 20 / 36**… | **Normalizar** ao degrau mais próximo **ou** tabela **Exceções nomeadas** (token + px + porquê + fonte). Nunca os dois mundos. |
| “1 Primary por chrome” + dois Primary sólidos medidos | **Perguntar.** Confirmado → **exceção nomeada = lei**. Não confirmado → um Primary + o outro outline/dívida. |
| Warning hex visualmente ≈ Primary (hue OKLCH ±25°) | Warning **distinto** **ou perguntar**; warning **nunca** é CTA |
| Tokens: shadow dentro de `motion` | `elevation` / `shadow` no topo; `motion` = duration/easing só |
| Lei no MD ≠ valor no `tokens.dtcg.json` ≠ variável do canvas | Alinhar os três |
| Margem/grade do documento ≠ margem medida no canvas | Fechar um valor e versionar |

**Auto-auditoria pré-STOP:** reler o `DESIGN_SYSTEM.md` e as pranchas procurando essas contradições. Achou → corrigir **antes** de dizer PASS.

### #4 — Documento vivo (“fechado até o momento”)

O gate do documento vale como lei **agora**, não é escrito em pedra. Canvas e telas reabrem com **nova versão** + motivo na tabela de versões. Nunca corrigir só no canvas.

### #5 — Nada é apagado

Opções não escolhidas, rodadas de logo, versões antigas → área **Rascunho** do canvas. Oficial não depende de Rascunho.

---

## Fluxo

```text
0. DIAGNÓSTICO (tem × falta) + tipo de produto + canvas conectado?
1. MODO: Extrair (existente) | Criar (novo) → GATE 0 do modo
2. PARTE A — Manual da marca (se falta: criar prancha; se existe: espelhar)   roteiro passos 1–7
3. PARTE B — Documento: fundamentos, domínio, lista por faixa, matriz de estados,
   padrões de tela → GATE Q → gate do documento “fechado até o momento”        roteiro passos 8–15
4. PARTE C — Canvas: variáveis → Fundamentos → Componentes (tema principal) →
   auditoria → domínio por variações → varredura das telas → leis → Oficial×Rascunho  roteiro passos 16–23
5. CONFRONTO COM UI-GOSTO (geral + tipo)
6. GATE ACCEPT + Princípio #3
7. STOP (veredito) + pergunta: “evoluir para o nível ouro?”
8. Se sim: itens do ouro (nivel-ouro.md) → novo STOP
9. Handoff → design-system-apply (telas)
```

---

## Etapa 0 — Diagnóstico (tem × falta)

Antes de qualquer decisão. Tabela no chat **e** no topo de `EXTRACTION_NOTES`:

| Item | Status (Tem / Parcial / Falta) | Evidência (path, prancha, versão) |
|------|-------------------------------|-----------------------------------|
| Manual da marca (PDF ou prancha) — oficial? | | |
| `.docs/DESIGN_SYSTEM.md` (versão, seções) | | |
| `.docs/tokens.dtcg.json` | | |
| Arquivo de canvas (path) + ferramenta conectada | | |
| Variáveis no canvas (dark e claro) | | |
| Prancha Fundamentos | | |
| Componentes por faixa (1, 2, 3, D) | | |
| Matriz de estados | | |
| Padrões de tela `P-…` | | |
| Segundo tema (Light / Dark) | | |
| Telas existentes (site, construtor, canvas) | | |

Perguntas do diagnóstico (se não estiver claro):

1. **Tipo de produto** (ui-gosto §11: cassino, admin/B2B, outro) — define quais regras do gosto valem.  
2. **Arquivo de canvas** e ferramenta — se não conectada, seguir [canvas-ferramentas.md](canvas-ferramentas.md). Sem canvas → Partes A/C ficam **bloqueadas** (entrega só Parte B, com aviso).  
3. **Superfícies** (site, app, extensão, painel) e pontos de quebra usados.

Resultado: lista do que o Forge vai **criar**, **completar** ou **só conferir**. Não refazer o que já está oficial e coerente.

---

## Etapa 1 — Modo de entrada e GATE 0

| Modo | Quando | Fonte principal |
|------|--------|-----------------|
| **Extrair** | Projeto existente (site, código, construtor, prints) | A fonte visual + marca |
| **Criar** | Projeto novo, sem tela pronta | Manual da marca (ou criação na Parte A) + protótipo / lista de telas + discovery |

### GATE 0 — modo Extrair (fonte suficiente)

| Nível | Critério | Pode gerar DS? |
|-------|----------|----------------|
| **F** | Só brief / 1 print / 1 tela sem código | **Não** — pedir mais fonte |
| **D** | URL/construtor sem mobile e sem tokens/código | Rascunho parcial **só** se o humano autorizar |
| **C** | Desktop + mobile **ou** desktop + CSS/tokens | Sim, com Q abertas fechadas depois |
| **B** | Desktop + mobile + código/tokens + ≥3 superfícies | Sim |
| **A** | B + manual da marca + brief de intenção | Sim (melhor caso) |

**Superfície distinta** = lista/home + 1 fluxo crítico + 1 overlay — ou equivalente no segmento.

### GATE 0 — modo Criar

| Nível | Critério | Pode gerar DS? |
|-------|----------|----------------|
| **Bloqueado** | Sem nome do produto confirmado **ou** sem superfícies conhecidas | **Não** |
| **Provisório** | Nome + superfícies + lista de telas, mas manual ainda não oficial | Sim — DS marcado **provisório** até o manual ser oficial |
| **Pronto** | Nome + superfícies + protótipo/lista de telas + manual oficial | Sim |

### PARAR e pedir (qualquer modo)

- Sem nenhuma fonte (URL, construtor, prints, código, manual, protótipo).  
- Sem cor/token mensurável **e** humano não define Primary/Surface.  
- Fonte errada para o job (ex.: só marketing estático para app/dashboard).  
- Bloqueio de acesso (auth, link morto, MCP desconectado) → reportar, não inventar.

Ao parar: (1) o que falta (2) o que já dá para ver (3) **não** entregar DS completo. Pode gravar só notes com `FONTE_INSUFICIENTE`.

---

## Parte A — Manual da marca

Roteiro: [roteiro.md](roteiro.md) passos 1–7.

| Situação | Ação |
|----------|------|
| Manual oficial existe (PDF/prancha) | Espelhar numa prancha “Manual da marca” no canvas (mesmo conteúdo, sem inventar) |
| Manual existe mas não é oficial | Espelhar + DS avança **provisório** |
| Não existe | **Perguntar** se cria. Sim → prancha com essência, cores, tipografia, regras de uso, versões do logo |
| Não existe e humano recusa | Parte B **bloqueada** (DS sem marca é chute) |

**Logo:** trabalho de designer ou ferramenta de desenho. A IA **não** desenha logo final com formas soltas. Sem logo → manual **provisório**, espaço reservado marcado, pendência listada.  
A prancha do manual é página de apresentação: **não** passa pelas regras de tela do DS.

---

## Parte B — Documento (`DESIGN_SYSTEM.md`)

Roteiro: [roteiro.md](roteiro.md) passos 8–15. Template: [template-design-system.md](template-design-system.md) **inteiro**.

### Wizard (contexto)

1. Fonte(s) e modo  
2. Path do Space DS / gosto (default constituição após sync)  
3. Contexto: B2B | B2C | híbrido — se **dúvida** se há admin/CRUD → **perguntar**  
4. Path de saída (default sob `.docs/`) e arquivo de canvas  
5. Incluir mobile? (se não → documentar risco)  
6. Rigor P2/P3 na dívida?

Primary/Surface → **GATE Q**, não opcional do wizard.

### Loop cognitivo

```text
1. Visualizar a fonte (desktop + mobile quando o gate exigir)
2. Repetição vs ruído / exceção / bug visual
3. Hipótese de padrão (Space DS + Laws = método, não cópia)
4. GATE Q — checklist; sem resposta = NÃO gravar DS final
5. Padrão pretendido → lei; fora → Apêndice rejeitado
6. Preencher template INTEIRO (sem colapsar §6–8)
7. Lista fechada por faixa + matriz de estados + padrões de tela
8. Gate do documento: “fechado até o momento”
```

### GATE Q — Perguntas obrigatórias

Cada item: **humano** **ou** **inferido** com evidência (token/código / repetição ≥3×) e confiança alta. Ambíguo → **investigar + perguntar**. Checklist incompleto → **proibido** `DESIGN_SYSTEM.md` / tokens “finais”.

| ID | Pergunta |
|----|----------|
| **Q1** | Primary único (hex/token)? Accent secundário ou ruído? |
| **Q2** | Surfaces (bg / card / surface-2…) com **hex cada** e regra de empilhar? |
| **Q3** | Tipografia: famílias + hierarquia com **size · weight · line-height** (computador e celular)? |
| **Q4** | Radius + espaçamento base + **pontos de quebra** (px + o que muda) + **margem lateral no computador e no celular**? |
| **Q5** | Chrome **mobile:** onde está o **único** Primary da ação principal? Header outline **e** FAB Primary no mesmo papel → **perguntar**. Se gosto/marca disser que a ação principal é Primary, outline nela = dívida até o humano confirmar. |
| **Q6** | Chrome **desktop:** o que muda vs mobile? |
| **Q7** | Feedback: **success · warning · destructive** (+ info/live se o produto tiver). Warning **obrigatório**. Hue ≈ Primary → **perguntar** ou afastar. Warning ≠ CTA. |
| **Q8** | O que na fonte é acidente / dívida vs lei? |
| **Q9** | Segmento/tom e **tipo de produto** (ui-gosto §11) — implicação no DS? |
| **Q10** | Escopo v1: o que entra vs fora? Inclui admin/CRUD? |
| **Q11** | Ícones: família · stroke · sizes · cor ativo/inativo? |
| **Q12** | Motion: durações + easing + reduced-motion? |
| **Q13** | Application patterns A–D/F: **sempre lei pretendida**; humano vetou algum ID? |
| **Q14** | Proporções de domínio (card do item principal, hero, auth split, grids)? |
| **Q15** | Valores medidos **fora** da escala de spacing/radius: normalizar **ou** exceção nomeada? (Princípio #3) |
| **Q16** | Peças que o **tipo de produto** regula no gosto (ui-gosto §11 do tipo — ex.: cassino = prova social global × contextual §11.1.5; admin = tabela/badge §11.2)? Tipo sem seção → N/A justificado |
| **Q17** | Overlays (auth, pagamento, confirmações, sheets): lei na tela principal/chrome ou só no modal? Ordem pretendida de entrega (modais → telas) se houver |
| **Q18** | **Lista fechada de componentes** por faixa ([catalogo-componentes.md](catalogo-componentes.md)): variações da Faixa 1; Faixa 2 sim/não/depois com tela; Faixa 3 só com tela; peças de domínio (Faixa D) com eco → confirma |
| **Q19** | **Contraste** conferido: 4,5:1 texto normal; 3:1 texto grande, bordas de campo, ícones de uso e foco — em cada tema com valores definidos? |

Se Q16/Q17 forem N/A, justificar em EXTRACTION_NOTES. Não inventar `P-…` de um tipo de produto em outro.

### Inferência

- Inferir só com token/código **ou** ≥3 repetições alinhadas ao gosto.  
- **Warning:** ausente → inferir hex + uso e marcar `inferido`. ∆hue &lt; ~25° do Primary com ambos saturados → afastar **ou perguntar**.  
- **Breakpoints:** 1º os do produto; senão Tailwind default com tabela do que muda.  
- **Spacing off-scale na fonte:** preferir **normalizar**; ritmo exige o valor → **Exceções nomeadas** + origem.  
- **Chrome dual (outline + FAB):** **perguntar** qual é o Primary canônico da ação principal.  
- Perguntar se 1×, conflito entre telas, Primary/CTA ambíguo, warning≈marca, ou escopo admin incerto.  
- Nunca inventar Primary/Surface se manual/código/humano já definiu.  
- **ABERTO** → não promover a lei (hipótese só no notes).

### Gate do documento

Checklist de aceite + anti-contradição → DS **fechado até o momento** (Princípio #4). Canvas e telas ainda vão corrigi-lo, sempre com versão.

---

## Parte C — Canvas

Roteiro: [roteiro.md](roteiro.md) passos 16–23. Ferramenta: [canvas-ferramentas.md](canvas-ferramentas.md) (Pencil padrão).

Leis (detalhe no roteiro):

1. **Variáveis antes de qualquer peça** — prefixo próprio, valor dark **e** claro. Nenhuma peça oficial com cor digitada.  
2. **Prancha Fundamentos** logo depois das variáveis — cores por papel, tipografia, espaçamento, medidas fixas, margem e grade **computador e celular**, pontos de quebra, cantos, bordas, sombras, ícones.  
3. **Componentes no tema principal** — só os da lista fechada (Q18), cada um com os estados da matriz; nomes com prefixo (ex.: `DS / Botão / Primário`).  
4. **Lei de prompt** — nunca pedir “corrigir”/“simplificar” à IA do canvas; dar lista fechada.  
5. **Auditoria visual peça por peça** — olhar, não contar.  
6. **Peça central do domínio por variações** lado a lado; cliente escolhe; opções vão para o Rascunho.  
7. **Varredura das telas** do protótipo → componentes faltantes listados **antes** de implementar.  
8. **Auditoria contra as leis** — só variáveis, 3 pesos, escala, cantos, contraste, um Primary por bloco, sem brilho.  
9. **Oficial × Rascunho** — topo só oficial; nada apagado.

Cada decisão do canvas entra no documento com nova versão.

---

## Etapa 5 — Confronto com o gosto (obrigatório antes do STOP)

1. Ler [`../docs/ui-gosto.md`](../docs/ui-gosto.md): parte geral + seção do tipo (Q9/Q16).  
2. Checklist §10 + checklist do tipo → **PASS/FAIL** por item, sobre **documento e canvas**.  
3. FAIL → corrigir no DS e no canvas **ou** registrar **exceção nomeada** com OK humano (marca > gosto: cor/fonte da marca nunca é FAIL de gosto).  
4. Seções de outros tipos → “não se aplica” com motivo.  
5. Resultado em `EXTRACTION_NOTES` (bloco “Confronto com o gosto”).

---

## GATE ACCEPT — Mínimo big-tech (bloqueante)

Barra: DS pelo qual um eng/designer **implementa sem adivinhar**. **Patterns bonitos + foundations pobres = REPROVADO.**

### Camada 0 — Artefato

- [ ] Template **todas** as seções presentes (vazio só com motivo — **proibido** colapsar §6–8 num bullet)  
- [ ] Cada regra: **Valor · Uso · Porquê · Fonte**  
- [ ] `tokens.dtcg.json` espelha foundations (cor, type, space, radius, breakpoint, icon, motion, **elevation/shadow**)  
- [ ] `EXTRACTION_NOTES` com diagnóstico + GATE 0 + Q + Accept + confronto gosto + rejeitado + nível entregue  

### Camada 1 — Foundations (F1–F8)

| ID | Obrigatório | Fail se |
|----|-------------|---------|
| **F1 Cor** | Marca + surfaces hex · texto · border · **success/warning/destructive** (+ info) · Do/Don’t · warning **≠** Primary · contraste 4,5:1 e 3:1 | Feedback sem hex; warning≈marca sem pergunta; contraste não medido |
| **F2 Tipo** | Família · papéis · size+weight+**line-height** (computador e celular) · pesos proibidos | Só size/weight |
| **F3 Space** | Escala primitiva + mapa semântico **só com valores da escala** (ou Exceções nomeadas) + medidas fixas | Off-scale virar lei **sem** exceção |
| **F4 Layout** | Pontos de quebra com px + o que muda · grade e margem **por ponto de quebra** · proporções | Breakpoint ausente; margem só do computador |
| **F5 Radius** | Tokens + mapping + proibições | — |
| **F6 Elevation** | Shadows em token **`elevation`/`shadow`** · glow proibido | Shadow só em motion; sem valor |
| **F7 Motion** | Durações + easing + reduced-motion | Só “Doherty” na tabela de leis |
| **F8 Ícones** | Família · stroke · sizes · cores de estado · touch ícone-only | Uma linha só |

### Camada 2 — Componentes (lista fechada + estados)

- [ ] Lista por faixa no DS (componente · faixa · variações · tela) + **proibidos por enquanto**  
- [ ] Faixa 1 completa (13 grupos do [catálogo](catalogo-componentes.md)) — variações confirmadas  
- [ ] Peças de domínio (Faixa D) com nome confirmado  
- [ ] **Matriz de estados**: cada componente × normal/hover/foco/pressionado/desabilitado/carregando/erro — nenhuma célula em branco (“não se aplica” vale)  
- [ ] Estados de tela: vazio, carregando (esqueleto), erro, falha parcial, sem permissão/saldo, sem resultado  

**Fail:** tabela de uma linha sem estados; componente no canvas fora da lista.

### Camada 3 — Application patterns (`P-…`) — obrigatória

Referência de mercado (método): Cloudscape resource views · Carbon create flows · Polaris index/details · Marigold table records.

**Seção sempre presente e preenchida como lei pretendida** — inclusive em produto B2C sem tela admin na fonte. Fonte = `pretendido (constituição)`; notes registram que a UI admin ainda não existe. `N/A` só se o humano **vetar** um ID.

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

Thresholds default (ajustar só com evidência ou OK humano): tabela se coleção tipicamente ≥9; cards se ≤5 com visual.

#### Catálogo mínimo de IDs

**A — Collection:** `P-COL-TABLE` · `P-COL-FILTER` · `P-COL-BULK` · `P-COL-EMPTY` · `P-COL-PAGINATION`  
**B — Object:** `P-OBJ-OPEN` · `P-OBJ-DETAIL` · `P-OBJ-SPLIT`  
**C — CRUD:** `P-CRUD-CREATE` · `P-CRUD-EDIT` · `P-CRUD-INLINE` · `P-CRUD-DELETE` · `P-CRUD-FEEDBACK`  
**D — Surface:** `P-SURF-PAGE` · `P-SURF-DRAWER` · `P-SURF-MODAL` · `P-SURF-SHEET` · `P-SURF-SPLIT`  
**E — Domínio** (conforme telas do produto e §11 do tipo no gosto): chrome, card do item principal, hero, auth, pagamento, peças próprias…  
**F — Operação:** `P-NAV-IA` · `P-FORM-LAYOUT` · `P-FORM-SAVE` · `P-STATUS-BADGE` · `P-PERMISSION` · `P-DANGER-ZONE` · `P-TOAST`

Cada `P-…`: **spec canônica · anti-padrão · fonte** (`extraído` | `inferido` | `pretendido (constituição)` | `humano`). Mock errado → Apêndice, não lei.

**Fail:** só patterns de domínio/marketing **sem** A–D/F preenchidos.

### Camada 4 — Operação

- [ ] Mobile (touch 44, sheet vs dialog)  
- [ ] Estados de tela  
- [ ] A11y (contraste 4,5/3, focus, labels, reduced-motion)  
- [ ] Anti-padrões IA (tabela)  
- [ ] Checklist de aceite espelhando as seções  
- [ ] Versionamento (inclui “fechado até o momento”)  

### Camada 5 — Canvas (nível essencial)

- [ ] Prancha “Manual da marca” (ou pendência explícita de logo)  
- [ ] Variáveis com valor dark e claro; nenhuma peça oficial com cor digitada  
- [ ] Prancha Fundamentos (tema principal) com margem e grade computador e celular  
- [ ] Prancha Componentes (tema principal) = lista fechada, com estados  
- [ ] Oficial × Rascunho separados; nada apagado  
- [ ] Documento ↔ canvas sem contradição (Princípio #3)  

### Regra de ouro

```text
DIAGNÓSTICO registrado
  + FOUNDATIONS F1–F8 OK (sem auto-contradição)
  + COMPONENTES lista fechada + MATRIZ DE ESTADOS OK
  + APPLICATION P-… A–D/F OK
  + tokens espelho OK (elevation ≠ motion)
  + CANVAS essencial OK
  + CONFRONTO COM O GOSTO registrado
→ pode STOP humano
Senão → REPROVADO (listar buracos; não vender como DS)
```

---

## STOP — vereditos (obrigatório no chat)

| Veredito | Quando | Como falar no chat |
|----------|--------|-------------------|
| **PASS** | GATE ACCEPT + Princípio #3 OK **e** Qs humanas fechadas. Exceção nomeada **já confirmada** = **lei**, não ressalva. | Pode haver bloco **Dívida Apply** (telas ≠ lei). Isso **não** impede PASS. |
| **PASS COM RESSALVAS** | Aceite estrutural OK, mas ainda há **decisão humana aberta**. | Listar **só** o que o humano ainda decide. **Proibido** chamar de ressalva: (a) exceção já confirmada; (b) telas ainda não aplicadas. |
| **REPROVADO** | Falta foundation/estados/P-…/canvas/confronto ou contradição não resolvida | Listar buracos; corrigir ou parar sem fingir completo |

**Separar sempre:**

| Bloco | É? | Exemplo |
|-------|-----|---------|
| **Ressalva** | Pergunta ainda aberta para o humano | “Header outline ou sólido?” |
| **Exceção nomeada (lei)** | Humano já confirmou; documentada no DS | Header + FAB ambos Primary |
| **Dívida Apply** | Lei pronta; telas atrasadas | Tela X ainda com cor solta; fonte da marca não carregada no código |

**Template mínimo do STOP no chat:**

```text
1. Paths dos artefatos (.docs/ + arquivo de canvas e pranchas)
2. Diagnóstico final (tem × falta) e modo (Extrair | Criar) + GATE 0
3. Confronto com o gosto: PASS/FAIL resumido (+ exceções nomeadas)
4. Veredito: PASS | PASS COM RESSALVAS | REPROVADO
5. Se PASS COM RESSALVAS: bullets do que o humano ainda decide
6. Se PASS: opcional “Dívida Apply” — não rebaixa o veredito
7. Pergunta: “Quer evoluir para o nível ouro?” (listar o que entra — nivel-ouro.md)
8. Próximo passo: design-system-apply nas telas (se o humano aprovar)
```

### Nível ouro (opcional)

Só depois do STOP do essencial e do **sim** do humano. Itens e critérios em [nivel-ouro.md](nivel-ouro.md). Ao terminar: novo confronto com o gosto sobre o que mudou + novo STOP com o mesmo template.

---

## EXTRACTION_NOTES — blocos obrigatórios

1. Diagnóstico (tem × falta) + modo + GATE 0 (nível)  
2. Tabela Q1–Q19  
3. GATE ACCEPT (pass/fail **por camada** + buracos + **auto-contradições encontradas**)  
4. Confronto com o gosto (geral + tipo; PASS/FAIL; exceções; “não se aplica” com motivo)  
5. Fonte vs decidido/questionado  
6. Rejeitado / dívida  
7. Perguntas feitas ao humano + respostas (se “nenhuma”, justificar por que Q5/Q7/Q15/Q16/Q17/Q18 não precisaram — senão **falha de processo**)  
8. Nível entregue (essencial | ouro) + versão do documento  

## Prioridade de verdade

1. Decisões humanas / escopo  
2. Marca do produto (manual)  
3. Código/tokens do produto  
4. Gosto (ui-gosto geral + tipo) + Space DS + Laws of UX (método)  
5. Fonte visual (hierarquia/campos — não neon/ruído como lei)

## O que NÃO fazer

- Pular o diagnóstico ou refazer o que já está oficial e coerente  
- Inventário do construtor/mock = DS final  
- DS “completo” com GATE 0 insuficiente, Q abertas ou **GATE ACCEPT fail**  
- Colapsar foundations (§6–8) em bullets  
- Declarar **PASS limpo** omitindo Qs humanas abertas  
- Manter **PASS COM RESSALVAS** depois que o humano fechou as Qs  
- Gravar off-scale como lei **e** “off-scale proibido” sem tabela de exceções  
- Aceitar warning ≈ Primary sem pergunta  
- Decidir sozinho chrome outline+FAB quando a ação principal é a mesma  
- Inventar lei ou nome sob dúvida (investigar + perguntar; eco → confirma)  
- A IA desenhar logo final  
- Desenhar componente fora da lista fechada; cor digitada em peça oficial  
- Apagar opção, rodada ou versão (vai para o Rascunho)  
- Corrigir só no canvas sem versionar o documento  
- Entregar sem confronto com o gosto; puxar regra de um tipo de produto para outro  
- Fazer o nível ouro sem o humano pedir  
- Corrigir telas do produto (isso é `design-system-apply`)  
- Hardcodar cliente na skill  
- Resumir Laws of UX de memória  
- Pular mobile sem documentar risco
