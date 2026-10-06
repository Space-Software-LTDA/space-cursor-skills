# Playbook — Fase 8.5 Protótipo navegável

> Molde pronto em [`molde/`](molde/): o **motor** (shell, navegação, servidor, scripts) é igual em todo produto; a fase só preenche **`screens.js`** (quais telas) e **`rotas.js`** (o que cada botão abre) e exporta as telas do canvas.  
> Barra: [`target-model.md`](target-model.md) · Caso real: [`examples/README.md`](examples/README.md)

**Agent:** [`AGENT.md`](AGENT.md)

## Header

```text
**Fase 8.5 — Protótipo navegável**
**Objetivo:** exportar as telas aprovadas e ligar os botões num site navegável para apresentar
**ON:** F2 (+ F6 no gate)
```

## O que o cliente recebe

- **Abre no Manual da marca**, com o botão **“Iniciar protótipo”** no canto (e no topo, em toda página de documentação; Enter também inicia). Iniciar leva à Home do dispositivo escolhido.
- **Barra lateral** com todas as páginas, agrupadas como no canvas: primeiro “Marca e Design System” (Manual da marca, logo original, Fundamentos, Componentes, Rascunho), depois um grupo por seção de telas. Seletor **Computador | Celular** no topo da lista.
- **Barra do topo:** ☰ (esconde/mostra a lista) · ← → (histórico) · título e subtítulo da tela (grupo · tamanho · logado/deslogado) · **Clicáveis** (realça as áreas que funcionam; tecla H) · livro (volta ao Manual) · abrir a tela sozinha.
- **Telas clicáveis:** cada botão leva à tela certa; modal/gaveta fecha clicando fora ou no X; telas “gerando…” avançam sozinhas; ação sem tela mostra um aviso curto. Clique fora de área clicável pisca as áreas.
- **Teclas:** H clicáveis · ← → telas da lista · D troca o dispositivo · Enter inicia.
- **Roda com** `npm run prototipo:start` (porta 4173; `PORT=8080` para outra) — o mesmo comando sobe num servidor para apresentar.

## Pré-requisitos

- Fase 8 **fechada** ou adiada com risco: `telas.md` com a lista de telas aprovadas e onde estão no canvas  
- Canvas conectado (Pencil por padrão); outra ferramenta precisa exportar **um HTML por frame** com o nome dos layers (ver “Outra ferramenta de canvas”)  
- Node 18+ na máquina  
- Sem isso → voltar à Fase 8 ou pedir a conexão

## Passo a passo

### 1) Copiar o molde

1. Copiar a pasta [`molde/`](molde/) inteira para `prototipo/` na raiz do workspace (fora do `docs/`).  
2. No `package.json` da raiz (criar um mínimo com `"private": true` se não existir), acrescentar:

```json
"scripts": {
  "prototipo:start": "npm --prefix prototipo start",
  "prototipo:preparar": "npm --prefix prototipo run preparar",
  "prototipo:verificar": "npm --prefix prototipo run verificar --"
}
```

(O `--` no fim do `verificar` deixa passar opções como `--telas` e `--inventario`.)

3. `npm --prefix prototipo install` (uma vez; só o verificar usa o `jsdom`). A pasta `prototipo/telas/` já vem no molde; é nela que o export grava.  
4. Se o workspace é git: `prototipo/node_modules/` no `.gitignore`. O resto de `prototipo/` é versionado (é o que vai para o servidor).

### 2) Inventário dos frames do canvas

No Pencil, com o arquivo do canvas aberto, listar os frames de topo (tool `execute`):

```js
Get(document,(n,c)=>{if(c.depth===0)Print(n.id,"|",n.name,"|",n.reusable?"componente":"",Math.round(c.bounds.width)+"x"+Math.round(c.bounds.height));c.skipChildren()})
```

Classificar cada frame:

| Frame | Vai para |
|-------|----------|
| Tela com superfície no nome (`… · computador 1440 …`, `… · celular 390 …`, extensão, app) | Grupo da seção dele no canvas, dispositivo `d` ou `m` |
| Manual da marca · arquivos originais (logo e ícone) · Fundamentos · Componentes · Rascunho/Draft | Grupo “Marca e Design System”, dispositivo `doc`, com a largura do frame |
| `Seção · …` (título de seção), frames sem nome, artes soltas, componentes | Fora do protótipo (o título da seção vira o nome do grupo) |

Conferir com `telas.md`: toda tela aprovada precisa estar na lista; tela no canvas que não está em `telas.md` → perguntar ao Controlador antes de incluir.

### 3) Montar o `screens.js`

Preencher `prototipo/screens.js` (o molde explica cada campo):

