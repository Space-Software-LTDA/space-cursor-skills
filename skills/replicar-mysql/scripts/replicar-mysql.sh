#!/usr/bin/env bash
# replicar-mysql.sh — monta e confere replicação MySQL (origem -> réplica) entre dois hosts.
# Subcomandos: ssh | verificar | montar | status | bloquear-porta
# Regra dura: nenhuma senha em tela, argumento, log ou arquivo versionado. Nunca usar `set -x`.
set -euo pipefail

BASE="${REPLICAR_DIR_BASE:-/root}"   # onde ficam .replicacao/ e backups/ no host de destino (testes: outro caminho)
SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=10)
SISTEMA="'mysql','sys','information_schema','performance_schema'"
MIN_VERSAO=8.0.26
LIMITE_CONTAGEM=1000000   # tabelas com mais linhas estimadas que isto não têm COUNT(*) exato

OSSH="" OSERV="" DSSH="" DSERV="" BANCOS="" OHOST="" PORTA=3306 SID=""
TRAVAR=0 REFAZER=0 CONFIRMO=0 OPWF="" DPWF="" SEGUIR_LONGA=0 BANCO_INFORMADO=0
OCONT="" DCONT="" CANDS=""
FALHAS=0 AVISOS=0
OVERS="" OSID="" OUUID="" DVERS="" DUUID="" TAMANHO=0 SRC_UUID=""

uso() {
  cat <<'USO'
Uso: replicar-mysql.sh <ssh|verificar|montar|status|bloquear-porta> [opções]  (ssh: confere o acesso e, se faltar, imprime a chave pública e o comando para colar no servidor)
  --origem-ssh   root@ip | local     --origem-servico  nome do serviço (ex. projeto_servico)
  --destino-ssh  root@ip | local     --destino-servico nome do serviço
  --banco a,b    (opcional) padrão: TODOS os bancos de usuário da origem; só aceito se a origem não tiver outros
  --origem-host  host/IP que o DESTINO usa para falar com a origem (padrão: tailscale ip -4 da origem)
  --porta 3306   --server-id N (padrão: aleatório, diferente da origem e das outras réplicas)
  --travar-tudo  dump com --lock-all-tables (TRAVA AS GRAVAÇÕES da origem durante o dump inteiro)
  --seguir-com-consulta-longa  não parar por consulta longa rodando na origem
  --refazer      refaz réplica existente (só se o destino já for réplica desta origem, cópia dela ou vazio)
  --confirmo     obrigatório em montar e bloquear-porta
  --origem-senha-arquivo / --destino-senha-arquivo  caminho (no host remoto) com a senha root, se o container não tiver MYSQL_ROOT_PASSWORD
Variável: REPLICAR_DIR_BASE (padrão /root) — base de .replicacao/ e backups/ no host de destino.
USO
}

ok() { printf 'OK     %s\n' "$*"; }
av() { printf 'AVISO  %s\n' "$*"; AVISOS=$((AVISOS + 1)); }
fa() { printf 'FALHA  %s\n' "$*"; FALHAS=$((FALHAS + 1)); }
passo() { printf '\n[%s/8] %s\n' "$1" "$2"; }
morrer() { printf 'ERRO   %s\n' "$*" >&2; exit 1; }

# ---------- execução nos hosts ----------
hexec() { # lado(o|d) comando — o stdin passa para o comando remoto
  local lado=$1 cmd=$2 tgt
  if [ "$lado" = o ]; then tgt=$OSSH; else tgt=$DSSH; fi
  if [ "$tgt" = local ]; then bash -c "$cmd"; else ssh "${SSH_OPTS[@]}" "$tgt" "$cmd"; fi
}

garantir_chave() { # garante ~/.ssh/id_ed25519(.pub) da máquina que roda a skill; nunca sobrescreve; imprime só a pública
  local k="$HOME/.ssh/id_ed25519"
  if [ -f "$k.pub" ]; then return 0; fi
  if [ -f "$k" ]; then
    echo "FALHA  existe a chave privada $k mas falta $k.pub. Gere a pública com: ssh-keygen -y -f $k > $k.pub"
    return 1
  fi
  mkdir -p "$HOME/.ssh"; chmod 700 "$HOME/.ssh"
  ssh-keygen -q -t ed25519 -N "" -C "replicar-mysql@$(hostname)" -f "$k" >/dev/null || { echo "FALHA  ssh-keygen falhou"; return 1; }
  echo "INFO   chave nova criada em $k.pub (a privada fica só nesta máquina)"
}

