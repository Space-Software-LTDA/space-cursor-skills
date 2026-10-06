# Revisão — template

> Fase: 9 — Revisão (antes do manual comercial)  
> Status: rascunho  
> Última atualização: YYYY-MM-DD  
> **Para o agente (não copiar para o arquivo final):** qualidade = `09-review/target-model.md` · CA: `shared/acceptance-criteria.md` · Clareza: `shared/docs-clarity.md` · Anti-pressa: `shared/anti-rush.md`
---

## Dicionário

| Termo | O que é |
|-------|---------|
| **Revisão** | Auditoria dos docs contra critérios de aceitação — não é refazer o produto |
| **CA** | Critério de aceitação — **um por linha** (proibido colapsar `3.1–3.7`) |
| **Clareza humana (CL)** | Doc legível por leigo — “ficaria confuso? isso esclarece?” |
| **Passagem A / B** | A = conteúdo linha a linha · B = clareza seção a seção (`anti-rush.md`) |
| **Alucinação** | Conteúdo inventado sem fonte/cliente |
| **Falhou clareza** | Conteúdo pode estar certo, mas confunde o leigo ou parece chat com a IA |
| **Busca residual** | Grep/busca nos `docs/` com hits anotados — não basta afirmar “limpo” |

---

## Resumo executivo

| Campo | Valor |
|-------|--------|
| Fases OK (conteúdo) | |
| Fases a corrigir | |
| Falharam clareza | |
| Alucinações removidas | |
| Faltas (precisa cliente) | |
| Passagens A+B em todos os arquivos? | sim / não |
| CA colapsado? | **não** (se sim → revisão inválida) |
| Liberar **manual comercial** (Fase 10)? | sim / não / adiado com risco |

---

## Clareza humana (obrigatório — após Passagem B)

> **Posicionamento (cada arquivo, cada seção):**  
> Se eu fosse um leigo lendo esta informação, eu ficaria confuso? Isso esclarece?

| Arquivo | CL0 Leigo | CL1 Estranho | CL2 Sem meta processo | CL3 Sem qtd./TBD | CL4 Sigla | CL5 Sem resíduo chat | Resultado |
|---------|-----------|--------------|----------------------|------------------|-----------|----------------------|-----------|
| discovery.md | Esclarece / Confunde | | | | | | |
| pesquisa-mercado.md | | | | | | | |
| prototipo.md | | | | | | | |
| mvp.md | | | | | | | |
| contrato.md | | | | | | | |
| setup.md | | | | | | | |
| DESIGN_SYSTEM.md | | | | | | | |
| telas.md | | | | | | | |
| produto.md | | | | | | | |
| {slug}.md (se existir) | | | | | | | |
| Consistência X.CL | — | — | — | — | — | — | |

Correções de clareza (path + o que mudou):

-  

---

## Busca residual (obrigatório — R9)

Padrões buscados: `qtd.` · `TBD` · `n/d` · não inventar · só o que for real · Shape Up · Gate F6 · GATE 0 · skill-draft · nesta rodada · recomendação do agente

| Padrão | Hits (arquivo:trecho) | Correção |
|--------|----------------------|----------|
| | zero hits / listar | |

---

## Por fase — **uma linha por CA** (proibido `1.1–1.8` / `…`)

### 1 Discovery

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 1.1 Dicionário | | |
| 1.2 Problem statement | | |
| 1.3 Persona com momento | | |
| 1.4 Sucesso mensurável | | |
| 1.5 Matching / regra crítica | | |
| 1.6 Entradas + canais | | |
| 1.7 Confirmado/Hipótese/Aberto + Gate | | |
| 1.8 Sem solução técnica densa | | |
| **1.CL** | | Passagem B |

### 2 Mercado

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 2.1 Dicionário TAM/SAM/SOM | | |
| 2.2 Dentro/fora alinhado | | |
| 2.3 Contas explícitas | | |
| 2.4 ≥2 sinais + fonte | | |
| 2.5 ≥5 alternativas | | |
| 2.6 Escala / browser | | |
| 2.7 Gaps + implicação | | |
| 2.8 Monetização com fonte | | |
| 2.9 Gate | | |
| **2.CL** | | Passagem B |

### 3 Protótipo

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 3.1 Dicionário; telas humanas | | |
| 3.2 Fluxos cobrem entradas | | |
| 3.3 Telas objetivo + ações | | |
| 3.4 Estados mínimos | | |
| 3.5 Alinha gaps mercado | | |
| 3.6 Feature nova só com eco | | |
| 3.7 Gate | | |
| **3.CL** | | Passagem B |

### 4 MVP

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 4.1 Dicionário | | |
| 4.2 Dentro / fora | | |
| 4.3 Jornadas = proto | | |
| 4.4 Sucesso do MVP | | |
| 4.5 Monetização + risco em PT | | |
| 4.6 Gate | | |
| **4.CL** | | Passagem B |

