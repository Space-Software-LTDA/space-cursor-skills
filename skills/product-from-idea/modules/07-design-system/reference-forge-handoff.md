# Fase 7 ↔ design-system-forge (passagem de bastão genérica)

> **100% genérico.** Como a fase de produto usa o Forge — sem nome de cliente/produto.

## Papéis

| Papel | Faz |
|-------|-----|
| **Controlador** | Confirma fonte + superfícies; abre o Forge; valida o veredito + gate de fase; **não** escreve o DS |
| **Subagente Fase 7** | Roda o loop Forge; grava `docs/`; emite STOP; **encerra** |
| **Skill `design-system-forge`** | Barra (GATE 0, Q, ACCEPT, template, Laws of UX) |
| **`design-system-apply`** | **Fase 8 (Telas)** — subagente novo, depois do gate da Fase 7; não roda dentro da Fase 7 |
| **`qa-space`** | Audita front **feito** — não forja DS |

## Artefatos (sempre sob `docs/`)

```text
docs/DESIGN_SYSTEM.md
docs/tokens.dtcg.json
docs/design-system-forge/EXTRACTION_NOTES.md
```

## Entradas que o product-from-idea deve passar ao Forge

| Entrada | De onde |
|---------|---------|
| Superfícies (frontend / extension / …) | `docs/setup.md` |
| Telas e fluxos com nome humano | `docs/prototipo.md` |
| Corte MVP (o que existe no dia 1) | `docs/mvp.md` |
| Tom / persona (contexto B2C etc.) | `docs/discovery.md` / brief |
| Fonte visual | Cliente: URL, construtor (ex.: Lovable), prints, código, canvas, manual da marca |

## GATE 0 — checklist rápida (fase)

| Nível | Pode DS final? |
|-------|----------------|
| **F** | Não — pedir fonte |
| **D** | Só rascunho se humano autorizar |
| **C+** | Sim, com Qs |

## STOP → gate de fase

| Forge STOP | Gate típico da fase |
|------------|---------------------|
| PASS | **fechado** (dívida Apply ≠ ressalva) |
| PASS COM RESSALVAS | **fechado** só se humano fechar Qs ou **adiado com risco** listando Qs |
| REPROVADO | **bloqueado** até corrigir |

## Superfícies (lei de cobertura)

Se o setup listou a peça, o DS **não pode silenciar** o canal:

| Peça setup | Obrigatório no DS |
|------------|-------------------|
| `…-frontend` | Chrome + páginas + overlays do proto |
| `…-extension` | UI extensão (popup/sidepanel/options); tipografia/contraste; estados |
| Ambos com mesma auth | Padrão de auth coerente (sheet/modal) |

Detalhe de scraper/seletores **não** é DS — é task.

## O que a fase 7 NÃO redefine

| Já fechado em | Não reabrir no Forge |
|---------------|----------------------|
| Setup | Nomes de repo, boilerplate, TS+webpack |
| Contrato | Quem calcula o quê (servidor vs extensão) |
| MVP | Preço de crédito, lista de lojas |

Visual **pode** orientar ícone/selo de domínio via `P-…` — com eco+confirma se batizar.
