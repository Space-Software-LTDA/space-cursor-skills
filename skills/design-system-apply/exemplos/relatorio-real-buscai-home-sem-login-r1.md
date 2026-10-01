# Conferência do Design System — buscaí — Home sem login — 2026-09-28 — r1

> Rodada 1 da conferência da tela Home sem login, depois do OK do cliente na tela (2026-09-28).  
> Varredura com prints desta sessão, correções no canvas só com peças oficiais e variáveis, re-conferência cega e prints depois.

## Dicionário

| Termo | O que é |
|-------|---------|
| **P0 / P1 / P2** | Gravidade do achado: P0 quebra a tela; P1 foge do Design System ou do guia de gosto; P2 é acabamento |
| **Peça ligada** | Cópia de um componente oficial “Ess / …”; muda junto quando o componente muda |
| **Peça solta** | Parte da tela desenhada à mão, sem componente oficial |
| **Nova versão do Design System** | Peça ou regra nova no documento do Design System, com motivo e OK do cliente (no time, mini-A); não reabre a Fase 7 |
| **Re-conferência cega** | Nova varredura depois das correções, feita como se todos os problemas ainda existissem, sem olhar a lista do que foi corrigido |
| **Primeira dobra** | O que aparece antes de rolar a página |

| Campo | Valor |
|-------|--------|
| Tela | “buscaí — Home sem login (desktop) · Dark”, canvas `buscai_pendev/buscai.pen` |
| Tipo de produto | Comparador de preços para pessoa física: parte geral do guia de gosto (sem seção própria) |
| Alvo de correção | Canvas |
| Superfície | Site no computador, 1440 × 4236 (celular não pedido pelo cliente) |
| Design System | `.docs/DESIGN_SYSTEM.md` versão 0.23.1 |
| Gosto | `ui-gosto.md`, parte geral |
| Momento | Fase 8, passo 2 c–d (conferência só nesta tela, autorizada pelo OK do cliente) |
| Re-conferência | Cega feita: sim · cruzamento depois: sim |
| Evidência nesta sessão | Prints do canvas: sim (exportados e lidos nesta sessão) |
| OK do cliente | Conferência com o gosto: 2026-09-28 · tela como estava: 2026-09-28 (“Pode fazer”) |

## Diagnóstico da tela

| Tela / estado | Onde existe | Usa só peças oficiais? | Observação |
|---------------|-------------|------------------------|------------|
| Home sem login | Canvas | Não | Cabeçalho, botões, logos das lojas, cards da demonstração, cards da vitrine, cards de solução, link e rodapé são peças ligadas. Barra de categorias, “Como funciona”, painel da prévia da busca com IA, etiquetas, promessa e lista de lojas são peças soltas. Nenhuma cor digitada; todas as fontes por variável |

## Conferência com o gosto

Feita uma vez antes da Home (2026-09-28); resultado no Design System 0.23.0. Nesta rodada, só a aplicação na tela.

## Inventário de alvos

| Alvo | Origem | Conferido? | Se não: motivo e risco |
|------|--------|------------|------------------------|
| Home sem login, tela inteira (11 blocos) | Lista de telas (`telas.md`) | sim | — |
| Sessão sem login | Própria tela | sim | — |
| Sessão logada | Outra tela (Home logado) | não | Fora desta rodada (uma tela por vez); risco baixo |
| Demais telas | Lista de telas | não | Fora desta rodada; só o componente Botão mudou nelas, por herança |

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
- [x] Print desta sessão da tela inteira e de cada bloco
- [x] Computador percorrido do topo ao rodapé
- [ ] Celular — não pedido pelo cliente
- [ ] Janelas abertas e fechadas — no canvas não há clique; janelas ficam nas telas donas
- [x] Telas ausentes no canvas: nenhuma
- [x] Caça: espaço vazio, corte, texto quebrado, peça fora do tamanho

## Escopo percorrido

| Passo | Computador — o que vi |
|-------|-----------------------|
| Primeira dobra | Cabeçalho sem login, barra de categorias, topo com título, dois botões (primário e fantasma), promessa, lojas e demonstração |
| Rolagem | Prévia da busca com IA · Mais buscados da semana · Por que comparar com o buscaí · Hardware e PC · Celulares · Como funciona · Transparência · Rodapé |
| Janelas | Nenhuma desenhada nesta tela |
| Estados | Não se aplica a esta tela (estados ficam no quadro Estados do site) |
| Medidas | Margem 112 e conteúdo 1216 em todas as seções; seções com 64 em cima e embaixo; 32 do título ao conteúdo; 24 entre cards; nenhum corte informado pela ferramenta |

### Espaço vazio e layout quebrado

| Achado | Tipo | Evidência | Gravidade |
|--------|------|-----------|-----------|
| As colunas Normal × Com IA terminam 58 acima da caixa de boas-vindas, deixando um vão embaixo delas dentro do painel | Vão dentro do card | Print da prévia | P2 |
| Nenhum outro vão, corte ou texto quebrado | — | Prints de todos os blocos | — |

