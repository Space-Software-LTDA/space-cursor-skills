---
name: subir-app-easypanel
description: >-
  Sobe um app, casa ou projeto novo num servidor com EasyPanel, de ponta a ponta
  e com serviços nativos: reconhece o servidor, prepara o modelo de dados,
  constrói as imagens no próprio servidor, cria banco, redis e apps pela API do
  EasyPanel, inicializa o projeto, confere os domínios, instala o Tailscale e
  monta a réplica do MySQL pela skill replicar-mysql. Os passos que dependem do
  produto estão em exemplos/<produto>.md. Use com /subir-app-easypanel,
  "subir app no EasyPanel", "subir casa", "subir projeto no EasyPanel",
  "servidor novo".
disable-model-invocation: true
---

# Subir app no EasyPanel

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta máquina** (PC ≠ Coders).
> **Altere em** `space-cursor-skills/skills/subir-app-easypanel/` → **obrigatório rodar** `npm run sync` na raiz (máquina alvo).
> Ver `00-COPIA-LEIA-ME.md`. Hub do pack: **`/skill-update`**. Fluxo do repo: **`AGENTS.md`**.
> **Use sempre o clone atualizado do pacote**: a cópia sincronizada pode estar velha (no primeiro uso a cópia da `replicar-mysql` estava sem 13 correções).

**Trigger:** `/subir-app-easypanel` · **Sempre responder em português.**

## Papel

Subir **um projeto novo** (nunca mexer em um existente) num servidor novo com EasyPanel, com serviços **nativos** (`<slug>-database`, `<slug>-redis`, um serviço por app, no projeto `<slug>`), iguais aos dos projetos já no ar, e deixar a réplica do banco montada. O agente conduz; o usuário faz só o que é dele (DNS, identidade visual, Tailscale se não houver OK, integrações externas).

**Primeiro passo: perguntar qual produto é** e ler `exemplos/<produto>.md`. O que depende do produto (modelo de dados, scripts, apps, branches, inicialização, o que o usuário cadastra) mora lá; esta skill traz só o roteiro comum. Produto sem exemplo: levantar com o usuário, executar e registrar o exemplo novo pelo `/skill-update`.

**A skill não carrega os scripts de produto: usa os do repo do produto** (caminhos no exemplo). A skill é o roteiro, as leis e a memória dos tropeços; o código evolui com o produto.

Conteúdo **genérico**: nenhum IP, token ou senha real; nada de um produto fora de `exemplos/`.

## Arquivos

| Arquivo | Para quê |
|---------|----------|
| [`reference.md`](reference.md) | API do EasyPanel (tRPC), tropeços conhecidos com a correção, roteiro manual |
| [`CORRECOES.md`](CORRECOES.md) | Registro das correções do primeiro uso |
| [`exemplos/`](exemplos/) | Um arquivo por produto: scripts, apps, branches e caso real |
| Skill irmã | [`../replicar-mysql/SKILL.md`](../replicar-mysql/SKILL.md): a réplica do banco (etapa final) |

## Fluxo do agente

Ordem: entradas → reconhecer → DNS → modelo → copiar → construir → variáveis → subir → identidade visual → Tailscale → destino da réplica → `replicar-mysql` → relatório.

1. **Reunir as entradas** (perguntar só o que faltar):
   - o **produto** (para ler o exemplo) e o SSH do **servidor novo** e do **ambiente modelo** (`root@IP`), se o produto usa modelo;
   - **painel do servidor novo** (`http://IP:3000`) e o **token da API** (painel → Settings/Configurações → Users → token da API). O usuário grava o token num **arquivo 600 fora do git** (ex.: `~/.easypanel/<slug>.token`) e a skill lê de lá a cada comando (`EASYPANEL_TOKEN="$(cat ARQ)"`): o shell do agente não guarda variável entre chamadas, e o token nunca vai em argumento, no git ou digitado no comando. O painel tem de ser `http://IP:3000` **do próprio servidor novo**, nunca um domínio `*.easypanel.host`;
   - **nome** e **slug** (minúsculas, números, hífen; é também o nome do banco e do usuário do banco);
   - **domínios com os nomes exatos dos subdomínios**: perguntar ou ler da Cloudflare, nunca presumir o padrão; cadastrar sempre o `www`;
   - **admins**: quais ficam e o e-mail do admin novo (a senha o usuário põe num arquivo 600; nunca no chat);
   - **branch/versão** de cada app (ver o exemplo; confirmar com o usuário);
   - painel e token do **servidor de réplicas** (para criar o MySQL de destino), também num arquivo 600.
