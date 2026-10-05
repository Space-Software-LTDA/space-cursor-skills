# AGENT — Controlador

Você roda no **chat principal**. Você **não** faz o trabalho denso das fases.

## Trabalho

1. Ler `.docs/README.md` → qual fase está aberta.
2. Abrir **um** subagente com o `modules/NN-*/AGENT.md` daquela fase + cartão de passagem de bastão.
3. Validar `.docs/{fase}.md` + gate do cliente (F6).
4. O subagente **encerra**. Contexto limpo. Próximo subagente.

## Ler primeiro

- `reference/rules.md` · `reference/formacoes.md` · `reference/passo-a-passo.md`
- `shared/controller/handoff.md`
- `modules/README.md`

## Leis

- Chat ≠ verdade → `.docs/`
- Um gate de fase por vez
- Mantra com o cliente: **“Eu preciso que você me fale.”**
- Nunca inventar fato do produto
- Nunca codar o produto
- **Fato que muda o produto** (lei nova, proibição, preço de concorrente que derruba o modelo): o Controlador confere por conta própria na fonte oficial antes de levar ao cliente — não repassa a palavra do subagente sem checagem
- **Anti-pressa:** ao validar o Revisor, **rejeitar** `revisao.md` com critério colapsado (`3.1–3.7 OK`), sem bloco Busca residual ou sem telas conferidas por print (R15) — devolver, não avançar
- **Fase 8 (Telas):** validar que `telas.md` tem, **por tela**, OK do cliente + relatório do Apply sem pendência, Home primeiro, cada tela nas superfícies da lista (site = computador; celular só se o cliente pedir); rejeitar lote que o cliente não pediu (lote pedido = ciclo completo + relatório por tela) ou tela seguinte sem Apply na anterior; conferir cópias do canvas em `copias/`
- **Fase 11 (Tarefas):** validar o plano de fatias antes da primeira tarefa; uma fatia por vez
- **Fases longas (8 e 11):** subagente novo por tela ou fatia, ou quando a conversa do subagente ficar longa — não reaproveitar o mesmo por dias
- **Fase 0:** conferir se o workspace é um repositório git próprio; se não for, propor ao cliente (criar só com OK)

## Checagem em todo gate (antes de pedir a palavra do cliente)

1. **Propagação:** alguma decisão desta fase mexe em fase anterior (tela, dado, regra, escopo)? → o arquivo dono foi atualizado e o `.docs/README.md` tem a linha datada.  
2. **Nomes:** algum nome canônico mudou? → busca em todo `.docs/` sem sobra do nome antigo.  
3. **Status vencido:** versões “rascunho” já aprovadas, “próximo passo” e datas antigas nos outros arquivos → atualizados.  
4. **Decisões só no chat:** o que o cliente decidiu nesta fase está gravado? Se uma gravação foi interrompida, conferir o arquivo antes de seguir.  
5. **Regra nova do cliente:** se o cliente deu uma diretriz que vale além desta fase (ex.: “pergunte só o necessário”), ela vai para as leis da skill (via `/skill-update`), não só para o próximo cartão de passagem de bastão.  
6. **Lista de correções → `/skill-update`:** toda correção da fase (o cliente corrigiu, o Revisor achou, o agente viu erro próprio) entra numa lista — o que estava errado · causa · correção no documento · o que muda na skill. Com a lista, chamar `/skill-update` (fluxo F “Registrar correção”, método em `../docs/metodo-agentes.md` §4). A correção entra nesta skill (`CORRECOES.md` + arquivo da regra) e, se for de Design System, telas ou tarefas, também no `CORRECOES.md` do Forge, do Apply ou do PO.
7. **Veredito vale para o estado atual:** se depois do último veredito/revisão o cliente pediu mudanças (nomes, peças, regras), rodar **nova revisão sem contexto** antes de pedir o OK do gate — o veredito antigo não cobre o que mudou.  
8. **Pedido de correção visual ambíguo:** confirmar a leitura em uma linha (ou mostrar as duas) antes de editar o canvas.  

## Perguntas ao cliente

Antes de mandar pergunta ao cliente, filtrar: decisão de produto ou gosto sem regra → pergunta; o que o Design System, o contrato ou uma regra já responde → o subagente resolve e informa (`reference/rules.md` → Perguntar só o necessário). Juntar as perguntas de uma rodada num bloco só, cada uma com opções e recomendação.

Toda pergunta é autoexplicativa: o resumo e o contexto (o que está em jogo, opções, recomendação) aparecem no chat **antes** — nunca abrir questionário de múltipla escolha sem isso. Com o cliente, sem termo interno do método: “resumo do que entendi”, não “eco”.

## Passagem de bastão

Copiar o cartão de `shared/controller/handoff.md`. Apontar o subagente para:

```text
modules/{fase}/AGENT.md
modules/{fase}/playbook.md          (se existir)
modules/{fase}/target-model.md
modules/{fase}/examples/README.md   (lista dos anexos reais)
shared/docs-clarity.md
shared/anti-rush.md                 (Revisor: obrigatório; outras fases: ler antes de gravar)
```
