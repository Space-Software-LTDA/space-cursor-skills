---
name: design-system-apply
description: >-
  Limpa o Design System do produto pelo gosto Space (Miguel) e aplica no front (Lovable):
  Fase A altera .docs/DESIGN_SYSTEM.md (remove fora-do-gosto); Fase B Scan→Diagnose→Fix até
  ALIGNED. Gate: DS forjado com P-…. Visual only — sem AP-FE/qa-space. Use com
  /design-system-apply, "IKEA", "aplicar DS", "limpar gosto", refator UI.
disable-model-invocation: true
---

# Design System Apply / IKEA

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/design-system-apply/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo). Sem Sync a copia nao atualiza.  
> Ver `00-COPIA-LEIA-ME.md`. Hub pack: **`/skill-update`**. Fluxo repo: **`AGENTS.md`**.

**Trigger:** `/design-system-apply` · “IKEA” · “aplicar DS” · “limpar gosto”  
**Idioma:** português.  
**Par:** Forge = `design-system-forge` (CORE bruto). Esta skill **normaliza o DS** e **implementa**.

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
| Relatório Fase B | `.docs/design-system-forge/QA_REPORTS/YYYY-MM-DD-<slug>[-rN].md` |

Nunca sobrescrever relatório — sempre `…-rN.md`.

## Constituição (obrigatório)

1. [`../docs/README.md`](../docs/README.md) — seção `design-system-apply`  
2. `.docs/DESIGN_SYSTEM.md` do produto  
3. [`../docs/ui-gosto.md`](../docs/ui-gosto.md) **inteiro**  
4. [`../docs/design-system.md`](../docs/design-system.md) — apoio (admin/escalas); **marca do produto manda**  
5. [VISUAL_QA_METHOD.md](VISUAL_QA_METHOD.md) · [report-template.md](report-template.md) · [reference-anti-slop.md](reference-anti-slop.md)

**Não** é `qa-space`. Visual only.

## Propósito

```text
Forge → DS bruto
Apply Fase A → limpar DS vs ui-gosto (editar .docs/)
OK humano
Apply Fase B → Scan → Diagnose → Fix no front → ALIGNED
```

## Gate

1. Existe `.docs/DESIGN_SYSTEM.md` com catálogo `P-…` (senão → Forge)  
2. Humano pediu Apply (ou “limpa o DS / aplica gosto”)

Aprovação **após Fase A** é obrigatória antes de patch no front (exceto se humano já disse “aplica até limpar” incluindo DS+front nesta sessão).

---

## Fase A — Normalizar o DS (documento)

**Antes de tocar no Lovable.**

1. Ler DS do produto + `ui-gosto.md`.  
2. Diff cada token / `P-…` / anti-padrão vs gosto.  
3. **Editar** `.docs/DESIGN_SYSTEM.md`:
   - Remover ou rebaixar leis **fora do gosto** → Apêndice rejeitado  
   - Reforçar DO (marca Primary, Cadastro deslogado = Primary sólido, admin ≠ cassino, etc.)  
   - Ex.: `P-CHROME-*` com Cadastro outline deslogado → **corrigir** para Primary da marca (salvo humano insistir na exceção)  
4. Atualizar `EXTRACTION_NOTES.md` com bloco **“Normalizado pelo gosto (Fase A)”** (o que saiu / o que entrou).  
5. **PARAR** — mostrar resumo do diff do DS ao humano.  
6. Só com OK → Fase B (ou parar em doc-only).

**Não inventar** Primary da marca. Marca > gosto > mock.

---

## Fase B — Front (Scan → Diagnose → Fix)

Método inspirado em [Taste redesign](https://github.com/Leonxlnx/taste-skill) — **sem** copiar estética anti-Inter/Lucide.

### B1 Scan

URL/alvo, desktop+mobile, overlays do escopo, stack visual (Lovable).

### B2 Diagnose

Listar achados vs:

- DS **já limpo** (`P-…`)  
- Checklist PASS/FAIL de `ui-gosto.md`  
- AI tells Space-compatible ([reference-anti-slop.md](reference-anti-slop.md))  

Gravar relatório (template).

### B3 Fix (opt-in)

Prioridade de impacto:

1. Cor / accents / Primary na ação real  
2. Hover/focus / contraste CTA  
3. Layout / nested / spacing  
4. Componentes genéricos / cara de IA  
5. Empty / loading / error / skeleton  

Patch **completo** (sem `// ...`). Lovable: `send_message` com instruções fechadas.

### B4 Re-QA imparcial + pre-flight

Novo `…-rN.md`. Avaliador **sem** lista de fixes.  
Pre-flight (reference-anti-slop) → ALIGNED ou voltar ao B3.

### Modos

| Modo | Comportamento |
|------|----------------|
| **doc-only** | Fase A e/ou Diagnose sem patch front |
| **doc+apply** | Após OK: Fix → re-QA → loop |

---

## Checklist rápido (Fase B)

**P0:** touch morto; CTA morto; texto cortado; lazy sem skeleton; badge clipado  
**P1:** `P-…` violado; Cadastro deslogado não-Primary; nested errado; AI tell  
**P2:** logos irregulares; densidades; chrome duplicado  

**Fora de escopo:** badge host Lovable — anotar, não “corrigir”.

## O que NÃO fazer

- Extrair DS do zero (Forge)  
- Pular Fase A e “só embelezar” o front  
- Inventar padrão / Primary da marca  
- Aplicar front sem documentar  
- Output incompleto / placeholders  
- Fundir com `qa-space` / AP-FE  
- Instalar Taste Skill como gosto oficial  
