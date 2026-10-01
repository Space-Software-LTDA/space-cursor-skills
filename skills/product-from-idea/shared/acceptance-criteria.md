# Critérios de aceitação por fase + anti-padrões de IA

> **Fonte canônica por fase:** `modules/*/target-model.md` (CA + anti-padrões no final).  
> Este arquivo é o **agregado** para o Revisor varrer tudo de uma vez.  
> Índice de anexos reais: `modules/README.md`.  
> **Lei de clareza (todos os docs):** [`docs-clarity.md`](docs-clarity.md) — **obrigatória**; o Revisor **reprova** se falhar.

---

## Como o Revisor trabalha

1. Ler `modules/README.md` + **`shared/docs-clarity.md`** + **`shared/anti-rush.md`** + target-model da fase sob auditoria.  
2. Abrir `.docs/{fase}.md` **inteiro** e comparar com **CA do target-model** **e** com o bloco **CLAREZA (CL\*)** — **Passagem A** (uma linha por CA) depois **Passagem B** (clareza seção a seção).  
3. Marcar: **OK** · **Corrigir** · **Alucinação** · **Falta** · **Adiado com risco (cliente)** · **Falhou clareza**.  
4. Corrigir com **replace limpo** (ou abrir o agente da fase só para o buraco).  
5. Busca residual + gravação em `.docs/revisao.md` — **incluindo** Clareza humana + Busca residual.  
6. Só então liberar **Fase 10 — Manual comercial** (depois: Fase 11 tasks).

**Temperatura / barra:** nas fases 1–3 priorizar clareza e corte; na 2 exigir evidência; na 5 exigir lista do *quê* sem código inventado; na revisão ser **rigoroso** com inconsistência **e** com documento que parece conversa com a IA.

**Regra de ouro do Revisor:** se o documento só faz sentido dentro do Cursor → **não passa**, mesmo que o conteúdo de produto esteja correto.  
**Regra de ouro anti-pressa:** CA colapsado (`3.1–3.7 OK`) ou residual sem evidência → revisão **inválida** — Controlador devolve.

---

## CLAREZA HUMANA — obrigatório em **toda** fase (CL\*)

> Fonte: [`docs-clarity.md`](docs-clarity.md).  
> O Revisor aplica **CL0–CL5 em cada** `.docs/` auditado (discovery → DS → brief → e, depois, no manual).  
> **Um CL vermelho = fase não OK** até corrigir (ou adiado com risco **explícito do cliente** só se for pendência de produto, nunca se for meta de chat).  
> Protocolo: [`anti-rush.md`](anti-rush.md) — duas passagens · uma linha por CA.

**Mantra do Revisor (repetir em todo arquivo):**

> Se eu fosse um leigo lendo esta informação, eu ficaria confuso? Isso esclarece?  
> Confunde → **Falhou clareza**. Esclarece na 1ª leitura → segue.

**Anti-pressa:** ver [`anti-rush.md`](anti-rush.md). CL0 **não** é só achar `qtd.` — é jargão de domínio também. Revisão com CA colapsado = **inválida**.

| # | Critério | Barra | Falha típica |
|---|----------|-------|--------------|
| **CL0** | **Posicionamento do leigo** | Em cada seção: “Se eu fosse leigo lendo isto, ficaria confuso? Isso esclarece?” — se confunde → reescrever | Jargão, frases soltas, assume que o leitor “já sabe” |
| **CL1** | **Teste do estranho** | Imprimir e entregar a cliente/sócio **sem** Cursor: a pessoa entende | Parece log de chat / nota para a IA |
| **CL2** | **Zero meta de processo no corpo** | Sem Shape Up, Appetite, Rabbit holes, Gate F6, CA, GATE 0, “Controlador”, “subagente”, “nesta thread”, “abrir anexo”, caminhos de arquivo da skill (`modules/…`) | Título “só o que for real nas fases”; cabeçalho com lista de PDFs da skill |
| **CL3** | **Zero abreviação preguiçosa** | Sem `qtd.`, `TBD`, `A DEFINIR` gritando; escrever **quantidade**, **ainda não definido** | `preço/qtd. de crédito` |
| **CL4** | **Não assume que o leitor sabe** | 1ª menção = por extenso + (sigla) + o que é; Dicionário no topo | SAM, matching, heatmap, HML sozinho |
| **CL5** | **Zero resíduo de chat** | Sem “não inventar”, “humano confirmou”, “cliente corrigiu”, “rodada anterior”, “ruído de chat” | Nota para o agente no meio do doc |

