# Roteiro operacional — Fase 2 Pesquisa de mercado

> **Genérico.** Pesquisa de mercado **de verdade** (análise de mercado), não lista rasa de links.  
> Framework de referência (escola / consultoria): definição de mercado → tamanho (TAM/SAM/SOM) → segmentos → landscape competitivo (com preço/valor e usuários quando houver dado) → jornada/decisão → drivers/riscos → implicações.  
> Fontes: Slideworks Market Analysis · TAM/SAM/SOM · validação early-stage (potential / desirability / viability).  
> Agent **executa** busca (web **e browser** quando a página exigir). Cliente valida no Gate F6.

**Template:** `templates/pesquisa-mercado.md`  
**Target-model + CA:** [`target-model.md`](target-model.md)  
**Real sources:** [`examples/anexos/`](examples/anexos/) (Airbnb + Deliveroo)  
**Density bar:** [`examples/density-reference.md`](examples/density-reference.md)  
**Formação:** F10

---

## Pré-requisito

- `.docs/discovery.md` fechado (ou adiado com risco) com problem statement, persona, fora de escopo.  
- Sem isso → **não** começa Fase 2.

## Cabeçalho

```text
**Fase 2 — Pesquisa de mercado**
**Objetivo:** tamanho + segmentos + concorrência com evidência + gaps
**ON:** F10 + F1 (+ F6 / F9 se monetização aparecer nos dados)
```

---

## Barra de qualidade (o que NÃO aceitamos)

| Raso (proibido como “feito”) | Pesquisa de verdade (obrigatório) |
|------------------------------|-----------------------------------|
| 5–7 links + “gaps: ranking” | Seções 1–7 abaixo preenchidas com **método + fonte** |
| Só homepage do concorrente | Abrir produto: pricing, features, store listing, reviews quando existir |
| “Mercado grande” sem número | TAM/SAM/SOM com **conta** e premissas explícitas |
| Opinião sem URL | Toda afirmação material → fonte (URL + data) |
| Chat dump | Arquivo estruturado; chat = 1 tela de destaques + gate |

**Lei:** se o dado só aparece atrás de UI (Chrome Web Store, App Store, pricing page, landing) → **abrir no browser** (MCP browser / navigate), não “achar que viu”.  
Se paywall/login bloquear → registrar em Fontes como **bloqueado** + o que deu pra ver; não inventar.

---

## Blocos obrigatórios (ordem)

### 1) Definição do mercado (1 parágrafo + limites)
- Categoria do produto/serviço  
- Geografia  
- Horizonte (ex.: MVP 12–18 meses vs visão)  
- O que **está dentro / fora** (amarrado ao discovery)

### 2) Tamanho — TAM / SAM / SOM
| Camada | O que é | Exigência |
|--------|---------|-----------|
| **TAM** | Universo se 100% do mercado amplo | Número + unidade + **conta escrita** + fonte |
| **SAM** | Fatia endereçável (geo + persona + job do discovery) | Idem — **não** basta “~20M proxy” sem fórmula |
| **SOM** | Fatia obtível no horizonte do MVP (realista) | Idem + premissas de captura |

**Lei da conta (obrigatória):** toda estimativa numérica em §2 (e tamanho de segmento) **mostra a conta**, mesmo com confiança baixa.

**Lei da clareza (obrigatória):** no arquivo e no chat, usar **nome em português** ao lado da sigla (`Mercado total (TAM)`). Cliente é leigo — se precisar decifrar, a saída falhou.

```text
# Aceito
SAM = 91,3M × 22% ≈ 20M          # % hipótese; rotular
SOM = 20M × 0,1% = 20.000
TAM = 91,3M (dado direto · fonte X)

# PROIBIDO
SAM ≈ 15–25M (proxy Mosaico)     # sem fórmula
“Parte do SAM”                   # sem número nem conta
```

Faixa `lo–hi` só vale se **as duas pontas** tiverem conta.  
Métodos: top-down e/ou bottom-up. Triangular quando possível.

### 3) Segmentos e usuários
- Segmento primário enriquecido: tamanho com **conta** (mesmo estimada), dor, disposição a pagar se houver indício
- 1–2 segmentos adjacentes (só se evidência)
- Sinais de demanda: volume de busca, downloads, reviews count, comunidades — **com fonte**

### 4) Landscape competitivo (matriz séria)
Para **cada** player relevante (mín. 5 incl. status quo), pesquisar e preencher:

| Campo | Obrigatório? |
|-------|----------------|
| Nome + tipo + URL | Sim |
| Proposta / job que ataca | Sim |
| Preço / modelo (free, freemium, assinatura, afiliado…) | Sim se existir página; senão “não publicado” |
| Escala aproximada (usuários, downloads, lojas, tráfego) | Sim se houver dado público; senão “n/d” + tentativa |
| Pontos fortes vs nossa dor | Sim |
| Falhas vs nossa dor | Sim |
| Fonte + data | Sim |

**Como obter:** search → abrir site → pricing → store listing → “sobre” / imprensa. Browser quando necessário.

Matriz de posicionamento (opcional mas recomendado): 3–5 dimensões que **importam ao cliente** (ex.: profundidade do job × cobertura de canais) — scores 1–5 com nota de evidência.

### 5) Jornada e decisão de compra (mercado)
- Como o usuário descobre alternativas hoje  
- O que decide a escolha (preço, confiança, hábito…) — evidência ou hipótese rotulada

### 6) Drivers, tendências e riscos
- 3–5 drivers (crescimento e-commerce, extensão no browser, afiliados…) com fonte  
- Riscos (ToS, incumbentes, commodity de preço)  

### 7) Implicações estratégicas (F6)
- Seguir / pivotar o corte / matar  
- O que é **mesa** (higiene de mercado) vs **diferencial**  
- Ajuste necessário no discovery? (se sim, atualizar `discovery.md` com replace limpo)

---

## Sequência operacional

1. Ler `discovery.md`  
2. Declarar Fase 2 + âncora  
3. Search amplo → shortlist  
4. **Para cada shortlist:** abrir páginas (browser) e extrair preço/usuários/proposta  
5. Montar TAM/SAM/SOM com contas  
6. Gravar `.docs/pesquisa-mercado.md` (usar template)  
7. Comparar com [`target-model.md`](target-model.md) (+ [`examples/density-reference.md`](examples/density-reference.md); abrir PDF em [`examples/anexos/`](examples/anexos/) se faltar densidade)  
8. Chat: destaques (tamanho, ameaça #1, gap, SOM) + path + Gate F6  

## Tamanho do arquivo

Esta fase **pode** passar de 200 linhas se forem **tabelas**. Preferir tabelas a prosa. Sem novela de chat.  
Se > ~350 linhas → mover anexos (ex.: scores detalhados) para `pesquisa-mercado-anexo.md`.

## Gate F6 — critério de “pesquisa suficiente”

Só **fechado** se:
- [ ] Mercado definido  
- [ ] TAM/SAM/SOM com **conta explícita** em cada camada (ou “dado direto da fonte X”)  
- [ ] ≥5 alternativas com preço/modelo **tentado** e falha vs nossa dor  
- [ ] Pelo menos 1 player com dado de escala (downloads/usuários/tráfego) **ou** registro honesto de bloqueio  
- [ ] Gaps + implicação (seguir/pivotar/matar) claros  
- [ ] Nenhum número órfão (“~faixa” / “parte do SAM”) sem fórmula  

**Raso = bloqueado** (refazer), não “adiado” por preguiça.  
**Número sem conta = bloqueado** (mesmo se o resto estiver bom).
