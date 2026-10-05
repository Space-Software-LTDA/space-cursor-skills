# Catálogo de componentes por faixa

> Base do passo 12 do [roteiro](roteiro.md) e da pergunta Q18 do Forge. Cada projeto tem suas necessidades, mas a conversa sempre parte desta lista.

## Como conduzir na conversa

| Faixa | Pergunta ao cliente | Regra |
|-------|---------------------|-------|
| **1 — Essenciais** | “Estes entram (lista do deck de referência). Alguma variação a mais ou a menos?” | Entram sempre. Ninguém discute se existem, só como. |
| **2 — Média** | Um item por vez ou lista de marcar: “Vai ter? Em qual tela?” | Sim só com tela apontada. “Depois” fica anotado como aberto. Faixa 2 completa = nível ouro. |
| **3 — Avançada** | O agente só pergunta se uma tela pedir | Sem tela que exija → proibido nesta versão. |
| **D — Domínio** | “Na tela X aparece Y. Isso é uma peça própria do produto?” | Nome só depois do eco → confirma. Variações lado a lado (roteiro, passo 20). |

**Toda peça, de qualquer faixa, define:** variações, estados (linha na matriz de estados), versão dark e clara, e tela onde aparece.

## Faixa 1 — Essenciais (13 grupos do deck de referência)

Lista do capítulo 06 do [deck de referência](exemplos/deck-referencia-estrutura.md). Todo site ou app tem. Teto: não criar variações além das listadas sem pedido. A coluna “Slide” só ajuda a achar o exemplo no deck atual; o que vale é o grupo.

| Grupo | Componente | O que é | Variações mínimas | Slide |
|-------|------------|---------|-------------------|-------|
| Botões — variantes | Botão | Ação clicável, da conversão ao link | Primário · secundário (contorno) · fantasma · destrutivo · link | 26 |
| Botões — estados e tamanhos | Botão | Resposta ao toque e tamanhos | Estados da matriz · tamanhos que o produto usar (mínimo 1) | 27 |
| Campos de texto | Campo de texto | Entrada com rótulo, ajuda e mensagem de erro | Padrão · senha · erro · sucesso · desabilitado | 28 |
| Outros controles de entrada | Select | Lista de opções fechada | Padrão · aberto · erro · desabilitado | 29 |
| Outros controles de entrada | Área de texto | Campo de várias linhas | Padrão · erro · desabilitado | 29 |
| Outros controles de entrada | Campo de busca | Entrada com lupa | Padrão · foco · com texto · desabilitado | 29 |
| Seleção | Checkbox | Marcar vários | Marcado · desmarcado · indeterminado · desabilitado | 30 |
| Seleção | Radio | Escolher um entre poucos | Marcado · desmarcado · desabilitado | 30 |
| Seleção | Switch | Ligar / desligar | Ligado · desligado · desabilitado | 30 |
| Badges e chips | Badge | Rótulo curto de status ou tipo | Uma por status que o produto usar | 31 |
| Badges e chips | Chip | Pílula selecionável (filtro, atributo) | Normal · selecionado · com remover | 31 |
| Cards | Card de conteúdo | Contêiner genérico de conteúdo | Padrão · passar o mouse | 32 |
| Cards | Card de domínio | O card do item principal do produto | Sai da Faixa D (roteiro, passo 20) | 32 |
| Modais e tooltips | Modal | Janela de decisão sobre a tela, com fundo escurecido | Padrão · confirmação | 33 |
| Modais e tooltips | Tooltip | Microajuda ao passar o mouse | Padrão | 33 |
| Dropdowns e menus | Menu suspenso | Lista de ações ou navegação contextual | Padrão · com ícone · item destrutivo | 34 |
| Tabelas e paginação | Tabela | Dados em linhas e colunas | Cabeçalho · linha · linha passar o mouse | 35 |
| Tabelas e paginação | Paginação | Navegar entre páginas de uma lista | Numérica · “Mostrar mais” | 35 |
| Abas e breadcrumbs | Abas | Trocar de visão na mesma página | Ativa · inativa | 36 |
| Abas e breadcrumbs | Caminho (breadcrumb) | “Início › Categoria › Item” | Padrão | 36 |
| Toasts e alertas | Toast | Mensagem temporária | Sucesso · alerta · erro · informação | 37 |
| Toasts e alertas | Alerta (aviso fixo) | Mensagem contextual que fica na tela | Sucesso · alerta · erro · informação | 37 |
| Espera e ausência | Loading | Indicador de carregando | Spinner · barra | 38 |
| Espera e ausência | Esqueleto | Forma cinza do conteúdo enquanto carrega | Um por bloco principal | 38 |
| Espera e ausência | Estado vazio | Bloco sem conteúdo, com próxima ação | Padrão | 38 |

