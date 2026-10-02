# Playbook — Fase 11 Tarefas

> Execução densa = skill **`po-techlead-scrum`** (pipeline Objetivo → Regra → Banco → Apidog → Tarefa, tom professor, publicação no ClickUp). Este playbook = só como a **fase 11 do product-from-idea** fatia o produto e orquestra o PO — **não** repete a skill.  
> Barra: [`target-model.md`](target-model.md) · Anexos reais: [`examples/README.md`](examples/README.md)

**Agent:** [`AGENT.md`](AGENT.md)

## Header

```text
**Fase 11 — Tarefas por fatia**
**Objetivo:** transformar o produto definido em tarefas que um desenvolvedor júnior executa sem adivinhar
**ON:** F7 + F5 (+ F6 nos gates)
**Skill:** po-techlead-scrum
```

## Pré-requisitos

- Revisão (Fase 9) liberou o caminho (fechado ou adiado com risco)  
- Manual comercial `.docs/{slug}.md` (Fase 10) fechado ou adiado com risco  
- Telas essenciais aprovadas em `.docs/telas.md` (Fase 8)  
- `setup.md` (repos + boilerplates) · `contrato.md` (o que guardar, quem faz o quê) · `mvp.md` (corte do dia 1)  
- Sem isso → voltar à fase que falta; não escrever tarefa sobre buraco

## Sequência (Controlador → subagente Tarefas)

### 0) Plano de fatias

Uma **fatia** é uma entrega que o time consegue fazer, provar e mostrar sozinha (ex.: “criar conta e ver saldo”, “buscar a partir da página do produto”). Não é “o back inteiro” nem “o front inteiro”.

1. Ler `mvp.md` (jornadas do dia 1), `telas.md` (telas aprovadas), `contrato.md` e `setup.md`.  
2. Propor o **plano de fatias** em `.docs/tarefas.md` (template `templates/tarefas.md`): ordem, o que cada fatia entrega, jornadas e telas cobertas, camadas (back · front · extensão), dependências.  
3. Conferir cobertura: **toda** jornada do dia 1 cai em alguma fatia. Fatias só do MVP; telas e itens da expansão futura ficam numa lista separada em `tarefas.md`, sem tarefa.  
4. **PARAR** → cliente aprova o plano (pode reordenar, juntar, cortar).

### 1) Uma fatia por vez — pipeline do PO

Para cada fatia, na ordem do plano, seguir `po-techlead-scrum` **sem pular passo**:

| # | Passo | Gate |
|---|-------|------|
| 1 | Objetivo — o quê, para quem, o que fica fora | Cliente confirma |
| 2 | Regra de negócio — casos de borda, limites | Cliente fecha |
| 3 | Banco — DBML + tabela coluna a coluna, a partir do contrato | Cliente valida |
| 4 | Rotas → Apidog — OpenAPI importado no projeto **deste** produto | Visível no Apidog |
| 5 | Tarefa — markdown professor em `.task/{projeto}/{fatia}.md` | Cliente: “pode publicar” |

Fatia só de tela, sem rota nova → pula o passo 4 (anotar o motivo no plano).

API pública publicada como portal pelo Apidog → rota pública no projeto separado definido no `setup.md` (o portal publica o projeto inteiro; rota interna ali vaza).

### 2) Referência visual das tarefas de tela

- **Prints das telas aprovadas na Fase 8** (canvas) = a referência visual da tarefa. Nome da tela igual ao de `telas.md`.  
- Ordem de prioridade: tema já existente no repositório (se houver) → Design System do produto + telas aprovadas → Design System do time → protótipo antigo ou construtor de app **só** para campos e ações, nunca cor.  
- Se `DIFERENCAS_PARA_DEVS.md` existir: cada diferença vira item da tarefa da fatia correspondente.

### 3) Publicação

Aprovação local explícita → publicação pelo fluxo da skill (lista, responsável, anexos) → link do ClickUp registrado na linha da fatia em `tarefas.md`.

### 4) Gate de fase

| Resultado | Significado |
|-----------|-------------|
| **fechado** | Todas as fatias do plano com tarefa aprovada (e publicada, se o cliente pediu) |
| **adiado com risco** | Cliente aceita começar o desenvolvimento com fatias ainda em aberto, listadas |
| **bloqueado** | Falta dado de contrato, banco ou Apidog para uma fatia crítica |

Atualizar `.docs/README.md`. **Fim da linha** agente + cliente — daqui para frente é dos devs.

## O que NÃO fazer

- Uma tarefa com o produto inteiro  
- Tarefa de tela sem print de tela aprovada na Fase 8  
- Banco ou rota inventados fora do contrato  
- Publicar sem aprovação local  
- Duas fatias abertas ao mesmo tempo na conversa

## Fora de escopo (apontar)

| Pedido | Para |
|--------|------|
| “Muda a tela” | Fase 8 · `design-system-apply` (nova rodada com OK) |
| “Audita o que o dev entregou” | `qa-space` |
| “Codar a fatia” | Devs |
