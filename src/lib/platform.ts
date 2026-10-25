import os from "node:os";
import path from "node:path";

export type Platform = "windows" | "linux" | "macos";

export function detectPlatform(): Platform {
  if (process.platform === "win32") return "windows";
  if (process.platform === "darwin") return "macos";
  return "linux";
}

/** Onde o Cursor lê as skills pessoais, se SKILLS_DEST_PATH estiver vazio. */
export function defaultSkillsDest(): string {
  return path.join(os.homedir(), ".cursor", "skills");
}

/** Onde o Claude Code lê as skills pessoais, se CLAUDE_SKILLS_DEST_PATH estiver vazio. */
export function defaultClaudeSkillsDest(): string {
  return path.join(os.homedir(), ".claude", "skills");
}

export function expandHome(input: string): string {
  if (input.startsWith("~/")) {
    return path.join(os.homedir(), input.slice(2));
  }
  if (input === "~") {
    return os.homedir();
  }
  return input;
}
