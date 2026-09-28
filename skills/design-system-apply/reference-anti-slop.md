# Anti-slop Space-compatible

> Método adaptado de [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) (`redesign-skill`, AI tells, `output-skill`).  
> **Gosto** = [`../docs/ui-gosto.md`](../docs/ui-gosto.md). Este arquivo só evita entrega genérica/preguiçosa.  
> **Proibido** importar bans Taste contra Inter, Lucide, ou “upgrades” glass/grain/GSAP alto.

## Scan → Diagnose → Fix

1. **Scan** — alvo, viewports, padrões atuais.  
2. **Diagnose** — listar AI tells + falhas de gosto/DS.  
3. **Fix** — no alvo escolhido (canvas por padrão; construtor se escolhido); só peças oficiais; mudanças reviewable.

## Preserve vs Overhaul

| Modo | Quando |
|------|--------|
| **Preserve** | Marca/IA ok; limpar slop e gaps |
| **Overhaul visual** | Dívida estrutural; humano pediu gosto Space no sistema todo |

Nunca mudar em silêncio: marca Primary, logo, rotas/IA de conteúdo sem OK.

## AI tells a matar (Space-ok)

- Gradient purple / mesh IA default  
- Multi-accent / carnaval  
- Glow, neon, live-pulse, glass no chrome  
- 3 feature cards idênticos (marketing)  
- Cards dentro de cards / fill empilhado igual  
- Fake screenshot de divs  
- Pill em CTA de form  
- Motion theater / hero ilegível / chip sobre foto  
- Ação principal do estado (ex.: criar conta quando deslogado) em outline “por conceito”  
- Peça solta / cor digitada / componente fora da lista oficial nas telas oficiais do canvas  

## Output completo (obrigatório)

Hard fail em edições (canvas, construtor ou código):

- `// ...`, `// rest`, `TODO`, “similar ao acima”, “resto igual”  
- Skeleton no lugar de implementação pedida  
- “Posso continuar se quiser” no lugar de entregar  

Se o output for longo: breakpoint limpo + `[PAUSED — X of Y]` — depois retomar sem recap.

## Pre-flight (antes de ALIGNED)

- [ ] Fase A feita (DS limpo) ou humano dispensou com ciência  
- [ ] Marca Primary respeitada  
- [ ] Checklist gosto §10 + checklist do tipo (§11) sem FAIL acionável  
- [ ] Regras do tipo respeitadas (ex.: cassino — no máximo **1** prova social **global**, §11.1.5)  
- [ ] Sem AI tells acima no escopo  
- [ ] Desktop + mobile do escopo revalidados **nesta sessão** (browser e/ou prints do canvas)  
- [ ] Review humano (se existir): tabela × tela sem FAIL ALTA  
- [ ] Affordance clicável validada (⋯/menus/CTAs) — presença no DOM ≠ PASS  
- [ ] Edição/output completo (sem placeholders)  
- [ ] `DIFERENCAS_PARA_DEVS.md` atualizado (projeto de código/construtor)  
- [ ] Badge/watermark do host anotado se visível (não “corrigido” como feature)  
- [ ] Relatório `…-rN.md` gravado  
- [ ] Se houve pedido pós-ALIGNED que mudou pattern: mini-A + OK (ou autorização explícita na mesma msg) registrados em EXTRACTION_NOTES  
- [ ] OK humano explícito para ALIGNED **final** (senão só “candidato”)  

Qualquer FAIL → não declarar ALIGNED.
