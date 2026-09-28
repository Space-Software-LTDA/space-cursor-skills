# Roteiro — Manual da marca + Design System (Forge)

> Passo a passo do Forge. Genérico: nenhum valor, nome ou peça daqui pertence a um produto; tudo do produto sai da conversa com o cliente.  
> Partes **A, B e C** = Forge. A validação com telas (tela-prova, demais telas, conferência cruzada) é do **`design-system-apply`**.  
> Níveis: o que é essencial × ouro em [nivel-ouro.md](nivel-ouro.md). Passos marcados **(ouro)** só rodam se o humano pedir.

---

## Dicionário

| Termo | O que é |
|-------|---------|
| **Manual da marca** (Brand Manual) | Documento da identidade: essência, logo, cores da marca, fontes e regras de uso. Não tem botão nem tela. |
| **Design System** (DS) | A marca aplicada à interface: paleta completa por papel, tipografia, espaçamento, grade, cantos, bordas, componentes, estados e padrões de tela. |
| **Documento do DS** | O arquivo `.docs/DESIGN_SYSTEM.md`. É a lei escrita. |
| **Canvas** | O arquivo de design (Pencil, Figma ou similar). É onde a lei vira peça visual. |
| **Prancha** (ou quadro) | Uma área grande do canvas com um assunto só (ex.: “Componentes (Dark)”, “Fundamentos (Dark)”). |
| **Variável** (token) | Um nome com um valor, ex.: `ds-primary`. As peças usam o nome, nunca o valor solto. |
| **Tema** | Conjunto de valores das variáveis: dark ou claro. Trocar o tema troca as cores sem redesenhar. |
| **Componente** | Peça reutilizável (botão, campo, card). Mudar o componente muda todas as cópias. |
| **Instância** | Cópia ligada a um componente. |
| **Deck de referência** | Design System de outro produto, em slides, usado como modelo de estrutura e de lista de componentes ([exemplos/deck-referencia-estrutura.md](exemplos/deck-referencia-estrutura.md)). Só a estrutura é copiada. |
| **Faixa de componentes** | Grupo do [catálogo](catalogo-componentes.md): Essenciais (sempre), Média (decidir), Avançada (só com tela que exija), Domínio (próprio do produto). |
| **Matriz de estados** | Tabela com cada componente numa linha e cada estado (normal, passar o mouse, foco…) numa coluna. |
| **Padrão de tela** (`P-…`) | Receita de uma tela ou bloco: o que entra, em que ordem, o que é proibido. |
| **Ponto de quebra** (breakpoint) | Largura de tela em que o layout muda (ex.: de computador para celular). |
| **Oficial × Rascunho** | Oficial = o que as telas podem usar. Rascunho = explorações, versões antigas, opções não escolhidas. Nada é apagado; só separado. |
| **Contraste** | Diferença de luz entre a cor da frente e a do fundo. Regra: pelo menos 4,5 para 1 em texto normal; 3 para 1 em texto grande (a partir de 24 px, ou 18,5 px em negrito) e em bordas e ícones que a pessoa precisa enxergar para usar (borda de campo, ícone de botão, anel de foco). |
| **Fechado até o momento** | Estado de um gate que vale como lei agora, mas pode ser reaberto pelo canvas ou pelas telas. Toda reabertura gera nova versão no documento. |

---

## Visão geral

| Parte | Passos | Entrega | Quem decide |
|-------|--------|---------|-------------|
| **A. Marca** | 1 a 7 | Prancha “Manual da marca” no canvas (+ PDF no ouro) | Cliente |
| **B. DS no documento** | 8 a 15 | `.docs/DESIGN_SYSTEM.md` com fundamentos, peças de domínio, lista de componentes, matriz de estados e padrões de tela | Cliente aprova; agente escreve |
| **C. DS no canvas** | 16 a 24 | Variáveis, prancha Fundamentos, Componentes no tema principal, Rascunho separado (+ segundo tema no ouro) | Cliente valida cada bloco |
| **D. Telas** | — | Tela-prova, demais telas, conferência cruzada | Skill `design-system-apply` |

Regra de ouro: **marca manda na cor e na fonte; o DS manda na tela; a tela revela o que falta no DS.**

---

## Parte A — Manual da marca

### Passo 1 — Pré-requisitos

- **Entrada:** nome do produto confirmado por escrito (nunca batizar por áudio), persona, tom, superfícies do produto (ex.: site, app, extensão, painel) e lista de telas.
- **Gate:** sem nome confirmado ou sem superfícies conhecidas → não começa.

### Passo 2 — Essência

