---
name: replicar-mysql
description: >-
  Monta e confere uma réplica MySQL (origem -> destino) entre dois servidores com
  Docker/EasyPanel, por GTID, de forma automática: verifica a origem, o destino e a
  rede, pede o OK do usuário, faz dump, import e liga a replicação, e confere os
  dados. Use com /replicar-mysql, "replicar mysql", "criar réplica", "réplica do
  banco", "montar replicação" ou "status da réplica".
disable-model-invocation: true
---

# Replicar MySQL

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta máquina** (PC ≠ Coders).
> **Altere em** `space-cursor-skills/skills/replicar-mysql/` → **obrigatório rodar** `npm run sync` na raiz (máquina alvo).
> Ver `00-COPIA-LEIA-ME.md`. Hub do pack: **`/skill-update`**. Fluxo do repo: **`AGENTS.md`**.

**Trigger:** `/replicar-mysql` · **Sempre responder em português.**

## Papel

Montar uma réplica MySQL de um banco que roda em Docker (serviços do EasyPanel/Swarm ou containers comuns) em outro servidor, com o mínimo de digitação do usuário. Só MySQL. **Não mexe na configuração da origem** (se faltar binlog/GTID, o `verificar` diz o que ajustar e para).

Conteúdo **genérico**: nenhum IP, casa ou serviço real. Tudo isso o usuário informa na conversa.

## Arquivos

| Arquivo | Para quê |
|---------|----------|
| [`scripts/replicar-mysql.sh`](scripts/replicar-mysql.sh) | O executor (Bash). Subcomandos `verificar`, `montar`, `status`, `bloquear-porta` |
| [`reference.md`](reference.md) | Conceitos, roteiro manual equivalente, tropeços conhecidos, troca (promover a réplica) |
| [`CORRECOES.md`](CORRECOES.md) | Registro das correções da skill |

## Fluxo do agente

1. **Perguntar só o que faltar:** SSH da origem (`root@ip`), serviço da origem (ex. `projeto_servico`), (banco(s) só se quiser restringir: por padrão vão TODOS os bancos de usuário da origem), SSH do destino, serviço do destino. Opcional: `--origem-host` (IP/nome que o destino usa para falar com a origem; padrão = IP do Tailscale da origem), `--porta`.
2. **Rodar `ssh` primeiro** (`$S ssh --origem-ssh root@IP_O --destino-ssh root@IP_D`). Se algum servidor falhar por **permissão negada**, o script gera a chave desta máquina (se não existir) e imprime a **chave pública** e o comando pronto: **mostre ao usuário, para cada servidor, a chave pública e o comando**, peça que cole como root no console/terminal do servidor (ex. terminal do provedor da VPS), espere o "pronto" e rode `ssh` de novo. Se falhar por **rede** (tempo esgotado, porta 22), o problema é IP/firewall: diga isso, não a chave. Nunca pedir nem mostrar a chave privada. `verificar` e `montar` repetem essa checagem e param com a mesma instrução.
3. **Conferir com o usuário os pré-requisitos que ele faz à mão** (a skill não faz):
   - Tailscale nos dois hosts, com *key expiry* desligado;
   - porta 3306 publicada no serviço de origem;
   - serviço MySQL padrão criado no destino, versão >= origem, **sem porta publicada**;
4. **Rodar `verificar`** e mostrar o relatório (uma linha por item: OK · AVISO · FALHA). FALHA = parar e explicar a correção.
5. **Pedir OK explícito do usuário no chat.** Só então `montar --confirmo`. Nunca rodar `montar` sem esse OK.
6. **Mostrar o relatório final.** Se aparecer o aviso da porta aberta, oferecer `bloquear-porta --confirmo` (OK à parte).
7. Combinar o acompanhamento: `status` sai com código diferente de 0 se a réplica parou ou atrasou mais de 60 s (serve de base para alerta).

```bash
S=skills/replicar-mysql/scripts/replicar-mysql.sh   # ou o caminho da cópia sincronizada
$S ssh --origem-ssh root@IP_O --destino-ssh root@IP_D
$S verificar --origem-ssh root@IP_O --origem-servico PROJ_SERV_O --destino-ssh root@IP_D --destino-servico PROJ_SERV_D
$S montar --confirmo   <mesmas opções>
$S status --destino-ssh root@IP_D --destino-servico PROJ_SERV_D
$S bloquear-porta --confirmo --origem-ssh root@IP_O --porta 3306
```

