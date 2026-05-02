---
name: frontend-designer
description: >
  Framework-agnostic frontend design skill for UI/UX architecture.
  Covers CSS layers, container queries, OKLCH design tokens, component patterns,
  WCAG 2.2 + EAA 2025 accessibility, scroll-driven animations, visual trends 2026,
  and Design.md (Google Labs standard for AI design-to-code).
  Trigger: When designing or implementing UI components, CSS architecture,
  design systems, responsive layouts, visual accessibility, or design tokens —
  regardless of React, Vue, or HTML.
license: Apache-2.0
metadata:
  author: kozz36
  version: "1.0"
---

## When to Use

- Designing or implementing UI components (cards, modals, tables, forms, nav, hero, feature-grid)
- Architecting CSS systems with cascade layers, container queries, or semantic tokens
- Building design systems with primitive → semantic → component token tiers
- Ensuring WCAG 2.2 + EAA 2025 compliance (contrast, focus, touch targets, reduced motion)
- Implementing scroll-driven animations, micro-interactions, or skeleton screens
- Deciding on visual trends (bento grids, glassmorphism, mesh gradients, dark mode first)
- Consuming or authoring a `Design.md` spec (Google Labs AI design-to-code standard)
- Any visual layer decision where the framework (React/Vue/HTML) is irrelevant

---

## 1. CSS Architecture 2026

### Cascade Layers (@layer)

Specificity is controlled unambiguously by `@layer`. The browser resolves conflicts by layer order, not selector weight or import sequence.

**Mandatory layer sequence** (lowest → highest priority):

```css
@layer vendor, tokens, reset, atoms, molecules, organisms, pages, utilities;
```

A utility class always overrides a complex component. Third-party styles (vendor) cannot collide with internal design system decisions.

### Native Nesting & BEM Obsolescence

The `&` selector references the parent context natively. Combined with `@layer`, it eliminates the need for BEM's verbose class chains.

| Paradigm | Specificity Control | DOM Legibility | Maintainability |
|----------|---------------------|----------------|-----------------|
| **BEM (2020)** | Depends on long strings (`.card__title--active`). Error-prone at scale. | Poor. HTML polluted with redundant classes. | High, but requires strict manual discipline. |
| **CSS Modules / Scoped (2023)** | Isolation via bundler-generated hashes. | Fair. Obfuscated classes hinder browser DevTools debugging. | Moderate. Tightly coupled to JS bundler pipeline. |
| **Layers + Nesting (2026)** | Deterministic `@layer` resolution. Browser handles conflict, not selector length. | Excellent. Semantic HTML with concise classes (`.card`, `.title`). | Exceptional. Safe modification without preprocessors or bundlers. |

### :has() — Relational Selector

The `:has()` pseudo-class applies styles to a parent based on descendant state. It removes JS for upward visual mutations.

```css
/* Form container reacts to any invalid input */
.form-group:has(:invalid:not(:placeholder-shown)) {
  border-color: var(--s-border-error);
  box-shadow: 0 0 0 4px var(--s-shadow-error);
}
```

### Paradigm Verdict

| Paradigm | Visual/Structural Coupling | Parse Performance | Framework-Agnostic Verdict |
|----------|--------------------------|-------------------|---------------------------|
| **CSS-in-JS (Styled Components)** | Absolute coupling. Style lives in JS thread only. | Poor. Blocks main thread, increases TBT. | **Prohibited.** Incompatible with static rendering and agnostic architecture. |
| **Utility-First (Tailwind v4.2)** | High. DOM is the sole visual source of truth. Requires mapping hundreds of classes per component. | High. Static CSS pre-generated via native compilation. | **Desaconsejado.** Transferring a design to a frontend architect forces token visual noise into component logic. |
| **Semantic CSS (Token System)** | Total decoupling. HTML describes content (`<article class="card">`); CSS governs display. | Optimal. Static CSS files, CDN-cacheable, parallelizable. | **Mandatory Standard.** Enables AI agents to generate stable interfaces that JS developers consume without friction. |

---

## 2. Design Tokens (3-Tier System)

