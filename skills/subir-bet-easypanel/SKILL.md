---
name: subir-bet-easypanel
description: >-
  Sobe uma casa (bet) nova num servidor com EasyPanel, de ponta a ponta e com
  serviços nativos: reconhece o servidor, gera o modelo na casa modelo (só
  leitura), copia direto entre servidores, constrói as imagens no servidor novo,
  cria banco, redis e os 3 apps pela API do EasyPanel, inicializa a casa, confere
  os domínios, instala o Tailscale e monta a réplica do MySQL pela skill
  replicar-mysql. Use com /subir-bet-easypanel, "subir bet", "casa nova",
  "subir casa no EasyPanel", "nova bet no servidor".
disable-model-invocation: true
---

# Subir bet no EasyPanel

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta máquina** (PC ≠ Coders).
> **Altere em** `space-cursor-skills/skills/subir-bet-easypanel/` → **obrigatório rodar** `npm run sync` na raiz (máquina alvo).
> Ver `00-COPIA-LEIA-ME.md`. Hub do pack: **`/skill-update`**. Fluxo do repo: **`AGENTS.md`**.
> **Use sempre o clone atualizado do pacote**: a cópia sincronizada pode estar velha (no primeiro uso a cópia estava sem 13 correções da `replicar-mysql`).

**Trigger:** `/subir-bet-easypanel` · **Sempre responder em português.**

## Papel

Subir **uma casa nova** (nunca mexer em casa existente) num servidor novo com EasyPanel, com serviços **nativos** (`<slug>-database`, `<slug>-redis`, `<slug>-backoffice`, `<slug>-home`, `<slug>-partners`, no projeto `<slug>`), iguais aos das casas no ar, e deixar a réplica do banco montada. O agente conduz; o usuário faz só o que é dele (DNS, logo, favicon, Tailscale se não houver OK, gateway, agregador, SMTP).

**A skill não carrega os scripts: usa os do repo do produto** (`space-spacesoft-bet/deploy/casa-nova/`, na `main`; enquanto o PR que os traz não for juntado, estão na branch `docs/2026-10-26-compose-casa-nova` desse repo — conferir com `git ls-tree origin/main deploy/casa-nova`). A skill é o roteiro, as leis e a memória dos tropeços; o código mora no repo do bet e evolui com ele.

Conteúdo **genérico**: nenhum IP, token ou senha real. Nomes de casas só como exemplo curto.

## Arquivos

| Arquivo | Para quê |
|---------|----------|
| [`reference.md`](reference.md) | API do EasyPanel usada (tRPC), tropeços conhecidos com a correção, roteiro manual equivalente aos scripts |
| [`CORRECOES.md`](CORRECOES.md) | Registro das correções do primeiro uso (Los Hermanos, 2026-10-27) |
| Scripts (repo do bet) | `deploy/casa-nova/`: `README.md`, `modelo/gerar-modelo.sh`, `modelo/copiar-modelo.sh`, `construir-no-servidor.sh`, `esquema.py`, `inicializar.sh`, `subir-casa.sh` |
| Skill irmã | [`../replicar-mysql/SKILL.md`](../replicar-mysql/SKILL.md): a réplica do banco (etapa final) |

## Fluxo do agente

Ordem: entradas → reconhecer → DNS → modelo → copiar → construir → `casa.env` → subir → logo/favicon → Tailscale → destino da réplica → `replicar-mysql` → relatório.

1. **Reunir as entradas** (perguntar só o que faltar):
   - SSH do **servidor novo** e da **casa modelo** (`root@IP`);
   - **painel do servidor novo** (`http://IP:3000`) e o **token da API** (painel → Configurações → API). O usuário grava o token num **arquivo 600 fora do git** (ex.: `~/.easypanel/<slug>.token`) e a skill lê de lá a cada comando (`EASYPANEL_TOKEN="$(cat ARQ)"`): o shell do agente não guarda variável entre chamadas, e o token nunca vai em argumento, no git ou digitado no comando. O painel tem de ser `http://IP:3000` **do próprio servidor novo** (o `subir-casa.sh` tira o SSH do IP do `--painel`), nunca um domínio `*.easypanel.host`;
   - **nome** e **slug** da casa (minúsculas, números, hífen; é também o nome do banco e do usuário do banco);
   - **domínios com os nomes exatos dos subdomínios** (casa, backoffice, partners): as casas costumam ter `backoffice.` e `parceiros.`, mas o usuário pode ter criado `partners.`. Perguntar ou ler da Cloudflare; cadastrar sempre o `www`;
   - **admins**: quais ids do modelo ficam (normalmente `1`) e o e-mail do admin novo (a senha o usuário põe num arquivo 600; nunca no chat);
   - **branch**: Home e backoffice da `HML`; partners da `main` (como as casas no ar; confirmar com o usuário);
   - painel e token do **servidor de réplicas** (para criar o MySQL de destino), também num arquivo 600.