**Sempre presentes, fora do catálogo de componentes:**

| Peça | De onde vem |
|------|-------------|
| Logo e ícone do app | Manual da marca (roteiro, Parte A) |
| Cabeçalho e rodapé | Padrão de tela (roteiro, passo 14), montados com os essenciais |

## Faixa 2 — Média (decidir na conversa)

Comum em muitos produtos, mas fora do deck de referência. Cada item precisa de “sim + tela” para entrar.

| Grupo | Componente | O que é | Quando costuma entrar |
|-------|------------|---------|-----------------------|
| Ações | Botão de ícone | Botão só com ícone (fechar, mais opções) | Barras de ferramenta, cards, janelas |
| Ações | Botão social | Entrar com Google, Apple etc. — mesmo envelope do botão secundário do produto + **marca oficial** do terceiro (nunca letra provisória) | Login |
| Formulário | Controle segmentado | 2 a 4 opções lado a lado, uma ativa | Troca de modo ou de visão |
| Formulário | Campo de código | Caixinhas para código de verificação | Login por SMS ou e-mail, recuperar senha |
| Formulário | Upload de arquivo | Enviar arquivo ou foto | Perfil, documentos |
| Sinais | Avatar | Foto ou iniciais da pessoa | Produtos com conta |
| Sinais | Avaliação (estrelas) | Nota de 0 a 5 | Produtos, serviços |
| Navegação | Barra de categorias | Atalhos de categoria no topo | Catálogo, loja, conteúdo |
| Camadas | Gaveta | Painel que desliza da lateral ou de baixo | Filtros no celular, menus |
| Camadas | Confirmação destrutiva | Modal “tem certeza?” para apagar ou cancelar | Ações irreversíveis |
| Estados | Barra de progresso com etapas | Quanto falta, com texto do que está acontecendo | Processos longos |
| Conteúdo | Linha de lista | Item em lista com ação | Histórico, registros |
| Conteúdo | Acordeão | Pergunta que abre a resposta | FAQ, ajuda |

## Faixa 3 — Avançada (só com tela que exija)

Se nenhuma tela pedir, fica na lista de proibidos.

| Componente | O que é | Quando costuma entrar |
|------------|---------|-----------------------|
| Slider (deslizante) | Arrastar para escolher um valor ou faixa | Filtro de preço, volume |
| Seletor de data | Calendário para escolher data | Agendamento, relatórios |
| Busca com sugestão (combobox) | Campo que sugere opções enquanto digita | Listas muito grandes de opções |
| Etapas (stepper) | “Passo 1 de 3” em fluxos longos | Cadastro longo, checkout |
| Carrossel | Itens que passam para o lado | Vitrine de destaque |
| Linha do tempo | Eventos em ordem cronológica | Histórico de pedido, auditoria |
| Gráficos | Barras, linhas, pizza | Painéis, relatórios |
| Tabela avançada | Ordenar, escolher colunas, total, filtros | Admin, financeiro |
| Barra lateral de app | Menu fixo à esquerda | Painéis, admin |
| Central de notificações | Lista de avisos com não lidos | Produtos com eventos frequentes |
| Tour de primeiro uso | Balões guiando a pessoa na primeira vez | Onboarding |
| Editor de texto rico | Negrito, listas, links num campo | Conteúdo criado pelo usuário |
| Chat | Conversa em tempo real | Suporte, mensagens |
| Paleta de comandos | Busca de ações por teclado (Ctrl+K) | Ferramentas de produtividade |

