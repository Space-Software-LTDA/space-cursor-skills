# Lições do piloto — product-from-idea

> Atualizar a cada gap ou acerto relevante. Enquanto a skill estiver em piloto, o Controlador anota aqui, ao fechar cada gate, o que o cliente corrigiu e por quê.  
> Piloto: buscaí (extensão + site de comparação de anúncios), 2026-09-23 a 2026-09-30.

**Última atualização:** 2026-09-30

## Conversas do piloto

| Conversa | O que foi |
|----------|-----------|
| `28cc9551-f788-4b08-bd4c-4ed5e15597ea` | Criação da skill: posicionamento, formações, leis, módulos, anexos reais, Fases 7 e 8 |
| `7460be65-4efe-4820-8ddc-0c82ce4bcff6` | Piloto das Fases 1 a 7 (Discovery → Design System) |
| `363e5e73-35e5-46ea-a7d3-a77b1b8e02c9` | Design System, componentes e primeiras telas no canvas, fora do fluxo de fases; passo a passo do DS que virou o roteiro do Forge |
| `df7bb8dd-…` · `6eb78914-…` | Revisor (primeira rodada e reauditoria com anti-pressa) |
| `5a377b4c-8e89-4580-9a81-ad613a25b3a1` | Controlador das Fases 8, 9 e 10 + apresentação comercial + repositório |

---

## Por que faltou (causas)

| # | Causa | O que ela gerou | Correção na skill |
|---|-------|-----------------|-------------------|
| 1 | **Não havia caminho de volta.** “Um arquivo por fase” + “gate não reabre” sem regra para decisões tardias | Vitrine, Minha conta, situações da busca e Excluir conta decididos nas telas não chegaram ao protótipo, MVP e contrato; a Revisão corrigiu 3 fases | Lei de **Propagação** (`reference/rules.md`, `.mdc`, Controlador, critérios 8.11 e X.8) |
| 2 | **Trabalho fora do fluxo e em conversa longa.** DS e telas num chat direto (sem subagente nem gate); Fase 8 num subagente por dois dias | Decisões presas no chat; gravação interrompida; canvas sobrescrito e refeito | Fases longas com subagente novo por tela; tela pronta ≠ aprovada; canvas protegido |
| 3 | **Templates ensinavam o erro.** Cabeçalho “Qualidade: `…`” e título “Gate F6” | A Revisão apagou meta de processo copiada do template | Templates com nota “para o agente (não copiar)” e “Decisão da fase (gate)” |
| 4 | **Regra do cliente ficou só no prompt.** “Pergunte só o necessário”, “dados de exemplo são mockup”, valores fictícios — ditos no chat do Controlador e repassados ao subagente, nunca gravados como lei | A próxima fase ou o próximo produto não herdariam | Viraram lei em `reference/rules.md`, `reference/passo-a-passo.md` e módulo 08 |
| 5 | **Lições não voltaram para a skill.** As Fases 8–10 rodaram em outra conversa; ninguém trouxe as lições de volta ao `.cursor/` | Este arquivo parado em 2026-09-28 | Controlador anota lição a cada gate (topo deste arquivo) |
| 6 | **Clareza checada só na Revisão.** Cada fase gravou termo técnico sem Dicionário | Cerca de 70 termos acrescentados pela Revisão | Lista de jargão que mais vazou em `docs-clarity.md` + checklist de gravação |

---

## O que funcionou (manter na skill)

| Padrão | Evidência |
|--------|-----------|
| Ler docs **antes** da 1ª pergunta | Agente abriu `reference/rules.md` / formações |
| Cabeçalho **Fase · Objetivo · ON** | Anti-poluição |
| Eco → confirma → grava | Contrato: cliente corrigiu fluxo antes do Write |
| Uma decisão A/B/C por vez | Auth, crédito, matching, Home — ritmo bom |
| “Não entendi” → reescrever do zero | 5 bullets simples da “busca” |
| Cliente manda inventário (`data.md`) → eco em PT → contrato | Todos os campos do inventário estão no contrato com nome em português |
| Progresso **no envio** (não status tagarela) | Cliente disse OVER; agent corrigiu |
| Pesquisa afiliado com política Amazon | Browser + fonte; mudou monetização |
| Conta explícita TAM/SAM/SOM | Depois da lei da conta |
| Variações lado a lado no canvas, sem apagar as não escolhidas | Card de anúncio escolhido entre muitas opções; cliente voltou a opções antigas |
| Comparação visual antes de decisão de gosto | Texto do botão principal: 3 colunas com contraste medido → cliente escolheu em uma rodada |
| Relatório + prints “antes/depois” por rodada | Permitiram refazer o canvas inteiro quando o arquivo foi sobrescrito |
| Perguntas da rodada num bloco só, com opções e recomendação | Cliente respondeu 5 decisões de produto de uma vez |
| Revisor abrindo o print de cada tela (R15) | Achou 2 problemas visuais em telas já aprovadas (título 16/700, “ranking”) |
| Manual escrito depois de telas e revisão | Aprovado sem ajustes |
| Subagente dedicado para material fora das fases | Apresentação comercial de 21 slides aprovada; só um ajuste de logo |

