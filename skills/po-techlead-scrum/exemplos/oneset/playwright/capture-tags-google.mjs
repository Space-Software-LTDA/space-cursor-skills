#!/usr/bin/env node
/** Captura única: navega até aba Tags Google no admin Lovable. */
import { chromium } from "playwright";
import { mkdir } from "node:fs/promises";
import path from "node:path";

const URL = "https://oneset.lovable.app/admin";
const OUT = process.argv[2] || "./screenshots";

async function main() {
  await mkdir(OUT, { recursive: true });
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });

  console.log("→", URL);
  await page.goto(URL, { waitUntil: "networkidle", timeout: 90000 });
  await page.waitForTimeout(2000);

  for (const label of ["Profissões", "Psicólogo", "Tags Google"]) {
    console.log("  click:", label);
    const loc = page.locator(`text=${label}`).first();
    await loc.waitFor({ state: "visible", timeout: 20000 });
    await loc.click();
    await page.waitForTimeout(1500);
  }

  const filePath = path.join(OUT, "17-profissao-tags-google.png");
  await page.screenshot({ path: filePath, fullPage: true });
  console.log("✓", filePath);

  await browser.close();
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
