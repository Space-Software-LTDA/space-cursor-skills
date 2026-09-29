# Template — Design System (wireframe industrial)

> Copiar para `.docs/DESIGN_SYSTEM.md` do produto e **preencher**.  
> Cada regra: **Valor · Uso · Porquê psicológico · Fonte**.  
> Não deixar seção vazia: marcar `TBD` / `N/A escopo` + por que falta.  
> **Proibido** colapsar §6–8 em um único bullet.  
> **Gravação:** sempre sob `.docs/`. Peças visuais no canvas do produto.  
> Ordem dos fundamentos = capítulos 01–05 do deck de referência (ver `roteiro.md` passo 9).  
> Skill: GATE ACCEPT (mínimo big-tech) + confronto com o gosto antes do STOP humano.

---

## 0. Meta

| Campo | Valor |
|-------|-------|
| Produto | |
| Contexto (B2B / B2C / híbrido) | |
| Tipo de produto (ui-gosto §11) | |
| Modo (Extrair / Criar) | |
| Fonte (site / construtor / canvas / código / manual / protótipo) | |
| Manual da marca (oficial / provisório) | |
| Arquivo de canvas | |
| DS de gosto/método | ui-gosto (geral + tipo) · Space DS |
| Nível entregue (essencial / ouro) | |
| Versão | 0.1.0-draft |
| Estado do documento | fechado até o momento (canvas e telas podem reabrir com nova versão) |
| Tokens DTCG path | `.docs/tokens.dtcg.json` |

### Prioridade de verdade

1. Decisões humanas / escopo  
2. Marca do produto (manual)  
3. Código/tokens do produto  
4. Gosto + DS de referência (método)  
5. Fonte visual (hierarquia/campos — não ruído como lei)

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
| info | | |
| live (se o produto tiver) | | |

### Contraste
> 4,5:1 texto normal · 3:1 texto grande (≥ 24 px ou 18,5 px negrito), bordas de campo, ícones de uso e anel de foco. Medir em **cada tema** com valores definidos.

| Combinação (frente / fundo) | Razão | Regra | PASS/FAIL |
|-----------------------------|-------|-------|-----------|
| | | | |

### Dois temas
Mesmos papéis, valores dark e claro. No claro, cor de texto e ícone numa versão mais escura da mesma cor.

### Do / Don’t · regra de aninhamento

---

## 4. Tipografia (F2)

Família(s) · máx pesos · proibições

| Papel | Size computador | Size celular | Weight | Line-height | Tracking | Uso | Porquê |
|-------|-----------------|--------------|--------|-------------|----------|-----|--------|
| Display | | | | | | | |
| H1 | | | | | | | |
| H2 | | | | | | | |
| H3 | | | | | | | |
| Body | | | | | | | |
| Label | | | | | | | |
| Caption | | | | | | | |
| Ribbon / overline | | | | | | | |
| Número / valor (se o produto mostrar) | | | | | tabular-nums | | |

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

### Grid e margens por ponto de quebra
> Computador **e** celular, nunca só um. Conferido na primeira tela-prova (Apply).

| Ponto de quebra | Tela de referência | Largura do conteúdo | Margem lateral | Colunas por tipo de conteúdo | Espaço entre colunas | Respiro de seção |
|-----------------|--------------------|---------------------|----------------|------------------------------|----------------------|------------------|
| Celular | | | | | | |
| Computador | | | | | | |

### Medidas fixas nomeadas
| Nome | px | Uso |
|------|-----|-----|
| Altura de botão | | |
| Área de toque | 44 | |
| Janela fixa (popup, modal) | | |

### Proporções de domínio
| Elemento | Ratio / split | Uso |
|----------|---------------|-----|
| Card do item principal / mídia | | |
| Hero / promo | | |
| Auth split | | |
| Outros | | |

Mídia (banner, capa, arte): **uma proporção por família**, em `aspect-ratio` com a largura do container (nunca largura fixa) · conferida nos **arquivos originais** · área segura (~80% do meio) · tamanho de exportação da arte · onde cada lugar usa a família (largura × altura) · arquivos fora do padrão com tamanho de reexportação. Mídias irmãs (ex.: arte de overlays irmãos) = mesma proporção e mesmo tamanho.

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

