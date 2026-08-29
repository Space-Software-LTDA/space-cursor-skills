import fs from "node:fs";
import path from "node:path";

const SKIP_DIRS = new Set(["__pycache__", ".git"]);
const SKIP_FILES = new Set(["clickup.env", ".DS_Store", "Thumbs.db"]);

export interface CopyStats {
  copied: number;
  skipped: number;
  skills: string[];
}

function shouldSkip(name: string, isDir: boolean): boolean {
  if (isDir && SKIP_DIRS.has(name)) return true;
  if (!isDir && SKIP_FILES.has(name)) return true;
  if (!isDir && name.endsWith(".pyc")) return true;
  if (!isDir && name === "00-COPIA-LEIA-ME.md") return true;
  return false;
}

function copyEntry(
  src: string,
  dest: string,
  dryRun: boolean,
  stats: CopyStats,
): void {
  const entry = path.basename(src);
  const stat = fs.statSync(src);

  if (shouldSkip(entry, stat.isDirectory())) {
    stats.skipped++;
    return;
  }

  if (stat.isDirectory()) {
    if (!dryRun) fs.mkdirSync(dest, { recursive: true });
    for (const child of fs.readdirSync(src)) {
      copyEntry(path.join(src, child), path.join(dest, child), dryRun, stats);
    }
    return;
  }

  if (!dryRun) {
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.copyFileSync(src, dest);
  }
  stats.copied++;
}

export function copySkills(
  source: string,
  dest: string,
  dryRun: boolean,
): CopyStats {
  const stats: CopyStats = { copied: 0, skipped: 0, skills: [] };

  if (!dryRun) {
    fs.mkdirSync(dest, { recursive: true });
  }

  for (const entry of fs.readdirSync(source, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;

    const skillName = entry.name;
    const srcSkill = path.join(source, skillName);
    const destSkill = path.join(dest, skillName);

    copyEntry(srcSkill, destSkill, dryRun, stats);
    stats.skills.push(skillName);
  }

  return stats;
}

/**
 * Copia `docs/` da raiz do repo para `{SKILLS_DEST_PATH}/docs/`.
 * Sem isso o agente no Cursor não lê a constituição (skills só apontam para `../docs/`).
 */
export function copyDocs(
  source: string,
  skillsDest: string,
  dryRun: boolean,
): CopyStats {
  const stats: CopyStats = { copied: 0, skipped: 0, skills: [] };
  const dest = path.join(skillsDest, "docs");

  if (!fs.existsSync(source)) {
    return stats;
  }

  copyEntry(source, dest, dryRun, stats);
  stats.skills.push("docs");
  return stats;
}
