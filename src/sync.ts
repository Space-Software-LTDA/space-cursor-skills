import path from "node:path";
import { fileURLToPath } from "node:url";
import { writeClickupEnv } from "./lib/clickup-env.js";
import { writeCopyNotices } from "./lib/copy-notice.js";
import { copySkills } from "./lib/copy-skills.js";
import { loadConfig, validateConfig } from "./lib/env.js";
import { gitPull } from "./lib/git.js";
import { detectPlatform } from "./lib/platform.js";

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const dryRun = process.argv.includes("--dry-run");

async function main(): Promise<void> {
  const platform = detectPlatform();
  const config = loadConfig(repoRoot, dryRun);

  console.log(`\n🔄 space-cursor-skills sync`);
  console.log(`   Plataforma: ${platform}`);
  console.log(`   Origem:     ${config.skillsSource}`);
  console.log(`   Destino:    ${config.skillsDest}`);
  if (dryRun) console.log(`   Modo:       dry-run (nada será alterado)\n`);
  else console.log("");

  validateConfig(config);

  if (config.gitPull) {
    console.log("📥 Atualizando repo (git pull)...");
    gitPull(config.repoRoot, config.dryRun);
  } else {
    console.log("⏭️  git pull desabilitado (GIT_PULL=false)");
  }

  console.log("\n📂 Sincronizando skills...");
  const stats = copySkills(config.skillsSource, config.skillsDest, config.dryRun);

  console.log("\n📝 Carimbando aviso de copia...");
  const noticed = writeCopyNotices(config.skillsDest, {
    repoRoot: config.repoRoot,
    dryRun: config.dryRun,
  });
  if (noticed.length) {
    console.log(`   00-COPIA-LEIA-ME.md em: ${noticed.join(", ")}`);
  }

  if (config.clickup) {
    const written = writeClickupEnv(
      config.skillsDest,
      config.clickup,
      config.dryRun,
    );
    if (written.length) {
      console.log(`🔑 clickup.env atualizado em: ${written.join(", ")}`);
    }
  } else {
    console.log(
      "⚠️  CLICKUP_API_TOKEN/WORKSPACE_ID não configurados — clickup.env não gerado",
    );
  }

  console.log("\n✅ Sync concluído");
  console.log(`   Skills:  ${stats.skills.join(", ")}`);
  console.log(`   Arquivos: ${stats.copied} copiados, ${stats.skipped} ignorados`);
  console.log(`\n   Reinicie o chat do Cursor para recarregar as skills.\n`);
}

main().catch((err: unknown) => {
  const message = err instanceof Error ? err.message : String(err);
  console.error(`\n❌ Erro: ${message}\n`);
  process.exit(1);
});
