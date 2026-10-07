# Tom professor — didática para júnior

Constituição de **comunicação** do time. Não é template de task nem de doc de produto.

**Regra de ouro:** se um júnior precisar **adivinhar** o que um campo, status, env, botão, RN ou fluxo significa — o artefato está **incompleto**.

Edite em `space-cursor-skills/docs/`. Após mudança: atualizar o mapa em [`README.md`](README.md) se o “quem lê” mudou → `npm run sync`.

---

## Público

Dev **júnior** (ou leitor que **nunca viu** o produto / a feature).  
Não escrever para quem “já sabe” ou para caber em 30 segundos de skim.

**Na task** (`po-techlead-scrum`), o público é **quem vai executar**. Problema e resultado esperado vão **sempre completos**, para qualquer nível. O detalhe do **como** escala com a senioridade: quanto mais sênior, menos como. Ver [Na task: explicar não é resolver](#na-task-explicar-não-é-resolver).  
Na documentação (`project-context-doc`), vale o parágrafo de cima.

---

## Fazer / Não fazer

| Fazer | Não fazer |
| --- | --- |
| Explicar como professor paciente: contexto → cenário → exemplo → consequência | Jogar informação solta ou telegráfica |
| Exemplos concretos (curl, JSON, persona, certo vs errado) | Só abstração (“o tenant”, “a bet”, “implementar CRUD”) |
| Glossário dos termos que aparecem no texto | Assumir que o leitor conhece MinIO, JSONB, soft delete, RBAC, etc. |
| Preferir **mais exemplo** a menos texto abstrato | Enxugar didática da **documentação** “para caber” ou “porque o sênior já sabe” (na task, o detalhe do **como** escala com quem executa — ver abaixo) |
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

## Na task: explicar não é resolver

Vale para a task (`po-techlead-scrum`). A documentação não muda.

**Menos é mais.** A task diz o essencial e explica o que é confuso. Sem ambiguidade.

| Explicar (entra no card) | Resolver pelo dev (não entra) |
| --- | --- |
| **Qual é o problema** e **qual resultado esperamos** — sempre completos e claros | O **como** passo a passo — fica com quem executa |
| Domínio, termos, regras de negócio | Tabela nova, coluna nova ou mecanismo especial em correção e integração |
| Onde as coisas estão; como o sistema funciona hoje | DBML, schema, pseudocódigo ou payload completo que o PO **não** decidiu |
| Direção: para onde olhar | A solução pronta |

- Antes de escrever, quem escreve confere se o que vai pedir **já existe** e se é **mesmo necessário** (YAGNI, DRY, KISS). É checagem de quem escreve, não conteúdo do card.
- A task **conduz**, não resolve. Direcionar para a solução é uma coisa; solucionar pelo dev é outra.
- Quanto mais sênior o dev, menos detalhe do **como**. Problema e resultado esperado não encolhem.
- Correção e integração: preferir o caminho mais simples e deixar a escolha com o dev.
- DBML, schema, pseudocódigo e payload completo entram **só quando já são decisão do PO** (ex.: produto novo, contrato já publicado no Apidog).
- O card leva **só o que é útil a quem executa**. Nada vazado da conversa entre PO e IA: as restrições que o PO deu para guiar a escrita guiam **como** escrevemos — não são conteúdo do card.
- “Mais exemplo” vale para o que é confuso, não para o como.

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
| `po-techlead-scrum` | **Sempre** ao escrever task. Princípios aqui (incl. **Na task: explicar não é resolver**); **granularidade** da spec (tela/aba/KPI) em `decomposicao-tom-professor.md`; cola em `templates.md`. |
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