**Manual comercial (`{slug}.md`) — barra extra:** CL0–CL5 + deve servir para **apresentar / lançar**; decisão do time só em **Uso interno** (não no miolo).

---

## Anti-padrões de IA (vale em todas as fases)

| Anti-padrão | Sintoma | Ação |
|-------------|---------|------|
| Alucinação | Fato/fonte/URL/% que o cliente não disse e não tem fonte | Remover ou virar **Hipótese** com rótulo |
| Batizou sozinho | Nome de modo/produto/API inventado (ex. “AIDE”) | Descrever sem marca até confirmar |
| Frankenstein | Tabelas irmãs com schemas diferentes; remendos | Reescrever arquivo limpo |
| Sem dicionário | Leigo não entende o doc | Criar **Dicionário** no topo |
| Sopa de siglas | TAM/SAM/E0 sem tradução | Extenso + (sigla) + o que é |
| Número sem conta | “~15–25M” sem fórmula | Exigir conta ou baixar confiança + conta |
| Contradiz fase anterior | Proto ≠ discovery; contrato ≠ MVP | Alinhar ou abrir gate com o cliente |
| Escopo inchado sem gate | Entrou feature no meio sem eco/confirma | Confirmar ou cortar |
| Resíduo de chat | “cliente corrigiu”, “antes era X”, “não inventar heatmap” | Replace limpo (**CL5**) |
| Meta de agente no doc | “só o que for real nas fases”, Shape Up no título, caminhos de arquivo da skill no cabeçalho | Reescrever (**CL2**) |
| Abreviação preguiçosa | `qtd.`, `TBD`, `HML` sem por extenso | Expandir (**CL3** / **CL4**) |
| Thread/fase errada | Doc da fase N com assunto da fase N+2 | Cortar / mover |
| Inventário órfão | `data.md` fora de `.docs/` como verdade | Espelhar no contrato |
| Over-spec precoce | Seletores/OpenAPI densos antes da hora | Parking / task |
| Doc só pro Cursor | Passa CA de conteúdo mas falha no teste do estranho | **Reprovar clareza** — reescrever |

---

## CA — Fase 1 Discovery (`.docs/discovery.md`)

| # | Critério | OK? |
|---|----------|-----|
| 1.1 | Dicionário no topo | |
| 1.2 | Problem statement: quem + dor + sucesso + o que **não** é | |
| 1.3 | Persona com momento (não “todo mundo”) | |
| 1.4 | Sucesso mensurável | |
| 1.5 | Matching / “mesmo produto” fechado ou adiado com risco | |
| 1.6 | Entradas + canais do dia 1 | |
| 1.7 | Confirmado / Hipótese / Aberto + Gate | |
| 1.8 | Zero solução técnica densa no lugar do problema | |
| **1.CL** | **CL0–CL5** (`docs-clarity.md`) — posicionamento do leigo | |

## CA — Fase 2 Mercado (`.docs/pesquisa-mercado.md`)

