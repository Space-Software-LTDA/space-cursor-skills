# Guia Apidog

Fonte canonica de **contratos HTTP** quando o usuario informar links.

Links associados aos **repos API descobertos no recon** (Fase 0a) — nomes reais das pastas, nunca rotulos predefinidos.

---

## Quando pedir Apidog

Apos Fase 0a, para cada repo classificado como **servidor HTTP com rotas**:

| Recon | Pergunta |
|-------|----------|
| 1 repo API | "Link Apidog desta API?" |
| N repos API | "Links Apidog (virgula ou um por linha)?" |
| 0 repos API | Nao perguntar |
| Usuario diz "sem apidog" | Omitir secao Apidog no doc |

---

## Formatos aceitos

**Virgula:**
```
https://app.apidog.com/project/a, https://app.apidog.com/project/b
```

**Linha (rotulo = nome do repo):**
```
meu-api-core: https://...
servico-pagamentos: https://...
```

**Link unico:** um URL para cruzar todos os repos API.

**Sem Apidog:** `sem apidog`

---

## Associar link ao repo

| Situacao | Acao |
|----------|------|
| 1 link, 1 repo API | Direto |
| N links, N repos (mesma ordem) | Por ordem |
| Links com rotulo | Rotulo = nome inferido no recon |
| 1 link, N repos API | Cruzar todos; filtrar por path/modulo |

Nao iniciar catalogo RT de APIs sem links ou "sem apidog" confirmado.

---

## Descoberta

1. Abrir link (WebFetch ou browser)
2. Extrair: metodo, path, summary, params, body, responses
3. Cruzar com codigo do repo associado
4. Apidog → **Para que**; codigo → **Por que**

---

## Prioridade de fontes

1. Apidog
2. Codigo
3. openapi.json / swagger.yaml

---

## Cruzamento

| Situacao | Acao |
|----------|------|
| Apidog + codigo | RT-xxx + link |
| So Apidog | RT `[CONFIRMAR]` |
| So codigo | RT sem link; Observacoes se util |
| Conflito | Codigo = Por que; Apidog = contrato |

---

## No documento final

Tabela dinamica — uma linha por repo API com link:

```markdown
## Referencias — Documentacao API (Apidog)

| Repo | Link Apidog | O que documenta la vs aqui |
|------|-------------|----------------------------|
| [nome real do repo] | [Abrir](URL) | Contratos HTTP deste servico |

> Apidog = **o que** enviar/receber. Este doc = **por que** e **para que**.
```

Se "sem apidog": omitir secao inteira.

Por rota: `| Apidog | [Ver endpoint](URL) |`

---

## Apidog inacessivel

1. Pedir export OpenAPI
2. Fallback swagger + codigo
3. Marcar `[CONFIRMAR]`

---

## O que nao duplicar do Apidog

Payloads completos, tutorial de chamada — link basta. Este doc complementa.
