# Template — Design System (wireframe industrial)

> Copiar para `.docs/DESIGN_SYSTEM.md` do produto e **preencher**.  
> Cada regra: **Valor · Uso · Porquê psicológico · Fonte**.  
> Não deixar seção vazia: marcar `TBD` + por que falta.  
> **Gravação:** sempre sob `.docs/` (DS, tokens, notes).

---

## 0. Meta

| Campo | Valor |
|-------|-------|
| Produto | |
| Contexto (B2B / B2C / híbrido) | |
| Fonte visual (URL / Lovable id) | |
| DS de gosto/método | |
| Versão | 0.1.0-draft |
| Tokens DTCG path | |

### Prioridade de verdade

1. Código/tokens do produto  
2. Escopo/task  
3. DS de referência (método)  
4. Mock (hierarquia/campos)

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

## 3. Cores

### Primary / Surface (hex + oklch se houver)
### Escala Background → Modal
### Texto
### Feedback (success / warning / destructive)
### Do / Don’t

---

## 4. Tipografia

| Papel | Size | Weight | Uso | Porquê |
|-------|------|--------|-----|--------|
| Display | | | | |
| H1–H3 | | | | |
| Body / Label / Caption / Ribbon | | | | |

Fonte · máx pesos · proibições

---

## 5. Radius

| Token | px | Uso |
|-------|----|-----|
| sm | | |
| lg (controle) | | |
| xl (modal) | | |
| hero | | |

---

## 6. Spacing / grid / breakpoints

Escala: `4 · 8 · 12 · 16 · 24 · 32 · 48 · 64`  
Tabela padding por contexto · breakpoints

---

## 7. Bordas / elevation / motion

Permitido · proibido · durações

---

## 8. Ícones

Família · sizes · ativo

---

## 9. Componentes

Para cada um: anatomia · variants · states · specs · a11y · do/don’t · porquê

- [ ] Button
- [ ] Input / Select
- [ ] Badge / Ribbon
- [ ] Card / Tile específico do domínio
- [ ] Dialog / Sheet
- [ ] Header / Nav / Footer / BottomNav
- [ ] Outros do inventário

---

## 10. Patterns de tela

> **Obrigatório:** catálogo com IDs (`P-…`), spec canônica e anti-padrão.  
> Lei: o que não tem padrão está **errado** ou o padrão **ainda precisa ser definido**.  
> A fonte visual é evidência — **não** lei. O que estava errado no mock vai ao Apêndice A (rejeitado), não a esta tabela.

| ID | Padrão | Spec | Anti-padrão |
|----|--------|------|-------------|
| P-… | | | |

Depois: wireframes/rotas (Home, Auth, Checkout, …) referenciando os IDs.

### Decisões com o humano (Forge)

| Tema | Pergunta | Decisão | Data |
|------|----------|---------|------|
| | | | |

Registrar também em `.docs/design-system-forge/EXTRACTION_NOTES.md`.

---

## 11. Mobile

Touch 44 · sheet vs dialog · densidades

---

## 12. Estados

Loading · Empty · Error · Disabled

---

## 13. Acessibilidade

Contraste · focus · reduced motion · labels

---

## 14. Anti-padrões IA

Tabela proibido → preferir

---

## 15. Checklist de aceite

Espelhar § do DS preenchido

---

## Apêndice A — Extraído / Normalizado / Rejeitado

| Item | Extraído | Normalizado | Rejeitado |
|------|----------|-------------|-----------|

## Apêndice B — tokens.dtcg.json

Link / gerar arquivo irmão

## Versionamento

| Versão | Data | Notas |