aviso_tailscale_local() { # IP 100.64.0.0/10 é do Tailscale: esta máquina precisa estar na mesma rede
  local ip=${1#*@} ts="" b
  ip=${ip%%:*}
  b=$(printf '%s' "$ip" | sed -n 's/^100\.\([0-9]\{1,3\}\)\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/\1/p')
  { [ -n "$b" ] && [ "$b" -ge 64 ] && [ "$b" -le 127 ]; } || return 0
  if command -v tailscale >/dev/null 2>&1; then ts=tailscale
  elif [ -x "/c/Program Files/Tailscale/tailscale.exe" ]; then ts="/c/Program Files/Tailscale/tailscale.exe"; fi
  if [ -z "$ts" ]; then
    echo "       $ip é um IP do Tailscale e esta máquina não tem o Tailscale. Instale e entre com a mesma conta dos servidores"
    echo "       (Windows: winget install Tailscale.Tailscale; Linux: curl -fsSL https://tailscale.com/install.sh | sh && tailscale up), ou use o IP público do servidor."
  elif ! "$ts" status >/dev/null 2>&1; then
    echo "       $ip é um IP do Tailscale e o Tailscale desta máquina está desligado ou sem login. Rode 'tailscale up' (ou abra o app) e tente de novo."
  else
    echo "       $ip é um IP do Tailscale e esta máquina está no Tailscale: confira se o servidor aparece em 'tailscale status' (mesma conta)."
  fi
}

checar_ssh() { # host|local -> 0 se acessa; senão imprime a instrução e devolve 1
  local tgt=$1 err motivo
  if [ "$tgt" = local ]; then echo "INFO   $tgt: pulado (roda nesta máquina)"; return 0; fi
  if err=$(ssh "${SSH_OPTS[@]}" "$tgt" true 2>&1 >/dev/null); then ok "acesso SSH a $tgt"; return 0; fi
  if printf '%s' "$err" | grep -qi 'Permission denied'; then motivo=chave
  elif printf '%s' "$err" | grep -qi 'Host key verification'; then motivo=hostkey
  else motivo=rede; fi
  case $motivo in
    rede)
      echo "FALHA  sem acesso SSH a $tgt: o servidor não respondeu (tempo esgotado, host inalcançável, porta 22 fechada ou IP errado)."
      echo "       Confira o IP, o firewall (porta 22) e se o servidor está ligado. Detalhe: $(printf '%s' "$err" | head -n1)"
      aviso_tailscale_local "$tgt"
      return 1 ;;
    hostkey)
      echo "FALHA  sem acesso SSH a $tgt: a chave do servidor mudou ou não é conhecida. Rode 'ssh $tgt' uma vez à mão para aceitar, ou confira ~/.ssh/known_hosts."
      return 1 ;;
  esac
  garantir_chave || return 1
  echo "FALHA  sem acesso SSH a $tgt: permissão negada (esta máquina ainda não está autorizada no servidor)."
  echo "       Entre no servidor como root (console ou terminal do provedor da VPS) e cole:"
  echo
  echo "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '$(cat "$HOME/.ssh/id_ed25519.pub")' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
  echo
  echo "       Depois rode este comando de novo."
  return 1
}

acesso_ssh() { # confere origem e destino (pula local); 0 só se todos acessam
  local rc=0
  echo "== SSH =="
  if [ -n "$OSSH" ]; then checar_ssh "$OSSH" || rc=1; fi
  if [ -n "$DSSH" ] && [ "$DSSH" != "$OSSH" ]; then checar_ssh "$DSSH" || rc=1; fi
  return $rc
}

setcont() { # lado -> preenche OCONT/DCONT; falha (1) se não achar exatamente um
  local lado=$1 serv out n
  if [ "$lado" = o ]; then serv=$OSERV; else serv=$DSERV; fi
  out=$(hexec "$lado" "docker ps --filter 'label=com.docker.swarm.service.name=$serv' --format '{{.Names}}'" 2>/dev/null) || out=""
  n=$(printf '%s' "$out" | grep -c . || true)
  if [ "$n" -eq 0 ]; then
    out=$(hexec "$lado" "docker ps --format '{{.Names}}'" 2>/dev/null | grep -E "^${serv//./\\.}(\\.|\$)" || true)
    n=$(printf '%s' "$out" | grep -c . || true)
  fi
  if [ "$n" -ne 1 ]; then CANDS=$out; return 1; fi
  if [ "$lado" = o ]; then OCONT=$out; else DCONT=$out; fi
}

mcmd() { # lado [flags] -> comando de host que lê SQL do stdin, como root; senha vem do container (nunca em argumento)
  local lado=$1 fl=${2:--N -B} c f
  if [ "$lado" = o ]; then c=$OCONT; f=$OPWF; else c=$DCONT; f=$DPWF; fi
  if [ -n "$f" ]; then
    printf "MYSQL_PWD=\"\$(tr -d '\\\\r' < '%s')\" docker exec -i -e MYSQL_PWD %s mysql -uroot %s" "$f" "$c" "$fl"
  else
    printf "docker exec -i %s sh -c 'MYSQL_PWD=\"\$MYSQL_ROOT_PASSWORD\" exec mysql -uroot %s'" "$c" "$fl"
  fi
}
q()  { printf '%s\n' "$2" | hexec "$1" "$(mcmd "$1")" 2>/dev/null; }          # silencioso, devolve linhas (tab)
qr() { printf '%s\n' "$2" | hexec "$1" "$(mcmd "$1" '-N -B -r')" 2>/dev/null; } # sem escape (SHOW CREATE USER etc.)
qe() { printf '%s\n' "$2" | hexec "$1" "$(mcmd "$1")"; }                      # mostra os erros do MySQL

pwcmd() { # comando, no host de origem, que imprime a senha root da origem numa linha
  if [ -n "$OPWF" ]; then printf "{ tr -d '\\\\r' < '%s'; echo; }" "$OPWF"; else printf "{ docker exec %s printenv MYSQL_ROOT_PASSWORD; echo; }" "$OCONT"; fi
}

via_tcp() { # SQL no stdin; roda mysql DE DENTRO do container de destino contra origem-host:porta (o caminho do dump)
  { hexec o "$(pwcmd)" </dev/null; cat; } |
    hexec d "docker exec -i $DCONT sh -c 'IFS= read -r MYSQL_PWD; export MYSQL_PWD; exec mysql -h $OHOST -P $PORTA -uroot -N -B'" 2>/dev/null
}

esperar_mysql() { # lado, segundos
  local lado=$1 max=${2:-120} t=0
  while [ "$t" -lt "$max" ]; do
    if setcont "$lado" 2>/dev/null && q "$lado" 'SELECT 1' >/dev/null; then return 0; fi
    sleep 3; t=$((t + 3))
  done
  return 1
}

ver_ge() { # a >= b ?
  local a=${1%%-*} b=${2%%-*}
  [ "$(printf '%s\n%s\n' "$b" "$a" | sort -V | head -n1)" = "$b" ]
}

lista_sql() {
  local out="" b arr
  IFS=, read -ra arr <<<"$BANCOS"
  for b in "${arr[@]}"; do out="$out${out:+,}'$b'"; done
  printf '%s' "$out"
}