---

## Gaps (corrigidos ou a vigiar)

| Gap | Status | Ação |
|-----|--------|------|
| Zero write em `docs/` | **Corrigido** | Write na rodada útil + gate |
| Pesquisa rasa / número sem conta | **Corrigido** | Roteiro F10 + lei da conta |
| Sopa de siglas | **Corrigido** | Especialista → leigo |
| Inventou “AIDE” (STT) | **Corrigido** | Não batizar; eco antes |
| Dois gates abertos | **Corrigido** | Um gate por vez |
| “Fechado” = nunca mais detalha (cliente confuso) | **Corrigido** | Roteiro F5: corte vs lista vs task |
| Documento Frankenstein / despadronizado (contrato) | **Corrigido na lei** | Template; mesma tabela; reescrever se remendou |
| Doc sem glossário / leigo perdido em sigla | **Corrigido na lei** | Dicionário no topo |
| Exemplos inventados (“caso ilustrativo”) | **Corrigido na lei** | Só anexos reais + modelo-alvo |
| Resposta ambígua (`2`) | **Corrigido** | Confirmar opção antes de gravar |
| `data.md` fora de `docs/` | **Resolvido** | Todos os campos traduzidos no contrato; o arquivo virou só referência técnica |
| Monetização sem preço no MVP | **OK com risco** | Mecanismo sim; R$ adiado explícito |
| Documentos com contexto de chat, `qtd.`, siglas | **Corrigido na lei** | `docs-clarity.md` + `*.CL` em toda fase |
| Revisor com pressa (CAs colapsados, residual só afirmado) | **Corrigido na lei** | `anti-rush.md` |
| Manual com meta de processo no cabeçalho | **Corrigido na lei** | Template limpo + M26–M28 |
| Dois roteiros de Design System coexistindo | **Corrigido** | Roteiro único no `design-system-forge`; o rascunho original fica só como histórico em `shared/historico/` |
| Telas construídas fora do fluxo | **Corrigido na lei** | Fase 8: tela pronta ≠ aprovada |
| Fase de tarefas só com `AGENT.md` | **Corrigido** | Playbook + target-model + anexos reais |
| Decisão tardia não propagada para protótipo, MVP e contrato | **Corrigido na lei** | Propagação |
| Template induzindo meta de processo no documento | **Corrigido** | Notas “para o agente (não copiar)” |
| Dicionários rasos nas fases 2 a 7 | **Corrigido na lei** | Lista de jargão em `docs-clarity.md` |
| Nome renomeado sem varredura (“Tela do produto” → “Tela da pesquisa”) | **Corrigido na lei** | Renomear = varrer (critério X.9) |
| Status vencido (versão aprovada ainda como “rascunho”; próximo passo antigo) | **Corrigido na lei** | Checagem de gate do Controlador |
| Canvas sobrescrito por um editor com a versão antiga; versões 0.31 a 0.35 refeitas | **Corrigido na lei** | Canvas protegido: um editor, cópia com data por rodada, conferir o disco |
| Um subagente para a Fase 8 inteira, por dois dias | **Corrigido na lei** | Fases longas: subagente novo por tela ou fatia |
| Agente perguntando o que o Design System já respondia | **Corrigido na lei** | Perguntar só o necessário |
| Conferência de dados de exemplo entre telas | **Corrigido na lei** | Dados de exemplo = mockup |
| Placeholder “X” nos valores de crédito | **Corrigido na lei** | Valores fictícios aprovados uma vez |
| Lote de telas pedido pelo cliente × lei “proibido lote” | **Corrigido na lei** | Exceção com pedido explícito, ciclo completo e relatório por tela |
| Texto e contraste do botão principal decididos só na Fase 8 (a cor da marca mudou) | **Corrigido na lei** | Fase 7 decide antes dos componentes, com comparação |
| Apply pede tela-prova também no celular; regra local é só computador | **Corrigido** | Linha na tabela “Quando o Apply disser” do módulo 08 |
| “Ranking” em texto de tela para o público | **Corrigido na lei** | Texto de tela no teste do leigo |
| Workspace dentro de um repositório alheio; canvas sem versionamento | **Corrigido na lei** | Fase 0: casa do produto |
| Auditoria de canvas por amostra (“25” quando um quadro tinha 70) | **Corrigido na lei** | `anti-rush.md` item 6 |
| IA do canvas criou 70 a 80 componentes | **Corrigido (Forge)** | Lista fechada por faixa no `catalogo-componentes.md` |
| Apresentação comercial sem lugar no processo | **Parcial** | Extra no `reference/passo-a-passo.md`; módulo próprio exige anexos reais de apresentações (decisão do cliente) |
| Trabalho autônomo a pedido (“estou saindo, só faça”) | **Vigiar** | Resultado entra na fase como “corrigir”, nunca como aprovado |
| Design System criado em chat direto, fora do fluxo | **Vigiar** | DS fora do fluxo passa pelo gate da Fase 7 como as telas passam pela 8 |
| Arquivos soltos na raiz (PDF de referência duplicado, exportação antiga do canvas) | **Vigiar** | Limpeza só com OK do cliente |
| Fase 11 (Tarefas) nunca rodou | **Aberto** | Rodar no buscaí antes de promover a skill |
| Correções corrigidas só na conversa, sem voltar para a skill | **Corrigido na lei** | Lista de correções ao fechar cada gate → `/skill-update` (fluxo F); `CORRECOES.md` em toda skill do pacote |
| Práticas que funcionaram (subagente por etapa, Pronto quando + exemplo real, revisor sem contexto) existiam só nesta skill | **Corrigido** | Viraram método de todo o pacote: `../docs/metodo-agentes.md` + seção “Método de execução” em cada `SKILL.md` |

