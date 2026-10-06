# Modelo-alvo — Fase 7 Design System

> Vivo: `docs/DESIGN_SYSTEM.md` (+ tokens + EXTRACTION_NOTES) + canvas (manual da marca, Fundamentos, componentes)  
> Barra da fase: **nível essencial** da skill **`design-system-forge`** (`nivel-ouro.md`) + aceite do Forge + confronto com o gosto. Ouro = opcional, a pedido do cliente.  
> **Densidade do documento (anexo real):** [`examples/anexos/spacebet-pixreals-DESIGN_SYSTEM.md`](examples/anexos/spacebet-pixreals-DESIGN_SYSTEM.md)  
> **Saída no canvas (anexo real, nível essencial):** [`examples/anexos/buscai-design-system.pen`](examples/anexos/buscai-design-system.pen) (manual da marca · Fundamentos escuro e claro · Componentes escuro e claro) + um PNG de cada prancha ao lado (`buscai-manual-da-marca.png`, `buscai-fundamentos-{escuro,claro}.png`, `buscai-componentes-{escuro,claro}.png`)  
> **Formato visual (anexo real, referência do ouro):** [`examples/anexos/bateubet-design-system-estrutura.md`](examples/anexos/bateubet-design-system-estrutura.md) (8 capítulos · 13 slides de componentes · matriz de estados)  
> Densidade: [`examples/density-reference.md`](examples/density-reference.md)  
> Passagem de bastão da fase: [`reference-forge-handoff.md`](reference-forge-handoff.md)

## Fontes (genéricas)

| Fonte | Papel |
|-------|-------|
| `design-system-forge` | Método, roteiro, modos Extrair/Criar, perguntas Q1–Q19, aceite (camadas 0–5), confronto com o gosto, veredito, essencial/ouro, canvas |
| `examples/anexos/spacebet-pixreals-*` | **Densidade da saída** — resultado real do Forge (só estrutura; **não** colar cores) |
| `examples/anexos/buscai-design-system.pen` + `buscai-*.png` | **Saída no canvas** (PNG = imagem de cada prancha) — resultado real do Forge aprovado pelo cliente: prancha da marca, Fundamentos (variáveis em uso), componentes oficiais (só estrutura; **não** colar cor nem logo) |
| `examples/anexos/bateubet-design-system-estrutura.md` (o PDF, 37 MB, fica fora do pacote — pedir ao humano se precisar das imagens) | **Formato de entrega visual** — ordem dos capítulos + cobertura de componentes (só estrutura; **não** colar cor nem fonte) |
| `examples/anexos/{carbon,atlassian,polaris,…}` | Teoria (token, papel, superfície, escala) |
| [`reference-space-constitution.md`](reference-space-constitution.md) | Caminhos do `design-system.md` e do `ui-gosto` da Space — **método**, não cor do produto |
| `docs/prototipo.md` + `mvp.md` + `setup.md` do produto | Superfícies e fluxos a cobrir |
| Fontes visuais (URL / construtor / prints / código / canvas) | Evidência do diagnóstico (modo Extrair) |

**Proibido:** inventar “exemplo ilustrativo”; copiar cores do anexo de referência, de Carbon ou da Space como padrão do produto.

## Mínimos da fase

1. Diagnóstico do Forge não bloqueado (ou rascunho parcial autorizado pelo cliente)  
2. Três artefatos em `docs/` + canvas com prancha da marca, variáveis, prancha de Fundamentos e componentes (nível essencial)  
3. Seções do template presentes (fundamentos não colapsados), incluindo lista de componentes por faixa + matriz de estados  
4. Aceite do Forge aprovado **ou** REPROVADO honesto com a lista de buracos  
5. Confronto com o gosto registrado + veredito no chat + pergunta sobre ouro  
6. Superfícies do setup e do protótipo cobertas (site / extensão / janelas, conforme o caso) — **lei Polaris**  
7. Gate do produto: fechado | adiado com risco | bloqueado  
8. Confirmado · Hipótese · Aberto (nas EXTRACTION_NOTES / cabeçalho do Design System)  
9. O agente abriu o `nivel-ouro.md` do Forge (tabela do essencial) + o anexo de densidade + o canvas real + pelo menos um anexo de teoria antes de declarar a barra