- **`PR_CONFIG`**: nome do produto; `destaque` = cor principal do `DESIGN_SYSTEM.md` (e `textoNoDestaque`); `inicio` = id do Manual da marca; `home` por dispositivo `[deslogado, logado]` (sem login: o mesmo id duas vezes); `imagensDoCanvas` = pasta `images/` ao lado do arquivo do canvas, relativa a `prototipo/`; `semLinkChegando` = telas abertas só pela lista (ex.: 404).  
- **`PR_GROUPS`**: um grupo por seção do canvas, na ordem do canvas. Cada tela: `[id, título, dispositivo, logado, tela de trás, gêmea, largura, altura]`.  
  - **Título** curto e humano, sem repetir o grupo nem o tamanho (“Login”, “Recuperar senha”, “Pagamento confirmado”). Tela que ainda não existe no produto → `" *"` no fim.  
  - **Tela de trás**: modal, gaveta e menu sobre uma tela → id dessa tela (é para onde o X e o clique fora levam). Tela cheia → `null`. No canvas, a tela de trás costuma aparecer no próprio frame como “Fundo · marcador (…)”.
  - **Janela solta** (o canvas tem a janela sozinha, sem a tela de trás nem o fundo escurecido desenhados — ex.: listas de modais por menu): um frame de topo só com a janela, a tela de trás preenchida (mesmo dispositivo) e a **largura da janela**, menor que a da tela de trás — é por isso que o shell sabe que é janela; com a mesma largura vira tela cheia. O shell monta a tela de trás escurecida com a janela por cima (clicar fora ou Esc volta). 9º campo opcional: `"centro"` (padrão), `"direita"` (gaveta, altura toda), `"baixo"` (gaveta de baixo do celular, presa na base e com a largura toda da tela — a única que pode ter a mesma largura da tela de trás) ou `[x, y]` (menu suspenso colado num botão; medidas a partir do canto de cima à esquerda da tela de trás, como no canvas). **Menu ou filtro da barra do topo** (existe em toda tela): desenhar aberto uma vez só e usar `"*"` como tela de trás — abre sobre a tela em que a pessoa está e fecha voltando para ela. Uma janela `"*"` aberta a partir de outra (ex.: gaveta do Menu → gaveta da busca) também fecha direto na tela de baixo — o X, o clique fora e o Esc levam ao destino `"fundo"`, que também pode ser usado em `rotas.js`.  
  - **Rolagem no celular:** desenhar a tela com a altura do aparelho e o miolo entre as barras fixas com recorte (clip). No protótipo, o motor faz rolar todo bloco que recorta conteúdo maior que ele — não esticar a tela no canvas para “caber tudo”.
  - **Gêmea**: a mesma tela no outro dispositivo; sem gêmea → `null` (a troca leva à Home do outro dispositivo).  
  - **Largura/altura**: só se fugir do padrão (computador 1440, celular 390×844). Extensão/app: tamanho real da superfície, dispositivo `m`.

### 4) Exportar

No Pencil (tool `execute`), com o caminho **absoluto** da pasta `prototipo/telas/`:

```js
const out="{caminho absoluto}/prototipo/telas/";
for (const id of [/* ids do screens.js */]) Export([id],"html-tailwind",out+id+".html",{includeLayerIds:true})
```

- Um arquivo por frame, com o **id do frame** como nome (`telas/<id>.html`).  
- **Só frame de topo** (frame solto no canvas, não dentro de outro), a **pelo menos 200 px** dos vizinhos: exportar uma peça de dentro de outro frame, ou frames muito próximos (menos de ~100 px), gera um arquivo em que o motor não acha a tela, e ela fica sem nenhum botão (o `preparar` avisa). Janela que só existe dentro de uma lista → criar uma fileira no canvas com um frame solto por janela, cada um com uma cópia da janela da lista que continua ligada ao componente.  
- `html-tailwind` gera HTML + Tailwind (CDN) com `data-pencil-name` em cada layer — é por esses nomes que o motor liga os botões.  
- As imagens não vão junto: o HTML aponta para `images/…` e os arquivos ficam na pasta `images/` ao lado do arquivo do canvas (o `preparar` copia).

### 5) Preparar

```bash
npm run prototipo:preparar
```

Copia as imagens do canvas, troca `images/` → `../images/`, corrige o `box-sizing` do export, injeta `screens.js` + `rotas.js` + `nav.js` em cada tela e avisa: tela do manifesto sem arquivo, arquivo sem manifesto, imagem que falta. Pode rodar quantas vezes quiser.

### 6) Escrever o `rotas.js`

1. Para cada tela, ver as peças com nome e texto:

```bash
npm run prototipo:verificar -- --inventario {id},{id}
```

