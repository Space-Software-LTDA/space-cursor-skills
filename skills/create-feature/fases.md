# Fases — create-feature

> Cada fase: **objetivo · ler (arquivo + seção da Constituição) · passos · pronto quando · anti-padrão típico**. A regra mora no arquivo citado; aqui fica só a ordem e o critério. Caminhos `../docs/` são os da cópia sincronizada (no repo: `docs/` na raiz).  
> Toda fase executada vira uma etapa da demanda ([`../docs/_moldes/etapa.md`](../docs/_moldes/etapa.md)), com 1–4 antes e 5–8 depois.  
> "Regras do projeto" = o arquivo de regras do repositório (ex.: `.claude/CLAUDE.md`). Quando ele registra uma **exceção** à Constituição (outro banco, outro canto, outra fonte), a exceção vale naquele projeto.

---

## Fase 1 — Demanda

**Objetivo:** a feature existe por escrito antes de qualquer conversa de solução.

**Ler:** [`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §3 (pastas) e §4.1 (registrar) · §5 (tags) · molde [`../docs/_moldes/demanda.md`](../docs/_moldes/demanda.md).

**Passos:**
1. Criar `docs/demandas/AAAA-MM-DD-slug/` com `README.md` (do molde), `solicitacao-original.md`, `snapshots/`, `etapas/`, `anexos/`.
2. Copiar o pedido do dono **sem edição** (inclusive os pedidos seguintes do mesmo assunto, com a data).
3. Tags que já existem no `TAGS.md` do projeto; tag nova entra lá primeiro, com o significado.
4. Linha no índice geral (`docs/README.md` do projeto) com status "aberta".

**Pronto quando:**
- A pasta segue o padrão e tem os cinco itens.
- `solicitacao-original.md` bate letra por letra com o pedido.
- Tags conferidas no `TAGS.md`; linha no índice geral.

**Anti-padrão típico:** resumir o pedido no lugar do literal; começar a propor solução na ficha antes do snapshot.

---

## Fase 2 — Snapshot, dores e causas

**Objetivo:** saber, com números, como está hoje e o que dói, antes de propor.

**Ler:** [`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §4.2 (snapshot), §4.3 (dor), §4.4 (causas), §4.5 (já existe?) · molde [`../docs/_moldes/snapshot.md`](../docs/_moldes/snapshot.md).

**Passos:**
1. Subagente de levantamento, **só leitura** (banco de cópia, código, telas, canvas): números que medem o problema, com a consulta ou o comando; exemplos reais com IDs; como funciona hoje com caminho de arquivo e tabela; riscos.
2. Dores `D1…` (quem sofre + o que acontece + por que é ruim) e causas `C1…` (fato com evidência · hipótese com como confirmar) na ficha.
3. "Já existe?": tags, catálogo de reaproveitamento do índice, código. Registrar o que achou.

**Pronto quando:**
- `snapshots/AAAA-MM-DD-antes.md` com números **e** as consultas que os produzem (para repetir no fechamento).
- Toda causa marcada fato ou hipótese; toda dor ligada a pelo menos uma causa.
- "Já existe?" preenchido (achado com caminho, ou "nada").
- O dono confirmou as dores.

**Anti-padrão típico:** dor escrita como solução ("falta uma tela X"); número sem a consulta; snapshot editado depois de pronto.

---

## Fase 3 — Impactos

**Objetivo:** saber o que mais muda antes de mexer.

**Ler:** [`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §4.6 · [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §6 ("Impactos antes de mexer") · a lista de áreas das regras do projeto.

**Passos:** uma linha por área (cada front e fork de cliente, dinheiro, métricas, banco, integrações, multi-cliente, operação, mais o que o projeto listar): muda ou não muda, por quê, o que fazer.

**Pronto quando:**
- Toda área da lista do projeto (ou a mínima do §4.6) tem linha, inclusive as que "não mudam".
- Cada impacto que muda tem ação (etapa, pendência ou decisão a pedir).

**Anti-padrão típico:** listar só o front que foi pedido e esquecer o cálculo de dinheiro, o painel de parceiros ou o fork de um cliente.

---

## Fase 4 — Regras de negócio e métricas

**Objetivo:** o comportamento fechado por escrito, antes de desenho e banco.

**Ler:** [`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §4.7 (decisões) · [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §6 ("Métrica num dicionário só", "Perguntar só o necessário", "Ideia não é ordem") · [`../docs/ui-gosto.md`](../docs/ui-gosto.md) §11.2 `GP-KPI-3SUB` e `GP-KPI-BIG-NUMBER` (se houver card de KPI) · [`../docs/banco.md`](../docs/banco.md) BD-01, BD-02 (quando a regra fala de valor ou de data).

**Passos:**
1. Escrever as perguntas que travam desenho e modelo, as principais primeiro; levar ao dono uma por vez, com recomendação.
2. Regras numeradas `RN-1…`, cada uma com um exemplo concreto (valores, datas, o que o usuário vê).
3. Cada métrica que vai aparecer: procurar no dicionário de métricas do projeto; não existe → criar a entrada (nome, definição, fórmula, fonte, data) antes de usar.
4. Decisões na tabela da demanda (data, decisão, motivo, quem); o que o agente concluiu sozinho fica marcado "proposta".

**Pronto quando:**
- Nenhuma pergunta que trave o desenho ou o modelo sem resposta do dono ou recomendação aprovada.
- Toda `RN` com exemplo.
- Toda métrica da feature com entrada no dicionário.
- **Gate 1:** o dono aprovou as regras (frase e data na tabela de decisões).

**Anti-padrão típico:** inventar rótulo ou fórmula de métrica; tratar comentário do dono como ordem; regra de dinheiro sem exemplo em centavos.

---

## Fase 5 — Desenho no canvas

**Objetivo:** o dono vê e aprova a tela antes de existir código.

**Ler:** [`../docs/ui-gosto.md`](../docs/ui-gosto.md) §0 (prioridade) e §0.1 (do desenho ao código) · o **DS do produto** (onde as regras do projeto disserem: fundamentos, componentes, ids no canvas) · [`../docs/design-system.md`](../docs/design-system.md) (método nos buracos) · [`checklist-front.md`](checklist-front.md) Parte A.

**Passos:**
1. Antes de desenhar: abrir o DS do produto no canvas e listar os componentes que a tela vai usar. Só criar o que não existe, como componente do DS.
2. Nova versão de tela = cópia da anterior melhorada; a antiga vai para o frame de rascunho (de topo, fora das telas atuais).
3. Desenhar cada tela e **cada popup** que uma ação abre (inclusive item de menu ⋮). Componente repetido (confirmação, modal, menu, toast): **um** exemplo desenhado + tabela de casos na demanda (título, texto, botões, itens).
4. Produto multi-cliente: trocar o tema de marca e conferir que nada da marca ficou na cor do primeiro ([`../docs/ui-gosto.md`](../docs/ui-gosto.md) §3.5).
5. Exportar o PNG de cada tela (é a régua da Fase 9). Um editor de canvas por vez.
6. Levar ao dono tela por tela; cada rodada de correção é registrada e a correção que vale para o mesmo componente é aplicada em todas as telas (§0.1 item 8).

**Pronto quando:**
- Parte A do checklist de front marcada, cada item com o nó/ID do canvas.
- Toda ação que abre popup tem o popup desenhado.
- Tabela de casos dos componentes repetidos na demanda.
- Peças soltas trocadas pelas do DS e a lista do que foi trocado entregue ao dono.
- PNG exportado de cada tela; aprovação do dono por tela registrada.

**Dispensa:** só com a frase do dono (ex.: "direto no código, só acrescentar a coluna"). Mesmo assim o código segue o checklist de front.

**Anti-padrão típico:** apagar a versão antiga; desenhar instância por instância; criar botão solto em vez de usar o do DS; esquecer o popup do item de menu.

---

## Fase 6 — Gate "pode codar"

**Objetivo:** separar definição de execução.

**Ler:** [`../docs/ui-gosto.md`](../docs/ui-gosto.md) §0.1 itens 2–3 · [`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §6 (status).

**Passos:** perguntar ao dono se pode codar, dizendo o que entra (fases 7–8) e o que fica de fora. Registrar a resposta literal.

**Pronto quando:** a frase do dono, com data, está na tabela de decisões e o status da demanda é "em execução" (ficha e índice).

**Anti-padrão típico:** ler "gostei do desenho" ou "aprovado o modelo" como "pode codar".

---

## Fase 7 — Banco e migrations

**Objetivo:** o modelo de dados certo na primeira vez, para todos os clientes.

**Ler:** [`../docs/banco.md`](../docs/banco.md) (inteiro; BD-01…BD-13 e o checklist de PR) · [`../docs/nomenclatura.md`](../docs/nomenclatura.md) "Banco de dados" · [`../docs/anti-padroes.md`](../docs/anti-padroes.md) AP-NAM-05, §C (AP-DB-*) · [`../docs/padrao-ouro.md`](../docs/padrao-ouro.md) GO-04, GO-13 · [`../docs/git-fluxo.md`](../docs/git-fluxo.md) "Migration vai junto com o código" · exceções de banco nas regras do projeto.

**Passos:**
1. **Modelo (só documento, numa etapa):** cada tabela e coluna com tipo e o `BD-xx` que a justifica (dinheiro, datas, ids externos, fornecedor, referências: BD-01…BD-07). Levar ao dono. Por ser documento, o modelo pode ser feito e aprovado **antes** do Gate 2, junto da Fase 4 ou 5 ([`../docs/ui-gosto.md`](../docs/ui-gosto.md) §0.1 item 2); as migrations, só depois do Gate 2.
2. **Migrations:** no mesmo PR do código, seguindo BD-08…BD-12 (genérica, idempotente, sem classe do app, em todos os repos que usam a coluna, colação, só por migration).
3. Testar numa **cópia** do banco: rodar, rodar de novo (nada muda), conferir a colação no banco real do ambiente.
4. Cache cujo formato muda → chave com versão nova (BD-13).

**Pronto quando:**
- Etapa de modelo com cada coluna e o `BD-xx`, aprovada pelo dono.
- Checklist de PR de [`banco.md`](../docs/banco.md) marcado item a item, com evidência.
- Saída das duas rodadas da migration na cópia (a segunda sem mudança).
- Lista dos repos que usam a coluna e a migration presente em cada um (mesmo nome e conteúdo).

**Dispensa:** feature sem banco — registrar "sem banco" na etapa.

**Anti-padrão típico:** `decimal` para dinheiro; data no fuso local; `gameCode`/`eventKey` em vez de `external…`; coluna fixa por fornecedor; ligar por e-mail; `UPDATE` direto no banco.

---

## Fase 8 — Código

**Objetivo:** implementar o que foi aprovado, com peças reutilizáveis.

**Ler:** [`checklist-front.md`](checklist-front.md) Parte B · [`../docs/frontend.md`](../docs/frontend.md) · [`../docs/padrao-ouro.md`](../docs/padrao-ouro.md) (GO-08, GO-11, GO-13) · [`../docs/anti-padroes.md`](../docs/anti-padroes.md) (AP-FE-*, e as partes de back que a fatia tocar) · back: [`../docs/backend.md`](../docs/backend.md) e [`../docs/entry-point.md`](../docs/entry-point.md) · [`../docs/git-fluxo.md`](../docs/git-fluxo.md) "Criar a branch da tarefa" · regras do projeto (stack, ambiente local, testes).

**Passos:**
1. Branch a partir da `HML` com o nome do padrão ([`../docs/nomenclatura.md`](../docs/nomenclatura.md) "Branches de feature"); trabalhar na pasta que o ambiente local lê.
2. Um subagente por fatia (back, cada tela). Dois subagentes nunca no mesmo arquivo.
3. Ponto de partida do front = o que o canvas exporta, não o visual padrão do framework ([`../docs/ui-gosto.md`](../docs/ui-gosto.md) §0.1 item 9).
4. Cada padrão do desenho (confirmação, modal de formulário, menu ⋮, cabeçalho de seção, card de KPI, skeleton) vira **um** componente, alimentado pela tabela de casos da Fase 5; se já existe no código, reaproveitar.
5. Testes do projeto rodando; reiniciar o que o ambiente local precisa.

**Pronto quando:**
- Testes passam (saída anexada na etapa; falha conhecida e anterior anotada como tal).
- Parte B do checklist de front marcada com `arquivo:linha`.
- Nenhuma cor digitada fora dos tokens (busca no diff anotada na etapa).
- Tabela "padrão do desenho → componente (`arquivo`)" na etapa, um componente por padrão.
- Código na branch, sem commit (o git espera a Fase 11).

**Anti-padrão típico:** visual padrão do framework no lugar do desenho; um modal copiado por tela; `fetch` na view; loading com atraso.

---

## Fase 9 — Conferência lado a lado

**Objetivo:** provar que a tela saiu igual ao desenho.

**Ler:** [`../docs/ui-gosto.md`](../docs/ui-gosto.md) §0.1 item 10 · §11.2 "Viewport de QA" (`GP-QA-3-WIDTHS`, `GP-TABLE-FIT`) · [`checklist-front.md`](checklist-front.md) Parte C.

**Passos:**
1. Um subagente por tela: print do navegador logado com um usuário que vê todas as ações, em **1280, 1536 e 1920 px CSS**, ao lado do PNG do canvas na mesma largura.
2. Comparar o que o §0.1 item 10 lista; abrir cada popup e cada estado (vazio, carregando, erro).
3. Tabela de diferenças; corrigir e repetir até zerar (diferença aceita: a do §0.1 item 10).
4. O subagente só encerra o navegador que ele mesmo abriu ([`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §1 regra 12).

**Pronto quando:**
- Um print por tela e largura, desta sessão, guardado em `anexos/` da demanda.
- Tabela de diferenças zerada ou com cada diferença aceita pelo dono.
- Nenhuma tabela passa da largura do card nas 3 larguras.

**Anti-padrão típico:** conferir lendo o HTML; validar só em 1440; não abrir os popups.

---

## Fase 10 — Revisão sem contexto

**Objetivo:** um olhar de fora antes de mostrar ao dono.

**Ler:** [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md) §3.

**Passos:** o Controlador abre um **subagente novo** e passa só: a demanda (ficha, regras, modelo, etapas), o diff, os prints da Fase 9, o "Pronto quando" de cada fase, os checklists ([`checklist-front.md`](checklist-front.md), o de [`banco.md`](../docs/banco.md)) e os arquivos da Constituição citados. Nunca a conversa. Revisão de dinheiro ou regra ambígua → modelo mais forte.

**Pronto quando:**
- Uma linha por critério, com evidência (proibido "1–7 OK").
- Busca residual anotada (resíduo de conversa, placeholder, cor digitada, `updatedAt` mostrado como evento, credencial).
- Cada achado aplicado (nova rodada da fase afetada) ou recusado pelo dono com motivo.

**Anti-padrão típico:** quem implementou revisa o próprio trabalho; revisão que recebe o histórico do chat.

---

## Fase 11 — Validação do dono

**Objetivo:** o dono usa a feature antes de ela ir ao git.

**Ler:** [`../docs/git-fluxo.md`](../docs/git-fluxo.md) "1. Validação do dono antes do git" · ambiente local nas regras do projeto.

**Passos:** código na pasta que o ambiente lê, serviços reiniciados; avisar o dono **o que testar, onde (endereço/porta) e com qual usuário**, em lista curta. Status "validação local" na ficha e no índice.

**Pronto quando:** **Gate 3** — a frase do dono aprovando, com data, na tabela de decisões. Correção pedida volta à fase dona (5, 7 ou 8) e repete 9–11.

**Anti-padrão típico:** commitar "para adiantar"; pedir validação sem dizer onde e o que testar.

---

## Fase 12 — PR e fechamento

**Objetivo:** entregar e deixar a demanda pronta para a próxima pessoa.

**Ler:** [`../docs/git-fluxo.md`](../docs/git-fluxo.md) "Tarefa → HML" e "Commits" · [`../docs/nomenclatura.md`](../docs/nomenclatura.md) "Commits" · [`../docs/metodo-demandas.md`](../docs/metodo-demandas.md) §4.9 (fechamento) e §4.10 (reaproveitamento).

**Passos:**
1. Commit no padrão; push; PR **para a `HML`** (`gh pr create --base HML`). Texto do PR: o que muda, como testar, e "a migration roda sozinha no deploy" quando houver. Não juntar.
2. Snapshot depois, com os mesmos números do antes, medidos do mesmo jeito, com a coluna "antes" ao lado.
3. Ficha e índice: status, pendências, reaproveitamento (peças principais no catálogo do índice); conhecimento novo do sistema em `docs/sistema/`.
4. Lista de correções da feature → `/skill-update` (regra geral) ou regras do projeto (regra local).

**Pronto quando:**
- Link do PR na ficha; PR aberto e não juntado.
- `snapshots/AAAA-MM-DD-depois.md` com os mesmos números do antes.
- Pendências e reaproveitamento na ficha e no índice; `docs/sistema/` atualizado se o funcionamento mudou.
- Lista de correções enviada (ou "nenhuma").

**Anti-padrão típico:** PR para `main`; fechar sem snapshot depois; reaproveitamento vazio.
