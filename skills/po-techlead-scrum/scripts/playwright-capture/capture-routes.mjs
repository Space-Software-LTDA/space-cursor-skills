#!/usr/bin/env node
/**
 * Captura full-page de rotas estáticas.
 *
 * Uso:
 *   node capture-routes.mjs --base https://SEU-PROTOTIPO.app --routes /a,/b --out ./screenshots
 */
import { chromium } from "playwright";
import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";

function parseArgs(argv) {
  const args = { base: "", routes: [], out: "./screenshots", viewport: "1440x900" };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--base") args.base = argv[++i];
    else if (a === "--routes") args.routes = argv[++i].split(",").map((r) => r.trim()).filter(Boolean);
    else if (a === "--out") args.out = argv[++i];
    else if (a === "--viewport") args.viewport = argv[++i];
  }
  if (!args.base || !args.routes.length) {
    console.error("Uso: node capture-routes.mjs --base URL --routes /a,/b [--out dir] [--viewport 1440x900]");
    process.exit(1);
  }
  return args;
}

function slugFromRoute(route) {
  return route.replace(/^\//, "").replace(/\//g, "-") || "home";
}

async function main() {
  const args = parseArgs(process.argv);
  const [w, h] = args.viewport.split("x").map(Number);
  await mkdir(args.out, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: w, height: h } });

  const manifest = [];

  for (let i = 0; i < args.routes.length; i++) {
    const route = args.routes[i];
    const url = `${args.base.replace(/\/$/, "")}${route.startsWith("/") ? route : `/${route}`}`;
    const name = `${String(i + 1).padStart(2, "0")}-${slugFromRoute(route)}.png`;
    const filePath = path.join(args.out, name);

    console.log(`→ ${url}`);
    await page.goto(url, { waitUntil: "networkidle", timeout: 60000 });
    await page.waitForTimeout(1500);
    await page.screenshot({ path: filePath, fullPage: true });

    manifest.push({ index: i + 1, route, url, file: name });
    console.log(`  ✓ ${filePath}`);
  }

  await writeFile(path.join(args.out, "manifest.json"), JSON.stringify(manifest, null, 2));
  await browser.close();
  console.log(`\n${manifest.length} screenshots em ${args.out}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
