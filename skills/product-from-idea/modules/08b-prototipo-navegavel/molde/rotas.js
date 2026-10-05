// ROTAS do produto — o que cada botão das telas abre. Única parte do comportamento que muda
// de produto para produto (o motor fica em nav.js). PREENCHER na Fase 8.5.
// Base para escrever: npm run prototipo:verificar -- --inventario {id} (na raiz do workspace) —
// lista nome do layer + texto de cada peça da tela.
//
// O motor já resolve sozinho: "Fundo escurecido…" e "…Fechar…" → tela de trás; fundo atrás do modal
// ("Fundo · marcador…", "… (fundo)") não é clicável; Título/Subtítulo/Cabeçalho não viram link;
// botão que levaria para a própria tela é ignorado.
//
// Cada regra devolve: id da tela · "back" · "toast:mensagem" (ação sem tela) · {hide: elemento} ·
// null (não clicável) · undefined (segue para a próxima regra).
// ctx: S (tela atual: id, device, logged, base, group) · D (é computador?) · pick(computador, celular) ·
//      HOME · HOME_IN · HOME_OUT · CLOSE (tela de trás) · nameOf(el) · textOf(el) · inside(el, /regex/)
window.PR_ROTAS = function ({ S, D, pick, HOME, HOME_IN, HOME_OUT, CLOSE, nameOf, inside }) {
  // 1. Por TEXTO do botão (rótulo curto, igual ao da tela). O nome do layer de uma cópia de
  //    componente é o do componente; o texto é o que muda — por isso a maioria das regras é por texto.
  const texto = {
    // "Entrar": () => (S.logged ? null : pick("{id login computador}", "{id login celular}")),
    // "Cancelar": () => CLOSE,
    // "Copiar link": () => "toast:Link copiado",
    // "Início": () => HOME,
  };

  // 2. Por NOME do layer / contexto (botão só-ícone, card, item de menu, navegação inferior…).
  //    Roda antes do mapa de textos.
  function nome(el, n, t) {
    // if (n === "Botão de ícone Menu" && inside(el, /^Header$/)) return S.logged ? "{menu logado}" : "{menu deslogado}";
    // if (/^Card · /.test(n)) return pick("{popup computador}", "{gaveta celular}");
    return undefined;
  }

  // 3. Telas de transição que avançam sozinhas: { "{id gerando}": ["{id pronto}", 2200] }
  const auto = {};

  return { texto, nome, auto };
};
