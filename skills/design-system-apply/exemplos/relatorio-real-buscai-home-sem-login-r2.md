# Conferência do Design System — buscaí — Home sem login — 2026-09-28 — r2

> Rodada 2 da conferência da tela Home sem login, depois das decisões do cliente sobre a rodada 1 (2026-09-28) e da versão 0.24.0 do Design System.  
> Troca das peças desenhadas à mão por cópias dos componentes novos, re-conferência cega da tela inteira com prints desta sessão e prints depois.

## Dicionário

| Termo | O que é |
|-------|---------|
| **P0 / P1 / P2** | Gravidade do achado: P0 quebra a tela; P1 foge do Design System ou do guia de gosto; P2 é acabamento |
| **Peça ligada** | Cópia de um componente oficial “Ess / …”; muda junto quando o componente muda |
| **Peça solta** | Parte da tela desenhada à mão, sem componente oficial |
| **Composição de texto** | Textos e peças ligadas arrumados na tela com os papéis de texto e as variáveis do Design System, sem componente próprio (ex.: título e subtítulo de uma seção) |
| **Nova versão do Design System** | Peça ou regra nova no documento do Design System, com motivo e OK do cliente (no time, mini-A); não reabre a Fase 7 |
| **Re-conferência cega** | Varredura feita como se todos os problemas ainda existissem, sem olhar a lista do que foi corrigido |
| **Primeira dobra** | O que aparece antes de rolar a página |

| Campo | Valor |
|-------|--------|
| Tela | “buscaí — Home sem login (desktop) · Dark”, canvas `buscai_pendev/buscai.pen` |
| Tipo de produto | Comparador de preços para pessoa física: parte geral do guia de gosto (sem seção própria) |
| Alvo de correção | Canvas |
| Superfície | Site no computador, 1440 × 4167 (celular não pedido pelo cliente) |
| Design System | `.docs/DESIGN_SYSTEM.md` versão 0.24.0 |
| Gosto | `ui-gosto.md`, parte geral |
| Momento | Fase 8, passo 2 d (nova rodada na mesma tela, depois das decisões do cliente) |
| Re-conferência | Cega feita: sim · cruzamento depois: sim |
| Evidência nesta sessão | Prints do canvas: sim (exportados e lidos nesta sessão) · leitura das peças da tela inteira pela ferramenta do canvas |
| OK do cliente | Tela como estava: 2026-09-28 · decisões da rodada 1 e versão 0.24.0: 2026-09-28 · tela depois da rodada 2: aguardando |

## Diagnóstico da tela

| Tela / estado | Onde existe | Usa só peças oficiais? | Observação |
|---------------|-------------|------------------------|------------|
| Home sem login | Canvas | Sim, onde o Design System tem componente | Peças ligadas: cabeçalho sem login, barra de categorias, etiqueta do topo, botões, logos das lojas, legenda de selos e cards da demonstração, painel da busca com IA (Sem login), cards da vitrine, cards de solução, passos, links e rodapé. Composição de texto sem componente: títulos e subtítulos das seções, promessa, lista de lojas, cabeçalho da moldura da demonstração e aviso de transparência. Nenhuma cor digitada; todas as fontes por variável; cantos só 4, 8 e 12 |

## Conferência com o gosto

Feita uma vez antes da Home (2026-09-28); resultado no Design System 0.23.0. Nesta rodada, só a aplicação na tela.

## Inventário de alvos

| Alvo | Origem | Conferido? | Se não: motivo e risco |
|------|--------|------------|------------------------|
| Home sem login, tela inteira (11 blocos) | Lista de telas (`telas.md`) | sim | — |
| Sessão sem login | Própria tela | sim | — |
| Sessão logada | Outra tela (Home logado) | não | Fora desta rodada (uma tela por vez); risco baixo |
| Componentes novos (Etiqueta, Barra de categorias, Painel da busca com IA, Passo) | Quadros “Componentes (Dark)” e “(Light)” | sim | — |
| Demais telas | Lista de telas | não | Fora desta rodada; nenhuma foi alterada |

## Janelas e painéis que abrem desta tela

| Janela ou painel | Tipo | Como abre | Conferido? | Se não: motivo e risco |
|------------------|------|-----------|------------|------------------------|
| Entrar e criar conta | Janela sobre a página | Botão “Entrar” do cabeçalho | não | Pertence à tela Entrar e criar conta (ordem 10); risco baixo |
| Resultados instantâneos | Painel abaixo do campo | Clique ou digitação no campo do cabeçalho | não | Pertence à tela Busca instantânea (ordem 11); risco baixo |
| Painel do selo e da nota (aba lateral) | Painel sobre o card | Clique na aba do card da demonstração | não | Peça do card de anúncio, conferida na Fase 7; risco baixo |

