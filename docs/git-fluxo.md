> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro**. Editar no repo `space-cursor-skills/docs/`; destino Cursor/Claude Code é cópia (`npm run sync`).

# Fluxo Git — PBI, ambientes, PR, deploy e hotfix

Este arquivo é a regra de promoção de código. Substitui a seção Git do onboarding antigo quando houver contradição.

Como cada skill usa este arquivo: [README.md](README.md).  
Nomenclatura de repo/branch/commit: [nomenclatura.md](nomenclatura.md).  
Visão completa de onboarding: [stacks-e-estrutura.md](stacks-e-estrutura.md).  
Migrations e mudança de dado: [banco.md](banco.md).

> **Mudou em 2026-10-24** (decisão do dono): o fluxo é **`HML` → `main`**. Não existe mais a branch `dev`. A branch da tarefa nasce da `HML` e o PR vai para a `HML`. Nome de branch aceita a descrição (`PBI-xxxx-descricao`) e trabalho sem PBI usa `tipo/AAAA-MM-DD-slug`.

---

## Branches permanentes (ambientes)

Cada repositório tem duas branches que representam ambiente. Elas **não** são branches de feature.

| Branch | Ambiente | Como entra código |
| --- | --- | --- |
| `HML` | Homologação (deve ficar alinhada com o que vai a produção) | **Somente Pull Request** da branch da tarefa → `HML`, com code review. |
| `main` | Produção | **Somente Pull Request** `HML` → `main`, avaliado pelo Tech Lead / Release Manager. |

- Nome da branch de homologação: **`HML`**, em maiúsculas (é o nome que os repositórios usam; para o git, `hml` minúsculo seria outra branch).
- `HML` e `main` recebem código **apenas** via PR aprovado. Onde o plano do GitHub não protege a branch, a regra vale do mesmo jeito: caso real, em 2026-10-06 um PR foi juntado na `main` por engano e precisou de reset forçado.
- **Repositório sem ambiente** (pacote de skills, repositório só de documentação ou de orquestração, que tem só `main`): a branch nasce da `main` e o PR vai para a `main`. Continua valendo: nada direto na `main`, só PR.

---

## O que “nenhum commit direto” significa

| Proibido | Permitido |
| --- | --- |
| `git checkout HML` (ou `main`) → editar arquivos → `git commit` nessa branch | Trabalhar **na branch da tarefa** (`PBI-2304-filtro-de-status`) e só então abrir PR |
| Push de commit criado em `HML` ou `main` sem PR | PR tarefa → `HML`; PR `HML` → `main` |
| Merge local + push em `HML` ou `main` | Hotfix pelo fluxo próprio (abaixo) |
| “Já que estou na `HML`, faço um ajuste rápido aqui” | Branch nova a partir da `HML`, PR |

---

## Criar a branch da tarefa

1. Atualizar a `HML` (`git fetch origin`).
2. Criar a branch **a partir da `HML`**: `git checkout -b PBI-2304-filtro-de-status origin/HML`.
3. Tirar o rastreio da `HML` para um `git push` sem destino não ir para ela: `git branch --unset-upstream`. O primeiro push vai com `git push -u origin <branch>`.
4. Nome (detalhe em [nomenclatura.md](nomenclatura.md)):
   - tarefa com PBI: `PBI-{id}-{descricao-curta}` (ex.: `PBI-3741-cancelamento-de-saque-manual`);
   - trabalho sem PBI (documentação, configuração, ajuste interno): `{tipo}/AAAA-MM-DD-{slug}` (ex.: `docs/2026-10-24-fechamento`, `chore/2026-10-24-env-example`).

**Repositório com submódulos:** cada submódulo fica numa branch (nunca em *detached HEAD*), a mesma que o ambiente dele usa (`HML` ou `main`). As regras do projeto dizem qual é qual.

---

## Fluxo de promoção

```text
tarefa (criada a partir da HML)
    |
    └── Pull Request → HML            (code review + homologação)
              |
              └── Pull Request HML → main   (Tech Lead / produção)
```

### 1. Validação do dono antes do git

**Nada vai para o git antes de o dono validar no ambiente de desenvolvimento.** Terminada a tarefa:

1. deixar o código na branch, dentro da pasta que o ambiente de desenvolvimento (Coder, containers) lê;
2. reiniciar o que precisa (containers, fila, servidor);
3. avisar o dono **o que testar e onde** (endereço, porta, usuário de teste).

