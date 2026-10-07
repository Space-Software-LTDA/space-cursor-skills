// MOTOR do protótipo navegável — não editar no produto (melhoria vai para a skill via /skill-update).
// Injetado em cada tela exportada (por scripts/preparar.mjs), depois de screens.js e rotas.js.
// Marca as áreas clicáveis e navega entre telas. Dentro do shell (index.html) conversa via
// postMessage; aberta sozinha, navega direto para o arquivo da tela.
window.PR_MOLDE_VERSAO = "1.6.0";

// Índice id → tela, montado a partir de PR_GROUPS (screens.js). Também usado pelo shell.
window.PR_INDEXAR = function () {
  const out = {};
  for (const g of window.PR_GROUPS || []) {
    for (const [id, title, device, logged, base, twin, width, height, pos] of g.screens) {
      const atual = base === "*"; // "*" = abre sobre a tela em que a pessoa está (menu da barra do topo, presente em toda tela)
      out[id] = {
        id, title, group: g.name, device, logged: !!logged, base: atual ? null : base || null, sobreAtual: atual, twin: twin || null,
        width: width || (device === "m" ? 390 : 1440), height: height || (device === "m" ? 844 : null),
        pos: pos || null, // janela solta: "centro" · "direita" · "baixo" · [x, y] (ver screens.js)
      };
    }
  }
  return (window.PR_SCREENS = out);
};

