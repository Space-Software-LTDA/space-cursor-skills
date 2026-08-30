import fs from "node:fs";
import path from "node:path";

export type ApidogCreds = {
  /** Só token da conta + base/versão. IDs de produto NÃO entram. */
  vars: Record<string, string>;
};

const ACCOUNT_KEYS = [
  "APIDOG_ACCESS_TOKEN",
  "APIDOG_API_BASE",
  "APIDOG_API_VERSION",
] as const;

const ALLOWED_KEYS = new Set<string>(ACCOUNT_KEYS);

function buildApidogEnvContent(vars: Record<string, string>): string {
  const lines = [`# Gerado por npm run sync — nao commitar`];
  const seen = new Set<string>();

  for (const key of ACCOUNT_KEYS) {
    const val = vars[key];
    if (val) {
      lines.push(`${key}=${val}`);
      seen.add(key);
    }
  }

  for (const key of Object.keys(vars).sort()) {
    if (seen.has(key)) continue;
    lines.push(`${key}=${vars[key]}`);
  }

  return `${lines.join("\n")}\n`;
}

export function collectApidogVarsFromProcessEnv(): Record<string, string> {
  const out: Record<string, string> = {};
  for (const [key, raw] of Object.entries(process.env)) {
    if (!ALLOWED_KEYS.has(key)) continue;
    const val = raw?.trim();
    if (val) out[key] = val;
  }
  return out;
}

/** Grava apidog.env na skill po-techlead-scrum. */
export function writeApidogEnv(
  skillsDest: string,
  creds: ApidogCreds,
  dryRun: boolean,
): string[] {
  const content = buildApidogEnvContent(creds.vars);
  const written: string[] = [];
  const targets = ["po-techlead-scrum"];

  for (const skill of targets) {
    const skillDir = path.join(skillsDest, skill);
    if (!fs.existsSync(skillDir)) continue;

    const envFile = path.join(skillDir, "apidog.env");
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