# ---------- argumentos ----------
validar() {
  local re_ssh='^(local|[A-Za-z0-9_.-]+@[A-Za-z0-9_.:-]+|[A-Za-z0-9_.-]+)$' re_n='^[A-Za-z0-9_.-]+$' b arr
  [[ $OSSH =~ $re_ssh ]] || [ -z "$OSSH" ] || morrer "--origem-ssh inválido"
  [[ $DSSH =~ $re_ssh ]] || [ -z "$DSSH" ] || morrer "--destino-ssh inválido"
  [[ $OSERV =~ $re_n ]] || [ -z "$OSERV" ] || morrer "--origem-servico inválido"
  [[ $DSERV =~ $re_n ]] || [ -z "$DSERV" ] || morrer "--destino-servico inválido"
  [[ $OHOST =~ ^[A-Za-z0-9_.:-]*$ ]] || morrer "--origem-host inválido"
  [[ $PORTA =~ ^[0-9]+$ ]] || morrer "--porta inválida"
  [[ $SID =~ ^[0-9]*$ ]] || morrer "--server-id inválido"
  [[ $BANCOS =~ ^[A-Za-z0-9_,]*$ ]] || morrer "--banco inválido (use letras, números, _ e vírgula)"
  if [ -n "$BANCOS" ]; then
    IFS=, read -ra arr <<<"$BANCOS"
    for b in "${arr[@]}"; do [ -n "$b" ] || morrer "--banco com item vazio"; done
    BANCO_INFORMADO=1
  fi
  [[ $OPWF =~ ^[A-Za-z0-9_./-]*$ ]] || morrer "--origem-senha-arquivo inválido"
  [[ $DPWF =~ ^[A-Za-z0-9_./-]*$ ]] || morrer "--destino-senha-arquivo inválido"
}

exigir() { local v; for v in "$@"; do [ -n "${!v}" ] || morrer "falta opção: $v"; done; }

repl_usuario() { # um usuário de replicação por destino: repl_<destino sanitizado>, até 32 caracteres
  local s
  s=$(printf '%s' "$DSERV" | tr 'A-Z' 'a-z' | tr -c 'a-z0-9_' '_')
  printf 'repl_%s' "$s" | cut -c1-32
}

consultas_longas() { # limite em segundos -> quantidade na origem
  q o "SELECT COUNT(*) FROM performance_schema.processlist WHERE command<>'Sleep' AND time>$1 AND ID<>CONNECTION_ID() AND command NOT LIKE 'Binlog Dump%' AND user NOT IN ('system user','event_scheduler') AND (info IS NULL OR info NOT LIKE '%processlist%')" || echo 0
}

