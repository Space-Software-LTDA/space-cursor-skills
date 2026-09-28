---
name: design-system-apply
description: >-
  Aplica DS do produto em 3 fases com OK humano entre cada uma: (A) normaliza
  .docs/DESIGN_SYSTEM.md vs ui-gosto; (B) Scan completo na URL + relatório de gaps;
  (C) Fix + loop até ALIGNED. Proibido A→C sem OK. Visual only. Use com
  /design-system-apply, "IKEA", "aplicar DS".
disable-model-invocation: true
---

# Design System Apply / IKEA

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/design-system-apply/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo). Sem Sync a copia nao atualiza.  
> Ver `00-COPIA-LEIA-ME.md`. Hub pack: **`/skill-update`**. Fluxo repo: **`AGENTS.md`**.

**Trigger:** `/design-system-apply` · “IKEA” · “aplicar DS” · “limpar gosto”  
**Idioma:** português.  
**Par:** Forge = `design-system-forge` (CORE bruto). Esta skill **normaliza**, **audita o front** e **corrige**.

## Conteúdo genérico

Serve **qualquer produto**. Sem ID/URL/default de cliente. Hub: `/skill-update`.

## Onde gravar artefatos (`.docs/`)

| Situação | O que fazer |
|----------|-------------|
| Fora de git repo | Criar `.docs/` e gravar |
| Dentro de git repo | Idem + `.docs/` no **`.gitignore`** se faltar |

| Artefato | Path |
|----------|------|
| DS (Fase A edita) | `.docs/DESIGN_SYSTEM.md` |
| Notes | `.docs/design-system-forge/EXTRACTION_NOTES.md` |
| Relatório Fase B / re-QA | `.docs/design-system-forge/QA_REPORTS/YYYY-MM-DD-<slug>[-rN].md` |

Nunca sobrescrever relatório — sempre `…-rN.md`.

## Constituição (obrigatório)

1. [`../docs/README.md`](../docs/README.md) — seção `design-system-apply`  
2. `.docs/DESIGN_SYSTEM.md` do produto  
3. [`../docs/ui-gosto.md`](../docs/ui-gosto.md) **inteiro**  
4. [`../docs/design-system.md`](../docs/design-system.md) — apoio; **marca do produto manda**  
5. [VISUAL_QA_METHOD.md](VISUAL_QA_METHOD.md) · [report-template.md](report-template.md) · [reference-anti-slop.md](reference-anti-slop.md)

**Não** é `qa-space`. Visual only.

---

## As três fases (travado)

```text
Forge → DS bruto aprovado
        ↓
┌───────────────────────────────────────┐
│ FASE A — DS × gosto (documento)       │
│ PARAR → humano valida                 │
└───────────────────────────────────────┘
        ↓ OK A
┌───────────────────────────────────────┐
│ FASE B — Scan URL cabo a rabo         │
│ Relatório de gaps / anti-padrões      │
│ PARAR → humano valida (faltou algo?)  │
└───────────────────────────────────────┘
        ↓ OK B (autoriza Fix)
┌───────────────────────────────────────┐
│ FASE C — Fix + loop                   │
│ Fix → re-Scan (B) → relatório …-rN    │
│ Se DS mudar → mini-A + OK             │
│ até ALIGNED                           │
└───────────────────────────────────────┘
```

### Regras de autorização (obrigatório)

| Transição | Permitido? |
|-----------|------------|
| A → **PARAR** humano | **Sim** — sempre |
| A → B | Só com **OK explícito** do humano na Fase A |
| A → C (Fix) | **PROIBIDO** |
| B → **PARAR** humano | **Sim** — sempre (humano confere se faltou algo no Scan) |
| B → C | Só com **OK explícito** liberando Fix |
| C sem A e B aprovados nesta Apply | **PROIBIDO** |

Frases do humano que **não** pulam B: “aplica”, “pode seguir”, “IKEA” — se ainda não houve OK na A, fazer A; se A ok e B não, fazer B e parar.  
Só “OK A” / “Fase A aprovada” libera B.  
Só “OK B” / “pode Fix” / “autorizo C” libera C.

Se o humano disser de uma vez **“Aprova A e B; pode C / aplica até ALIGNED”** → aí sim encadear, mas **ainda executar B completo com relatório** antes do primeiro patch (não inventar Scan).

---

## Gate inicial

1. Existe `.docs/DESIGN_SYSTEM.md` com `P-…` (senão → Forge)  
2. Humano pediu Apply / IKEA / limpar gosto  

---

## FASE A — Validar e padronizar o DS (gosto)

**Só documento.** URL não obrigatória.