### Pedidos do cliente sobre a tela

| # | Pedido | Onde | Resultado | Evidência |
|---|--------|------|-----------|-----------|
| 1 | Texto dos botões grosso demais | Todos os botões | Resolvido com a versão 0.23.1 (rótulo 14/600 no componente; as 74 cópias no canvas herdaram) | `componente-botao-dark-depois.png` · `home-sem-login-depois-03-hero.png` |

## P0 — quebra a tela

Nenhum. Nenhum texto cortado, nenhuma peça para fora do quadro, tela no tamanho de 1440.

## P1 — foge do Design System ou do gosto

| # | Achado | Onde | Regra | Situação |
|---|--------|------|-------|----------|
| 1 | Dois botões primários sólidos na primeira dobra: o segundo “Adicionar ao Chrome” estava sólido | Prévia da busca com IA | Princípio 4 e P-HOME-SEM-LOGIN (0.23.0) | Corrigido: trocado por cópia do Botão / Contorno |
| 2 | Etiqueta “Extensão grátis para Google Chrome” sozinha numa linha acima do título | Topo | §8, posição junto do título | Corrigido: na linha do título, à direita |
| 3 | Etiqueta “Busca com IA” sozinha numa linha acima do título | Prévia da busca com IA | §8 | Corrigido: na linha do título, à direita |
| 4 | Painel da prévia e caixa da demonstração com cantos 16 | Prévia e topo | §5: card até 12; 16 só no painel de baixo do celular | Corrigido: cantos 12 |
| 5 | As duas etiquetas em formato de pílula (cantos arredondados por completo) e com textos diferentes entre si (12/600 e 12/700) | Topo e prévia | §5: cantos redondos só nas peças listadas; etiqueta com cantos 4 e texto no papel Destaque (12/700) | Corrigido: cantos 4, fundo `surface-2` e texto 12/700 nas duas |
| 6 | Títulos de card em 16/700 | Como funciona (4 passos), colunas Normal e Com IA, produto da demonstração | §4: título de card no papel H3 (16/600), igual ao Card de solução | Corrigido: 16/600 |
| 7 | Barra de categorias desenhada à mão; o item escolhido é marcado só por peso (700) e cor do texto | Barra de categorias | Regra das telas (peça ligada) · §7: seleção ativa em Azul | Pendente: componente novo (proposta 1) |
| 8 | “Como funciona” desenhado à mão; número dentro de círculo (cantos redondos fora da lista) em fonte de números 16 (fora dos tamanhos do papel Número) | Como funciona | Regra das telas · §4 · §5 | Pendente: componente novo (proposta 2) |
| 9 | Painel da prévia desenhado à mão: colunas Normal × Com IA, caixa de boas-vindas e etiquetas “Grátis” e “Recomendada” soltas | Prévia da busca com IA | Regra das telas; o mesmo painel existe na Home logado | Pendente: componente novo (proposta 3) |
| 10 | Etiquetas sem componente oficial (“Extensão grátis para Google Chrome”, “Busca com IA”, “Grátis”, “Recomendada”) | Topo e prévia | Regra das telas | Pendente: componente novo (proposta 4) |
| 11 | Subtítulos em 16/400 (texto do topo, da prévia e das seções) sem papel no Design System | 7 textos | §4: papéis de texto | Pendente: regra nova (proposta 5) |

## P2 — acabamento

| # | Achado | Onde | Situação |
|---|--------|------|----------|
| 12 | Etiqueta “Mais buscado” repetida nos 4 cards da seção “Mais buscados da semana”: repete o título da seção | Mais buscados | Pendente: mudança de conteúdo, o cliente decide |
| 13 | Card “Busca com IA” usa o mesmo ícone da categoria Hardware e PC (chip); no resto do produto a busca com IA usa estrelinhas | Por que comparar | Pendente: troca de ícone, o cliente decide |
| 14 | Vão de 58 embaixo das colunas Normal × Com IA | Prévia | Anotado; entra na proposta 3 |
| 15 | Promessa (“< 5 min · 9 lojas · Grátis”) em fonte de números 20, papel pensado para preço | Topo | Anotado |
| 16 | Nomes das lojas em 12/600, papel pensado para rótulo de campo | Topo | Anotado |
| 17 | Etiqueta do topo alinhada ao alto da primeira linha do título, um pouco acima do centro da linha | Topo | Anotado |
| 18 | “QueimaI” se lê “Queimal” na fonte Geist | Prévia e Por que comparar | Apontamento de marca, fora da tela |

## Gosto — passa ou falha

