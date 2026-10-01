# Referência de densidade — Fase 2 Mercado (Airbnb + Deliveroo)

> **Não é o documento vivo do produto.** Barra oficial: [`../target-model.md`](../target-model.md) (estrutura + critérios).  
> Este arquivo = **quão denso** fica um estudo de mercado real, extraído dos PDFs abaixo.  
> Saída viva: `.docs/pesquisa-mercado.md` (template: `templates/pesquisa-mercado.md`).

## Fontes reais

| Arquivo | Uso |
|---------|-----|
| [`anexos/airbnb-pitch-deck-2009.pdf`](anexos/airbnb-pitch-deck-2009.pdf) | Slides 4, 5, 7 e 9: validação **antes** do tamanho; mercado total → alcançável → capturável (TAM → SAM → SOM) com unidade; eixos |
| [`anexos/deliveroo-prospectus-2021.pdf`](anexos/deliveroo-prospectus-2021.pdf) | Setor definido; valores em libras com fonte **OC&C**; história de captura |

**Não** copiar números de Airbnb ou Deliveroo para o `.docs/` do cliente. Copiar só a **lógica**.

---

## O que os PDFs fazem (a nossa barra)

| Bloco | Airbnb | Deliveroo | Obrigatório no nosso `.docs/` |
|-------|--------|-----------|-------------------------------|
| Mercado definido | Problema + limites | Setor = alimentação fora de casa + mercado | § Definição |
| Validação **antes** do tamanho | Couchsurfing 630 mil · Craigslist 17 mil | Penetração online × offline; OC&C | § Sinais (pelo menos 2 com nome) |
| Funil de tamanho | 1,9 bi de viagens → 532 mi → 10,6 mi | £ 1,2 tri (OC&C) → ocasiões online | § Mercado total / alcançável / capturável + **Conta** |
| Unidade explícita | **Viagens** | **£ no varejo** + ocasiões de refeição | Coluna Unidade |
| Fonte com nome | Sites / contagens | **OC&C**, Euromonitor | Coluna Fonte |
| Valor / modelo | Taxa de 10% · esboço de receita | Volume bruto / economia por pedido | Preço / modelo |
| Concorrência | Barato ↔ caro · online ↔ offline | Pares no prospecto | Matriz + eixos |
| Implicação | Plano de adoção | Investir para capturar ocasiões | Seguir / mudar / parar |

**Regras de ouro:** validação com concorrentes nomeados antes do tamanho (Airbnb) · empresa de pesquisa nomeada quando a conta é de cima para baixo (Deliveroo) · rótulos para leigo: Mercado total / Mercado que faz sentido / Pedaço realista (nunca só a sigla).

---

## Bloco da conta (tem que aparecer no `.docs/`)

Texto simples, uma linha por camada — **“~15–25 mi” solto = inválido**:

```text
TAM = …                         # ou: TAM = N (direto da fonte X)
SAM = TAM × …% = …              # ou de baixo para cima: N × …
SOM = SAM × …% = …              # ou âncora num rival: …
Receita_ilustrativa = SOM × …   # se afiliado / visível nos concorrentes
```

---

## Roteiro do agente

1. Abrir o PDF do Airbnb → lógica dos slides 4, 5, 7 e 9 (não os números de viagens para o cliente).  
2. Abrir o PDF da Deliveroo → setor + valor com fonte nomeada + forma de captura.  
3. Preencher `.docs/pesquisa-mercado.md` pelo **template** + critérios do **target-model**.  
4. Conferir a densidade: toda linha de tamanho tem unidade + conta; pelo menos 2 sinais de demanda; pelo menos 5 concorrentes com preço/modelo + tentativa de porte.  
5. Gate F6 só depois disso.

---

## Válido × inválido (rápido)

| Válido | Inválido |
|--------|----------|
| Mercado total → alcançável → capturável com unidade + conta em cada um | “~faixa” / “parte do SAM” sem fórmula |
| Pelo menos 2 sinais de demanda com número + fonte | Só opinião |
| Fonte do tamanho nomeada quando a conta é de cima para baixo | Número grande inventado |
| Cada concorrente: preço/modelo + tentativa de porte | Só a página inicial |
| História de captura + implicação explícita | Tabela de lacunas sem decisão |