2. **Reconhecer (só leitura):** `ssh` no servidor novo (`hostname; nproc; free -g; df -h /; docker info`: Swarm ativo, espaço) e `projects.listProjects` com o token (responde `[]` em servidor limpo; 401 = painel errado). Conferir que o servidor do token é o servidor novo (o painel das réplicas é outro servidor).
3. **DNS (usuário, Cloudflare):** `A` para a raiz e cada subdomínio → IP; `CNAME` `www` → raiz. Proxy laranja funciona (o Traefik serve o certificado). Pode propagar depois; a skill testa com `curl --resolve`.
4. **Gerar o modelo no ambiente modelo (só leitura):** ver o exemplo do produto. Fora de deploy e fora do pico; o ambiente modelo está no ar: nada de escrita nele. Conferir o relatório do gerador (tudo classificado, nenhum dado de usuário final ou dinheiro).
5. **Copiar o modelo direto entre servidores** (dry-run antes; conferir a impressão digital). Nunca passar o modelo pela máquina do agente em disco (14 min contra 7 s).
6. **Construir as imagens no servidor novo** (build no servidor e registry local `127.0.0.1:5000`; **sem GitHub no servidor**, o código vai por `git archive`). Anotar as versões das imagens.
7. **Montar o arquivo de variáveis** (arquivo 600, **fora do git**): `openssl rand` para senhas e chaves. Nunca imprimir valores. Nomes das variáveis: README do produto.
8. **Subir:** orquestrador do produto com `EASYPANEL_TOKEN="$(cat ARQ_TOKEN)"`, primeiro em `--dry-run`, mostrar ao usuário, e só então de verdade. Cobre: banco/redis (`createFromSchema`) → importar modelo → apps → deploy → inicialização → testes de domínio. Se preferir à mão, o `reference.md` traz o roteiro equivalente. **Antes do primeiro deploy**, comparar as variáveis dos apps com um serviço já no ar (`docker service inspect`).
9. **Usuário: identidade visual e cadastros do produto** (ver o exemplo; alguns produtos travam a abertura sem isso). Avisar antes de dizer "no ar".
10. **Tailscale no servidor novo** (necessário para a réplica): se não houver, instalar com **OK explícito** do usuário (`curl -fsSL https://tailscale.com/install.sh | sh`; `tailscale up --hostname=<slug>` em segundo plano), entregar **só a URL de login** e esperar o "pronto". O usuário desliga o *key expiry*.
11. **Criar o MySQL de destino** no projeto `databases` do **painel de réplicas** pela API (`services.mysql.createService`, token desse painel lido do arquivo 600 por `curl -K`, nunca na linha de comando; `mysql:9`, **sem porta**, nome `<slug>-database`, banco e usuário = slug). **Nunca imprimir o corpo da resposta** (ela ecoa senhas): `-o /dev/null -w '%{http_code}'`.
12. **Réplica:** chamar a skill [`replicar-mysql`](../replicar-mysql/SKILL.md) (`ssh` → `listar` → confirmar o par → `verificar` → OK do usuário → `montar --confirmo`). Ponte `299NN` só no IP do Tailscale. **Nunca publicar a 3306.**
13. **Relatório final:** domínios e status HTTP, serviços e versões das imagens, admins, réplica (IO/SQL = Yes, atraso, `gtid_executed`), e a lista **do usuário** (ver o exemplo).

## Leis desta skill