1. Ler DS + `ui-gosto.md` inteiro.  
2. Diff tokens / `P-…` / anti-padrões vs gosto.  
3. Editar `.docs/DESIGN_SYSTEM.md`:
   - Fora do gosto → Apêndice rejeitado (salvo **exceção humana** já confirmada — não reverter)  
   - Reforçar DO (marca Primary, Cadastro deslogado = Primary, admin ≠ cassino, …)  
4. Bloco em `EXTRACTION_NOTES`: **“Normalizado pelo gosto (Fase A)”**.  
5. **PARAR.** Resumo do diff + pedir **OK A**.  
6. Sem OK A → **não** iniciar B nem C.

**Marca > gosto > mock.** Não inventar Primary da marca.

---

## FASE B — Scan do front + relatório (cabo a rabo)

**Só depois do OK A.** Sem patch Lovable.

Método: [VISUAL_QA_METHOD.md](VISUAL_QA_METHOD.md). Template: [report-template.md](report-template.md).

### Princípio

> **Régua = DS + gosto. Crime = preview.**  
> Se existir **review humano** no workspace/chat → checklist obrigatória (VISUAL_QA_METHOD §1.1).  
> DS sozinho **não** detecta espaço vazio, poço, overflow, CTA morto, layout quebrado.

### Obrigatório

0. **Review humano** — se houver `observacoes.md` / prints / clip / bullets no chat: ler inteiro; virar tabela PASS/FAIL no relatório.  
1. **Inventário de alvos** — VISUAL_QA_METHOD §3.0:  
   - bases/URLs/rotas/estados de sessão  
   - **e popups/overlays** (modal, sheet, drawer, dialog, toast bloqueante, welcome, confirm…) — muitos **não** são óbvios na dobra; descobrir por código + gatilhos de UI  
   Listar tudo; scaneado vs Não coberto; dúvida → perguntar.  
2. Abrir cada alvo/overlay escolhido no browser **nesta sessão** (navigate → evidência). **Proibido** inventar Scan.  
3. Desktop + mobile (por alvo principal). Admin/B2B: **~1300×800**.  
4. Roteiro completo (dobra → scroll footer → **cada overlay do inventário** → shell → estados → CDP). **Clicar** affordances (⋯, filtros, paginação) — presença no DOM ≠ PASS.  
5. Caçar: vazio, quebrado, cortado, hit morto — **e voids intra-card** (VISUAL_QA_METHOD §3.3: grid-hole, CTA-spread, meta-baseline).  
6. Relatório **inteiro** (review humano × preview + **prints/círculos do chat** + inventário URL + inventário overlay + P0/P1/P2 + não coberto).  
7. **PARAR.** Path do relatório + resumo. Pedir **OK B**.  
8. Sem OK B → **não** iniciar C.

**Scan inválido:** código-only; só home sem inventário; só auth/depósito “óbvios” ignorando outros overlays descobertos no código; template com `…`; omitir id-preview / deep links / logado / popup sem registrar em Não coberto; PASS em ⋯/menu sem click; ALIGNED com review humano ALTA em FAIL; **PASS “espaços vazios” só medindo vão entre seções**; **ignorar print/círculo do humano**.

---

## FASE C — Fix + loop até ALIGNED

**Só depois do OK B** (autorização de Fix).

### Ciclo do loop

```text
C1. Fix (prioridade impacto) — patch completo, Lovable send_message fechado
C2. Re-Scan **cego** (T1) → cruzamento (T2) → GATE SCAN + novo …-rN.md
    — NÃO ler lista de fixes / relatório anterior durante T1
    — Assumir que TODOS os pontos negativos do review ainda são FAIL até prova browser
C3. Se o re-Scan exigir mudança de lei no DS → mini Fase A + PARAR OK humano → depois continua
C4. Pre-flight anti-slop → **ALIGNED candidato** (VISUAL_QA_METHOD §5.0) ou voltar a C1  
C5. ALIGNED **final** só com OK humano explícito — nunca só porque o pré-flight interno passou
```

No loop C, o humano **já** autorizou Fix; novos relatórios `…-rN` são entregues a cada volta.  
Se surgir **mudança de DS** (mini-A), **PARAR** de novo para OK antes do próximo patch.  
Se o humano pedir “para o loop”, parar.  
Se o review humano ALTA ainda tiver FAIL → **proibido** escrever ALIGNED (mesmo candidato).

### Prioridade de Fix

1. Cor / Primary na ação real  
2. Hover/focus / contraste / par CTA  
3. Layout / nested / spacing / vazio estrutural (**intra-card primeiro**: AP-GRID-HOLE, AP-CTA-SPREAD, AP-META-BASELINE)  
4. Cara de IA / componentes  
5. Empty / loading / error / skeleton  

### Imparcialidade no re-Scan (cego → cruzar)