Tokenization uses a relational semantic graph. Theme reassignment happens without component-level restructuring.

### Three-Tier Hierarchy

1. **Primitive (Tier 1 — `--p-`)**: Absolute, mathematical, raw values. Color palettes, spatial scales, base font families. Agnostic to context and theme. Never mutate in dark mode.  
   Example: `--p-blue-500: oklch(0.6 0.15 250);`

2. **Semantic (Tier 2 — `--s-`)**: Assigns intent and purpose. Roles: surface backgrounds, error text, interactive borders, visual accents. Inherently dynamic. Uses `light-dark()` to alternate primitive values based on active color scheme.  
   Example: `--s-bg-surface: light-dark(var(--p-gray-50), var(--p-gray-900));`

3. **Component (Tier 3 — `--c-`)**: Encapsulated override hooks within a component block. Consume semantic tokens as fallbacks, but allow local injection for specific variations.  
   Example: `background-color: var(--c-card-bg, var(--s-bg-surface));`

### Colorimetry: OKLCH vs HEX/HSL

| Format | Gamut | Perceptual Uniformity | Mathematical Manipulation |
|--------|-------|----------------------|---------------------------|
| **HEX / RGB** | sRGB only. | None. No correlation between numbers and luminosity perception. | Unviable. Cannot darken or saturate algorithmically in CSS. |
| **HSL** | sRGB only. | Poor. Same L value can appear drastically different, breaking contrast calculations. | Low. Hue shifts alter perceived brightness unpredictably. |
| **OKLCH** | Display-P3 and Rec2020 (Wide Gamut). ~30% more vibrant. | Perfect. Lightness is constant regardless of Hue and Chroma. | Exceptional. CSS relative colors (`oklch(from base l c h)`) preserve perceptual contrast. |

**Verdict**: OKLCH is mandatory. HEX, RGB, and HSL are prohibited for base specifications.

### Fluid Typography

Reject viewport-based breakpoints. Use `clamp()` with container query inline units (`cqi`).

```css
font-size: clamp(1rem, 0.8rem + 1.5cqi, 1.5rem);
```

Using `cqi` instead of `vw` ensures a component (e.g., a card) reduces its typography appropriately when confined in a narrow column, even if the global browser viewport is extremely wide.

### Spacing Grid

- **8-point multiples**: macro layout, containers, section margins.
- **4-point multiples**: micro-alignments, button padding, icon gaps.

Injected via primitive tokens:

```css
--p-space-8: 0.5rem;
--p-space-16: 1rem;
--p-space-24: 1.5rem;
```

### Dark Mode First

Use `color-scheme: light dark;` at root. All semantic tokens declare dual values via `light-dark()`. Component tokens inherit this automatically. No manual `.dark` class toggling.

---

## 3. Component Patterns

Every component decomposes into **five structural responsibilities**:

1. **Layout**: Internal geometry (Flexbox / CSS Grid).
2. **Skin**: Semantic tokens for backgrounds, borders, shadows.
3. **Typography**: Font families, weights, line-height, fluid scales.
4. **Animation**: Transition orchestration without layout reflow properties.
5. **State**: Interactive visual representation (hover, focus-visible, invalid, disabled).

### Component Rules

| Component | Key Rule |
|-----------|----------|
| **Card** | `container-type: inline-size` mandatory. No external margins. Images use strict `aspect-ratio` + `object-fit: cover`. |
| **Modal** | Use `<dialog>` + `showModal()`. Backdrop via `::backdrop`. `overscroll-behavior: contain`. |
| **Table** | `<table>` structure with `scope`. Complex layouts: `display: grid` + `subgrid` on rows. |
| **Form** | `:user-valid` / `:user-invalid` (post-interaction only). Error expansion: `grid-template-rows: 0fr` transition. |
| **Nav** | `<nav>` + lists. Sticky: `position: sticky`. Scroll animation: `animation-timeline: scroll()`. |
| **Hero** | `min-height: 100svh`. CSS mesh gradients only. |
| **Feature-Grid** | Bento: `repeat(12, 1fr)` + named `grid-template-areas`. Hero tiles span 4–6 cols; metrics span 2×1 or 2×2. |

