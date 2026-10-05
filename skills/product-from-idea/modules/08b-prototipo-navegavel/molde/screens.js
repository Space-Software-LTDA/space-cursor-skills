// TELAS do produto — manifesto lido pelo shell (index.html), pelo motor (nav.js) e pelos scripts.
// PREENCHER na Fase 8.5 (passo a passo: modules/08b-prototipo-navegavel/playbook.md da skill).
//
// Cada tela: [id do frame no canvas, título, dispositivo, logado, tela de trás, gêmea, largura, altura]
//   id: o id do frame de topo no canvas (é também o nome do arquivo em telas/<id>.html)
//   dispositivo: "d" computador · "m" celular/app/extensão · "doc" documentação (manual, DS, rascunho)
//   logado: true/false (produto sem login: false em todas)
//   tela de trás: para onde o modal/gaveta volta ao fechar (null = tela cheia)
//   gêmea: a mesma tela no outro dispositivo (botão Computador ⇄ Celular); null se não existe
//   largura/altura: só quando foge do padrão (computador 1440 · celular 390×844; documentação = largura do frame)
//   Título com " *" = tela que ainda não existe no produto (aviso no rodapé da lista)
window.PR_CONFIG = {
  produto: "{Nome do produto}",
  destaque: "{hex da cor principal do DESIGN_SYSTEM.md}", // botões do shell; sem preencher = azul neutro
  textoNoDestaque: "{hex do texto em cima dessa cor}",
  inicio: "{id do Manual da marca}", // tela de abertura
  home: { d: ["{id home deslogado}", "{id home logado}"], m: ["{id}", "{id}"] }, // [deslogado, logado]; sem login: o mesmo id duas vezes
  semLinkChegando: [],          // telas abertas só pela lista (ex.: 404) — o verificar não acusa
  imagensDoCanvas: "../{pasta do canvas}/images", // pasta images/ ao lado do arquivo do canvas (relativa a esta pasta)
  // Opcionais (raro): ignorar: /regex/ de layers não clicáveis (padrão: "Fundo · marcador…", "… (fundo)");
  // titulos: /regex/ de layers que nunca viram link (padrão: Título, Subtítulo, Cabeçalho, Topo…)
};

window.PR_GROUPS = [
  { name: "Marca e Design System", screens: [
    // ["{id}", "Manual da marca", "doc", false, null, null, 1600],
    // ["{id}", "Fundamentos", "doc", false, null, null, 1600],
    // ["{id}", "Componentes essenciais", "doc", false, null, null, 1800],
    // ["{id}", "Rascunho", "doc", false, null, null, 1800],
  ]},
  { name: "Home", screens: [
    // ["{id}", "Home · deslogado", "d", false, null, "{id gêmea celular}"],
    // ["{id}", "Home · deslogado", "m", false, null, "{id gêmea computador}"],
  ]},
  // Um grupo por seção do canvas (Autenticação, Depósito, Minha conta…), na ordem do canvas
];