Commit, push e PR só depois que o dono aprovar.

### 2. Tarefa → `HML` (Pull Request)

- Origem: a branch da tarefa. Destino: `HML` (`gh pr create --base HML`).
- Obrigatório: code review (pelo menos 1 reviewer) e aprovação dos desenvolvedores responsáveis.
- Título do PR: `PBI-2304 - O que está sendo ajustado` (sem PBI: `tipo: o que muda`).
- PR com migration diz no texto que **ela roda sozinha no deploy**.
- Quem junta o PR é quem aprova; o agente abre e não junta.

**HML ≈ `main`**, inclusive **banco**. Teste e prova de pronto valem neste ambiente como se fosse produção (sem inventar dado que produção nunca teria como único cenário).

### 3. `HML` → `main` (Pull Request)

Com homologação validada e **evidências de pronto** anexadas (o que a task listou em `REGRAS DE DDD`: gravação Front, prova Back/contrato, regressão dos paralelos) **e nenhum item do `NÃO DEVE` verdadeiro**:

- Origem: `HML`. Destino: `main`.
- Review de código **já foi feito** no PR anterior. Aqui o Tech Lead / Release Manager avalia se a branch e os testes estão ok para produção — não é o momento de reabrir o code review linha a linha, salvo problema novo.

---

## Tabela resumo de PRs

| PR | Review obrigatório | Quem aprova |
| --- | --- | --- |
| Branch da tarefa → `HML` | Sim (pelo menos 1 reviewer) | Desenvolvedores |
| `HML` → `main` | Não no sentido de re-review completo (já ocorreu na `HML`) | Release Manager ou Tech Lead |

---

## Migration vai junto com o código

- A migration que cria ou muda a coluna vai **no mesmo PR** do código que usa a coluna.
- **Mudança de dado no banco só por migration**, nunca direto no banco (nem `UPDATE` em cliente SQL, nem console do framework). Motivo: o mesmo código roda em vários bancos (um por cliente/casa) e a migration roda em todos no deploy. Regras da migration: [banco.md](banco.md) BD-08 a BD-11.
- Leitura direta no banco para conferir pode.

---

## Deploy

- Deploy = **EasyPanel rodando o `Dockerfile`** de cada repositório (serviço por app; banco e cache em serviços separados — [stacks-e-estrutura.md](stacks-e-estrutura.md#servidores-easypanel), AP-NAM-07).
- O dono sobe o git; o EasyPanel constrói a imagem e o *entrypoint* do container roda as migrations. **Nada roda à mão** no deploy.
- Comando manual num container de produção (raro, só leitura ou emergência) roda com o **usuário do servidor web**, nunca como root: arquivo de cache criado por root derruba o app com "Permission denied" (caso real, 2026-10-21).

---

## Hotfix emergencial

Quando produção está quebrada e não dá para esperar o ciclo tarefa → `HML` → `main`:

1. Branch criada **a partir de `main`**, prefixo `hotfix_` (exemplo: `hotfix_login-500`).
2. Pull Request da branch de hotfix → `main` (aprovado).
3. **Back-merge** da mesma correção na `HML` (PR), para homologação não ficar atrás de produção.

Não commitar o hotfix direto em `main`. Não “aproveitar” uma branch de PBI antiga para emergência se o commit não for o da correção isolada.

---

## Commits

Formato:

```text
tipo: mensagem no imperativo, em português ou inglês consistente no repo
```

Exemplos: `feat: adicionar filtro de status na listagem`, `fix: corrigir botão de salvar no modal`.

Tipos usuais: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`. Não usar o envelope `[tipo: "comentario"]` com aspas literais — o exemplo antigo do onboarding era literal demais e o júnior copiava as aspas.

Um commit = uma intenção. Não misturar formatação do linter com regra de negócio no mesmo commit se der para separar.

---

## O que a skill de PO coloca na task

Se a PBI muda fluxo de branch ou o júnior é novo no repo: apontar este arquivo (ou copiar o diagrama em PNG / mermaid.ink — **nunca** bloco `mermaid` cru no ClickUp). Não reescrever um GitFlow paralelo na task.

Se a skill de contexto for documentar práticas da empresa: apontar para cá; não inventar “git flow clássico” com `develop` ou `dev` — o time usa `HML` + `main`.
