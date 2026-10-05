// ROTAS do produto — o que cada botão das telas abre. Única parte do comportamento que muda
// de produto para produto (o motor fica em nav.js). Ids = ids dos frames no canvas (screens.js).
//
// Cada regra devolve: id da tela · "back" · "toast:mensagem" · {hide: elemento} ·
// null (não clicável) · undefined (segue para a próxima regra).
// ctx: S (tela atual), D (é computador?), pick(computador, celular), HOME, HOME_IN, HOME_OUT,
//      CLOSE (tela de trás do modal/gaveta), nameOf(el), textOf(el), inside(el, /regex/)
window.PR_ROTAS = function ({ S, D, pick, HOME, HOME_IN, HOME_OUT, CLOSE, nameOf, inside }) {
  const JOGOS = pick("EJq8g", "Xoebf");

  const texto = {
    "Entrar": () => (S.logged ? null : pick("jT994", "mKfgY")),
    "Cadastrar": () => (S.logged ? null : pick("Youjd", "GDAnw")),
    "Cadastre-se": () => pick("Youjd", "GDAnw"),
    "Criar conta e resgatar bônus": () => HOME_IN,
    "Continuar com Google": () => HOME_IN,
    "Esqueci minha senha": () => pick("PxSGV", "flk7V"),
    "Enviar link": () => (D ? "toast:Link de recuperação enviado para seu e-mail" : "flk7V"),
    "Voltar para Entrar": () => pick("jT994", "mKfgY"),
    "Depositar": () => pick("rlFMn", "s3QGVD"),
    "Depositar e ganhar": () => pick("rlFMn", "s3QGVD"),
    "Depositar via PIX": () => pick("P5iZFJ", "CRLme"),
    "Copiar código PIX": () => (D ? "toast:Código PIX copiado" : "sHUvB"),
    "Copiar link": () => "toast:Link copiado",
    "Reenviar e-mail": () => "toast:E-mail reenviado",
    "Já paguei": () => pick("Oah4n", "fpmH2"),
    "O código expira em": () => (D ? "uSj00" : null),
    "Gerar novo código": () => "P5iZFJ",
    "Voltar e mudar o valor": () => pick("rlFMn", "s3QGVD"),
    "Jogar agora": () => pick("JVhZQ", "kXlC3"),
    "Jogar": () => pick("JVhZQ", "kXlC3"),
    "Compartilhar": () => (S.id === "Z29qza" ? "tivc0" : S.id === "DX3rU" ? "cXAEN" : null),
    "Ver carteira": () => pick("CZDFz", "B4Rfu2"),
    "Carteira": () => pick("CZDFz", "B4Rfu2"),
    "Carteira e histórico": () => "B4Rfu2",
    "Saldo real": () => pick("CZDFz", "B4Rfu2"),
    "Minha conta": () => pick("SQMst", "QUh8V"),
    "Perfil": () => "SQMst",
    "Segurança": () => "B7QXf",
    "Indicações": () => "es5nB",
    "Dados do perfil": () => pick("SQMst", "Qaye9"),
    "Alterar senha": () => pick("B7QXf", "S2Afc"),
    "Painel de Afiliado": () => pick("es5nB", "j9hY1"),
    "Indique e ganhe": () => pick("es5nB", "j9hY1"),
    "Verificação de identidade": () => (S.id === "QUh8V" ? "c8Zvk" : null),
    "Verificar agora": () => "aKTEP",
    "Começar verificação": () => pick("Y4Wy3", "F3z0r"),
    "Tentar de novo": () => (S.id === "F3z0r" ? "c8Zvk" : S.id),
    "Falar com o suporte": () => CLOSE,
    "Voltar para a conta": () => "SQMst",
    "Sacar agora": () => pick("fGQVA", "r6kJb"),
    "Sacar": () => pick("fGQVA", "r6kJb"),
    "Sacar R$ 100,00": () => pick("s2Su6", "TfOhL"),
    "Confirmar saque": () => "CZDFz",
    "Cadastrar CPF": () => "Qaye9",
    "Regras de saque": () => (D ? null : "t4dxYx"),
    "Regras do bônus": () => (D ? "C6YYUT" : "t4dxYx"),
    "Jogos com bônus": () => JOGOS,
    "Jogar com bônus": () => JOGOS,
    "Sair": () => HOME_OUT,
    "Sair da conta": () => HOME_OUT,
    "Salvar avatar": () => S.base,
    "Salvar alterações": () => S.base,
    "Atualizar senha": () => S.base,
    "Cancelar": () => CLOSE,
    "Agora não": () => CLOSE,
    "Voltar": () => (S.id === "s2Su6" ? "fGQVA" : S.base ? CLOSE : S.id === "JDnM3" ? HOME : "back"),
    "Ver todos": () => (S.id === "nMcx4" || S.id === "x5wRP2" ? null : JOGOS),
    "Ver todos os jogos": () => JOGOS,
    "Ver mais jogados": () => JOGOS,
    "Cassino": () => JOGOS,
    "Ao Vivo": () => JOGOS,
    "Esportes": () => pick("JDnM3", "pnHC7"),
    "Promoções": () => pick("r9uclq", "lXaSI"),
    "Ver detalhes": () => pick("R4qqsV", "hVb0b"),
    "Ver promoções ativas": () => pick("r9uclq", "lXaSI"),
    "Ver todas as promoções": () => "lXaSI",
    "Torneios": () => (D ? null : "kBwS2"),
    "Todas": () => (S.id === "kBwS2" ? "lXaSI" : null),
    "Termos de uso": () => (S.id === "lqwBu" || S.id === "JmUT9" ? null : pick("lqwBu", "JmUT9")),
    "Início": () => HOME,
  };
  for (const c of ["Populares", "Slots", "Crash", "Cassino Ao Vivo", "Game Shows", "Cartas", "Novos", "Roleta", "Mesa"]) {
    texto[c] = () => JOGOS;
  }

  const temContadores = (el) => el.querySelector('[data-pencil-name="Contadores"]');

  function nome(el, n, t) {
    // Faixa de bônus: o X esconde a faixa (não fecha tela)
    if (/Fechar/.test(n) && inside(el, /^Faixa de bônus$/)) return { hide: el.closest('[data-pencil-name="Faixa de bônus"]') };

    // Header
    if (n === "Imagem" && inside(el, /^Header$/) && /^Linha · (Cassino|imagem)$/.test(nameOf(el.parentElement))) return HOME;
    if (n === "Botão de ícone Toque 44" && inside(el, /^Header$/)) return S.logged ? "h6ZE2E" : "bGf9D";
    if (n === "Busca" && inside(el, /^(Header|Gaveta)/)) return pick("EnCUk", "wf7j3");
    if (n === "Saldo" && inside(el, /^Header$/)) return pick("g9QwzN", "Jdxvg");
    if (n === "Conta" && inside(el, /^Header$/)) return S.id === "g9QwzN" ? "RDzWG" : "g9QwzN";

    // Navegação inferior (celular)
    if (/^Coluna · /.test(n) && inside(el, /^Navegação inferior$/)) {
      const go = { "Início": HOME, "Cassino": "Xoebf", "Ao Vivo": "Xoebf", "Depositar": "s3QGVD", "Cadastre-se": "GDAnw",
        "Conta": S.logged ? (S.id === "QUh8V" ? null : "Jdxvg") : "mKfgY" }[n.slice(9)];
      return go || null;
    }
    if (n === "Ver minha conta" || n === "Usuário · Minha conta") return pick("SQMst", "QUh8V");

    // Voltar no celular
    if (S.id === "kXlC3" && n === "Voltar") return "DX3rU";
    if (S.id === "kXlC3" && n === "Depositar") return "s3QGVD";
    if (n === "Voltar" && !D && t !== "Voltar e mudar o valor") {
      return S.id === "nMcx4" ? HOME : S.id === "hVb0b" || S.id === "kT0Bj" ? "lXaSI" : S.id === "JmUT9" ? "back" : "QUh8V";
    }
    if (n === "Voltar para promoções") return pick("r9uclq", "lXaSI");

    // Avatar na Minha conta
    if (n === "Avatar + trocar") return pick("B9WFX", "qTyWw");
    if (n === "Avatar" && S.id === "QUh8V" && !inside(el, /^Header$|^Avatar \+ trocar$/)) return "qTyWw";

    // Botão só-ícone de compartilhar no popup/gaveta do jogo
    if (n === "Compartilhar" && (S.id === "Z29qza" || S.id === "DX3rU")) return pick("tivc0", "cXAEN");

    // Cards
    if (/^(Card|Thumb)/.test(n) && temContadores(el)) return pick("Z29qza", "DX3rU");
    if (n === "Tile de provedor") return pick("x5wRP2", "nMcx4");
    if (/^Card · /.test(n) && !temContadores(el) && !/\*\*\*\*/.test(n)) return !D && /Torneio/.test(n) ? "kT0Bj" : pick("R4qqsV", "hVb0b");
    if (n === "Destaque" && /promo/i.test(S.group)) return pick("R4qqsV", "hVb0b");
    if (n === "Item de navegação lateral" && texto[t]) return texto[t]();
    if (n === "Texto · Termos de uso") return pick("lqwBu", "JmUT9");

    // Abas da Minha conta (computador)
    const abas = { "Perfil": "SQMst", "Segurança": "B7QXf", "Carteira": "CZDFz", "Indicações": "es5nB" };
    if (inside(el, /^Abas$/) && abas[t]) return abas[t];

    // Login: o botão principal "Entrar" loga; a aba "Entrar" não faz nada
    if ((S.id === "jT994" || S.id === "mKfgY") && t === "Entrar") {
      if (n === "Primário" || inside(el, /^Primário$/)) return HOME_IN;
      if (inside(el, /^Entrar \/ Cadastrar$/)) return null;
    }
    return undefined;
  }

  // Telas de transição que avançam sozinhas: [próxima tela, milissegundos]
  const auto = { P5iZFJ: ["YecQi", 2200], CRLme: ["sHUvB", 2200] };

  return { texto, nome, auto };
};