### Philosophy Shift

**Mobile-First and Desktop-First are obsolete.** Replaced by **Component-First**: spatial reconfigurations respond to the component's own internal content stress via `@container`, not the global device viewport.

---

## 4. Responsive & Layout

### Subgrid

`grid-template-columns: subgrid` and `grid-template-rows: subgrid` are production-ready. A nested card inside a 12-column macro-layout can inherit the parent's tracks, aligning internal avatars, text, and buttons mathematically across adjacent cards. Solves the historic "uneven content height" problem without JS equalization.

### Named Areas

Map visual topology directly in CSS:

```css
.bento-layout {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  grid-template-areas:
    "hero hero hero hero hero hero metric1 metric1 metric1 metric2 metric2 metric2"
    "hero hero hero hero hero hero chart chart chart chart alert alert";
}
```

This prevents structural errors by AI agents and enables immediate human code audits.

### Aspect-Ratio & Content-Visibility

- `aspect-ratio: 16 / 9;` replaces padding-bottom hacks for all media containers.
- Breakpoints must be content-based, not device-based. Use `minmax()` and `ch` units to enforce optimal reading width (60–75ch max).
- `content-visibility: auto;` with `contain-intrinsic-size` defers layout and paint calculations for below-the-fold sections.

---

## 5. Accessibility (WCAG 2.2 + EAA 2025)

The European Accessibility Act (EAA 2025) is legally enforceable since June 2025. Penalties are fiscal. Align with EN 301 549, WCAG 2.1 AA, and selected WCAG 2.2 AAA criteria.

### Contrast Ratios

| Element | Minimum Ratio |
|---------|--------------|
| Standard text | **4.5:1** |
| Large text (24px regular / 18px bold) | **3:1** |
| UI components (input outlines, interactive borders) | **3:1** |

OKLCH enables mathematical contrast resolution at design time because Lightness is independent of Hue and Chroma.

### Focus Indicators

WCAG 2.2 criteria 2.4.11 and 2.4.13 dictate: minimum 2px CSS border perimeter; color ≥ 3:1 against unfocused state AND adjacent background; focused element must be fully visible (`scroll-padding-top` on scroll containers).

```css
:focus-visible {
  outline: 2px solid var(--p-brand-base);
  outline-offset: 4px;
}
```

Prohibited: `outline: 1px dotted`, faint blurred shadows.

### Touch Targets & Reduced Motion

- **Touch target**: 44×44 px minimum for primary buttons (exceeds WCAG 2.2 AA 24×24 px).
- `@media (prefers-reduced-motion: reduce)` is mandatory. Neutralize scale/parallax animations instantly or fade only.

### ARIA Rule

> "The best ARIA practice is to not use ARIA unless critically necessary."

Default to native interactive elements: `<button>`, `<dialog>`, `<nav>`, `<fieldset>`, `<details>`. `role="button"` on `<div>` elements is prohibited unless strictly managed by the frontend architect for asynchronous semantic control.

---

## 6. Micro-interactions & Animation

### CSS Transitions vs WAAPI

Prefer declarative `transition` and `@keyframes`. WAAPI is reserved for imperative orchestration controlled by JS logic; CSS declarations guarantee visual state remains packaged regardless of React or Vanilla JS injection.

### Compositor-Only Properties

Apply animations exclusively to `transform` and `opacity`. **Strictly prohibited during state transitions**: `width`, `height`, `margin`, `top`, `left` — these trigger Layout Reflow and Paint, destroying 60fps consistency.

### Scroll-Driven Animations

| Context | Property | Architectural Use |
|---------|----------|-------------------|
| **Root scroll** | `animation-timeline: scroll();` | Shrink sticky headers, global reading progress bar (0% → 100%). |
| **Component intersection** | `animation-timeline: view();` | Staggered card reveals as they enter viewport. Combine with `animation-range: entry 0% entry 100%`. |

### Hover Without :hover

Wrap hover styles inside `@media (hover: hover) and (pointer: fine)` to prevent "sticky hover" on touch devices. Tactile feedback uses `:active` exclusively.