- **O que fazer:** escrever em poucas linhas o que a marca faz, 3 a 4 pilares, como deve parecer e como **não** deve parecer.
- **Critério:** um leigo entende o produto só lendo essa seção.

### Passo 3 — Logo

- **O que fazer:**
  1. Símbolo + wordmark (nome desenhado).
  2. Versões: lockup horizontal, ícone do app e favicon nos tamanhos reais de cada superfície (ex.: 16, 32, 48, 128).
  3. Versão para fundo escuro e para fundo claro.
  4. Versão simplificada para o menor tamanho (detalhe fino some em 16 px).
- **Quem desenha:** designer ou ferramenta de desenho. A IA não desenha logo final com formas soltas. Sem logo → espaço reservado marcado + manual **provisório**.
- **Validação:** rodadas lado a lado num quadro de validação. Nunca apagar as rodadas; elas vão para o Rascunho.
- **Critério:** legível no menor tamanho; funciona no escuro e no claro.

### Passo 4 — Cores da marca

- **O que fazer:** poucas cores, cada uma com papel. Estrutura típica: um tom escuro de base, uma cor principal, um neutro claro e um fundo claro.
- **Obrigatório:**
  - medir contraste de cada combinação; se branco sobre a cor principal falhar, o texto sobre ela passa a ser o tom escuro da marca;
  - dizer o que é proibido (ex.: cores de outro produto da mesma empresa);
  - toda proibição diz **onde** vale. “Sem a cor X” é ambíguo: no produto inteiro, só no logo, só no fundo?
- **Critério:** uma cor principal só; contraste de 4,5 para 1 em texto normal e de 3 para 1 em texto grande, bordas e ícones de uso.

### Passo 5 — Tipografia da marca

- **O que fazer:** famílias e papéis. Estrutura típica: uma família para títulos e textos e, se o produto mostra muitos números ou dados, uma monoespaçada para eles.
- **Critério:** no máximo 2 famílias; pesos definidos.

### Passo 6 — Regras de uso

- **O que fazer:** respiro mínimo em volta do logo, faz/não faz (não esticar, não girar, sem sombra no logo, detalhes decorativos só onde o manual permitir).
- **Critério:** cada regra com exemplo visual certo e errado.

### Passo 7 — Fechar o manual

- **Saída (essencial):** prancha “Manual da marca” no canvas. Se já existe PDF oficial, a prancha espelha o PDF (mesmo conteúdo, sem inventar).
- **Saída (ouro):** PDF do manual v1.0 gerado a partir da prancha.
- **Gate:** cliente declara “oficial”. Enquanto não for oficial, o DS avança marcado como **provisório**. Manual existente mas ainda não oficial ≠ manual inexistente: o primeiro deixa o DS avançar como provisório; o segundo bloqueia (passo 8).
- **Nota:** a prancha do manual é página de apresentação. Ela **não** segue as regras de tela do DS (tamanhos, cantos, variáveis) e não passa por auditoria de tela. **Mas segue a composição do gosto geral** (`ui-gosto` parte geral — ex.: §6.6 ícone e selo na linha do título, nada de linha desperdiçada). Antes de entregar a prancha: olhar cada bloco procurando ícone/selo sozinho numa linha.

---

## Parte B — Design System no documento

### Passo 8 — Inventário de fontes

- **O que fazer:** listar o que existe: manual da marca, protótipo (telas em texto), superfícies, referências, telas prontas se houver (modo Extrair).
- **Gate:** sem manual da marca → **bloqueado**. DS sem marca é chute.

### Passo 9 — Referência padrão-ouro

- **Referência principal:** o deck de referência ([exemplos/deck-referencia-estrutura.md](exemplos/deck-referencia-estrutura.md)). Tem a ordem de capítulos certa e **todos os componentes considerados essenciais** (base da Faixa 1 do catálogo).
- **Lei anti-cópia:** do deck se copia só a **estrutura** (capítulos, lista de componentes, matriz de estados, “Faça / Evite”, tela final montada com o guia). Cores, fontes, nomes e peças do domínio dele são proibidos em outro produto.
- **Ordem dos capítulos:**

| Capítulo | Conteúdo |
|----------|----------|
| 00 Introdução | Objetivo, como usar, sumário |
| 01 Identidade visual | Cores da marca, escala neutra, escalas de interface, cores de status, regras de uso da cor |
| 02 Tipografia | Famílias, hierarquia de títulos, texto e interface, boas práticas |
| 03 Espaçamento e grid | Escala de espaçamento, grid e margens, densidade e respiro interno dos componentes |
| 04 Bordas, raios e sombras | Cantos, bordas, sombras e elevação |
| 05 Ícones | Biblioteca, traço e grade |
| 06 Componentes | Faixa 1 do catálogo |
| 07 Estados | Matriz de estados |
| 08 Regras gerais | Boas práticas, o que evitar, uma tela real montada só com o guia |

