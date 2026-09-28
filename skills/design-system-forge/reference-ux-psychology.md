# Reference — UX Psychology → Design System

Fonte canônica: [Laws of UX](https://lawsofux.com/) · machine: https://lawsofux.com/llms.txt  
Usar ao preencher §2 e o campo **Porquê** de cada token/componente.

## Como citar

```
Porquê: Fitts’s Law — alvo do CTA ≥ 40px reduz tempo de aquisição.
Fonte: lawsofux.com/fittss-law · medido no preview
```

## Catálogo rápido (lei → pergunta do DS)

| Lei | Pergunta ao forjar o DS |
|-----|-------------------------|
| **Aesthetic-Usability Effect** | A limpeza visual aumenta confiança neste domínio? |
| **Choice Overload / Hick** | Quantas opções reais o usuário precisa ver de uma vez? |
| **Chunking / Miller** | As seções da tela são grupos ≤ ~7 itens mentais? |
| **Cognitive Load** | Removemos ruído (glow, duplicatas, 6 accents)? |
| **Doherty Threshold** | Feedback de UI &lt; 400ms (ideal ≤ 200ms)? |
| **Fitts’s Law** | CTAs e touch targets são grandes e próximos do polegar? |
| **Flow** | O fluxo cadastro→pagamento (ou cadastro→primeira ação) interrompe desnecessariamente? |
| **Goal-Gradient** | O usuário vê progresso perto do objetivo (concluir compra, liberar recurso, terminar processo)? |
| **Jakob’s Law** | O shell parece o que o mercado já ensinou? |
| **Common Region / Proximity / Similarity / Uniform Connectedness** | Agrupamento visual é óbvio (card, form, tile)? |
| **Prägnanz** | Formas simples (radius fechado) vs ornamentação? |
| **Mental Model** | Pagamento / login / categorias batem com a expectativa do segmento? |
| **Occam’s Razor** | A regra mais simples explica o chrome? |
| **Peak-End Rule** | Hero e fim do cadastro/pagamento/processo principal são memoráveis? |
| **Selective Attention** | O que compete com o CTA primary? |
| **Serial Position** | Início e fim da tela carregam as ações críticas? |
| **Tesler’s Law** | Complexidade foi para o sistema, não para o usuário? |
| **Von Restorff** | Há **um** isolamento por seção (não dez)? |
| **Zeigarnik** | Tarefas/ofertas incompletas motivam sem spam? |
| **Working Memory** | Labels e helpers reduzem o que o usuário precisa lembrar? |
| **Postel’s Law** | Inputs tolerantes; outputs limpos? |
| **Pareto** | 20% dos componentes (Button, Input, Card, Modal) cobrem 80% das telas? (Faixa 1 do catálogo) |

## Mapeamento típico token → lei

| Decisão de DS | Leis principais |
|---------------|-----------------|
| 1 Primary | Von Restorff, Selective Attention |
| Escala spacing 4…64 | Prägnanz, Cognitive Load |
| Radius fechado 4/8/12/16 | Similarity, Jakob |
| Touch 44px / h-10 | Fitts |
| Valores rápidos no pagamento | Hick, Mental Model |
| Sheet mobile | Jakob (app), Fitts |
| Banner com prazo | Zeigarnik, Peak |
| Prova social (avaliações, ranking, “quem já usou”) | Aesthetic-Usability — com parcimônia (Load); regras do tipo no ui-gosto §11 |
| Sem glow | Aesthetic-Usability (confiança), Occam, anti-IA |

## Anti-padrões de “psicologia falsa”

- Usar “urgência” (Zeigarnik) em **tudo** → fadiga  
- Muitos Von Restorff → nenhum  
- Jakob ≠ copiar concorrente feio; é **padrão de interação**, não lixo visual  
- Aesthetic-Usability ≠ mais efeitos; é **clareza + consistência**

## Leitura obrigatória na skill

Antes de fechar o DS: abrir `llms.txt` e garantir que §2 do template tem pelo menos 10 leis mapeadas a decisões reais do produto.
