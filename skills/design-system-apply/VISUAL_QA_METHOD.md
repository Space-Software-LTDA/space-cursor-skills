# Método de QA visual — Apply (pós–Forge + gosto)

> Usado por `design-system-apply`.  
> Gosto: `../docs/ui-gosto.md` (parte geral + seção do tipo em §11). Anti-slop: [reference-anti-slop.md](reference-anti-slop.md).  
> Relatório: [report-template.md](report-template.md). Canvas: `../design-system-forge/canvas-ferramentas.md`.

---

## 0. Três fases (com OK humano)

| Fase | O quê | Output | Para? |
|------|--------|--------|-------|
| **A** | DS × ui-gosto (documento) | `.docs/DESIGN_SYSTEM.md` + EXTRACTION_NOTES | **Sim — OK A** |
| **B** | Scan cabo a rabo (site/construtor no browser + canvas por print) + espelho no canvas + gaps | `QA_REPORTS/…[-rN].md` completo | **Sim — OK B** (libera Fix) |
| **C** | Fix no canvas (padrão) + re-Scan até ALIGNED | telas corrigidas + `…-rN.md` + `DIFERENCAS_PARA_DEVS.md` | Loop; mini-A se DS mudar |

**Proibido:** A → C sem B e sem OKs.  
**Proibido:** Fix sem OK B.

---

## 1. Princípio — Scan ≠ ler o DS

| Fonte | Serve para |
|-------|------------|
| `.docs/DESIGN_SYSTEM.md` | **Régua** (tokens / `P-…`) |
| Review humano no workspace (ex. `observacoes.md`, prints, clip, notas do chat) | **Checklist obrigatória** se existir — cada bullet PASS/FAIL com evidência |
| Tela no browser (site / preview do construtor) ou print do canvas desta sessão | **Crime** |

DS sozinho **não** detecta: espaço vazio, poço, overflow, CTA morto, layout quebrado, faixa sumida, sheet bugado.

### 1.1 Review humano vs DS (obrigatório)

Se existir review humano recente no workspace **ou** o humano apontar reclamações no chat:

1. Ler o review **inteiro** antes do Scan / re-Scan.  
2. No relatório: tabela **“Review humano × tela”** — uma linha por bullet (rota ou tela do canvas, sintoma, PASS/FAIL/mitigado, evidência browser ou print).  
3. **Conflito DS × humano** (ex. default de paginação): **não** dar PASS só porque o DS diz X. Registrar FAIL gosto/humano + abrir **mini-A** para reconciliar a lei. Até reconciliar, ALIGNED **proibido**.  
4. **Proibido** ALIGNED se qualquer item de prioridade ALTA do review humano estiver FAIL ou “Não coberto” sem risco baixo explícito aceito pelo humano.  
5. Inventário AP/GP / tokens **não substitui** o review humano — complementa.

---

## 2. Três cestas (Fase B / re-Scan)

**P0 Bugs** — impede ação / render.  
**P1 Lacunas** — viola `P-…` / gosto / AI tell.  
**P2 Agonias** — polish.  
**Fora de escopo:** watermark do host (anotar).

---

## 3. GATE SCAN — completo ou inválido

### 3.0 Inventário de alvos (obrigatório — antes do passeio)

Não assumir “a URL do chat”. **Descobrir e listar** o que o produto expõe:

| Tipo | Como descobrir (genérico) | Exemplo de papel |
|------|---------------------------|------------------|
| Base publicada | Deploy que o humano ou o MCP do construtor apontar | Produção / share |
| Base preview | MCP do construtor, notes do Forge, URL de preview se existir | Build de sandbox |
| Deep links / rotas | Router do código, links do nav/footer, DS § rotas v1 | auth page, settings, checkout… |
| **Telas do canvas** | Pranchas “Telas” oficiais + “Rascunho · espelho …” via MCP da ferramenta | Tela oficial / espelho / estado |
| **Popups / overlays** | Ver §3.0b — **obrigatório**; não só os óbvios | modal, sheet, drawer, dialog, welcome… |
| Estados de sessão | Deslogado **e**, se houver demo/login, **logado** | chrome/FAB diferentes |