### 5 Contrato

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 5.1 Dicionário | | |
| 5.2 Fonte primária × verdade | | |
| 5.3 Conta / créditos | | |
| 5.4 Lista do quê (tabela) | | |
| 5.5 Quem faz o quê | | |
| 5.6 Pedidos ao servidor em PT | | |
| 5.7 Coerente MVP/proto | | |
| 5.8 Aberto só com adiado | | |
| 5.9 Gate | | |
| **5.CL** | | Passagem B |

### 6 Setup

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 6.1 Dicionário | | |
| 6.2 Peças = contrato | | |
| 6.3 Git A/B/C | | |
| 6.4 Boilerplate por peça | | |
| 6.5 Ambientes (por extenso) | | |
| 6.6 Contas externas | | |
| 6.7 Ponteiros sem dump | | |
| 6.8 Gate | | |
| **6.CL** | | Passagem B |

### 7 Design System

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 7.1 Tríade DS+tokens+notes | | |
| 7.2 Primary/Surface com evidência | | |
| 7.3 Foundations densas | | |
| 7.4 Componentes com states | | |
| 7.5 Superfícies cobertas | | |
| 7.6 STOP / gate fase | | |
| 7.7 Densidade sem hex alien | | |
| 7.8 Não redefine produto | | |
| **7.CL** | | Passagem B — jargão UX no Dicionário |

### 8 Telas

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 8.1 Dicionário (termos do Apply traduzidos) | | |
| 8.2 Lista cobre todas as telas do protótipo | | |
| 8.3 Home no tema principal aprovada primeiro | | |
| 8.4 OK do cliente + Apply sem pendência, por tela | | |
| 8.5 Só peças oficiais (ligadas aos componentes) | | |
| 8.6 Mudança no DS = nova versão com motivo | | |
| 8.7 Estados cobertos ou pendentes | | |
| 8.8 Telas = protótipo · MVP · contrato | | |
| 8.9 Onde estão + relatórios | | |
| 8.10 Gate | | |
| **8.CL** | | Passagem B |

**Telas conferidas por print (R15)** — uma linha por tela essencial:

| Tela | Print ou canvas aberto | Bate com `telas.md` · protótipo · DS? | Ação |
|------|------------------------|----------------------------------------|------|
| | | | |


### 8.5 Protótipo navegável

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| 8b.1 Motor igual ao da skill (conferência do playbook, passo 7) | | |
| 8b.2 Protótipo fora do `docs/`; `prototipo:start` na raiz | | |
| 8b.3 Abre no Manual da marca com “Iniciar protótipo” | | |
| 8b.4 Todas as telas aprovadas no protótipo | | |
| 8b.5 Botões fazem o que o protótipo diz; aviso para ação sem tela; modal fecha para a tela de trás | | |
| 8b.6 `prototipo:verificar` sem erro | | |
| 8b.7 Conferência visual com prints | | |
| 8b.8 Nenhuma tela remendada no HTML | | |
| 8b.9 Registro em `telas.md` + gate | | |
| **8b.CL** | | Passagem B |

### Brief produto.md

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| P.1 Links das fases | | |
| P.2 Curto | | |
| P.3 Não substitui manual | | |
| **P.CL** | | Passagem B |

### Consistência cruzada

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| X.1 Nome | | |
| X.2 Persona | | |
| X.3 Lojas | | |
| X.4 Monetização | | |
| X.5 Matching | | |
| X.6 Buracos avisados | | |
| X.7 Telas ↔ protótipo ↔ DS ↔ contrato | | |
| **X.CL** | | |

### Checklist do Revisor (R1–R15)

| CA | Resultado | Evidência / ação |
|----|-----------|------------------|
| R1 Conteúdo 1–8 + brief | | |
| R2 Alucinações | | |
| R3 Contradições | | |
| R4 revisao.md gravado | | |
| R5 Gate = Manual (não tasks) | | |
| R6 Lei clareza + leigo | | |
| R7 Seção Clareza | | |
| R8 Todos *.CL | | |
| R9 Busca residual anotada | | |
| R10 Barra CL do manual | | |
| R11 Duas passagens | | |
| R12 Zero CA colapsado | | |
| R13 Evidência na Ação | | |
| R14 Jargão de domínio | | |
| R15 Telas conferidas por print | | |

---

## Anti-padrões encontrados

| Anti-padrão | Onde | Correção |
|-------------|------|----------|
| | | |

---

## Confirmado · Hipótese · Aberto

### Confirmado
-  

### Hipótese
-  

### Aberto
-  

---

## Gate — liberar Fase 10 (Manual comercial)?

| Campo | Valor |
|-------|--------|
| Resultado | fechado / adiado com risco / bloqueado |
| Data | |
| Clareza humana | OK em todos / pendências |
| Busca residual | feita · hits corrigidos |
| CA colapsado | **não** |
| Riscos de produto que o cliente assume | |
| Próximo | Manual `{slug}.md` — **não** tasks |