2. Ler em `prototipo.md` o que cada botão faz e escrever em `prototipo/rotas.js`:
   - **`texto`** — rótulo do botão → destino. É a maioria: numa cópia de componente o nome do layer é o do **componente** (“Botão Primário”, “Rótulo”) e o que muda é o **texto**.  
   - **`nome`** — regras por nome de layer e contexto, para o que não tem texto: botão só-ícone (menu, compartilhar, voltar), card inteiro (produto, item de lista, promoção), logo do header, item da navegação inferior, abas. Use `inside(el, /^Header$/)` para limitar a uma região.  
   - **`auto`** — telas de transição que avançam sozinhas (“gerando…” → “pronto”).  
   - `pick(computador, celular)` escolhe a tela do dispositivo atual; `HOME`, `HOME_IN`, `HOME_OUT`, `CLOSE` já vêm prontos.  
3. O motor já resolve: fundo escurecido e X → tela de trás; o que está **atrás** do modal não é clicável; títulos não viram link; botão para a própria tela é ignorado; container cujo texto é igual ao de um botão **cede** quando tem dentro outro botão com destino diferente.  
4. Ação que não tem tela desenhada (copiar código, reenviar e-mail) → `"toast:Código copiado"`. Nunca mandar para uma tela “parecida”.  
5. Mesmo rótulo com destinos diferentes conforme a tela (ex.: “Entrar” do botão principal × “Entrar” da aba) → regra em `nome` olhando `S.id` e o contexto (`inside`).

### 7) Verificar

```bash
npm run prototipo:verificar                    # resumo
npm run prototipo:verificar -- --telas {id},{id}   # áreas clicáveis dessas telas
npm run prototipo:verificar -- --todas         # todas
npm run prototipo:verificar -- --soltos        # peças com cara de botão que não levam a lugar nenhum
```

Pronto quando: **nenhum destino inválido**, **toda tela alcançável** (fora `semLinkChegando`), **nenhum botão desenhado sem ligação** no `--soltos` — só pode sobrar peça que leva à própria tela, como a aba já aberta ou a página atual (o `--soltos` avisa, não reprova sozinho: conferir a lista) e a lista de áreas de cada tela bate com `prototipo.md` (conferir tela a tela: botão principal, voltar, fechar, menus, cards).

Motor intacto (o produto não mexeu no motor):

```bash
npm run prototipo:verificar -- --motor {pasta desta skill}/modules/08b-prototipo-navegavel/molde
```

### 8) Subir

```bash
npm run prototipo:start
```

Abre em `http://localhost:4173` no Manual da marca. Outra porta: `PORT=8080 npm run prototipo:start` (Linux/Mac) · `$env:PORT=8080; npm run prototipo:start` (Windows PowerShell). Em servidor, o mesmo comando; o `server.js` só entrega shell, telas, scripts públicos e imagens e não tem dependência.

### 9) Conferência visual (com prints desta sessão)

Abrir no navegador (navegador automático do agente; se não houver, pedir ao humano para abrir e mandar prints) e conferir:

- [ ] Abre no Manual da marca com o botão “Iniciar protótipo”; Iniciar leva à Home do dispositivo escolhido  
- [ ] Nenhuma tela com **barra de rolagem horizontal** ou peça vazando da largura (botão cortado na borda)  
- [ ] ☰ esconde e mostra a lista sem sumir com a tela  
- [ ] Computador ⇄ Celular leva à mesma tela no outro tamanho  
- [ ] Botão principal, voltar, fechar e clique fora de cada modal/gaveta; janela solta aparece **sobre** a tela de trás escurecida (nunca isolada)  
- [ ] “Clicáveis” (H) realça só o que funciona; nada atrás do modal realçado  
- [ ] Imagens carregam (fundo, capas, logo) e a fonte é a do Design System  
- [ ] Páginas de documentação inteiras e legíveis (reduzidas para caber)

Defeito **na tela** → Fase 8 corrige no canvas → reexportar (passo 4) → preparar. Defeito **no motor** → lista de correções → `/skill-update`.

### 10) Gate

Mostrar ao cliente rodando. Registrar em `docs/telas.md` (seção “Protótipo navegável”): data, comando, telas cobertas, ações que viraram aviso (sem tela), pendências. Atualizar `docs/README.md`.

| Resultado | Significado |
|-----------|-------------|
| **fechado** | Todas as telas aprovadas navegáveis; verificar sem erro; conferência visual ok; cliente aprovou |
| **adiado com risco** | Cliente segue com pendências listadas (tela sem link, ação só com aviso) |
| **bloqueado** | Canvas sem export, telas da Fase 8 incompletas, ou defeito visual que exige voltar à Fase 8 |

Subagente **encerra**. Commit/push só quando o cliente pedir.

## Atualizar o protótipo

O protótipo acompanha o canvas. Toda vez que uma tela muda depois da 8.5 (nova rodada da Fase 8, correção pedida pelo cliente, mini-A do Design System), atualizar **na mesma rodada**:

