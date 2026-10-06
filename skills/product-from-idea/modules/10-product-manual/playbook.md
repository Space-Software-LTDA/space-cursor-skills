# Playbook — Fase 10 Manual comercial

> Saída viva: `docs/{slug}.md`  
> Bar: [`target-model.md`](target-model.md) · density: [`examples/density-reference.md`](examples/density-reference.md)

**Agent:** [`AGENT.md`](AGENT.md)

## Header

```text
**Fase 10 — Manual comercial do produto**
**Objetivo:** um doc completo que conta a história e reúne as fases — tom comercial
**ON:** F1 + F2 + F7 (+ F6)
**Arquivo:** docs/{slug}.md  (slug = nome do produto)
```

## Pré-requisitos

- Revisão (9) **fechada** ou **adiada com risco** (buracos listados — entram no manual)  
- Fases 1–8 existem (mesmo com ressalvas) — as telas aprovadas (`telas.md`) são a referência da jornada e das imagens  
- Nome de trabalho fechado (discovery) → define `{slug}`

## Sequência

### 0) Fixar slug + audiências

| Campo | Regra |
|-------|--------|
| Slug | minúsculas, sem acento (`Meu Produto` → `meu-produto`) |
| Path | `docs/{slug}.md` |
| Público A | Quem **usa** (usuário final) |
| Público B | Quem **decide / vende / investe** |

### 1) Abrir exemplos reais

Abrir [`examples/density-reference.md`](examples/density-reference.md) + ≥1 **arquivo real**:

| Anexo | Roubar |
|-------|--------|
| `airbnb-pitch-deck.pdf` | História comercial completa (problem→product→model) |
| `stripe-2021-update.pdf` | Prosa comercial longa |
| `shape-up.pdf` | Clareza ao explicar produto |
| `apple-airpods-pro.html` | Tom usuário (highlights → depth) |
| `stripe-payments.html` / `linear-homepage.html` | Página produto / sistema em capítulos |

**Proibido:** tratar markdown-resumo como anexo.

### 2) Ler todas as fases (síntese, não cola)

Ordem: discovery → mercado → proto → MVP → contrato → setup → DS → revisao.  
Extrair fatos **Confirmados**; Hipótese só se rotulada; Aberto/adiado → seção **Pendências** / **Riscos conhecidos** (português claro).  
A expansão futura (lista do `mvp.md` e telas do futuro) pode aparecer no manual, sempre separada: “no lançamento” × “no futuro”.

### 3) Escrever o manual (template)

Copiar `templates/manual-produto.md` → `docs/{slug}.md` e preencher **inteiro**.  
Cada parte: história contínua + tabelas quando ajudam.  
**Obrigatório:** passar no teste do estranho (`shared/docs-clarity.md`) — zero meta de chat, zero `qtd.`/`TBD`, títulos humanos.

### 4) Decisão (Uso interno)

| Resultado | Significado |
|-----------|-------------|
| **fechado** | Manual cobre tudo; pronto pra Fase 11 (tasks) |
| **adiado com risco** | Pendências listadas no próprio manual + cliente assume |
| **bloqueado** | Falta nome/slug ou fases críticas vazias |

Gravar só na seção **Uso interno** — não no cabeçalho comercial. Atualizar `docs/README.md`. Subagente **encerra**.

## Fora de escopo

| Pedido | Para |
|--------|------|
| Brief interno curto | `docs/produto.md` (já existe / vago) |
| Task ClickUp | Fase 11 · `po-techlead-scrum` |
| Inventar preço/hex | Cliente / fase certa |