## Telas espelhadas

Não se aplica: a tela só existe no canvas.

## Checklist da varredura

- [x] Diagnóstico da tela preenchido
- [x] Inventário de alvos preenchido
- [x] Janelas e painéis listados
- [x] Print desta sessão da tela inteira e de cada bloco alterado
- [x] Computador percorrido do topo ao rodapé
- [ ] Celular — não pedido pelo cliente
- [ ] Janelas abertas e fechadas — no canvas não há clique; janelas ficam nas telas donas
- [x] Telas ausentes no canvas: nenhuma
- [x] Caça: espaço vazio, corte, texto quebrado, peça fora do tamanho

## Escopo percorrido

| Passo | Computador — o que vi |
|-------|-----------------------|
| Primeira dobra | Cabeçalho sem login · barra de categorias com “Todas as categorias” em Azul e traço embaixo · topo com a etiqueta “Extensão grátis para Google Chrome” numa linha acima do título, título em 2 linhas, subtítulo, primário “Adicionar ao Chrome” + fantasma “Ver como funciona”, promessa, lojas e demonstração |
| Rolagem | Prévia da busca com IA (painel Sem login) · Mais buscados da semana (sem etiqueta) · Por que comparar com o buscaí (“Busca com IA” com estrelinhas) · Hardware e PC · Celulares · Como funciona (4 passos) · Transparência · Rodapé |
| Janelas | Nenhuma desenhada nesta tela |
| Estados | Não se aplica a esta tela (estados ficam no quadro Estados do site) |
| Medidas | Margem 112 e conteúdo 1216 em todas as seções; 24 entre cards; fileiras “Por que comparar” e “Como funciona” com 4 cards de 160 de altura; nenhum corte informado pela ferramenta |

### Espaço vazio e layout quebrado

| Achado | Tipo | Evidência | Gravidade |
|--------|------|-----------|-----------|
| As colunas Normal × Com IA terminam 11 acima da caixa de boas-vindas | Diferença de fim de linha dentro do painel | Medida do painel nesta sessão · `home-sem-login-r2-03-previa.png` | P2 |
| Nenhum outro vão, corte ou texto quebrado | — | Prints de todos os blocos alterados e da tela inteira | — |

### Pedidos do cliente sobre a tela (decisões da rodada 1)

| # | Pedido | Onde | Resultado | Evidência |
|---|--------|------|-----------|-----------|
| 1 | Etiqueta “Extensão grátis para Google Chrome” de volta acima do título; título em 2 linhas | Topo | Feito com cópia da Etiqueta / Neutra; exceção escrita na §8 | `home-sem-login-r2-01-topo.png` |
| 2 | Barra de categorias como componente, escolhida em Azul | Categorias | Feito com cópia da Barra de categorias | `home-sem-login-r2-02-categorias.png` |
| 3 | Como funciona com a variação Passo do Card de solução | Como funciona | Feito: 4 cópias do Card de solução / Passo, com os mesmos títulos e textos | `home-sem-login-r2-06-como-funciona.png` |
| 4 | Painel da busca com IA como componente, versão Sem login | Prévia | Feito com cópia do Painel da busca com IA / Sem login | `home-sem-login-r2-03-previa.png` |
| 5 | Etiquetas como componente | Topo e prévia | Feito: todas as etiquetas da tela são cópias da Etiqueta | Prints do topo e da prévia |
| 6 | Papel Subtítulo 16/400 | Topo, prévia e seções | Os 7 textos de apoio já estavam em 16/400 e agora têm papel no Design System | Leitura das peças |
| 7 | Sem a etiqueta “Mais buscado” nos cards de “Mais buscados da semana” | Mais buscados | Feito: etiqueta desligada só nas 4 cópias desta seção; o componente não mudou. Em Hardware e PC e em Celulares, cada seção segue com 1 card “Indicação” e 3 cards “Mais buscado”, como antes | `home-sem-login-r2-04-mais-buscados.png` |
| 8 | Estrelinhas no card “Busca com IA” | Por que comparar | Feito | `home-sem-login-r2-05-por-que-comparar.png` |

## P0 — quebra a tela

Nenhum. Nenhum texto cortado, nenhuma peça para fora do quadro, tela no tamanho de 1440.

## P1 — foge do Design System ou do gosto

| # | Achado | Onde | Regra | Situação |
|---|--------|------|-------|----------|
| 1 | Títulos das seções em 28/700 (papel H1), mas a §4 diz que título de seção é H2 (20/700); a prancha de Fundamentos usa “Mais buscados da semana” como exemplo de H2 em 20. O mesmo acontece na Home logado (28), enquanto a página do produto da vitrine usa 20 nas seções | 5 seções da Home sem login e o título do painel da busca com IA | §4, papéis de texto | Pendente: decisão do cliente (proposta abaixo). Corrigir sem decisão mudaria as duas Homes ou a regra |