2. **Reconhecer (só leitura):** `ssh` no servidor novo (`hostname; nproc; free -g; df -h /; docker info`: Swarm ativo, espaço) e `projects.listProjects` com o token (responde `[]` em servidor limpo; 401 = painel errado). Conferir que o servidor do token é o servidor novo (o painel das réplicas é outro servidor).
3. **DNS (usuário, Cloudflare):** `A` para `@`, backoffice, partners → IP; `CNAME` `www` → raiz. Proxy laranja funciona (o Traefik serve o certificado). Pode propagar depois; a skill testa com `curl --resolve`.
4. **Gerar o modelo na casa modelo (só leitura):** `scp modelo/gerar-modelo.sh` e `ADMIN_IDS=1 /root/gerar-modelo.sh`. Fora de deploy e fora do pico. Conferir: "todas as N tabelas classificadas", só os admins, **zero** linha de dinheiro, jogada ou sessão. A casa modelo está no ar: nada de escrita nela.
5. **Copiar o modelo direto entre servidores:** `modelo/copiar-modelo.sh --de MODELO --para NOVO` (`--dry-run` antes; conferir a impressão digital). Nunca passar o modelo pelo Coder em disco (14 min contra 7 s).
6. **Construir as imagens no servidor novo:** `construir-no-servidor.sh --host NOVO --home origin/HML --backoffice origin/HML --partners origin/main` (~13 min; imagens e registry local `127.0.0.1:5000`). Anotar as `VERSAO_*`.
7. **Montar o `casa.env`** (arquivo 600, **fora do git**): `openssl rand` para senhas, `APP_KEY` = `base64:` + 32 bytes, `INTERNAL_API_TOKEN` = `openssl rand -hex 32`. Nunca imprimir valores. Inclui `ADMIN_IDS`, `ADMIN_EMAIL` e `ADMIN_NOME` (o admin novo) e `WWW=1` (padrão: o `www.` é cadastrado sozinho na Home). Nomes das variáveis: `deploy/casa-nova/README.md`.
8. **Subir:** `EASYPANEL_TOKEN="$(cat ARQ_TOKEN)" subir-casa.sh --env casa.env --painel http://IP:3000 [--admin-senha-arquivo ARQ] --dry-run`, mostrar ao usuário, e só então sem `--dry-run` (cobre banco/redis → importar modelo → apps → deploy → `inicializar.sh app` → `cache:clear` na Home → testes de domínio e capa). Se preferir à mão, o `reference.md` traz o roteiro equivalente. **Antes do primeiro deploy**, comparar as variáveis dos apps com uma casa no ar (`docker service inspect` na casa modelo).
9. **Usuário: logo e favicon** (backoffice → Designer → Personalização). **Sem logo a Home fica presa na tela de carregamento** (o `bet:fabrica` zera o logo). Avisar antes de dizer "no ar".
10. **Tailscale no servidor novo** (necessário para a réplica): se não houver, instalar com **OK explícito** do usuário (`curl -fsSL https://tailscale.com/install.sh | sh`; `tailscale up --hostname=<slug>` em segundo plano), entregar **só a URL de login** e esperar o "pronto". O usuário desliga o *key expiry*.
11. **Criar o MySQL de destino** no projeto `databases` do **painel de réplicas** pela API (`services.mysql.createService`, token desse painel lido do arquivo 600 por `curl -K` (arquivo de configuração 600 com o cabeçalho), nunca na linha de comando; `mysql:9`, **sem porta**, nome `<slug>-database`, banco e usuário = slug). **Nunca imprimir o corpo da resposta** (ela ecoa senhas): `-o /dev/null -w '%{http_code}'`.
12. **Réplica:** chamar a skill [`replicar-mysql`](../replicar-mysql/SKILL.md) (`ssh` → `listar` → confirmar o par → `verificar` → OK do usuário → `montar --confirmo`). Ponte `299NN` só no IP do Tailscale. **Nunca publicar a 3306.**
13. **Relatório final:** domínios e status HTTP, serviços e versões das imagens, admins, réplica (IO/SQL = Yes, atraso, `gtid_executed`), e a lista **do usuário** (logo, banners, cores, gateway, agregador, SMTP, cadastro no proxy, trocar a senha dos admins do modelo).

## Leis desta skill

