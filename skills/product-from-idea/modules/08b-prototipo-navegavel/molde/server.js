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

// Um servidor por protótipo: se a porta estiver ocupada por um servidor antigo deste mesmo protótipo
// (ex.: terminal parado e o node ficou órfão), ele é derrubado e substituído. E este servidor se
// encerra sozinho quando o terminal (processo pai) some — não sobra porta aberta.
const QUEM = "/__prototipo";

const server = http.createServer((req, res) => {
  let rel;
  try { rel = decodeURIComponent(new URL(req.url, "http://x").pathname); } catch { rel = "/"; }
  if (rel === QUEM) {
    res.writeHead(200, { "Content-Type": "application/json" }).end(JSON.stringify({ root: ROOT, pid: process.pid }));
    return;
  }
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
});

let tentativas = 0;
server.on("error", (err) => {
  if (err.code !== "EADDRINUSE" || tentativas++ > 0) { console.error(err.message); process.exit(1); }
  // Quem está na porta?
  http.get({ host: "127.0.0.1", port: PORT, path: QUEM, timeout: 1500 }, (r) => {
    let body = "";
    r.on("data", (c) => (body += c));
    r.on("end", () => {
      let info = null;
      try { info = JSON.parse(body); } catch {}
      if (info && info.root === ROOT && info.pid) {
        console.log(`Servidor antigo deste protótipo na porta ${PORT} (processo ${info.pid}) — substituindo.`);
        try { process.kill(info.pid, "SIGTERM"); } catch {}
        setTimeout(() => server.listen(PORT, HOST), 600);
      } else ocupada(info);
    });
  }).on("error", () => ocupada(null)).on("timeout", function () { this.destroy(); });
});
function ocupada(info) {
  const dono = info && info.root ? `o protótipo de outra pasta (${info.root}, processo ${info.pid})` : "outro programa";
  console.error(`A porta ${PORT} está ocupada por ${dono}.\nUse outra porta: PORT=4174 npm run prototipo:start`);
  process.exit(1);
}

server.listen(PORT, HOST, () => console.log(`Protótipo no ar: http://localhost:${PORT}  (Ctrl+C para parar)`));

// Parar o terminal mata o npm e deixava este node órfão (às vezes com um "sh" no meio): vigia a
// cadeia de processos pais (até 4 níveis, no Linux por /proc) e sai junto se algum deles sumir
const paiDe = (pid) => {
  try { return Number(fs.readFileSync(`/proc/${pid}/stat`, "utf8").split(") ")[1].split(" ")[1]); } catch { return 0; }
};
const ancestrais = [process.ppid];
for (let p = paiDe(process.ppid); p > 1 && ancestrais.length < 4; p = paiDe(p)) ancestrais.push(p);
const pai = process.ppid;
const sair = () => { server.close(); process.exit(0); };
for (const sig of ["SIGINT", "SIGTERM", "SIGHUP"]) process.on(sig, sair);
setInterval(() => {
  if (process.ppid !== pai) return sair();
  for (const p of ancestrais) { try { process.kill(p, 0); } catch { return sair(); } }
}, 2000).unref();
