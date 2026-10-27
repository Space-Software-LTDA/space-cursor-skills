# Referência — subir-bet-easypanel

Tudo genérico: `NOVO` = servidor novo, `MODELO` = casa modelo, `<slug>` = slug da casa. Os scripts ficam em `space-spacesoft-bet/deploy/casa-nova/`.

## API do EasyPanel (tRPC)

- Base: `http://IP:3000/api/trpc/<rota>` (painel do servidor onde a casa vai morar). Cabeçalho `Authorization: Bearer $EASYPANEL_TOKEN`.
- **Mutação = POST** com corpo `{"json":{...}}`. **Consulta = GET** com `?input=<json url-encoded>` (também no formato `{"json":...}`).
- Token da API: painel → Configurações → API. Passar por variável de ambiente e arquivo de configuração do `curl` (`-K`), nunca na linha de comando.
- **Segurança de resposta:** rotas de serviço (`services.mysql.createService`, `updateCredentials`, etc.) **ecoam senhas** na resposta e nos erros. Sempre `curl -sS -o /dev/null -w '%{http_code}'`; só ler o corpo de rotas de consulta sem segredo (`projects.listProjects`, `domains.listDomains`).

| Rota | Uso |
|------|-----|
| `projects.listProjects` (GET) | Teste do token: `[]` em servidor limpo; 401 = painel errado |
| `projects.createProject` `{name}` | Projeto `<slug>` |
| `templates.createFromSchema` | Cria vários serviços de uma vez; formato dos modelos do EasyPanel: `{"projectName":…, "schema": {"services":[{"type":"mysql"\|"redis"\|"app","data":{…}}]}}`. Só **cria**: app precisa de deploy. O `schema` pode ir como objeto ou texto (`SCHEMA_FORMATO` do `subir-casa.sh`) |
| `services.app.deployService` `{projectName, serviceName}` | Sobe o app (sempre faz *pull* da imagem) |
| `services.app.updateSourceImage` `{projectName, serviceName, image}` | Troca a imagem (`127.0.0.1:5000/space/<repo>:<versão>`); usado também para atualizar/voltar versão |
| `services.mysql.createService` | Cria MySQL avulso (destino da réplica no painel de réplicas): `mysql:9`, sem porta. **Resposta com senha** |
| `services.mysql.exposeService {exposedPort}` | Publica/fecha porta (`0` = fecha). **Não usar na 3306** |
| `domains.listDomains` / `domains.createDomain` / `domains.updateDomain` | Domínios do serviço: `{host, https:true, port:80, path:"/"}`; `www` na Home |

Tipos do `createFromSchema`:
- `mysql`: `mysql:9.7.4` (GTID ligado por padrão; `easypanel.cnf` vazio como as casas no ar), `serviceName=<slug>-database`, banco e usuário = slug, volume visível no painel, **sem porta**.
- `redis`: `<slug>-redis`, senha própria.
- `app`: `source.image=127.0.0.1:5000/space/<repo>:<versão>`, `env` em texto, `domains`, `mounts`. O backoffice leva volume `images` em `public/images`; a Home leva *bind* na **mesma pasta** (`/etc/easypanel/projects/<slug>/<slug>-backoffice/volumes/images`, mesmo inode).

Dois esquemas, nesta ordem: **banco + redis** → importar o modelo → **apps**. O entrypoint da Home e do backoffice roda as migrations ao subir; num banco vazio criaria tabelas vazias.

## Tropeços conhecidos

