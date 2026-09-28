# QA visual — [produto] — [data] [opcional -rN]

> Preencher **todas** as seções. Vazio / “ok” / “…” = relatório **inválido**.  
> Scan = **URL aberta no browser** nesta sessão (não só DS / não só código).

| Campo | Valor |
|-------|--------|
| URL / alvo (principal desta passagem) | |
| Viewports | desktop ____ × ____ / mobile ____ × ____ |
| DS | `.docs/DESIGN_SYSTEM.md` versão ____ |
| Gosto | `docs/ui-gosto.md` |
| Modo | doc-only \| doc+diagnose \| doc+apply |
| Fase | A \| B (Scan+Diagnose) \| C (Fix) \| re-QA (loop C) |
| Re-Scan modo (se re-QA) | **T1 cego** feito? sim/não · **T2 cruzamento** depois? sim/não |
| Browser nesta sessão? | **sim** / não (se não → Scan inválido) |
| OK humano | A: ____ / B: ____ (C só com OK B) |

## Fase A — DS normalizado (se nesta rodada)

| Item | Ação | Notas |
|------|------|-------|
| Removido / rejeitado | | |
| Reforçado (DO) | | |
| Cadastro deslogado = Primary? | | |
| Marca Primary preservada? | | |
| Exceções humanas mantidas | | |

## Inventário de URLs / alvos (obrigatório — Fase B)

> Descobrir **antes** do passeio. Fontes: humano, Lovable/`get_project`, DS rotas v1, router/código, links do nav/footer.  
> Em dúvida → perguntar. Não assumir uma única home.

| Alvo (URL ou rota) | Origem da descoberta | Scaneado? | Se não: motivo + risco |
|--------------------|----------------------|-----------|-------------------------|
| Base publicada | | sim / não | |
| Base preview / id-preview (se houver) | | | |
| Deep link / rota 1 | | | |
| Deep link / rota 2 | | | |
| Overlay sem rota (listar) | | | |
| Sessão **deslogada** | | | |
| Sessão **logada** (se o produto tiver) | | | |

## Inventário de popups / overlays (obrigatório — Fase B)

> Nem todo popup é óbvio. Descobrir no **código** (`*Modal*`, `*Dialog*`, `*Sheet*`, `*Drawer*`, Welcome, Confirm…) + store/`open*` + gatilhos de UI (Buscar, Sino, tile, Conta, faixa).  
> Órfão / desligado = ainda entra na tabela.

| Overlay (nome código ou UI) | Tipo | Gatilho para abrir | Scaneado? | Se não: motivo + risco |
|-----------------------------|------|--------------------|-----------|-------------------------|
| | modal / sheet / drawer / dialog / banner / outro | | sim / não | |

## GATE SCAN — checklist (Fase B)

- [ ] Inventário de URLs preenchido  
- [ ] Inventário de **popups/overlays** preenchido (não só os óbvios)  
- [ ] URL(s) escolhidas abertas no browser **nesta** sessão  
- [ ] Desktop percorrido (dobra + scroll até footer)  
- [ ] Mobile percorrido (shell + scroll + overlays)  
- [ ] Cada overlay “scaneado”: aberto e fechado  
- [ ] Fluxo crítico 2 (ex. checkout) se no inventário  
- [ ] Deep links / logado: scaneado ou Não coberto  
- [ ] Urgência dismissível revalidada ou Não coberto  
- [ ] Caça: espaço vazio · poço · corte · CTA/hit morto · layout quebrado  

## Escopo percorrido (evidência por passo)

| Passo | Desktop — o que vi / evidência | Mobile — o que vi / evidência |
|-------|--------------------------------|-------------------------------|
| A. Dobra | | |
| B. Scroll (listar seções) | | |
| C. Overlays (cada um) | | |
| D. Mobile shell | | |
| E. Estados (loading/empty/error) | | |
| F. CDP / medidas | | |

### Espaço vazio / layout quebrado (obrigatório comentar)

> Incluir **intra-card** (ui-gosto AP-GRID-HOLE / AP-CTA-SPREAD / AP-META-BASELINE).  
> Não basta gap entre seções.

| Achado | Tipo (seção / grid-hole / CTA-spread / meta-baseline) | Viewport | Evidência | Cesta |
|--------|--------------------------------------------------------|----------|-----------|-------|
| (nenhum / descrever) | | | | P0/P1/P2 |

### Prints / círculos do humano (se houver no chat)

| # | O que o círculo aponta | Rota | PASS/FAIL | Evidência nesta sessão |
|---|------------------------|------|-----------|------------------------|
| | | | | |

## P0 Bugs

| # | Achado | Onde | Evidência | vs DS/`P-…` |
|---|--------|------|-----------|-------------|
| | | | | |

## P1 Lacunas (DS / gosto / AI tell)

| # | Achado | Onde | Evidência | vs DS/`P-…` / gosto |
|---|--------|------|-----------|---------------------|
| | | | | |

## P2 Agonias

| # | Achado | Onde | Evidência |
|---|--------|------|-----------|
| | | | |

## Gosto Miguel — PASS/FAIL

| Item (ui-gosto §10) | Resultado | Evidência (viewport) |
|---------------------|-----------|----------------------|
| Surface neutra / sem carpete | PASS / FAIL | |
| Primary só CTA/ativo (marca) | | |
| Nested perceptível | | |
| Sem glow/neon/glass chrome | | |
| 1 guia / Cadastro deslogado Primary | | |
| Hero estático / legível | | |
| CTA par alinhado | | |
| Auth sheet / sem poço | | |
| Providers com logo / footer | | |
| Anti-slop tells | | |

## Review humano × preview (obrigatório se existir review/notas/prints)

> Em **re-QA**: preencher em **T1 cego** — assumir FAIL até prova; **não** citar o Fix.

| Bullet do review | Rota | PASS / FAIL / mitigado | Evidência (browser desta sessão) |
|------------------|------|------------------------|----------------------------------|
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

## Pre-flight

- [ ] Completo (reference-anti-slop)  
- [ ] Browser aberto nas rotas do inventário **nesta** sessão  
- [ ] Re-QA: T1 cego **antes** de T2  
- [ ] Review humano ALTA sem FAIL (ou N/A)  
- [ ] ALIGNED candidato? sim / não  
- [ ] ALIGNED final? **só** com OK humano explícito  

## Não coberto

| Item | Motivo | Risco |
|------|--------|-------|
| | | |

> Se item do review humano estiver aqui com risco ≥ médio → **proibido** ALIGNED.

## Próxima ação

- [ ] Aguardando **OK A** (humano validou DS)  
- [ ] Aguardando **OK B** (humano validou Scan; faltou algo?)  
- [ ] Aguardando **OK B → Fix** / loop C  
- [ ] ALIGNED candidato — aguardando OK humano  
- [ ] ALIGNED (OK humano)  

- [ ] **OK B** recebido → iniciar Fase C (Fix)  
- [ ] Revalidar → `…-rN.md`  
- [ ] ALIGNED candidato / aguardando OK humano  
- [ ] ALIGNED final (OK humano) / encerrar  
