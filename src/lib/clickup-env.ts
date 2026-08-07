import fs from "node:fs";
import path from "node:path";

export function writeClickupEnv(
  skillsDest: string,
  creds: { apiToken: string; workspaceId: string },
  dryRun: boolean,
): boolean {
  const skillDir = path.join(skillsDest, "project-context-doc");
  const envFile = path.join(skillDir, "clickup.env");

  if (!fs.existsSync(skillDir)) {
    return false;
  }

  const content = `# Gerado por npm run sync — não commitar
CLICKUP_API_TOKEN=${creds.apiToken}
CLICKUP_WORKSPACE_ID=${creds.workspaceId}
`;

  if (dryRun) {
    console.log(`🔍 [dry-run] escrever ${envFile}`);
    return true;
  }

  fs.writeFileSync(envFile, content, "utf8");
  return true;
}