---

## Comportamentos a exigir no SKILL.md

1. Write em `docs/{fase}.md` na mesma rodada do fato.  
2. Gate só com arquivo refletindo o pacote.  
3. Eco → confirma → grava (dump / inventário / áudio).  
4. Clareza leigo; um gate por vez.  
5. Fase 5: roteiro contrato; explicar tipo de “fechado”.  
6. “Não entendi” → reescrever simples.  
7. Resposta ambígua → confirmar opção.  
8. Não inventar protocolo que o cliente não pediu.  
9. Número de mercado com conta; comissão com fonte.  
10. Correção = replace limpo no arquivo.  
11. Padronização: template + mesmo rótulo + mesmas colunas; Frankenstein → Write limpo do arquivo.  
12. Limpar contexto a cada gate (agente novo + handoff); não empilhar fases na thread.  
13. Teste do leigo em todo documento e em todo texto de tela.  
14. Sem pressa: ler o arquivo inteiro antes de gravar; nunca colapsar critérios; abrir todos os quadros do canvas.  
15. Telas uma por vez, Home primeiro, OK do cliente por tela; lote só a pedido.  
16. Tarefas por fatia, com plano aprovado antes da primeira.  
17. **Propagar** decisão tardia para o arquivo dono na mesma rodada.  
18. **Renomear = varrer** todo `docs/`; atualizar status vencido ao fechar gate.  
19. **Perguntar só o necessário**: produto e gosto sem regra → cliente; o resto → resolver e informar.  
20. **Canvas protegido**: um editor, cópia com data por rodada, conferir que o arquivo mudou no disco.  
21. **Fases longas**: subagente novo por tela ou fatia.  
22. **Lição a cada gate** neste arquivo, enquanto em piloto.

---

## Anti-padrões

- Discovery só no chat.  
- Batizar feature por STT.  
- Protocolo tagarela / over-spec de status.  
- Fechar contrato com lista que o cliente disse faltar.  
- Copiar código/`POST /...` para o doc de produto sem traduzir.  
- Tratar inventário externo como verdade sem eco + `docs/`.  
- Remendar `docs/` até ficar despadronizado.  
- Decisão nova gravada só no arquivo da fase atual.  
- Copiar a nota “para o agente” do template para o documento.  
- Editar o canvas sem cópia, com o arquivo aberto em duas janelas.  
- Perguntar ao cliente o que a regra escrita já responde.

---

## Artefatos do piloto (skill)

| Arquivo | Uso |
|---------|-----|
| `modules/02-market/` | Mercado denso |
| `modules/05-contract/` · `templates/contrato.md` | Contrato |
| `shared/docs-clarity.md` · `shared/anti-rush.md` | Leis de clareza e anti-pressa |
| `modules/08-screens/` + `templates/telas.md` | Fase de telas |
| `modules/11-task/` + `templates/tarefas.md` | Fase de tarefas por fatia |
| `shared/historico/RASCUNHO-passo-a-passo-marca-e-ds.md` | Origem do roteiro do Forge (só consulta) |

---

## Próximas lições a capturar

- [ ] Fase 11: plano de fatias e primeira fatia pelo `po-techlead-scrum`  
- [ ] Corte obrigatório × desejável dos marketplaces no plano de fatias  
- [ ] Como anexar OpenAPI/DBML sem poluir `contrato.md`  
- [ ] Subagente novo por tela na Fase 8: custo de passagem de bastão × ganho de contexto limpo

---

## Exemplos só do piloto (não virar regra genérica)

- Job: melhor anúncio pós-escolha do modelo (marketplaces BR)  
- Extensão = leitura das páginas das lojas; fonte = navegador; verdade = servidor  
- Inventário: `data.md` (semente + cards)  
- QueimaI, selos Igual/Similar, Mascote-lupa, cores da marca do buscaí

Na skill genérica: montar a partir do `discovery.md` / inventário da vez.
