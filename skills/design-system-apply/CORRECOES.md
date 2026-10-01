# Correções — design-system-apply

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F — `skill-update/playbook.md`, “Registrar correção”).
> Sem dado de cliente: descrever o padrão, não o produto. Mais recente em cima.

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde na skill |
|------|--------------------|-------|---------------------|---------------|
| 2026-09-30 | Arquivo do canvas sobrescrito com uma versão antiga; telas aprovadas refeitas a partir dos prints | Duas janelas do editor; edição sem cópia; arquivo não conferido no disco | Arquivo do canvas protegido (cópia antes e depois, um editor, conferir o disco) | `SKILL.md` Fase C “Como corrigir” · `VISUAL_QA_METHOD.md` checklist |
| 2026-09-29 | Agente apontava diferenças de dados de exemplo entre telas (mesmo produto com preço diferente) | Não estava escrito que dado de exemplo é mockup | Dados de exemplo = mockup; placeholder “X” continua achado | `SKILL.md` Fase C “Como corrigir” |
| 2026-09-29 | Valores de crédito como “X” levados para aprovação | Placeholder não era achado | Placeholder é achado → valor fictício aprovado uma vez | `SKILL.md` Fase C · `VISUAL_QA_METHOD.md` checklist |
| 2026-09-30 | Palavra de especialista (“ranking”) em texto de tela para o público | A conferência olhava só visual, não a linguagem do texto | Texto de tela no teste do leigo (P1) | `SKILL.md` Fase C · `VISUAL_QA_METHOD.md` checklist |
| 2026-09-29 | Humano pediu “me pergunte só o que for necessário”: o agente pedia OK de coisas que o DS já respondia | Faltava separar decisão de produto de correção coberta por regra | Corrigir e informar o que a regra responde; perguntar só produto e gosto sem regra | `SKILL.md` Fase C “Como corrigir” |
| 2026-09-30 | Bloco e estado novos aprovados nas telas não chegaram ao protótipo e à especificação | Decisão ficava só no relatório | Registrar também na fonte de produto do projeto | `SKILL.md` Fase C “Como corrigir” |
| 2026-09-28 | Tela-prova exigida no celular num produto só de computador | Regra fixa computador + celular | Superfícies = as do diagnóstico | `SKILL.md` Etapa 0, Fase B item 3, Fase C · `VISUAL_QA_METHOD.md` |
