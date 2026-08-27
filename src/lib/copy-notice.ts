import fs from "node:fs";
import path from "node:path";

/**
 * Carimba aviso em cada skill no destino (SKILLS_DEST_PATH do .env desta maquina).
 * Esta pasta e COPIA — editar no repo space-cursor-skills e rodar npm run sync.
 */
export function writeCopyNotices(
  skillsDest: string,
  opts: {
    repoRoot: string;
    dryRun: boolean;
  },
): string[] {
  if (!fs.existsSync(skillsDest)) return [];

  const written: string[] = [];
  const repoUrl = "https://github.com/Space-Software-LTDA/space-cursor-skills";
  const repoRoot = opts.repoRoot;

  for (const entry of fs.readdirSync(skillsDest, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    // pular pastas que nao sao skills do repo (plugins etc.)
    const skillDir = path.join(skillsDest, entry.name);
    const skillMd = path.join(skillDir, "SKILL.md");
    if (!fs.existsSync(skillMd)) continue;

    const sourcePath = path.join(repoRoot, "skills", entry.name);
    const content = `# ⚠️ COPIA — nao edite aqui

Os arquivos desta pasta (\`${entry.name}\`) sao uma **copia** gerada pelo sync nesta maquina.

**Destino atual:** \`${skillsDest}\`  
(vem de \`SKILLS_DEST_PATH\` no \`.env\` da raiz do repo — PC local e Coders usam paths diferentes)

## Onde alterar

1. Edite em: \`${sourcePath}\`
2. Repo: [${repoUrl}](${repoUrl})
3. Depois rode **nesta maquina** (usa o \`.env\` local):

\`\`\`bash
cd ${repoRoot}
npm run sync
\`\`\`

## Credenciais ClickUp

Ficam no \`.env\` da **raiz** do \`space-cursor-skills\` (nao nesta pasta).
O sync gera \`clickup.env\` aqui a partir desse \`.env\`.

---
_Gerado automaticamente por \`npm run sync\`. Nao versionar este arquivo no destino._
`;

    const noticePath = path.join(skillDir, "00-COPIA-LEIA-ME.md");
    if (opts.dryRun) {
      console.log(`🔍 [dry-run] escrever ${noticePath}`);
    } else {
      fs.writeFileSync(noticePath, content, "utf8");
    }
    written.push(entry.name);
  }

  return written;
}