| Sintoma | Causa | Correção |
|---------|-------|----------|
| `pull access denied for space/<repo>` no deploy | EasyPanel sempre faz pull; imagem só local | Registry local `127.0.0.1:5000`, `docker push`, `updateSourceImage` |
| App criado e parado | `createFromSchema` não sobe | `deployService` de cada um |
| 500 em todos os apps (`sessions` não existe) | Falta `SESSION_DRIVER=redis` etc. | Comparar variáveis com casa no ar (`docker service inspect --format '{{json .Spec.TaskTemplate.ContainerSpec.Env}}'`, sem colar valores secretos na conversa) |
| Partners 404 | Subdomínio diferente do criado no DNS | Perguntar os nomes exatos; `domains.updateDomain`; atualizar a variável `PARTNERS_*` e redeploy |
| Home não abre / carrega para sempre | Sem logo (`global.logo`) | Cadastrar logo e favicon no backoffice |
| Home sem `www` | Domínio não cadastrado | `domains.createDomain` para `www.<domínio>` (ou `WWW=1` no `casa.env`) |
| Segunda execução do init não faz nada | Trava de segurança (banco com tabelas / `concluido`) | Esperado; casa nova pela metade: apagar projeto e volume e recomeçar |
| Container de app com cache de dono root → 500 | Comando como root | Sempre `www-data` |
| Senha na tela após `createService` | Resposta ecoa a senha | Apagar o serviço novo e recriar imprimindo só o HTTP |
| `docker cp` de arquivo 600 ilegível pelo `www-data` | Dono root | `chmod 644` dentro do container, ou entrada padrão |
| Cópia do modelo lenta | Passava pelo Coder | `copiar-modelo.sh` (direto) |
| Painel errado | O painel das réplicas é outro servidor | O token da API é do painel do servidor novo |

## Roteiro manual equivalente aos scripts

1. **Reconhecer:** `ssh root@NOVO 'hostname; nproc; free -g; df -h /; docker info'`; `GET projects.listProjects`.
2. **Modelo:** `scp modelo/gerar-modelo.sh root@MODELO:/root/` e `ssh root@MODELO 'ADMIN_IDS=1 /root/gerar-modelo.sh'` → `/srv/space/modelo/` (`modelo.sql.gz` + `images/`).
3. **Copiar:** `modelo/copiar-modelo.sh --de root@MODELO --para root@NOVO` (equivale a `ssh -A MODELO 'tar -C /srv/space -cf - modelo | ssh NOVO "tar -C /srv/space -xpf -"'` com `ssh-agent` temporário encerrado no fim).
4. **Imagens:** `construir-no-servidor.sh --host root@NOVO --home origin/HML --backoffice origin/HML --partners origin/main` (git archive → docker build no servidor → push no registry local → envia `inicializar.sh` para `/srv/space/`).
5. **`casa.env`** (600, fora do git): ver variáveis no `README.md` do `deploy/casa-nova/`.
6. **Projeto:** `projects.createProject {name:"<slug>"}`.
7. **Banco e redis:** `esquema.py --env casa.env --parte banco` → `templates.createFromSchema` (arquivo 600; só código HTTP). Esperar `<slug>-database` Up.
8. **Importar:** no servidor, `/srv/space/inicializar.sh banco <slug>` (só com 0 tabelas; converte MyISAM → InnoDB).
9. **Apps:** `esquema.py --parte apps` → `createFromSchema` → `deployService` ×3; esperar os containers.
10. **Init do app:** `ADMIN_IDS=1 CASA_NOME=… CASA_DOMINIO=… ADMIN_EMAIL=… /srv/space/inicializar.sh app <slug>` (senha do admin pela entrada padrão); depois `cache:clear` **na Home também** (prefixo de redis próprio).
11. **Conferir:** `curl -I` nos domínios (casa 200, `www` 200, backoffice 302 → `/admin`, partners 200) e numa capa (200 `image/webp`); sem DNS ainda, `curl --resolve dominio:443:IP`.
12. **Logo e favicon** (usuário). **Tailscale** no novo (OK explícito). **Destino da réplica** no projeto `databases` do painel de réplicas (`mysql:9`, sem porta; resposta nunca impressa). **`replicar-mysql`**.

## Atualizar uma casa já no ar

`construir-no-servidor.sh --host root@IP` (só constrói o que mudou), depois `updateSourceImage` + `deployService` por app. Voltar atrás: `updateSourceImage` com a versão antiga (fica no registry local); migration aplicada não volta sozinha.