**No relatório:**  
1. tabela **Inventário de URLs / alvos** (inclui telas do canvas)  
2. tabela **Inventário de popups / overlays** (§3.0b)  
3. tabela **Telas espelhadas no canvas** (§3.4) — projeto de código/construtor

- Se houver **duas bases** (publicado + preview): scaneia **ambas** **ou** uma + Não coberto com risco.  
- Rota no nav/código não aberta → Não coberto.  
- Overlay descoberto no código **não** aberto → Não coberto (não fingir que “não existe”).  
- Estado **logado** não exercitado → Não coberto com risco.  
- Dúvida de URL/overlay → **perguntar** ao humano.

### 3.0b Inventário de popups / overlays (obrigatório)

> Nem todo popup é óbvio na dobra. **Proibido** limitar-se a “login e checkout”.

**Descobrir por:**

| Fonte | O que procurar |
|-------|----------------|
| Código (repo local ou arquivos do construtor via MCP) | Componentes `*Modal*`, `*Dialog*`, `*Sheet*`, `*Drawer*`, `*Popover*` de fluxo, `*Welcome*`, `*Confirm*`, `AlertDialog`, toasts bloqueantes, banners dismissíveis que cobrem chrome |
| Estado / store | flags `open*`, `isOpen`, `showModal`, providers de auth/pagamento/menu |
| Gatilhos de UI | botões que não navegam (Buscar, Sino, ⋯, ação do card, Conta, X de faixa) |
| Canvas | Pranchas de overlay/estado desenhadas; componentes Modal/Sheet/Toast usados nas telas |
| DS / mem | overlays citados em `P-SURF-*` / rotas v1 / dívidas (“Welcome desligado”, “StickyCTA órfão”) |

**No relatório — uma linha por overlay:**

| Overlay (nome no código ou UI) | Tipo (modal/sheet/drawer/…) | Como abrir (gatilho) | Scaneado? | Se não: motivo + risco |

**Regras:**

- Overlay **órfão** (arquivo existe, não montado) → linha no inventário: scaneado=não, motivo “não montado / dívida”, risco documentado.  
- Overlay **desligado de propósito** (ex. auto-open off) → inventariar; tentar abrir por gatilho alternativo ou Não coberto justificado.  
- Abrir **e fechar** cada um marcado scaneado (Escape/X/drag).  
- Desktop **e** mobile quando o tipo mudar (dialog ↔ sheet).
- **Rota aberta direto ≠ overlay aberto pela tela.** A mesma URL (ex.: `/login`) pode virar página cheia quando aberta direto e modal/gaveta quando aberta a partir da Home. Inventariar os dois; o espelho e a tela oficial copiam **o que o usuário vê** (normalmente o overlay sobre a tela).
- **Medidas do overlay saem do código**, não do print: largura, divisão de colunas, altura máxima, canto, véu e desfoque (ex.: classes utilitárias no bundle JS/CSS). O print só confirma.

### 3.1 Checklist do passeio

- [ ] Inventário de URLs/alvos preenchido (§3.0)  
- [ ] Inventário de **popups/overlays** preenchido (§3.0b) — não só os óbvios  
- [ ] Cada URL, tela do canvas e overlay: scaneado ou Não coberto  
- [ ] URL(s) abertas **nesta** sessão; telas do canvas com print **desta** sessão  
- [ ] Telas do inventário ausentes no canvas: espelhadas (§3.4) ou motivo  
- [ ] Desktop + mobile no(s) alvo(s) principal(is)  
- [ ] Home: dobra + scroll até footer  
- [ ] Chrome completo (deslogado; logado se scaneado)  
- [ ] **Todos** os overlays marcados scaneados: abertos e fechados agora  
- [ ] Deep links visitados ou Não coberto  
- [ ] Urgência dismissível revalidada ou Não coberto  
- [ ] Caça: vazio / poço / corte / hit morto / quebrado  
- [ ] **Caça intra-card** (§3.3): grid-hole · CTA-spread · meta-baseline  
- [ ] Prints/círculos humanos no chat: cada um PASS/FAIL  
- [ ] Template **inteiro** + evidências  

