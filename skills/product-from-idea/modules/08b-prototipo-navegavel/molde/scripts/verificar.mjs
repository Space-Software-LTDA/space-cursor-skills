// MOTOR — confere a navegação sem abrir navegador (precisa de: npm install, uma vez, para o jsdom).
//   npm run verificar                     → resumo: destinos inválidos e telas que nenhum clique alcança
//   npm run verificar -- --telas id1,id2  → lista as áreas clicáveis dessas telas (camada[texto] → destino)
//   npm run verificar -- --todas          → lista as áreas clicáveis de todas as telas
//   npm run verificar -- --inventario id  → nome de layer + texto curto da tela (base para escrever rotas.js)
//   npm run verificar -- --motor {pasta do molde na skill} → confere se o motor é igual ao da skill
//   npm run verificar -- --soltos         → lista, tela a tela, peças com cara de botão que não levam a lugar nenhum
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

let JSDOM;
try { ({ JSDOM } = await import("jsdom")); } catch {
  console.error("Falta o jsdom. Rode uma vez: npm install (dentro da pasta do protótipo)");
  process.exit(2);
}

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const ler = (f) => fs.readFileSync(path.join(ROOT, f), "utf8");
const SCREENS = ler("screens.js"), ROTAS = fs.existsSync(path.join(ROOT, "rotas.js")) ? ler("rotas.js") : "", NAV = ler("nav.js");
const arg = (k) => { const i = process.argv.indexOf(k); return i > -1 ? process.argv[i + 1] || "" : null; };
const lista = (v) => (v ? v.split(",").map((x) => x.trim()).filter(Boolean) : []);

function abrir(id) {
  const html = fs.readFileSync(path.join(ROOT, "telas", id + ".html"), "utf8").replace(/<script[\s\S]*?<\/script>/g, "");
  const dom = new JSDOM(html, { runScripts: "outside-only", url: "http://localhost/telas/" + id + ".html" });
  const w = dom.window;
  w.__PR_VERIFICAR = true;
  w.eval(SCREENS); if (ROTAS) w.eval(ROTAS); w.eval(NAV);
  return w;
}
const curto = (s, n = 24) => s.replace(/\s+/g, " ").trim().slice(0, n);
const root = (d) => d.querySelector("body > [data-pencil-id]");

// Motor intacto: compara os arquivos do motor com os do molde da skill
const motor = arg("--motor");
if (motor !== null) {
  const MOLDE = path.resolve(motor);
  const arquivos = ["index.html", "nav.js", "server.js", "package.json", "LEIA-ME.md",
    ...fs.readdirSync(path.join(MOLDE, "scripts")).map((f) => "scripts/" + f)];
  const diferentes = arquivos.filter((f) => !fs.existsSync(path.join(ROOT, f)) ||
    !fs.readFileSync(path.join(ROOT, f)).equals(fs.readFileSync(path.join(MOLDE, f))));
  console.log(diferentes.length ? `✗ Motor diferente do molde em: ${diferentes.join(", ")} — copiar do molde (melhoria = /skill-update)` : "✓ Motor igual ao molde da skill");
  process.exit(diferentes.length ? 1 : 0);
}

// Inventário de uma tela: nome do layer + texto curto, sem repetir (para escrever rotas.js)
const inv = arg("--inventario");
if (inv !== null) {
  for (const id of lista(inv)) {
    const w = abrir(id), vistos = new Set();
    if (!w.PR_SCREENS) { console.log(`== ${id} · ✗ sem o frame na raiz do HTML (exportar o frame de topo; ver preparar)`); continue; }
    console.log(`== ${id} · ${(w.PR_SCREENS[id] || {}).title || "?"}`);
    for (const el of w.document.querySelectorAll("[data-pencil-name]")) {
      const n = el.getAttribute("data-pencil-name"), t = curto(el.textContent, 40);
      if (!t || t === n || el.textContent.trim().length > 40) continue;
      const k = `${n}[${t}]`;
      if (!vistos.has(k)) { vistos.add(k); console.log("  " + k); }
    }
  }
  process.exit(0);
}

const win0 = new JSDOM("", { runScripts: "outside-only" }).window;
win0.eval(SCREENS); win0.eval(NAV);
const SC = win0.PR_INDEXAR();
const CFG = win0.PR_CONFIG || {};
const ids = Object.keys(SC);
const detalhar = arg("--todas") !== null || process.argv.includes("--todas") ? ids : lista(arg("--telas"));

