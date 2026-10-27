---
name: replicar-mysql
description: >-
  Monta e confere uma réplica MySQL (origem -> destino) entre dois servidores com
  Docker/EasyPanel, por GTID, de forma automática: acessa os servidores, lista as
  casas, verifica a origem, o destino e a rede, pede o OK do usuário, faz dump,
  import e liga a replicação, e confere os dados. Use com /replicar-mysql,
  "replicar mysql", "criar réplica", "réplica do banco", "montar replicação" ou
  "status da réplica".
disable-model-invocation: true
---

# Replicar MySQL

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta máquina** (PC ≠ Coders).
> **Altere em** `space-cursor-skills/skills/replicar-mysql/` → **obrigatório rodar** `npm run sync` na raiz (máquina alvo).
> **Cópia velha?** Rode pelo clone atualizado (`git pull` e `bash <clone>/skills/replicar-mysql/scripts/replicar-mysql.sh`) ou `npm run sync` antes.
> Ver `00-COPIA-LEIA-ME.md`. Hub do pack: **`/skill-update`**. Fluxo do repo: **`AGENTS.md`**.

**Trigger:** `/replicar-mysql` · **Sempre responder em português.**

## Papel

Montar uma réplica MySQL de um banco que roda em Docker (serviços do EasyPanel/Swarm ou containers comuns) em outro servidor, com o mínimo de digitação do usuário. Só MySQL. **Não mexe na configuração do MySQL da origem** (se faltar binlog/GTID, o `verificar` diz o que ajustar e para). No host de origem a skill só faz, com `--confirmo`: o usuário de replicação, a **ponte** (container `socat`, quando o serviço não tem porta publicada) e o **firewall** (`bloquear-porta`).

Conteúdo **genérico**: nenhum IP, casa ou serviço real. Tudo isso o usuário informa na conversa ou o `listar` descobre.

## Arquivos

| Arquivo | Para quê |
|---------|----------|
| [`scripts/replicar-mysql.sh`](scripts/replicar-mysql.sh) | O executor (Bash). Subcomandos `ssh`, `listar`, `verificar`, `criar-destino`, `ponte`, `montar`, `status`, `bloquear-porta` |
| [`reference.md`](reference.md) | Conceitos, roteiro manual equivalente, tropeços conhecidos, ponte, Swarm, firewall, troca (promover a réplica) |
| [`CORRECOES.md`](CORRECOES.md) | Registro das correções da skill |

## Fluxo do agente

Ordem: `ssh` → `listar` → (**destino não existe: `criar-destino`**) → **confirmar a casa com o usuário** → `verificar` → OK do usuário → `montar` → relatório → (`bloquear-porta`).

1. **Perguntar só o que faltar:** SSH da origem (`root@ip`) e SSH do destino. **Não pergunte o nome do serviço**: o `listar` mostra. (Opcional: banco(s), `--origem-host`, `--porta`.)
2. **Rodar `ssh` primeiro** (`$S ssh --origem-ssh root@IP_O --destino-ssh root@IP_D`). A instalação automática da chave só acontece em `ssh`, `verificar`, `montar` e `criar-destino` (este, só fora do `--dry-run`); `listar`, `status`, `ponte`, `bloquear-porta` e `criar-destino --dry-run` (inclusive `--dry-run`) só conferem e mandam rodar `ssh`. O script faz tudo o que pode sozinho:
   - aceita sozinho a chave **desconhecida** de um servidor (`StrictHostKeyChecking=accept-new`); se a chave **mudou**, é FALHA e a skill nunca aceita (explica `ssh-keygen -R`);
   - se der **permissão negada**, tenta cada chave privada de `~/.ssh` (e as do `IdentityFile` do `~/.ssh/config`; no máximo 5 por host, por causa do fail2ban; sem `ForwardAgent`) e, se alguma entra, **instala a chave da skill sozinha** (idempotente); tenta também **pular de um servidor já acessível** para o outro;
   - só quando nada funcionou imprime a chave pública e o comando para o usuário colar (console do provedor) naquele servidor. Mostre isso ao usuário, espere o "pronto" e rode `ssh` de novo;
   - falha de **rede** (tempo esgotado, porta 22): problema de IP/firewall, não de chave. Para IP `100.x` o script lê o Tailscale desta máquina **uma vez** e dá o mesmo aviso para todos os hosts (instalar, ligar ou conferir a conta). Nunca pedir nem mostrar chave privada.