**Inválido:** só código; só dobra; só login+checkout quando o inventário listava outros popups; relatório com `…`; URL única sem inventário; overlays órfãos omitidos da tabela; Scan **sem** abrir URL no browser nesta sessão; relatório que marca PASS em affordance **sem** clicar/abrir; ALIGNED com review humano ALTA ainda FAIL; ALIGNED com rotas do review humano em “Não coberto”; **PASS em “espaços vazios” só com gap entre seções** (sem §3.3); **ignorar print/círculo do humano** no chat.

### 3.2 Affordance morta = FAIL (não PASS)

| Sintoma | Classificação |
|---------|----------------|
| Ícone/botão `⋯` / “Colunas” / menu presente **sem** abrir menu/ações ao clicar | **P0/P1** hit morto — remover **ou** implementar; **nunca** PASS por “estar no DOM” |
| Paginação / default / filtro que o review humano pediu e o preview contradiz | FAIL até corrigir **ou** mini-A + OK humano |
| Heurística CDP (`chromeWaste=[]`, etc.) **sem** screenshot/snapshot da rota | insuficiente sozinha — confrontar olho + review |

### 3.3 Caça poço **intra-card** (obrigatório — admin/forms)

> Bug histórico: Apply media só **vão entre seções** (alert→histórico) e marcava “espaços vazios” PASS.  
> Crimes reais do review humano costumam ser **dentro** do card: célula de grid vazia, CTAs nas bordas, meta colada embaixo.

**Régua:** ui-gosto §11.2 `GP-FORM-DENSE-ROW` + `AP-GRID-HOLE` / `AP-CTA-SPREAD` / `AP-META-BASELINE` / `AP-FORM-VOID`.

Para **cada** card de form / side panel scaneado:

| Check | Como provar | FAIL se |
|-------|-------------|---------|
| Grid completo | Contar campos por row visual (2-col) | Última row com 1 campo e buraco ao lado → **AP-GRID-HOLE** |
| CTAs agrupados | Medir gap horizontal entre Primary e outline (site: CDP `getBoundingClientRect`; canvas: bounds dos nós) | Gap &gt; ~64px com só 2 botões **ou** `justify-between` nas bordas → **AP-CTA-SPREAD** |
| Meta vs valor | Bloco “valor + ID/badge” | Meta com poço **acima** (irmão alto + `items-end`) → **AP-META-BASELINE** |
| Prints do humano | Círculo/seta no chat ou anexo | Cada círculo = linha PASS/FAIL; **proibido** “mitigado” sem reabrir a rota **nesta** sessão |

**CDP mínimo sugerido (forms):**

```js
// gap entre 1º e 2º botão da row de ações
// área vazia à direita de input sozinho em grid 2-col
// top do bloco ID vs top do bloco valor (delta > 8px com items-end → suspeito)
```

**Proibido** marcar item ALTA “eliminar espaços vazios” como PASS só porque `gapAlertHist` entre seções melhorou.

### 3.4 Espelho no canvas (projeto de código ou construtor — Fase B)

> Objetivo: ter no canvas o “antes” de **toda** tela do inventário, para corrigir/redesenhar na Fase C sem editar código.

| Regra | Detalhe |
|-------|---------|
| Onde | Área **“Rascunho · espelho do site”** (ou “… do construtor”) — nunca na área oficial |
| O quê | Estrutura, conteúdo, ordem dos blocos e medidas **como estão** na tela real (computador e celular) |
| Peças | Usar instância oficial quando houver equivalente; sem equivalente → marcar “sem peça oficial” (vira achado) |
| Evidência | Print da tela real + print do espelho lado a lado no relatório |
| Depois | Espelho **não** é apagado; a tela oficial alinhada nasce na Fase C |
| Não coberto | Tela do inventário sem espelho → motivo + risco |

### 3.5 Scan no canvas

