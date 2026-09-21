# Método de QA visual — Apply (pós–Forge + gosto)

> Usado por `design-system-apply`. Casos reais ficam no `.docs/` do workspace.  
> Gosto: `../docs/ui-gosto.md`. Anti-slop: [reference-anti-slop.md](reference-anti-slop.md).

---

## 0. Duas fases

| Fase | O quê | Output |
|------|--------|--------|
| **A** | Normalizar DS vs ui-gosto | `.docs/DESIGN_SYSTEM.md` + EXTRACTION_NOTES |
| **B** | Scan → Diagnose → Fix front | `QA_REPORTS/…[-rN].md` |

Sem Fase A (DS ainda com leis fora do gosto), o Fix no front **replica o erro**.

---

## 1. Três cestas (Fase B)

### Bugs (P0)
Impede ação / render inequívoco: touch morto, CTA morto, corte de texto, lazy sem skeleton.

### Lacunas (P1)
Viola `P-…` do DS limpo ou gosto (ex. Cadastro deslogado não-Primary; nested; AI tell).

### Agonias (P2)
Polish: logos, densidades, chrome duplicado.

**Fora de escopo:** watermark do host.

---

## 2. Procedimento Fase B

### Setup
URL acessível; desktop + mobile; DS **limpo** aberto; ui-gosto checklist §10.

### Passos
```text
A. Superfície principal (dobra)
B. Scroll / seções
C. Overlays do escopo
D. Mobile shell (Primary na ação real se deslogado)
E. CDP se screenshot ambíguo
F. Classificar → documentar → (opt-in) fix → re-QA imparcial → pre-flight
```

### Prioridade de fix
1. Cor / Primary na ação real  
2. Hover/focus / contraste  
3. Layout / nested / spacing  
4. Cara de IA / componentes  
5. Estados empty/loading/error  

### Imparcialidade
Re-QA sem lista de fixes — só URL + DS limpo + este método + ui-gosto.

---

## 3. Output

| Artefato | Path |
|----------|------|
| Relatório | `.docs/design-system-forge/QA_REPORTS/YYYY-MM-DD-<slug>[-rN].md` |
| Índice | `QA_REPORTS/README.md` |
| Notes | EXTRACTION_NOTES (link + bloco Fase A) |

Template: [report-template.md](report-template.md).

---

## 4. Loop

```text
1. Fase A (se ainda não) + OK humano
2. Scan / Diagnose → relatório
3. Perguntar se aplica Fix
4. Fix completo → re-QA → …-rN
5. Pre-flight → ALIGNED ou passo 3
```