```css
@media (hover: hover) and (pointer: fine) {
  .btn-primary:hover {
    background-color: oklch(from var(--p-brand-base) calc(l + 0.05) c h);
  }
}
```

### Skeleton Screens & State Attributes

Async states use `data-state="loading"`. Skeleton screens use animated `linear-gradient` via `background-position` shift, consuming the base background token and a contrast token.

---

## 7. Visual Trends 2026 (Opinionated)

| Trend | Verdict | Implementation |
|-------|---------|---------------|
| **Bento Grids CSS** | **Mandatory** for dashboards/metrics. Asymmetric tile sizing signals data density. Requires identical `gap` and identical `border-radius` (12–24px) across all tiles for puzzle-fit rhythm. |
| **Glassmorphism** | **Focalized only.** Overlays, sticky navbars, contextual menus. Use low-alpha transparency + `backdrop-filter: blur(20px)` + 1px bright semi-transparent border + layered `box-shadow`. |
| **Neumorphism** | **Prohibited.** Extruded monochrome interfaces with dual opposing shadows violate EAA 2025 contrast thresholds for shape recognition by visually impaired users. |
| **Bold Typography** | **Standard.** High weight contrast between display and body text. Variable font weight axes exploited for hierarchy without extra file requests. |
| **Dark Mode First** | **Standard.** All palettes designed for dark environment first; `light-dark()` lifts to light mode. Reduces eye strain and OLED energy consumption. |
| **Mesh / Aurora Gradients** | **CSS-only.** Stack multiple `radial-gradient` declarations in `background-image` using OKLCH colors. Blend with `mix-blend-mode`. Optional SVG noise texture overlay. No WebGL/Canvas JS. |

---

## 8. Performance Visual

### Containment & Visibility

| Property | Declaration | Performance Impact |
|----------|-------------|-------------------|
| **content-visibility** | `content-visibility: auto;` + `contain-intrinsic-size` | Omits layout and paint for below-the-fold trees until near viewport. |
| **contain** | `contain: paint layout;` | Isolates mutations. Internal changes do not recalculate parent or siblings. |
| **will-change** | `will-change: transform, opacity;` (transient only) | Promotes element to GPU compositor layer before complex animation. Remove after animation completes. |

### Cumulative Layout Shift (CLS) Prevention

Load fonts asynchronously. Compensate FOUT/FOIT with `font-size-adjust`. Declare system UI font stack as algorithmic fallback. Reserve exact space for images with `aspect-ratio` before load.

### Image Format Decision

| Format | Adoption (May 2026) | Verdict |
|--------|---------------------|---------|
| **WebP** | ~95.6% | Default for user-generated content (thumbnails). Fast encode (~90ms). |
| **AVIF** | ~93.8% browser / ~1.3% real delivery | Static assets only (logos, UI graphics). ~50% smaller than JPEG, but encode is slow (~1–2s). |
| **JPEG XL** | <0.1% | Prohibited for direct client interfaces. Insufficient WebKit/iOS support despite superior compression. |

### Variable Fonts

Use a single variable font file with weight/width/slant axes instead of multiple static files. Reduces HTTP requests and enables fluid weight interpolation for responsive hierarchy.

---

## 9. Design.md (Google Labs)

Launched April 2026 by Google Labs. Replaces Figma handoff with a deterministic, AI-consumable design specification.

- **YAML Front Matter**: Machine-readable metadata. Declares design system structure: OKLCH colors, fluid typography scales (`cqi`), spacing grid, border-radius hierarchy.
- **Markdown Prose**: Narrative rules for LLMs. Explains *why* and *when* to invoke the YAML tokens. Example: "The destructive error palette is implemented on modals and notifications only; never on passive interactive elements like tabs."

**Toolchain**: Design traced in Figma/Google Stitch → auto-generate `design.md` → Claude Code consumes via MCP → deterministic component generation without per-request contrast micromanagement.

---

## 10. Staff-Level Snippet

Production-ready HTML5 + CSS consolidating `@layer`, three-tier tokens, `light-dark()`, bento grid, container queries, and dark mode.

