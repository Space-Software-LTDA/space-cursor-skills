# Módulos — agentes de fase

| # | Pasta | Documento em `.docs/` | Como abrir |
|---|-------|------------------------|------------|
| 1 | [`01-discovery/`](01-discovery/) | `.docs/discovery.md` | `AGENT.md` |
| 2 | [`02-market/`](02-market/) | `.docs/pesquisa-mercado.md` | `AGENT.md` |
| 3 | [`03-prototype/`](03-prototype/) | `.docs/prototipo.md` | `AGENT.md` |
| 4 | [`04-mvp/`](04-mvp/) | `.docs/mvp.md` | `AGENT.md` |
| 5 | [`05-contract/`](05-contract/) | `.docs/contrato.md` | `AGENT.md` |
| 6 | [`06-setup/`](06-setup/) | `.docs/setup.md` | `AGENT.md` — repositórios + leis Space genéricas (`reference-space-defaults.md`) |
| 7 | [`07-design-system/`](07-design-system/) | `.docs/DESIGN_SYSTEM.md` + canvas | `design-system-forge` (marca → documento → canvas; essencial, ouro a pedido) |
| 8 | [`08-screens/`](08-screens/) | `.docs/telas.md` + canvas | Sequência do módulo (conferência com o gosto; Home no tema principal; por tela: OK do cliente → Apply na tela → próxima) usando a skill `design-system-apply` |
| 8.5 | [`08b-prototipo-navegavel/`](08b-prototipo-navegavel/) | `prototipo/` (fora do `.docs/`) + seção em `.docs/telas.md` | `AGENT.md` — copia o [molde](08b-prototipo-navegavel/molde/), exporta as telas do canvas, preenche `screens.js` + `rotas.js`; `npm run prototipo:start` |
| 9 | [`09-review/`](09-review/) | `.docs/revisao.md` | `AGENT.md` (Revisor, R1–R15) — libera a **Fase 10** |
| 10 | [`10-product-manual/`](10-product-manual/) | `.docs/{slug}.md` | Manual comercial — anexos **PDF/HTML reais** (Airbnb, carta da Stripe, Shape Up, Apple/Stripe/Linear/Notion) |
| 11 | [`11-task/`](11-task/) | `.docs/tarefas.md` + `.task/` + ClickUp | `po-techlead-scrum` — plano de fatias; uma fatia por vez; anexos = tarefas reais |

**Também:** `.docs/produto.md` = brief **interno** (curto) — **não** é o manual da Fase 10.

**Compartilhado:** [`../shared/`](../shared/) — controlador, passagem de bastão, [`docs-clarity.md`](../shared/docs-clarity.md) (CL0–CL5), [`anti-rush.md`](../shared/anti-rush.md) (duas passagens · zero critério colapsado), [`acceptance-criteria.md`](../shared/acceptance-criteria.md) (critérios + **\*.CL** + Revisor R6–R15), lições do piloto.

**Estrutura de cada módulo:** `AGENT.md` · `playbook.md` · `target-model.md` · `examples/README.md` (o que abrir e por quê) · `examples/anexos/` (casos reais). O módulo 8.5 tem também `molde/` (o protótipo pronto para copiar).

**Regra:** abrir `target-model.md` + pelo menos um anexo real antes de fechar um gate. Nunca inventar exemplo.  
**Regra:** todo critério de fase inclui **\*.CL**. O Revisor **precisa** preencher Clareza humana + Busca residual; **uma linha por critério**; o Controlador rejeita intervalos colapsados.  
**Regra:** sem pressa — ler o arquivo inteiro antes de gravar (`anti-rush.md`).