# ---------- verificar ----------
verificar() {
  FALHAS=0; AVISOS=0
  local row overs olog ofmt ogtid oenf osid ouuid dvers
  acesso_ssh || return 1
  echo "== Origem =="
  if setcont o; then ok "container da origem: $OCONT"; else
    fa "container da origem não achado (exatamente um) para '$OSERV'. Candidatos: ${CANDS:-nenhum}"; fi
  if [ -n "$OCONT" ]; then
    if row=$(q o 'SELECT @@version,@@log_bin,@@binlog_format,@@gtid_mode,@@enforce_gtid_consistency,@@server_id,@@server_uuid'); then
      IFS=$'\t' read -r overs olog ofmt ogtid oenf osid ouuid <<<"$row"
      ok "root da origem funciona (MySQL $overs)"
      if ver_ge "$overs" "$MIN_VERSAO"; then ok "versão da origem >= $MIN_VERSAO"; else fa "versão da origem $overs < $MIN_VERSAO"; fi
      if [ "$olog" = 1 ]; then ok "log_bin=ON"; else fa "log_bin desligado na origem. Ligue (--log-bin) e reinicie; a skill não mexe na origem"; fi
      if [ "$ofmt" = ROW ]; then ok "binlog_format=ROW"; else fa "binlog_format=$ofmt (precisa ROW). Ajuste na origem; a skill não mexe nela"; fi
      if [ "$ogtid" = ON ]; then ok "gtid_mode=ON"; else fa "gtid_mode=$ogtid na origem (precisa ON, via OFF_PERMISSIVE, ON_PERMISSIVE, ON). A skill não mexe na origem"; fi
      if [ "$oenf" = ON ]; then ok "enforce_gtid_consistency=ON"; else fa "enforce_gtid_consistency=$oenf na origem (precisa ON). A skill não mexe na origem"; fi
      ok "server_id da origem = $osid"
      OVERS=$overs; OSID=$osid; OUUID=$ouuid
      local todos outros n_ok tot lista ntab myi big lock
      todos=$(q o "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ($SISTEMA) ORDER BY 1" | tr '\n' ',' | sed 's/,$//' || true)
      if [ "$BANCO_INFORMADO" = 0 ]; then
        BANCOS=$todos
        if [ -z "$BANCOS" ]; then fa "a origem não tem bancos de usuário"; else ok "bancos a replicar (todos os de usuário da origem): $BANCOS"; fi
        if [ -n "$BANCOS" ] && ! [[ $BANCOS =~ ^[A-Za-z0-9_,]+$ ]]; then fa "a origem tem banco com nome fora de [A-Za-z0-9_] (não suportado pela skill): $BANCOS"; BANCOS=""; fi
      fi
      if [ -n "$BANCOS" ]; then
        lista=$(lista_sql)
        outros=$(q o "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ($SISTEMA) AND schema_name NOT IN ($lista) ORDER BY 1" | tr '\n' ' ' || true)
        if [ -n "$outros" ]; then
          fa "a origem tem outros bancos de usuário além de --banco: $outros. A réplica recebe o binlog de TODOS (pararia com erro na primeira gravação). Omita --banco para replicar todos"
        fi
        n_ok=$(q o "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name IN ($lista)" || echo 0)
        tot=$(printf '%s' "$BANCOS" | tr ',' '\n' | grep -c .)
        if [ "$n_ok" = "$tot" ]; then ok "banco(s) existem na origem: $BANCOS"; else fa "banco(s) não encontrados na origem ($n_ok de $tot): $BANCOS"; fi
        ntab=$(q o "SELECT CONCAT(COALESCE(engine,'?'),'=',COUNT(*)) FROM information_schema.tables WHERE table_schema IN ($lista) AND table_type='BASE TABLE' GROUP BY engine" | tr '\n' ' ' || true)
        ok "tabelas por engine: ${ntab:-nenhuma}"
        myi=$(q o "SELECT CONCAT(table_schema,'.',table_name) FROM information_schema.tables WHERE table_schema IN ($lista) AND engine='MyISAM'" | tr '\n' ' ' || true)
        if [ -n "$myi" ]; then av "tabelas MyISAM (sem transação; --travar-tudo dá consistência mas TRAVA AS GRAVAÇÕES da origem durante o dump inteiro): $myi"; fi
        TAMANHO=$(q o "SELECT COALESCE(SUM(data_length+index_length),0) FROM information_schema.tables WHERE table_schema IN ($lista)" || echo 0)
        ok "tamanho dos dados: $((TAMANHO / 1048576)) MB"
      fi
      big=$(consultas_longas 60)
      if [ "${big:-0}" -gt 0 ]; then
        if [ "$SEGUIR_LONGA" = 1 ]; then av "$big consulta(s) há mais de 60 s na origem (seguindo por --seguir-com-consulta-longa)"; else
          fa "$big consulta(s) rodando há mais de 60 s na origem: o dump espera por elas segurando as gravações. Espere ou use --seguir-com-consulta-longa"; fi
      else ok "nenhuma consulta longa na origem"; fi
      lock=$(q o "SELECT COUNT(*) FROM performance_schema.processlist WHERE state LIKE 'Waiting for global read lock%'" || echo 0)
      if [ "${lock:-0}" -gt 0 ]; then fa "origem com espera de trava global ($lock). Aguarde e rode de novo"; fi
    else fa "root da origem não conectou (confira MYSQL_ROOT_PASSWORD do container ou --origem-senha-arquivo)"; fi
  fi
  # porta no host de origem
  local regra
  if regra=$(hexec o "iptables -S DOCKER-USER 2>/dev/null" 2>/dev/null) && [ -n "$regra" ]; then
    if printf '%s\n' "$regra" | grep -q -- "ctorigdstport $PORTA .*DROP"; then ok "porta $PORTA bloqueada para a internet (DOCKER-USER)"; else
      av "porta $PORTA aberta na internet (sem regra DROP no DOCKER-USER). Use: bloquear-porta --confirmo"; fi
  else av "não foi possível ler o iptables do host de origem (sem root ou sem iptables); porta $PORTA não verificada"; fi

  echo "== Rede =="
  if [ -z "$OHOST" ]; then
    OHOST=$(hexec o "tailscale ip -4 2>/dev/null | head -n1" 2>/dev/null || true)
    if [ -n "$OHOST" ]; then ok "origem-host (tailscale): $OHOST"; else fa "não achei o IP do Tailscale da origem; passe --origem-host"; fi
  else ok "origem-host informado: $OHOST"; fi

  echo "== Destino =="
  if setcont d; then ok "container do destino: $DCONT"; else
    fa "container do destino não achado (exatamente um) para '$DSERV'. Candidatos: ${CANDS:-nenhum}"; fi
  if [ -n "$DCONT" ]; then
    if row=$(q d 'SELECT @@version,@@server_uuid,@@server_id'); then
      local dsid
      IFS=$'\t' read -r dvers DUUID dsid <<<"$row"
      ok "root do destino funciona (MySQL $dvers)"
      DVERS=$dvers
      if ver_ge "$dvers" "$MIN_VERSAO"; then ok "versão do destino >= $MIN_VERSAO"; else fa "versão do destino $dvers < $MIN_VERSAO"; fi
      if [ -n "$OVERS" ]; then
        if ver_ge "$dvers" "$OVERS"; then ok "versão do destino ($dvers) >= origem ($OVERS)"; else fa "versão do destino ($dvers) < origem ($OVERS)"; fi
        if [ "${dvers%.*}" != "${OVERS%.*}" ]; then av "séries diferentes (origem ${OVERS%.*}, destino ${dvers%.*}): a Oracle só suporta réplica entre séries vizinhas"; fi
      fi
      # identidade: destino nunca pode ser a origem
      if [ -n "$OUUID" ]; then
        if [ "$DUUID" = "$OUUID" ]; then
          fa "o destino É a origem (mesmo server_uuid). Destino errado: nada será alterado"
        else ok "destino e origem são servidores diferentes (server_uuid)"; fi
        local tcp tuuid cipher ids
        if [ -n "$OHOST" ] && tcp=$(printf "SELECT @@server_uuid;\nSHOW STATUS LIKE 'Ssl_cipher';\n" | via_tcp) && [ -n "$tcp" ]; then
          tuuid=$(printf '%s\n' "$tcp" | sed -n '1p'); cipher=$(printf '%s\n' "$tcp" | sed -n 's/^Ssl_cipher\t//p')
          if [ "$tuuid" = "$OUUID" ]; then ok "login root de dentro do destino em $OHOST:$PORTA chega na origem (server_uuid confere)"; else
            fa "$OHOST:$PORTA visto de dentro do destino NÃO é a origem informada (server_uuid diferente). Confira --origem-host e --porta"; fi
          if [ -n "$cipher" ]; then ok "conexão do dump usa TLS"; else av "conexão do dump sem TLS"; fi
        else fa "container do destino não conseguiu logar como root em $OHOST:$PORTA (rede/Tailscale, porta publicada, root@'%' ou senha)"; fi
        ids=$(q o 'SHOW REPLICAS' | cut -f1 | tr '\n' ' ' || true)
        if [ -n "$SID" ]; then
          if [ "$SID" = "$OSID" ]; then fa "--server-id $SID é o da origem"; fi
          if [ "$SID" != "$dsid" ] && printf '%s\n' "$ids" | tr ' ' '\n' | grep -qx "$SID"; then fa "--server-id $SID já é de outra réplica desta origem"; fi
        fi
      fi
      local rs lista dtab_lista dtab_all copia
      if [ -z "$BANCOS" ]; then lista="''"; else lista=$(lista_sql); fi
      if ! rs=$(printf 'SHOW REPLICA STATUS;\n' | hexec d "$(mcmd d '-E')" 2>/dev/null); then
        fa "não consegui consultar SHOW REPLICA STATUS no destino"; rs=""; fi
      dtab_lista=$(q d "SELECT COUNT(*) FROM information_schema.tables WHERE table_type='BASE TABLE' AND table_schema IN ($lista)" || echo 0)
      dtab_all=$(q d "SELECT COUNT(*) FROM information_schema.tables WHERE table_type='BASE TABLE' AND table_schema NOT IN ($SISTEMA)" || echo 0)
      copia=0
      if [ -n "$OUUID" ] && [ "$(q d "SELECT GTID_SUBSET('$OUUID:1', @@GLOBAL.gtid_executed)" || echo 0)" = 1 ]; then copia=1; fi
      SRC_UUID=$(printf '%s\n' "$rs" | sed -n 's/^ *Source_UUID: //p' | head -n1)
      if [ -n "$rs" ]; then
        if [ "$REFAZER" = 1 ]; then
          if [ -n "$OUUID" ] && [ "$SRC_UUID" = "$OUUID" ]; then av "destino já é réplica desta origem; será refeita (--refazer)"; else
            fa "destino é réplica de OUTRA origem (Source_UUID diferente). --refazer recusado"; fi
        else fa "destino já é réplica. Use --refazer para refazer"; fi
      else ok "destino ainda não é réplica"; fi
      if [ "${dtab_lista:-0}" -gt 0 ] || [ "${dtab_all:-0}" -gt 0 ]; then
        if [ "$REFAZER" = 1 ]; then
          if [ -n "$rs" ] && [ "$SRC_UUID" = "$OUUID" ]; then :; elif [ "$copia" = 1 ]; then
            av "destino tem cópia anterior desta origem (sobra de montagem interrompida); será apagada (--refazer)"; else
            fa "destino tem tabelas que NÃO vêm desta origem. --refazer só vale para réplica/cópia desta origem ou destino vazio; nada será apagado"; fi
        elif [ "${dtab_lista:-0}" -gt 0 ]; then fa "o destino já tem tabelas nos bancos a replicar. Use --refazer (se for cópia/réplica desta origem)"; else
          av "o destino tem outros bancos com tabelas (o RESET dos GTIDs afeta o servidor todo)"; fi
      else ok "destino sem tabelas de usuário"; fi
      local av_kb bk_kb sz
      av_kb=$(hexec d "df -Pk /var/lib/docker 2>/dev/null | awk 'NR==2{print \$4}'" 2>/dev/null || true)
      bk_kb=$(hexec d "d='$BASE'; while [ ! -d \"\$d\" ]; do d=\$(dirname \"\$d\"); done; df -Pk \"\$d\" | awk 'NR==2{print \$4}'" 2>/dev/null || true)
      sz=${TAMANHO:-0}
      if [ -n "$av_kb" ]; then
        if [ $((av_kb * 1024)) -ge $((sz * 3)) ]; then ok "disco livre do Docker no destino $((av_kb / 1024)) MB >= 3x dados"; else fa "disco livre do Docker no destino $((av_kb / 1024)) MB < 3x dados ($((sz * 3 / 1048576)) MB)"; fi
      else av "não consegui medir o disco do Docker no destino"; fi
      if [ -n "$bk_kb" ]; then
        if [ $((bk_kb * 1024)) -ge $((sz * 2)) ]; then ok "disco livre para o dump em $BASE/backups: $((bk_kb / 1024)) MB >= 2x dados"; else fa "disco livre para o dump em $BASE: $((bk_kb / 1024)) MB < 2x dados ($((sz * 2 / 1048576)) MB)"; fi
      else av "não consegui medir o disco de $BASE/backups"; fi
    else fa "root do destino não conectou (confira MYSQL_ROOT_PASSWORD do container ou --destino-senha-arquivo)"; fi
  fi
  printf '\nResumo: %s falha(s), %s aviso(s)\n' "$FALHAS" "$AVISOS"
  [ "$FALHAS" -eq 0 ]
}

