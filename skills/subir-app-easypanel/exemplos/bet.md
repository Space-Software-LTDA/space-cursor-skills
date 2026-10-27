# Exemplo: bet (casas de apostas, EasyPanel)

> Produto: `space-spacesoft-bet` (Home Vue + backoffice e partners Laravel/Filament, MySQL compartilhado). Caso real: casa **Los Hermanos**, 2026-10-27. Casa modelo usada como exemplo: **BravaBet** (no ar, só leitura).
> Roteiro completo da demanda: `space-spacesoft-bet/docs/demandas/2026-10-26-subir-casa-nova/etapas/04-primeira-casa-los-hermanos.md`.

## Scripts (repo do bet)

Ficam em `space-spacesoft-bet/deploy/casa-nova/`, na `main` (juntados em 2026-10-27). Variáveis do `casa.env`: `deploy/casa-nova/README.md`.

| Script | Para quê |
|--------|----------|
| `modelo/gerar-modelo.sh` | Gera o modelo na casa modelo (`ADMIN_IDS=1`): só leitura; `modelo.sql.gz` + `images/` em `/srv/space/modelo/` |
| `modelo/copiar-modelo.sh` | Copia o modelo direto entre servidores (`--de`, `--para`, `--dry-run`) |
| `construir-no-servidor.sh` | Build das 3 imagens no servidor novo + registry local; envia `inicializar.sh` |
| `esquema.py` | Gera o esquema do `createFromSchema` (`--parte banco` / `--parte apps`) |
| `inicializar.sh` | `banco <slug>` importa o modelo (só com 0 tabelas); `app <slug>` roda `bet:fabrica`, limpa a cópia e cria o admin novo |
| `subir-casa.sh` | Orquestrador (`--env casa.env --painel http://IP:3000 [--admin-senha-arquivo ARQ] --dry-run`) |

## Particularidades do bet

- **Serviços:** `<slug>-database`, `<slug>-redis`, `<slug>-backoffice`, `<slug>-home`, `<slug>-partners`, no projeto `<slug>`.
- **Branches:** Home e backoffice da `HML`; partners da `main` (`construir-no-servidor.sh --host NOVO --home origin/HML --backoffice origin/HML --partners origin/main`, ~13 min).
- **Imagens:** `127.0.0.1:5000/space/<repo>:<versão>`. O backoffice leva volume `images` em `public/images`; a Home leva *bind* na mesma pasta (`/etc/easypanel/projects/<slug>/<slug>-backoffice/volumes/images`, mesmo inode).
- **Subdomínios:** as casas costumam ter `backoffice.` e `parceiros.`; o usuário pode ter criado `partners.`. Sempre perguntar. `WWW=1` no `casa.env` cadastra o `www.` na Home.
- **Admins:** `ADMIN_IDS=1` (ids do modelo que ficam), `ADMIN_EMAIL` e `ADMIN_NOME` (admin novo, criado pelo `inicializar.sh app` rodando como `www-data`); o modelo traz o `admin@admin.com`, cuja senha o usuário troca.
- **`bet:fabrica`:** o `inicializar.sh` só o roda sem dinheiro/jogadores e só com os admins esperados em `users`. Ele zera o logo.
- **Logo e favicon travam a Home:** a `LoadingScreen` só some com `global.logo`. O usuário cadastra no backoffice → Designer → Personalização, logo após o deploy; avisar antes de dizer "no ar".
- **Variáveis a comparar com a casa modelo:** `SESSION_*` (`SESSION_DRIVER=redis`), `QUEUE_CONNECTION=sync`, `LOG_LEVEL=warning`, `APP_MAINTENANCE_DRIVER=file`, `REDIS_PREFIX` por app. Depois do init, `cache:clear` também na Home.
- **Testes após subir:** casa 200, `www` 200, backoffice 302 → `/admin`, partners 200, uma capa de jogo 200 `image/webp`.
- **Lista do usuário no relatório:** logo, favicon, banners, cores, gateway, agregador, SMTP, cadastro no proxy, trocar a senha dos admins do modelo.
- **Réplica:** destino `<slug>-database` no projeto `databases` do painel de réplicas.

## Os 13 passos no bet

