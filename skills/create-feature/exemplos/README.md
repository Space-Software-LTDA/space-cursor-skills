# Exemplos reais — create-feature

> Casos reais de um projeto de apostas online com vários clientes (cada "casa" tem banco e cor próprios), outubro de 2026. Servem de **forma** (estrutura, densidade, o que conta como evidência), não de conteúdo: o domínio deles não vira regra ([`../../docs/metodo-agentes.md`](../../docs/metodo-agentes.md) §2 regra 3).  
> Caso principal: **catálogo próprio de jogos** (o site mostrava o catálogo do fornecedor como vinha; a feature criou um catálogo nosso, com prioridade entre versões e troca automática). Casos de apoio citados onde mostram melhor a fase.

## Fase 1 — Demanda

Pasta `docs/demandas/2026-10-20-catalogo-jogos/` com ficha, `solicitacao-original.md` (o pedido no texto do dono, com erros de digitação e tudo), `snapshots/`, `etapas/`, `anexos/`. Tags que já existiam (`#site` `#painel` `#jogos` `#tela` `#migration`) e linha no índice com status "aberta".

## Fase 2 — Snapshot, dores e causas

Snapshot antes, só leitura, numa cópia do banco: "3.705 versões ativas para 3.361 nomes; o jogo mais popular 2× ativo no mesmo estúdio; imagem própria: 0 de 3.705" — cada número com a consulta SQL ao lado. Dor D1 "o jogador busca um jogo e vê o mesmo jogo várias vezes; não sabe qual abrir". Causa C1 (fato): "não existe catálogo nosso; a tabela é o espelho do fornecedor, uma linha por versão". "Já existe?": achou um custo por versão criado dias antes e uma troca automática primitiva — reaproveitados.

## Fase 3 — Impactos

Tabela com: site padrão e o fork de um cliente (busca, URL do jogo), painel (telas novas), cálculo de GGR e comissão (custo por versão), métricas (dimensão "jogo" nas fotos de métricas), banco (tabelas novas nos dois repos que dividem o banco), integração futura com outro fornecedor, operação (quem revisa jogo novo). O painel de parceiros entrou como "não muda: não lê jogos hoje".

## Fase 4 — Regras de negócio e métricas

Etapa de regras com RN-1…RN-14, cada uma com exemplo. Ex.: "prioridade em cascata: ordem por jogo; sem ela, por estúdio; acima, por fornecedor; sem nada configurado, menor custo e depois a mais jogada". Erro na versão da vez → sinalizada e fora por 24 h; 3 sinalizações seguidas → inativada. Perguntas levadas ao dono uma por vez, com recomendação; respostas na tabela de decisões com data.

## Fase 5 — Desenho no canvas

Telas do painel desenhadas no frame das telas atuais, com instâncias dos componentes do DS (botões, badges, tabela, modal). Dez rodadas de correção do dono, cada uma registrada em anexo; correções que valiam para todas as telas viraram regra (hoje em `ui-gosto.md` §11.2). Uma versão v1 apagada teve de ser recriada → regra "nunca apagar tela; antiga vai para o rascunho" (§0.1 item 5). Confirmações e menus: um exemplo desenhado + tabela de casos na demanda.

## Fase 6 — "Pode codar"

Linha na tabela de decisões: data + frase do dono "Continua o desenvolvimento, termina os jogos" + "desenho aprovado, liberado codar as telas". Antes disso, "modelo de dados aprovado" foi registrado à parte e **não** liberou código.

## Fase 7 — Banco e migrations

Etapa "modelo de dados" só em documento, aprovada antes do código: tabelas de estúdios, jogos e versões; FK para o nosso id; código do fornecedor numa tabela só, renomeado para `externalCode` na revisão; configuração do fornecedor em `json`. Migrations idempotentes nos dois repos que dividem o banco, com o mesmo nome e conteúdo, ensaiadas numa cópia. Uma coluna nova entrou em JOIN com tabela antiga e quebrou com "Illegal mix of collations" → migration de alinhamento (BD-12). Caso de apoio: uma feature de datas guardou o valor em centavos e trocou o fuso do banco para UTC com conversão só na exibição (BD-01, BD-02).

## Fase 8 — Código

Um subagente por fatia (catálogo no site, telas do painel, troca automática). Confirmação destrutiva, modal de formulário, menu ⋮ e card de KPI viraram componentes únicos do DS do painel, alimentados pelas tabelas de casos. Suíte de testes verde, com a falha conhecida e anterior anotada como tal.

## Fase 9 — Conferência lado a lado

Prints do painel × PNG do canvas por página. A primeira entrega foi validada só em 1440 e uma tabela vazou do card em 1280 → regra das 3 larguras (1280, 1536, 1920; `GP-QA-3-WIDTHS`). Outra entrega saiu com fonte, cantos e cores do framework em vez do desenho → regra "tela só é entregue depois do lado a lado" (§0.1 item 10).

## Fase 10 — Revisão sem contexto

Revisões por subagente novo, só com a demanda, o diff e os critérios: acharam colunas sem o prefixo `external…`, uma regra de piso ausente e um caso de rollback não ensaiado. Cada achado virou etapa de correção e passou por nova revisão curta.

## Fase 11 — Validação do dono

Aviso ao dono com roteiro curto: o que testar em cada porta do ambiente local (site padrão, fork do cliente, painel), com qual usuário, e as decisões que ainda esperavam por ele. Status "validação local" na ficha e no índice.

## Fase 12 — PR e fechamento

Pacote do PR revisado à parte, PR para `HML` com "a migration roda sozinha no deploy", sem juntar. Reaproveitamento na ficha: cascata de prioridade, componentes do DS do painel, migration de colação como modelo. Caso de apoio (dispensa da Fase 5): uma feature que só acrescentou as colunas "Criado em" e "Pago em" nas telas de depósito e saque foi direto ao código, com a frase do dono na tabela de decisões ("direto no código, só jogar uma coluna nova, sem mudar nada").
