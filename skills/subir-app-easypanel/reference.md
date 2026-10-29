# Referência — subir-app-easypanel

Tudo genérico: `NOVO` = servidor novo, `MODELO` = ambiente modelo, `<slug>` = slug do projeto. Os scripts e os nomes de serviço de cada produto estão em `exemplos/<produto>.md`.

## API do EasyPanel (tRPC)

- Base: `http://IP:3000/api/trpc/<rota>` (painel do servidor onde o projeto vai morar). Cabeçalho `Authorization: Bearer $EASYPANEL_TOKEN`.
- **Mutação = POST** com corpo `{"json":{...}}`. **Consulta = GET** com `?input=<json url-encoded>` (também no formato `{"json":...}`).
- Token da API: painel → Settings/Configurações → Users → token da API. Passar por variável de ambiente e arquivo de configuração do `curl` (`-K`), nunca na linha de comando.
- **Segurança de resposta:** rotas de serviço (`services.mysql.createService`, `updateCredentials`, etc.) **ecoam senhas** na resposta e nos erros. Sempre `curl -sS -o /dev/null -w '%{http_code}'`; só ler o corpo de rotas de consulta sem segredo (`projects.listProjects`, `domains.listDomains`).

| Rota | Uso |
|------|-----|
| `projects.listProjects` (GET) | Teste do token: `[]` em servidor limpo; 401 = painel errado |
| `projects.createProject` `{name}` | Projeto `<slug>` |
| `templates.createFromSchema` | Cria vários serviços de uma vez; formato dos modelos do EasyPanel: `{"projectName":…, "schema": {"services":[{"type":"mysql"\|"redis"\|"app","data":{…}}]}}`. Só **cria**: app precisa de deploy. O `schema` pode ir como objeto ou texto (ver o orquestrador do produto) |
| `services.app.deployService` `{projectName, serviceName}` | Sobe o app (sempre faz *pull* da imagem) |
| `services.app.updateSourceImage` `{projectName, serviceName, image}` | Troca a imagem (`127.0.0.1:5000/space/<repo>:<versão>`); usado também para atualizar/voltar versão |
| `services.mysql.createService` | Cria MySQL avulso (destino da réplica no painel de réplicas): `mysql:9`, sem porta. **Resposta com senha** |
| `services.mysql.exposeService {exposedPort}` | Publica/fecha porta (`0` = fecha). **Não usar na 3306** |
| `domains.listDomains` / `domains.createDomain` / `domains.updateDomain` | Domínios do serviço; `www` no app principal. O `createDomain` exige **`id`** (texto único, ex.: `"c"` + 24 hex) além de `host`, `https:true`, `path:"/"`, `wildcard:false`, `middlewares:[]`, `certificateResolver:""`, `destinationType:"service"` e `serviceDestination {projectName, serviceName, port:80, path:"/", protocol:"http"}`. Para copiar o formato, extrair (script/`jq`) os campos de um domínio que já existe com `listDomains`, sem imprimir o corpo inteiro |
| `services.app.inspectService` (GET) | Configuração do app (origem, build, `env`, montagens). **A resposta tem a ENV com segredos:** ler só os campos necessários num script, nunca imprimir o corpo |
| `services.app.updateEnv` `{projectName, serviceName, env}` | Grava a ENV inteira (texto `CHAVE=valor` por linha): ler a atual pelo `inspectService`, guardar backup 600, acrescentar/trocar só o necessário e mandar o texto completo. O corpo leva a ENV inteira: montar num script ou arquivo 600, nunca na linha de comando, e ler só o código HTTP. Vale no próximo deploy |
| `mounts.listMounts` (GET) / `mounts.createMount` `{projectName, serviceName, values:{type, hostPath, mountPath}}` | Montagens do app (`type:"bind"` com `hostPath`, ou `"volume"` com `name`); extrair só os campos, nunca imprimir o corpo. Não existe `services.app.updateMounts` (404). Vale no próximo deploy |

Tipos do `createFromSchema`:
- `mysql`: `mysql:9.7.4` (GTID ligado por padrão; `easypanel.cnf` vazio como os projetos no ar), `serviceName=<slug>-database`, banco e usuário = slug, volume visível no painel, **sem porta**.
- `redis`: `<slug>-redis`, senha própria.
- `app`: `source.image=127.0.0.1:5000/<imagem>:<versão>`, `env` em texto, `domains`, `mounts` (volumes e *binds* de cada produto: ver o exemplo).