| # | Critério | OK? |
|---|----------|-----|
| 2.1 | Dicionário (TAM/SAM/SOM em português) | |
| 2.2 | Definição dentro/fora alinhada ao discovery | |
| 2.3 | TAM/SAM/SOM com **conta explícita** cada um | |
| 2.4 | ≥2 sinais de demanda com número + fonte | |
| 2.5 | ≥5 alternativas com preço/modelo tentado + falha vs nossa dor | |
| 2.6 | Escala ou bloqueio honesto; browser quando UI exige | |
| 2.7 | Gaps + implicação (seguir/pivotar/matar) | |
| 2.8 | Monetização/afiliado com fonte se o cliente pediu (F9) | |
| 2.9 | Gate gravado | |
| **2.CL** | **CL0–CL5** (`docs-clarity.md`) | |

## CA — Fase 3 Protótipo (`.docs/prototipo.md`)

| # | Critério | OK? |
|---|----------|-----|
| 3.1 | Dicionário; telas com **nome humano** | |
| 3.2 | Fluxos cobrem as entradas do discovery | |
| 3.3 | Telas com objetivo + campos/ações (sem hex) | |
| 3.4 | Estados loading/empty/error mínimos | |
| 3.5 | Alinhado a gaps do mercado (diferencial) | |
| 3.6 | Feature nova só com eco+confirma na época | |
| 3.7 | Gate gravado | |
| **3.CL** | **CL0–CL5** (`docs-clarity.md`) | |

## CA — Fase 4 MVP (`.docs/mvp.md`)

| # | Critério | OK? |
|---|----------|-----|
| 4.1 | Dicionário | |
| 4.2 | Dentro / fora explícitos | |
| 4.3 | Jornadas do dia 1 batem com proto | |
| 4.4 | Sucesso do MVP | |
| 4.5 | Monetização: mecanismo claro; preço adiado só com risco escrito em português | |
| 4.6 | Gate gravado | |
| **4.CL** | **CL0–CL5** (`docs-clarity.md`) | |

## CA — Fase 5 Contrato (`.docs/contrato.md`)

| # | Critério | OK? |
|---|----------|-----|
| 5.1 | Dicionário | |
| 5.2 | Fonte primária × onde mora a verdade | |
| 5.3 | Conta/auth + regras de crédito se houver | |
| 5.4 | Lista do *quê* guardar (campos padronizados; uma tabela) | |
| 5.5 | Quem faz o quê (extensão/app vs servidor) | |
| 5.6 | Pedidos ao servidor em português (sem inventar API name à toa) | |
| 5.7 | Sem contradizer MVP/proto | |
| 5.8 | Aberto só com adiado explícito ou pendência real | |
| 5.9 | Gate gravado | |
| **5.CL** | **CL0–CL5** (`docs-clarity.md`) | |

## CA — Fase 6 Setup (`.docs/setup.md`)

| # | Critério | OK? |
|---|----------|-----|
| 6.1 | Dicionário | |
| 6.2 | Peças alinhadas ao contrato | |
| 6.3 | Git A/B/C decidido ou adiado com risco | |
| 6.4 | Boilerplate (ou “sem”) por peça + link | |
| 6.5 | Ambientes Local / Homologação / Produção (siglas só após por extenso) | |
| 6.6 | Contas externas checklist | |
| 6.7 | Ponteiros: Manual (10) · Forge (7) · qa-space — **sem** DBML/DS densos aqui | |
| 6.8 | Gate gravado | |
| **6.CL** | **CL0–CL5** (`docs-clarity.md`) | |

## CA — Fase 7 Design System

> Canônico: `modules/07-design-system/target-model.md` (DS1–DS12 + **DS.CL**). Abaixo = checklist rápido do Revisor.

| # | Critério | OK? |
|---|----------|-----|
| 7.1 | Tríade: `DESIGN_SYSTEM.md` + `tokens.dtcg.json` + `EXTRACTION_NOTES` | |
| 7.2 | GATE 0 ≥ C (ou parcial autorizado) + Primary/Surface com evidência ou humano | |
| 7.3 | Foundations F1–F8 densas (não moodboard); elevation ≠ motion | |
| 7.4 | Componentes com **states**; `P-…` A–D/F (ou N/A justificado) | |
| 7.5 | Superfícies do setup cobertas (frontend / extension / overlays) | |
| 7.6 | STOP Forge honesto; gate de fase gravado; Apply **não** smuggled | |
| 7.7 | Densidade ≈ anexo de referência do módulo 07 (estrutura); **sem** colar cor de outro produto | |
| 7.8 | Não redefine produto (só visual) | |
| **7.CL** | **CL0–CL5** no `DESIGN_SYSTEM.md` (corpo legível; EXTRACTION_NOTES pode ser mais técnico ao time) | |

