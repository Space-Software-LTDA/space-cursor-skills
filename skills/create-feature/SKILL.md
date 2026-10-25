---
name: create-feature
description: >-
  Conduz uma feature nova de ponta a ponta num projeto que já existe: demanda com o
  pedido literal → snapshot, dores e causas → impactos → regras de negócio e métricas →
  desenho no canvas (Pencil) com o DS geral e o DS do produto → "pode codar" do dono →
  banco e migrations → código com componente reutilizável → conferência lado a lado com
  o desenho em 3 larguras → revisão por subagente novo → validação do dono → PR para HML.
  Guarda só a ordem, os gates e os critérios; as regras moram na Constituição Space
  (docs/). Use com /create-feature, "nova feature", "feature nova", "criar funcionalidade",
  "implementar do zero com as regras".
disable-model-invocation: true
---

# Create Feature

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` (Cursor) ou `CLAUDE_SKILLS_DEST_PATH` (Claude Code) do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/create-feature/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo).  
> Hub de manutenção: **`/skill-update`**. Repo: **`AGENTS.md`**.

**Sempre responder em português.**

## Papel

Você é o **Controlador** ([`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §1) de uma feature nova num projeto que já tem código, regras do projeto e (de preferência) `docs/` versionado. Conduz as fases na ordem, abre **um subagente por fase** com o cartão do projeto, confere o "Pronto quando" pela evidência e leva ao dono só as decisões dele.

- **Dono** = quem pediu; decide regra, desenho, "pode codar" e validação final.
- **Esta skill** = a ordem, os gates e os critérios de cada fase. **Não** é fonte de regra: cada regra citada aponta para o arquivo da Constituição (arquivo + seção/ID). Proibido copiar regra para cá ou para o artefato.
- Linha de corte: a skill termina no **PR aberto para a `HML`**, com a demanda fechada. Não junta o PR.

## Quando usar · quando não usar