```html
<section class="bento-dashboard" aria-label="Performance Metrics Panel">
  <article class="stat-card stat-card--hero">
    <header class="stat-card__header">
      <h2 class="stat-card__title">Cyclic Return</h2>
      <span class="stat-card__status" data-state="success" aria-label="Positive"></span>
    </header>
    <div class="stat-card__content">
      <p class="stat-card__value">42.8%</p>
      <p class="stat-card__metric">+5.2% vs prior baseline.</p>
    </div>
  </article>
  <article class="stat-card">
    <header class="stat-card__header">
      <h2 class="stat-card__title">Operational Volume</h2>
      <span class="stat-card__status" data-state="neutral" aria-label="Stable"></span>
    </header>
    <div class="stat-card__content">
      <p class="stat-card__value">1.42M</p>
      <p class="stat-card__metric">Consolidated transactions.</p>
    </div>
  </article>
</section>
```

```css
@layer tokens, reset, layout, components, utilities;

@layer tokens {
  :root {
    --p-hue-brand: 250;
    --p-brand-light: oklch(0.95 0.05 var(--p-hue-brand));
    --p-brand-base:  oklch(0.60 0.15 var(--p-hue-brand));
    --p-brand-dark:  oklch(0.25 0.10 var(--p-hue-brand));
    --p-surface-white: oklch(0.99 0.01 var(--p-hue-brand));
    --p-surface-black: oklch(0.15 0.02 var(--p-hue-brand));
    --p-space-8: 0.5rem; --p-space-16: 1rem; --p-space-24: 1.5rem;
    color-scheme: light dark;
    --s-bg-canvas:  light-dark(var(--p-surface-white), var(--p-surface-black));
    --s-bg-surface: light-dark(oklch(1 0 0), oklch(0.20 0.02 var(--p-hue-brand)));
    --s-text-primary: light-dark(var(--p-surface-black), var(--p-surface-white));
    --s-text-muted:   light-dark(oklch(0.4 0.05 var(--p-hue-brand)), oklch(0.7 0.05 var(--p-hue-brand)));
    --s-border-radius-base: 16px;
    --s-font-size-fluid: clamp(1rem, 0.8rem + 1cqi, 1.25rem);
  }
}

@layer reset {
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background-color: var(--s-bg-canvas); color: var(--s-text-primary);
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    -webkit-font-smoothing: antialiased;
  }
  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
      animation-duration: 0.01ms !important; animation-iteration-count: 1 !important;
      transition-duration: 0.01ms !important; scroll-behavior: auto !important;
    }
  }
}

@layer layout {
  .bento-dashboard {
    display: grid; grid-template-columns: repeat(12, 1fr);
    gap: var(--p-space-24); padding: var(--p-space-24);
    max-width: 1440px; margin-inline: auto;
  }
  .stat-card { grid-column: span 12; }
  @media (min-width: 768px) {
    .stat-card { grid-column: span 4; }
    .stat-card--hero { grid-column: span 8; }
  }
}

@layer components {
  .stat-card {
    container-type: inline-size; container-name: card-container;
    --c-card-bg: var(--s-bg-surface); --c-card-radius: var(--s-border-radius-base);
    background-color: var(--c-card-bg); border-radius: var(--c-card-radius);
    padding: var(--p-space-24);
    border: 1px solid light-dark(oklch(0.9 0 0), oklch(0.3 0 0));
    &:focus-visible { outline: 2px solid var(--p-brand-base); outline-offset: 4px; }
  }
  .stat-card__header {
    display: flex; justify-content: space-between; align-items: flex-start;
    margin-block-end: var(--p-space-16);
  }
  .stat-card__title { font-size: var(--s-font-size-fluid); font-weight: 600; }
  .stat-card__value {
    color: oklch(from var(--p-brand-base) calc(l - 0.1) c h);
    font-size: clamp(2rem, 1.5rem + 5cqi, 3.5rem);
    font-weight: 800; letter-spacing: -0.02em; line-height: 1;
  }
  .stat-card__metric { color: var(--s-text-muted); font-size: 0.875rem; margin-block-start: var(--p-space-8); }
  .stat-card__status[data-state="success"] {
    width: 12px; height: 12px; border-radius: 50%;
    background-color: oklch(0.7 0.2 146); box-shadow: 0 0 0 4px oklch(0.7 0.2 146 / 0.15);
  }
  .stat-card__status[data-state="neutral"] {
    width: 12px; height: 12px; border-radius: 50%;
    background-color: oklch(0.7 0.05 250); box-shadow: 0 0 0 4px oklch(0.7 0.05 250 / 0.15);
  }
  @container card-container (max-width: 320px) {
    .stat-card__header { flex-direction: column; gap: var(--p-space-8); }
    .stat-card__status { align-self: flex-end; }
    .stat-card__value { font-size: 2rem; }
  }
}
```

