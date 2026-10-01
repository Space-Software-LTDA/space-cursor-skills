# Modelo-alvo — Fase 9 Revisão

> A revisão **usa** os modelos-alvo + CA de cada fase.  
> Vivo: `.docs/revisao.md` · CA agregado: `../shared/acceptance-criteria.md`  
> **Lei de clareza:** [`../shared/docs-clarity.md`](../../shared/docs-clarity.md)  
> **Anti-pressa:** [`../shared/anti-rush.md`](../../shared/anti-rush.md)

## Fontes reais (anexadas)

| Arquivo | O que é | O que extrair |
|---------|---------|----------------|
| [`examples/anexos/google-sre-launch-checklist.html`](examples/anexos/google-sre-launch-checklist.html) | Google SRE — Launch Coordination Checklist | Checklist **item a item** antes de liberar (não skim) |
| [`examples/anexos/firebase-launch-checklist.html`](examples/anexos/firebase-launch-checklist.html) | Firebase launch checklist | Pré-lançamento por área; analogia → pré-task por fase |

Os anexos das **fases 1–8 e 10** também são fonte: o Revisor aplica a barra de cada `target-model.md` **e** CL0–CL5.

## Nosso modelo-alvo

1. Dicionário  
2. Resumo executivo  
3. Tabela CA por fase — **uma linha por CA** (OK / Corrigir / Alucinação / Falta / Falhou clareza) + evidência  
4. **Clareza humana** — CL0–CL5 por arquivo (após passagem B)  
5. **Busca residual** — padrões · hits · correção  
6. Consistência cruzada (X.* linha a linha)  
7. Anti-padrões encontrados  
8. Gate — liberar **Fase 10 Manual**?

## Critérios de aceitação (Revisão)

| # | CA | Barra |
|---|-----|--------|
| R1 | Fases 1–8 (+ produto.md) passaram checklist de **conteúdo** | Ou adiado explícito |
| R2 | Alucinações removidas ou Hipótese | |
| R3 | Contradições resolvidas ou listadas | |
| R4 | `.docs/revisao.md` gravado | |
| R5 | Gate = Fase 10 manual — **não** tasks | |
| **R6** | Leu docs-clarity + **posicionamento do leigo** em todo arquivo / seção | “Ficaria confuso? Esclarece?” |
| **R7** | Seção Clareza humana preenchida | Sem pular arquivo |
| **R8** | Todo *.CL OK ou corrigido | Conteúdo + clareza |
| **R9** | Busca residual executada e anotada | Hits listados ou “zero hits” |
| **R10** | Barra CL máxima do manual avisada ao liberar a Fase 10 | |
| **R11** | Protocolo **duas passagens** (A conteúdo · B clareza) por arquivo | `anti-rush.md` |
| **R12** | **Zero CA colapsado** (`3.1–3.7`, `1.1 … 1.8`) | Uma linha = um CA |
| **R13** | Coluna Ação com **evidência** (não só “OK”) | Citação curta do doc |
| **R14** | Jargão de domínio coberto (Scraper, Forge, a11y…) | Dicionário ou por extenso — sem escape “técnico legível” |
| **R15** | Telas conferidas: abriu o print registrado (ou o canvas) de **cada** tela essencial e comparou com `telas.md`, protótipo e DS | Uma linha por tela com evidência — ler só `telas.md` não vale |

**Bloqueio:** R6–R9 ou R11–R15 vermelhos → gate **não** fecha. Meta de chat = **Corrigir**, nunca “adiado com risco”.

## Anti-padrões (Revisão)

| Anti-padrão | Sintoma |
|-------------|---------|
| Reboot | Reescreve tudo sem CA |
| Borracha seletiva | Ignora mercado/contrato |
| Inventa requisito | “Melhor adicionar X” sem cliente |
| Skip manual | Vai pra task sem `{slug}.md` |
| Skip clareza | OK com `qtd.` / título de prompt |
| Clareza só no manual | Limpa `{slug}` e deixa fases sujas |
| Gate cego | Libera a Fase 10 sem Clareza humana |
| **Telas no papel** | Marca a Fase 8 OK lendo só `telas.md`, sem abrir print nem canvas |
| **Pressa / skim** | Fecha gate sem reler o arquivo |
| **CA colapsado** | `3.1–3.7 OK` numa linha |
| **CL0 raso** | Só removeu Gate F6; deixou Scraper / Von Restorff sem tradução |
| **Residual de mentira** | “Zero qtd.” sem busca registrada |
| **Escape técnico** | “DS é técnico mas legível” sem Dicionário |