Dois esquemas, nesta ordem: **banco + redis** → importar o modelo → **apps**. Se o entrypoint dos apps roda migrations ao subir, num banco vazio criaria tabelas vazias.

## Tropeços conhecidos

| Sintoma | Causa | Correção |
|---------|-------|----------|
| `pull access denied for space/<repo>` no deploy | EasyPanel sempre faz pull; imagem só local | Registry local `127.0.0.1:5000`, `docker push`, `updateSourceImage` |
| App criado e parado | `createFromSchema` não sobe | `deployService` de cada um |
| 500 em todos os apps (tabela de sessão não existe) | Falta a variável de sessão/fila/cache de um serviço no ar | Comparar variáveis com um serviço no ar (`docker service inspect --format '{{json .Spec.TaskTemplate.ContainerSpec.Env}}'`, sem colar valores secretos na conversa) |
| 404 em um subdomínio | Nome diferente do criado no DNS | Perguntar os nomes exatos; `domains.updateDomain`; atualizar as variáveis que citam o domínio e redeploy |
| App abre e fica carregando | O produto trava sem um cadastro (ex.: logo) | Ver o exemplo do produto |
| App principal sem `www` | Domínio não cadastrado | `domains.createDomain` para `www.<domínio>` |
| Segunda execução do init não faz nada | Trava de segurança (banco com tabelas / `concluido`) | Esperado; projeto novo pela metade: apagar projeto e volume e recomeçar |
| Container de app com cache de dono root → 500 | Comando como root | Sempre o usuário do serviço web (`www-data` em PHP) |
| Senha na tela após `createService` | Resposta ecoa a senha | Apagar o serviço novo e recriar imprimindo só o HTTP |
| Arquivo 600 copiado para o container ilegível pelo usuário do serviço | Dono root | Passar a senha pela entrada padrão (ou `chmod 644` dentro do container) |
| Cópia do modelo lenta | Passava pela máquina do agente | Cópia direta entre servidores, pelo script do produto (ver o exemplo) |
| Painel errado | O painel das réplicas é outro servidor | O token da API é do painel do servidor novo |
| `createDomain` → 400 `id Required` | O corpo não tinha `id` | Mandar `id` único e o formato completo (ver a tabela da API) |
| `services.app.updateMounts` → 404 | A rota não existe | `mounts.createMount` com `values` |
| App serve a página do site no lugar de um arquivo do volume (200 `text/html`) | O app que serve o arquivo não monta a pasta que outro app grava | Montar a mesma pasta nos dois (`mounts.createMount`, de preferência só a subpasta compartilhada, para não esconder arquivos que vêm na imagem) e fazer o deploy |
| `listProjects` não volta `[]` | O servidor já hospeda outro projeto | Confirmar com o usuário projeto separado e slug único; reaproveitar Tailscale, registry e modelo; nunca tocar nos outros projetos |
| `verificar` da réplica: FALHA "o destino já tem tabelas" | O destino `<slug>-database` já existia com dados de outra origem (ex.: teste antigo); não é réplica, então `--refazer` não vale | Investigar só lendo e perguntar; só com OK explícito no chat (descartável): dump em `<base>/backups/` (600), conferir o dump, `DROP DATABASE`, `verificar`, `montar` |

## Roteiro manual equivalente aos scripts

Os nomes dos scripts e das variáveis estão em `exemplos/<produto>.md`.

1. **Reconhecer:** `ssh root@NOVO 'hostname; nproc; free -g; df -h /; docker info'`; `GET projects.listProjects`.
2. **Modelo:** rodar o gerador no `MODELO` (só leitura) e conferir o relatório.
3. **Copiar:** direto `MODELO` → `NOVO` por `tar` sobre `ssh -A` com `ssh-agent` temporário encerrado no fim.
4. **Imagens:** `git archive` → `docker build` no servidor → `docker push` no registry local `127.0.0.1:5000`.
5. **Arquivo de variáveis** (600, fora do git).
6. **Projeto:** `projects.createProject {name:"<slug>"}`.
7. **Banco e redis:** esquema só com a parte do banco → `templates.createFromSchema` (arquivo 600; só código HTTP). Esperar `<slug>-database` Up.
8. **Importar o modelo** no servidor, só com 0 tabelas (converte MyISAM → InnoDB, se for o caso).
9. **Apps:** esquema com a parte dos apps → `createFromSchema` → `deployService` de cada um; esperar os containers.
10. **Inicialização dos apps** (script do produto; senha do admin pela entrada padrão); limpar o cache de **todos** os apps que têm prefixo de redis próprio.
11. **Conferir:** `curl -I` nos domínios e numa imagem do produto; sem DNS ainda, `curl --resolve dominio:443:IP`.
12. **Identidade visual** (usuário). **Tailscale** no novo (OK explícito). **Destino da réplica** no projeto `databases` do painel de réplicas (`mysql:9`, sem porta; resposta nunca impressa). **`replicar-mysql`**.