- **Só casas novas.** Nunca rodar em casa com jogadores ou dinheiro. `inicializar.sh` só age com **banco vazio** e só roda o `bet:fabrica` sem dinheiro/jogadores e só com os admins esperados em `users`.
- **A casa modelo está no ar: só leitura.** O gerador não escreve nada nela.
- **Serviços nativos do EasyPanel; nada de Compose** (no Compose o painel não mostra portas nem volumes por serviço: não dá para abrir porta da réplica nem ver volume de backup). Decisão do usuário, 2026-10-27.
- **Comparar as variáveis com uma casa no ar** (`docker service inspect`) antes do primeiro deploy: sessão, fila, log, manutenção e prefixo de redis por app.
- **Nunca publicar a porta do MySQL.** A réplica usa ponte (`socat`) só no IP do Tailscale, faixa 29900–29999.
- **Nunca imprimir corpo de resposta das rotas de serviço do EasyPanel** (`createService`, `updateCredentials`…: ecoam senhas) nem qualquer segredo. Sempre `-o /dev/null -w '%{http_code}'`. Se uma senha vazar na tela, apagar o serviço novo e recriar.
- **Token da API só por variável de ambiente**, nunca por argumento (aparece na lista de processos). Chave SSH privada nunca é copiada nem mostrada; cópia entre servidores usa agente SSH temporário.
- **Comando no container de app roda como `www-data`** (`runuser -u www-data -- php artisan …` / `docker exec -u www-data`), nunca como root (cache com dono root derruba o painel em 500).
- **Mudança de dado só por migration ou pelos scripts**; nada de UPDATE solto em banco de casa.
- **O que é do usuário fica com ele:** DNS/SSL, logo e favicon, gateway, agregador, SMTP, banners e cores. A skill avisa; não inventa.
- **Dry-run antes, OK explícito antes do que mexe em servidor** (instalar Tailscale, criar destino da réplica, `montar`).
- **Parar no primeiro erro.** Casa criada pela metade: apagar o projeto no painel (e o volume do banco) e recomeçar, só se a casa for nova e vazia.
- **Cada tropeço novo** vira linha em `CORRECOES.md` pelo `/skill-update`.

## Método de execução

Segue [`../../docs/metodo-agentes.md`](../../docs/metodo-agentes.md). Registro: [`CORRECOES.md`](CORRECOES.md).

**Âncora:** em repositório de código, só `.task/subir-bet-easypanel/ANCORA.md` (modelo em `../../docs/metodo-agentes.md` §5): aponta para este `SKILL.md`, etapa atual e próximo passo. Não escrever no `AGENTS.md` do repositório.

| Etapa | Subagente | Entrega | Pronto quando | Exemplo real | Quem aprova |
|-------|-----------|---------|---------------|--------------|-------------|
| Entradas e reconhecimento | Não — Controlador | Tabela de entradas preenchida; saída do reconhecimento (sem token) | Swarm ativo no novo; token responde `[]`; domínios exatos confirmados | Los Hermanos, 2026-10-27: o primeiro painel informado era o do servidor de réplicas, não o do servidor novo (token dava 401) | Humano |
| DNS | Não — usuário | Registros criados na Cloudflare | Nomes dos subdomínios conferidos (propagação pode demorar) | Los Hermanos: usuário criou `partners.` e o padrão era `parceiros.` | Humano |
| Gerar e copiar o modelo | Sim (leve) — roda `gerar-modelo.sh` e `copiar-modelo.sh` | Saída do gerador e da cópia | "todas as N tabelas classificadas"; só admin; 0 dinheiro/jogada/sessão; modelo no novo (600) | Los Hermanos: 848 KB + 241 MB em 6,6 s | Humano |
| Construir imagens | Sim — roda `construir-no-servidor.sh` | `VERSAO_*` das 3 imagens | Imagens em `127.0.0.1:5000/space/*` | Los Hermanos: ~13 min, ~1 GB cada | Controlador |
| `casa.env` | Não — Controlador | Arquivo 600 fora do git (só nomes na conversa) | Todas as obrigatórias preenchidas; nenhum valor impresso | Los Hermanos: 15 variáveis obrigatórias | Controlador |
| Subir a casa | Sim — roda `subir-casa.sh` (dry-run, depois real) | Saída do orquestrador | 3 apps no ar; domínios 200/302; capa 200 `image/webp`; admin novo criado | Los Hermanos: 85 tabelas, 5.858 capas, casa no ar em ~10 min fora o build | Humano (OK após o dry-run) |
| Logo e favicon | Não — usuário | Logo e favicon cadastrados | Home sai do carregamento | Los Hermanos: Home presa até o logo entrar | Humano |
| Tailscale e destino da réplica | Não — Controlador (OK explícito) | URL de login entregue; destino criado sem corpo de resposta na tela | IP `100.x` no novo; destino no projeto `databases` sem porta | Los Hermanos: destino recriado após vazar senha na saída | Humano |
| Réplica | Sim — via `replicar-mysql` | Relatório do `montar` | IO/SQL = Yes; atraso 0; `gtid_executed` e contagem iguais | Los Hermanos: ponte 29901, GTID 1-324 | Humano |
| Revisão sem contexto | Sim — subagente novo | Lista de achados | Nenhum segredo na saída; estado final bate com a lista de pronto | — | Controlador |

**Revisor sem contexto:** subagente novo recebe só os relatórios (subir-casa, `montar`) e esta seção; confere item por item e procura token, senha ou `APP_KEY` na saída.

**Toda correção vira atualização da skill:** lista de correções → `/skill-update` (fluxo F) → edição genérica + `CORRECOES.md` + sync.
