# Modelo-alvo — Fase 11 Tarefas

> Vivo: `docs/tarefas.md` (plano de fatias + gate) + `.task/{projeto}/{fatia}.md` + ClickUp  
> Método: skill **`po-techlead-scrum`** (checklist “antes de entregar descrição” é parte da barra)

## Fontes reais (anexadas)

| Arquivo | O que é | O que extrair |
|---------|---------|----------------|
| [`examples/anexos/spacesoft-front-ds-modais-e-home.md`](examples/anexos/spacesoft-front-ds-modais-e-home.md) | Tarefa real de front: aplicar Design System (modais → Home) | Contexto · objetivo · prioridade visual · alterações · critérios Dado/Quando/Então · passo a passo · regras de pronto · referência visual · “não deve” |
| [`examples/anexos/spacebet-back-relatorios-diagnostico.md`](examples/anexos/spacebet-back-relatorios-diagnostico.md) | Tarefa real de back: diagnóstico com roteiro e laudo | Roteiro por passos · critérios testáveis · prova de pronto · “não deve” com falhas reais |

Formato de referência da skill: `po-techlead-scrum/templates.md` + `decomposicao-tom-professor.md`.

## Mínimos que os modelos reais exigem

1. Contexto e glossário para quem não participou da conversa.  
2. Objetivo em uma frase + o que fica fora.  
3. Alterações separadas por camada (back · front).  
4. Critérios de aceitação testáveis (Dado / Quando / Então).  
5. Prova de pronto (o que o dev mostra para dizer que terminou).  
6. Referência visual quando há tela.  
7. “Não deve” no final, só com falhas reais desta entrega.

## Nosso modelo-alvo

**`docs/tarefas.md`:** Dicionário · plano de fatias (uma linha por fatia: ordem, entrega, jornadas e telas cobertas, camadas, dependências, status, link) · cobertura das jornadas do dia 1 · Confirmado / Hipótese / Aberto · Gate.  
**Cada tarefa:** o formato da skill `po-techlead-scrum`.

## Critérios de aceitação

| # | CA | Barra |
|---|-----|--------|
| TK1 | Plano de fatias em `docs/tarefas.md` | Uma linha por fatia; aprovado pelo cliente antes da primeira tarefa |
| TK2 | Cobertura: toda jornada do dia 1 (`mvp.md`) cai em alguma fatia | Tabela de cobertura sem jornada órfã |
| TK3 | Ordem com dependências explícitas | Ex.: conta antes de créditos; rota antes da tela que a consome |
| TK4 | Cada fatia passou pelo pipeline do PO na ordem | Sem rota nova → motivo anotado para pular o Apidog |
| TK5 | Banco e rotas saem do contrato | Nada inventado; divergência → eco → confirma → atualizar `contrato.md` |
| TK6 | Tarefa de tela usa print de tela aprovada na Fase 8 | Nome da tela igual ao de `telas.md`; Design System apontado pelo nome do arquivo |
| TK7 | Checklist da skill PO cumprido | Tom professor · Dado/Quando/Então · regras de pronto · “não deve” no final |
| TK8 | Aprovação local antes de publicar; link registrado | Linha da fatia com status e link |
| TK9 | Gate gravado | fechado · adiado com risco · bloqueado |
| **TK.CL** | **CL0–CL5** em `tarefas.md` e no corpo da tarefa | Júnior entende sem a conversa; sem meta de roteamento; sem caminho `docs/` no ClickUp |

## Anti-padrões (Tarefas)

| Anti-padrão | Sintoma |
|-------------|---------|
| Tarefa monolítica | “Implementar o produto” numa tarefa só |
| Fatia horizontal | “Todo o back” / “todo o front” como fatia |
| Tarefa antes das telas | Front especificado sem tela aprovada |
| Mock como régua de cor | Tarefa manda copiar cor ou brilho do construtor de app |
| Banco inventado | Tabela ou campo que o contrato não tem |
| Apidog “depois” | “O dev atualiza o Apidog” |
| Publicar sem OK | ClickUp antes da aprovação local |
| Resíduo de conversa | Ferramenta rejeitada, anedota, “como falamos” no corpo |