const chegam = new Set([CFG.inicio, ...Object.values(CFG.home || {}).flat()].filter(Boolean));
const invalidos = [], semArquivo = [], soltos = {};
// Peça com cara de botão (altura de botão + canto arredondado + largura do conteúdo + rótulo curto; campo de texto ocupa
// a largura e fica de fora) ou ícone de ação, sem área clicável:
// o verificar não acha link quebrado aqui — acha botão desenhado que ninguém ligou (o cliente clica e nada acontece)
const ALTURA_BOTAO = /h-\[(32|36|40|44|48)px\]/;
const ICONE_ACAO = /^(ellipsis|ellipsis-vertical|more-horizontal|more-vertical|copy|pencil|trash|trash-2|x|chevron-down|chevrons-up-down|list-filter|filter|download|share|share-2|log-out|bell|menu)$/;
for (const id of ids) {
  if (!fs.existsSync(path.join(ROOT, "telas", id + ".html"))) { semArquivo.push(id); continue; }
  if (SC[id].device === "doc") continue;
  const w = abrir(id), d = w.document;
  const areas = [...d.querySelectorAll("[data-hs]")];
  const auto = d.documentElement.getAttribute("data-pr-auto");
  if (auto) chegam.add(auto);
  for (const el of areas) {
    const go = el.getAttribute("data-hs");
    if (go === "back" || go === "fundo" || go === "hide" || go === "toast") continue;
    if (!SC[go]) invalidos.push(`${id}: ${el.getAttribute("data-pencil-name")} → ${go}`);
    chegam.add(go);
  }
  for (const el of root(d) ? root(d).querySelectorAll("[data-pencil-name]") : []) {
    if (el.closest("[data-hs]") || el.querySelector("[data-hs]")) continue;
    const cls = el.getAttribute("class") || "", t = curto(el.textContent, 40);
    const botao = ALTURA_BOTAO.test(cls) && /rounded/.test(cls) && /\bw-fit\b/.test(cls) && t && el.textContent.trim().length <= 32 && !el.querySelector(":scope [data-pencil-name] [data-pencil-name] [data-pencil-name]");
    const icone = el.tagName.toLowerCase() === "svg" && ICONE_ACAO.test(el.getAttribute("data-icon-name") || "") && !el.parentElement.closest("[data-hs]") &&
      !/^(Ícone|Icone|Icon|i)$/.test(el.parentElement.getAttribute("data-pencil-name") || ""); // ícone dentro de selo decorativo não é botão
    if (botao || icone) (soltos[id] = soltos[id] || new Set()).add(`${el.getAttribute("data-pencil-name")}[${t}]`);
  }
  if (detalhar.includes(id)) {
    const linhas = [...new Set(areas.map((el) => `${el.getAttribute("data-pencil-name")}[${curto(el.textContent)}]→${el.getAttribute("data-hs")}`))];
    console.log(`== ${id} · ${SC[id].title} (${areas.length} áreas${auto ? ` · avança sozinha → ${auto}` : ""})\n  ` + linhas.join("\n  "));
  }
}
const permitidas = new Set(CFG.semLinkChegando || []);
const isoladas = ids.filter((id) => SC[id].device !== "doc" && !chegam.has(id) && !permitidas.has(id));

console.log(`\nTelas: ${ids.length} (${ids.filter((i) => SC[i].device === "doc").length} de documentação)`);
console.log(semArquivo.length ? `✗ Sem arquivo em telas/: ${semArquivo.join(", ")}` : "✓ Toda tela do manifesto tem arquivo");
console.log(invalidos.length ? `✗ Destinos que não existem:\n  ${invalidos.join("\n  ")}` : "✓ Nenhum destino inválido");
console.log(isoladas.length ? `✗ Telas que nenhum clique alcança (ligar em rotas.js ou listar em PR_CONFIG.semLinkChegando): ${isoladas.join(", ")}` : "✓ Toda tela é alcançável");
const nSoltos = Object.values(soltos).reduce((a, s) => a + s.size, 0);
console.log(nSoltos ? `! ${nSoltos} peças com cara de botão sem ligação em ${Object.keys(soltos).length} telas — conferir com --soltos (ligar em rotas.js ou dar aviso; peça que leva à própria tela é normal)` : "✓ Nenhum botão desenhado sem ligação");
if (process.argv.includes("--soltos")) for (const [id, set] of Object.entries(soltos)) console.log(`== ${id} · ${SC[id].title}\n  ` + [...set].join("\n  "));
process.exitCode = semArquivo.length || invalidos.length || isoladas.length ? 1 : 0;
