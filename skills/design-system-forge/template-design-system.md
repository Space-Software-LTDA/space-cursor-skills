# Template — Design System (wireframe industrial)

> Copiar para `.docs/DESIGN_SYSTEM.md` do produto e **preencher**.  
> Cada regra: **Valor · Uso · Porquê psicológico · Fonte**.  
> Não deixar seção vazia: marcar `TBD` / `N/A escopo` + por que falta.  
> **Proibido** colapsar §6–8 em um único bullet.  
> **Gravação:** sempre sob `.docs/`.  
> Skill: GATE ACCEPT (mínimo big-tech) antes do STOP humano.

---

## 0. Meta

| Campo | Valor |
|-------|-------|
| Produto | |
| Contexto (B2B / B2C / híbrido) | |
| Fonte visual (URL / Lovable id) | |
| DS de gosto/método | |
| Versão | 0.1.0-draft |
| Tokens DTCG path | `.docs/tokens.dtcg.json` |

### Prioridade de verdade

1. Decisões humanas / escopo  
2. Código/tokens do produto  
3. DS de referência (método)  
4. Mock (hierarquia/campos — não ruído como lei)

---

## 1. Filosofia

### Deve parecer
### Não deve parecer
### Princípios (com porquê)

---

## 2. Fundamentos psicológicos

| Lei (Laws of UX) | Decisão neste produto |
|------------------|------------------------|
| Aesthetic-Usability | |
| Jakob | |
| Hick / Choice Overload | |
| Fitts | |
| Proximity / Common Region / Similarity | |
| Von Restorff | |
| Peak-End / Goal-Gradient | |
| Zeigarnik | |
| Doherty | |
| Cognitive Load / Miller / Chunking | |
| Tesler / Mental Model / Postel | |

---

## 3. Cores (F1)

### Brand
| Token | Hex | OKLCH | Uso |
|-------|-----|-------|-----|
| primary | | | |
| primary-foreground | | | |

### Surfaces (hex **cada** degrau)
| Token | Hex | Uso |
|-------|-----|-----|
| background | | |
| surface | | |
| card | | |
| surface-2 | | |
| surface-3 | | |
| muted | | |
| modal | | |

### Texto / border
| Token | Hex | Uso |
|-------|-----|-----|
| foreground | | |
| muted-foreground | | |
| border | | |

### Feedback (warning **obrigatório** — inferir se ausente no CSS)
> Warning **≠** CTA. Hue deve ser distinto do Primary (se ∆hue pequeno → perguntar ou afastar).

| Token | Hex | Uso |
|-------|-----|-----|
| success | | |
| warning | | |
| destructive | | |
| live (se produto) | | |

### Do / Don’t · regra de aninhamento

---

## 4. Tipografia (F2)

Família(s) · máx pesos · proibições

| Papel | Size | Weight | Line-height | Tracking | Uso | Porquê |
|-------|------|--------|-------------|----------|-----|--------|
| Display | | | | | | |
| H1 | | | | | | |
| H2 | | | | | | |
| H3 | | | | | | |
| Body | | | | | | |
| Label | | | | | | |
| Caption | | | | | | |
| Ribbon | | | | | | |
| Money (se B2C) | | | | | tabular-nums | |

---

## 5. Radius (F5)

| Token | px | Uso |
|-------|----|-----|
| sm | | |
| md | | |
| lg | | |
| xl | | |
| full (só onde permitido) | | |

Proibições:

---

## 6. Spacing / grid / breakpoints / proporção (F3 + F4)

### Escala primitiva
`4 · 8 · 12 · 16 · 24 · 32 · 48 · 64` px — off-scale **proibido** no mapa semântico.

### Mapa semântico (só valores da escala)
| Contexto | Padding / gap | Token |
|----------|---------------|-------|
| Page | | |
| Section | | |
| Card | | |
| Control | | |
| Chip | | |

### Exceções nomeadas (se inevitável)
| Token | px | Porquê | Fonte |
|-------|-----|--------|-------|
| | | | |

> Medido off-scale na fonte → **normalizar** ao degrau mais próximo **ou** preencher Exceções.  
> **Fail:** “off-scale proibido” + 28/14/… como lei sem esta tabela.

### Breakpoints
> 1º os que o **produto usa**. Se não houver evidência → Tailwind default.

| Token | px | O que muda neste breakpoint |
|-------|-----|------------------------------|
| sm | 640 (default) | |
| md | 768 | |
| lg | 1024 | |
| xl | 1280 | |
| 2xl | 1536 | |

### Proporções de domínio
| Elemento | Ratio / split | Uso |
|----------|---------------|-----|
| Tile / card mídia | | |
| Hero / promo | | |
| Auth split | | |
| Outros | | |

---

## 7. Bordas / elevation / motion (F6 + F7)

### Border
Valor · onde · proibições

### Elevation
| Token | Valor | Uso |
|-------|-------|-----|
| shadow-card | | |
| (outros) | | |

**Proibido:** glow / multi-shadow colorido / neon

### Motion
| Token | ms / easing | Uso |
|-------|-------------|-----|
| instant | | |
| fast | | |
| base | | |
| slow | | |

`prefers-reduced-motion`:

---

## 8. Ícones (F8)