| Pedido | Skill |
|--------|-------|
| Feature nova (ou mudança grande) num produto que já existe, do pedido ao PR | **esta** |
| Produto novo, da ideia à tarefa | `product-from-idea` |
| Só escrever a tarefa para um dev implementar | `po-techlead-scrum` (a partir da demanda; [`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §8) |
| Auditar um front já feito | `qa-space` |
| Criar ou aplicar o DS do produto | `design-system-forge` / `design-system-apply` |
| Correção pequena (um texto, um botão) | O próprio chat, sem skill ([`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §1 regra 7) |

## Conteúdo genérico

Nada aqui pertence a um produto. Nomes de tabela, tela, cliente e fornecedor saem do projeto e da conversa. Caso real só em [`exemplos/`](exemplos/).

## Onde gravar

| O quê | Onde |
|-------|------|
| A feature (pedido, snapshot, dores, impactos, regras, decisões, etapas) | `docs/demandas/AAAA-MM-DD-slug/` do projeto ([`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §3) — versionado |
| Desenho | O arquivo de canvas do projeto (o caminho está nas regras do projeto) |
| Âncora desta skill | `.docs/create-feature/ANCORA.md` (fora do git; [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §5, linha "Repositório de código"); garantir `.docs/` no `.gitignore` do projeto |
| Projeto sem `docs/` versionado | Propor ao dono criar `docs/` com o índice e os moldes ([`../docs/_moldes/`](../docs/_moldes/)); sem OK, gravar em `.docs/create-feature/<slug>/` e avisar que fica fora do git |

## Como começar (primeira chamada)

1. **Ler, nesta ordem:** [`../docs/README.md`](../docs/README.md) (seção "Trabalho num projeto" e a linha desta skill) · [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) · [`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) · as **regras do projeto** (ex.: `.claude/CLAUDE.md`, `AGENTS.md`) — elas dizem as exceções à Constituição, a lista de áreas de impacto, o arquivo de canvas, o DS do produto, o dicionário de métricas e o ambiente local.
2. **Onde estou?** Repositório de código com regras do projeto → seguir. Pasta vazia ou ideia sem produto → parar e apontar `product-from-idea`.
3. **Já existe demanda para isso?** Procurar no índice (`docs/README.md` do projeto) e nas tags ([`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §4.5). Existe → retomar pela fase aberta dela.
4. **Gravar a âncora** (modelo em [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §5) apontando para este `SKILL.md`, a demanda e a fase atual.
5. Abrir a Fase 1.

**Retomada:** ler a âncora → reler este `SKILL.md` e [`fases.md`](fases.md) (só a fase aberta) → ler a ficha da demanda → seguir.

## Fases

Detalhe de cada fase (ler, passos, gate, anti-padrão típico): [`fases.md`](fases.md). Checklist de front (desenho, código e conferência): [`checklist-front.md`](checklist-front.md). Exemplos reais: [`exemplos/README.md`](exemplos/README.md).

```text
1 Demanda → 2 Snapshot, dores, causas e "já existe?" → 3 Impactos → 4 Regras de negócio e métricas
→ 5 Desenho no canvas ─┐
                       ├─ GATE "pode codar" (6)
→ 7 Banco e migrations → 8 Código → 9 Conferência lado a lado (3 larguras)
→ 10 Revisão por subagente novo → 11 Validação do dono no ambiente local → 12 PR para HML + fechamento
```

**Gates duros (nunca pular):**

- **Gate 1 — antes da Fase 5:** regras de negócio (Fase 4) aprovadas pelo dono.
- **Gate 2 — antes da Fase 7:** o dono disse explicitamente que pode codar ([`../docs/ui-gosto.md`](../docs/ui-gosto.md) §0.1 item 3). Aprovar desenho ou métrica **não** é ordem para codar.
- **Gate 3 — antes da Fase 12:** o dono validou no ambiente local ([`../docs/git-fluxo.md`](../docs/git-fluxo.md) "Validação do dono antes do git"). Nada vai ao git antes.

**Dispensas** (só com a frase do dono na tabela de decisões da demanda): Fase 5 quando a mudança de tela é mínima e o dono mandou ir direto ao código (ex.: acrescentar uma coluna); Fase 7 quando não há banco. A fase dispensada fica registrada como "dispensada — {motivo, data, frase}".

## Método de execução

Segue [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md): Controlador + subagente por fase · Pronto quando + exemplo real · revisor sem contexto · toda correção → lista de correções → `/skill-update` (registro em [`CORRECOES.md`](CORRECOES.md)). Cada fase executada vira uma **etapa** da demanda ([`../docs/_moldes/etapa.md`](../docs/_moldes/etapa.md)): o Controlador escreve 1–4, o subagente recebe o cartão [`../docs/_moldes/tarefa-subagente.md`](../docs/_moldes/tarefa-subagente.md) e preenche 5–8. Modelo do subagente pela complexidade e pelo risco (§1 regra 6).

**Âncora:** `.docs/create-feature/ANCORA.md` no repositório (fora do git). Proibido escrever no `AGENTS.md` do repositório ou nas regras do projeto.

| Etapa (fase) | Subagente | Entrega | Pronto quando | Exemplo real | Quem aprova |
|------|-----------|---------|---------------|--------------|-------------|
| 1 — Demanda | Não — Controlador | Pasta da demanda + `solicitacao-original.md` + linha no índice | Pasta no padrão `AAAA-MM-DD-slug`; pedido copiado sem edição; tags existentes no `TAGS.md`; linha no índice geral | [exemplos §1](exemplos/README.md#fase-1--demanda) | Controlador |
| 2 — Snapshot, dores, causas | Sim — levantamento (só leitura) | `snapshots/AAAA-MM-DD-antes.md` + dores `D…` e causas `C…` na ficha + "já existe?" | Snapshot com números **e** a consulta que os produz; cada causa marcada fato (com evidência) ou hipótese (com como confirmar); "já existe?" com o que foi achado ou "nada" | [exemplos §2](exemplos/README.md#fase-2--snapshot-dores-e-causas) | Dono (confirma as dores) |
| 3 — Impactos | Sim — levantamento | Tabela de impactos na ficha | Uma linha por área da lista do projeto (ou a mínima de `metodo-demandas.md` §4.6), cada uma "muda / não muda" + o que fazer | [exemplos §3](exemplos/README.md#fase-3--impactos) | Dono |
| 4 — Regras de negócio e métricas | Sim — redação; o Controlador leva as perguntas | Etapa de regras (`RN-1…`) + decisões + entradas no dicionário de métricas | Toda RN com um exemplo concreto; toda pergunta com resposta do dono ou recomendação aprovada; toda métrica da tela existe no dicionário; **Gate 1** registrado | [exemplos §4](exemplos/README.md#fase-4--regras-de-negócio-e-métricas) | Dono |
| 5 — Desenho no canvas | Sim — um por vez no canvas | Telas e popups no canvas + PNG exportado + tabela de casos na demanda | Parte A do [checklist de front](checklist-front.md) marcada com o nó/ID do canvas; toda ação que abre popup tem o popup; versão antiga no rascunho; tema de marca trocado sem sobra | [exemplos §5](exemplos/README.md#fase-5--desenho-no-canvas) | Dono (por tela) |
| 6 — Gate "pode codar" | Não — Controlador | Linha na tabela de decisões + status "em execução" | Frase literal do dono, com data, na tabela de decisões | [exemplos §6](exemplos/README.md#fase-6--pode-codar) | Dono |
| 7 — Banco e migrations | Sim — modelagem; depois implementação | Etapa de modelo de dados + migrations no(s) repo(s) | Modelo com cada coluna e o `BD-xx` que vale; checklist de [`banco.md`](../docs/banco.md) marcado; migration rodada **duas vezes** numa cópia sem erro e sem mudar nada na segunda | [exemplos §7](exemplos/README.md#fase-7--banco-e-migrations) | Dono (modelo) · Controlador (migration) |
| 8 — Código | Sim — um por fatia (back, front, por tela) | Código na branch da tarefa, dentro da pasta que o ambiente local lê | Testes do projeto passam (saída anexada); Parte B do checklist de front marcada com `arquivo:linha`; tabela "padrão do desenho → componente (`arquivo`)" na etapa | [exemplos §8](exemplos/README.md#fase-8--código) | Controlador |
| 9 — Conferência lado a lado | Sim — um por tela | Prints do navegador × PNG do canvas em 1280, 1536 e 1920 + tabela de diferenças | Parte C do checklist de front; um print por tela e largura, logado com usuário que vê todas as ações; diferença zero ou aceita pelo dono | [exemplos §9](exemplos/README.md#fase-9--conferência-lado-a-lado) | Controlador |
| 10 — Revisão sem contexto | Sim — **subagente novo** | Lista de achados por critério | Uma linha por critério com evidência; busca residual anotada; achados aplicados ou recusados pelo dono | [exemplos §10](exemplos/README.md#fase-10--revisão-sem-contexto) | Controlador + dono |
| 11 — Validação do dono | Não — Controlador | Aviso ao dono (o que testar, onde, com qual usuário) | Frase do dono aprovando, com data, na tabela de decisões (**Gate 3**) | [exemplos §11](exemplos/README.md#fase-11--validação-do-dono) | Dono |
| 12 — PR e fechamento | Sim — pacote do PR; Controlador fecha a demanda | PR para `HML` + snapshot depois + ficha fechada | PR aberto (não juntado) com "a migration roda sozinha no deploy" quando houver; snapshot depois com os mesmos números do antes; pendências e reaproveitamento na demanda e no índice; lista de correções enviada ao `/skill-update` | [exemplos §12](exemplos/README.md#fase-12--pr-e-fechamento) | Dono (junta o PR) |

**Revisor sem contexto:** Fase 10, sempre. Recebe só a demanda (ficha, regras, modelo, etapas), o diff, os prints da Fase 9, o "Pronto quando" de cada fase e os arquivos da Constituição citados — **nunca** a conversa. Também é usado na Fase 4 quando a regra mexe em dinheiro (modelo mais forte).

**Correções:** ao fim de cada fase, o Controlador monta a lista de correções ([`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §4) e usa o roteador: regra geral → Constituição/skill via `/skill-update`; regra do projeto → regras do projeto; decisão → tabela da demanda.

## Leis duras (resumo; o texto está nos arquivos citados)

- Sem pedido literal e snapshot, não há solução ([`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §4.1–§4.2).
- Impactos antes de mexer ([`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §6).
- Tela primeiro no canvas; código só com "pode codar" ([`../docs/ui-gosto.md`](../docs/ui-gosto.md) §0.1).
- Banco: centavos `…Cents`, UTC, `external…`, `jsonb` por fornecedor, FK pelo nosso id, migration idempotente ([`../docs/banco.md`](../docs/banco.md) BD-01…BD-13).
- Nada no git antes da validação do dono; PR para `HML`, nunca direto ([`../docs/git-fluxo.md`](../docs/git-fluxo.md)).

## Fora de escopo (apontar)

| Pedido | Para |
|--------|------|
| Juntar o PR, promover `HML` → `main`, deploy | O dono / Tech Lead ([`../docs/git-fluxo.md`](../docs/git-fluxo.md)) |
| Criar o DS do produto do zero | `design-system-forge` |
| Tarefa para outro dev implementar | `po-techlead-scrum` |
| Mudar esta skill | `/skill-update` |
