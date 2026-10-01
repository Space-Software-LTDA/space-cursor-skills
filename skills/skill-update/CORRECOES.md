# Correções — skill-update

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F — `skill-update/playbook.md`, “Registrar correção”).
> Sem dado de cliente: descrever o padrão, não o produto. Mais recente em cima.

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde na skill |
|------|--------------------|-------|---------------------|---------------|
| 2026-09-30 | Skill nova promovida de um rascunho com resíduos (nomes de produto, caminhos antigos) só achados na revisão | Checklist de skill nova não pedia revisão de fora | Revisão sem contexto antes do sync de skill nova | `SKILL.md` checklist C · `playbook.md` (Criar skill nova) |
| 2026-09-30 | Em conversa longa o agente perdia o papel da skill (o texto da skill sai do contexto quando o histórico é resumido) | O texto da skill entra uma vez; só regra sempre ativa e `AGENTS.md` são reinjetados | Âncora curta no projeto, que aponta para a skill (§5 do método); regra sempre ativa só em workspace dedicado | `docs/metodo-agentes.md` §5 · `SKILL.md` (Método de execução, checklist C) · linha “Âncora” em cada skill |
| 2026-09-30 | Correções feitas pelo humano ou pelo revisor ficavam só na conversa e voltavam na próxima vez | Não existia caminho da correção até a skill | Fluxo F “Registrar correção” + `CORRECOES.md` em toda skill + seção “Método de execução” obrigatória | `SKILL.md` (Wizard, Fluxo F, Método de execução, checklists) · `playbook.md` · `docs/metodo-agentes.md` |
