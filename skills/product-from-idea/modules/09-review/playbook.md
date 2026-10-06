# Roteiro — Fase 9 Revisão (Revisor)

> **Genérico.** Não refaz o produto do zero. **Audita** cada `docs/` contra CA + anti-padrões + **clareza**.  
> **Target-model:** [`target-model.md`](target-model.md)  
> **CA por fase:** `../NN-*/target-model.md` · agregado: [`../../shared/acceptance-criteria.md`](../../shared/acceptance-criteria.md)  
> **Clareza:** [`../../shared/docs-clarity.md`](../../shared/docs-clarity.md) — CL0–CL5  
> **Anti-pressa:** [`../../shared/anti-rush.md`](../../shared/anti-rush.md) — duas passagens · zero CA colapsado  
> **Anexos:** [`examples/anexos/`](examples/anexos/) (Google SRE + Firebase)  
> **Template:** `templates/revisao.md`

---

## Quem é quem

| Papel | Faz |
|-------|-----|
| **Controlador** | Spawna o Revisor; **rejeita** `revisao.md` com CA colapsado (`3.1–3.7 OK`); valida Clareza + Busca residual; pede gate ao cliente |
| **Subagente Revisor** | Lê **devagar**; duas passagens; uma linha por CA; corrige no arquivo; **não** abre Manual nem Tasks |

---

## Cabeçalho

```text
**Fase 9 — Revisão**
**Objetivo:** docs coerentes, sem alucinação, legíveis por leigo, prontos para o manual comercial
**ON:** F4 + F6 (+ F1/F10/F5 conforme o arquivo sob revisão)
**ANTI:** pressa · CA colapsado · CL0 só em meta de chat
```

---

## Sequência (obrigatória — não pular)

0. Ler [`anti-rush.md`](../../shared/anti-rush.md) + [`docs-clarity.md`](../../shared/docs-clarity.md) + [`target-model.md`](target-model.md) + `docs/README.md`.  
1. Ordem fixa de arquivos: discovery → mercado → proto → MVP → contrato → setup → DS → telas → produto.md.  
   - Em **telas**: além de `telas.md`, abrir o print registrado (ou o canvas) de **cada** tela essencial e comparar com protótipo e DS — uma linha por tela (R15).  
2. **Por cada arquivo — Passagem A (conteúdo):**  
   - Abrir `docs/{fase}` **inteiro** (não só o topo).  
   - Abrir `../NN-*/target-model.md` **de novo** (não de memória).  
   - Preencher **uma linha por CA** (1.1, 1.2… + *.CL) com Resultado + **evidência** na Ação.  
   - **Proibido** `1.1–1.8` / `3.1–3.7` / reticências entre CAs.  
3. **Por cada arquivo — Passagem B (clareza):**  
   - Relêr **seção a seção**.  
   - Em cada seção: *“Se eu fosse leigo, ficaria confuso? Isso esclarece?”*  
   - Corrigir jargão (Scraper, Forge, a11y…), meta de chat, abreviação — no **arquivo**, não só na tabela.  
   - Só então marcar CL0–CL5.  
4. Consistência cruzada (X.1… + X.CL) — também **linha a linha**.  
5. **Busca residual** nos `docs/` (ferramenta de busca):  
   `qtd.` · `TBD` · `n/d` · “não inventar” · “só o que for real” · Shape Up · Gate F6 · GATE 0 · skill-draft · “nesta rodada” · “recomendação do agente”  
   Registrar hits → corrigir → anotar bloco **Busca residual** em `revisao.md`.  
6. Consolida `docs/revisao.md` (R1–R15).  
7. Gate: liberar **Fase 10 Manual**? (não tasks; barra CL máxima no manual)

**Se a revisão for longa:** Controlador abre `revisor-discovery`, `revisor-mercado`… cada um encerra ao terminar a fase — **nunca** compensar volume com pressa/colapso.

---

## O que NÃO fazer

- Reescrever tudo “do zero” sem CA.  
- Inventar requisito novo sem o cliente.  
- Ir para tasks sem manual `{slug}.md`.  
- Misturar 5 fases num Write sem rastreio.  
- **Colapsar CAs** ou marcar Clareza OK sem passagem B.  
- Escapar com “técnico mas legível” sem Dicionário.  
- Tratar meta de chat como “adiado com risco”.  
- Declarar residual limpo **sem** ter buscado.

---

## Gate

| Resultado | Significado |
|-----------|-------------|
| **fechado** | Cada CA em linha própria · CL0–CL5 OK · residual limpo (ou riscos de *produto* adiados) |
| **adiado com risco** | Cliente assume buracos de **produto** — **não** de clareza nem de pressa |
| **bloqueado** | Falta correção / resposta / CA colapsado / clareza vermelha / residual não feito |
