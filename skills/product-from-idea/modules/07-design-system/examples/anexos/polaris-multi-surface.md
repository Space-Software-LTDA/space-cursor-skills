# Anexo real — Shopify Polaris · Multi-surface (extensão!)

> **Fonte:** https://polaris.shopify.com/foundations  
> **Capturado:** 2026-09-24 · conteúdo público  
> **Uso crítico para produtos com extensão:** um DS / framework, **várias superfícies** com subsets. Não copiar componentes Shopify — copiar a **lei de superfície**.

---

# Polaris references — surfaces

Shopify apps can appear across multiple surfaces in the Shopify platform. Each surface has its own set of available APIs and components.

All app surfaces use **Polaris**, Shopify's unified UI framework built on web components, to deliver a consistent experience across the platform.

## App Home

App Home is the app's main page in the Shopify admin. Two ways to build it:

### App Home (iframe)

Main page as an iframe in Shopify admin using App Bridge and Polaris.

### App Home (UI extension)

Main page as a Preact-based UI extension.

## Extensions in other surfaces

Extensions put the app's UI inside a surface that Shopify renders. Each surface has its own extension APIs and its **own subset** of Polaris web components.

| Surface | What it is |
| --- | --- |
| **Admin UI extensions** | Actions and blocks on admin resource pages (products, orders, customers). |
| **Checkout UI extensions** | Defined points in checkout (product info, shipping, payment, order summary, Shop Pay). |
| **Customer account UI extensions** | Order index, order status, profile pages. |
| **POS UI extensions** | Smart grid, cart, post-purchase in Point of Sale. |

---

## Extraction for our phase 7 (Buscai / multi-repo)

If setup has `frontend` + `extension`:

| Polaris idea | Our bar |
| --- | --- |
| One system, many surfaces | One `.docs/DESIGN_SYSTEM.md` |
| Subset per surface | `P-…` / states per popup vs page vs overlay |
| Don’t pretend Admin iframe = Checkout block | Don’t treat Next chrome = extension popup density |