## CA — Fase 8 Telas (`.docs/telas.md` + canvas)

> Canônico: `modules/08-screens/target-model.md` (T1–T13 + **T.CL**). Método: skill `design-system-apply`.

| # | Critério | OK? |
|---|----------|-----|
| 8.1 | Dicionário no topo, com os termos da skill Apply traduzidos | |
| 8.2 | Lista de telas cobre **todas** as telas do protótipo (nome humano · superfície e tamanhos · montar/corrigir) | |
| 8.3 | Tela 1 = Home no tema principal, aprovada antes das demais (site: computador, celular só se o cliente pedir; extensão/app: tamanho real) | |
| 8.4 | Cada tela essencial com OK do cliente **e** Apply sem pendência, uma por vez (data + relatório por linha; correção do Apply mostrada de novo ao cliente) | |
| 8.5 | Telas só com peças oficiais do DS (cópias ligadas aos componentes + variáveis) | |
| 8.6 | Toda mudança no DS nesta fase = nova versão com motivo (DS + `telas.md`) | |
| 8.7 | Estados do protótipo cobertos ou pendentes por escrito | |
| 8.8 | Telas batem com protótipo, MVP e contrato (nada novo sem eco → confirma) | |
| 8.9 | Onde estão as telas + relatórios linkados | |
| 8.10 | Gate gravado | |
| 8.11 | Propagação: o que as telas revelaram (tela, estado, dado, regra) está também em protótipo, MVP e contrato | |
| 8.12 | Canvas protegido: cópias com data por rodada; prints “depois” da versão aprovada de cada tela | |
| 8.13 | Texto de tela no teste do leigo; sem placeholder “X”; valores fictícios aprovados e iguais em todas as telas | |
| **8.CL** | **CL0–CL5** (`docs-clarity.md`) — sem jargão cru do Apply | |

## CA — Brief interno (`.docs/produto.md`)

> Índice vago para o time. **Não** substitui o manual comercial.

| # | Critério | OK? |
|---|----------|-----|
| P.1 | Existe e aponta links das fases | |
| P.2 | Continua curto (não vira monolito) | |
| P.3 | Não é passado como “produto completo” no lugar de `{slug}.md` | |
| **P.CL** | **CL0–CL5** | |

## CA — Fase 10 Manual comercial (`.docs/{slug}.md`)

> Canônico: `modules/10-product-manual/target-model.md` (**M1–M29**).  
> **Barra máxima de clareza** — este arquivo vai para o mercado.

| # | Critério | OK? |
|---|----------|-----|
| 10.1 | `{slug}.md` existe | |
| 10.2 | Parte A sozinha (frase, problema-história, destaques, jornada, dia 1) | |
| 10.3 | Parte B sozinha (história, mercado+conta, validação, dinheiro, gap) | |
| 10.4 | Parte C sistema + regras + riscos conhecidos + fora de propósito | |
| 10.5 | Cobertura absoluta dos fatos fechados | |
| 10.6 | Tom comercial; estrutura (problema · escopo · solução · riscos · fora) **sem** jargão Shape Up no corpo | |
| 10.7 | ≥1 PDF/HTML real aberto pelo agente (não listar no cabeçalho comercial) | |
| 10.8 | Decisão em **Uso interno** | |
| 10.9 | Jornada e destaques batem com as telas aprovadas na Fase 8 (se usar imagem, só print de tela aprovada) | |
| **10.CL** | **CL0–CL5 + teste do estranho estrito** (daria para colar num PDF de pitch?) | |

