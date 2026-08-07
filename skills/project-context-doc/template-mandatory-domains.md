# Template Dominios — Auth, Tenant, INT, WH, CR, ENV

Secoes **condicionais**: incluir **somente se encontrado** no codigo.

---

## Auth e tokens

```markdown
## Autenticacao e Tokens

### Visao geral
[2-3 frases sobre como auth funciona neste produto]

### Tokens / sessoes
| Token/sessao | Emitido por | Uso | Por que |
|--------------|-------------|-----|---------|
| [tipo] | [servico] | [...] | [...] |

### Roles / permissoes
| Role | Escopo | Rotas tipicas |
|------|--------|---------------|
| [role] | [...] | [...] |

### Middlewares
| Nome | Arquivo | Para que |
|------|---------|----------|
| [nome] | [path] | [...] |
```

---

## Multi-tenant / contexto

```markdown
## Multi-tenant (ou contexto por org/conta)

### Resolucao de contexto
1. [passo — ex.: header X → middleware Y → entidade Z]
2. [...]

### Headers / chaves de contexto
| Header/campo | Quem envia | Para que | Por que |
|--------------|------------|----------|---------|

### Isolamento no banco
- FK / filtros: [listar campos encontrados]
```

Documentar single-tenant **so** se relevante para o dev (decisao explicita).

---

## INT-xxx — Integracao externa

```markdown
### INT-001: [Nome do servico externo]

| Campo | Valor |
|-------|-------|
| Repo | `[adapters]` ([nome-da-pasta]) |
| Fluxo | FL-001 passo 4 (se aplicavel) |
| Tipo | [API REST / SDK / fila / ...] |
| Para que | [login, pagamento, notificacao, ...] |
| Por que | [razao de estar isolado ou separado] |
| Pasta/modulo | [caminho no codigo] |
| Consumido por | `[core]` → `[adapters]` |
| ENV | [variaveis relacionadas, sem valores] |
```

Repetir por servico externo encontrado.

---

## WH-xxx — Webhook

### Inbound

```markdown
### WH-001: [METODO] [path]

| Campo | Valor |
|-------|-------|
| Repo | `[core]` ([nome-da-pasta]) |
| Fluxo | FL-002 passo 1 (se aplicavel) |
| Direcao | Inbound |
| Publica | [Sim/Nao — detalhar protecao] |
| Protecao | [JWT / HMAC / secret / IP allowlist] |
| Para que | [...] |
| Por que | [...] |
| Atualiza | [tabelas/estado] |
| Codigo | [path] |
```

### Outbound

```markdown
### WH-002: [nome descritivo] (outbound)

| Campo | Valor |
|-------|-------|
| Repo | `[core]` ([nome-da-pasta]) |
| Direcao | Outbound |
| Destino | [config URL / campo entity] |
| Para que | [...] |
| Disparado em | [funcao/evento] |
| Codigo | [path] |
```

---

## CR-xxx — Cron / job / worker

```markdown
### CR-001: [Nome do job]

| Campo | Valor |
|-------|-------|
| Repo | `[core]` ([nome-da-pasta]) |
| Tipo | [cron / setInterval / queue worker] |
| Frequencia | [intervalo ou expressao cron] |
| Para que | [...] |
| Por que | [por que nao sincrono] |
| Iniciado em | [entrypoint] |
| Falha/retry | [...] |
| Codigo | [path] |
```

---

## ENV

```markdown
## Variaveis de Ambiente

### `[core]` — [nome-da-pasta]

| Variavel | Obrigatoria | Para que | Por que |
|----------|-------------|----------|---------|
| [VAR] | Sim/Nao | [...] | [...] |

### `[adapters]` — [nome-da-pasta]

...
```

Agrupar por categoria quando `.env.example` tiver secoes. **Nunca** colar secrets.

---

## Ambientes

```markdown
## Ambientes

| Ambiente | Branch / URL | Observacao |
|----------|--------------|------------|
| [nome] | [...] | [...] |
```

Incluir se identificavel no codigo, CI ou env.

---

## Checklist interno

- [ ] Auth rascunhada ou omitida
- [ ] Tenant/contexto rascunhado ou omitido
- [ ] INT / WH / CR listados ou omitidos
- [ ] ENV por repo ou omitido