## Faixa D — Domínio (sempre definida na conversa)

É o que diferencia o produto. Não existe lista pronta: sai das telas. Os tipos abaixo ajudam a reconhecer uma peça de domínio. Se o tipo de produto tiver seção no [`ui-gosto.md`](../docs/ui-gosto.md) §11, ela pode nomear peças do tipo (ex.: cassino).

| Tipo de peça | O que é | Exemplos em produtos diferentes |
|--------------|---------|---------------------------------|
| Card do item principal | O bloco que mostra a coisa central do produto | Produto, anúncio, imóvel, vaga, pedido, curso |
| Indicador próprio | Nota, nível ou escala criada pelo produto | Score de 0 a 100, nível de risco, temperatura, ranking |
| Selo de tipo ou confiança | Marca curta que classifica o item | Verificado, oficial, igual / parecido, novo |
| Status de processo | Em que etapa algo está | Na fila, processando, concluído, falhou, cancelado |
| Saldo ou plano | Quanto a pessoa tem para usar | Créditos, pontos, plano atual, limite |
| Item de origem | O contexto que disparou a tela | Item comparado, pedido original, arquivo enviado |
| Resultados instantâneos | O que aparece enquanto a pessoa digita | Sugestões, atalhos, itens recentes |
| Seletor de fontes | Escolher de onde vêm os dados | Lojas, contas conectadas, integrações |
| Painel de detalhe | Informação extra que abre ao clicar | Explicação da nota, histórico do item |
| Logos de terceiros | Marcas de parceiros exibidas no produto | Lojas, bancos, meios de pagamento |
| Mídia de campanha | Banner, capa ou arte com imagem trocável; uma proporção por família (roteiro, passo 18.1) | Banner de promoção, arte de login, capa de curso |

### Regras de domínio que se repetem (de correções reais)

- **Situação nunca leva o tipo no nome.** Numa tela de saque, o selo diz “Processando”, não “Saque em processamento”. Em tabela que mistura tipos (movimentações, transações), o tipo vai numa **coluna própria com ícone + nome**; a situação fica só com a palavra da situação. O mesmo vale para avisos/eventos de integração: um evento “mudou de situação” com **tipo** e **situação** separados, não um nome composto por combinação.
- **Meio de pagamento:** usar o ícone **oficial** do meio (biblioteca de ícones de marca, ex.: Simple Icons) numa cor só, como indicador — nunca redesenhar o logo do meio nem usá-lo como marca do produto.
- **Indicadores sem espaço vazio:** cartões de indicador lado a lado com metade vazia (porque um vizinho é mais alto) são reprovados. Preferir **um cartão de resumo** com colunas separadas por fio, cada coluna com valor + 1 ou 2 linhas de apoio úteis.
- **Tabela no celular:** se o produto tem celular, a decisão “tabela vira cartões” só está feita quando o **componente** existe (lista de cartões com cabeçalho, filtros, total e paginação de toque) — não basta escrever a regra.
- **Renomear entidade** (ex.: trocar o nome de uma operação): conferir o **gênero** das situações que concordam com ela (paga/pago, cancelada/cancelado) e perguntar ao humano antes de trocar.

## Por superfície (entram junto com a faixa correspondente)

| Superfície | Peças a mais |
|------------|--------------|
| Extensão de navegador | Cabeçalho da extensão, telas no tamanho do popup |
| Celular | Gaveta de baixo, navegação inferior (se houver), área de toque 44 |
| Painel / admin | Barra lateral, tabela avançada, filtros em card — Faixa 3 vira comum |
