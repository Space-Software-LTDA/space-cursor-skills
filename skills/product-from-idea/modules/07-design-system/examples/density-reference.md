# Referência de densidade — Fase 7 Design System

> **Não é o documento vivo do produto.** Barra oficial: [`../target-model.md`](../target-model.md).  
> Saída viva: `.docs/DESIGN_SYSTEM.md` + `tokens.dtcg.json` + `EXTRACTION_NOTES` + canvas (pela skill **`design-system-forge`**).

## Dois tipos de exemplo real

| Tipo | O quê | O que tirar |
|------|-------|-------------|
| **A — Saída** | Design System **fechado** de produtos Space reais: documento (PixReals) e canvas (buscaí) | Densidade, seções, Valor · Uso · Porquê · Fonte, Apêndice A, veredito; pranchas de marca, Fundamentos e Componentes |
| **B — Teoria (internet)** | Carbon / Atlassian / Polaris / Primer / Spectrum / Lightning | Anatomia do token, papéis, várias superfícies, escala |

**Não** copiar cores de PixReals, buscaí, IBM ou Atlassian para o produto do cliente.

---

## A — Referência de saída

### Documento (PixReals / SpaceBET)

> Produto gerado com o Forge no repositório `space-spacesoft-bet`.  
> **Este é o modelo de densidade do documento** — o “Airbnb” da Fase 7.

| Arquivo | Papel |
|---------|-------|
| [`anexos/spacebet-pixreals-DESIGN_SYSTEM.md`](anexos/spacebet-pixreals-DESIGN_SYSTEM.md) | Constituição completa §§0–15 + apêndices |
| [`anexos/spacebet-pixreals-tokens.dtcg.json`](anexos/spacebet-pixreals-tokens.dtcg.json) | Espelho de F1–F8; elevação separada de movimento |
| [`anexos/spacebet-pixreals-EXTRACTION_NOTES.md`](anexos/spacebet-pixreals-EXTRACTION_NOTES.md) | Diagnóstico · perguntas Q1–Q15 (anexo anterior à versão atual do Forge, que tem Q1–Q19; vale a lista do Forge) · aceite · rejeitado · dívidas |
| [`anexos/spacebet-pixreals-README.md`](anexos/spacebet-pixreals-README.md) | Ponte + lei contra copiar cor |

### Canvas (buscaí)

| Arquivo | Papel |
|---------|-------|
| [`anexos/buscai-design-system.pen`](anexos/buscai-design-system.pen) | Manual da marca · Fundamentos escuro e claro · Componentes escuro e claro (157 componentes oficiais, 34 variáveis) — como abrir: ver [`README.md`](README.md) |

### O que o PixReals faz (barra do documento)

| Bloco | PixReals (abrir o arquivo) | Obrigatório no nosso `.docs/` |
|-------|----------------------------|-------------------------------|
| Cabeçalho + ordem de verdade | §0 — humano > gosto > código > método Space > rascunho | Mesma ordem |
| Filosofia + o que não parecer | §1 — uma cor principal, sem brilho, aninhado = superfície 2 | Deve / Não deve + princípios com porquê |
| Leis de UX → decisão | §2 tabela lei → produto | Não só citar a lei; amarrar à especificação |
| F1–F8 densos | §§3–8 cor de **cada** degrau; alerta ≠ botão principal; exceções nomeadas | Fundamentos sem “um tópico só” |
| Componentes **com estados** | §9 botão / campo / selo / cartão / janela / barra | padrão / passar o mouse / foco / desativado / … |
| Padrões `P-…` + árvore de decisão | §10 A–F + domínio do jogador | A–D/F mesmo se a tela ainda não existe |
| Celular / estados / acessibilidade | §§11–13 | Explícito |
| Anti-padrões de IA | §14 tabela Proibido → Preferir | Aceite do Forge |
| Checklist de aceite | §15 | Gate |
| Extraído / Normalizado / Rejeitado | Apêndice A | EXTRACTION_NOTES + Apêndice |
| Trio de artefatos | Design System + tokens + notas | Sempre |

**Regras de ouro (saída):** Valor · Uso · Porquê · Fonte em cada regra · rascunho ≠ lei · exceção do cliente **nomeada** · dívida de tela ≠ buraco de lei · veredito honesto.

---

## B — Teoria (internet)

| Arquivo | Sistema | Tirar a **lógica** |
|---------|---------|--------------------|
| [`anexos/carbon-color-overview.md`](anexos/carbon-color-overview.md) | IBM Carbon | Tema ≠ token ≠ papel ≠ valor; camadas; estados |
| [`anexos/carbon-themes-overview.md`](anexos/carbon-themes-overview.md) | IBM Carbon | Mesmos papéis; valores mudam |
| [`anexos/atlassian-color.md`](anexos/atlassian-color.md) | Atlassian | Papéis semânticos; cor de destaque não é significado |
| [`anexos/atlassian-design-tokens.md`](anexos/atlassian-design-tokens.md) | Atlassian | Anatomia do nome do token |
| [`anexos/polaris-multi-surface.md`](anexos/polaris-multi-surface.md) | Shopify Polaris | Um sistema, várias superfícies (extensão + site) |
| [`anexos/primer-getting-started.md`](anexos/primer-getting-started.md) | GitHub Primer | Constituição; foco |
| [`anexos/spectrum-platform-scale.md`](anexos/spectrum-platform-scale.md) | Adobe Spectrum | Escala para computador × toque |
| [`anexos/lightning-design-tokens.md`](anexos/lightning-design-tokens.md) | Salesforce | Token + descrição de uso |

---

## Roteiro do agente

1. Abrir o **DESIGN_SYSTEM do PixReals** → alvo de densidade do `.docs/DESIGN_SYSTEM.md` vivo.  
2. Abrir as **EXTRACTION_NOTES do PixReals** → formato do diagnóstico / perguntas / aceite / apêndice.  
3. Abrir o **canvas do buscaí** → como ficam as pranchas de marca, Fundamentos e Componentes.  
4. Se o produto tem extensão: abrir **Polaris** (várias superfícies).  
5. Dúvida de token ou papel: **Carbon** ou **Atlassian**.  
6. Rodar o **`design-system-forge`** com as fontes **deste** produto (nunca colar o dourado do PixReals).  
7. Gate só quando a densidade ≈ estrutura do PixReals (mesmo com conteúdo mais enxuto).

---

## Válido × inválido (rápido)

| Válido | Inválido |
|--------|----------|
| Seções 0–15 presentes (ou “não se aplica” com motivo) | Mural de referências / 2 páginas de cores |
| Tokens espelham F1–F8; elevação fora de movimento | Só CSS solto |
| EXTRACTION_NOTES com diagnóstico + perguntas + rejeitado | “PASS” sem notas |
| Cor principal e superfícies com evidência ou cliente | Colar `#CFA551` do PixReals em outro produto |
| Estados + padrões `P-…` | Inventário das telas atuais = lei |
| Superfícies do setup cobertas | Só o site quando tem extensão |
