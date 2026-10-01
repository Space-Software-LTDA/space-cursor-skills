# Anexo real — IBM Carbon · Themes

> **Fonte:** https://carbondesignsystem.com/elements/themes/overview/  
> **Capturado:** 2026-09-24 · conteúdo público  
> **Uso:** Theme vs Token vs Role vs Value — mesma anatomia que o Forge exige. Não copiar tokens `$g100` para o produto.

---

# Themes

Themes are used to customize component styles to fit the specific aesthetic of a brand or product.

## Theming basics

Themes modify existing components to fit a specific visual style. By using Carbon’s tokens, developers customize all components by changing a set of universal variables, eliminating the need to modify individual components.

### Theme terms

| Term | Definition |
| --- | --- |
| Theme | A collection of visual attributes assigned to the tokens in order to create a specific aesthetic |
| Token | A role-based identifier that assigns a value to a theme. Tokens are universal and never change across themes |
| Role | The systematic usage(s) of a token. Roles cannot be changed between themes |
| Value | The actual style (such as a hex code) assigned to a token |

### Default theme

Carbon provides four themes (White, Gray 10, Gray 90, Gray 100). Components preset to White; other themes via Sass `with` / `$theme`.

## Customizing a theme

Altering one, some, or all of the default token values results in a new theme. Developers configure new values via Sass module `with`.

## Tokens

With tokens, the code only needs to be changed in one place to see the effect system-wide. Token categories: Color · Spacing · Typography · Global.

Example mapping (same roles, different values):

| Key | Token | Role | White theme value | Gray 100 theme value |
| --- | --- | --- | --- | --- |
| 1 | `$text-secondary` | Label color | Gray 70 | Gray 30 |
| 2 | `$text-primary` | Primary text color | Gray 100 | Gray 10 |
| 3 | `$border-strong` | Border bottom color | Gray 50 | Gray 60 |
| 4 | `$icon-primary` | Primary icon color | Gray 100 | Gray 10 |
| 5 | `$field-01` | Field color | Gray 10 | Gray 90 |
| 6 | `$background` | Page background | White | Gray 100 |
