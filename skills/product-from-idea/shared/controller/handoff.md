# Handoff entre fases / subagentes (limpar contexto)

> **Padrão canônico:** Controlador no chat principal · **um subagente por fase** · ao fechar o gate o subagente **encerra**.  
> Ônibus da verdade = `docs/` — **não** o transcript do subagente encerrado.

---

## Papéis

| Papel | Onde | Faz |
|-------|------|-----|
| **Controlador** | Chat principal | Declara a fase; abre o subagente; valida `docs/` + gate do cliente; gera a passagem de bastão; **não** mistura as fases no próprio contexto |
| **Agente da fase** | Subagente (Task / multi-agent) | Só aquela etapa; eco→confirma→grava; contexto limpo |
| **Forge / Apply / po-techlead** | Subagente ou skill | DS (7, Forge) · Telas (8, Apply) · Manual (10) · Tarefas (11, po-techlead) |

**Ciclo:** abrir o subagente → trabalho até o gate → Controlador confirma arquivo + palavra do cliente → **subagente encerra** → passagem de bastão → abrir o subagente da próxima fase.

Fallback (sem Task): chat **novo** por fase + mesmo cartão abaixo.

---

## Cartão de handoff (Controlador → subagente)

```text
Você é o agente da Fase N — {nome}.
Objetivo: {1 linha}.
Verdade: `docs/{arquivo}.md` (criar do template se não existir)
Âncora: {arquivos fechados relevantes}
Feito até agora: {3 bullets}
Aberto: {ou “nenhum”}
Ler antes: {SKILL_DIR}/modules/{fase}/AGENT.md · playbook.md · target-model.md · examples/README.md · ../docs/metodo-agentes.md
Pronto quando: {copiado da linha da fase na tabela “Método de execução” do SKILL.md}
Leis: eco→confirma→grava (termo interno; com o cliente: “resumo do que entendi”) · especialista→leigo · docs padronizados · Dicionário · um gate · não batizar · **abrir target-model.md + ≥1 anexo** · **docs-clarity.md** (teste do estranho + posicionamento do leigo) · **anti-rush.md** (ler o arquivo inteiro antes de gravar; não otimizar para fechar rápido)
Propagação: decisão que mexe em fase anterior → replace no arquivo dono na mesma rodada (`reference/rules.md` → Propagação). Pergunte ao cliente só decisão de produto ou gosto sem regra, sempre com o resumo e o contexto visíveis no chat antes da pergunta.
Ao fechar: atualizar Gate no `docs/`; devolver ao Controlador o path + status + o que foi propagado para outras fases (não continue para a próxima fase).
```

Apontar também o subagente para: `modules/{fase}/AGENT.md` + `playbook.md` + `target-model.md` + `examples/README.md` + **`shared/docs-clarity.md`** + **`shared/anti-rush.md`**.

**Telas (Fase 8):** conferência do DS com o gosto (uma vez) → Home no tema principal → por tela: OK do cliente → Apply só nessa tela → novo OK se algo mudou → próxima. Site = computador; celular só se o cliente pedir. Tudo registrado em `telas.md`. Mudança no DS = nova versão com motivo (a Fase 7 não reabre). No cartão, sempre: caminho do canvas, “um só editor aberto com o arquivo”, “cópia com data em `copias/` antes e depois da rodada”, “dados de exemplo são mockup”. Subagente novo por tela (ou quando a conversa ficar longa).

**Revisor (Fase 9):** barra máxima anti-pressa — duas passagens · **uma linha por CA** · busca residual anotada · prints das telas essenciais abertos (R15). Controlador **rejeita** `revisao.md` com `3.1–3.7 OK` ou residual sem evidência.

**Tarefas (Fase 11):** plano de fatias aprovado em `tarefas.md` → uma fatia por vez pelo pipeline `po-techlead-scrum`.

**Exemplos:** `modules/{fase}/examples/README.md` → `examples/anexos/` (casos reais) + `target-model.md` (estrutura + CA + anti-padrões). **Proibido** inventar exemplo.

## Cartão de retorno (subagente → Controlador)

```text
Fase N — status: fechado | adiado com risco | bloqueado | em validação
Arquivo: `docs/{arquivo}.md`
Pendências do cliente: …
Propagado para outras fases: {arquivo → o que mudou} | nada
Pronto para encerrar / próximo handoff: sim|não
```