# ---------- status ----------
rstatus() {
  local st io sql lag e1 e2 rc=0
  setcont d || morrer "container do destino não achado: ${CANDS:-nenhum}"
  st=$(printf 'SHOW REPLICA STATUS;\n' | hexec d "$(mcmd d '-E')" 2>/dev/null || true)
  if [ -z "$st" ]; then echo "FALHA  o destino não é réplica (SHOW REPLICA STATUS vazio)"; return 1; fi
  g() { printf '%s\n' "$st" | sed -n "s/^ *$1: //p" | head -n1; }
  io=$(g Replica_IO_Running); sql=$(g Replica_SQL_Running); lag=$(g Seconds_Behind_Source)
  e1=$(g Last_IO_Error); e2=$(g Last_SQL_Error)
  echo "IO running:  $io"; echo "SQL running: $sql"; echo "Atraso (s):  ${lag:-NULL}"
  [ -z "$e1" ] || echo "Último erro IO:  $e1"
  [ -z "$e2" ] || echo "Último erro SQL: $e2"
  echo "gtid_executed destino: $(q d 'SELECT @@GLOBAL.gtid_executed' | tr -d '\n' | head -c 300)"
  if [ -n "$OSERV" ] && [ -n "$OSSH" ] && setcont o 2>/dev/null; then
    echo "gtid_executed origem:  $(q o 'SELECT @@GLOBAL.gtid_executed' | tr -d '\n' | head -c 300)"
  fi
  if [ "$io" != Yes ] || [ "$sql" != Yes ]; then rc=1; fi
  if [ -z "$lag" ] || [ "$lag" = NULL ] || ! [[ $lag =~ ^[0-9]+$ ]] || [ "$lag" -gt 60 ]; then rc=1; fi
  if [ "$rc" -eq 0 ]; then echo "OK     réplica saudável"; else echo "FALHA  réplica parada ou atrasada (> 60 s)"; fi
  return $rc
}