| Campo | Valor |
|-------|-------|
| Família | (uma — não misturar packs) |
| Stroke | |
| Sizes | 16 / 20 / 24 — onde cada |
| Default / muted / active / disabled | |
| Touch ícone-only | ≥ 44 |
| Proibido | emoji como ícone de sistema; segundo pack |

---

## 9. Componentes

Para **cada** um: anatomia · variants · **states** (default / hover / focus / active / disabled / loading) · specs · a11y · do/don’t · porquê

- [ ] Button
- [ ] Input / Select
- [ ] Badge / Ribbon
- [ ] Card / Tile de domínio
- [ ] Dialog / Sheet / Drawer
- [ ] Header / Nav / Sidebar / BottomNav / Footer
- [ ] Outros do inventário

*(Tabela de uma linha sem states = incompleto / GATE ACCEPT fail.)*

---

## 10. Patterns de tela (`P-…`)

> **Obrigatório.** O que não tem padrão está **errado** ou o padrão **ainda precisa ser definido**.  
> Fonte visual = evidência, **não** lei. Errado no mock → Apêndice A.

### 10.0 Decision tree (sempre)

```text
COLLECTION → TABLE | CARDS | + SPLIT?
CLICK → DETAIL PAGE | DRAWER | SPLIT
CREATE/EDIT → MODAL | DRAWER | PAGE | INLINE | (nunca cell edit)
DELETE → MODAL confirm
```

### 10.1 Application — Collection (A)

> Preencher **sempre** como lei pretendida (mesmo sem admin na fonte). `N/A` só se o humano vetar o ID.

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-COL-TABLE | | | pretendido / extraído / humano |
| P-COL-FILTER | | | |
| P-COL-BULK | | | |
| P-COL-EMPTY | | | |
| P-COL-PAGINATION | | | |

### 10.2 Application — Object (B)

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-OBJ-OPEN | Clique na linha/card abre… | | |
| P-OBJ-DETAIL | Anatomia da página de detalhe | | |
| P-OBJ-SPLIT | Split ≠ substituto de detail | | |

### 10.3 Application — CRUD (C)

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-CRUD-CREATE | | | |
| P-CRUD-EDIT | | | |
| P-CRUD-INLINE | Só 1 campo no detail | form na célula | |
| P-CRUD-DELETE | Modal confirm critical | delete sem confirm | |
| P-CRUD-FEEDBACK | | | |

### 10.4 Application — Surface (D)

| ID | Quando usar | Quando não |
|----|-------------|------------|
| P-SURF-PAGE | | |
| P-SURF-DRAWER | | |
| P-SURF-MODAL | | |
| P-SURF-SHEET | | |
| P-SURF-SPLIT | | |

### 10.5 Domínio / player (E)

Preencher só o que o produto tiver. Quando houver **prova social**, preferir IDs estáveis (global ≠ contextual — [ui-gosto.md](../../docs/ui-gosto.md) §5.5):

| ID | Spec | Anti-padrão |
|----|------|-------------|
| P-WINS | Prova social **global**: painel “maiores ganhos” / ranking (uma superfície) | Segunda faixa global competindo; ticker **e** painel |
| P-TICKER | (Opcional) Ticker global — **só** se for a única superfície global escolhida | Remountar após Align que removeu duplicata |
| P-JACKPOT | Card/bloco jackpot (valor + hierarquia) | Glow/teatro; valor ilegível no mobile |
| P-JACKPOT-WINNERS | Lista nested **dentro** do jackpot (prova social **contextual**) | Tratar como 2ª global; remountar ticker no chrome |
| P-… | (outros do domínio) | |

> `P-WINS` / `P-JACKPOT-WINNERS` são **convenção sugerida** quando o domínio tiver esses papéis — não inventar os dois se o produto não tiver jackpot/ranking.

### 10.6 Operação (F)

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-NAV-IA | | | |
| P-FORM-LAYOUT | | | |
| P-FORM-SAVE | | | |
| P-STATUS-BADGE | | | |
| P-PERMISSION | | | |
| P-DANGER-ZONE | | | |
| P-TOAST | | | |

### Rotas v1
Listar rotas/fluxos referenciando IDs.

### Decisões com o humano (Forge)

| Tema | Pergunta | Decisão | Data |
|------|----------|---------|------|
| | | | |

---

## 11. Mobile

Touch ≥ 44 · sheet vs dialog · densidades · breakpoints que afetam shell

---

## 12. Estados

Loading · Empty · Error · Disabled — por superfície crítica

---

## 13. Acessibilidade

Contraste AA · focus ring · labels · `prefers-reduced-motion` · não só cor para status

---

## 14. Anti-padrões IA

| Proibido | Preferir |
|----------|----------|
| | |

---

## 15. Checklist de aceite

Espelhar GATE ACCEPT (F1–F8 · componentes · P-… · a11y). Itens binários.

---

## Apêndice A — Extraído / Normalizado / Rejeitado

| Item | Extraído | Normalizado | Rejeitado |
|------|----------|-------------|-----------|

## Apêndice B — tokens.dtcg.json

Link para `.docs/tokens.dtcg.json` — deve incluir: `color` · `typography` · `space` · `radius` · `breakpoint` · `icon.size` · `motion` · **`elevation`/`shadow` (fora de motion)**

## Versionamento

| Versão | Data | Notas |
|--------|------|-------|