| Item | Resultado | Evidência |
|------|-----------|-----------|
| Fundos neutros, sem excesso de cor | Passa | Seções alternando `background` e `surface` |
| Azul só na ação e na escolha | Passa com atenção | Botão primário, link, contorno do painel e coluna Com IA (acentos aprovados); etiqueta “Mais buscado” Azul em todos os cards (acento aprovado, ver item 12) |
| Camadas perceptíveis | Passa | Painel `card` → colunas e caixa `surface-2` |
| Sem brilho, neon ou vidro | Passa | Prints |
| Um guia visual; primário na ação real | Passa (depois da correção 1) | Print do topo e da prévia |
| Topo parado e legível | Passa | Print do topo |
| Par de botões alinhado | Passa | Primário + fantasma lado a lado, 16 entre eles |
| Logos de terceiros com logo | Passa | 9 lojas com logo e nome |
| Rodapé estruturado | Passa com atenção | Rodapé numa linha só (peça oficial) |
| Ícone e selo na linha do título | Passa (depois das correções 2 e 3) | Prints do topo e da prévia |
| Fileiras de cards iguais | Passa com atenção | “Por que comparar” e “Como funciona” com 4 cards da mesma altura |

## Fase C — tela trabalhada

| Ordem | Tela | Ação | Nova versão do Design System? | Print depois |
|-------|------|------|-------------------------------|--------------|
| 1 | Home sem login (computador, tema escuro) | Ajuste; versão anterior guardada no Rascunho como “Rascunho · Home sem login · antes das correções do Apply r1 (2026-09-28)” | Sim, cinco propostas (itens 7 a 11), aguardando OK | `home-sem-login-depois-00-tela-inteira.png` e blocos 01, 03, 04, 09 |

### Conferência cruzada

| Medida | Telas comparadas | Valores encontrados | Valor no Design System |
|--------|------------------|---------------------|------------------------|
| Cantos do painel da busca com IA | Home sem login · Home logado | 12 (corrigido) · 16 | 12 — corrigir na Home logado no ciclo dela |
| Cantos da etiqueta “Busca com IA” | Home sem login · Home logado | 4 (corrigido) · redondo | 4 — corrigir na Home logado no ciclo dela |

## Re-conferência cega

| Problema procurado | Assumido | Resultado | Evidência nesta sessão |
|--------------------|----------|-----------|------------------------|
| Dois primários sólidos na primeira dobra | ainda falha | Passa: 1 primário (topo), 1 fantasma (topo), 1 contorno (prévia) | Leitura das peças + print da prévia |
| Etiqueta ou ícone sozinho acima do título | ainda falha | Passa: nenhum | Leitura das peças + prints |
| Card com cantos acima de 12 | ainda falha | Passa: nenhum | Leitura das peças |
| Cantos redondos fora da lista | ainda falha | Falha: número dos 4 passos de “Como funciona” | Leitura das peças (proposta 2) |
| Título de card fora do papel H3 | ainda falha | Passa nos títulos; os números dos passos seguem em 16/700 | Leitura das peças (proposta 2) |
| Cor digitada ou fonte fora de variável | ainda falha | Passa: 0 e 0 | Leitura das peças |
| Corte ou peça para fora | ainda falha | Passa: nenhum | Problemas de layout da ferramenta: 0 |
| Peças soltas | ainda falha | Falha: barra de categorias, “Como funciona”, painel da prévia, etiquetas | Contagem por bloco |
| Subtítulo sem papel | ainda falha | Falha: 7 textos 16/400 | Leitura das peças (proposta 5) |
| Botão com texto grosso | ainda falha | Passa: 14/600 em todos | Leitura das peças + print do topo |
| Espaço vazio | ainda falha | Falha leve: vão de 58 sob as colunas da prévia | Print da prévia |

## Cruzamento com a varredura

| Item | Comparação | Nota |
|------|------------|------|
| 1 a 6 | Sanados | Confirmados na re-conferência cega |
| 7 a 11 | Ainda falham | Dependem de componente ou regra nova |
| 12 a 18 | Ainda presentes | Acabamento ou decisão de conteúdo |
| 17 | Novo | Surgiu com a correção 2 |

## Diferenças para os devs

Não se aplica: a tela só existe no canvas.

## Conferência final

- [x] Relatório completo
- [x] Prints do canvas nesta sessão
- [x] Re-conferência cega antes do cruzamento
- [x] Pedido do cliente sem falha
- [ ] Tela só com peças oficiais e variáveis — falta o resultado das propostas 1 a 5
- [ ] Conferência cruzada fechada — Home logado ainda com cantos 16 e etiqueta redonda
- [ ] Tela alinhada, candidata — não
- [ ] Tela alinhada, final — só com OK do cliente

## Não coberto

| Item | Motivo | Risco |
|------|--------|-------|
| Versão de celular | Cliente não pediu | Baixo |
| Janelas e painéis abertos a partir desta tela | Conferidos nas telas donas | Baixo |
| Clique em botões e links | Canvas sem clique | Baixo |

## Próxima ação

- [x] OK do cliente na tela como estava (2026-09-28)
- [x] Correções de tela aplicadas e re-conferidas
- [ ] Aguardando novo OK do cliente depois das correções
- [ ] Aguardando decisão do cliente nas cinco propostas de nova versão do Design System e nos itens 12 e 13
- [ ] Depois do OK: aplicar o que for aprovado e rodar a rodada r2
