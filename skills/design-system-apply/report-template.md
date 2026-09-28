# QA visual — [produto] — [data] [opcional -rN]

> Preencher **todas** as seções. Vazio / “ok” / “…” = relatório **inválido**.  
> Scan = **tela aberta nesta sessão**: site/construtor no browser **ou** print do canvas via MCP (não só DS / não só código).

| Campo | Valor |
|-------|--------|
| Alvo principal desta passagem (URL, rota ou tela do canvas) | |
| Tipo de produto (ui-gosto §11) | |
| Alvo de correção | canvas (padrão) \| construtor (secundário) |
| Viewports | desktop ____ × ____ / mobile ____ × ____ / outra superfície ____ |
| DS | `.docs/DESIGN_SYSTEM.md` versão ____ |
| Gosto | `docs/ui-gosto.md` — geral + §11.__ |
| Fase | A \| B (Scan + espelho) \| C (Fix) \| re-QA (loop C) |
| Re-Scan modo (se re-QA) | **T1 cego** feito? sim/não · **T2 cruzamento** depois? sim/não |
| Evidência nesta sessão? | browser **sim/não** · prints do canvas **sim/não** (nenhum → Scan inválido) |
| OK humano | A: ____ / B: ____ (C só com OK B) |

## Diagnóstico das telas (Etapa 0)

| Tela / estado | Onde existe (site/código · construtor · canvas) | No canvas usa só peças oficiais? | Observação |
|---------------|-------------------------------------------------|----------------------------------|------------|
| | | | |

## Fase A — DS confrontado com o gosto (se nesta rodada)

| Item | Ação | Notas |
|------|------|-------|
| Removido / rejeitado | | |
| Reforçado (DO) | | |
| Primary na ação real? | | |
| Marca Primary preservada? | | |
| Exceções humanas mantidas | | |
| Seções de outros tipos (“não se aplica” + motivo) | | |

## Inventário de URLs / alvos (obrigatório — Fase B)

> Descobrir **antes** do passeio. Fontes: humano, MCP do construtor, DS rotas v1, router/código, links do nav/footer, pranchas do canvas.  
> Em dúvida → perguntar. Não assumir uma única home.

| Alvo (URL, rota ou tela do canvas) | Origem da descoberta | Scaneado? | Se não: motivo + risco |
|------------------------------------|----------------------|-----------|-------------------------|
| Base publicada | | sim / não | |
| Base preview (se houver) | | | |
| Deep link / rota 1 | | | |
| Deep link / rota 2 | | | |
| Tela do canvas 1 | | | |
| Overlay sem rota (listar) | | | |
| Sessão **deslogada** | | | |
| Sessão **logada** (se o produto tiver) | | | |

## Inventário de popups / overlays (obrigatório — Fase B)

> Nem todo popup é óbvio. Descobrir no **código** (`*Modal*`, `*Dialog*`, `*Sheet*`, `*Drawer*`, Welcome, Confirm…) + store/`open*` + gatilhos de UI + pranchas do canvas.  
> Órfão / desligado = ainda entra na tabela.

| Overlay (nome código ou UI) | Tipo | Gatilho para abrir | Scaneado? | Se não: motivo + risco |
|-----------------------------|------|--------------------|-----------|-------------------------|
| | modal / sheet / drawer / dialog / banner / outro | | sim / não | |

## Telas espelhadas no canvas (Fase B — projeto de código ou construtor)

> Área “Rascunho · espelho do site”. Estrutura e conteúdo **como estão**. Não é tela oficial; não é apagada depois.

| Tela | Origem (URL/rota) | Espelho (nome da prancha) | Blocos sem peça oficial equivalente | Print real × espelho |
|------|-------------------|---------------------------|-------------------------------------|----------------------|
| | | | | |

## GATE SCAN — checklist (Fase B)

- [ ] Diagnóstico das telas preenchido  
- [ ] Inventário de URLs / telas preenchido  
- [ ] Inventário de **popups/overlays** preenchido (não só os óbvios)  
- [ ] URL(s) abertas no browser **nesta** sessão; telas do canvas com print **desta** sessão  
- [ ] Desktop percorrido (dobra + scroll até footer)  
- [ ] Mobile percorrido (shell + scroll + overlays)  
- [ ] Cada overlay “scaneado”: aberto e fechado  
- [ ] Fluxo crítico 2 (ex. checkout) se no inventário  
- [ ] Deep links / logado: scaneado ou Não coberto  
- [ ] Telas ausentes no canvas: espelhadas ou motivo  
- [ ] Caça: espaço vazio · poço · corte · CTA/hit morto · layout quebrado  

## Escopo percorrido (evidência por passo)

| Passo | Desktop — o que vi / evidência | Mobile — o que vi / evidência |
|-------|--------------------------------|-------------------------------|
| A. Dobra | | |
| B. Scroll (listar seções) | | |
| C. Overlays (cada um) | | |
| D. Mobile shell | | |
| E. Estados (loading/empty/error) | | |
| F. CDP / bounds do canvas / medidas | | |

### Espaço vazio / layout quebrado (obrigatório comentar)

