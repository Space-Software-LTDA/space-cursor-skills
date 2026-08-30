# Templates de Descrição de Tarefa

## Tom professor (lembrar sempre)

Toda task segue o padrão da skill: **explicar tintim por tintim para júnior**.  
Incluir glossário, tabela de colunas, DBML, exemplos e “por quê” — ver seção 🎓 no `SKILL.md`.  
**Não** enxugar isso no template.

---

## Aviso de IA (sempre no topo)

```markdown
> ⚠️ Esta tarefa foi estruturada com auxílio de Inteligência Artificial com base nas informações fornecidas. Embora o conteúdo tenha sido organizado para facilitar o entendimento, podem existir interpretações incorretas ou incompletas. Em caso de dúvida, valide com o solicitante antes de iniciar o desenvolvimento.
```

---

## Cabeçalho em grid (obrigatório)

Colar **logo após** o aviso de IA. Só campos úteis ao dev. **Nunca** incluir modo SuperAgente / complexidade de roteamento.

```markdown
# 🔗 [Título da Funcionalidade]

| | |
| --- | --- |
| **Projeto** | {nome do produto} |
| **Camadas** | Frontend + Backend |
| **Repositório Frontend** | [org/repo-front](https://github.com/…) |
| **Repositório Backend** | [org/repo-back](https://github.com/…) |
| **API (Front)** | `NEXT_PUBLIC_API_URL` → `https://…` (ver `.env.example` do front) |
| **Env Backend** | Criar/atualizar `.env.example` do back com as keys da seção Backend |
| **Protótipo** | [URL](https://...) |
| **Diagrama DB** | [dbdiagram](https://...) |
| **Contrato API (Apidog)** | [URL do docs deste produto](https://…) → pasta **…** |
```

Omite a linha do repo que não se aplica (só Front ou só Back).

---

## Template — SuperAgente / Direto pro Dev (corpo igual)

O **modo** (SuperAgente vs direto) decide-se no chat. O markdown entregue é o mesmo padrão abaixo — **didático**, para o **dev júnior**.

```markdown
> ⚠️ Esta tarefa foi estruturada com auxílio de Inteligência Artificial com base nas informações fornecidas. Embora o conteúdo tenha sido organizado para facilitar o entendimento, podem existir interpretações incorretas ou incompletas. Em caso de dúvida, valide com o solicitante antes de iniciar o desenvolvimento.

# 🔗 [Título da Funcionalidade]

| | |
| --- | --- |
| **Projeto** | … |
| **Camadas** | Frontend + Backend |
| **Repositório Frontend** | [org/repo-front](https://github.com/…) |
| **Repositório Backend** | [org/repo-back](https://github.com/…) |
| **API (Front)** | `NEXT_PUBLIC_API_URL` → `https://…` |
| **Env** | Front: `.env.example` · Back: criar/atualizar `.env.example` (keys na seção Backend) |
| **Protótipo** | [URL](https://…) |
| **Diagrama DB** | [URL](https://…) |
| **Contrato API (Apidog)** | [URL do docs deste produto](https://…) → pasta **…** |

---

## 📌 Contexto

[Dor / situação atual.]

### Glossário

| Termo | Significado em português simples |
| --- | --- |
| … | … |

---

## 🎯 Objetivo

[Resultado esperado em 1-2 frases.]

---

## 🔧 Alterações Necessárias

### 🖥️ Backend

#### 1. Schema — o que é cada coluna

| Coluna | Tipo | Para que serve |
| --- | --- | --- |
| … | … | … |

#### 2. DBML (colar no dbdiagram.io)

```dbml
// bloco completo com Notes
```

#### 3. [Endpoints / payloads / helpers]

[Exemplos curl, tabelas se X então Y, pseudocódigo.]

#### 4. Variáveis de ambiente / `.env.example`

```bash
KEY=
```

---

### 🖥️ Frontend

#### 1. [Telas / campos / comportamentos]

#### 2. API base

Usar `NEXT_PUBLIC_API_URL` (valor no grid).

---

## 🖼️ Referência visual

**Protótipo:** [Nome — URL](https://exemplo.lovable.app/rota)

### [Tela]
![O que o júnior deve observar neste print](https://raw.githubusercontent.com/Space-Software-LTDA/space-assets/main/{projeto}/{task-slug}/01-tela.png)

---

## ✅ Critérios de Aceitação

### 🖥️ Backend

**BE-1: …**

- **Dado** …
- **Quando** …
- **Então** …

### 🖥️ Frontend

**FE-1: …**

- **Dado** …
- **Quando** …
- **Então** …

---

## ⚠️ Observações

- [Risco, dependência, env, edge case, o que o protótipo mente]
```

---

## Template — Direto pro Dev (urgente) — extra opcional

Além do template acima (mesmo detalhe didático), pode acrescentar:

```markdown
## 🚀 Ordem de Execução

1. [Migration / endpoint]
2. [Front]
3. [Testes manuais]
4. [Deploy]
```

---

## Template — Só Backend ou Só Frontend

Mesmo template; omitir a seção da camada ausente e a linha do repo correspondente no grid. Manter Critérios só da camada envolvida. **Manter** glossário/colunas/DBML se a camada for Backend.

---

## Dicas de qualidade

| Elemento | Bom | Ruim |
|----------|-----|------|
| Tom | Professor: explica o porquê + exemplo | “Implementar conforme protótipo” |
| Cabeçalho | Grid com links dos repos + API URL | “Modo SuperAgente…” / complexidade |
| Schema | Coluna + “para que serve” + DBML | Só `CREATE TABLE` sem explicação |
| Payload | Formato completo com tipos | "Enviar os dados do cadastro" |
| Env | Keys no `.env.example` + placeholder | Secret real colado na task |
| Critério | Dado/Quando/Então por camada | "Deve funcionar corretamente" |
| Front | Campo + print com legenda | "Ajustar a tela" |
| UI | Legenda + URL space-assets | Caminho `C:\...` |
| Tamanho | Longo e claro | Curto e ambíguo |