# ---------- contagens ----------
contagens() { # lado -> linhas "db.tabela<TAB>n" só das tabelas pequenas (<= LIMITE_CONTAGEM linhas estimadas na origem)
  local lado=$1 lista sql="" db tb first=1 tabs
  lista=$(lista_sql)
  tabs=$(q o "SELECT table_schema,table_name FROM information_schema.tables WHERE table_schema IN ($lista) AND table_type='BASE TABLE' AND COALESCE(table_rows,0)<=$LIMITE_CONTAGEM ORDER BY 1,2") || return 1
  while IFS=$'\t' read -r db tb; do
    [ -n "$db" ] || continue
    [ "$first" = 1 ] || sql="$sql UNION ALL "
    first=0
    sql="${sql}SELECT '$db.$tb', COUNT(*) FROM \`$db\`.\`$tb\`"
  done <<<"$tabs"
  [ -n "$sql" ] || return 0
  q "$lado" "$sql" | sort
}

grandes() { # tabelas grandes: só estimativa (table_rows)
  local lado=$1 lista
  lista=$(lista_sql)
  q "$lado" "SELECT CONCAT(table_schema,'.',table_name,'~',COALESCE(table_rows,0)) FROM information_schema.tables WHERE table_schema IN ($lista) AND table_type='BASE TABLE' AND COALESCE(table_rows,0)>$LIMITE_CONTAGEM ORDER BY 1" | tr '\n' ' '
}

# ---------- copiar usuários da origem ----------
copiar_usuarios() {
  local lista u h sql="" cs gr n=0 pul=0 ex
  lista=$(qr o "SELECT user,host FROM mysql.user WHERE user<>'' AND user<>'root' AND user<>'debian-sys-maint' AND LEFT(user,6)<>'mysql.' AND LEFT(user,5)<>'repl_' ORDER BY 1,2") || { av "não consegui listar usuários da origem"; return 0; }
  while IFS=$'\t' read -r u h; do
    [ -n "$u" ] || continue
    if ! [[ $u =~ ^[A-Za-z0-9_.-]+$ ]] || ! [[ $h =~ ^[A-Za-z0-9_.%:-]+$ ]]; then av "usuário '$u'@'$h' com nome fora do padrão simples; não copiado"; pul=$((pul + 1)); continue; fi
    ex=$(q d "SELECT COUNT(*) FROM mysql.user WHERE user='$u' AND host='$h'" || echo 0)
    if [ "${ex:-0}" -gt 0 ]; then av "usuário '$u'@'$h' já existe no destino; pulado"; pul=$((pul + 1)); continue; fi
    cs=$(qr o "SHOW CREATE USER '$u'@'$h'") || { av "SHOW CREATE USER falhou para '$u'@'$h'; pulado"; pul=$((pul + 1)); continue; }
    gr=$(qr o "SHOW GRANTS FOR '$u'@'$h'") || gr=""
    sql="${sql}$(printf '%s;\n' "$cs")
$(printf '%s\n' "$gr" | sed '/^$/d; s/$/;/')
"
    n=$((n + 1))
  done <<<"$lista"
  if [ "$n" -gt 0 ]; then
    { echo 'SET SESSION sql_log_bin=0;'; printf '%s' "$sql"; } | hexec d "$(mcmd d)" || morrer "falha ao criar os usuários no destino"
  fi
  echo "       usuários copiados da origem: $n (pulados: $pul); excluídos root, mysql.* e repl_*"
}

