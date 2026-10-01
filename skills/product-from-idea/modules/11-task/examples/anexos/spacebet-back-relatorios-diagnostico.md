> ⚠️ Esta tarefa foi estruturada com auxílio de Inteligência Artificial com base nas informações fornecidas. Embora o conteúdo tenha sido organizado para facilitar o entendimento, podem existir interpretações incorretas ou incompletas. Em caso de dúvida, valide com o solicitante antes de iniciar o desenvolvimento.

# 🔗 Relatórios do dashboard — diagnosticar por que funciona em alguns APPs e quebra em outros

| | |
| --- | --- |
| **Projeto** | SpaceBet |
| **Camadas** | Backend (subtask). Spec completa na MAIN. |
| **Repositório Backend** | [Space-Software-LTDA/space-app-spacebet-backend](https://github.com/Space-Software-LTDA/space-app-spacebet-backend) |
| **API** | Base do dash: `NEXT_PUBLIC_API_URL` → `https://api.spacebet.app` |
| **Env** | Sem variável nova. **Não** alterar `GA4_PROPERTY_ID` nem `GA_CREDENTIALS_URL`. Só leitura. |
| **Contrato API** | **Não muda nesta entrega.** Laudo compara o que existe. Swagger **mente** — fonte = `routes.ts`. |
| **Git** | **Sem branch e sem PR.** Laudo. Repo intocado. |

### Constituição

| Ouro | Como esta subtask usa |
| --- | --- |
| Entry point | Roteiro já existe: `dashboard.controller.ts` → `googleAnalyticsService` → `GoogleAnalyticsHelper`. Teste de ouro: de onde vem o `domain` e o que o GA4 filtra, **sem** abrir o helper. **Não** refatorar. |
| GO-11 | Só chama path que **já existe**. Não inventar alias `/trafego`. |
| GO-12 | Coluna `domain` já existe. **Não** rename. |

---

## 📌 Contexto

O **expert** (Admin) abre Relatórios no dashboard e espera métricas **do APP dele**. Há vários APPs (`application`). O Back filtra GA4 por `application.domain` com match **EXACT** no `hostName`. Em alguns APPs os números aparecem; em outros “não funciona nem a pau”.

O menu Relatórios é `/dashboard/metricas`, **não** o mock `/dashboard/reports`.

Esta subtask = laudo Back. **Não** corrige cache, domain, swagger nem filtro EXACT.

### Glossário rápido

| Termo | Significado |
| --- | --- |
| **APP** | Linha em `application` (`id`, `name`, `domain`). |
| **`application.domain`** | Hostname do **site do jogador**. Vai ao GA4 como `hostName`. Não é o painel. |
| **Admin** | JWT amarra `admin.application`. Header `x-application-domain` **não** escolhe o APP. |
| **Filtro EXACT** | `app.foo.com` ≠ `www.app.foo.com`. |
| **Cache campanha** | Chave `campaign_metrics_{dateFrom}_{dateTo}` — **sem** domain. TTL 15 min. |

---

## 🎯 Objetivo

Provar com curl + banco + GA4 Explorer **por que** o APP ok responde diferente do APP quebrado. Entrega = laudo. Sem PR.

---

## 🗺️ Paths vivos (não use o swagger)

| Front chama | Back (`routes.ts`) |
| --- | --- |
| `GET /dashboards/metrics/campaign` | `GET /dashboards/metrics/campaign` |
| `GET /dashboards/metrics/funnel` | `GET /dashboards/metrics/funnel` |
| `GET /dashboards/metrics/monetization` | `GET /dashboards/metrics/monetization` |
| `GET /dashboards/metrics/trafego` | `GET /dashboards/metrics/traffic` |
| (abas Jogos/Retenção/Qualidade/Dispositivos sem page) | `games` / `retention` / `quality` / `devices` existem no Back |
| Tempo | **Não existe** no Back |

Swagger: `GET /dashboard/metrics/campaign` + query `startDate`/`endDate` — **errado**. Código: `dateFrom`/`dateTo`.

JSON de tráfego no Back: `visitors`, `registrations`, `ftds`. O Front lê `users` / `purchases` — isso é prova do Front; no curl do Back anote as **keys reais**.

---

## 🔧 Backend — roteiro

### Pré-requisito

O briefing **não nomeou** os APPs. **Peça** o par ok/quebrado no comentário da MAIN. Sem o par, **pare**.

Produção = onde o expert reclama (GA4 é evento real). Leitura only: **zero** `UPDATE`, **zero** restart para limpar cache sem avisar.

### 1. De onde vem o `domain`

| Role | `request.application` | Header `x-application-domain` |
| --- | --- | --- |
| `Admin` | `admin.application` | **Ignorado** |
| `StaffUser` | `findOne({ domain: header })` | Obrigatório |

```sql
SELECT id, name, domain
FROM application
WHERE name ILIKE '%...%'
   OR domain ILIKE '%...%';
```

Anotar **exato**, byte a byte.

### 2. GA4

Uma property (`GA4_PROPERTY_ID` — anotar se preenchida / últimos 4 dígitos; **não** colar credential JSON).

No Explorer da **mesma** property, dimensão `hostName`, mesmo `dateFrom`/`dateTo` da tela:

| `application.domain` | hostName no GA4 | Relatório |
| --- | --- | --- |
| Igual + eventos `sign_up` / `FTD` / `purchase` | Tem linha | Deveria ter número |
| Igual, evento com outro nome | Helper não conta | 200 vazio |
| Diferente (`www`, domínio do painel, domínio antigo) | Eventos no host do jogador | 200 vazio — clássico “só alguns APPs” |
| Domain vazio | — | 404 `"Aplicação não encontrada"` |

Filtro no código: `fieldName: hostName`, `matchType: EXACT`, `value: application.domain`.

### 3. Quatro GETs × dois tokens

```bash
API="https://api.spacebet.app"

curl -sS -D - -H "Authorization: Bearer ${TOKEN_APP_OK}" \
  "$API/dashboards/metrics/campaign?dateFrom=2026-08-08&dateTo=2026-09-07&page=1&perPage=10"
curl -sS -D - -H "Authorization: Bearer ${TOKEN_APP_OK}" \
  "$API/dashboards/metrics/funnel?dateFrom=2026-08-08&dateTo=2026-09-07"
curl -sS -D - -H "Authorization: Bearer ${TOKEN_APP_OK}" \
  "$API/dashboards/metrics/monetization?dateFrom=2026-08-08&dateTo=2026-09-07"
curl -sS -D - -H "Authorization: Bearer ${TOKEN_APP_OK}" \
  "$API/dashboards/metrics/traffic?dateFrom=2026-08-08&dateTo=2026-09-07"
```

Repetir com `TOKEN_APP_QUEBRADO`. Admin: APP sai do JWT. **Não** chamar `/trafego` e concluir que “tráfego não existe”.

Anotar status, keys, tamanho. Sem token no anexo.

### 4. Cache de campanha

Mesmo período, dois tokens, **&lt; 15 min**, A depois B. B repetiu A? H2 confirmada ou morta. Vários pods = cache por processo; um try que não colide **não** mata H2 — anote.

### 5. Env (leitura)

`GA4_PROPERTY_ID` e `GA_CREDENTIALS_URL` preenchidos? Se env vazio, **todos** os APPs 500 — aí “alguns ok” não fecha com 500 de env.

### 6. Não fazer

Não muda chave de cache, EXACT, `domain` no banco, alias `trafego`, swagger.

---

## 📋 Template do laudo (Back preenche identificação, H1/H2/H6/H7/H8, conclusão Back)

| | APP ok | APP quebrado |
| --- | --- | --- |
| Nome | | |
| `application.id` | | |
| `application.domain` (exato) | | |
| Ambiente | | |
| Período | | |

| # | Hipótese | Veredito | Evidência |
| --- | --- | --- | --- |
| H1 | `domain` ≠ `hostName` GA4 | | |
| H2 | Cache campanha sem domain | | |
| H6 | Eventos com outro nome | | |
| H7 | Env GA4 ausente (quebraria todos) | | |
| H8 | 404 Aplicação não encontrada | | |
| H9 | Outra | | |

Conclusão: causa por APP / global / hipóteses mortas / sugestão para a **próxima** task (não implementar).

---

## 🖼️ Diagrama

![Fluxo: expert → attachApplication → application.domain → cache → GA4 hostName EXACT](https://raw.githubusercontent.com/Space-Software-LTDA/space-assets/main/spacebet/relatorios-metricas-diagnostico/diagram-fluxo-ga4.png)

Uma property. O APP só entra como `hostName`.

---

## ✅ Critérios de Aceitação

**BE-1: Par de APPs no banco**

- **Dado** os dois nomes/logins do solicitante
- **Quando** o `SELECT id, name, domain`
- **Então** o laudo tem `id` + `domain` **exato** dos dois

**BE-2: domain vs hostName GA4**

- **Dado** a property do env
- **Quando** você lista `hostName` no período da tela
- **Então** para cada APP: existe linha EXACT? Existem `sign_up` / `FTD` / `purchase`? Print/export colado

**BE-3: oito curls**

- **Dado** dois JWTs de expert
- **Quando** `campaign`, `funnel`, `monetization`, `traffic` com o mesmo período
- **Então** status + keys + recorte dos oito. Nenhum `/trafego`. Nenhum `startDate`

**BE-4: cache**

- **Dado** mesmo período, A depois B, &lt; 15 min
- **Quando** GET campaign
- **Então** H2 confirmada ou morta, com os dois JSON

**BE-5: env**

- **Dado** o Back que o dash de prod chama
- **Quando** você confere as duas keys
- **Então** “preenchido sim/não”. Secret fora. H7 preenchida

---

## 🏁 REGRAS DE DDD

**Peça** o par de APPs. **Dispare** os quatro GETs com cada JWT. **Confirme** `domain` no banco e `hostName` no GA4. **Grave** o laudo. Git status **limpo**.

**Paralelos (não mexer):** home `/dashboard` (`active-users` / `top-games`), `attachApplication` em Usuários/Depósitos/Gatilhos, env `GA4_*`, app do jogador.

| ID | Anexar |
| --- | --- |
| **P-BACK-1** | 4 GETs APP ok (status + keys). Token fora. |
| **P-BACK-2** | 4 GETs APP quebrado. |
| **P-BACK-3** | SELECT dos dois + hostName no GA4. |
| **P-BACK-4** | Par A→B campaign. Veredito H2. |

---

## 📝 Observações

- Sem o par de APPs, relógio parado.
- HML sem evento GA4 não substitui produção (leitura only).
- Home usa `INTERVAL '3 hours'`; Relatórios usam timezone da property GA4. Não misturar KPI.
- Cache `NodeCache` é por processo / pod.

---

## ⛔ NÃO DEVE

> **BLOQUEIO.** Se qualquer linha abaixo for verdade, a entrega **não** está pronta — mesmo que o caminho feliz “pareça ok”. Não negociar. Não “quase pronto”.

| Se isto acontecer | Por que é falha |
| --- | --- |
| Abrir PR / commitar fix no backend (ou em qualquer repo de produto) | Esta entrega é laudo. |
| “Corrigir no chute” `domain`, EXACT ou chave de cache | Mascara a evidência. |
| Laudo com um APP só | Exige os dois. |
| Colar credential GA / JWT completo | Secret. |
| Chamar `GET …/trafego` e concluir que tráfego “não existe no Back” | Router é `/traffic`. |
| Encerrar com “é o GA” sem print `hostName` vs `domain` | H1 sem evidência. |
| Prova só em localhost com GA4 vazio | Não é o APP do expert. |
| Diff no git do produto | Read-only. |

> **Frase de ouro.** Pronto Back = oito curls, `domain` vs `hostName`, veredito do cache, env sem secret, **zero** linha mergeada. Qualquer linha da tabela = **não** está pronto.