- **Se o deck for trocado:** vale a lista de capítulos e de grupos de componentes deste roteiro e do catálogo, não a numeração de slides.
- **Apoio (opcional):** design systems públicos (Polaris, Carbon, Material, One UI) para tirar dúvida de como documentar um componente.

### Passo 10 — Fundamentos

Escrever no `DESIGN_SYSTEM.md`, na ordem dos capítulos 01 a 05, cada valor com **porquê** e **fonte** (marca ou inferido):

| Capítulo | Fundamento | O que precisa ter |
|----------|------------|-------------------|
| 01 | **Cores da marca** | As cores oficiais do manual, com papel de cada uma |
| 01 | **Escala neutra** | Cinzas para texto, bordas e superfícies |
| 01 | **Escalas de interface** | Superfícies em degraus (fundo → faixa → card → dentro do card → passar o mouse), ação, acento |
| 01 | **Cores de status** | Sucesso, erro, alerta, informação |
| 01 | **Regras de uso da cor** | Proporção (cor principal só em ação e destaque), contraste (4,5 para 1 em texto normal; 3 para 1 em texto grande, bordas de campo, ícones de uso e foco), “Faça / Evite” |
| 01 | **Dois temas** | Mesmos papéis, valores diferentes para dark e claro; no claro, cor de texto e ícone numa versão mais escura da mesma cor |
| 02 | **Famílias** | Fontes e papel de cada uma |
| 02 | **Hierarquia de títulos** | Display e títulos, com tamanho, peso e altura de linha, no computador **e** no celular |
| 02 | **Texto e interface** | Corpo, rótulo, placeholder, legenda, dado, número; só 3 pesos |
| 02 | **Boas práticas** | Como aplicar a escala, “Faça / Evite” |
| 03 | **Escala de espaçamento** | Base de 4 (ex.: 4, 8, 12, 16, 24, 32, 48, 64) + **mapa de uso** + **medidas fixas nomeadas** (altura de botão, área de toque, janela fixa) |
| 03 | **Pontos de quebra** | Larguras em px de cada faixa (celular, tablet se houver, computador) e **o que muda** em cada uma (colunas, margem, menu, filtros) |
| 03 | **Grid e margens** | Por ponto de quebra: tela de referência, largura do conteúdo, margem lateral, colunas por tipo de conteúdo, espaço entre colunas, respiro de seção. Computador **e** celular, nunca só um |
| 03 | **Densidade e respiro interno** | Respiro dentro de card, botão, campo, chip, janela |
| 04 | **Cantos** | Pequeno / padrão / destaque / modal / redondo, com uso de cada um |
| 04 | **Bordas** | Espessura e cor: borda comum, borda de campo, foco, seleção |
| 04 | **Sombras e elevação** | Sombra só em camada flutuante; proibido brilho |
| 05 | **Ícones** | Biblioteca, traço, tamanhos |
| — | **Movimento e acessibilidade** | Durações, “reduzir movimento”, foco visível, área de toque |

- **Armadilha comum:** escrever o mapa de espaçamento antes das telas e nunca conferir. A margem real acaba diferente do documento. **Margem, grade e pontos de quebra são decididos aqui e conferidos na primeira tela-prova (Apply), no computador e no celular.**

### Passo 11 — Peças e cores do domínio

- **O que fazer:** as peças que só este produto tem (indicadores próprios, notas, selos, status de processo), decididas com o cliente, uma por vez, com eco → confirma → grava.
- **Critério:** a cor comunica o significado certo. Ex.: o melhor resultado leva a cor da marca, não vermelho, que se lê como erro; uma escala de nota não mistura cor de erro com cor de “bom”.

### Passo 12 — Lista fechada de componentes (por faixa)

- **O que fazer:** montar a lista do produto a partir do [catálogo](catalogo-componentes.md):
  1. **Faixa 1 — Essenciais:** os 13 grupos do deck de referência; entram todos e na conversa só se confirmam as variações.
  2. **Faixa 2 — Média:** cada item é perguntado (sim / não / depois), apontando a tela que usaria. (Completa = ouro.)
  3. **Faixa 3 — Avançada:** só entra se uma tela exigir; sem tela, fica proibida.
  4. **Faixa D — Domínio:** sai das telas e do passo 11, com eco → confirma → grava.
