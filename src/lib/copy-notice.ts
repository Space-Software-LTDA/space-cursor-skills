import fs from "node:fs";
import path from "node:path";

/**
 * Carimba aviso em cada skill do repo no destino (SKILLS_DEST_PATH ou CLAUDE_SKILLS_DEST_PATH).
 * Esta pasta e COPIA — editar no repo space-cursor-skills e rodar npm run sync.
 * So carimba as skills que vieram do repo (opts.skillNames): pastas de terceiros no
 * destino (plugins, skills pessoais, `synced/` do Claude Code) nao sao tocadas.
 */
export function writeCopyNotices(
  skillsDest: string,
  opts: {
    repoRoot: string;
    dryRun: boolean;
    skillNames: string[];
    envVarName: string;
  },
): string[] {
  if (!fs.existsSync(skillsDest)) return [];

  const written: string[] = [];
  const repoUrl = "https://github.com/Space-Software-LTDA/space-cursor-skills";
  const repoRoot = opts.repoRoot;
  const fromRepo = new Set(opts.skillNames);

  for (const entry of fs.readdirSync(skillsDest, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    // pular pastas que nao sao skills do repo (plugins, skills pessoais etc.)
    if (!fromRepo.has(entry.name)) continue;
    const skillDir = path.join(skillsDest, entry.name);
    const skillMd = path.join(skillDir, "SKILL.md");
    if (!fs.existsSync(skillMd)) continue;

    const sourcePath = path.join(repoRoot, "skills", entry.name);
    const content = `# ⚠️ COPIA — nao edite aqui

Os arquivos desta pasta (\`${entry.name}\`) sao uma **copia** gerada pelo sync nesta maquina.

**Destino atual:** \`${skillsDest}\`  
(vem de \`${opts.envVarName}\` no \`.env\` da raiz do repo — PC local e Coders usam paths diferentes)

## Onde alterar

1. Edite em: \`${sourcePath}\`
2. Repo: [${repoUrl}](${repoUrl})
3. **OBRIGATORIO — rode o Sync** nesta maquina (sem isso a copia nao atualiza):

\`\`\`bash
cd ${repoRoot}
npm run sync
\`\`\`

O Sync usa o \`.env\` local (\`SKILLS_DEST_PATH\`, \`CLAUDE_SKILLS_DEST_PATH\`, ClickUp e Apidog) e copia para os dois destinos (Cursor e Claude Code).

## Credenciais ClickUp / Apidog

Ficam no \`.env\` da **raiz** do \`space-cursor-skills\` (nao nesta pasta).
O sync gera \`clickup.env\` e \`apidog.env\` aqui a partir desse \`.env\`.

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

  const docsDest = path.join(skillsDest, "docs");
  if (fs.existsSync(docsDest) && fs.statSync(docsDest).isDirectory()) {
    const docsSource = path.join(repoRoot, "docs");
    const docsNotice = `# ⚠️ COPIA — nao edite aqui

Os arquivos desta pasta (\`docs/\`) sao uma **copia** da constituição do time, gerada pelo sync nesta maquina.

**Destino atual:** \`${docsDest}\`  
(vem de \`${opts.envVarName}\` no \`.env\` da raiz do repo — PC local e Coders usam paths diferentes)

## Onde alterar

1. Edite em: \`${docsSource}\`
2. Repo: [${repoUrl}](${repoUrl})
3. **OBRIGATORIO — rode o Sync** nesta maquina:

\`\`\`bash
cd ${repoRoot}
npm run sync
\`\`\`

Skills leem estes arquivos via \`../docs/<arquivo>.md\`. Comecar pelo \`README.md\` (roteador).

---
_Gerado automaticamente por \`npm run sync\`. Nao versionar este arquivo no destino._
`;
    const docsNoticePath = path.join(docsDest, "00-COPIA-LEIA-ME.md");
    if (opts.dryRun) {
      console.log(`🔍 [dry-run] escrever ${docsNoticePath}`);
    } else {
      fs.writeFileSync(docsNoticePath, docsNotice, "utf8");
    }
    written.push("docs");
  }

  return written;
}