# ---------- montar ----------
montar() {
  [ "$CONFIRMO" = 1 ] || morrer "montar exige --confirmo (rode 'verificar' e peça o OK do usuário antes)"
  local repl_env repl_pw ru stamp arq dumpcmd opt st conf go gd co cd b arr err tag cur ids n

  passo 1 "verificar"
  verificar || morrer "verificar falhou; nada foi alterado"
  ru=$(repl_usuario)
  if [ -z "$SID" ]; then
    cur=$(q d 'SELECT @@server_id')
    ids=$(q o 'SHOW REPLICAS' | cut -f1 | tr '\n' ' ' || true)
    if [ "${cur:-1}" -gt 1 ] && [ "$cur" != "$OSID" ]; then SID=$cur; else
      while :; do
        SID=$(( ((RANDOM << 15 | RANDOM) % 2000000000) + 2 ))
        if [ "$SID" != "$OSID" ] && ! printf '%s\n' "$ids" | tr ' ' '\n' | grep -qx "$SID"; then break; fi
      done
    fi
  fi
  [ "$SID" != "$OSID" ] || morrer "server-id do destino não pode ser igual ao da origem ($OSID)"

  passo 2 "configurar o destino (server_id=$SID, GTID, relay_log_recovery, skip_replica_start) e reiniciar"
  qe d "SET PERSIST server_id = $SID;" || morrer "falha ao definir server_id"
  qe d "SET PERSIST enforce_gtid_consistency = ON;" || morrer "falha em enforce_gtid_consistency"
  for st in OFF_PERMISSIVE ON_PERMISSIVE ON; do
    if ! err=$(qe d "SET PERSIST gtid_mode = $st;" 2>&1); then
      if printf '%s' "$err" | grep -q '1788'; then echo "       (gtid_mode=$st ignorado: GTID já estava em outro degrau, erro 1788 esperado)"; else
        morrer "SET PERSIST gtid_mode=$st falhou: $err"; fi
    fi
  done
  qe d "SET PERSIST_ONLY relay_log_recovery = ON;" || morrer "falha em relay_log_recovery"
  qe d "SET PERSIST_ONLY skip_replica_start = ON;" || morrer "falha em skip_replica_start"
  hexec d "docker restart -t 120 $DCONT" >/dev/null || morrer "docker restart do destino falhou"
  esperar_mysql d 180 || morrer "destino não voltou em 180 s"
  conf=$(q d 'SELECT @@server_id,@@gtid_mode,@@enforce_gtid_consistency,@@relay_log_recovery,@@skip_replica_start' | tr '\t' ' ')
  [ "$conf" = "$SID ON ON 1 1" ] || morrer "configuração do destino não bateu após reiniciar: '$conf' (esperado '$SID ON ON 1 1')"
  echo "       destino configurado: $conf (server_id gtid_mode enforce relay_log_recovery skip_replica_start)"

  passo 3 "origem: usuário de replicação '$ru' (um por destino, REQUIRE SSL, sem ir para o binlog)"
  repl_env="$BASE/.replicacao/$DSERV.env"
  hexec d "umask 077; mkdir -p '$BASE/.replicacao'; if ! grep -Eq '^REPL_SENHA=[A-Za-z0-9]{32}\$' '$repl_env' 2>/dev/null; then p=\$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32); printf 'REPL_SENHA=%s\n' \"\$p\" > '$repl_env'; fi; chmod 600 '$repl_env'" || morrer "não consegui guardar a senha de replicação no destino"
  repl_pw=$(hexec d "sed -n 's/^REPL_SENHA=//p' '$repl_env' | head -n1")
  [ "${#repl_pw}" -eq 32 ] || morrer "senha de replicação inválida em $repl_env"
  printf "SET SESSION sql_log_bin=0;\nCREATE USER IF NOT EXISTS '%s'@'%%' IDENTIFIED BY '%s' REQUIRE SSL;\nALTER USER '%s'@'%%' IDENTIFIED BY '%s' REQUIRE SSL;\nGRANT REPLICATION SLAVE ON *.* TO '%s'@'%%';\n" "$ru" "$repl_pw" "$ru" "$repl_pw" "$ru" |
    hexec o "$(mcmd o)" || morrer "falha ao criar o usuário $ru na origem"
  echo "       usuário '$ru'@'%' pronto (senha em $repl_env no destino); nenhum outro usuário da origem foi alterado"

  passo 4 "dump da origem (de dentro do container de destino)"
  n=0
  while [ "$(consultas_longas 10)" -gt 0 ]; do
    n=$((n + 1))
    if [ "$SEGUIR_LONGA" = 1 ]; then echo "       (consulta longa na origem; seguindo por --seguir-com-consulta-longa)"; break; fi
    [ "$n" -lt 4 ] || morrer "consulta com mais de 10 s rodando na origem: o dump seguraria as gravações. Abortei antes do dump"
    echo "       consulta longa na origem; esperando 5 s (tentativa $n/3)"; sleep 5
  done
  [ "$(q o "SELECT COUNT(*) FROM performance_schema.processlist WHERE state LIKE 'Waiting for global read lock%'" || echo 0)" -eq 0 ] || morrer "origem com espera de trava global; abortei antes do dump"
  stamp=$(date -u +%Y%m%d-%H%M%S)
  n=$(printf '%s' "$BANCOS" | tr ',' '\n' | grep -c .)
  if [ "$n" -le 3 ]; then tag=${BANCOS//,/+}; else tag="${n}bancos"; fi
  arq="$BASE/backups/${DSERV}-${tag}-$stamp.sql"
  if [ "$TRAVAR" = 1 ]; then opt="--lock-all-tables"; else opt="--single-transaction"; fi
  dumpcmd="IFS= read -r MYSQL_PWD; export MYSQL_PWD; exec mysqldump -h $OHOST -P $PORTA -uroot $opt --source-data=2 --set-gtid-purged=ON --routines --triggers --events --databases ${BANCOS//,/ }"
  hexec o "$(pwcmd)" </dev/null | hexec d "umask 077; mkdir -p '$BASE/backups'; docker exec -i $DCONT sh -c '$dumpcmd' > '$arq.parcial'" ||
    morrer "dump falhou (o parcial, se existir, fica em $arq.parcial no destino)"
  hexec d "tail -c 400 '$arq.parcial' | grep -q 'Dump completed'" || morrer "dump incompleto em $arq.parcial"
  hexec d "if [ -e '$arq' ]; then exit 1; fi; mv '$arq.parcial' '$arq'; chmod 600 '$arq'" || morrer "não consegui finalizar o dump (arquivo $arq já existe?)"
  echo "       dump salvo no destino: $arq (nunca apagar)"

  passo 5 "destino: limpar GTIDs, importar e copiar os usuários da origem"
  if [ "$REFAZER" = 1 ]; then
    qe d "STOP REPLICA;" 2>/dev/null || true
    qe d "RESET REPLICA ALL;" 2>/dev/null || true
    qe d "SET PERSIST super_read_only = OFF;" || true
    qe d "SET PERSIST read_only = OFF;" || true
    IFS=, read -ra arr <<<"$BANCOS"
    for b in "${arr[@]}"; do qe d "DROP DATABASE IF EXISTS \`$b\`;" || morrer "DROP DATABASE $b falhou"; done
  fi
  if ver_ge "$DVERS" 8.4.0; then qe d "RESET BINARY LOGS AND GTIDS;" || morrer "RESET falhou"; else qe d "RESET MASTER;" || morrer "RESET MASTER falhou"; fi
  hexec d "$(mcmd d) < '$arq'" || morrer "import do dump falhou"
  echo "       import concluído"
  copiar_usuarios

  passo 6 "destino: somente leitura"
  qe d "SET PERSIST read_only = ON;" || morrer "read_only"
  qe d "SET PERSIST super_read_only = ON;" || morrer "super_read_only"

  passo 7 "ligar a replicação"
  printf "CHANGE REPLICATION SOURCE TO SOURCE_HOST='%s', SOURCE_PORT=%s, SOURCE_USER='%s', SOURCE_PASSWORD='%s', SOURCE_AUTO_POSITION=1, SOURCE_SSL=1, GET_SOURCE_PUBLIC_KEY=1;\nSTART REPLICA;\n" "$OHOST" "$PORTA" "$ru" "$repl_pw" |
    hexec d "$(mcmd d)" || morrer "CHANGE REPLICATION SOURCE / START REPLICA falhou"
  st=""
  for _ in $(seq 1 30); do
    st=$(q d "SELECT CONCAT((SELECT COALESCE(MAX(service_state),'?') FROM performance_schema.replication_connection_status),'/',(SELECT COALESCE(MAX(service_state),'?') FROM performance_schema.replication_applier_status))" || true)
    [ "$st" = "ON/ON" ] && break
    sleep 2
  done
  [ "$st" = "ON/ON" ] || { rstatus || true; morrer "IO/SQL não ficaram Yes em 60 s"; }
  qe d "RESET PERSIST IF EXISTS skip_replica_start;" || true

  passo 8 "conferência final"
  go=""; gd=""
  for _ in $(seq 1 15); do
    go=$(q o 'SELECT @@GLOBAL.gtid_executed' | tr -d '\n ' || true); gd=$(q d 'SELECT @@GLOBAL.gtid_executed' | tr -d '\n ' || true)
    [ "$go" = "$gd" ] && break
    sleep 2
  done
  if [ "$go" = "$gd" ]; then ok "gtid_executed igual nos dois"; else av "gtid_executed difere (a origem segue gravando)"; fi
  co=$(contagens o || true); cd=$(contagens d || true)
  if [ "$co" = "$cd" ]; then ok "contagem exata de linhas igual nas tabelas até $LIMITE_CONTAGEM linhas"; else
    av "contagem de linhas difere (a origem segue mudando?)"; diff <(printf '%s\n' "$co") <(printf '%s\n' "$cd") | head -n 20 || true; fi
  go=$(grandes o || true); gd=$(grandes d || true)
  if [ -n "$go" ]; then echo "INFO   tabelas grandes, só ESTIMATIVA (table_rows, sem COUNT exato). origem: $go | destino: $gd"; fi
  if ! rstatus; then
    morrer "a réplica NÃO está saudável no fim (veja o status acima). Dump em: $arq"
  fi
  echo
  echo "Réplica montada. Dump em: $arq  | Senha de '$ru' em: $repl_env (host do destino)"
  echo "Próximo: 'status' periódico; se o aviso da porta apareceu, 'bloquear-porta --confirmo'."
}

# ---------- bloquear-porta ----------
bloquear_porta() {
  [ "$CONFIRMO" = 1 ] || morrer "bloquear-porta exige --confirmo"
  acesso_ssh || exit 1
  hexec o "set -e
    iface=\$(ip route show default | awk '{print \$5; exit}')
    [ -n \"\$iface\" ] || { echo 'sem interface default'; exit 1; }
    if iptables -C DOCKER-USER -i \"\$iface\" -p tcp -m conntrack --ctorigdstport $PORTA -j DROP 2>/dev/null; then
      echo \"regra IPv4 já existe em \$iface\"
    else
      iptables -I DOCKER-USER -i \"\$iface\" -p tcp -m conntrack --ctorigdstport $PORTA -j DROP
      echo \"regra IPv4 inserida em \$iface\"
    fi
    if command -v ip6tables >/dev/null 2>&1; then
      if ip6tables -C DOCKER-USER -i \"\$iface\" -p tcp -m conntrack --ctorigdstport $PORTA -j DROP 2>/dev/null; then
        echo \"regra IPv6 já existe em \$iface\"
      elif ip6tables -I DOCKER-USER -i \"\$iface\" -p tcp -m conntrack --ctorigdstport $PORTA -j DROP 2>/dev/null; then
        echo \"regra IPv6 inserida em \$iface\"
      else
        echo 'AVISO: sem chain DOCKER-USER no ip6tables (IPv6 não coberto; confira de fora)'
      fi
    fi
    if command -v netfilter-persistent >/dev/null 2>&1; then netfilter-persistent save >/dev/null && echo 'regras salvas (netfilter-persistent)';
    else echo 'AVISO: instale iptables-persistent (apt install iptables-persistent) e rode netfilter-persistent save, senão a regra some no reboot'; fi
    echo 'Confira DE FORA (outra rede, sem Tailscale) que a porta $PORTA não responde mais'"
}

# ---------- main ----------
[ $# -ge 1 ] || { uso; exit 2; }
SUB=$1; shift
while [ $# -gt 0 ]; do
  case "$1" in
    --origem-ssh) OSSH=$2; shift 2 ;;
    --origem-servico) OSERV=$2; shift 2 ;;
    --destino-ssh) DSSH=$2; shift 2 ;;
    --destino-servico) DSERV=$2; shift 2 ;;
    --banco) BANCOS=$2; shift 2 ;;
    --origem-host) OHOST=$2; shift 2 ;;
    --porta) PORTA=$2; shift 2 ;;
    --server-id) SID=$2; shift 2 ;;
    --origem-senha-arquivo) OPWF=$2; shift 2 ;;
    --destino-senha-arquivo) DPWF=$2; shift 2 ;;
    --travar-tudo) TRAVAR=1; shift ;;
    --refazer) REFAZER=1; shift ;;
    --confirmo) CONFIRMO=1; shift ;;
    --seguir-com-consulta-longa) SEGUIR_LONGA=1; shift ;;
    -h|--ajuda|--help) uso; exit 0 ;;
    *) morrer "opção desconhecida: $1" ;;
  esac
done
validar
case "$SUB" in
  ssh) [ -n "$OSSH$DSSH" ] || morrer "falta --origem-ssh e/ou --destino-ssh"; acesso_ssh ;;
  verificar) exigir OSSH OSERV DSSH DSERV; verificar ;;
  montar) exigir OSSH OSERV DSSH DSERV; montar ;;
  status) exigir DSSH DSERV; rstatus ;;
  bloquear-porta) exigir OSSH; bloquear_porta ;;
  *) uso; exit 2 ;;
esac
