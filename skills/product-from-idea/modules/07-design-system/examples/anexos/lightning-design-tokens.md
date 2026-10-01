# Anexo real — Salesforce Lightning · Design tokens (amostra)

> **Fonte:** https://lightningdesignsystem.com/design-tokens/  
> **Capturado:** 2026-09-24 · conteúdo público (tabela oficial; amostra — página tem centenas de tokens)  
> **Uso:** token tem **nome + descrição de uso + valor + themeable**. Espelha barra de `tokens.dtcg.json`. Não copiar brand Salesforce.

---

# Design Tokens — Lightning Design System

Design tokens are the visual design atoms of the design system — named entities that store visual design attributes. Use them in place of hard-coded values (hex for color, px for spacing) to maintain a scalable and consistent visual system.

**Token Support Legend (as published):**

- **GA** — Global Access (Salesforce Platform)
- **I** — Internal only; subject to change

## Brand / color tokens (excerpt)

| Token | Description (published) | Example value | Themeable | Support |
| --- | --- | --- | --- | --- |
| `$brand-accessible` | Dark variant of BRAND accessible with white | `#0176d3` | Yes | GA |
| `$brand-accessible-active` | Active / Hover of BRAND_A11Y | `#014486` | Yes | GA |
| `$brand-background-primary` | Primary page background | `#eef4ff` | Yes | GA |
| `$brand-primary` | Primary brand color | `#1b96ff` | Yes | GA |
| `$brand-primary-active` | Active / Hover of BRAND_PRIMARY | `#0176d3` | Yes | GA |
| `$brand-text-link` | Primary text link brand color | `#0b5cab` | Yes | GA |
| `$brand-disabled` | Disabled state of BRAND_A11Y | `#c9c7c5` | Yes | GA |
| `$brand-light` | Light variant accessible with dark colors | `#f4f6fe` | Yes | GA |
| `$brand-contrast` | Variant accessible with BRAND | `#1a1b1e` | Yes | GA |

## Gray ramp (excerpt)

| Token | Value |
| --- | --- |
| `$color-gray-1` | `#ffffff` |
| `$color-gray-2` | `#fafaf9` |
| `$color-gray-3` | `#f3f2f2` |
| `$color-gray-5` | `#dddbda` |
| `$color-gray-7` | `#b0adab` |
| `$color-gray-9` | `#706e6b` |
| `$color-gray-11` | `#3e3e3c` |
| `$color-gray-13` | `#080707` |

## Blue palette (excerpt)

| Token | Value |
| --- | --- |
| `$palette-blue-10` | `#001639` |
| `$palette-blue-30` | `#014486` |
| `$palette-blue-50` | `#0176d3` |
| `$palette-blue-60` | `#1b96ff` |
| `$palette-blue-90` | `#d8e6fe` |
| `$palette-blue-95` | `#eef4ff` |

> Tokens prefixed **BRAND** are brandable and change when a customer applies theming. Always read the published description for intended usage.
