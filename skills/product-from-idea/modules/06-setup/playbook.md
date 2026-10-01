# Playbook — Fase 6 Setup

> Spec **só** o chão de fábrica. Detalhe de implementação = skills Space na hora certa.  
> Leis genéricas: [`reference-space-defaults.md`](reference-space-defaults.md)

**Agent:** [`AGENT.md`](AGENT.md)  
**Bar:** [`target-model.md`](target-model.md)  
**Template:** `templates/setup.md`

## Header

```text
**Fase 6 — Setup**
**Objetivo:** peças → repos + origem/boilerplate + ambientes + contas (sem código)
**ON:** F5 + F6
```

## Sequence

### 1) Peças (do contrato)

Listar superfícies do contrato. Sem peça inventada.

### 1b) Nomenclatura — aplicar lei Space

Abrir [`reference-space-defaults.md`](reference-space-defaults.md) §1.

```text
<cliente>-<produto>-<o-que-é>
```

`<o-que-é>` canônico: `backend` · `frontend` · `extension`.

Eco → confirma cliente/produto slugs → grava nomes no `.docs/setup.md`.

### 2) Organização Git — gate

A = 1 repo/peça (default Space) · B = monorepo · C = outro.  
Gravar. Sem escolha → não fechar (ou adiado com risco).

### 3) Origem por peça

| Peça | O que gravar |
|------|----------------|
| backend | Link boilerplate-back-elysia + mapa [`examples/anexos/backend-STRUCTURE.md`](examples/anexos/backend-STRUCTURE.md) |
| frontend | Link boilerplate-front-nextjs + mapa [`examples/anexos/frontend-STRUCTURE.md`](examples/anexos/frontend-STRUCTURE.md) |
| extension | TS + webpack + Manifest V3; mapa [`examples/anexos/extension-STRUCTURE.md`](examples/anexos/extension-STRUCTURE.md) |

**Quem cria o repo:** DEV ao iniciar. Setup só nomeia.  
Pastas densas = clone do boilerplate / scaffold — não inventar árvore no setup além do mapa.

### 4) Ambientes

Local · HML · Produção (sem provisionar).

### 5) Contas / ferramentas

Checklist Git, Apidog, OAuth, store da extensão, EasyPanel, DB, ClickUp… MVP sim/não.

### 6) Mapa leve ao nascer

Uma linha por peça. Coluna “fora”: DBML · Apidog · seletores · hex.

### 7) Ponteiros

Fase 11 PO · Fase 7 Forge · Fase 10 Manual · qa-space depois do front.

### 8) Gate F6

fechado | adiado com risco | bloqueado.

## Fora de escopo

| Pedido | Apontar para |
|--------|----------------|
| DBML / Apidog | `po-techlead-scrum` |
| Pastas Next/Elysia | AGENTS do boilerplate |
| Extensão em JS puro | **Recusar** — lei = TypeScript + webpack |
| Cores / DS | `design-system-forge` |
| Auditar front | `qa-space` |
| Criar repo / deploy | Devs |
