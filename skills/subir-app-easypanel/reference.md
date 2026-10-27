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
| `domains.listDomains` / `domains.createDomain` / `domains.updateDomain` | Domínios do serviço: `{host, https:true, port:80, path:"/"}`; `www` no app principal |

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
