# Exemplo — ONESET Admin → Profissões (tokens)

Referência **concreta** para [decomposicao-tom-professor.md](../decomposicao-tom-professor.md).  
Outros projetos: criar arquivo similar em `exemplos/` quando houver tokens de domínio.

## Glossário de tokens (Profissões ONESET)

| Token (UI) | Onde aparece | Significado | Origem do valor | Engine (`ProfessionService`) |
| --- | --- | --- | --- | --- |
| `{cidade}` / `cidade` | Keywords, descrições, LP | Cidade do profissional | `user_briefing` / endereço | `replaceAll("cidade", …)` |
| `{Cidade}` | Títulos Ads | Cidade (capitalização ads) | Idem | `replaceAll("Cidade", …)` |
| `{bairro}` / `bairro` | Keywords | Bairro | Endereço | `replaceAll("bairro", …)` |
| `{especialidade}` | Keywords, títulos, descrições, LP | Especialidade briefing | Quiz / `SPECIALITY` | Loop + `replaceAll("especialidade", …)` |
| `{KeyWord:…}` | Títulos Ads | Google Keyword Insertion | Google na exibição | Persistir literal |
| *(sem token)* | Todas | Texto fixo | — | Tal qual |

**UI:** "+ Inserir variável" + bloco VISUALIZAÇÃO (pills ≠ valor real).

**Persistência:** protótipo usa `{cidade}`; engine pode esperar `cidade` sem chaves — normalizar na gravação admin.

## Tipos `profession_items` (mapa aba → DB)

| Aba admin | `type` |
| --- | --- |
| Palavras-chave | `KEYWORD` |
| Títulos Ads | `TITLE` |
| Descrições Ads | `DESCRIPTION` |
| LP Títulos | `LP_TITLE` |
| LP Subtítulos | `LP_SUBTITLE` |
| LP Combinações | `LP_FIXED_TITLE_AND_SUBTITLES` (`Título \| Subtítulo`) |
| Prompt Sobre mim | `ABOUT_YOU_PROMPT_BASE` |
| Certificado / conta | `LICENSE_LABEL`, `LICENSE_REQUIRED`, `GA_ACCOUNT_ID` |

## Exemplo didático

Maria, psicóloga, Curitiba, especialidade "Ansiedade":

- Template: `psicólogo {especialidade} em {cidade}`
- Resolvido: `psicólogo Ansiedade em Curitiba`
- 2 especialidades → **2 keywords** geradas do mesmo template
