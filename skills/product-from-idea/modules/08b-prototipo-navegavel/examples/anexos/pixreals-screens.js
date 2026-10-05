// TELAS do produto — manifesto lido pelo shell (index.html), pelo motor (nav.js) e pelos scripts.
// Cada tela: [id do frame no canvas, título, dispositivo, logado, tela de trás, gêmea, largura, altura]
//   dispositivo: "d" computador · "m" celular/app/extensão · "doc" documentação (manual, DS, rascunho)
//   tela de trás: para onde o modal/gaveta volta ao fechar (null = tela cheia)
//   gêmea: a mesma tela no outro dispositivo (troca Computador ⇄ Celular)
//   largura/altura: só quando foge do padrão (computador 1440 · celular 390×844)
window.PR_CONFIG = {
  produto: "PixReals",
  destaque: "#CFA551",          // cor de destaque do shell (cor principal do Design System)
  textoNoDestaque: "#1A1408",
  inicio: "VBREp",              // tela de abertura (Manual da marca)
  home: { d: ["iZHKa", "RDzWG"], m: ["AP2FS", "uN9wZ"] }, // [deslogado, logado] por dispositivo
  semLinkChegando: ["EUwD1", "IZ9q2"], // abertas só pela lista (o verificar não acusa)
  imagensDoCanvas: "../pixreals_prototipo/images", // pasta images/ ao lado do .pen (relativa a esta pasta)
};

