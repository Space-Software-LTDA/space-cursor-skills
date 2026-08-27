#!/usr/bin/env node
/**
 * Clica em abas/seletores e captura full-page após cada passo.
 *
 * Uso:
 *   node capture-tabs.mjs --url https://SEU-PROTOTIPO.app/rota --config tabs.config.json --out ./screenshots
 */
import { chromium } from "playwright";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";

function parseArgs(argv) {
  const args = { url: "", config: "tabs.config.json", out: "./screenshots", viewport: "1440x900" };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--url") args.url = argv[++i];
    else if (a === "--config") args.config = argv[++i];
    else if (a === "--out") args.out = argv[++i];
    else if (a === "--viewport") args.viewport = argv[++i];
  }
  if (!args.url) {
    console.error("Uso: node capture-tabs.mjs --url URL [--config tabs.config.json] [--out dir]");
    process.exit(1);
  }
  return args;
}

async function shot(page, outDir, index, name) {
  const file = `${String(index).padStart(2, "0")}-${name}.png`;
  const filePath = path.join(outDir, file);
  await page.waitForTimeout(1200);
  await page.screenshot({ path: filePath, fullPage: true });
  console.log(`  ✓ ${filePath}`);
  return file;
}

async function clickIfSelector(page, selector) {
  if (!selector) return;
  const loc = page.locator(selector).first();
  await loc.waitFor({ state: "visible", timeout: 15000 });
  await loc.click();
}

async function main() {
  const args = parseArgs(process.argv);
  const [w, h] = args.viewport.split("x").map(Number);
  const config = JSON.parse(await readFile(args.config, "utf8"));
  await mkdir(args.out, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: w, height: h } });
  const manifest = [];
  let index = 1;

  console.log(`→ ${args.url}`);
  await page.goto(args.url, { waitUntil: "networkidle", timeout: 60000 });

  for (const step of config.steps ?? []) {
    await clickIfSelector(page, step.selector);
    const file = await shot(page, args.out, index++, step.name);
    manifest.push({ step: step.name, file });
  }

  for (const block of config.subSteps ?? []) {
    if (block.click) {
      console.log(`→ sub: ${block.click}`);
      await clickIfSelector(page, block.click);
      await page.waitForTimeout(800);
    }
    for (const tab of block.tabs ?? []) {
      await clickIfSelector(page, tab.selector);
      const file = await shot(page, args.out, index++, tab.name);
      manifest.push({ step: tab.name, after: block.after, file });
    }
  }

  await writeFile(path.join(args.out, "manifest.json"), JSON.stringify(manifest, null, 2));
  await browser.close();
  console.log(`\n${manifest.length} screenshots em ${args.out}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
