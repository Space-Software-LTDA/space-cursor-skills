# Perguntas — Fase 3 (Entrevista)

Executar **depois** da Fase 2 e **antes** da Fase 4. Validar inferencias e capturar regras **nao presentes no codigo**.

**Sempre em portugues.**

**Gate:** apresentar blocos 1 e 2 no chat e **aguardar resposta**. So gravar `.docs/contexto-*.md` apos respostas (ver [SKILL.md](SKILL.md) Gates).

---

## Bloco 1 — Negocio (obrigatorio)

Apresentar ao usuario:

1. **Qual problema de negocio este produto resolve?**
2. **Quem sao os usuarios finais?**
3. **Por que existem N repositorios separados?** (validar DA-xxx inferidos)
4. **Quais sao as 3–5 jornadas que todo dev precisa entender?** (valida FL-xxx)
5. **O que um dev novo mais erra neste projeto?** (prioriza FL-xxx)

---

## Bloco 1b — Referencia rapida (obrigatorio)

Perguntas para o cartao no **topo do documento** (antes do indice curto):

1. **URLs de ambiente teste:** app jogador, API core, integration, dashboard/painel
2. **Header tenant:** valor de `x-application-domain` nos exemplos
3. **Credenciais de teste:** usuario/senha player (se existirem) — **sem commitar secrets no doc final se o time pedir**
4. **Repos Git:** confirmar URLs `git remote get-url origin` por alias (ou informar manualmente)

```markdown
| Item | Valor |
|------|-------|
| App teste | https://... |
| API core | https://... |
| Player teste | email / [CONFIRMAR senha] |
| Repo core | https://github.com/... |
```

Se o usuario ja informou no chat, **confirmar** e registrar para Fase 4.

---

## Bloco 1c — Exemplos concretos para narrativa (obrigatorio)

Perguntas para alimentar **casos de uso** e **exemplos** no documento (tom professor — ver [pedagogical-examples.md](pedagogical-examples.md)):

1. **Qual tenant/app de teste** devemos usar nos exemplos? (domain, URL publica)
2. **2–3 cenarios reais** que ilustram regras contra-intuitivas (ex.: mesmo email em dois apps, login delegado, config sem redeploy)
3. **URLs de ambiente** que podem aparecer nos exemplos (API, front, dashboard) — sem secrets
4. **Nomes de platform/bet** usados em staging para exemplos de integration (se multi-bet)

Se o usuario ja informou no chat (ex.: `app.test.exemplo.com`, `tenant-especial.exemplo.com`), confirmar e registrar para Fase 4.

---

## Bloco 2 — Validacao das extractions (obrigatorio)

Apresentar **somente itens extraidos deste projeto** — copiar template abaixo preenchido:

```markdown
Encontrei no codigo:

**Fluxos (FL):**
- FL-001: [titulo] — correto?
- FL-002: [titulo] — correto?

**Regras (RN):**
- RN-001: [titulo] — correto?
- ...

**Guardrails (G):**
- G-001: [titulo] — correto?
- ...

**Outros (se houver):**
- INT: [lista] — falta algum?
- WH-001: [titulo] — correto?
- CR-001: [titulo] — correto?

**Itens [CONFIRMAR] pendentes:**
- [listar]

**Perguntas:**
- Algum fluxo FL incompleto ou ordem de passos errada?
- Alguma RN ou Guardrail errada ou incompleta?
- Regra de negocio importante **fora do codigo**?
- Algo diferente em producao vs codigo?
```

**Listar apenas o que foi encontrado neste produto.** Nao importar exemplos de outros projetos.

---

## Bloco 3 — Banco (se TB gerados)

6. Alguma coluna com Por que diferente do inferido?
7. Campos JSON — chaves deprecated ou sensiveis?

---

## Bloco 4 — Rotas e Apidog

8. Apidog atualizado com o codigo?
9. Rotas internal-only ou deprecated?

---

## Bloco 5 — Contexto multi-tenant (se secao existir)

10. Tenants/clientes com comportamento especial?
11. Single-tenant por design? (se relevante documentar)

---

## Bloco 6 — Ambientes

12. URLs dev / hml / prod corretas?
13. ENV critica nao documentada?

---

## Quando pular ou encurtar

| Situacao | Acao |
|----------|------|
| Usuario **ja respondeu** no chat (mesma sessao ou anterior) | Usar respostas; registrar o que foi confirmado |
| Dominio nao encontrado no codigo | Nao perguntar bloco daquele dominio |
| Usuario escreve **explicitamente** "pular Fase 3" / "gerar doc sem entrevista" | Fase 4 com doc preliminar; `[CONFIRMAR]` maximo na Revisao pendente; avisar que falta validacao humana |

### Nao pular Fase 3 nestes casos

| Pedido do usuario | Acao correta |
|-------------------|--------------|
| "Implemente o plano" | Executar fases na ordem; plano com todo "gerar doc" = Fase 4 **depois** da 3 |
| "Teste agora" / "crie o contexto" | Fase 0b → 1 → 2 → **3 (parar e perguntar)** → 4 |
| "Execute" / urgencia implicita | Mesmo fluxo; nao gravar `.docs/` antes da 3 |
| Usuario nao respondeu ainda | **Aguardar** — nao assumir defaults |

---

## Output da Fase 3

- Respostas registradas (para incorporar na Fase 4)
- FL/RN/G confirmados ou corrigidos
- **Exemplos concretos** registrados (domains, URLs, cenarios) para RN/FL/G
- `[CONFIRMAR]` reduzido ao que ficou em aberto
- Texto para secao Contexto (incluindo erros classicos com links para RN/G)
- Observacoes adicionais

**Proximo passo:** Fase 4 — montar doc e gravar `.docs/contexto-[slug].md` (nao commitar automaticamente).
