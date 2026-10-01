# Anexo real — Atlassian Design · Color

> **Fonte:** https://atlassian.design/foundations/color  
> **Capturado:** 2026-09-24 · conteúdo público  
> **Uso:** Color **roles** (neutral/brand/danger…) + emphasis + interaction — espelha Qs do Forge. Não copiar rampa Atlassian.

---

# Color

Color distinguishes our brand and reinforces consistent experiences across apps.

### Saturated colors

Saturated colors can infuse meaning to an experience, highlight UI, or create associations with similar colored UI.

### Neutral colors

Neutral colors apply to most backgrounds, text, and shapes. They don’t typically have a meaning associated with them, though they can imply things like disabled states.

### Alpha colors

Alpha colors have varying levels of transparency. Transparency helps UI adapt to different background colors and elevations.

## Applying color with design tokens

For most Atlassian app experiences, colors are applied using design tokens — rather than choosing a shade, you choose a design token.

All color design tokens start with the word “color”, followed by the property (background, border, icon…). After the property, modifiers: **color role**, **emphasis level**, **interaction state**.

## Color roles

| Role | Description |
| --- | --- |
| `neutral` | Default text and secondary UI (secondary buttons, navigation). |
| `brand` | Primary actions or elements that communicate the Atlassian brand. |
| `information` | Informative UI / in-progress. |
| `success` | Favorable outcome. |
| `warning` | Caution to prevent mistake/error. |
| `danger` | Danger or serious error. |
| `discovery` | Something new (onboarding / new feature). |
| `accent` | Colors without specific meaning — interchangeable. Accents: gray, red, green, blue, yellow, orange, teal, purple, magenta, lime. |
| `inverse` | UI on bold emphasis backgrounds. |
| `input` | Form fields. |

#### Do

Use the right color role for your situation.

#### Don’t

Don’t use an accent when the color has semantic meaning.

## Emphasis levels

Emphasis = contrast against the default surface, from subtlest to boldest. Inverse tokens for text/borders/icons on bold backgrounds. Bold warning (yellow) has special `warning.inverse` tokens for WCAG AA.

## Interaction states

Hovered, pressed, selected, focused, disabled. For icons: no dedicated hover/pressed tokens — use subtle neutral background for state.

## Accessibility

WCAG AA:

- **3:1** — UI essential to understanding + text ≥24px (WCAG 1.4.11)
- **4.5:1** — text &lt;24px (WCAG 1.4.3)

## Dark mode

Tokens support light and dark themes. Each token maps to a different value per theme. If using design tokens, you shouldn’t map your own values.
