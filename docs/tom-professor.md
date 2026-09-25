# Tom professor — didática para júnior

Constituição de **comunicação** do time. Não é template de task nem de doc de produto.

**Regra de ouro:** se um júnior precisar **adivinhar** o que um campo, status, env, botão, RN ou fluxo significa — o artefato está **incompleto**.

Edite em `space-cursor-skills/docs/`. Após mudança: atualizar o mapa em [`README.md`](README.md) se o “quem lê” mudou → `npm run sync`.

---

## Público

Dev **júnior** (ou leitor que **nunca viu** o produto / a feature).  
Não escrever para quem “já sabe” ou para caber em 30 segundos de skim.

---

## Fazer / Não fazer

| Fazer | Não fazer |
| --- | --- |
| Explicar como professor paciente: contexto → cenário → exemplo → consequência | Jogar informação solta ou telegráfica |
| Exemplos concretos (curl, JSON, persona, certo vs errado) | Só abstração (“o tenant”, “a bet”, “implementar CRUD”) |
| Glossário dos termos que aparecem no texto | Assumir que o leitor conhece MinIO, JSONB, soft delete, RBAC, etc. |
| Preferir **mais exemplo** a menos texto abstrato | Enxugar didática “para caber” ou “porque o sênior já sabe” |
| Frases curtas; subtítulos; tabelas quando ajudam | Um parágrafo denso para um módulo inteiro |

---

## Explicativo ≠ redundante

| | |
| --- | --- |
| **Redundante** | Repetir a **mesma** decisão várias vezes **sem** agregar informação |
| **Explicativo** | Dar contexto, exemplo e regra para o júnior executar **sem adivinhar** |

Em dúvida → mais exemplo, não menos texto.

## Verboso ≠ ambíguo

| | |
| --- | --- |
| **Verboso (bom)** | Cada parágrafo desenvolve **uma** ideia com exemplo ou consequência |
| **Ambíguo (ruim)** | Frase vaga com duas interpretações opostas |

---

## Forma pedagógica (alinhada aos anti-padrões)

Quando ensinar uma regra ou proibição, preferir:

1. **Cenário** — o que acontece na prática  
2. **Por quê** — risco se não entender  
3. **Ouro / exemplo** — o caminho certo  
4. **Erro comum** — o que o júnior/IA costuma errar  

O catálogo concreto de anti-padrões de **código** continua em [`anti-padroes.md`](anti-padroes.md) (IDs `AP-*`). Este arquivo só fixa o **método** de explicar.

---

## Dois tons — não misturar

| Tom | Onde | Como |
| --- | --- | --- |
| **Professor** | Contexto, glossário, schema, RN, FL, “como deveria ser” | Cenário + exemplo. Pode usar “Exemplo:” + persona. |
| **Ordenante** | `## REGRAS DE DDD` (Definição de Done na task) | **Faça / Abra / Dispare / Confirme / Grave / Anexe**. **Proibido** “Imagine que…”. |

DDD = o que executar para chamar de pronto (prova em HML). Não é Domain-Driven Design.  
Molde preenchível da task: skill `po-techlead-scrum` → `evidencias-dod.md`. Norma HML: [`git-fluxo.md`](git-fluxo.md).

---

## Quem usa este arquivo

| Skill | Como usar |
| --- | --- |
| `po-techlead-scrum` | **Sempre** ao escrever task. Princípios aqui; **granularidade** da spec (tela/aba/KPI) em `decomposicao-tom-professor.md`; cola em `templates.md`. |
| `project-context-doc` | **Sempre** ao escrever doc. Princípios aqui; ordem FL/RN/G, anchors e mínimos do artefato em `language-guide.md` / `pedagogical-examples.md`. |
| `qa-space` | Só no “Como deveria ser” do achado: explicar citando § DS / `AP-FE-*` — **não** copiar decomposição de task. |
| `skill-update` | Garante que o mapa em [`README.md`](README.md) continue verdadeiro. |

**Mesmo princípio, artefatos diferentes:** task ClickUp ≠ doc de contexto ≠ REPORT de QA. Não copiar molde de um para o outro.

---

## O que este arquivo NÃO é

- Template de seções da task (grid, BE-n, Esteira/Imediatas)  
- Decomposição por aba/KPI/endpoint  
- Layout FL/RN/G ou índices ClickUp do doc de produto  
- Prompt do Estruturador ClickUp  

Isso permanece nas skills de produto.