## Critérios de aceitação

| # | CA | Barra | Inspirado em |
|---|-----|-------|--------------|
| DS1 | `docs/DESIGN_SYSTEM.md` existe | Template completo, não um mural de referências | Primer |
| DS2 | `docs/tokens.dtcg.json` espelha os fundamentos | Elevação separada de movimento; cada token tem papel | Atlassian / Lightning |
| DS3 | `EXTRACTION_NOTES` tem diagnóstico + perguntas + aceite | | Forge |
| DS4 | Cor principal e superfícies com evidência ou OK do cliente | Nada inventado em silêncio | — |
| DS5 | Fundamentos F1–F8 + componentes com **estados** | Aceite do Forge | Estados de interação do Carbon |
| DS6 | Padrões de tela `P-…` A–D/F como lei | Mesmo que a tela ainda não exista | — |
| DS7 | Superfícies do setup cobertas (site / extensão / …) | Ou “não se aplica” com motivo | **Polaris multi-superfície** |
| DS8 | Sem contradição (fora da escala, duas cores principais, alerta ≈ marca) | Papéis semânticos | Papéis Atlassian |
| DS9 | Veredito = PASS / PASS COM RESSALVAS / REPROVADO | Sem aprovação falsa | Primer |
| DS10 | Gate da fase gravado; telas **não** feitas nesta fase (é a Fase 8) | | |
| DS11 | O tema troca **valores**, não nomes de papel | Se houver mais de um tema | Temas do Carbon |
| DS12 | Densidade e escala definidas para extensão × página | Se houver as duas superfícies | Escala de plataforma do Spectrum |
| DS13 | Canvas: só componentes oficiais, cores por variável, versões antigas no rascunho (nada apagado) | Forge, camada 5 | — |
| DS14 | Confronto com o gosto (geral + tipo do produto) antes do veredito | Forge, etapa 5 | `ui-gosto.md` |
| DS15 | Regra de contraste escrita (4.5:1 texto normal; 3:1 texto grande, bordas de campo, ícones usáveis, foco) | Forge Q19 | WCAG |
| **DS.CL** | **CL0–CL5** no corpo do `DESIGN_SYSTEM.md` | `shared/docs-clarity.md` — sem `qtd.` / “não inventar” / títulos de prompt no documento vivo |

## Anti-padrões

| Anti-padrão | Sintoma | Contraexemplo |
|-------------|---------|---------------|
| Inventário das telas atuais = Design System | Neon, brilho e cores do rascunho viram lei | Primer: intenção coesa primeiro |
| Segundo roteiro no módulo | Playbook repete os passos do Forge e desalinha | O `roteiro.md` do Forge é o único roteiro |
| Ouro forçado por padrão | Fase travada esperando PDF / segundo tema | Essencial primeiro; ouro a pedido |
| Cores coladas de Space / Carbon | Produto com cara de outra marca | Atlassian: significado acima de copiar cor |
| AGENT magro | “Chama o Forge” sem critério da fase nem superfícies | Este modelo-alvo |
| Pular o diagnóstico | Design System só a partir do brief | — |
| Colapsar §6–8 | Um tópico para cor, tipografia e espaço | Profundidade do guia de cor do Carbon |
| Telas feitas escondido | Telas corrigidas ou redesenhadas durante o Forge | — |
| Renomear sem eco | Inventa `P-…` a partir de áudio | — |
| Ignorar a extensão | Só a barra do site | Polaris: subconjunto por superfície |
| PASS falso | Ressalvas escondidas | Primer: meia medida = nada |
| “Exemplo ilustrativo” inventado | Design System de marca falsa na skill | Abrir os anexos reais |
| Cores do anexo de referência coladas | Produto com a cara de outro produto | Só a estrutura do anexo |
| Meta de conversa no documento | “A DEFINIR — não inventar heatmap” como nota do agente | Português: “ainda não definido” |
