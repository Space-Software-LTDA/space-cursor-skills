# Ferramenta de canvas — opções de conexão

> Usado pelo **Forge** (Parte C) e pelo **Apply** (varredura e correção de telas). O roteiro não depende de uma ferramenta.  
> **Padrão da casa:** Pencil. Construtor de app com IA (ex.: Lovable) fica como opção secundária para projetos antigos.

## Opções

| Opção | Quando usar | Como conectar | Cuidados |
|-------|-------------|---------------|----------|
| **Ferramenta local, agente na mesma máquina** | Pessoa e agente no mesmo computador | Servidor MCP da ferramenta configurado direto no editor | Ferramenta aberta com o arquivo certo |
| **Ferramenta local, agente remoto** | Ferramenta no computador da pessoa; agente numa máquina remota | Ponte + túnel (detalhe abaixo) | Fechar ponte e túnel ao terminar |
| **Ferramenta na nuvem com MCP oficial** | Ferramenta web que oferece servidor MCP próprio | Configurar a URL e a autenticação do MCP no editor | Permissão de edição no arquivo; limite de uso da conta |
| **Construtor de app como canvas** (secundário) | Projeto antigo cujas telas vivem num construtor de app com IA | Ferramenta ou API do construtor | Tela vira código: separar Oficial × Rascunho por página ou projeto; tokens no tema do app |
| **Sem conexão direta** | Ferramenta sem MCP ou sem acesso do agente | Pessoa exporta prints ou o arquivo; agente lê e devolve instruções | Agente não edita; cada rodada depende da pessoa |

## Detalhe — ferramenta local, agente remoto

- **Ponte no computador local:** expor o servidor MCP da ferramenta de design numa porta (ex.: `npx -y supergateway --stdio "<comando do servidor MCP>" --port <porta>`).
- **Túnel:** levar a porta até a máquina remota (ex.: `ssh -R <porta>:127.0.0.1:<porta> <máquina>`).
- **Teste na máquina remota:** `curl -s -N --max-time 4 -H "Accept: text/event-stream" http://127.0.0.1:<porta>/sse` deve devolver `event: endpoint`.
- **Editor não vê a ferramenta mesmo com o túnel no ar:** recarregar a janela ou desligar e ligar o servidor MCP nas configurações.
- **Fechar ao terminar:** encerrar a ponte e o túnel.

## Cuidados gerais no canvas

- **Evidência:** print de cada prancha/tela depois de editar (a varredura do Apply usa esses prints).
- **Peças criadas que não aparecem no print:** trocar o nó por ele mesmo (substituir pelo próprio conteúdo, sem ids). **Não** copiar a prancha para “forçar o desenho”: em algumas ferramentas a cópia transforma instâncias em frames soltos e quebra o vínculo com o componente.
- **Tamanho real:** telas no tamanho da superfície (ex.: 1440 computador, 375 celular, popup de extensão com largura fixa e altura máxima da plataforma).
- **Sem conexão:** Parte C do Forge e Fase C do Apply ficam **bloqueadas** — reportar e pedir a conexão; não fingir edição.
- **Organização:** pranchas do DS à esquerda; telas em fileiras por fluxo, cada fileira com um rótulo “Seção · …”; referências do site (navegador ao vivo, capturas “Captura · …”) separadas à direita e **removidas depois que o humano valida as telas**. No fim de cada rodada, conferir se alguma prancha foi deslocada sozinha.
- **Scripts em lote:** rodar um bloco por vez e conferir o resultado antes do próximo. Bloco rodado duas vezes cria duplicatas; procurar e apagar na mesma hora.

## Pencil — armadilhas conhecidas

Valem para o Pencil; em outra ferramenta, testar antes de assumir.

| Situação | O que acontece | Como contornar |
|----------|----------------|----------------|
| Imagem por URL `http` | Não desenha | Usar arquivo relativo ao `.pen` (pedir ao humano para pôr na pasta do arquivo) ou importar pelo nó de navegador |
| Trazer peça real de um site | — | Nó de navegador com o site (largura de computador e de celular) → importar por seletor. Vem com camadas editáveis, cor em hex e imagens. Depois: cor → variável mais próxima, raio → variável, SVG → ícone da biblioteca, camadas renomeadas pelo conteúdo (sem “div”/“span”) |
| Overlay que só abre com clique (modal, gaveta, menu) | O nó de navegador não clica por você | Pedir ao humano para deixar o overlay aberto no navegador do Pencil e importar dali |
| Imagem com carregamento tardio fora da tela | Vem vazia | Rolar até ela antes de importar, ou registrar como lacuna |
| Largura/altura com variável | Não aceita | Número igual ao token (ex.: 40 = `control-h`) e anotar no documento |
| Mudar a altura do componente depois de ter instâncias | Instâncias antigas ficam com a altura velha | Conferir: altura da instância = altura do componente (salvo estado que muda de tamanho de propósito) |
| Prancha acima de ~8.000 px de altura | Para de desenhar o conteúdo | Dividir em duas pranchas |
| Frame novo | Nasce com layout horizontal | `layout: none` em telas com camadas sobrepostas (fundo + véu + modal) |
| Frame montado peça a peça | Às vezes fica deslocado ~50 px ou desenha vazio | Montar a árvore numa inserção só; se já aconteceu, substituir o nó raiz pelo próprio conteúdo |
| Instância inserida depois, num frame existente | Às vezes não desenha | Substituir a instância por ela mesma |
| Mudança em componente aninhado | Às vezes não aparece no print de uma instância já existente | Recriar a instância (o dado está certo) |
| Copiar nós | Instâncias viram frames soltos | Não usar cópia para reaproveitar tela; montar com instâncias novas |
| Inserir em posição | Índice ignorado | Inserir e depois mover para o índice |
| Trocar o componente de uma instância | O vínculo não é editável | Substituir o nó por uma instância nova do outro componente, mesmo tamanho |
| Substituir um componente que tem instâncias | Pode falhar | Inserir o novo, reapontar/mover, apagar o antigo |
| Remover efeito | `null` é inválido | Lista vazia (`effect: []`) |
| Proporção fixa (`aspect-ratio`) | Não existe | Altura = largura × razão (ex.: 8:3 → largura × 3 ÷ 8), anotada no documento |
| Desfoque de fundo copiado do CSS | O raio do Pencil desfoca menos | CSS `blur(8px)` ≈ raio 16 no Pencil; comparar com o print do site |
| Sublinhado de texto | Não é guardado | Borda inferior de 1 px no texto |
| Fonte monoespaçada do site ausente | Largura diferente do site | Medir largura por caractere no site e escolher a substituta mais próxima |
| Logo de terceiro (ex.: Google) | Sem ícone de marca na biblioteca | Desenhar com caminhos SVG oficiais (um por cor), nunca letra provisória |
| Print de nó largo | Sai reduzido (~400 px) | Tirar print de blocos menores para conferir detalhe |
