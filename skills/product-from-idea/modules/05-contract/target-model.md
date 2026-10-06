# Modelo-alvo — Fase 5 Contrato

> Derivado de contrato de API **real** (OpenAPI Petstore).  
> Vivo: `docs/contrato.md`

## Fontes reais (anexadas)

| Arquivo | O que é | O que extrair |
|---------|---------|----------------|
| [`examples/anexos/openapi-petstore-v3.yaml`](examples/anexos/openapi-petstore-v3.yaml) | Swagger Petstore OpenAPI 3 | Recursos · operações · schemas · o *quê* se troca |

> No **nosso** contrato de produto (fase 5) ainda falamos em **português** (pedidos ao servidor, entidades). O OpenAPI denso pode ser anexo na task — o Petstore mostra a **barra de clareza** de um contrato: recursos nomeados, campos, obrigatoriedade.

## Mínimos que o modelo real exige

1. Recursos / entidades claros.  
2. Campos com obrigatoriedade.  
3. Operações (o que se pede ao sistema).  
4. Sem ambiguidade de nome (mesmo campo = mesmo nome).  
5. Separar o que o cliente manda vs o que o servidor calcula.

## Nosso modelo-alvo

1. Dicionário  
2. De onde × onde ficam  
3. Conta / auth / créditos  
4. O que guardar (lista padronizada do *quê*)  
5. Fluxo extensão/app ↔ servidor  
6. Quem decide matching/ordem  
7. Pedidos úteis ao servidor (PT)  
8. Confirmado · Hipótese · Aberto · Gate  

## Critérios de aceitação

| # | CA | Barra |
|---|-----|--------|
| C1 | Dicionário | |
| C2 | Fonte primária × verdade | |
| C3 | Auth + regras de crédito se houver | |
| C4 | Lista do *quê* (uma tabela; rótulos únicos) | |
| C5 | Quem faz o quê | |
| C6 | Pedidos ao servidor em PT | Sem batizar API à toa |
| C7 | Coerente com MVP/proto | |
| C8 | Gate; aberto só com adiado explícito | |
| **C.CL** | **CL0–CL5** — `shared/docs-clarity.md` | Português comercial; zero meta de chat |

## Anti-padrões (Contrato)

| Anti-padrão | Sintoma |
|-------------|---------|
| Duas tabelas pro mesmo tipo de campo | Frankenstein |
| “Fechado” = nunca detalha | Cliente confuso |
| OpenAPI no lugar do *quê* | Fase errada / over-spec |
| Inventário externo como verdade | `data.md` sem espelho |
| Status tagarela | Protocolo não pedido |
| Meta de chat / abreviação | `qtd.`, “não inventar”, nota para a IA |