3. **Rodar `listar`** (`$S listar --origem-ssh ... --destino-ssh ...`): mostra os serviços MySQL/MariaDB de cada host (serviço, imagem, porta publicada, ponte, se já é réplica) e sugere o par origem → destino pelo nome da casa. **Mostre ao usuário e confirme a casa** (par origem/destino) antes de seguir; se aparecer `AMBIGUO`, pergunte. **Se o destino não existe (`SEM PAR` e nenhum MySQL no destino): a skill CRIA o serviço, não para.** Peça ao usuário (a) um **token da API do painel do EasyPanel de destino** salvo num arquivo de modo 600 (ele cria no painel em Configurações (Settings) → Users → token da API; nunca cole o token no chat nem em argumento) e (b) o OK para criar. Rode antes `$S criar-destino ... --dry-run`, mostre o plano e, com o OK, rode `criar-destino --confirmo`. Ele cria o serviço MySQL (`mysql:9`, sem porta publicada, senhas aleatórias que nunca aparecem), espera subir e confere. Depois use o serviço criado (`<projeto>_<nome>`, impresso no fim) no `verificar`.
4. **Pré-requisitos que o usuário faz à mão** (a skill não faz): Tailscale nos dois hosts com *key expiry* desligado (e, se o SSH usar IP `100.x`, **esta máquina também no Tailscale, mesma conta**); (o serviço MySQL do destino a skill cria com `criar-destino`; criar à mão no painel continua valendo: versão >= origem, **sem porta publicada**). A **porta da origem a skill resolve** (item 5).
5. **Rodar `verificar`** e mostrar o relatório (OK · AVISO · FALHA). A porta da origem é descoberta sozinha: ponte da casa → porta publicada do serviço → senão o relatório avisa que o `montar` vai criar a **ponte** (nada é criado no `verificar`). FALHA = parar e explicar a correção. **FALHA "o destino já tem tabelas" num destino que não é réplica nem cópia desta origem:** não usar `--refazer` (ele recusa e não apaga). Investigar só lendo (data de criação, tabelas, usuários) e perguntar ao usuário o que é. Só com **OK explícito do usuário no chat** (dado descartável): dump completo dos bancos a replicar em `<base>/backups/<serviço>-ANTIGO-<data>.sql.gz` (600) no destino, conferir o dump (existe, não está vazio, termina em `Dump completed`), `DROP DATABASE` desses bancos e `verificar` de novo. Esse dump, como os outros, nunca é apagado. Sem OK, usar outro destino.
6. **Pedir OK explícito do usuário no chat.** Só então `montar --confirmo`. Nunca rodar `montar` sem esse OK. Se a origem não tinha porta, o `montar` cria a ponte (mexe no host de origem; o OK já cobre isso, diga que vai acontecer).
7. **Mostrar o relatório final** do `montar` (inclui a porta da ponte, como acessar o banco pelo Tailscale e que reiniciar pelo EasyPanel não quebra a réplica). Se aparecer o aviso da porta aberta, oferecer `bloquear-porta --confirmo` (OK à parte; `--dry-run` primeiro mostra o que mudaria).
8. Combinar o acompanhamento: `status` sai com código diferente de 0 se a réplica parou ou atrasou mais de 60 s (base para alerta). `status` funciona só com o destino (descobre a origem pelo `Source_Host/Port`).

