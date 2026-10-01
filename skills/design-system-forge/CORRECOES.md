# Correções — design-system-forge

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F — `skill-update/playbook.md`, “Registrar correção”).
> Sem dado de cliente: descrever o padrão, não o produto. Mais recente em cima.

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde na skill |
|------|--------------------|-------|---------------------|---------------|
| 2026-09-30 | Arquivo do canvas sobrescrito com uma versão antiga; várias rodadas aprovadas tiveram de ser refeitas a partir dos prints | Duas janelas do editor com o mesmo arquivo; edição sem cópia; ninguém conferia se o arquivo mudou no disco | Arquivo protegido: cópia com data antes e depois da rodada, um só editor, conferir o disco | `canvas-ferramentas.md` (Cuidados gerais) · Método de execução, linha C |
| 2026-09-30 | Texto do botão principal (claro × escuro) só foi decidido quando as telas já existiam, e a cor da marca teve de mudar | O roteiro só pedia medir contraste, não levar a escolha ao humano antes dos componentes | Comparação lado a lado no passo 4, antes dos componentes | `roteiro.md` passo 4 |
| 2026-09-30 | Destaque do “melhor” feito em vermelho, que passa sensação de alerta | Regra de cor de domínio não dizia que positivo é da família da marca | Cor do melhor = família da marca; vermelho só para o ruim | `roteiro.md` passo 4 |
| 2026-09-30 | Inventário de componentes feito olhando um quadro só (contou 25 onde um quadro tinha 70) | Auditoria por amostra | Abrir todos os quadros antes de contar | `roteiro.md` passo 19 · Método de execução, linha C |
| 2026-09-30 | Grade e tela-prova exigiam celular num produto que o humano definiu como só computador | Template supunha sempre as duas superfícies | Cada superfície que o produto tem; registrar quando é só uma | `template-design-system.md` (Grid e margens) |
| 2026-09-26 | A IA do canvas criou de 70 a 80 componentes quando o pedido era o essencial | Sem lista fechada antes de construir | Lista fechada por faixa antes do canvas | `catalogo-componentes.md` · `roteiro.md` passo 12 |