- **Saída:** tabela no `DESIGN_SYSTEM.md` com cada componente, a faixa, as variações e a tela onde aparece; mais a lista de **proibidos por enquanto**.
- **Lei de prompt:** nunca pedir à IA para “corrigir” ou “simplificar”. Dar lista fechada: o que está na lista fica, o resto sai. Sem isso, a IA do canvas tende a criar dezenas de componentes que ninguém pediu.

### Passo 13 — Matriz de estados

- **O que fazer:** para cada componente da lista do passo 12, uma linha; para cada estado, uma coluna — capítulo 07. Definida **antes** de desenhar qualquer componente, para que cada peça já nasça com todos os estados.
- **Estados de componente:** normal, passar o mouse, foco, pressionado, desabilitado, carregando, erro (marcar “não se aplica” onde não couber).
- **Estados de tela:** vazio, carregando (esqueleto no formato do conteúdo), erro, falha parcial, sem permissão ou sem saldo, sem resultado.
- **Critério:** nenhuma célula em branco.

### Passo 14 — Padrões de tela

- **O que fazer:** para cada tela, um `P-…` com o que entra, em que ordem e o que é proibido (ex.: um botão principal por seção). Mais os patterns A–D/F do GATE ACCEPT.
- **Critério:** todas as superfícies cobertas (site, app, extensão, janelas, estados), em cada ponto de quebra que a superfície tiver.

### Passo 15 — Gate do documento (“fechado até o momento”)

- **O que fazer:** GATE Q fechado + checklist de aceite + anti-contradição (a mesma coisa não pode ter dois valores).
- **Saída:** DS **fechado até o momento**: vale como lei para começar o canvas, mas não é escrito em pedra. O canvas (Parte C) e as telas (Apply) vão revelar faltas e erros.
- **Como reabrir:** cada mudança vinda do canvas ou das telas entra no documento com nova versão na tabela de versões e com o motivo. Nunca corrigir só no canvas ou só na tela.

---

## Parte C — Design System no canvas

Conectar a ferramenta antes: [canvas-ferramentas.md](canvas-ferramentas.md).

### Passo 16 — Variáveis antes de qualquer peça

- **O que fazer:** criar no arquivo de design todas as variáveis com prefixo próprio (ex.: `ds-*`), com valor para dark e claro.
- **Lei:** nenhuma peça oficial usa cor digitada. É isso que permite criar o segundo tema depois sem redesenhar.

### Passo 17 — Prancha “Fundamentos”

- **O que fazer:** desenhar os fundamentos do passo 10 na ordem dos capítulos 01 a 05: amostras de cor por papel (com variável e valor), escala de tipografia com exemplos reais do produto, régua de espaçamento, medidas fixas, desenho de margem e grade **no computador e no celular**, pontos de quebra, cantos, bordas, sombras e ícones.
- **Por quê aqui:** quem abre o canvas precisa enxergar a base antes dos componentes.
- **Armadilha comum:** deixar essa prancha para o fim. Quem abre o canvas acha que o DS não tem espaçamento nem paleta, mesmo estando tudo no documento.

### Passo 18 — Construir os componentes no tema principal

- **O que fazer:** uma prancha “Componentes (tema principal)”, um grupo por assunto (marca, ações, formulário, sinais, conteúdo, camadas e avisos, estrutura), nomes com prefixo (ex.: `DS / Botão / Primário`). Só entram os componentes da lista do passo 12, cada um com os estados da matriz do passo 13.
- **Matriz no canvas:** um bloco que mostra, para cada componente, os estados lado a lado, espelhando a tabela do passo 13.
- **Lei:** tema principal primeiro (dark por padrão). O outro tema só depois do primeiro aprovado (passo 24, ouro).

### Passo 19 — Auditoria visual peça por peça

- **O que fazer:** abrir e **olhar** cada componente, não contar. Conferir contraste, estados faltando, tamanho de logo, botão de fechar, texto cortado.
- **Armadilha comum:** auditoria rápida que conta peças em vez de olhar. Auditoria com pressa é refeita.

### Passo 20 — Peças do domínio por variações

- **O que fazer:** para a peça central do produto (normalmente o card do item principal: produto, anúncio, imóvel, vaga, pedido), criar **variações lado a lado** (A, B, C…), escolher com o cliente, iterar. Computador **e** celular. Estados fechado e aberto.
- **Também aqui:** logos de terceiros como componentes (parceiros, meios de pagamento, integrações, fornecedores), em dark e claro.
- **Leis:**
  - nunca apagar as opções não escolhidas; vão para o Rascunho;
  - o conteúdo principal vem antes do secundário (ex.: nome do item mais forte que o nome de quem vende);
  - espaço vazio só por causa de um ícone é defeito;
  - cada escolha vira texto no DS na mesma rodada.

