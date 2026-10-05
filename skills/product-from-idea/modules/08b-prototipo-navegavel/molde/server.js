// MOTOR — servidor estático do protótipo, sem dependências. Porta: PORT (padrão 4173) · HOST (padrão 0.0.0.0).
const http = require("http");
const fs = require("fs");
const path = require("path");

const ROOT = __dirname;
const PORT = Number(process.env.PORT) || 4173;
const HOST = process.env.HOST || "0.0.0.0";
const TYPES = {
  ".html": "text/html; charset=utf-8", ".js": "text/javascript; charset=utf-8", ".css": "text/css; charset=utf-8",
  ".json": "application/json", ".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".gif": "image/gif",
  ".webp": "image/webp", ".svg": "image/svg+xml", ".woff": "font/woff", ".woff2": "font/woff2", ".ttf": "font/ttf",
};
// Só o que o navegador precisa sai daqui: shell, motor, manifesto, rotas, telas e imagens
const PUBLIC = /^(index\.html|nav\.js|screens\.js|rotas\.js|telas\/[^/]+\.html|images\/[^/]+)$/;

http.createServer((req, res) => {
  let rel;
  try { rel = decodeURIComponent(new URL(req.url, "http://x").pathname); } catch { rel = "/"; }
  if (rel.endsWith("/")) rel += "index.html";
  const file = path.join(ROOT, path.normalize(rel));
  const pub = path.relative(ROOT, file).split(path.sep).join("/");
  if (!file.startsWith(ROOT + path.sep) || !PUBLIC.test(pub)) {
    res.writeHead(404).end("Não encontrado");
    return;
  }
  fs.readFile(file, (err, data) => {
    if (err) { res.writeHead(404).end("Não encontrado"); return; }
    res.writeHead(200, { "Content-Type": TYPES[path.extname(file).toLowerCase()] || "application/octet-stream", "Cache-Control": "no-cache" });
    res.end(data);
  });
}).listen(PORT, HOST, () => console.log(`Protótipo no ar: http://localhost:${PORT}`));
