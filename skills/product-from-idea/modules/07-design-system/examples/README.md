# Exemplos — Fase 7 Design System

> Casos **reais**. Documento vivo do produto: `docs/DESIGN_SYSTEM.md` + canvas (não estes arquivos).  
> **Barra de saída** = PixReals (documento) e buscaí (canvas). **Teoria** = grandes sistemas da internet.

## Ler primeiro

| Documento | Papel |
|-----------|-------|
| [`density-reference.md`](density-reference.md) | Saída (PixReals, buscaí) + teoria (Carbon…) |
| [`../target-model.md`](../target-model.md) | Critérios de aceite + anti-padrões |
| [`../playbook.md`](../playbook.md) | Sequência da fase |
| [`../reference-forge-handoff.md`](../reference-forge-handoff.md) | Como a fase usa o Forge |
| Skill `design-system-forge` | Diagnóstico / perguntas / aceite / template |

## Como abrir um `.pen`

O `.pen` é o arquivo do canvas (Pencil). É grande demais para ler inteiro de uma vez — abrir **por prancha**.

1. **Com o Pencil conectado (preferido):** abrir o arquivo pela conexão do canvas, listar as pranchas do topo, ler uma prancha por vez e tirar print de cada uma para ver a imagem.  
2. **Sem o Pencil:** o `.pen` é JSON. Ler por partes, sem carregar o arquivo inteiro na conversa:
   - `children` = pranchas do topo (campo `name`);  
   - `variables` = variáveis (cores, fontes, medidas) e `themes` = temas (claro / escuro);  
   - componente oficial = nó com `"reusable": true`;  
   - cópia ligada a um componente = nó com `"type": "ref"`.

```bash
python3 -c "import json,sys; d=json.load(open(sys.argv[1])); [print(c.get('name')) for c in d['children']]; print(len(d.get('variables',{})),'variáveis', d.get('themes'))" arquivo.pen
```

As imagens dentro do `.pen` apontam para uma pasta da máquina de origem e podem não abrir; vale a estrutura. Quando houver PNG da prancha ao lado do `.pen`, abrir o PNG para ver a imagem.

## A — Referência de saída (obrigatório abrir)

| Anexo | O quê |
|-------|-------|
| [`anexos/spacebet-pixreals-README.md`](anexos/spacebet-pixreals-README.md) | Ponte + lei anti-cópia |
| [`anexos/spacebet-pixreals-DESIGN_SYSTEM.md`](anexos/spacebet-pixreals-DESIGN_SYSTEM.md) | DS completo §§0–15 |
| [`anexos/spacebet-pixreals-tokens.dtcg.json`](anexos/spacebet-pixreals-tokens.dtcg.json) | tokens DTCG |
| [`anexos/spacebet-pixreals-EXTRACTION_NOTES.md`](anexos/spacebet-pixreals-EXTRACTION_NOTES.md) | Forge notes |

**Proibido** colar hex/tokens PixReals em outro produto.

## A1 — Saída no canvas (obrigatório abrir)

| Anexo | O quê |
|-------|-------|
| [`anexos/buscai-design-system.pen`](anexos/buscai-design-system.pen) | Canvas real aprovado pelo cliente, nível essencial. 5 pranchas: **Manual da marca** · **Fundamentos (Dark)** · **Fundamentos (Light)** · **Componentes (Dark)** (157 componentes oficiais) · **Componentes (Light)**. 34 variáveis com tema claro e escuro |
| [`anexos/buscai-manual-da-marca.png`](anexos/buscai-manual-da-marca.png) | Imagem da prancha **Manual da marca** |
| [`anexos/buscai-fundamentos-escuro.png`](anexos/buscai-fundamentos-escuro.png) | Imagem da prancha **Fundamentos**, tema escuro |
| [`anexos/buscai-fundamentos-claro.png`](anexos/buscai-fundamentos-claro.png) | Imagem da prancha **Fundamentos**, tema claro |
| [`anexos/buscai-componentes-escuro.png`](anexos/buscai-componentes-escuro.png) | Imagem da prancha **Componentes**, tema escuro — visão geral; o detalhe de cada componente está no `.pen` |
| [`anexos/buscai-componentes-claro.png`](anexos/buscai-componentes-claro.png) | Imagem da prancha **Componentes**, tema claro — visão geral; o detalhe de cada componente está no `.pen` |

Ordem de leitura: abrir o PNG para ver o resultado; abrir o `.pen` para ver a estrutura (variáveis, componentes oficiais, temas).

O que extrair:

- **Fundamentos e Componentes** usam só variáveis (nenhuma cor digitada) — é a barra da Parte C do roteiro.  
- Componentes oficiais ficam numa prancha própria, por tema; o tema principal é o escuro.  
- O **Manual da marca** é prancha de apresentação: pode ter cor digitada e não segue as regras de tela.  
- As imagens de dentro do `.pen` apontam para uma pasta local da máquina de origem e não abrem aqui; para ver as pranchas, usar os PNG acima.

**Proibido** colar cores, logo ou nome buscaí em outro produto — só a estrutura.

## A2 — Formato de entrega visual (modelo-ouro)

| Anexo | O quê |
|-------|-------|
| [`anexos/bateubet-design-system-estrutura.md`](anexos/bateubet-design-system-estrutura.md) | Índice slide a slide + o que copiar / não copiar |
| `bateubet-design-system.pdf` (fora do pacote, 37 MB) | Design System em slides (44 págs · 8 capítulos); estrutura completa em `anexos/bateubet-design-system-estrutura.md` |

**Proibido** colar cores/fontes BateuBet em outro produto — só a estrutura.

## B — Teoria (internet)

| Anexo | Sistema |
|-------|---------|
| [`anexos/carbon-color-overview.md`](anexos/carbon-color-overview.md) | IBM Carbon |
| [`anexos/carbon-themes-overview.md`](anexos/carbon-themes-overview.md) | IBM Carbon |
| [`anexos/atlassian-color.md`](anexos/atlassian-color.md) | Atlassian |
| [`anexos/atlassian-design-tokens.md`](anexos/atlassian-design-tokens.md) | Atlassian |
| [`anexos/polaris-multi-surface.md`](anexos/polaris-multi-surface.md) | Shopify Polaris |
| [`anexos/primer-getting-started.md`](anexos/primer-getting-started.md) | GitHub Primer |
| [`anexos/spectrum-platform-scale.md`](anexos/spectrum-platform-scale.md) | Adobe Spectrum |
| [`anexos/lightning-design-tokens.md`](anexos/lightning-design-tokens.md) | Salesforce |
| [`anexos/pdf/unicef-design-system-visual-guidelines.pdf`](anexos/pdf/unicef-design-system-visual-guidelines.pdf) (+ `.txt`) | **UNICEF Design System** — PDF oficial para **sites**, só o essencial, 26 págs ([fonte](https://unicef.github.io/design-system/assets/UNICEF-Design-system.pdf)) |
| [`anexos/pdf/samsung-one-ui-design-guidelines.pdf`](anexos/pdf/samsung-one-ui-design-guidelines.pdf) (+ `.txt`) | Samsung One UI — PDF oficial ([fonte](https://design.samsung.com/global/contents/one-ui/download/oneui_design_guide_eng.pdf)); mobile Android |
| [Shopify Polaris](https://polaris.shopify.com) (site, sem PDF) | Modelo principal de documentação por componente |

## Product-workspace anexos

URL / Lovable / prints do **produto atual** → GATE 0 em `docs/` — não substituem A/B acima.
