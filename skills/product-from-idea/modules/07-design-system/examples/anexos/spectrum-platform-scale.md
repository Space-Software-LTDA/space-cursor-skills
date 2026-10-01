# Anexo real — Adobe Spectrum · Platform scale (desktop vs touch)

> **Fonte:** https://spectrum.adobe.com/page/platform-scale/  
> **Capturado:** 2026-09-24 · conteúdo público  
> **Uso:** produto com **extensão + web** precisa de escala/densidade explícita — não um único “mobile-first” genérico.

---

# Platform scale

Spectrum is designed for multiple platforms. There are two scales: **desktop** (cursor) and **mobile** (touch).

## Principles

### Proportions

Mobile components are larger than desktop. Spectrum uses a **1:1.25** scale ratio (mobile = +25% vs desktop; desktop = −20% vs mobile).

### Borders

Component proportions change between scales; **border width stays the same**.

### Typography

Two font-size sets — desktop and mobile. Text larger on mobile scale.

### Iconography

Two icon sets so the same icon isn’t manually scaled. Icons larger on touch platforms. Sizes: small / medium / large.

## Choosing the correct scale

- Desktop platforms (e.g. macOS) → desktop scale.
- Mobile (iOS/Android) → mobile scale.
- Blurry platforms (touch desktop, responsive web) → accommodate both (e.g. by device or browser width).

## Areas and interactions

Each component includes:

| Area | Role |
| --- | --- |
| **Placement area** | Boundaries for layout |
| **Cursor hit areas** | Cursor interactions (may match placement or be a portion) |
| **Touch hit areas** | Prefer minimum **48px** width/height when possible |

Primary interaction: desktop = cursor; mobile = touch. Both scales still handle both interaction types.