---

## 11. Architectural Dictates

**1. Absolute Structural Independence**  
No component shall declare external geometric coordinates (e.g., `margin-left`) or assume its dimensions in the parent canvas. Every component is a spatially ignorant module. Its final topological adaptation is subordinated to the macro-container (`display: grid` with `gap`) or its own self-referencing local queries (`@container`).

**2. Total Rejection of Global Device Viewports**  
The conditional use of physical screen dimensions (`@media (min-width: 1024px)`) is strictly prohibited for determining internal component metric, typographic, or interface recompositions. All responsive transitions respond to geometric stress dictated by `@container`, enforcing an irreducible Component-First philosophy.

**3. Perceptual Prohibition of Legacy Color Formats**  
All base, mathematical, and visual color specifications universally ban RGB, RGBA, HEX, and HSL. Primary matrices are parameterized mandatorily with OKLCH, using CSS relative color functions (`oklch(from var(--x) calc(l) c h)`) for dynamic alterations and shadow calculations.

**4. Visual Compliance with EAA 2025 (Touch & Focus)**  
To prevent European legal infringement: every keyboard focus ring must have an immutable 2px CSS thickness backed by >3:1 contrast. Every primary transient button must have a hidden capacitive touch target achieving 44×44 px (exceeding WCAG 2.2 24×24 px).

**5. Zero Main-Thread Execution for Visual Scroll Orchestration**  
The invocation of imperative JavaScript (`IntersectionObserver`, scroll event listeners) for purely decorative visual positioning or parallax is formally prohibited. All interactive scroll or parallax manipulation uses declarative compositor APIs (`animation-timeline: view();`, `scroll()`), guaranteeing 60fps and zero TBT overhead.

---

## Commands

```bash
# Verify contrast ratios (OKLCH-aware)
npx @adobe/spectrum-css-contrast-checker --token-file tokens.css

# Lighthouse accessibility + performance audit
npx lighthouse https://example.com --only-categories=accessibility,performance

# CSS specificity visualization
npx specificity-graph src/styles.css

# Validate CSS nesting and layer support
npx browserslist "supports css-nesting and supports css-cascade-layers"

# AVIF encoding for static assets
avifenc --min 0 --max 63 --minalpha 0 --maxalpha 63 -a end-usage=q -a cq-level=18 -a tune=ssim input.png output.avif

# Check WCAG 2.2 compliance via axe-core
npx axe-core-cli https://example.com --tags wcag22aa
```

---

## Resources

- **CSS Nesting Module Level 1**: https://www.w3.org/TR/css-nesting-1/
- **OKLCH in CSS — Evil Martians**: https://evilmartians.com/chronicles/oklch-in-css-why-quit-rgb-hsl
- **MDN Container Queries**: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_container_queries
- **CSS Scroll-Driven Animations**: https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Scroll-driven_animations
- **WCAG 2.2 Overview**: https://www.w3.org/WAI/standards-guidelines/wcag/new-in-22/
- **European Accessibility Act 2025 — Chromatic**: https://www.chromatic.com/blog/developers-guide-to-european-accessibility-act-2025/
- **Design.md Spec (Google Labs)**: https://design.md (reference implementation)
- **Bento Grid CSS Guide**: https://senorit.de/en/blog/bento-grid-design-trend-2025
