# Modelo-alvo — Fase 3 Protótipo

> Derivado de Design Sprint / Product Sprint **reais**.  
> Vivo: `.docs/prototipo.md`

## Fontes reais (anexadas)

| Arquivo | O que é | O que extrair |
|---------|---------|----------------|
| [`examples/anexos/google-product-design-sprint-deck.pdf`](examples/anexos/google-product-design-sprint-deck.pdf) | Google Design Sprint Kit — Product Sprint | Map · storyboard · key moments · prototype surface |
| [`examples/anexos/design-sprint-2-sessionlab.pdf`](examples/anexos/design-sprint-2-sessionlab.pdf) | Design Sprint 2.0 printout | User map · user test flow · storyboard 6–8 passos |

Online: [GV Design Sprint](https://www.gv.com/sprint/)

## Mínimos que os modelos reais exigem

1. Mapa / jornada do ator até o objetivo.  
2. Fluxo testável em passos (storyboard).  
3. Superfícies (telas) nomeadas — o que a pessoa **vê**.  
4. Hipótese do que está sendo testado.  
5. Sem polir visual (hex/tokens) no lugar do fluxo.

## Nosso modelo-alvo

1. Dicionário  
2. Fluxos / jornadas (numerados)  
3. Telas com nome humano + campos/ações  
4. Estados (loading / empty / error)  
5. Hipótese de solução (resumo)  
6. Fora deste proto  
7. Confirmado · Hipótese · Aberto · Gate  

## Critérios de aceitação

| # | CA | Barra |
|---|-----|--------|
| P1 | Dicionário + telas com nome humano | Sem só E0/D1 |
| P2 | Fluxos cobrem entradas do discovery | |
| P3 | Telas com objetivo + ações | Sem hex |
| P4 | Estados mínimos | |
| P5 | Alinha gaps do mercado | Diferencial |
| P6 | Feature nova só com eco+confirma | |
| P7 | Gate gravado | |
| **P.CL** | **CL0–CL5** — `shared/docs-clarity.md` | Telas humanas; zero meta de chat |

## Anti-padrões (Protótipo)

| Anti-padrão | Sintoma |
|-------------|---------|
| Tela sem jornada | Wireframe órfão |
| Código de tela só | “E2” sem nome |
| Hex / DS cedo | Fase errada |
| Stack no proto | “vamos usar Redis” |
| Status tagarela | Protocolo que o cliente não pediu |
| Meta de chat / abreviação | `qtd.`, “não inventar”, título de prompt |