## P2 — acabamento

| # | Achado | Onde | Situação |
|---|--------|------|----------|
| 2 | Colunas Normal × Com IA terminam 11 acima da caixa de boas-vindas | Prévia (componente Painel / Sem login) | Anotado. Igualar exigiria altura fixa no componente, que quebra quando o texto mudar |
| 3 | Promessa (“< 5 min · 9 lojas · Grátis”) em fonte de números 20, papel pensado para preço | Topo | Anotado |
| 4 | Nomes das lojas em 12/600, papel pensado para rótulo de campo | Topo | Anotado |
| 5 | Moldura da demonstração (fundo `card`, contorno, cantos 12, cabeçalho “Você pesquisou…”) desenhada na tela; o miolo usa peças ligadas | Topo | Anotado: aparece só nesta tela; vira componente só se outra tela precisar |
| 6 | “QueimaI” se lê “Queimal” na fonte Geist | Prévia, Por que comparar e Como funciona | Apontamento de marca, fora da tela |

## Proposta de nova versão do Design System

**Título de seção nas Homes (achado 1)**

| Opção | O que muda | Efeito |
|-------|------------|--------|
| A | Escrever na §4: nas páginas feitas de seções de ponta a ponta, sem título de página (as duas Homes), o título de seção usa 28/700 (H1); nas páginas com título próprio (ex.: produto da vitrine), a seção usa 20/700 (H2). Prancha de Fundamentos troca o exemplo de H2 | Nenhuma tela muda |
| B | Baixar os títulos de seção das duas Homes para 20/700 (H2) | Muda 5 títulos nesta tela e 8 na Home logado; título 20 fica perto do subtítulo 16 e a página longa perde hierarquia |
| C | Deixar como está, sem escrever | A regra continua contradizendo a tela; a revisão (Fase 9) vai apontar de novo |

**Recomendação: A.** O topo tem título 32, e as seções logo abaixo em 28 mantêm a escada clara numa página longa; nas páginas com título próprio, 20 já é o que está em uso.

## Gosto — passa ou falha

| Item | Resultado | Evidência |
|------|-----------|-----------|
| Fundos neutros, sem excesso de cor | Passa | Seções alternando `background` e `surface` |
| Azul só na ação e na escolha | Passa | Botão primário, link, categoria escolhida, contorno do painel e coluna Com IA, etiquetas Destaque (acentos aprovados); a etiqueta Azul saiu dos cards de “Mais buscados da semana” |
| Camadas perceptíveis | Passa | Painel `card` → colunas e caixa `surface-2` |
| Sem brilho, neon ou vidro | Passa | Prints |
| Um guia visual; primário na ação real | Passa | Primeira dobra com 1 primário (topo), 1 fantasma (topo) e 1 contorno (prévia) |
| Topo parado e legível | Passa | Etiqueta, título em 2 linhas e subtítulo |
| Par de botões alinhado | Passa | Primário + fantasma lado a lado, 16 entre eles |
| Logos de terceiros com logo | Passa | 9 lojas com logo e nome |
| Rodapé estruturado | Passa com atenção | Rodapé numa linha só (peça oficial) |
| Ícone e etiqueta na linha do título | Passa | Prévia com a etiqueta à direita do título, centralizada na primeira linha; topo usa a exceção escrita na §8 |
| Fileiras de cards iguais | Passa | “Por que comparar” e “Como funciona” com 4 cards de 160 |
| Item selecionado igual em toda parte | Passa nesta tela | Categoria escolhida em Azul com traço, igual ao componente |

## Fase C — tela trabalhada

| Ordem | Tela | Ação | Nova versão do Design System? | Print depois |
|-------|------|------|-------------------------------|--------------|
| 1 | Home sem login (computador, tema escuro) | Ajuste; versão anterior guardada no Rascunho como “Rascunho · Home sem login · antes das correções do Apply r2 (2026-09-28)” | Versão 0.24.0 aplicada; uma proposta nova (achado 1), aguardando OK | `home-sem-login-r2-00-tela-inteira.png` e blocos 01 a 06 |

### Conferência cruzada

| Medida | Telas comparadas | Valores encontrados | Valor no Design System |
|--------|------------------|---------------------|------------------------|
| Título de seção | Home sem login · Home logado · Produto da vitrine | 28 · 28 · 20 | 20 (H2) — proposta A acima |
| Painel da busca com IA | Home sem login · Home logado | Componente (cantos 12, etiqueta com cantos 4) · desenhado à mão (cantos 16, etiqueta redonda) | Componente 53 — trocar na Home logado no ciclo dela |
| Barra de categorias | Home sem login · Home logado · Resultado da busca nos produtos | Componente · desenhada à mão · desenhada à mão | Componente 52 — trocar nas outras duas no ciclo de cada uma |

