# Lei — anti-pressa (ler direito)

> Causa #1 de doc ruim e revisão fraca: o agente **otimiza para “fechar o gate”** em vez de **ler e aplicar**.  
> Vale para **toda fase** que grava `docs/` e, com barra máxima, para o **Revisor**.

## Por que o agente erra (diagnóstico)

| Causa | Sintoma | O que a skill exige agora |
|-------|---------|---------------------------|
| Pressa / “parecer pronto” | Marca tudo OK rápido; `revisao.md` grosso mas raso | Duas passagens obrigatórias; “Pronto quando” exige evidência |
| Checklist colapsado | Linha `3.1–3.7 OK` / `1.1 … 1.8` | **Uma linha por CA**; colapso = **reprovado** |
| CL0 só em meta de chat | Tira `qtd.` e Gate F6, deixa “Scraper”, Von Restorff, a11y sem tradução | CL0 = **jargão de domínio** também; Dicionário ou por extenso |
| Uma passagem só | Skim + Write | Passagem A (conteúdo) → Passagem B (clareza seção a seção) |
| Escape “técnico legível” | DS/contrato densos marcados OK sem limpar | Técnico **pode** existir; **leigo ainda precisa de Dicionário + 1ª menção clara** |
| Busca residual de mentira | Diz “zero qtd.” sem procurar | Grep/busca **obrigatória** + listar hits ou “zero hits” |
| “Pronto quando” fraco | “Seção Clareza preenchida” = verde | Preenchida **e** cada CA individual **e** residual limpo |

## Diretiva (todos os agentes que escrevem `docs/`)

1. **Ler o arquivo inteiro** (ou o trecho que vai editar) **antes** do Write — não adivinhar pelo título.  
2. **Não otimizar para velocidade.** Preferir uma correção certa a dez OKs rasos.  
3. Antes de gravar: CL0 em **cada seção** que tocou.  
4. Proibido no corpo: abreviação preguiçosa, meta de chat, jargão sem Dicionário.  
5. Se o tempo/contexto apertar: **pedir split** (ex.: revisor-discovery, revisor-mercado) — **nunca** colapsar CA.  
6. **Canvas também:** ao listar, auditar ou conferir componentes e telas, abrir **todos** os quadros (inclusive o segundo tema) e contar. No piloto o agente disse “25 componentes” olhando um quadro, quando um só quadro tinha 70 — o cliente teve de mandar “para de fazer com pressa”.  
7. **Antes de fechar o gate:** perguntar “alguma decisão desta fase mexe em outra fase?” e propagar (`reference/rules.md` → Propagação).

## Diretiva extra — Revisor (barra máxima)

### Protocolo de duas passagens (obrigatório)

**Por cada** `docs/{fase}.md`:

| Passagem | O que fazer | Proibido |
|----------|-------------|----------|
| **A — Conteúdo** | Abrir `target-model` da fase + arquivo. Marcar **cada** CA (1.1, 1.2…) em linha própria. Citar evidência curta na coluna Ação (onde está no doc). | `1.1–1.8 OK` · “parece ok” · pular CA |
| **B — Clareza** | Relêr o arquivo **seção a seção**. Em cada seção: *“leigo ficaria confuso? esclarece?”* Corrigir no arquivo. Só então CL0–CL5 = OK. | Marcar Clareza OK só porque passou no grep de `qtd.` |

Ordem: discovery → mercado → proto → MVP → contrato → setup → DS → brief → **só então** cruzada → residual → consolidar `revisao.md`.

### Proibições duras (Revisor)

- Colapsar intervalos de CA (`3.1–3.7`, `4.1–4.6`, `1.1 … 1.8`).  
- Marcar **Esclarece** no CL0 sem ter relido o arquivo na passagem B.  
- Usar “técnico mas legível” como desculpa para deixar jargão sem Dicionário (Scraper, Forge, Von Restorff, a11y, Polaris…).  
- Declarar R9 (busca residual) sem ter **rodado busca** e anotado resultado.  
- Fechar gate com Clareza OK e ainda existir no corpo: `qtd.`, `TBD`, “não inventar”, Gate F6, Shape Up, caminhos de arquivo da skill (`modules/…`), setas `→ proto/DS` sem português claro.

### Evidência mínima em `revisao.md`

| Exigência | Como prova |
|-----------|------------|
| Conteúdo | Uma linha por CA + ação/evidência |
| Clareza | Tabela CL0–CL5 por arquivo + lista do que **corrigiu** (paths) |
| Residual | Bloco “Busca residual”: padrões · hits · correção (ou “zero hits”) |
| Split | Se usou vários subagentes, listar qual fase cada um fechou |

## Checklist rápido (antes de dizer “pronto”)

1. [ ] Nenhuma linha de CA com “…” ou “–” entre números  
2. [ ] Passagem B feita em **todos** os arquivos da trilha  
3. [ ] Busca residual executada e registrada  
4. [ ] Jargão técnico tem Dicionário ou por extenso na 1ª vez  
5. [ ] Gate só depois de R1–R15 (ver `acceptance-criteria.md`)
