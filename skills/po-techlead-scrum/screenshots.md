# Prints e referências visuais (UI / Frontend)

## Regra

Tarefas com **Frontend**, **alteração de tela** ou **protótipo visual** devem incluir **prints de referência** para o dev saber exatamente o alvo.

Diagramas de fluxo continuam em [diagrams.md](diagrams.md) (mermaid.ink). **Prints de UI** seguem este arquivo.

---

## Repositório de hospedagem (padrão do agente)

**Repo:** [Space-Software-LTDA/space-assets](https://github.com/Space-Software-LTDA/space-assets) (público)

**Clone:** clone local de [space-assets](https://github.com/Space-Software-LTDA/space-assets) nesta máquina (não amarrar a pasta de um produto).

**URL base para ClickUp:**

```
https://raw.githubusercontent.com/Space-Software-LTDA/space-assets/main/{projeto}/{task-slug}/{arquivo}.png
```

O agente **salva, commita e dá push** neste repo — o markdown **local** (`.task/`) usa essas URLs. No **corpo ClickUp publicado**, o script reescreve para URL de **attachment**.

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

**Protótipo:** [URL do protótipo desta task](https://…)

### {tela 1}
![{o que observar}](https://raw.githubusercontent.com/Space-Software-LTDA/space-assets/main/{projeto}/{task-slug}/01-….png)

### {tela 2}
![{o que observar}](https://raw.githubusercontent.com/Space-Software-LTDA/space-assets/main/{projeto}/{task-slug}/02-….png)
```

Sempre incluir **link do protótipo** como backup interativo.

---

## Hospedagem para o ClickUp

Dois papéis distintos:

| Papel | Onde | Para quê |
|---|---|---|
| **Backup / markdown local** | space-assets (`raw.githubusercontent.com/…`) | `.task/*.md` no disco do PO; histórico no Git |
| **Corpo da task ClickUp** | URL do **attachment** da própria task | ClickUp renderiza inline de forma confiável |

### Fluxo de publicação (obrigatório)

1. Prints em space-assets (push) — markdown local usa essas URLs
2. Ao criar/atualizar a task: **anexar** cada PNG na task via API
3. Reescrever o corpo com `![](attachment-url)` e gravar em **`markdown_content`** (nunca `<img>`, nunca o campo `markdown_description`)
4. O script `clickup_create_task.py` faz anexar + reescrever automaticamente

```markdown
![Listagem](https://t9013….p.clickup-attachments.com/t9013…/uuid/01-listagem.png)
```

| Opção | Quem faz | Quando |
|---|---|---|
| **Attachment ClickUp + URL de attachment** | Agente (script) | **Padrão no corpo ClickUp** |
| space-assets + push | Agente | Markdown local + backup |
| Arrastar PNG no ClickUp | PO | Fallback manual |
| Link do protótipo | Agente | Sempre, além dos prints |

### O que NÃO funciona bem no corpo ClickUp

| Abordagem | Funciona? |
|---|---|
| `![](C:\Users\...)` | Não |
| `![](assets/foo.png)` relativo | Não |
| Só `![](raw.githubusercontent.com/…)` | **Instável** — ClickUp costuma stripar/não renderizar |
| Só `![](mermaid.ink/…)` | **Instável** — mesma limitação (diagramas: ver [diagrams.md](diagrams.md)) |
| `<img>` / `<p><img>` no corpo | **Não** — a UI mostra as tags como texto |
| Gravar em `markdown_description` | **Não** — campo de leitura. Escrita = `markdown_content` |
| `![](attachment da própria task)` via `markdown_content` | **Sim** — formato do Estruturador |
| Print só no chat do Cursor | Não — anexar na task |
| Repo privado sem auth | Não |

---

## Fluxo do agente ao criar task Front

```
1. Identificar projeto, URLs de protótipo / prints do usuário
2. Se URL → browser: navegar, screenshot das telas-chave
3. Se usuário enviou imagem → copiar para space-assets/{projeto}/{slug}/
4. git add, commit, push em space-assets
5. Escrever task.md com seção 🖼️ Referência visual (URLs space-assets no .md local)
6. Legendar cada print (o que mostra, o que mudou vs código atual)
7. Ao publicar: clickup_create_task.py anexa PNGs e grava `![](attachment-url)` em markdown_content
8. Manter link do protótipo
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
4. Na publicação ClickUp, anexar o mesmo PNG e usar URL do attachment no corpo

---

## Checklist de prints

- [ ] Tarefa Front tem seção 🖼️ Referência visual
- [ ] Cada print tem legenda (não só imagem solta)
- [ ] PNGs em `space-assets/{projeto}/{slug}/` com push feito
- [ ] Markdown **local** com URLs space-assets
- [ ] Corpo **ClickUp** com URL de attachment (não depender só de raw.githubusercontent)
- [ ] Link do protótipo incluído
- [ ] Nenhum caminho absoluto do Windows no markdown
