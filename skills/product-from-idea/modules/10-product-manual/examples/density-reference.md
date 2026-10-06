# Referência de densidade — Fase 10 Manual comercial

> **Não é o documento vivo do produto.** Vivo: `docs/{slug}.md`.  
> **Lei:** abrir o **arquivo real** (PDF / HTML). Resumo no chat **não** conta como anexo.

## Fontes reais (arquivos no disco — abrir)

| Arquivo | O que é | Tirar a **lógica** |
|---------|---------|--------------------|
| [`anexos/airbnb-pitch-deck.pdf`](anexos/airbnb-pitch-deck.pdf) | Apresentação do Airbnb para investidores, 2009 (PDF real) | Problema → solução → validação → tamanho → produto → modelo → concorrência — **história comercial completa** |
| [`anexos/stripe-2021-update.pdf`](anexos/stripe-2021-update.pdf) | Carta anual da Stripe, 2021 (PDF oficial) | Carta longa: negócio + produto + visão — tom comercial sério |
| [`anexos/shape-up.pdf`](anexos/shape-up.pdf) | Livro *Shape Up*, da Basecamp (PDF oficial, ~7 MB) | Como **explicar** um produto com clareza (sem copiar o processo da Basecamp) |
| [`anexos/stripe-payments.html`](anexos/stripe-payments.html) | Página Stripe Payments (HTML) | Promessa → pilares → prova → caminhos para começar |
| [`anexos/apple-airpods-pro.html`](anexos/apple-airpods-pro.html) | Página Apple AirPods Pro (HTML) | Manual para **quem usa**: título → destaques → detalhe |
| [`anexos/linear-homepage.html`](anexos/linear-homepage.html) | Página inicial do Linear (HTML) | Sistema contado em capítulos |
| [`anexos/linear-method-introduction.html`](anexos/linear-method-introduction.html) | Linear Method (HTML) | Princípios em prosa |
| [`anexos/notion-product.html`](anexos/notion-product.html) | Página de produto do Notion (HTML; página dinâmica — olhar no navegador se o HTML vier vazio) | Uma linha + blocos de capacidade |

**Proibido:** inventar “exemplo ilustrativo” num `.md` curto no lugar destes arquivos.

---

## O que eles fazem (a nossa barra para `{slug}.md`)

| Bloco | Melhor professor | Obrigatório no manual |
|-------|------------------|-----------------------|
| Arco da história (problema → oferta) | **Apresentação do Airbnb** | Partes A e B abrem com história |
| Prosa comercial longa | **Carta da Stripe** | Negócio legível sem jargão de processo |
| Sistema em capítulos | **Linear** | Parte C = jornada completa |
| Profundidade para quem usa | **Apple** | Parte A com destaques + detalhe |
| Clareza da explicação | **Shape Up** | Frases que um leigo entende |

**Não** copiar números do Airbnb, volume da Stripe ou promessas da Apple para o produto do cliente.

---

## Roteiro do agente

1. Abrir o **PDF do Airbnb** (slides de problema / solução / produto / modelo).  
2. Abrir o **PDF da carta da Stripe** ou o HTML do Payments.  
3. Abrir o HTML da **Apple** para o tom de quem usa.  
4. Costurar os fatos do `docs/` **deste** produto no `templates/manual-produto.md`.  
5. Gate F6.

---

## Válido × inválido

| Válido | Inválido |
|--------|----------|
| Abrir o PDF / HTML real da pasta | “Anexo” = markdown de 40 linhas resumindo a página |
| História + todos os fatos cobertos | Brief `produto.md` disfarçado |
| Dívidas honestas | Métrica inventada no estilo da Stripe |
