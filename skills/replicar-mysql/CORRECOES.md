# Correções — replicar-mysql

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F — `skill-update/playbook.md`, “Registrar correção”).
> Sem dado de cliente: descrever o padrão, não o produto. Mais recente em cima.

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde na skill |
|------|--------------------|-------|---------------------|---------------|
| 2026-10-25 | SSH para IP `100.x` dava só "servidor não respondeu" | A máquina que roda a skill não estava no Tailscale (ou estava sem login); o texto apontava para firewall/IP | `aviso_tailscale_local`: em falha de rede para IP 100.64.0.0/10, diz se a máquina não tem o Tailscale (como instalar), se está desligado/sem login ou se o servidor não aparece na conta; pré-requisito no SKILL.md | `scripts/replicar-mysql.sh` (`aviso_tailscale_local`, `checar_ssh`), `SKILL.md` (pré-requisitos) |
| 2026-10-25 | A skill tratava a chave SSH como pré-requisito manual e só dizia "SSH falhou" | O usuário não sabia qual chave pôr nos servidores; o script não ajudava | Subcomando `ssh`: testa o acesso, gera a chave desta máquina se faltar (nunca sobrescreve), imprime a chave pública e o comando para colar no servidor; distingue rede x permissão; `verificar`, `montar` e `bloquear-porta` rodam a checagem primeiro | `scripts/replicar-mysql.sh` (`ssh`, `checar_ssh`), `SKILL.md` (passo 2 do fluxo, lista de pré-requisitos, tabela de etapas) |