### 9.1 Lista fechada por faixa
> Base: `catalogo-componentes.md` da skill. Faixa 1 entra inteira (13 grupos); Faixa 2 só com “sim + tela”; Faixa 3 só com tela que exija; Faixa D com eco → confirma.

| Componente | Faixa (1 / 2 / 3 / D) | Variações | Tela onde aparece | Prancha no canvas |
|------------|-----------------------|-----------|-------------------|-------------------|
| | | | | |

**Proibidos por enquanto:** (lista)

### 9.2 Matriz de estados
> Definida **antes** de desenhar. Nenhuma célula em branco (“não se aplica” vale).

| Componente | Normal | Passar o mouse | Foco | Pressionado | Desabilitado | Carregando | Erro |
|------------|--------|----------------|------|-------------|--------------|------------|------|
| | | | | | | | |

**Estados de tela:** vazio · carregando (esqueleto no formato do conteúdo) · erro · falha parcial · sem permissão / sem saldo · sem resultado — por superfície crítica.

### 9.3 Especificação por componente
Para **cada** um: anatomia · variants · **states** (da matriz) · specs · a11y · do/don’t · porquê

- [ ] Button
- [ ] Input / Select
- [ ] Badge / Chip
- [ ] Card de conteúdo / Card de domínio
- [ ] Dialog / Sheet / Drawer
- [ ] Header / Nav / Sidebar / BottomNav / Footer
- [ ] Outros da lista 9.1

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

### 10.5 Domínio (E)

Preencher só o que o produto tiver: telas próprias, card do item principal, peças da Faixa D, chrome, auth, pagamento. Nome só depois de eco → confirma.

| ID | Spec | Anti-padrão | Fonte |
|----|------|-------------|-------|
| P-… | | | |

> Se o **tipo de produto** tiver seção no `ui-gosto.md` §11 (ex.: cassino §11.1, admin §11.2), usar os IDs sugeridos ali. Não inventar IDs de um tipo em produto de outro tipo.

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

Touch ≥ 44 · sheet vs dialog · densidades · margem e grade do celular (§6) · breakpoints que afetam shell

---

## 12. Estados

Loading · Empty · Error · Disabled — por superfície crítica

---

## 13. Acessibilidade

Contraste 4,5:1 texto normal e 3:1 texto grande / bordas de campo / ícones de uso / foco (§3) · focus ring · labels · `prefers-reduced-motion` · não só cor para status

---

## 14. Anti-padrões IA

| Proibido | Preferir |
|----------|----------|
| | |

---

## 15. Checklist de aceite

Espelhar GATE ACCEPT (F1–F8 · lista fechada + matriz · P-… · a11y · canvas · confronto com o gosto). Itens binários.

---

## 16. Canvas — Oficial × Draft × Rascunho

| Prancha | Tema | Status (oficial / draft / rascunho) | Observação |
|---------|------|-------------------------------------|------------|
| Manual da marca | — | | |
| Fundamentos | tema principal | | |
| Componentes essenciais (genéricos → domínio) | tema principal | | |
| Draft (lista fechada ainda não validada/usada) | tema principal | | |
| Rascunho (explorações, opções, versões antigas) | | | |
| Telas (fileiras por fluxo, rótulo “Seção · …”) | | | |
| Fundamentos / Componentes (segundo tema — ouro) | | | |

Regras: variáveis em todas as peças oficiais · oficial não depende de Draft nem de Rascunho · peça sai do Draft quando o humano valida (movida para a seção existente, com a matriz) · zero componente com nome repetido · nada apagado.

## 17. Confronto com o gosto

| Checklist (ui-gosto §10 + §11 do tipo) | Resultado | Exceção nomeada / motivo |
|-----------------------------------------|-----------|--------------------------|
| | | |

Seções de outros tipos: “não se aplica” + motivo.

---

## Apêndice A — Extraído / Normalizado / Rejeitado

| Item | Extraído | Normalizado | Rejeitado |
|------|----------|-------------|-----------|

## Apêndice B — tokens.dtcg.json

Link para `.docs/tokens.dtcg.json` — deve incluir: `color` · `typography` · `space` · `radius` · `breakpoint` · `icon.size` · `motion` · **`elevation`/`shadow` (fora de motion)**

## Versionamento

> Documento **fechado até o momento**: cada mudança vinda do canvas ou das telas entra aqui com versão e motivo.

| Versão | Data | Notas (o que mudou e por quê) |
|--------|------|-------------------------------|