| Check | Como provar |
|-------|-------------|
| Tamanho real | Frame no tamanho da superfície (ex.: 1440, 375, popup com largura fixa e altura máxima) |
| Só oficial | Nós da tela são instâncias de componentes oficiais; cores por variável (sem hex digitado) |
| Corte / sobra | Problemas de layout reportados pela ferramenta (ex.: “clipped”) + print |
| Contraste | 4,5:1 texto normal; 3:1 texto grande, bordas de campo, ícones de uso, foco |
| Conferência cruzada | Mesma medida para a mesma coisa entre telas do mesmo tipo |
| Lado a lado com a fonte | Cada tela do canvas comparada com a captura da tela real no mesmo tamanho (uma imagem combinada: real × canvas), nesta sessão |
| Telas irmãs | Overlays irmãos (ex.: abas Entrar / Cadastrar do mesmo modal) com a **mesma altura** e a mesma proporção de mídia — o botão principal não pula ao trocar de aba |
| Mídia como amostra | Toda posição de banner/capa/arte nas telas do canvas é instância da amostra de proporção com a medida do lugar |
| Mídia sem recorte duplo | Instância da mídia no tamanho exato da coluna; arquivo fora da proporção do DS → achado com tamanho de reexportação |
| Sem duplicata | Zero componente com nome repetido e zero instância quebrada depois de cada rodada de Fix |

---

## 4. Roteiro Scan (Fase B e todo re-Scan em C)

```text
0. INVENTÁRIO URLs/rotas/sessão + telas do canvas (§3.0) + INVENTÁRIO popups/overlays (§3.0b)
1. Para cada alvo “scaneado”:
   A. Dobra desktop (**admin/B2B: preferir ~1300×800 notebook**, não só 1440) + mobile
   B. Scroll completo → footer
   C. Cada overlay scaneado: abrir + fechar (desktop e mobile se mudar tipo)
   D. Mobile shell
   E. Estados (loading/empty/error; logado se inventariado)
   F. CDP (site) / bounds e problemas de layout (canvas) se preciso
   G. Checklist do tipo em ui-gosto §11 (admin §11.2: KPI crush, chrome waste, tabela, badge drift, **§3.3 intra-card**; cassino §11.1)
   H. Canvas: §3.5
2. Espelho no canvas das telas ausentes (§3.4) — Fase B
3. Classificar P0/P1/P2 + gosto + Não coberto (URLs, telas e popups não abertos)
```

### Prioridade de Fix (Fase C)

1. Cor / Primary na ação real  
2. Hover/focus / par CTA  
3. Layout / nested / spacing / vazio (**intra-card primeiro** — grid-hole, CTA-spread, meta-baseline)  
4. Cara de IA  
5. Estados  

### Imparcialidade (re-Scan em C) — **cego primeiro, cruzar depois**

> Re-Scan **manipulado** = olhar o preview já sabendo “corrigimos X” e confirmar o fix.  
> Re-Scan **válido** = caçar como se **todo** ponto negativo ainda existisse; só **depois** cruzar com o relatório anterior / lista de fixes.

#### O que o avaliador **NÃO** abre durante a caça (fase cega)

| Proibido na fase cega | Por quê |
|----------------------|---------|
| Relatório pai / `…-rN` anterior (seção “o que foi corrigido”, P0 sanados, “PASS mitigado”) | Ancora expectativa |
| `EXTRACTION_NOTES` bloco “Fix / patch / C1” | Lista de fixes |
| Diff git / mensagem de patch / todo “fix pag 10” | Olhar dirigido |
| Chat resumindo “já fizemos ⋯ / dates / voids” | Confirmação enviesada |

**Pode** na fase cega: URL(s) no browser; prints do canvas desta sessão; `.docs/DESIGN_SYSTEM.md` (régua `P-…`); `ui-gosto` + este método; **`observacoes.md` / review humano / prints** como checklist de **crimes a caçar** (não como “já sanado”).

#### Protocolo obrigatório (2 tempos)

```text
T1 — FASE CEGA (escrever primeiro no …-rN)
  • Montar checklist NEGATIVA completa:
      – todos os bullets ALTA (+ MÉDIA se no review) do observacoes/humano
      – APs do tipo (ui-gosto §11) relevantes (grid-hole, CTA-spread, meta-baseline, …)
      – P0/P1 do relatório B **como se ainda fossem FAIL** (nomes do crime, sem ler o veredito PASS)
  • Abrir browser / tirar print do canvas e caçar **cada** item assumindo FAIL até prova PASS nesta sessão
  • Preencher tabela “Review × tela” + §3.3 **sem** mencionar o que o Fix fez
  • Se “parece ok” → ainda assim evidência (click/CDP/print); sem evidência = FAIL ou Não coberto

T2 — CRUZAMENTO (só depois de T1 completo no arquivo)
  • Abrir relatório anterior / notas de Fix
  • Coluna “vs rodada anterior”: sanado / ainda FAIL / regrediu / novo
  • Se T1 deu PASS e o fix listava o item → ok
  • Se T1 deu FAIL → volta C1 (não “descontar” porque o patch existiu)
```

