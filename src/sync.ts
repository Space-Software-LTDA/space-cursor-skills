import path from "node:path";
import { fileURLToPath } from "node:url";
import { writeApidogEnv } from "./lib/apidog-env.js";
import { writeClickupEnv } from "./lib/clickup-env.js";
import { writeCopyNotices } from "./lib/copy-notice.js";
import { copyDocs, copySkills } from "./lib/copy-skills.js";
import { loadConfig, validateConfig, type SyncConfig } from "./lib/env.js";
import { gitPull } from "./lib/git.js";
import { detectPlatform } from "./lib/platform.js";

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const dryRun = process.argv.includes("--dry-run");

/** Um lugar onde um editor lê as skills pessoais desta máquina. */
type Destination = {
  editor: string;
  dest: string;
  envVarName: string;
};

function destinationsOf(config: SyncConfig): Destination[] {
  const list: Destination[] = [
    { editor: "Cursor", dest: config.skillsDest, envVarName: "SKILLS_DEST_PATH" },
  ];
  if (config.claudeSkillsDest) {
    list.push({
      editor: "Claude Code",
      dest: config.claudeSkillsDest,
      envVarName: "CLAUDE_SKILLS_DEST_PATH",
    });
  }
  return list;
}

async function main(): Promise<void> {
  const platform = detectPlatform();
  const config = loadConfig(repoRoot, dryRun);
  const destinations = destinationsOf(config);

  console.log(`\n🔄 space-cursor-skills sync`);
  console.log(`   Plataforma: ${platform}`);
  console.log(`   Origem:     ${config.skillsSource}`);
  for (const d of destinations) {
    console.log(`   Destino:    ${d.dest}  (${d.editor} · ${d.envVarName})`);
  }
  if (!config.claudeSkillsDest) {
    console.log(`   Claude Code: desligado (CLAUDE_SKILLS_DEST_PATH=off ou igual ao do Cursor)`);
  }
  if (dryRun) console.log(`   Modo:       dry-run (nada será alterado)\n`);
  else console.log("");

  validateConfig(config);

  if (config.gitPull) {
    console.log("📥 Atualizando repo (git pull)...");
    gitPull(config.repoRoot, config.dryRun);
  } else {
    console.log("⏭️  git pull desabilitado (GIT_PULL=false)");
  }

  for (const destination of destinations) {
    syncDestination(config, destination);
  }

  console.log(`\n   Reinicie o chat do Cursor / Claude Code para recarregar as skills.\n`);
}

/** Copia skills/ e docs/ para um destino, carimba o aviso de cópia e gera os .env das skills. */
function syncDestination(config: SyncConfig, destination: Destination): void {
  const { editor, dest, envVarName } = destination;
  console.log(`\n━━ ${editor}: ${dest}`);

  console.log("📂 Sincronizando skills...");
  const stats = copySkills(config.skillsSource, dest, config.dryRun);

  console.log("📂 Sincronizando docs (constituição)...");
  const docsSource = path.join(config.repoRoot, "docs");
  const docsStats = copyDocs(docsSource, dest, config.dryRun);
  if (docsStats.copied === 0 && docsStats.skipped === 0) {
    console.log("   (pasta docs/ ausente no repo — pulado)");
  }

  console.log("📝 Carimbando aviso de copia...");
  const noticed = writeCopyNotices(dest, {
    repoRoot: config.repoRoot,
    dryRun: config.dryRun,
    skillNames: stats.skills,
    envVarName,
  });
  if (noticed.length) {
    console.log(`   00-COPIA-LEIA-ME.md em: ${noticed.join(", ")}`);
  }

  if (config.clickup) {
    const written = writeClickupEnv(dest, config.clickup, config.dryRun);
    if (written.length) {
      console.log(`🔑 clickup.env atualizado em: ${written.join(", ")}`);
    }
  } else {
    console.log(
      "⚠️  CLICKUP_API_TOKEN/WORKSPACE_ID não configurados — clickup.env não gerado",
    );
  }

  if (config.apidog) {
    const written = writeApidogEnv(dest, config.apidog, config.dryRun);
    if (written.length) {
      console.log(`🔑 apidog.env atualizado em: ${written.join(", ")}`);
    }
  } else {
    console.log(
      "⚠️  APIDOG_ACCESS_TOKEN não configurado — apidog.env não gerado",
    );
  }

  console.log(`✅ ${editor} concluído`);
  console.log(`   Skills:  ${stats.skills.join(", ")}`);
  console.log(`   Docs:    ${docsStats.copied} arquivos → ${path.join(dest, "docs")}`);
  console.log(`   Arquivos (skills): ${stats.copied} copiados, ${stats.skipped} ignorados`);
}

main().catch((err: unknown) => {
  const message = err instanceof Error ? err.message : String(err);
  console.error(`\n❌ Erro: ${message}\n`);
  process.exit(1);
});
