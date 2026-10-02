# Referência — SuperAgente Scrum Ritter (ClickUp)

Calibra **como escrever** a spec para o agente do ClickUp absorver. **Não** copiar o prompt do Ritter na task. Meta de roteamento (Esteira vs Imediatas) fica no chat.

**Este arquivo vale só para a Esteira.** Imediatas: o SuperAgente **não** passa. Sem PBI, sem Dependência — checklist nativo na task do dev ([clickup-task-guide.md](clickup-task-guide.md#imediatas--checklist-nativo-do-clickup)).

## Hierarquia que ele gera

```
Epic → Feature → PBI (User Story) → Tasks
```

Nós entregamos **uma** spec local. Ele quebra. O **passo a passo** (`## Passo a passo sugerido`) é o mapa para virar PBI/Task e **linkar** dependências.

| Nível | Padrão de título (Ritter) | De onde sai na nossa spec |
| --- | --- | --- |
| Epic | `EPIC \| <módulo>` | Módulo principal do grid / contexto |
| Feature | `FEATURE \| <módulo> \| <capacidade>` | Agrupamento de PBIs correlatos |
| PBI | `PBI \| <módulo> \| <ação>` | **Uma tabela** do passo a passo (`#### PBI N — …`) |
| Task | `[BACK]` ou `[FRONT]` + texto (prefixo no **início**, não truncar) | **Uma linha** da tabela (`1.1`, `2.3`) |

## Passo a passo → vínculos ClickUp

Cada tabela do passo a passo = um PBI. Cada linha = uma Task.

| Coluna | O Ritter faz |
| --- | --- |
| `Nº` (`1.1`) | ID estável da Task |
| `Camada` | Prefixo `[BACK]` / `[FRONT]` no início do título e agrupamento |
| `Espera` | Task **bloqueada por** esses IDs |
| `Bloqueia` | Task **bloqueando** esses IDs |
| Lista **Por quê** | Texto da seção Dependências (não inventar outro racional) |

Proibido na spec: “todos abaixo”, “o resto”. Só IDs.

**Mermaid:** o Ritter lê o **fonte** (`Código do diagrama (SuperAgente)`). A imagem mermaid.ink é para o humano. Os dois vão na seção passo a passo. Outros diagramas da task continuam só imagem ([diagrams.md](diagrams.md)).

## Tasks que ele cria (e as que não cria)

Front+Back na mesma PBI: agrupadores `Tasks de FRONTEND` e `Tasks de BACKEND`; tasks técnicas **dentro**.

Uma camada só: tasks direto na PBI, sem agrupador.

| Camada | Tipos de Task | Não criar |
| --- | --- | --- |
| FRONTEND | Implementação + Testes | Documentação específica de Front; **Code Review** |
| BACKEND | Implementação + Testes + Documentação (se a spec pediu doc) | **Code Review** |

Code review = PR. Links de PR em comentário no agrupador (ou na PBI se não houver agrupador).

Campos `Tipo de Tarefa` / `Tipo de Task`: preencher **só se vazios**. Não criar Task classificada como Code Review.

## O que extrair das outras seções

| Seção da spec | Vira |
| --- | --- |
| `## 📌 Contexto` | Contexto da PBI |
| `## 🎯 Objetivo` | Objetivo |
| `## 🔧 Alterações Necessárias` | Escopo (Back / Front separados) |
| Fora de escopo / Observações | Fora de escopo (deixar explícito) |
| `## ✅ Critérios de Aceitação` | CA Dado/Quando/Então por camada |
| `## REGRAS DE DDD` | Pronto / prova / paralelos — copiar para a PBI, não resumir embora. Tom ordenante. |
| `## ⛔ NÃO DEVE` | Anti-critérios — copiar para a PBI (último bloco). Não resumir embora. |

Deixar explícito na spec Esteira: Backend, Frontend, CA, DDD, passo a passo. Sem isso o Ritter inventa quebra e vínculo.

## Front+Back no ClickUp (publicação)

A spec no disco é **um** `.md` por entrega. Na Esteira, Front+Back vira **uma** task com a spec completa e o passo a passo inteiro — é ela que o Ritter lê; as linhas BACK/FRONT do passo a passo viram as Tasks. Sprint com várias entregas: **1 MAIN da sprint** (visão geral) + cada entrega como subtask. Subtarefa só se precisar, sem copiar o corpo da pai (ver [clickup-task-guide.md](clickup-task-guide.md#estrutura-no-clickup-regra-por-lista)).

## Boilerplate Front

Tasks de UI alinham nomenclatura ao [boilerplate-front-nextjs](https://github.com/Space-Software-LTDA/boilerplate-front-nextjs).
