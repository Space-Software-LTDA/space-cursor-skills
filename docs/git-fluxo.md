> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro**. Editar no repo `space-cursor-skills/docs/`; destino Cursor é cópia (`npm run sync`).

# Fluxo Git — PBI, ambientes, PR e hotfix

Este arquivo é a regra de promoção de código. Substitui a seção Git do onboarding antigo quando houver contradição.

Como cada skill usa este arquivo: [README.md](README.md).  
Nomenclatura de repo/branch/commit: [nomenclatura.md](nomenclatura.md).  
Visão completa de onboarding: [stacks-e-estrutura.md](stacks-e-estrutura.md).

---

## Branches permanentes (ambientes)

Cada repositório tem três branches que representam ambiente. Elas **não** são branches de feature.

| Branch | Ambiente | Como entra código |
| --- | --- | --- |
| `dev` | Desenvolvimento / stage (quando o ambiente existir) | **Merge da branch do PBI** + `git push origin dev`. Não é commit solto feito em cima de `dev`. |
| `hml` | Homologação (deve ficar alinhada com o que vai a produção) | **Somente Pull Request** da branch do PBI → `hml`, com code review. |
| `main` | Produção | **Somente Pull Request** `hml` → `main`, avaliado pelo Tech Lead / Release Manager. |

`hml` e `main` têm proteção de branch: merge **apenas** via PR aprovado.

---

## O que “nenhum commit direto” significa

A frase antiga misturava duas coisas e gerava dúvida. Fica explícito:

| Proibido | Permitido |
| --- | --- |
| `git checkout dev` (ou `hml` / `main`) → editar arquivos → `git commit` nessa branch | Trabalhar **na branch do PBI** (`PBI-2304`) e só então integrar |
| Push de commit criado em `hml` ou `main` sem PR | PR PBI → `hml`; PR `hml` → `main` |
| “Já que estou em `dev`, faço um hotfix rápido aqui” | Hotfix tem fluxo próprio (abaixo) |

**Exceção controlada — só `dev`:** depois que a PBI está pronta para teste interno, o desenvolvedor faz **merge da branch do PBI em `dev`** (comandos abaixo) e dá push. Isso **não** é “commit direto”: o commit da feature nasceu na `PBI-xxxx`; `dev` só recebe o merge.

`hml` e `main` **nunca** recebem merge local + push. Só PR.

---

## Criar a branch da tarefa

1. Atualizar a branch principal (`main` ou `master`, o que o repo usar).
2. Criar a branch **a partir de `main`**, nunca a partir de `dev` ou `hml`.
3. Nome = ID customizado do PBI no ClickUp, exemplo: `PBI-2304`.

Detalhe da nomenclatura: [nomenclatura.md](nomenclatura.md).

---

## Fluxo de promoção

```text
PBI-xxxx (criada a partir de main)
    |
    ├── merge local + push → dev     (teste / stage, se o ambiente existir)
    |
    └── Pull Request → hml           (code review + homologação)
              |
              └── Pull Request hml → main   (Tech Lead / produção)
```

### 1. PBI → `dev` (merge direto, não PR)

Objetivo: colocar a implementação no ambiente de desenvolvimento para teste.

```bash
git checkout dev
git pull origin dev
git merge PBI-2304
git push origin dev
```

Se o repositório **não** tiver ambiente `dev`, esta etapa simplesmente não se aplica — a promoção começa no PR para `hml`.

### 2. PBI → `hml` (Pull Request)

Depois dos testes em `dev` (quando houver) e da validação da tarefa:

- Origem: `PBI-2304`
- Destino: `hml`
- Obrigatório: code review (pelo menos 1 reviewer) e aprovação dos desenvolvedores responsáveis
- Título do PR: `PBI-2304 - O que está sendo ajustado`

Só então o merge do PR vai para homologação.

### 3. `hml` → `main` (Pull Request)

Com homologação validada e evidências da tarefa anexadas:

- Origem: `hml`
- Destino: `main`
- Review de código **já foi feito** no PR anterior. Aqui o Tech Lead / Release Manager avalia se a branch e os testes estão ok para produção — não é o momento de reabrir o code review linha a linha, salvo problema novo.

---

## Tabela resumo de PRs

| PR | Review obrigatório | Quem aprova |
| --- | --- | --- |
| Branch do PBI → `hml` | Sim (pelo menos 1 reviewer) | Desenvolvedores |
| `hml` → `main` | Não no sentido de re-review completo (já ocorreu em hml) | Release Manager ou Tech Lead |

Não existe PR obrigatório PBI → `dev`. O caminho para `dev` é o merge descrito acima.

---

## Hotfix emergencial

Quando produção está quebrada e não dá para esperar o ciclo PBI → hml → main:

1. Branch criada **a partir de `main`**, prefixo `hotfix_` (exemplo: `hotfix_login-500`).
2. Pull Request da branch de hotfix → `main` (aprovado).
3. **Back-merge** da mesma correção em `hml` e em `dev`, para os ambientes não ficarem atrás de produção.

Não commitar o hotfix direto em `main`. Não “aproveitar” uma `PBI-xxxx` antiga para emergência se o commit não for o da correção isolada.

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

Se a skill de contexto for documentar práticas da empresa: apontar para cá; não inventar “git flow clássico” com `develop` se o time usa `dev` + `hml` + `main`.
