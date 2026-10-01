# Anexo real — IBM Carbon · Color

> **Fonte:** https://carbondesignsystem.com/elements/color/overview/  
> **Capturado:** 2026-09-24 · conteúdo público (não inventado)  
> **Uso na skill:** extrair **lógica** (token ≠ hex, layering, roles). **Proibido** copiar hex Carbon para o produto do cliente.

---

# Color

Maintaining consistent and engaging digital interfaces throughout IBM, whether applications or experiences, demands extended guidance around color usage. The following concepts provide the foundation as we strive to achieve balance and harmony through our User Interface design.

## Introduction

Application of the color palette brings a unified and recognizable consistency to IBM’s array of digital products and interfaces. This consistency is grounded in a set of well-defined rules about how to work with the Carbon component library in the context of dark and light themes.

## Color anatomy

Carbon’s default themes are derived from the IBM Design Language color palette. The neutral gray family is dominant in the default themes, making use of subtle shifts in value to organize content into distinct zones.

The core blue family serves as the primary action color across all IBM products and experiences. Additional colors are used sparingly and purposefully.

### Layering model

Colors in the neutral gray palette are layered on top of each other to create depth and spatial associations. The layering model defines the logic of how colors stack on top of each other in a UI when using the Carbon themes. Aspects of the layering model are built directly into the themes, color tokens, and components.

The layering model differs between the light and dark themes.

- In the light themes, layers alternate between White and Gray 10 with each added layer.
- In the dark themes, layers become one step lighter with each added layer.

## Implementing color

Carbon uses tokens and themes to manage color. Tokens are role-based, and themes specify the color values that serve those roles in the UI.

| Term | Definition |
| --- | --- |
| Theme | A theme is a collection of colors designed to create a specific aesthetic. Themes control the color value assigned to a token. For example, Gray 100 theme. |
| Token | A token is the role-based identifier that assigns a color. Unlike hex codes, tokens apply universally across themes. For example, `$layer`, `$border-subtle`, `$support-error`. |
| Role | A role is the systematic usage of a color assigned to a token. Roles cannot be changed between themes. |
| Value | A value is the unique visual attribute (hex code, rgba value) assigned to a token through the use of themes. |

## Themes

Themes serve as an organizational framework for color in Carbon, with each theme based on a specific primary background color. There are two default light themes and two default dark themes.

| Theme | Primary background | Token | Hex value |
| --- | --- | --- | --- |
| White | Global Background Light | `$background` | `#ffffff` |
| Gray 10 | Global Background Light | `$background` | `#f4f4f4` |
| Gray 90 | Global Background Dark | `$background` | `#262626` |
| Gray 100 | Global Background Dark | `$background` | `#161616` |

### Light themes — layering

- **White theme:** White as global background; first layer components use Gray 10; second layer White; third Gray 10.
- **Gray 10 theme:** Gray 10 as global background; first layer White; then alternate.

Avoid use of midtones.

### Dark themes — layering

- **Gray 90:** background Gray 90 → layer Gray 80 → Gray 70 → Gray 60.
- **Gray 100:** background Gray 100 → layer Gray 90 → Gray 80 → Gray 70.

Do not apply components that are darker than the background unless using high-contrast mode.

## Tokens

Tokens abstract how we use color from the values themselves. They are used in place of hard-coded hex codes. Color token names and roles are the same across themes; only the assigned value changes.

### Core token groups

| Token group | Applied to |
| --- | --- |
| Background | Page or primary backgrounds |
| Layer | Stacked backgrounds (includes layering tokens) |
| Field | Form and input backgrounds |
| Border | Dividers, rules, and borders |
| Text | Type and type styles |
| Link | Standalone and inline links |
| Icon | Icons and pictograms |
| Support | Notification elements and status indicators |
| Focus | Focus states |
| Skeleton | Skeleton states |

### Component tokens

Some components have their own specific color tokens. They should never be used for anything other than their own component.

## Interaction states

Five interaction states beyond enabled: hover, active, selected, focus, disabled — signified by a state suffix on the base token (e.g. `$layer-hover`).

- Hover: half-steps between IBM palette steps.
- Active: two full steps lighter/darker on the scale.
- Selected: one full step lighter/darker.
- Focus: typically 2px border; light themes Blue 60; dark themes White; must pass 3:1.
- Disabled: Gray family; intentionally de-emphasized; not subject to WCAG contrast the same way.

## Accessibility

WCAG: small text (&lt;24px) **4.5:1**; large text / graphics **3:1**. IBM palette has twelve grades — contrast tables map minimum steps between any two colors.
