// MOTOR — prepara as telas exportadas do canvas para o protótipo. Rodar depois de cada exportação.
// Idempotente: pode rodar quantas vezes quiser.
//   1. copia a pasta images/ do canvas (PR_CONFIG.imagensDoCanvas) para ./images
//   2. em cada telas/*.html: imagens → ../images/, corrige o box-sizing do export, injeta os scripts
//   3. avisa tela do manifesto sem arquivo, arquivo sem manifesto e imagem que falta
import fs from "node:fs";
import path from "node:path";
import vm from "node:vm";
import { fileURLToPath } from "node:url";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const TELAS = path.join(ROOT, "telas");
const IMAGES = path.join(ROOT, "images");

function carregarManifesto() {
  const window = {};
  vm.runInNewContext(fs.readFileSync(path.join(ROOT, "screens.js"), "utf8"), { window });
  const ids = new Set((window.PR_GROUPS || []).flatMap((g) => g.screens.map((s) => s[0])));
  return { cfg: window.PR_CONFIG || {}, ids };
}

const { cfg, ids } = carregarManifesto();
fs.mkdirSync(IMAGES, { recursive: true });

// 1. Imagens do canvas
let copiadas = 0;
if (cfg.imagensDoCanvas) {
  const src = path.resolve(ROOT, cfg.imagensDoCanvas);
  if (fs.existsSync(src)) {
    for (const f of fs.readdirSync(src)) {
      const a = path.join(src, f), b = path.join(IMAGES, f);
      if (!fs.statSync(a).isFile()) continue;
      if (!fs.existsSync(b) || fs.statSync(a).mtimeMs > fs.statSync(b).mtimeMs) { fs.copyFileSync(a, b); copiadas++; }
    }
  } else {
    console.warn(`! Pasta de imagens do canvas não encontrada: ${src} (PR_CONFIG.imagensDoCanvas)`);
  }
}

// 2. Telas
const SCRIPTS = '<script src="../screens.js"></script><script src="../rotas.js"></script><script src="../nav.js"></script>';
const arquivos = fs.existsSync(TELAS) ? fs.readdirSync(TELAS).filter((f) => f.endsWith(".html")) : [];
const faltaImagem = new Set();
for (const f of arquivos) {
  const p = path.join(TELAS, f);
  let s = fs.readFileSync(p, "utf8");
  s = s.replace(/url\((['"]?)images\//g, "url($1../images/").replace(/(src=["'])images\//g, "$1../images/");
  // O canvas mede largura/altura com o padding dentro; o export às vezes sai com content-box e estoura o layout
  s = s.replace(/\[box-sizing:content-box\]/g, "box-border");
  if (!s.includes('src="../nav.js"')) s = s.replace("</body>", SCRIPTS + "\n</body>");
  fs.writeFileSync(p, s);
  for (const m of s.matchAll(/\.\.\/images\/([^'")\s]+)/g)) {
    if (!fs.existsSync(path.join(IMAGES, m[1]))) faltaImagem.add(m[1]);
  }
}

// 3. Conferência
const nomes = new Set(arquivos.map((f) => f.slice(0, -5)));
const semArquivo = [...ids].filter((id) => !nomes.has(id));
const semManifesto = [...nomes].filter((id) => !ids.has(id));
console.log(`OK: ${arquivos.length} telas preparadas · ${copiadas} imagens copiadas do canvas`);
if (semArquivo.length) console.warn(`! No manifesto (screens.js) sem arquivo em telas/: ${semArquivo.join(", ")} — exportar do canvas`);
if (semManifesto.length) console.warn(`! Em telas/ sem linha no manifesto: ${semManifesto.join(", ")} — incluir em screens.js ou apagar`);
if (faltaImagem.size) console.warn(`! Imagens referenciadas que não existem em images/: ${[...faltaImagem].join(", ")}`);
process.exitCode = semArquivo.length || faltaImagem.size ? 1 : 0;
