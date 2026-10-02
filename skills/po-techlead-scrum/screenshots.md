# Prints e referências visuais (UI / Frontend)

## Regra

Tarefas com **Frontend**, **alteração de tela** ou **protótipo visual** devem incluir **prints de referência** para o dev saber exatamente o alvo.

Diagramas de fluxo continuam em [diagrams.md](diagrams.md) (mermaid.ink). **Prints de UI** seguem este arquivo.

---

## Hospedagem: anexo direto na task (padrão)

Imagem de task ClickUp **não vai para repositório** (nem space-assets, nem repo do projeto). O PNG fica **local**, na pasta de artefatos da task, e na publicação o script **anexa direto na task** e troca o link pela URL do attachment.

- **Local:** `.task/{projeto}/assets/{task-slug}/{arquivo}.png` (`.task/` já está no `.gitignore`)
- **No `.md` local:** caminho **relativo** à pasta do `.md` — `![…](assets/{task-slug}/01-tela.png)` (abre no preview do Cursor)
- **Na publicação:** `clickup_create_task.py` resolve o caminho relativo a partir da pasta do `.md`, anexa e grava `![](attachment-url)` em `markdown_content`

**space-assets** ([Space-Software-LTDA/space-assets](https://github.com/Space-Software-LTDA/space-assets), público) é **opcional**: só quando a imagem precisa de URL pública **fora** do ClickUp (ex.: README, doc externa). Nunca é pré-requisito para publicar task.

> Erro que originou a regra: tasks com link `raw.githubusercontent` para uma pasta do space-assets que nunca recebeu push — imagens quebradas no ClickUp. Ver [CORRECOES.md](CORRECOES.md).

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

1. **Prints enviados pelo usuário no chat** — copiar para `assets/{task-slug}/` da task e referenciar na task
2. **Protótipo via URL** — acessar com browser (MCP), capturar telas relevantes
3. **App local/staging** — screenshot se URL acessível
4. **Fallback** — link do protótipo + lista do que capturar; pedir prints ao PO se bloqueado (login, paywall)

---

## Onde salvar

```
.task/{projeto}/
├── {task-slug}.md                # a task (ver "Onde gravar artefatos" no SKILL.md)
└── assets/
    └── {task-slug}/
        ├── 01-listagem.png
        ├── 02-formulario.png
        └── 03-combobox-afiliado.png
```

O caminho é relativo à pasta do `.md`: `assets/{task-slug}/01-listagem.png`. Se o `.md` estiver numa subpasta (ex.: entregas de uma sprint em `tasks/`), suba o nível: `../assets/{task-slug}/01-listagem.png`.

**Convenção de nomes:** `{ordem}-{tela-ou-estado}.png` — ordem cronológica ou de fluxo. Nome **único** dentro da task: o script casa anexo por nome de arquivo.

---

## Markdown na task

```markdown
## 🖼️ Referência visual

**Protótipo:** [URL do protótipo desta task](https://…)

### {tela 1}
![{o que observar}](assets/{task-slug}/01-….png)

### {tela 2}
![{o que observar}](assets/{task-slug}/02-….png)
```

Sempre incluir **link do protótipo** como backup interativo.

---

## Hospedagem para o ClickUp

| Papel | Onde | Para quê |
|---|---|---|
| **Markdown local** | `assets/{task-slug}/` na pasta do `.md` (caminho relativo) | `.task/*.md` no disco do PO |
| **Corpo da task ClickUp** | URL do **attachment** da própria task | ClickUp renderiza inline de forma confiável |

### Fluxo de publicação (obrigatório)

1. PNGs em `assets/{task-slug}/` da task — markdown local com caminho relativo
2. Ao criar/atualizar a task: o script **anexa** cada PNG referenciado (resolve o relativo pela pasta do `.md`; `--attach <png>` também funciona e casa pelo nome)
3. Reescreve o corpo com `![](attachment-url)` e grava em **`markdown_content`** (nunca `<img>`, nunca o campo `markdown_description`)
4. **Conferir o publicado:** baixar a descrição e garantir **zero** `raw.githubusercontent`, `mermaid.ink` ou caminho local nas imagens. O script só avisa (`WARN`) quando não acha o arquivo — não falha

```markdown
![Listagem](https://t9013….p.clickup-attachments.com/t9013…/uuid/01-listagem.png)
```

| Opção | Quem faz | Quando |
|---|---|---|
| **Attachment ClickUp + URL de attachment** | Agente (script) | **Padrão no corpo ClickUp** |
| space-assets + push | Agente | **Opcional** — só se precisar de URL pública fora do ClickUp |
| Arrastar PNG no ClickUp | PO | Fallback manual |
| Link do protótipo | Agente | Sempre, além dos prints |

### O que NÃO funciona bem no corpo ClickUp

| Abordagem | Funciona? |
|---|---|
| `![](C:\Users\...)` | Não |
| `![](assets/foo.png)` relativo **sem passar pelo script** | Não (com o script vira attachment) |
| Só `![](raw.githubusercontent.com/…)` | **Instável** — ClickUp costuma stripar/não renderizar; quebra se o push não aconteceu |
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
3. Se usuário enviou imagem → copiar para .task/{projeto}/assets/{task-slug}/
4. Escrever task.md com seção 🖼️ Referência visual (caminho relativo assets/{task-slug}/…)
5. Legendar cada print (o que mostra, o que mudou vs código atual)
6. Ao publicar: clickup_create_task.py anexa PNGs e grava `![](attachment-url)` em markdown_content
7. Baixar o publicado e conferir que toda imagem virou attachment
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
2. **Copiar** para `.task/{projeto}/assets/{task-slug}/` com nome descritivo
3. Na publicação ClickUp, o script anexa o PNG e usa a URL do attachment no corpo

---

## Checklist de prints

- [ ] Tarefa Front tem seção 🖼️ Referência visual
- [ ] Cada print tem legenda (não só imagem solta)
- [ ] PNGs em `.task/{projeto}/assets/{task-slug}/` (sem push em repositório)
- [ ] Markdown **local** com caminho relativo `assets/{task-slug}/…`
- [ ] Corpo **ClickUp** conferido depois de publicar: toda imagem é URL de attachment (zero raw.githubusercontent / mermaid.ink / caminho local)
- [ ] Link do protótipo incluído
- [ ] Nenhum caminho absoluto do Windows no markdown