window.PR_GROUPS = [
  { name: "Marca e Design System", screens: [
    ["VBREp", "Manual da marca", "doc", false, null, null, 1600],
    ["ikUtc", "Logo e ícone originais", "doc", false, null, null, 2535],
    ["HLoJq", "Fundamentos", "doc", false, null, null, 1600],
    ["A4Xb07", "Componentes essenciais", "doc", false, null, null, 1800],
    ["oLguM", "Rascunho (Draft)", "doc", false, null, null, 1800],
  ]},
  { name: "Home", screens: [
    ["iZHKa", "Home · deslogado", "d", false, null, "AP2FS"],
    ["RDzWG", "Home · logado", "d", true, null, "uN9wZ"],
    ["g9QwzN", "Home · painel da conta", "d", true, "RDzWG", "Jdxvg"],
    ["AP2FS", "Home · deslogado", "m", false, null, "iZHKa"],
    ["uN9wZ", "Home · logado", "m", true, null, "RDzWG"],
    ["bGf9D", "Menu (gaveta) · deslogado", "m", false, "AP2FS", "iZHKa"],
    ["h6ZE2E", "Menu (gaveta) · logado", "m", true, "uN9wZ", "RDzWG"],
    ["Jdxvg", "Conta (gaveta)", "m", true, "uN9wZ", "g9QwzN"],
  ]},
  { name: "Autenticação", screens: [
    ["jT994", "Login", "d", false, "iZHKa", "mKfgY"],
    ["Youjd", "Cadastro", "d", false, "iZHKa", "GDAnw"],
    ["PxSGV", "Recuperar senha", "d", false, "iZHKa", "flk7V"],
    ["mKfgY", "Login", "m", false, "AP2FS", "jT994"],
    ["GDAnw", "Cadastro", "m", false, "AP2FS", "Youjd"],
    ["flk7V", "Recuperar senha · e-mail enviado", "m", false, "AP2FS", "PxSGV"],
  ]},
  { name: "Depósito", screens: [
    ["rlFMn", "Escolher valor", "d", false, "iZHKa", "s3QGVD"],
    ["P5iZFJ", "PIX gerando", "d", false, "iZHKa", "CRLme"],
    ["YecQi", "PIX pronto", "d", false, "iZHKa", "sHUvB"],
    ["uSj00", "PIX expirado", "d", false, "iZHKa", "sHUvB"],
    ["Oah4n", "PIX confirmado", "d", false, "iZHKa", "fpmH2"],
    ["s3QGVD", "Escolher valor", "m", false, "AP2FS", "rlFMn"],
    ["CRLme", "PIX gerando", "m", false, "AP2FS", "P5iZFJ"],
    ["sHUvB", "PIX código copiado", "m", false, "AP2FS", "YecQi"],
    ["fpmH2", "PIX confirmado", "m", false, "AP2FS", "Oah4n"],
  ]},
  { name: "Busca", screens: [
    ["EnCUk", "Resultados", "d", false, "iZHKa", "wf7j3"],
    ["wf7j3", "Resultados", "m", false, "AP2FS", "EnCUk"],
  ]},
  { name: "Jogo", screens: [
    ["Z29qza", "Popup do jogo", "d", true, "RDzWG", "DX3rU"],
    ["tivc0", "Popup · compartilhar", "d", true, "Z29qza", "cXAEN"],
    ["JVhZQ", "Jogando", "d", true, null, "kXlC3"],
    ["DX3rU", "Gaveta do jogo", "m", true, "uN9wZ", "Z29qza"],
    ["cXAEN", "Gaveta · compartilhar", "m", true, "DX3rU", "tivc0"],
    ["kXlC3", "Jogando", "m", true, null, "JVhZQ"],
  ]},
  { name: "Lista de jogos", screens: [
    ["EJq8g", "Todos os jogos", "d", true, null, "Xoebf"],
    ["x5wRP2", "Provedor (PG Soft)", "d", true, null, "nMcx4"],
    ["Xoebf", "Todos os jogos", "m", true, null, "EJq8g"],
    ["nMcx4", "Provedor (PG Soft)", "m", true, null, "x5wRP2"],
  ]},
  { name: "Minha conta", screens: [
    ["SQMst", "Aba Perfil", "d", true, null, "QUh8V"],
    ["B7QXf", "Aba Segurança", "d", true, null, "S2Afc"],
    ["CZDFz", "Aba Carteira", "d", true, null, "B4Rfu2"],
    ["es5nB", "Aba Indicações", "d", true, null, "j9hY1"],
    ["B9WFX", "Trocar avatar", "d", true, "SQMst", "qTyWw"],
    ["aKTEP", "KYC início *", "d", true, "SQMst", "c8Zvk"],
    ["Y4Wy3", "KYC verificada *", "d", true, "SQMst", "F3z0r"],
    ["QUh8V", "Início", "m", true, null, "SQMst"],
    ["Qaye9", "Gaveta dados do perfil", "m", true, "QUh8V", "SQMst"],
    ["S2Afc", "Gaveta alterar senha", "m", true, "QUh8V", "B7QXf"],
    ["B4Rfu2", "Carteira", "m", true, null, "CZDFz"],
    ["j9hY1", "Indique e ganhe", "m", true, null, "es5nB"],
    ["qTyWw", "Gaveta trocar avatar", "m", true, "QUh8V", "B9WFX"],
    ["c8Zvk", "Gaveta KYC início *", "m", true, "QUh8V", "aKTEP"],
    ["F3z0r", "Gaveta KYC não confirmada *", "m", true, "QUh8V", "Y4Wy3"],
  ]},
  { name: "Saque e regras", screens: [
    ["fGQVA", "Sacar", "d", true, "CZDFz", "r6kJb"],
    ["s2Su6", "Sacar · confirmar", "d", true, "CZDFz", "r6kJb"],
    ["C6YYUT", "Regras do bônus", "d", true, "CZDFz", "t4dxYx"],
    ["r6kJb", "Sacar", "m", true, "B4Rfu2", "fGQVA"],
    ["TfOhL", "Sacar · sem CPF", "m", true, "B4Rfu2", "fGQVA"],
    ["t4dxYx", "Regras de saque", "m", true, "B4Rfu2", "C6YYUT"],
  ]},
  { name: "Promoções", screens: [
    ["r9uclq", "Listagem", "d", true, null, "lXaSI"],
    ["R4qqsV", "Página da promoção", "d", true, null, "hVb0b"],
    ["lXaSI", "Listagem", "m", true, null, "r9uclq"],
    ["kBwS2", "Filtro sem promoções", "m", true, null, "r9uclq"],
    ["hVb0b", "Página da promoção", "m", true, null, "R4qqsV"],
    ["kT0Bj", "Promoção encerrada", "m", true, null, "R4qqsV"],
  ]},
  { name: "Esportes, legais e 404", screens: [
    ["JDnM3", "Esportes · erro do provedor", "d", true, null, "pnHC7"],
    ["lqwBu", "Termos de uso", "d", true, null, "JmUT9"],
    ["EUwD1", "404", "d", true, null, "IZ9q2"],
    ["pnHC7", "Esportes · carregando", "m", true, null, "JDnM3"],
    ["JmUT9", "Termos de uso", "m", true, null, "lqwBu"],
    ["IZ9q2", "404", "m", true, null, "EUwD1"],
  ]},
];