#### Proibido no re-Scan

- Começar o relatório por “corrigimos X, Y, Z — validar”  
- Marcar PASS porque o código/diff/edição mostra a mudança (sem browser ou print desta sessão)  
- Pular item ALTA “porque já estava PASS no rN anterior” sem reabrir a rota  
- Usar linguagem de confirmação (“o void do ID foi empilhado ✓”) na fase cega  

Novo arquivo **sempre** `…-rN.md`. Régua na caça = tela (URL ou print do canvas) + DS + método + gosto + checklist negativa — **não** a narrativa do Fix.

---

## 5. Loop Fase C

```text
OK B (humano autorizou Fix)
  → Tela-prova → demais telas → estados → conferência cruzada
  → Fix (canvas padrão; construtor se escolhido; código nunca)
  → Re-Scan **cego** (T1: checklist negativa como se tudo ainda FAIL) 
       → depois cruzamento T2 com relatório anterior
       → GATE SCAN + relatório novo …-rN
  → Se DS precisa mudar (peça ou regra faltando): mini-A → OK humano → segue
  → ALIGNED candidato (§5.0) ou Fix de novo
  → DIFERENCAS_PARA_DEVS.md atualizado (projeto de código/construtor)
  → ALIGNED final só com OK humano explícito
```

### 5.0 Quando **pode** escrever ALIGNED

- [ ] GATE SCAN desta sessão válido (browser nas rotas do inventário e/ou prints do canvas)  
- [ ] Re-Scan: **T1 cego** feito antes do cruzamento T2 (VISUAL_QA_METHOD § Imparcialidade)  
- [ ] Tabela “Review humano × tela” sem FAIL ALTA (ou humano dispensou por escrito)  
- [ ] Telas oficiais do canvas só com peças oficiais e variáveis; tela-prova em cada superfície do diagnóstico  
- [ ] Cópia com data do canvas antes e depois da rodada; arquivo conferido no disco  
- [ ] Nenhum placeholder (“X”, “Lorem”) nas telas; texto de tela no teste do leigo  
- [ ] Conferência cruzada: mesma coisa, mesma medida  
- [ ] `DIFERENCAS_PARA_DEVS.md` completo (projeto de código/construtor)  
- [ ] **§3.3 intra-card** PASS nos forms scaneados (ou FAIL listado — nunca omitir)  
- [ ] Prints/círculos do humano no chat: todos PASS ou FAIL explícito  
- [ ] Pre-flight anti-slop PASS  
- [ ] Nenhuma rota do review humano em “Não coberto” com risco médio/alto  
- [ ] **OK humano explícito** na mensagem (“ALIGNED ok” / “pode fechar”) — pré-flight interno sozinho **não** é ALIGNED final  

Sem isso: no máximo **“ALIGNED candidato — aguardando humano”**.

### 5.1 Pós-ALIGNED

Pedido humano após ALIGNED que muda layout/pattern (ex. “coloca a lista Y dentro do card X”):

```text
ALIGNED
  → pedido muda superfície / P-… / gosto interpretado?
       sim → mini-A (DS) → OK (salvo “atualiza DS e aplica” na mesma msg)
            → Fix → re-Scan …-rN → novo pre-flight
       não → polish P2 pontual sem nova lei (raro; preferir mini-A se houver dúvida)
```

**Regras do tipo no re-Scan:** aplicar a seção do tipo em ui-gosto §11 (ex.: cassino — prova social global ≠ contextual §11.1.5; remountar faixa global removida = FAIL).

---

## 6. Output

| Artefato | Path |
|----------|------|
| Relatório | `.docs/design-system-forge/QA_REPORTS/YYYY-MM-DD-<slug>[-rN].md` |
| Índice | `QA_REPORTS/README.md` |
| Notes | EXTRACTION_NOTES (Fase A + links Scan) |
| Diferenças para devs | `.docs/design-system-forge/DIFERENCAS_PARA_DEVS.md` |
| Telas | Canvas: área “Telas” oficial + “Rascunho · espelho …” |