## Atualizar um projeto já no ar

O script de build do produto (só constrói o que mudou), depois `updateSourceImage` + `deployService` por app. Voltar atrás: `updateSourceImage` com a versão antiga (fica no registry local); migration aplicada não volta sozinha.

### Projeto antigo (subido por *upload* de código ou por git no EasyPanel)

Atualizar é mexer num projeto com usuários e dinheiro: **só código, ENV, montagens, serviços de apoio e arquivos de volume; nunca dado do banco à mão** (o banco muda só pelas migrations do código, listadas no plano). Plano e OK explícito do usuário antes de qualquer escrita; uma casa (projeto) por vez.

1. **Reconhecer só lendo:** `docker service ls`, `inspectService` de cada app (só `source`, `build`, `mounts`; nunca imprimir a ENV), data da imagem no ar (`docker image inspect … .Created`). Imagem recente avisa que alguém subiu algo: perguntar antes de trocar.
2. **Build no servidor + registry local** (script do produto). Se um app vem de um fork ou outra pasta, apontar o script para ela (ex.: pasta temporária com links simbólicos para os clones), nunca mexer nas pastas principais.
3. **Migrations no plano:** antes do deploy, listar só lendo as migrations que o código novo traz e o banco ainda não tem (arquivos de migration da versão nova × tabela de migrations do banco). Entram no plano que o usuário aprova; se alguma apaga coluna/tabela ou muda dado, parar e pedir OK à parte (e backup do banco, se o produto tiver).
4. **Guardar para voltar atrás:** a imagem no ar vai para o registry local (`docker tag` + `push`, ex.: `antes-<app>:<data>`); a ENV atual vai para um backup 600 fora do git.
5. **Conferir a ENV** com a de um projeto novo e com as variáveis que o código lê (`env('…')` em `config/` e `app/`): listar só os **nomes**; valor só de uma lista curta e explícita sem segredo (`APP_ENV`, `APP_URL`, `ASSET_URL`, `*_DRIVER`, `*_STORE`, `*_HOST`, `APP_TIMEZONE`, `MAIL_MAILER`), o resto oculto; acrescentar o que falta, sem tocar nas outras. Avisar o que parece errado mas é decisão do usuário (nome do app, mailer de log…).
6. **Serviços de apoio que faltam** (ex.: Redis) entram por `createFromSchema` no projeto que já existe, sem porta. Troca de driver de sessão desloga todo mundo uma vez: avisar antes.
7. **Arquivos de volume** (ex.: imagens de catálogo) só com OK explícito: cópia direta entre servidores, `rsync -a --ignore-existing` (nunca sobrescreve nem apaga), dono do usuário do serviço (`www-data`); comandos do app que gravam (importadores) como esse usuário, com `--dry-run` antes.
8. **Deploy na ordem do produto** (ver o exemplo), um app por vez: `updateEnv` → `updateSourceImage` (a origem passa de *upload*/git para imagem e não volta a ser *upload*: dizer isso no plano) → `deployService` → esperar a task nova → conferir domínio, drivers (`artisan about` em Laravel), migrations pendentes e log.
9. **Conferir no fim:** domínios (inclusive `www`, que pode nunca ter sido cadastrado), arquivos servidos pelos apps que leem volume de outro app, e os outros projetos do servidor intactos.
10. **Voltar atrás, se precisar:** `updateSourceImage` para `antes-<app>:<data>` e `updateEnv` com o backup 600, depois `deployService`; montagem criada sai pelo painel; serviço de apoio novo pode ficar (sem uso). **Não voltam:** migration aplicada e a sessão que caiu na troca de driver.