> Incluir **intra-card** (ui-gosto AP-GRID-HOLE / AP-CTA-SPREAD / AP-META-BASELINE).  
> Não basta gap entre seções.

| Achado | Tipo (seção / grid-hole / CTA-spread / meta-baseline) | Viewport | Evidência | Cesta |
|--------|--------------------------------------------------------|----------|-----------|-------|
| (nenhum / descrever) | | | | P0/P1/P2 |

### Prints / círculos do humano (se houver no chat)

| # | O que o círculo aponta | Rota / tela | PASS/FAIL | Evidência nesta sessão |
|---|------------------------|-------------|-----------|------------------------|
| | | | | |

## P0 Bugs

| # | Achado | Onde | Evidência | vs DS/`P-…` |
|---|--------|------|-----------|-------------|
| | | | | |

## P1 Lacunas (DS / gosto / AI tell / peça fora do oficial)

| # | Achado | Onde | Evidência | vs DS/`P-…` / gosto |
|---|--------|------|-----------|---------------------|
| | | | | |

## P2 Agonias

| # | Achado | Onde | Evidência |
|---|--------|------|-----------|
| | | | |

## Gosto — PASS/FAIL (geral + tipo)

| Item (ui-gosto §10 + checklist do tipo em §11) | Resultado | Evidência (viewport) |
|------------------------------------------------|-----------|----------------------|
| Surface neutra / sem carpete | PASS / FAIL | |
| Primary só CTA/ativo (marca) | | |
| Nested perceptível | | |
| Sem glow/neon/glass chrome | | |
| 1 guia visual / Primary na ação real | | |
| Hero estático / legível | | |
| CTA par alinhado | | |
| Auth sheet / sem poço | | |
| Logos de terceiros com logo / rodapé estruturado | | |
| Anti-slop tells | | |
| (itens do tipo — §11.__) | | |

## Review humano × tela (obrigatório se existir review/notas/prints)

> Em **re-QA**: preencher em **T1 cego** — assumir FAIL até prova; **não** citar o Fix.

| Bullet do review | Rota / tela | PASS / FAIL / mitigado | Evidência (browser ou print desta sessão) |
|------------------|-------------|------------------------|-------------------------------------------|
| | | | |

## Fase C — telas trabalhadas (só loop C)

| Ordem | Tela | Ação (ajuste / redesenho) | Mini-A necessário? | Print depois |
|-------|------|---------------------------|--------------------|--------------|
| 1 | Tela-prova (computador + celular) | | | |
| 2 | | | | |

### Conferência cruzada

| Medida (ex.: espaço filtros → lista) | Telas comparadas | Valores encontrados | Valor único no DS |
|--------------------------------------|------------------|---------------------|-------------------|
| | | | |

## Re-QA — T1 cego (só loop C)

> Checklist negativa completa. Caçar como se **todos** os crimes ainda existissem.  
> **Não** abrir relatório anterior / EXTRACTION_NOTES de Fix / diff nesta etapa.

| Crime (ALTA/MÉDIA/AP-…) | Assumido | Achado T1 (PASS/FAIL/Não coberto) | Evidência fresca |
|-------------------------|----------|-----------------------------------|------------------|
| | ainda FAIL | | |

## Re-QA — T2 cruzamento (depois de T1)

> Só agora abrir `…` anterior / notas de Fix.

| Item T1 | vs rodada anterior (sanado / ainda FAIL / regrediu / novo) | Nota |
|---------|-------------------------------------------------------------|------|
| | | |

## Diferenças para os devs (resumo — detalhe em `DIFERENCAS_PARA_DEVS.md`)

> Projeto de código ou construtor: cada diferença entre a tela real e a tela alinhada no canvas.

| Tela | Rota / arquivo | Como está | Como deve ficar (tela do canvas) | Peça / token | Prioridade |
|------|----------------|-----------|----------------------------------|--------------|------------|
| | | | | | P0/P1/P2 |

## Pre-flight

- [ ] Completo (reference-anti-slop)  
- [ ] Browser nas rotas do inventário e/ou prints do canvas **nesta** sessão  
- [ ] Re-QA: T1 cego **antes** de T2  
- [ ] Review humano ALTA sem FAIL (ou N/A)  
- [ ] Telas oficiais só com peças oficiais e variáveis  
- [ ] Conferência cruzada fechada  
- [ ] `DIFERENCAS_PARA_DEVS.md` atualizado (se código/construtor)  
- [ ] ALIGNED candidato? sim / não  
- [ ] ALIGNED final? **só** com OK humano explícito  

## Não coberto

| Item | Motivo | Risco |
|------|--------|-------|
| | | |

> Se item do review humano estiver aqui com risco ≥ médio → **proibido** ALIGNED.

## Próxima ação

- [ ] Aguardando **OK A** (humano validou o confronto do DS com o gosto)  
- [ ] Aguardando **OK B** (humano validou Scan e espelho; faltou algo?)  
- [ ] **OK B** recebido → Fase C (tela-prova primeiro)  
- [ ] Aguardando OK de **mini-A** (peça/regra nova no DS)  
- [ ] Revalidar → `…-rN.md`  
- [ ] ALIGNED candidato — aguardando OK humano  
- [ ] ALIGNED final (OK humano) / encerrar  
