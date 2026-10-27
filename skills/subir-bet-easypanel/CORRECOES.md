# Correções — subir-bet-easypanel

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F). Sem dado de cliente: descrever o padrão.
> Mais recente em cima. Origem: primeiro uso real (casa Los Hermanos, 2026-10-27).

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde |
|------|--------------------|-------|---------------------|------|
| 2026-10-27 | Réplica: porta 3306 da origem publicada por minutos em `0.0.0.0` | Seguiu-se a cópia antiga (25/10) da `replicar-mysql`, que listava "porta 3306 publicada no serviço de origem" como pré-requisito | Nunca publicar a 3306; usar o clone atualizado, que cria ponte `socat` só no Tailscale. Desfeito com `exposeService {exposedPort:0}` e conferido com `ss -ltn` | SKILL.md (leis, etapa 12) |
| 2026-10-27 | Senhas do MySQL apareceram na tela | A resposta do `services.mysql.createService` e o erro do `updateCredentials` ecoam as senhas | Nunca imprimir corpo de resposta das rotas de serviço; só código HTTP. Serviço vazado foi apagado e recriado | SKILL.md (leis), reference.md |
| 2026-10-27 | Home presa na tela de carregamento | `LoadingScreen` só some com `global.logo`; o `bet:fabrica` zera o logo | Logo e favicon são passo obrigatório logo após o deploy; avisar antes de dizer "no ar" | SKILL.md (etapa 9) |
| 2026-10-27 | Domínio do partners deu 404 | O usuário criou `partners.`; o padrão usado foi `parceiros.` | Perguntar os nomes exatos dos subdomínios (ou ler a Cloudflare) antes de criar; sempre cadastrar o `www` | SKILL.md (etapa 1) |
| 2026-10-27 | Home, backoffice e partners em 500 (`sessions` não existe) | A primeira tentativa não passava `SESSION_DRIVER=redis` e afins | Comparar variáveis com uma casa no ar (`docker service inspect`): `SESSION_*`, `QUEUE_CONNECTION=sync`, `LOG_LEVEL=warning`, `APP_MAINTENANCE_DRIVER=file`, `REDIS_PREFIX` por app | SKILL.md (leis), esquema.py |
| 2026-10-27 | `services.app.deployService` falhou com `pull access denied` | O EasyPanel faz *pull* em todo deploy de app; imagem só local não serve | Registry local `127.0.0.1:5000` (`registry:2`); `docker push` e `updateSourceImage` | `construir-no-servidor.sh` |
| 2026-10-27 | Apps criados por `createFromSchema` não subiram | A rota só cria | `deployService` de cada app depois | `subir-casa.sh` |
| 2026-10-27 | Serviço Compose descartado (não usar) | O usuário não conseguia abrir porta do MySQL nem ver volumes no painel | Serviços nativos (`mysql`, `redis`, `app` no `createFromSchema`) | SKILL.md (leis), README do deploy |
| 2026-10-27 | Admin novo não era criado pelo init | O serviço do botão "Criar administrador" exige SuperAdmin logado; `docker cp` de arquivo 600 não era legível pelo `www-data` | `inicializar.sh app` cria o admin (`ADMIN_EMAIL`) rodando como `www-data` com `auth()->setUser(<admin 1>)`; senha pela entrada padrão | `inicializar.sh` |
| 2026-10-27 | Cópia do modelo passou de 14 min | Os 241 MB passavam pelo Coder | Cópia direta entre servidores por agente SSH encaminhado temporário: 6,6 s | `copiar-modelo.sh` |
| 2026-10-27 | Senha do root do MySQL visível na lista de processos do container | `mysql -p"$SENHA"` no gerador | Usar `MYSQL_PWD` via `docker exec -e` | `gerar-modelo.sh` |
| 2026-10-27 | Skill `replicar-mysql` da máquina estava velha (25/10, sem 13 correções, sem permissão de execução) | Cópia sincronizada não atualizada | Usar o clone atualizado do pacote ou `npm run sync` antes | SKILL.md (cabeçalho) |

## Pendências (sugestões do primeiro uso, ainda não feitas)
- `inicializar.sh app` receber `CASA_LOGO_URL`/`CASA_FAVICON_URL` e cadastrar o logo, para a Home não travar na primeira abertura.
- Home do bet: não travar a tela de carregamento quando não há logo (mostrar o nome da casa).
- `replicar-mysql`: criar o MySQL de destino sozinha quando não existir (pedindo o token do painel de destino), em vez de parar no "SEM PAR".
- Primeira rodada completa do `subir-casa.sh` de ponta a ponta (na Los Hermanos os passos foram feitos um a um).
