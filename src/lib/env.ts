import fs from "node:fs";
import path from "node:path";
import dotenv from "dotenv";
import { defaultSkillsDest, expandHome } from "./platform.js";

export interface SyncConfig {
  repoRoot: string;
  skillsSource: string;
  skillsDest: string;
  gitPull: boolean;
  dryRun: boolean;
  clickup?: {
    apiToken: string;
    workspaceId: string;
  };
}

function parseBool(value: string | undefined, fallback: boolean): boolean {
  if (value === undefined || value.trim() === "") return fallback;
  return !["false", "0", "no", "off"].includes(value.trim().toLowerCase());
}

export function loadConfig(repoRoot: string, dryRun: boolean): SyncConfig {
  const envPath = path.join(repoRoot, ".env");
  if (fs.existsSync(envPath)) {
    dotenv.config({ path: envPath });
  }

  const destRaw = process.env.SKILLS_DEST_PATH?.trim();
  const skillsDest = expandHome(destRaw || defaultSkillsDest());

  const token = process.env.CLICKUP_API_TOKEN?.trim();
  const workspaceId = process.env.CLICKUP_WORKSPACE_ID?.trim();

  const config: SyncConfig = {
    repoRoot,
    skillsSource: path.join(repoRoot, "skills"),
    skillsDest,
    gitPull: parseBool(process.env.GIT_PULL, true),
    dryRun,
  };

  if (token && workspaceId) {
    config.clickup = { apiToken: token, workspaceId };
  }

  return config;
}

export function validateConfig(config: SyncConfig): void {
  if (!fs.existsSync(config.skillsSource)) {
    throw new Error(`Pasta de origem não encontrada: ${config.skillsSource}`);
  }

  if (!config.skillsDest.trim()) {
    throw new Error("SKILLS_DEST_PATH está vazio. Configure no .env");
  }
}