### Passo 21 — Varredura das telas → componentes faltantes

- **O que fazer:** percorrer todas as telas do protótipo (ou telas existentes, no modo Extrair) e listar o que falta, **sem implementar**. Cliente escolhe o que entra. Depois implementar, com linha nova na lista do passo 12 e na matriz do passo 13.
- **O que costuma aparecer:** peças da Faixa 2 que ninguém lembrou (campo de código, avatar, botão de ícone, gaveta) e peças de domínio (histórico, resultados de busca, painéis de detalhe).

### Passo 22 — Auditoria contra as leis do DS

- **O que fazer:** varrer todos os componentes oficiais: só variáveis, só 3 pesos, só tamanhos da escala, espaçamento da escala, cantos da tabela, contraste (4,5 para 1 em texto normal; 3 para 1 em texto grande, bordas de campo, ícones de uso e foco), um botão principal por bloco, sem brilho.
- **Critério:** zero exceção sem nome no documento.

### Passo 23 — Organização Oficial × Rascunho

- **O que fazer:**
  - no topo, só o oficial: Manual da marca, Fundamentos, Componentes (e o segundo tema, se houver);
  - todo o resto numa área “Rascunho” (nomes “Rascunho · …”);
  - o oficial não pode depender de nenhuma peça do rascunho;
  - nada é apagado.

### Passo 24 — Segundo tema (ouro)

- **O que fazer:** “Fundamentos” e “Componentes” no segundo tema feitos de **instâncias** do tema principal com o outro tema ligado (mudar no principal muda no segundo). Conferir contraste com as mesmas regras do passo 22 e ajustar só as cores de texto e ícone.
- **Documento:** cada decisão do canvas entra no `DESIGN_SYSTEM.md` com nova versão na tabela de versões e no parágrafo “Oficial × rascunho”.

---

## Erros comuns × ordem certa

| Tema | Erro comum | Ordem certa |
|------|------------|-------------|
| Marca antes do DS | Forjar o DS sem manual da marca | Manual primeiro (Parte A); sem ele, bloqueado |
| Quantidade de componentes | IA do canvas cria dezenas de peças sem pedido | Lista fechada por faixa no documento, antes de desenhar (passo 12) |
| Estados | Componentes desenhados e estados lembrados depois | Matriz de estados antes de desenhar (passo 13) |
| Documento “pronto” | Tratar o gate do documento como escrito em pedra | Fechado até o momento; canvas e telas reabrem com nova versão (passo 15) |
| Variáveis | Cores digitadas nas primeiras peças | Variáveis antes de qualquer peça (passo 16) |
| Fundamentos no canvas | Prancha feita por último | Logo depois das variáveis (passo 17) |
| Margem e grade | Decididas nas telas; documento diz outra coisa; só computador | Decididas no passo 10 para cada ponto de quebra e conferidas na tela-prova (Apply) |
| Contraste | Uma regra só (4,5) para tudo | 4,5 para 1 em texto normal; 3 para 1 em texto grande, bordas de campo, ícones de uso e foco |
| Peça central | Escolhida na primeira tentativa | Variações lado a lado até o cliente escolher (passo 20) |
| Temas | Fazer dark e claro ao mesmo tempo | Tema principal aprovado primeiro, depois o outro (ouro) |
| Rascunho | Misturado com o oficial | Separado desde o início |
| Auditoria | Contar peças em vez de olhar | Olhar peça por peça, duas passagens |

## Por que esse caminho gera telas boas

1. **Marca decidida antes:** uma cor principal só, contraste medido, fontes definidas.
2. **Variáveis em tudo:** o segundo tema sai de graça e não existe cor solta.
3. **Lista fechada por faixa e estados definidos antes:** poucas peças, bem feitas e completas.
4. **Peça central escolhida por variações:** o cliente escolhe, não recebe imposto.
5. **Leis escritas e auditadas:** pesos, tamanhos, espaçamento e cantos fechados; qualquer desvio aparece.
6. **Telas montadas só com peças oficiais (Apply):** a tela não inventa; se falta algo, o DS ganha a peça.
7. **Documento vivo com versão:** fechado até o momento, reaberto com motivo.
8. **Nada apagado:** as opções ficam no Rascunho e podem ser retomadas.