1. Entradas (SSH novo e casa modelo; painel/token; slug; domínios; admins; branches; painel de réplicas).
2. Reconhecer o servidor novo.
3. DNS na Cloudflare (raiz, backoffice, partners; `www` CNAME).
4. `ADMIN_IDS=1 /root/gerar-modelo.sh` na casa modelo: conferir "todas as N tabelas classificadas", só os admins, zero dinheiro/jogada/sessão.
5. `copiar-modelo.sh --de MODELO --para NOVO` (`--dry-run` antes).
6. `construir-no-servidor.sh` (anotar as `VERSAO_*`).
7. `casa.env` (600): `APP_KEY` = `base64:` + 32 bytes, `INTERNAL_API_TOKEN` = `openssl rand -hex 32`, `ADMIN_*`, `WWW=1`.
8. `subir-casa.sh` em dry-run, depois real (banco/redis → importar → apps → deploy → `inicializar.sh app` → `cache:clear` na Home → testes).
9. Logo e favicon (usuário).
10. Tailscale (OK explícito; só a URL de login).
11. MySQL de destino (`mysql:9`, sem porta).
12. `replicar-mysql` (ponte `299NN`).
13. Relatório final.

## Histórico do primeiro uso: Los Hermanos (2026-10-27)

- O primeiro painel informado era o do servidor de réplicas, não o do servidor novo (token dava 401).
- O usuário criou `partners.` e o padrão era `parceiros.` (404 no partners).
- Cópia do modelo: 848 KB de SQL + 241 MB de imagens em 6,6 s (contra 14 min passando pelo Coder).
- Build: ~13 min, ~1 GB por imagem.
- Número de variáveis obrigatórias do `casa.env`: 15.
- Casa importada: 85 tabelas, 5.858 capas; no ar em ~10 min fora o build.
- Home presa na tela de carregamento até o logo entrar.
- Destino da réplica recriado após vazar senha na saída; réplica na ponte 29901, GTID 1-324.
- Mais detalhes e decisões: roteiro `04-primeira-casa-los-hermanos.md` citado no topo.

### Correções do primeiro uso, com os nomes do bet
- Apps em 500 por falta de `SESSION_DRIVER=redis`, `SESSION_*`, `QUEUE_CONNECTION=sync`, `LOG_LEVEL=warning`, `APP_MAINTENANCE_DRIVER=file` e `REDIS_PREFIX` por app (`esquema.py`).
- `deployService` com `pull access denied`: registry local em `construir-no-servidor.sh`.
- Apps do `createFromSchema` sem subir: `deployService` em `subir-casa.sh`.
- Admin não criado: `inicializar.sh` cria o admin rodando como `www-data` com `auth()->setUser(<admin 1>)`; senha pela entrada padrão.
- Cópia de 241 MB passando pelo Coder (14 min): `copiar-modelo.sh` direto, 6,6 s.
- Senha do root na lista de processos: `gerar-modelo.sh` usa `MYSQL_PWD` via `docker exec -e`.
- Home presa na tela de carregamento: `LoadingScreen` só some com `global.logo` e o `bet:fabrica` zera o logo; domínio `partners.` (não `parceiros.`).
- Pendências: `inicializar.sh app` receber `CASA_LOGO_URL`/`CASA_FAVICON_URL` (a primeira rodada completa do `subir-casa.sh` foi feita no segundo uso, abaixo).

## Segundo uso: BossPlay (2026-10-27)

- **Mesmo servidor da Los Hermanos**, como projeto separado (`listProjects` = `['loshermanos']`). Tailscale, registry local e modelo reaproveitados; o build só refez o backoffice (a HML andou).
- **Primeira rodada completa do `subir-casa.sh`**: sem erro, 2 min 46 s (sem contar o build). Variáveis iguais às da Los Hermanos; as únicas diferenças (`PORT`, `GIT_SHA`, `DEPLOY_TIMESTAMP`) vêm do `Dockerfile`.
- **Destino da réplica já existia** no projeto `databases`, com dados de teste antigos (não era réplica): dump em `/root/backups/…-ANTIGO-TESTE-…sql.gz`, `DROP DATABASE`, `verificar` 0 falha, `montar` (ponte 29902, GTID igual).
- Tokens colados no chat pelo usuário: gravados em 600, recomendado gerar novos.
- Roteiro: `space-spacesoft-bet/docs/demandas/2026-10-26-subir-casa-nova/etapas/05-segunda-casa-bossplay.md`.