## Re-conferência cega

| Problema procurado | Assumido | Resultado | Evidência nesta sessão |
|--------------------|----------|-----------|------------------------|
| Dois primários sólidos na primeira dobra | ainda falha | Passa: 1 primário, 1 fantasma, 1 contorno | Leitura das peças + prints do topo e da prévia |
| Etiqueta, ícone ou selo sozinho acima do título | ainda falha | Passa: só a etiqueta do topo, na exceção escrita (§8) | Print do topo |
| Card com cantos acima de 12 | ainda falha | Passa: nenhum | Leitura das peças |
| Cantos redondos fora da lista | ainda falha | Passa: nenhum (número do passo em quadrado com cantos 8) | Leitura das peças + print de Como funciona |
| Título de card fora do papel H3 | ainda falha | Passa: nenhum texto 16/700 na tela | Leitura das peças |
| Título de seção fora do papel | ainda falha | Falha: 28/700 contra H2 20/700 da §4 | Leitura das peças (achado 1) |
| Cor digitada ou fonte fora de variável | ainda falha | Passa: 0 e 0 | Leitura das peças |
| Corte ou peça para fora | ainda falha | Passa: nenhum | Problemas de layout da ferramenta: 0 |
| Peças soltas onde existe componente | ainda falha | Passa: barra, etiquetas, painel e passos são cópias ligadas | Lista de peças por bloco |
| Texto sem papel no Design System | ainda falha | Passa, fora o achado 1: subtítulos 16/400 no papel Subtítulo | Leitura das peças |
| Etiqueta repetindo o título da seção | ainda falha | Passa: “Mais buscados da semana” sem etiqueta | Print de Mais buscados |
| Ícone trocado entre assuntos | ainda falha | Passa: estrelinhas na busca com IA; chip só em Hardware e PC | Print de Por que comparar e da barra |
| Fileira de cards com alturas diferentes | ainda falha | Passa: 160 nas duas fileiras | Medida das peças |
| Espaço vazio | ainda falha | Falha leve: 11 entre o fim das colunas e o fim da caixa de boas-vindas | Medida do painel (achado 2) |
| Botão com texto grosso | ainda falha | Passa: 14/600 em todos | Print do topo |

## Cruzamento com a rodada 1

| Item da rodada 1 | Comparação | Nota |
|------------------|------------|------|
| 1 a 6 | Continuam sanados | Nenhum voltou |
| 7 Barra de categorias | Sanado | Componente 52 |
| 8 Como funciona | Sanado | Card de solução / Passo |
| 9 Painel da prévia | Sanado | Componente 53, versão Sem login |
| 10 Etiquetas | Sanado | Componente 51 |
| 11 Subtítulo | Sanado | Papel Subtítulo 16/400 |
| 12 “Mais buscado” repetido | Sanado | Etiqueta desligada nas 4 cópias da seção |
| 13 Ícone do card “Busca com IA” | Sanado | Estrelinhas |
| 14 Vão sob as colunas | Diminuiu | Hoje 11 (achado 2) |
| 15 e 16 Promessa e nomes das lojas | Ainda presentes | Achados 3 e 4 |
| 17 Etiqueta acima do centro da linha | Sanado | Topo com a etiqueta acima do título; na prévia, a etiqueta fica centralizada na primeira linha do título |
| 18 “QueimaI” | Ainda presente | Fora da tela |
| Achados 1 e 5 | Novos | Não apareciam na rodada 1 |

## Diferenças para os devs

Não se aplica: a tela só existe no canvas.

## Conferência final

- [x] Relatório completo
- [x] Prints do canvas nesta sessão
- [x] Re-conferência cega antes do cruzamento
- [x] Pedidos do cliente sem falha (itens 1 a 8)
- [x] Tela só com peças oficiais e variáveis onde o Design System tem componente
- [ ] Conferência cruzada fechada — título de seção (proposta A), painel e barra na Home logado e no Resultado da busca nos produtos
- [ ] Tela alinhada, candidata — não: falta a decisão do achado 1
- [ ] Tela alinhada, final — só com OK do cliente

## Não coberto

| Item | Motivo | Risco |
|------|--------|-------|
| Versão de celular | Cliente não pediu | Baixo |
| Janelas e painéis abertos a partir desta tela | Conferidos nas telas donas | Baixo |
| Clique em botões e links | Canvas sem clique | Baixo |

## Próxima ação

- [x] Decisões do cliente sobre a rodada 1 aplicadas (Design System 0.24.0 e tela)
- [x] Re-conferência cega feita
- [ ] Aguardando decisão do cliente na proposta do título de seção (achado 1)
- [ ] Aguardando novo OK do cliente nos prints da rodada 2