Opções: `--banco a,b` (opcional; por padrão TODOS os bancos de usuário da origem; só é aceito se a origem não tiver outros, porque a réplica recebe o binlog de todos) · `--origem-host` · `--porta` · `--server-id` (padrão: aleatório, diferente da origem e das outras réplicas) · `--travar-tudo` (dump com `--lock-all-tables`: **trava as gravações da origem durante o dump inteiro**; só com OK à parte do usuário, para MyISAM gravada com frequência) · `--seguir-com-consulta-longa` (por padrão consulta longa na origem é FALHA, porque o dump esperaria por ela segurando as gravações) · `--refazer` (refaz réplica existente; só vale se o destino já for réplica DESTA origem, cópia dela ou estiver sem tabelas; apaga **só** os bancos replicados no destino) · `--origem-senha-arquivo` / `--destino-senha-arquivo` (se o container não tiver `MYSQL_ROOT_PASSWORD`). `--origem-ssh local` / `--destino-ssh local` rodam na máquina atual (teste). Variável `REPLICAR_DIR_BASE` (padrão `/root`) muda onde ficam `.replicacao/` e `backups/` no destino. Versão mínima: MySQL 8.0.26 nos dois lados.

## Leis desta skill

- **Senha nunca aparece:** nem na tela, nem em argumento, nem em log, nem em arquivo do git. O script usa o `MYSQL_ROOT_PASSWORD` de dentro de cada container e passa a senha da origem ao dump pela entrada padrão. A senha do usuário de replicação `repl_<destino>` (32 letras e números, o máximo que o MySQL aceita) fica em `<base>/.replicacao/<servico-destino>.env`, modo 600, no host de destino. O agente **nunca** pede nem repete senha no chat.
- **O dump nunca é apagado:** fica em `<base>/backups/<servico>-<bancos>-AAAAMMDD-HHMMSS.sql` (modo 600) no destino. Contém dados de jogadores/clientes: não vai para o git nem para o chat.
- **A origem quase não é alterada:** só nasce o usuário `repl_<destino>` (um por destino, criado sem ir para o binlog; nunca se altera outro usuário) e, com `bloquear-porta --confirmo`, a regra de firewall. Os usuários da aplicação são **copiados** da origem para o destino (menos `root`, `mysql.*` e `repl_*`; os que já existirem no destino são pulados com aviso) antes de ligar a replicação. O `verificar` recusa destino que seja a própria origem (`server_uuid` igual).
- **`montar` e `bloquear-porta` exigem `--confirmo`** dado depois do OK do usuário. O segundo `montar` num destino que já é réplica recusa; `--refazer` é decisão do usuário e é recusado se o destino for réplica de outra origem ou tiver dados que não vêm desta. `montar` sai com código diferente de 0 se a réplica não estiver saudável no fim.
- **Chave SSH:** a skill só cria `~/.ssh/id_ed25519` se não existir, nunca sobrescreve, e só imprime a `.pub`.
- **Processos:** só mexer nos containers do destino que o fluxo pede (`docker restart` do serviço MySQL de destino). Nada de matar processos em geral.
- Nunca usar `set -x` nem imprimir variáveis de senha ao depurar.

## Método de execução

Segue [`../../docs/metodo-agentes.md`](../../docs/metodo-agentes.md). Registro: [`CORRECOES.md`](CORRECOES.md).

**Âncora:** em repositório de código, só `.task/replicar-mysql/ANCORA.md` (modelo em `../../docs/metodo-agentes.md` §5): aponta para este `SKILL.md`, etapa atual e próximo passo. Não escrever no `AGENTS.md` do repositório.

| Etapa | Subagente | Entrega | Pronto quando | Exemplo real | Quem aprova |
|-------|-----------|---------|---------------|--------------|-------------|
| Acesso SSH | Não — Controlador roda `ssh` | Saída do `ssh` (e chave pública + comando mostrados ao usuário, se faltar) | `ssh` sai com 0 nos dois servidores (OK acesso SSH a cada host) | Falta exemplo real | Humano (cola a chave) |
| Entradas e pré-requisitos | Não — Controlador | Lista de entradas + pré-requisitos confirmados | Serviços, bancos e os 3 pré-requisitos (Tailscale, porta publicada, MySQL de destino) respondidos pelo usuário | Falta exemplo real | Humano |
| Verificar | Sim (leve) — roda `verificar` | Relatório OK/AVISO/FALHA colado na conversa | Zero FALHA; cada AVISO explicado ao usuário | Falta exemplo real | Humano |
| Montar | Sim — roda `montar --confirmo` | Relatório final `[1/8]`..`[8/8]` | IO e SQL = Yes; `gtid_executed` igual (ou aviso explicado); contagem de linhas igual; dump salvo no destino | Falta exemplo real | Humano |
| Proteger a porta | Não — Controlador | Regra no `DOCKER-USER` | `verificar` não mostra mais o aviso da porta (só com OK à parte) | Falta exemplo real | Humano |
| Revisão sem contexto | Sim — subagente novo | Lista de achados | Nenhuma senha na saída colada; relatório coerente com os itens acima | — | Controlador |

**Revisor sem contexto:** subagente novo recebe só os relatórios de `verificar`/`montar` e esta seção; confere item por item e procura senha ou dado de cliente na saída.

**Toda correção vira atualização da skill:** lista de correções → `/skill-update` (fluxo F) → edição genérica + `CORRECOES.md` + sync.
