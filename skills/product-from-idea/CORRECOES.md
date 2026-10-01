# Correções — product-from-idea

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F — `skill-update/playbook.md`, “Registrar correção”).
> Sem dado de cliente: descrever o padrão, não o produto. Mais recente em cima. O histórico completo do piloto (causas, o que funcionou, gaps) está em [`exemplos/piloto-licoes.md`](exemplos/piloto-licoes.md).

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde na skill |
|------|--------------------|-------|---------------------|---------------|
| 2026-09-30 | Ao promover o rascunho, sobraram nomes de produto em regra, caminhos antigos (crases vazias), títulos de rascunho e um “como começar” incompleto | Migração por troca automática de caminhos, sem leitura de fora | Revisão sem contexto obrigatória antes do sync de skill nova; seções Pré-requisitos e Como começar | `SKILL.md` · `reference/rules.md` · módulos 05, 07, 08, 10, 11 · `skill-update` (checklist C) |
| 2026-09-30 | Decisões tomadas nas telas não chegaram ao protótipo, MVP e contrato; a Revisão corrigiu três fases | “Um arquivo por fase” + “gate não reabre” sem regra de volta | Propagação | `reference/rules.md` · `shared/controller/AGENT.md` · critérios 8.11 e X.8 |
| 2026-09-30 | Templates induziam recado de processo no documento (“Qualidade: …”, “Gate F6”) | O próprio template trazia a linha | Notas “para o agente (não copiar)” | `templates/*` · `shared/docs-clarity.md` |
| 2026-09-30 | Dicionários rasos; a Revisão acrescentou cerca de 70 termos | Clareza só checada no fim | Lista do jargão que mais vaza + checklist de gravação | `shared/docs-clarity.md` |
| 2026-09-30 | Canvas sobrescrito por uma versão antiga; telas aprovadas refeitas | Duas janelas do editor; sem cópia; disco não conferido | Canvas protegido | `reference/passo-a-passo.md` Fase 8 · `modules/08-screens/` |
| 2026-09-30 | Um subagente rodou a Fase 8 inteira por dois dias | “Um subagente por fase” sem exceção para fase longa | Subagente novo por tela ou fatia | `reference/rules.md` · `shared/controller/AGENT.md` |
| 2026-09-30 | Workspace dentro de um repositório alheio; canvas sem versionamento | Fase 0 não conferia a casa do produto | Repositório próprio na Fase 0 | `reference/passo-a-passo.md` Fase 0 |
| 2026-09-30 | Sem modelo do `.docs/README.md`, que é o “onde estamos” do Controlador | Arquivo surgiu à mão no piloto | Template `docs-README.md` instalado na Fase 0 | `templates/docs-README.md` · `SKILL.md` |
| 2026-09-29 | Agente perguntava o que o Design System já respondia | Mantra “eu preciso que você me fale” sem limite | Perguntar só o necessário | `reference/rules.md` · `modules/08-screens/AGENT.md` |
| 2026-09-29 | Dados de exemplo conferidos entre telas; placeholder “X” levado para aprovação | Não estava escrito que exemplo é mockup | Dados de exemplo = mockup; valores fictícios aprovados | `reference/passo-a-passo.md` Fase 8 · `modules/08-screens/` |
| 2026-09-29 | Texto do botão principal decidido só nas telas; a cor da marca mudou no meio | Decisão de gosto deixada para depois dos componentes | Comparação antes dos componentes | `reference/passo-a-passo.md` Fase 7 · `modules/07-design-system/playbook.md` |