```bash
S='bash <clone>/skills/replicar-mysql/scripts/replicar-mysql.sh'   # pelo clone atualizado (git pull), ou 'npm run sync' antes de usar a cópia
$S ssh --origem-ssh root@IP_O --destino-ssh root@IP_D
$S listar --origem-ssh root@IP_O --destino-ssh root@IP_D
$S criar-destino --dry-run --origem-servico SERV_O --destino-ssh root@IP_D --destino-painel https://PAINEL_D/ --token-arquivo ~/token-painel   # só se o destino não existe; depois igual com --confirmo
$S verificar --origem-ssh root@IP_O --origem-servico SERV_O --destino-ssh root@IP_D --destino-servico SERV_D
$S montar --confirmo   <mesmas opções>
$S status --destino-ssh root@IP_D --destino-servico SERV_D        # origem é descoberta
$S ponte --confirmo --origem-ssh root@IP_O --origem-servico SERV_O   # só a ponte (o montar já cria quando precisa)
$S bloquear-porta --dry-run --origem-ssh root@IP_O                   # depois sem --dry-run e com --confirmo
```

Opções: `--banco a,b` (opcional; por padrão TODOS os bancos de usuário da origem; só é aceito se a origem não tiver outros, porque a réplica recebe o binlog de todos) · `--origem-host` (padrão: IP da ponte, ou IP do Tailscale da origem) · `--porta` (**só força**; por padrão é descoberta) · `--ponte-ip` (IP em que a ponte escuta; só aceita IP do Tailscale 100.64.0.0/10; `0.0.0.0`, `::` e IP público são recusados sempre) · `--forcar-ponte-ip` (só em teste: aceita IP privado, com AVISO) · `--forcar-porta` (aceita porta de ponte fora da faixa 29900–29999) · `--server-id` (padrão aleatório, diferente da origem e das outras réplicas) · `--travar-tudo` (dump com `--lock-all-tables`: **trava as gravações da origem durante o dump inteiro**; só com OK à parte, para MyISAM gravada com frequência) · `--seguir-com-consulta-longa` (por padrão consulta longa na origem é FALHA) · `--refazer` (refaz réplica existente; só vale se o destino já for réplica DESTA origem, cópia dela ou estiver sem tabelas; apaga **só** os bancos replicados no destino) · `--portas a,b` e `--dry-run` (`bloquear-porta`) · `--origem-senha-arquivo` / `--destino-senha-arquivo` (se o container não tiver `MYSQL_ROOT_PASSWORD`). `--origem-ssh local` / `--destino-ssh local` rodam na máquina atual (teste). Variável `REPLICAR_DIR_BASE` (padrão `/root`) muda onde ficam `.replicacao/` e `backups/` no destino. Versão mínima: MySQL 8.0.26 nos dois lados.

## Leis desta skill

- **Senha nunca aparece:** nem na tela, nem em argumento, nem em log, nem em arquivo do git. O script usa o `MYSQL_ROOT_PASSWORD` de dentro de cada container e passa a senha da origem ao dump pela entrada padrão. A senha do usuário de replicação `repl_<destino>` (32 letras e números, o máximo que o MySQL aceita) fica em `<base>/.replicacao/<servico-destino>.env`, modo 600, no host de destino. O agente **nunca** pede nem repete senha no chat. Chave SSH privada também nunca: só a `.pub` é impressa.
- **O dump nunca é apagado:** fica em `<base>/backups/<servico>-<bancos>-AAAAMMDD-HHMMSS.sql` (modo 600) no destino. Contém dados de jogadores/clientes: não vai para o git nem para o chat.
- **A origem quase não é alterada:** nasce o usuário `repl_<serviço>_<hash>` (um por destino de verdade: o hash vem do host de destino + serviço; sem ir para o binlog). Se o usuário já existe na origem e este destino não tem a senha dele, é FALHA: a skill nunca troca a senha de um usuário que pode ser de outra réplica; a **ponte** só se o serviço não tem porta (container `replicacao-<casa>-ponte-<porta>` (achado pelos rótulos `replicacao.origem-servico`/`replicacao.porta`, rodando ou parada; parada é religada com `docker start`), imagem `alpine/socat:1.8.0.3`, `--restart unless-stopped`, **só no IP do Tailscale**, porta da faixa **29900–29999**, sem reiniciar o MySQL e sem abrir a internet; sempre preferida a publicar a porta no EasyPanel); e, com `bloquear-porta --confirmo`, o script e o serviço de firewall. Os usuários da aplicação são **copiados** da origem para o destino (menos `root`, `mysql.*` e `repl_*`). O `verificar` recusa destino que seja a própria origem (`server_uuid` igual).
- **`montar`, `ponte` (quando vai criar) e `bloquear-porta` (sem `--dry-run`) exigem `--confirmo`** dado depois do OK do usuário. O segundo `montar` num destino que já é réplica recusa; `--refazer` é decisão do usuário. `montar` sai com código diferente de 0 se a réplica não estiver saudável no fim.
- **Swarm:** container de serviço Swarm **nunca** é reiniciado com `docker restart` (o Swarm sobe outra task no mesmo volume e sobram dois MySQL no mesmo dado). A skill usa `docker service update --force` e espera a task nova. Ela **re-acha os containers antes de cada passo**; se o serviço tem **mais de um container rodando**, para com ERRO antes de escrever (diz qual parar).
- **Chave SSH:** a skill só cria `~/.ssh/id_ed25519` se não existir, nunca sobrescreve, e só instala a `.pub` dela (idempotente).
- **Processos:** só mexer nos containers do destino que o fluxo pede. Nada de matar processos em geral.
- **Nunca imprimir o corpo de resposta da API do EasyPanel** (`createService`, `updateCredentials` etc. ecoam as senhas, também nas mensagens de erro): só o código HTTP. O token vai em arquivo 600 (`curl -K`), nunca em argumento nem na tela.
- **Nunca publicar a porta 3306 (nem outra) do MySQL de origem ou de destino**, nem "por alguns minutos": a origem sem porta usa a **ponte** (Tailscale). Se um passo antigo pedir porta publicada, ignore.
- **Rodar pelo clone atualizado** (`bash <clone>/skills/replicar-mysql/scripts/replicar-mysql.sh`) ou `npm run sync` antes: a cópia sincronizada pode estar velha e sem bit de execução.
- Nunca usar `set -x` nem imprimir variáveis de senha ao depurar.

