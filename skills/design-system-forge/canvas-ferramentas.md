# Ferramenta de canvas — opções de conexão

> Usado pelo **Forge** (Parte C) e pelo **Apply** (varredura e correção de telas). O roteiro não depende de uma ferramenta.  
> **Padrão da casa:** Pencil. Construtor de app com IA (ex.: Lovable) fica como opção secundária para projetos antigos.

## Opções

| Opção | Quando usar | Como conectar | Cuidados |
|-------|-------------|---------------|----------|
| **Ferramenta local, agente na mesma máquina** | Pessoa e agente no mesmo computador | Servidor MCP da ferramenta configurado direto no editor | Ferramenta aberta com o arquivo certo |
| **Ferramenta local, agente remoto** | Ferramenta no computador da pessoa; agente numa máquina remota | Ponte + túnel (detalhe abaixo) | Fechar ponte e túnel ao terminar |
| **Ferramenta na nuvem com MCP oficial** | Ferramenta web que oferece servidor MCP próprio | Configurar a URL e a autenticação do MCP no editor | Permissão de edição no arquivo; limite de uso da conta |
| **Construtor de app como canvas** (secundário) | Projeto antigo cujas telas vivem num construtor de app com IA | Ferramenta ou API do construtor | Tela vira código: separar Oficial × Rascunho por página ou projeto; tokens no tema do app |
| **Sem conexão direta** | Ferramenta sem MCP ou sem acesso do agente | Pessoa exporta prints ou o arquivo; agente lê e devolve instruções | Agente não edita; cada rodada depende da pessoa |

## Detalhe — ferramenta local, agente remoto

- **Ponte no computador local:** expor o servidor MCP da ferramenta de design numa porta (ex.: `npx -y supergateway --stdio "<comando do servidor MCP>" --port <porta>`).
- **Túnel:** levar a porta até a máquina remota (ex.: `ssh -R <porta>:127.0.0.1:<porta> <máquina>`).
- **Teste na máquina remota:** `curl -s -N --max-time 4 -H "Accept: text/event-stream" http://127.0.0.1:<porta>/sse` deve devolver `event: endpoint`.
- **Editor não vê a ferramenta mesmo com o túnel no ar:** recarregar a janela ou desligar e ligar o servidor MCP nas configurações.
- **Fechar ao terminar:** encerrar a ponte e o túnel.

## Cuidados gerais no canvas

- **Evidência:** print de cada prancha/tela depois de editar (a varredura do Apply usa esses prints).
- **Peças criadas que não aparecem no print:** copiar a prancha inteira e apagar a original costuma fazer o desenho aparecer (a cópia é a mesma peça — não é perda de conteúdo).
- **Tamanho real:** telas no tamanho da superfície (ex.: 1440 computador, 375 celular, popup de extensão com largura fixa e altura máxima da plataforma).
- **Sem conexão:** Parte C do Forge e Fase C do Apply ficam **bloqueadas** — reportar e pedir a conexão; não fingir edição.