(function () {
  const root = document.querySelector("body > [data-pencil-id]");
  if (!root) return;
  if (!window.PR_SCREENS) window.PR_INDEXAR();
  const S = window.PR_SCREENS[root.dataset.pencilId];
  if (!S) return;
  const CFG = window.PR_CONFIG || {};
  const inShell = window.parent !== window;
  const verificando = !!window.__PR_VERIFICAR;

  // Sem barra de rolagem dentro da tela: ela come largura e cria scroll horizontal
  const base = document.createElement("style");
  // Bloco que preenche o espaço (flex 1 1 0 no export) nunca alarga o pai, como no canvas: pode encolher
  // abaixo do conteúdo, e texto sem espaço (código Pix, chave, URL) quebra em vez de empurrar a tela
  base.textContent = "html,body{overflow-x:hidden;scrollbar-width:none}html::-webkit-scrollbar,body::-webkit-scrollbar{display:none}" +
    '[class*="[flex:1_1_0]"]{min-width:0;min-height:0;overflow-wrap:anywhere}';
  document.head.appendChild(base);

  // Celular: no canvas, a tela tem a altura do aparelho e o miolo recorta (clip) o que passa.
  // Esse recorte é a área que rola entre as barras fixas — no export vira overflow-hidden e trava.
  // Todo bloco que recorta conteúdo maior que ele passa a rolar (o mais externo vence).
  if (S.device === "m") {
    const rola = document.createElement("style");
    rola.textContent = ".pr-rola{overflow-y:auto!important;overflow-x:hidden!important;overscroll-behavior:contain;scrollbar-width:none}.pr-rola::-webkit-scrollbar{display:none}";
    document.head.appendChild(rola);
    const liberar = () => {
      for (const el of [root, ...root.querySelectorAll("*")]) {
        if (el.closest(".pr-rola") || el instanceof SVGElement) continue;
        if (!el.children.length || el.scrollHeight <= el.clientHeight + 4) continue; // texto cortado com “…” não rola
        if (!/hidden|clip/.test(getComputedStyle(el).overflowY)) continue;
        el.classList.add("pr-rola");
      }
    };
    liberar();
    window.addEventListener("load", liberar);
  }

  if (S.device === "doc") {
    if (inShell) window.parent.postMessage({ pr: "ready", id: S.id }, "*");
    return;
  }

  // ---- contexto entregue às rotas do produto ----
  const D = S.device === "d";
  const pick = (d, m) => (D ? d : m);
  const homes = (CFG.home && CFG.home[S.device]) || [];
  const HOME_OUT = homes[0] || null;
  const HOME_IN = homes[1] || homes[0] || null;
  const HOME = S.logged ? HOME_IN : HOME_OUT;
  const CLOSE = S.base || (S.sobreAtual ? "fundo" : "back"); // "fundo" = fecha tudo e volta à tela de baixo
  const nameOf = (el) => (el && el.getAttribute && el.getAttribute("data-pencil-name")) || "";
  const textOf = (el) => (el.textContent || "").replace(/\s+/g, " ").replace(/\s*→\s*$/, "").trim();
  const inside = (el, re) => {
    for (let p = el.parentElement; p && p !== document.body; p = p.parentElement) {
      if (re.test(nameOf(p))) return true;
    }
    return false;
  };
  const ctx = { S, D, pick, HOME, HOME_IN, HOME_OUT, CLOSE, nameOf, textOf, inside, CFG };
  const R = (typeof window.PR_ROTAS === "function" ? window.PR_ROTAS(ctx) : window.PR_ROTAS) || {};
  const TEXTO = R.texto || {};
  const has = (k) => Object.prototype.hasOwnProperty.call(TEXTO, k);
  const IGNORAR = CFG.ignorar || /^(Fundo · marcador|.* \(fundo\)$)/;
  const TITULOS = CFG.titulos || /^(Título|Subtítulo|Cabeçalho|Ícone \+ título|Topo|Voltar \+ título|Caminho)$/;

  // Resultado de regra: string = destino ("back", "toast:mensagem" ou id de tela) ·
  // objeto {go} | {hide: elemento} · null/false = não clicável · undefined = seguir para a próxima regra
  const norm = (v) => (v === undefined ? undefined : !v ? null : typeof v === "string" ? { go: v } : v);

  function resolve(el) {
    const n = nameOf(el);
    if (!n) return null;
    const t = textOf(el);

    // 1. Clique fora do modal/gaveta fecha; o que está atrás do modal não é clicável
    if (/^Fundo escurecido/.test(n)) return { go: CLOSE, quiet: true };
    if (IGNORAR.test(n) || inside(el, IGNORAR)) return null;

    // 2. Regras do produto por nome/contexto (rotas.js)
    if (typeof R.nome === "function") {
      const r = norm(R.nome(el, n, t));
      if (r !== undefined) return r;
    }

    // 3. Fechar → tela de trás
    if (/Fechar/.test(n)) return { go: CLOSE };

    // 4. Títulos não viram link
    if (TITULOS.test(n)) return null;

    // 5. Rótulo curto idêntico a uma chave do mapa de textos
    if (t && t.length <= 40 && has(t)) {
      const r = norm(TEXTO[t](el, n, t));
      if (r) return r;
    }
    // 6. Linha de menu cujo layer tem o nome do item (ex.: "Alterar senha" + descrição)
    if (has(n) && t.startsWith(n) && t !== n) {
      const r = norm(TEXTO[n](el, n, t));
      if (r) return r;
    }
    return null;
  }

  // ---- marca as áreas: do mais externo para o mais interno; o externo vence,
  // a menos que contenha outro botão com destino diferente ----
  const safe = (el) => {
    try { const r = resolve(el); return r && r.go !== S.id ? r : null; } catch (e) { return null; }
  };
  const conflicts = (el, r) => {
    if (r.quiet || r.hide) return false;
    const kids = el.querySelectorAll("[data-pencil-name]");
    if (kids.length > 80) return false;
    for (const k of kids) { const o = safe(k); if (o && o.go !== r.go) return true; }
    return false;
  };
  for (const el of root.querySelectorAll("[data-pencil-name]")) {
    if (el.closest("[data-hs]")) continue;
    const r = safe(el);
    if (!r || conflicts(el, r)) continue;
    el.setAttribute("data-hs", r.go ? r.go.split(":")[0] : "hide");
    if (r.quiet) el.setAttribute("data-hs-quiet", "");
    el.__pr = r;
  }

  const accent = /^#[0-9a-f]{3,8}$/i.test(CFG.destaque || "") ? CFG.destaque : "#3B82F6";
  const style = document.createElement("style");
  style.textContent = `
    [data-hs]{cursor:pointer}
    html.pr-hs [data-hs]:not([data-hs-quiet]){outline:2px solid ${accent};outline-offset:-1px;box-shadow:inset 0 0 0 9999px ${accent}24}
    html.pr-flash [data-hs]:not([data-hs-quiet]){outline:2px solid ${accent};outline-offset:-1px}
  `;
  document.head.appendChild(style);

  function go(id) {
    if (inShell) window.parent.postMessage({ pr: "go", id }, "*");
    else if (id === "back") history.back();
    else location.href = id + ".html";
  }

  function toast(msg) {
    const t = document.createElement("div");
    t.textContent = msg;
    t.style.cssText = "position:fixed;left:50%;bottom:32px;transform:translateX(-50%);z-index:99999;background:#1A2129;color:#F2F4F7;" +
      "border:1px solid #2A333D;border-left:3px solid #22C55E;padding:12px 16px;border-radius:10px;font:500 14px Inter,system-ui,sans-serif;" +
      "box-shadow:0 8px 24px rgba(0,0,0,.4);transition:opacity .3s";
    document.body.appendChild(t);
    setTimeout(() => { t.style.opacity = "0"; setTimeout(() => t.remove(), 300); }, 1800);
  }

  document.addEventListener("click", (e) => {
    const el = e.target.closest("[data-hs]");
    if (!el) {
      document.documentElement.classList.add("pr-flash");
      setTimeout(() => document.documentElement.classList.remove("pr-flash"), 700);
      return;
    }
    e.preventDefault();
    const r = el.__pr;
    if (r.hide) { r.hide.style.display = "none"; return; }
    if (r.go.startsWith("toast:")) { toast(r.go.slice(6)); return; }
    go(r.go);
  });

  window.addEventListener("message", (e) => {
    if (e.data && e.data.pr === "hotspots") document.documentElement.classList.toggle("pr-hs", !!e.data.on);
  });
  if (inShell) window.parent.postMessage({ pr: "ready", id: S.id }, "*");
  // Esc com o foco dentro da tela: o shell fecha a janela solta
  document.addEventListener("keydown", (e) => { if (e.key === "Escape" && inShell) window.parent.postMessage({ pr: "esc" }, "*"); });

  // Telas de transição (ex.: "gerando…") avançam sozinhas
  const auto = R.auto && R.auto[S.id];
  if (auto) {
    document.documentElement.setAttribute("data-pr-auto", auto[0]);
    if (!verificando) setTimeout(() => go(auto[0]), auto[1] || 2000);
  }
})();
