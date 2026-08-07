# Prints e referências visuais (UI / Frontend)

## Regra

Tarefas com **Frontend**, **alteração de tela** ou **protótipo visual** devem incluir **prints de referência** para o dev saber exatamente o alvo.

Diagramas de fluxo continuam em [diagrams.md](diagrams.md) (mermaid.ink). **Prints de UI** seguem este arquivo.

---

## Repositório de hospedagem (padrão do agente)

**Repo:** [Space-Software-LTDA/space-assets](https://github.com/Space-Software-LTDA/space-assets) (público)

**Clone local:** `c:\Users\space\Documents\BATEU\space-assets`

**URL base para ClickUp:**

```
https://raw.githubusercontent.com/Space-Software-LTDA/space-assets/main/{projeto}/{task-slug}/{arquivo}.png
```

O agente **salva, commita e dá push** neste repo — o markdown da task já sai com URLs públicas, pronto para colar no ClickUp.

---

## Quando é obrigatório

| Situação | Prints? |
|---|---|
| Tarefa envolve Frontend (total ou parcial) | **Sim** |
| Usuário enviou print no chat | **Sim** — incorporar na task |
| Existe link de protótipo (Lovable, Figma, staging) | **Sim** — capturar ou pedir print |
| Só Backend sem impacto visual | Não (diagrama basta se houver fluxo) |
| Usuário colou print só para explicar contexto | Incorporar se for alvo da entrega |

---

## Fontes de print (ordem de prioridade)

1. **Prints enviados pelo usuário no chat** — copiar para `space-assets` e referenciar na task
2. **Protótipo via URL** — acessar com browser (MCP), capturar telas relevantes
3. **App local/staging** — screenshot se URL acessível
4. **Fallback** — link do protótipo + lista do que capturar; pedir prints ao PO se bloqueado (login, paywall)

---

## Onde salvar

### 1. space-assets (obrigatório para tasks com UI)

```
space-assets/
└── {projeto}/                    # ex.: bateu, monitor, spacepay
    └── {task-slug}/              # ex.: pixels-platform-affiliate
        ├── 01-listagem.png
        ├── 02-formulario.png
        └── 03-combobox-afiliado.png
```

**Convenção de nomes:** `{ordem}-{tela-ou-estado}.png` — ordem cronológica ou de fluxo.

### 2. task/assets no repo do projeto (opcional, cópia local)

Espelhar em `task/assets/{task-slug}/` se a task `.md` ficar no repo do projeto — útil para revisão offline. **URLs no markdown usam sempre space-assets.**

---

## Markdown na task (URLs públicas)

```markdown
## 🖼️ Referência visual

**Protótipo:** [Lovable — Pixels](https://bateu-datalake-exemple.lovable.app/pixels)

### Listagem de cards
![Listagem de pixels com ícones por plataforma](https://raw.githubusercontent.com/Space-Software-LTDA/space-assets/main/bateu/pixels-platform-affiliate/01-listagem.png)

### Formulário — combobox afiliado
![Combobox com opção Adicionar ID novo](https://raw.githubusercontent.com/Space-Software-LTDA/space-assets/main/bateu/pixels-platform-affiliate/03-combobox-afiliado.png)
```

Sempre incluir **link do protótipo** como backup interativo.

---

## Hospedagem para o ClickUp

| Opção | Quem faz | Quando |
|---|---|---|
| **space-assets + push** | Agente | **Padrão** — markdown pronto com `![](raw.githubusercontent.com/...)` |
| Arrastar PNG no ClickUp | PO | Fallback se push falhar ou imagem não puder ir pro repo |
| Link do protótipo | Agente | Sempre, além dos prints |

### O que NÃO funciona no ClickUp

| Abordagem | Funciona? |
|---|---|
| `![](C:\Users\...)` | Não |
| `![](assets/foo.png)` sem URL pública | Não ao colar só o .md |
| Print só no chat do Cursor | Não — dev não vê; precisa ir para space-assets |
| mermaid.ink para UI | Não — só diagramas; UI = screenshot real |
| Repo privado sem auth | Não — imagem quebrada para o time |

---

## Fluxo do agente ao criar task Front

```
1. Identificar projeto, URLs de protótipo / prints do usuário
2. Se URL → browser: navegar, screenshot das telas-chave
3. Se usuário enviou imagem → copiar para space-assets/{projeto}/{slug}/
4. git add, commit, push em space-assets
5. Escrever task.md com seção 🖼️ Referência visual (URLs raw.githubusercontent.com)
6. Legendar cada print (o que mostra, o que mudou vs código atual)
7. Manter link do protótipo
```

**Telas mínimas a capturar (quando aplicável):**

- Listagem / overview
- Formulário completo
- Estados especiais (dropdown aberto, empty state, erro, loading)
- Detalhe / header com badges
- Antes vs depois (se houver código legado visível)

---

## Prints enviados pelo usuário no chat

1. Arquivos ficam em `assets/` do workspace do Cursor
2. **Copiar** para `space-assets/{projeto}/{task-slug}/` com nome descritivo
3. Push no space-assets
4. Referenciar na task com URL pública — **não** depender só do anexo da conversa

---

## Checklist de prints

- [ ] Tarefa Front tem seção 🖼️ Referência visual
- [ ] Cada print tem legenda (não só imagem solta)
- [ ] PNGs em `space-assets/{projeto}/{slug}/` com push feito
- [ ] URLs `raw.githubusercontent.com/Space-Software-LTDA/space-assets/...` na task
- [ ] Link do protótipo incluído
- [ ] Nenhum caminho absoluto do Windows no markdown
