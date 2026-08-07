import { execSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

function hasRemote(repoRoot: string): boolean {
  try {
    const out = execSync("git remote", { cwd: repoRoot, encoding: "utf8" }).trim();
    return out.length > 0;
  } catch {
    return false;
  }
}

export function gitPull(repoRoot: string, dryRun: boolean): void {
  const gitDir = path.join(repoRoot, ".git");
  if (!fs.existsSync(gitDir)) {
    console.log("ℹ️  Sem repositório Git — pulando git pull");
    return;
  }

  if (!hasRemote(repoRoot)) {
    console.log("ℹ️  Sem remote configurado — pulando git pull");
    return;
  }

  if (dryRun) {
    console.log("🔍 [dry-run] git pull");
    return;
  }

  try {
    execSync("git pull --ff-only", {
      cwd: repoRoot,
      stdio: "inherit",
    });
  } catch {
    throw new Error(
      "git pull falhou. Resolva conflitos ou use GIT_PULL=false no .env",
    );
  }
}