## CA — Consistência cruzada (obrigatório no Revisor)

| # | Critério | OK? |
|---|----------|-----|
| X.1 | Nome do produto igual em todos | |
| X.2 | Persona/corte discovery = proto = MVP | |
| X.3 | Canais/lojas: mesma lista (ou diff explícito no MVP) | |
| X.4 | Monetização: mercado ↔ MVP ↔ contrato | |
| X.5 | Matching: discovery ↔ contrato | |
| X.6 | Nada “fechado” com buraco que o cliente já avisou | |
| X.7 | Telas ↔ protótipo ↔ DS ↔ contrato: mesmas telas e nomes; peças do DS; dado mostrado existe no contrato | |
| X.8 | Decisões tardias propagadas: cada decisão datada no `.docs/README.md` aparece no arquivo dono (protótipo, MVP, contrato, DS) | |
| X.9 | Nome canônico renomeado sem sobra do nome antigo em nenhum arquivo; nenhum status vencido (versão “rascunho” já aprovada, próximo passo antigo) | |
| **X.CL** | **Nenhum** `.docs/` da trilha com CL0–CL5 vermelho | |

---

## CA — Fase 9 Revisão (o Revisor passa neste checklist)

> Canônico: `modules/09-review/target-model.md`.

| # | Critério | OK? |
|---|----------|-----|
| R1 | Todas as fases 1–8 (+ produto.md) passaram pelo checklist de conteúdo | |
| R2 | Alucinações removidas ou viraram Hipótese | |
| R3 | Contradições entre docs resolvidas ou listadas | |
| R4 | `.docs/revisao.md` gravado | |
| R5 | Gate libera ou bloqueia **Fase 10 (manual)** — **não** tasks | |
| **R6** | Leu [`docs-clarity.md`](docs-clarity.md) e aplicou o **posicionamento do leigo** em todo arquivo | “Ficaria confuso? Isso esclarece?” |
| **R7** | Seção **Clareza humana** preenchida em `revisao.md` (por arquivo) | |
| **R8** | Todo arquivo com **\*.CL** marcado OK ou corrigido nesta rodada | |
| **R9** | Busca residual **executada e anotada** (hits ou “zero hits”) | Não basta afirmar |
| **R10** | Se liberar Fase 10: deixa explícito que o **manual** também terá barra CL máxima | |
| **R11** | Duas passagens por arquivo (A conteúdo · B clareza) — [`anti-rush.md`](anti-rush.md) | |
| **R12** | Zero CA colapsado (`3.1–3.7`, `1.1 …`) — uma linha por critério | Controlador **rejeita** colapso |
| **R13** | Coluna Ação com evidência curta do doc (não só “OK”) | |
| **R14** | Jargão de domínio (Scraper, Forge, a11y…) com Dicionário ou por extenso | Sem escape “técnico legível” |
| **R15** | Telas conferidas: abriu os prints registrados (ou o canvas) de cada tela essencial e comparou com `telas.md`, protótipo e DS | Evidência por tela — não basta ler `telas.md` |

---

## CA — Fase 11 Tarefas (`.docs/tarefas.md` + `.task/`)

> Canônico: `modules/11-task/target-model.md` (TK1–TK9 + **TK.CL**). Vem **depois** do Revisor: quem valida é o Controlador, com o cliente, fatia por fatia.

---

## Saída do Revisor

Arquivo: `.docs/revisao.md` (template).  
Por fase: **uma linha por CA** + **\*.CL** + evidência.  
Seção obrigatória: **Clareza humana** + **Busca residual**.  
Gate: liberar **Fase 10 — Manual** (não pular para tasks).  
Tasks = **Fase 11**, só após manual `{slug}.md` fechado ou adiado com risco **e** clareza OK.

**Controlador valida:** se `revisao.md` tiver CA colapsado ou residual sem evidência → **devolver** ao Revisor (não avançar).
