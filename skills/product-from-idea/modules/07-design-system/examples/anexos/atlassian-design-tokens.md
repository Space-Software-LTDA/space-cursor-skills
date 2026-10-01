# Anexo real — Atlassian Design · Design tokens explained

> **Fonte:** https://atlassian.design/foundations/tokens/design-tokens  
> **Capturado:** 2026-09-24 · conteúdo público  
> **Uso:** anatomia do nome do token + theme ≠ value. Barra mental para `.docs/tokens.dtcg.json`.

---

# Design tokens explained

Design tokens are a single source of truth to name and store design decisions for Atlassian app experiences.

## What are design tokens?

Name and value pairings that represent small, repeatable design decisions — color, font style, whitespace unit, motion for a specific need.

Example: instead of picking one of many greens for an icon, apply `color.icon.success`.

## What are themes?

A theme is a collection of token values designed to achieve a certain look. Themes switch color schemes and styles everywhere using a single set of tokens.

Light mode, dark mode, and high-contrast are theming. Non-color themes also possible: cozy/comfortable/compact, reduced motion, custom typography.

## Why use design tokens?

- Global theming, responsive design, user customization become possible.
- Streamlines decision making and handover between crafts.
- Visual language evolves once across the system — no find-and-replace of hard-coded values.
- Automated tooling helps designers and developers adopt tokens.
- Newest visual foundations ship through tokens.

## How to read design token names

1. **Foundation** — type of attribute (color, elevation, space).
2. **Property** — UI element (border, background, shadow…).
3. **Modifier** — role, emphasis, interaction state (not every token has one). Example: `color.text` = default body text.

## Best practices

Choose tokens based on **meaning**, not because the colors appear to match (breaks other themes).

#### Do

Use tokens whose names/descriptions fit the situation.

#### Don’t

Don’t pick a token just because the hex looks right.

## Token families (examples they publish)

- **Color** — text, links, icons, backgrounds, borders, blankets, charts, skeletons.
- **Elevation** — surface level and shadow.
- **Opacity** — e.g. `opacity.disabled`, `opacity.loading`.
- **Space** — horizontal/vertical spacing consistency.
- **Typography** — family, size, weight, line height.
