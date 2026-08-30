import fs from "node:fs";
import path from "node:path";
import dotenv from "dotenv";
import { collectApidogVarsFromProcessEnv, type ApidogCreds } from "./apidog-env.js";
import type { ClickupCreds } from "./clickup-env.js";
import { defaultSkillsDest, expandHome } from "./platform.js";

export interface SyncConfig {
  repoRoot: string;
  skillsSource: string;
  skillsDest: string;
  gitPull: boolean;
  dryRun: boolean;
  clickup?: ClickupCreds;
  apidog?: ApidogCreds;
}

function parseBool(value: string | undefined, fallback: boolean): boolean {
  if (value === undefined || value.trim() === "") return fallback;
  return !["false", "0", "no", "off"].includes(value.trim().toLowerCase());
}

function opt(name: string): string | undefined {
  const v = process.env[name]?.trim();
  return v || undefined;
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
    config.clickup = {
      apiToken: token,
      workspaceId,
      listEsteira: opt("CLICKUP_LIST_ESTEIRA"),
      listImediatas: opt("CLICKUP_LIST_IMEDIATAS"),
      assigneeRicardo: opt("CLICKUP_ASSIGNEE_RICARDO"),
      customTypeImediata: opt("CLICKUP_CUSTOM_TYPE_IMEDIATA"),
      statusEsteiraPbi: opt("CLICKUP_STATUS_ESTEIRA_PBI"),
      cfProjeto: opt("CLICKUP_CF_PROJETO"),
      cfProjetoOptionBateu: opt("CLICKUP_CF_PROJETO_OPTION_BATEU"),
      cfProjetoOrderindexBateu: opt("CLICKUP_CF_PROJETO_ORDERINDEX_BATEU"),
    };
  }

  const apidogVars = collectApidogVarsFromProcessEnv();
  if (apidogVars.APIDOG_ACCESS_TOKEN) {
    config.apidog = { vars: apidogVars };
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