| O que mudou | O que fazer |
|-------------|-------------|
| **Tela alterada** no canvas | Reexportar só ela (passo 4 com o id) → `preparar` → `verificar -- --telas {id}`. Botão novo ou com outro texto → ajustar `rotas.js` |
| **Tela nova** | Linha no `screens.js` (grupo, dispositivo, logado, tela de trás, gêmea; e a gêmea apontando de volta) → exportar → `preparar` → regras em `rotas.js` para os botões que **levam** a ela e para os botões **dela** → `verificar` (ela não pode ficar isolada) |
| **Tela removida ou trocada por outra** | Tirar a linha do `screens.js` e apagar `telas/<id>.html` → `verificar` acusa todo botão que apontava para ela → corrigir `rotas.js` |
| **Frame recriado no canvas** (id mudou) | Trocar o id no `screens.js` e no `rotas.js` (buscar o id antigo) e renomear o arquivo exportando de novo |
| **Componente ou variável do Design System** | Reexportar **todas** as telas (a mudança aparece em todas) → `preparar` → `verificar` |
| **Manual da marca / Fundamentos / Componentes** | Reexportar a página de documentação |
| **Molde novo na skill** (`PR_MOLDE_VERSAO` maior que o do rodapé da lista) | Copiar por cima **só o motor**: `index.html`, `nav.js`, `server.js`, `scripts/`, `package.json`, `LEIA-ME.md`. **Nunca** `screens.js`, `rotas.js`, `telas/`, `images/`. Depois `preparar` + `verificar` |

Depois de qualquer atualização: `verificar` sem erro + print das telas mexidas.

## Armadilhas conhecidas

| Armadilha | Sintoma | O que fazer |
|-----------|---------|-------------|
| Export com `box-sizing: content-box` | Bloco com padding fica maior que o desenhado: botão cortado na borda, rodapé mais largo e mais alto | O `preparar` troca por `box-border` (no canvas, largura e altura já incluem o padding) |
| Barra de rolagem dentro da tela | Scroll horizontal no computador (a barra come ~15px dos 1440) | O motor esconde as barras e trava o eixo X; não mexer na largura do frame |
| Imagens “sumidas” | Fundo/capa sem imagem | Conferir `imagensDoCanvas` e rodar `preparar` de novo (ele avisa a imagem que falta). A pasta pode ter outro nome ao lado do canvas (`imagens/`): o `preparar` usa o nome do fim de `imagensDoCanvas` |
| Janela abre isolada | Clicar num botão que abre modal mostra só a janela, sem a tela de trás | Canvas sem o fundo escurecido desenhado: preencher a tela de trás e a largura da janela no `screens.js` (janela solta); o shell monta a tela de trás por baixo |
| Tela sem nenhum botão | `verificar -- --telas` mostra 0 áreas; `preparar` avisa “sem o frame na raiz” | Exportou um nó que não é de topo, ou frames próximos demais: reexportar o frame de topo, afastado 200 px |
| Nome do layer ≠ texto | Regra por nome não pega o botão | Numa cópia de componente o nome é o do componente; usar a regra por **texto** |
| Botão só-ícone | Não aparece no “Clicáveis” | Regra por **nome** (`--inventario` mostra o nome) |
| Container engolindo botões | Rodapé com “Comprar” + ícone de favoritar: tudo vira “Comprar” | O motor já cede quando há destinos diferentes dentro; se ainda acontecer, regra por nome no botão menor |
| Rascunho vazio | Página só com título | Normal quando tudo foi validado; entra assim mesmo |
| Telas logado × deslogado | Botão “Assinar”, numa tela logada, leva a um modal desenhado sobre o fundo deslogado | É o que está no canvas; registrar como pendência da Fase 8 se o cliente quiser a variação |
| Sem navegador automático no agente | Não dá para tirar print | `verificar` cobre os links; a conferência visual é do humano (pedir prints) |
| Fonte/Tailwind por CDN | Protótipo sem internet fica sem estilo | Apresentar com internet, ou avisar o cliente |

## Outra ferramenta de canvas

O motor só precisa de: um HTML por frame, nomeado pelo id, com o nome de cada layer num atributo `data-pencil-name` e o frame de topo como filho direto do `<body>` com `data-pencil-id`. Ferramenta que exporte HTML de outro jeito → converter para esse formato antes do `preparar` (pedir ao humano; não inventar export).

## O que NÃO fazer

- Editar `telas/*.html` à mão para “consertar” uma tela — conserto é no canvas  
- Mexer no motor dentro do produto em vez de mandar a melhoria para a skill  
- Pôr o protótipo dentro de `docs/`  
- Ligar botão para tela “parecida” quando a tela certa não existe (usar aviso)  
- Mostrar ao cliente sem rodar o `verificar` e sem conferência visual  
- Esquecer o Manual da marca e o botão Iniciar (o protótipo **abre** nele)  
- Abrir a Fase 9 (Revisão) na mesma conversa