## Método de execução

Segue [`../../docs/metodo-agentes.md`](../../docs/metodo-agentes.md). Registro: [`CORRECOES.md`](CORRECOES.md).

**Âncora:** em repositório de código, só `.task/replicar-mysql/ANCORA.md` (modelo em `../../docs/metodo-agentes.md` §5): aponta para este `SKILL.md`, etapa atual e próximo passo. Não escrever no `AGENTS.md` do repositório.

| Etapa | Subagente | Entrega | Pronto quando | Exemplo real | Quem aprova |
|-------|-----------|---------|---------------|--------------|-------------|
| Acesso SSH | Não — Controlador roda `ssh` | Saída do `ssh` (e chave pública + comando mostrados ao usuário, só se nada entrou sozinho) | `ssh` sai com 0 nos dois servidores (OK acesso SSH a cada host) | Primeiro uso real: chave existente entrou e a da skill foi instalada sozinha | Humano (só se precisar colar a chave) |
| Casa | Não — Controlador | Saída do `listar` + par origem → destino | O usuário confirmou a casa (serviços origem e destino) | `listar` mostrou 3 casas de cada lado e sugeriu 2 pares | Humano |
| Verificar | Sim (leve) — roda `verificar` | Relatório OK/AVISO/FALHA colado na conversa | Zero FALHA; cada AVISO explicado ao usuário | Falta exemplo real de montagem completa | Humano |
| Montar | Sim — roda `montar --confirmo` | Relatório final `[1/8]`..`[8/8]` | IO e SQL = Yes; `gtid_executed` igual (ou aviso explicado); contagem de linhas igual; dump salvo no destino; um container só no destino | Falta exemplo real | Humano |
| Proteger a porta | Não — Controlador | `bloquear-porta --dry-run`, depois com `--confirmo` | `verificar` não mostra mais o aviso da porta (só com OK à parte) | Falta exemplo real | Humano |
| Revisão sem contexto | Sim — subagente novo | Lista de achados | Nenhuma senha na saída colada; relatório coerente com os itens acima | — | Controlador |

**Revisor sem contexto:** subagente novo recebe só os relatórios de `verificar`/`montar` e esta seção; confere item por item e procura senha ou dado de cliente na saída.

**Toda correção vira atualização da skill:** lista de correções → `/skill-update` (fluxo F) → edição genérica + `CORRECOES.md` + sync.
