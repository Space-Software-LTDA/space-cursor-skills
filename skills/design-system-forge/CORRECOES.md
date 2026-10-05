# Correções — design-system-forge

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F — `skill-update/playbook.md`, “Registrar correção”).
> Sem dado de cliente: descrever o padrão, não o produto. Mais recente em cima.

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde na skill |
|------|--------------------|-------|---------------------|---------------|
| 2026-10-04 | Foco na cor principal em volta de Cancelar e do botão destrutivo — o humano achou péssimo | Matriz de estados usava um anel de foco só | Botão neutro e destrutivo: foco na cor de erro; mouse do Cancelar neutro | `roteiro.md` passo 13 |
| 2026-10-04 | Cartões de indicador lado a lado com metade vazia | Altura igualada ao vizinho sem conteúdo | Um cartão de resumo com colunas e linhas de apoio | `catalogo-componentes.md` (Regras de domínio) |
| 2026-10-04 | “Tabela vira cartão no celular” decidido, mas o componente não existia no canvas | Decisão registrada sem peça | Decisão de superfície só fecha com o componente desenhado | `catalogo-componentes.md` (Regras de domínio) |
| 2026-10-04 | Símbolo dentro de um selo com borda ganhou borda própria (borda dupla) | Ícone e selo tratados como peças separadas | Mesmo elemento: sem texto = círculo; com texto = pílula; símbolo dentro sem borda | `roteiro.md` passo 3 |
| 2026-10-04 | Essência proibia “contagem regressiva” e a validade de um pagamento ficou sem o tempo restante | Proibição sem distinguir urgência × informação | Contagem de validade é informação e pode aparecer; urgência de venda segue proibida | `roteiro.md` passo 2 |
| 2026-10-04 | Logo do meio de pagamento ia ser desenhado à mão | Sem regra para ícones de terceiros | Ícone oficial (biblioteca de marcas), cor única, só como indicador | `catalogo-componentes.md` (Regras de domínio) |
| 2026-10-04 | Tentativa de recuperar desenho antigo lendo a cópia datada pela ferramenta devolveu o arquivo aberto; dois agentes no mesmo arquivo mudaram IDs | Armadilhas do Pencil não registradas | Novas linhas em armadilhas do Pencil | `canvas-ferramentas.md` (Pencil) |
| 2026-10-04 | Versões divergentes entre documento, pranchas, tokens e capturas | Sem regra de carimbo | Versão única nos quatro lugares | `roteiro.md` (Versão única) |
| 2026-09-30 | Arquivo do canvas sobrescrito com uma versão antiga; várias rodadas aprovadas tiveram de ser refeitas a partir dos prints | Duas janelas do editor com o mesmo arquivo; edição sem cópia; ninguém conferia se o arquivo mudou no disco | Arquivo protegido: cópia com data antes e depois da rodada, um só editor, conferir o disco | `canvas-ferramentas.md` (Cuidados gerais) · Método de execução, linha C |
| 2026-09-30 | Texto do botão principal (claro × escuro) só foi decidido quando as telas já existiam, e a cor da marca teve de mudar | O roteiro só pedia medir contraste, não levar a escolha ao humano antes dos componentes | Comparação lado a lado no passo 4, antes dos componentes | `roteiro.md` passo 4 |
| 2026-09-30 | Destaque do “melhor” feito em vermelho, que passa sensação de alerta | Regra de cor de domínio não dizia que positivo é da família da marca | Cor do melhor = família da marca; vermelho só para o ruim | `roteiro.md` passo 4 |
| 2026-09-30 | Inventário de componentes feito olhando um quadro só (contou 25 onde um quadro tinha 70) | Auditoria por amostra | Abrir todos os quadros antes de contar | `roteiro.md` passo 19 · Método de execução, linha C |
| 2026-09-30 | Grade e tela-prova exigiam celular num produto que o humano definiu como só computador | Template supunha sempre as duas superfícies | Cada superfície que o produto tem; registrar quando é só uma | `template-design-system.md` (Grid e margens) |
| 2026-09-26 | A IA do canvas criou de 70 a 80 componentes quando o pedido era o essencial | Sem lista fechada antes de construir | Lista fechada por faixa antes do canvas | `catalogo-componentes.md` · `roteiro.md` passo 12 |
