# Protótipo navegável

Telas exportadas do canvas do produto, navegáveis no navegador. Gerado pela skill `product-from-idea` (Fase 8.5).

| Comando (na raiz do workspace) | O que faz |
|---|---|
| `npm run prototipo:start` | Sobe em http://localhost:4173 (`PORT=8080 npm run prototipo:start` para outra porta) |
| `npm run prototipo:preparar` | Depois de exportar telas do canvas: corrige e liga as telas |
| `npm run prototipo:verificar` | Confere links quebrados e telas sem caminho (rodar `npm --prefix prototipo install` uma vez) |

| Arquivo | De quem |
|---|---|
| `screens.js` (lista de telas) · `rotas.js` (o que cada botão abre) · `telas/` · `images/` · `package-lock.json` | **Do produto** (`node_modules/` fica fora do git) |
| `index.html` · `nav.js` · `server.js` · `scripts/` · `package.json` · este arquivo | **Motor** — vem da skill; não editar aqui. Atualizar = copiar a versão nova do molde por cima |

O servidor responde em toda a rede local (para apresentar de outra máquina); para só esta máquina: `HOST=127.0.0.1`.

Atualizar telas, criar telas novas e trocar o motor: `modules/08b-prototipo-navegavel/playbook.md` da skill, seção "Atualizar o protótipo".
