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

### 0) Sistema atual (só se o produto está sendo refeito)

Perguntar e gravar na seção opcional “Sistema atual” do template: o que existe, o que é reaproveitado, o que vira só consulta, o que arquivar, segredos expostos encontrados (chave ou senha no código ou em arquivo público → anotar para trocar, sem copiar o valor).

### 1) Peças (do contrato)

Listar superfícies do contrato. Sem peça inventada.

Contrato com fornecedor externo (pagamento, provedores…) → perguntar se haverá camada de integração separada ([`reference-space-defaults.md`](reference-space-defaults.md) §5) antes de recomendar tudo num servidor só.

### 1b) Nomenclatura — aplicar lei Space

Abrir [`reference-space-defaults.md`](reference-space-defaults.md) §1 e a constituição `../docs/nomenclatura.md`.

```text
<cliente>_<produto>_<o-que-é>     (hífen se o cliente já usa hífen)
```

`<o-que-é>` = o que a peça é: `backend` · `frontend` · `extension` · outra peça descrita pelo que é (`integrations`, `backoffice`…).

Perguntar o separador que o cliente já usa → eco → confirma slugs → grava nomes no `docs/setup.md`.

### 2) Organização Git — gate

A = 1 repo/peça (default Space) · B = monorepo · C = outro.  
Gravar. Sem escolha → não fechar (ou adiado com risco).

### 3) Origem por peça

| Peça | O que gravar |
|------|----------------|
| backend | Link boilerplate-back-elysia + mapa [`examples/anexos/backend-STRUCTURE.md`](examples/anexos/backend-STRUCTURE.md) |
| frontend | Link boilerplate-front-nextjs + mapa [`examples/anexos/frontend-STRUCTURE.md`](examples/anexos/frontend-STRUCTURE.md) |
| extension | TS + webpack + Manifest V3; mapa [`examples/anexos/extension-STRUCTURE.md`](examples/anexos/extension-STRUCTURE.md) |
| integrations | Referência Space ([`reference-space-defaults.md`](reference-space-defaults.md) §5) — ferramenta conferida no código da referência |

**Quem cria o repo:** DEV ao iniciar. Setup só nomeia.  
Pastas densas = clone do boilerplate / scaffold — não inventar árvore no setup além do mapa.

### 4) Ambientes

Local · HML · Produção (sem provisionar). `dev` só se houver ambiente de desenvolvimento compartilhado (`../docs/git-fluxo.md`) — perguntar.

### 5) Contas / ferramentas

Checklist Git, Apidog, OAuth, store da extensão, EasyPanel, DB, ClickUp… MVP sim/não.

Ferramenta pronta para uma superfície (portal de documentação, página de situação…) → anotar a consequência: na Fase 8 é conteúdo, ordem, logo e cores dentro do layout da ferramenta ([`reference-space-defaults.md`](reference-space-defaults.md) §6). Portal pelo Apidog publica o projeto inteiro → API pública com rotas internas = projeto separado no Apidog.

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