Detalhe: [VISUAL_QA_METHOD.md](VISUAL_QA_METHOD.md) § Imparcialidade.

| Tempo | O quê |
|-------|--------|
| **T1 cego** | Checklist **negativa** completa (`observacoes` ALTA/MÉDIA + APs + crimes do B). Caçar no browser **como se tudo ainda falhasse**. **Proibido** abrir relatório anterior / EXTRACTION_NOTES de Fix / diff / “já corrigimos X”. |
| **T2 cruzamento** | Só **depois** de T1 escrito: comparar com rodada anterior (sanado / ainda FAIL / regrediu / novo). |

**Proibido:** re-Scan que “valida o patch”; PASS porque o código mudou; pular item porque o rN anterior já tinha PASS.

### Prova social (Apply)

Régua: [`../docs/ui-gosto.md`](../docs/ui-gosto.md) §5.5 (global vs contextual).

| Situação | Ação |
|----------|------|
| Ticker **global** + painel “maiores ganhos” na mesma Home | P1 / FAIL gosto — sanar (escolher **uma** superfície global) |
| Remover ticker global no Fix para ALIGNED | OK |
| Remountar ticker full-bleed sob Header sem mini-A | **Proibido** |
| Humano pede lista de ganhadores **dentro** de card (ex. jackpot) | Mini-A: nomear contextual no DS (sugerido `P-JACKPOT-WINNERS`) → OK → Fix nested; **não** remountar ticker no chrome |
| Strip nested no jackpot + painel Maiores ganhos | **PASS** se não houver ticker global e o DS nomeou o nested (ex. `P-JACKPOT-WINNERS` + `P-WINS`) |

### Pós-ALIGNED / pedido que muda pattern

ALIGNED **não** é licença para patch livre. Se o humano pedir mudança que:

- recoloca componente removido no Fix,
- cria superfície nova (prova social, CTA, faixa, chrome),
- altera interpretação de `P-…` / gosto,

então:

1. **Mini-A** — editar `.docs/DESIGN_SYSTEM.md` (novo `P-…` ou exceção nomeada) + bloco em EXTRACTION_NOTES  
2. **PARAR** → OK humano no diff do DS — **exceto** se a mesma mensagem já disser explicitamente “atualiza o DS e aplica” / “mini-A ok, pode Fix”  
3. Fix + re-Scan `…-rN` — o ALIGNED anterior **quebra** até novo pre-flight PASS  

“Pode continuar” / “faz aí” **sem** nomear mudança de lei → ainda assim mini-A se o pedido conflitar com o gosto §10 ou com um FAIL que o Align sanou.

---

## Checklist rápido (achados)

**P0:** touch/CTA morto; texto cortado; lazy sem skeleton; poço/quebrado bloqueante; **AP-META-BASELINE / AP-CTA-SPREAD em form crítico**  
**P1:** `P-…` / Cadastro não-Primary; nested; AI tell; spacing; par CTA; **AP-GRID-HOLE**  
**P2:** logos; densidades; chrome duplicado  

**Fora de escopo:** badge host Lovable — anotar, não corrigir.

## O que NÃO fazer

- Extrair DS do zero (Forge)  
- **Pular B** e ir de A para C  
- **Fix sem OK B**  
- Scan incompleto ou relatório pela metade  
- **Inventar Scan** / ALIGNED sem abrir a URL no browser nesta sessão  
- Ignorar `observacoes.md` / review humano / prints quando existirem  
- Marcar ⋯ / menu / CTA como PASS sem clicar (affordance morta)  
- Declarar **ALIGNED** com itens ALTA do review humano ainda FAIL, ou com rotas do review em “Não coberto”  
- Declarar ALIGNED final só com pré-flight interno (falta OK humano §5.0)  
- Abrir **só** a home publicada e ignorar outras bases/rotas **sem** inventário + Não coberto  
- Inventariar só overlays “óbvios” (login/checkout) e **calar** welcome / confirm / busca / notify / bonus / orphan components  
- “Diagnose” só pelo DS/código  
- **Marcar “espaços vazios” PASS** só com gap entre seções (sem caça §3.3 intra-card)  
- **Ignorar círculo/print** do humano no chat  
- **Re-Scan manipulado**: ler Fix/relatório anterior **antes** de caçar; “validar o patch”; pular ALTA porque o rN anterior já era PASS  
- Reverter exceção humana sem perguntar  
- Remountar ticker/prova social **global** após Align sem mini-A (ver § Prova social)  
- Contar strip **nested** em card como FAIL de “duplicata global” sem checar ui-gosto §5.5  
- Patch pós-ALIGNED que muda pattern **sem** mini-A / OK  
- Fundir com `qa-space` / AP-FE  
- Output incompleto / placeholders  