- **Só projetos novos.** Nunca rodar em projeto com usuários ou dinheiro. A inicialização do produto só age com **banco vazio** (importa o modelo, roda migrations, limpa a cópia, cria o admin) e recusa rodar de novo.
- **O ambiente modelo está no ar: só leitura.**
- **Serviços nativos do EasyPanel, criados por esquema (`createFromSchema`); nada de Compose** (no Compose o painel não mostra portas nem volumes por serviço: não dá para abrir porta da réplica nem ver volume de backup). Decisão do usuário, 2026-10-27.
- **Build no servidor novo + registry local `127.0.0.1:5000`;** sem GitHub no servidor (o EasyPanel sempre faz *pull* no deploy).
- **Comparar as variáveis com um serviço no ar** (`docker service inspect`) antes do primeiro deploy: sessão, fila, log, manutenção e prefixo de redis por app.
- **Nunca publicar a porta do MySQL.** A réplica usa ponte (`socat`) só no IP do Tailscale, faixa 29900–29999.
- **Nunca imprimir corpo de resposta das rotas de serviço do EasyPanel** (`createService`, `updateCredentials`…: ecoam senhas) nem qualquer segredo. Sempre `-o /dev/null -w '%{http_code}'`. Se uma senha vazar na tela, apagar o serviço novo e recriar.
- **Token da API só por variável de ambiente ou arquivo 600**, nunca por argumento (aparece na lista de processos). Chave SSH privada nunca é copiada nem mostrada; cópia entre servidores usa agente SSH temporário.
- **Comando no container de app roda como usuário do serviço web (`www-data` em PHP)**, nunca como root (cache com dono root derruba o painel em 500).
- **Mudança de dado só por migration ou pelos scripts**; nada de UPDATE solto em banco.
- **O que é do usuário fica com ele:** DNS/SSL, identidade visual, integrações externas. A skill avisa; não inventa.
- **Dry-run antes, OK explícito antes do que mexe em servidor** (instalar Tailscale, criar destino da réplica, `montar`).
- **Parar no primeiro erro.** Projeto criado pela metade: apagar o projeto no painel (e o volume do banco) e recomeçar, só se for novo e vazio.
- **Cada tropeço novo** vira linha em `CORRECOES.md` pelo `/skill-update`.

## Método de execução

Segue [`../../docs/metodo-agentes.md`](../../docs/metodo-agentes.md). Registro: [`CORRECOES.md`](CORRECOES.md).

**Âncora:** em repositório de código, só `.task/subir-app-easypanel/ANCORA.md` (modelo em `../../docs/metodo-agentes.md` §5): aponta para este `SKILL.md`, o produto/exemplo, etapa atual e próximo passo. Não escrever no `AGENTS.md` do repositório.

Exemplo real de cada etapa: [`exemplos/bet.md`](exemplos/bet.md) (caso Los Hermanos, 2026-10-27).

| Etapa | Subagente | Entrega | Pronto quando | Exemplo real | Quem aprova |
|-------|-----------|---------|---------------|--------------|-------------|
| Entradas e reconhecimento | Não — Controlador | Tabela de entradas preenchida; saída do reconhecimento (sem token) | Swarm ativo no novo; token responde `[]`; domínios exatos confirmados | `exemplos/bet.md` | Humano |
| DNS | Não — usuário | Registros criados na Cloudflare | Nomes dos subdomínios conferidos (propagação pode demorar) | `exemplos/bet.md` | Humano |
| Gerar e copiar o modelo | Sim (leve) — roda os scripts do produto | Saída do gerador e da cópia | Tudo classificado; só admin; nenhum dado de usuário final (ver o exemplo do produto); modelo no novo (600) | `exemplos/bet.md` | Humano |
| Construir imagens | Sim — roda o script de build do produto | Versões das imagens | Imagens em `127.0.0.1:5000/*` | `exemplos/bet.md` | Controlador |
| Arquivo de variáveis | Não — Controlador | Arquivo 600 fora do git (só nomes na conversa) | Obrigatórias preenchidas; nenhum valor impresso | `exemplos/bet.md` | Controlador |
| Subir o projeto | Sim — roda o orquestrador (dry-run, depois real) | Saída do orquestrador | Apps no ar; domínios 200/302; admin novo criado | `exemplos/bet.md` | Humano (OK após o dry-run) |
| Identidade visual | Não — usuário | Cadastros exigidos pelo produto | Produto abre normalmente | `exemplos/bet.md` | Humano |
| Tailscale e destino da réplica | Não — Controlador (OK explícito) | URL de login entregue; destino criado sem corpo de resposta na tela | IP `100.x` no novo; destino no projeto `databases` sem porta | `exemplos/bet.md` | Humano |
| Réplica | Sim — via `replicar-mysql` | Relatório do `montar` | IO/SQL = Yes; atraso 0; `gtid_executed` e contagem iguais | `exemplos/bet.md` | Humano |
| Revisão sem contexto | Sim — subagente novo | Lista de achados | Nenhum segredo na saída; estado final bate com a lista de pronto | — | Controlador |

**Revisor sem contexto:** subagente novo recebe só os relatórios (orquestrador, `montar`) e esta seção; confere item por item e procura token, senha ou chave de aplicação na saída.

**Toda correção vira atualização da skill:** lista de correções → `/skill-update` (fluxo F) → edição genérica + `CORRECOES.md` + sync.
