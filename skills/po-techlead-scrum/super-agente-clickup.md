# Referência — SuperAgente Scrum Ritter (ClickUp)

Calibra **como escrever** a spec para o agente do ClickUp absorver. **Não** copiar o prompt do Ritter na task. Meta de roteamento (Esteira vs Imediatas) fica no chat.

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
| Task | `[FRONTEND]` ou `[BACKEND]` + texto | **Uma linha** da tabela (`1.1`, `2.3`) |

## Passo a passo → vínculos ClickUp

Cada tabela do passo a passo = um PBI. Cada linha = uma Task.

| Coluna | O Ritter faz |
| --- | --- |
| `Nº` (`1.1`) | ID estável da Task |
| `Camada` | Prefixo `[BACKEND]` / `[FRONTEND]` e agrupamento |
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

Deixar explícito na spec: Backend, Frontend, CA, DDD, passo a passo. Sem isso o Ritter inventa quebra e vínculo.

## Front+Back no ClickUp (publicação)

A spec no disco é **um** `.md`. Na publicação Front+Back o agente cria **três** tasks (ver [clickup-task-guide.md](clickup-task-guide.md)). O Ritter deve ler sobretudo a **MASTER** (spec completa + passo a passo inteiro). As irmãs Backend/Frontend são recorte para o dev da camada.

## Boilerplate Front

Tasks de UI alinham nomenclatura ao [boilerplate-front-nextjs](https://github.com/Space-Software-LTDA/boilerplate-front-nextjs).
