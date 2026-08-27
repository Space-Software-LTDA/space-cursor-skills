# Playwright — captura de protótipo Lovable

Scripts reutilizáveis da skill para tirar **screenshots full-page** de protótipos (Lovable, staging, etc.) antes de escrever a task.

**Local dos scripts:** `scripts/playwright-capture/` (dentro desta skill).

**Local das imagens durante o trabalho:** no **projeto cliente**, pasta `.playwright-capture/` (gitignored). Depois copiar para `space-assets`.

---

## Quando usar

- Task de **Frontend** com protótipo URL
- PO pediu prints por tela
- Comparar Lovable vs local (ver [lovable-vs-local.md](lovable-vs-local.md))

Preferir Playwright a browser MCP quando precisar de **várias telas**, **abas** ou **full-page** repetível.

---

## Setup (uma vez por projeto)

No **root do projeto cliente**:

**Validar `.gitignore`** contém `.playwright-capture/`, `.task/` e `.skill/` — adicionar se faltar.  
Workspace **fora** de repo: criar essas pastas localmente sem gitignore. Workspace **dentro** de repo: pastas + **gitignore obrigatório**.

```bash
mkdir -p .playwright-capture/screenshots
cd .playwright-capture
npm init -y
npm install playwright
npx playwright install chromium
```

Copiar scripts da skill para o projeto (ou rodar direto apontando `--config`):

```bash
cp -r ~/.cursor/skills/po-techlead-scrum/scripts/playwright-capture/* .playwright-capture/
```

**Windows (PowerShell):**

```powershell
New-Item -ItemType Directory -Force -Path .playwright-capture\screenshots
Copy-Item -Recurse "$env:USERPROFILE\.cursor\skills\po-techlead-scrum\scripts\playwright-capture\*" .playwright-capture\
cd .playwright-capture
npm init -y
npm install playwright
npx playwright install chromium
```

Adicionar ao `.gitignore` do projeto (validar sempre antes de capturar):

```
.playwright-capture/
.task/
.skill/
```

---

## Scripts disponíveis

### 1. `capture-routes.mjs` — rotas fixas

Captura full-page de uma lista de URLs.

```bash
node capture-routes.mjs \
  --base https://SEU-PROTOTIPO.exemplo.app \
  --routes /rota-a,/rota-b \
  --out ./screenshots
```

**Saída:** `01-admin.png`, `02-admin-campaigns.png`, …

### 2. `capture-tabs.mjs` — abas / cliques

Navega numa SPA, clica em seletores (tabs, botões) e tira print após cada clique.

```bash
node capture-tabs.mjs \
  --url https://SEU-PROTOTIPO.exemplo.app/rota \
  --config tabs.config.json \
  --out ./screenshots
```

Config de exemplo ONESET Admin: [exemplos/oneset/playwright/tabs.config.example.json](exemplos/oneset/playwright/tabs.config.example.json)

**Formato `tabs.config.json`:**

```json
{
  "steps": [
    { "name": "dashboard", "selector": null },
    { "name": "campanhas", "selector": "text=Campanhas" },
    { "name": "profissoes", "selector": "text=Profissões" }
  ],
  "subSteps": [
    {
      "after": "profissoes",
      "click": "text=Psicólogo",
      "tabs": [
        { "name": "palavras-chave", "selector": "text=Palavras-chave" },
        { "name": "tags-google", "selector": "text=Tags Google" }
      ]
    }
  ]
}
```

Ajuste seletores inspecionando o DOM do Lovable (DevTools). Preferir `text=Label visível` ou `[role="tab"]`.

### 3. `capture-detail.mjs` — modais e fichas

Abre item da lista → entra em detalhe → captura cada sub-aba.

Ver comentários no arquivo para parâmetros `--listSelector`, `--itemSelector`, `--tabSelectors`.

---

## Convenção de nomes dos PNG

| Padrão | Uso |
| --- | --- |
| `01-dashboard.png` | Telas principais (ordem de navegação) |
| `05-profissao-palavras-chave.png` | Sub-telas / abas |
| `12-usuario-ficha.png` | Detalhe / ficha |

Numeração **sequencial** com **kebab-case** descritivo. Mesmos nomes ao copiar para `space-assets/{projeto}/{task-slug}/`.

---

## Opções úteis do Playwright

Todos os scripts usam internamente:

```javascript
await page.goto(url, { waitUntil: "networkidle" });
await page.setViewportSize({ width: 1440, height: 900 });
await page.screenshot({ path, fullPage: true });
```

| Situação | Ajuste |
| --- | --- |
| SPA lenta | `waitUntil: "domcontentloaded"` + `await page.waitForTimeout(2000)` |
| Fonte/icones | `await page.waitForLoadState("networkidle")` |
| Login no protótipo | Passo manual: exportar cookies ou usar `--storage-state auth.json` |
| Tema visual | Protótipo × app — validar grep; copiar layout, não paleta literal |

---

## Depois da captura

1. Revisar PNGs (legível, sem loading infinito).
2. Copiar para `space-assets/{projeto}/{task-slug}/`.
3. Commit + push em space-assets.
4. Embutir URLs raw GitHub na seção **🖼️ Referência visual** da task em `{projeto-cliente}/.task/{projeto}/{task-slug}.md`.

Ver [screenshots.md](screenshots.md).

---

## Troubleshooting

| Problema | Solução |
| --- | --- |
| `Executable doesn't exist` | `npx playwright install chromium` |
| Screenshot em branco | Aumentar timeout; checar se rota exige auth |
| Clique não acha elemento | Inspecionar Lovable; trocar seletor; usar `page.locator(...).first()` |
| Aba errada | Confirmar ordem em `tabs.config.json`; print extra manual se necessário |

---

## O que NÃO fazer

- Commitar `.playwright-capture/` no repo do cliente (só PNG final vai pro space-assets)
- Usar caminhos locais (`C:\...`) na task ClickUp
- Substituir [lovable-vs-local.md](lovable-vs-local.md) — captura é só a parte visual; lacunas vêm da comparação com código
