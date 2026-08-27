import fs from "node:fs";
import path from "node:path";

export type ClickupCreds = {
  apiToken: string;
  workspaceId: string;
  /** Opcionais — usados pela skill po-techlead-scrum */
  listEsteira?: string;
  listImediatas?: string;
  assigneeRicardo?: string;
  customTypeImediata?: string;
  statusEsteiraPbi?: string;
  cfProjeto?: string;
  cfProjetoOptionBateu?: string;
  cfProjetoOrderindexBateu?: string;
};

function buildClickupEnvContent(creds: ClickupCreds): string {
  const lines = [
    `# Gerado por npm run sync — nao commitar`,
    `CLICKUP_API_TOKEN=${creds.apiToken}`,
    `CLICKUP_WORKSPACE_ID=${creds.workspaceId}`,
  ];

  const optional: Array<[string, string | undefined]> = [
    ["CLICKUP_LIST_ESTEIRA", creds.listEsteira],
    ["CLICKUP_LIST_IMEDIATAS", creds.listImediatas],
    ["CLICKUP_ASSIGNEE_RICARDO", creds.assigneeRicardo],
    ["CLICKUP_CUSTOM_TYPE_IMEDIATA", creds.customTypeImediata],
    ["CLICKUP_STATUS_ESTEIRA_PBI", creds.statusEsteiraPbi],
    ["CLICKUP_CF_PROJETO", creds.cfProjeto],
    ["CLICKUP_CF_PROJETO_OPTION_BATEU", creds.cfProjetoOptionBateu],
    ["CLICKUP_CF_PROJETO_ORDERINDEX_BATEU", creds.cfProjetoOrderindexBateu],
  ];

  for (const [key, val] of optional) {
    if (val && val.trim()) lines.push(`${key}=${val.trim()}`);
  }

  return `${lines.join("\n")}\n`;
}

/** Grava clickup.env em cada skill que consome ClickUp. */
export function writeClickupEnv(
  skillsDest: string,
  creds: ClickupCreds,
  dryRun: boolean,
): string[] {
  const content = buildClickupEnvContent(creds);
  const written: string[] = [];

  const targets = ["project-context-doc", "po-techlead-scrum"];

  for (const skill of targets) {
    const skillDir = path.join(skillsDest, skill);
    if (!fs.existsSync(skillDir)) continue;

    const envFile = path.join(skillDir, "clickup.env");
    if (dryRun) {
      console.log(`🔍 [dry-run] escrever ${envFile}`);
      written.push(skill);
      continue;
    }
    fs.writeFileSync(envFile, content, "utf8");
    written.push(skill);
  }

  return written;
}
