---
name: frontend-designer-lite
description: >
  Concise framework-agnostic frontend design skill for UI/UX architecture.
  Covers CSS architecture, tokens, component patterns, accessibility, motion,
  responsive layout, visual direction, and performance safeguards.
  Trigger: rapid component decisions, token systems, accessibility checks, or
  visual layout decisions when repository evidence is available.
license: Apache-2.0
metadata:
  author: kozz36
  version: "3.0.1"
---

## When to Use

- Rapid component design (card, dialog, table, form, navigation, hero, or information grid)
- Choosing CSS architecture, tokens, or responsive behavior under known constraints
- Accessibility checks for contrast, focus, touch targets, keyboard behavior, or reduced motion
- Implementing motion or visual layout after support and performance requirements are known
- Consuming an existing `Design.md`, `design.md`, token source, or approved design artifact

## Context Gate

Before selecting a pattern, inspect the repository-native architecture and CSS naming, design source, browser matrix, accessibility scope, performance evidence, team conventions, installed tooling, and migration cost.

- Preserve the existing CSS paradigm (layers, modules, utilities, CSS-in-JS, BEM-like names, or another convention) unless a compatible migration has an accepted cost.
- When the approved token contract and browser/build matrix select OKLCH, keep newly specified tokens OKLCH-only. Otherwise preserve the current color contract.
- Use dark-mode-first, a `light-dark()` strategy, a class-based theme, or another mechanism only when product requirements, the design source, and support policy justify it.
- Choose container queries, viewport media queries, mobile-first, desktop-first, or composition from component reuse, page topology, content, and browser support; none is a default mandate.
- Run validation commands only when the repository provides the dependency, target, permission, and expected evidence. Do not prescribe package installation or an unavailable tool.

---

## 1. CSS Architecture

### Cascade Layers

Use cascade layers when the repository already uses them or when their precedence model fits the build pipeline and migration plan. Layer order changes can alter existing styles, so audit them before adoption.

```css
@layer vendor, tokens, reset, atoms, molecules, organisms, pages, utilities;
```

### Nesting, Naming, and `:has()`

Native nesting may improve local readability where the browser matrix and tooling support it. Retain the repository's naming convention—semantic classes, BEM-like names, modules, utilities, or CSS-in-JS—unless a change has an approved migration path.

Use `:has()` only when the browser matrix supports it and a fallback is unnecessary or defined.

```css
/* Form container reacts to invalid input when relational selectors are supported. */
.form-group:has(:invalid:not(:placeholder-shown)) {
  border-color: var(--s-border-error);
}

/* Keep explicit state when the support policy requires a fallback. */
.nav-card[data-expanded="true"] {
  grid-row: span 2;
}
```

### Paradigm Choice

| Existing or proposed paradigm | Decision |
|---|---|
| BEM-like naming | Retain when it is the repository convention; assess change cost before replacing it. |
| CSS Modules | Retain when its bundler and component ownership model fit the project. |
| CSS-in-JS | Retain or choose when it fits runtime, server-rendering, tooling, and performance evidence; measure material runtime cost. |
| Utility classes | Retain or choose when the team, token system, readability, and output constraints support it. |
| Layers and semantic CSS | Choose when the browser, build pipeline, cascade ownership, and migration plan support them. |

---

## 2. Design Tokens

Use primitive, semantic, and component token tiers when they match the repository's existing contract. Preserve equivalent local tiers and define loading, disabled, error, success, and selected states before visual styling.

1. **Primitive (`--p-`)**: Raw values. `--p-blue-500: oklch(0.6 0.15 250);`
2. **Semantic (`--s-`)**: Context roles. `--s-bg-surface: var(--p-gray-50);`
3. **Component (`--c-`)**: Local override hooks. `--c-card-bg: var(--s-bg-surface);`

### Color

| Format | Use |
|---|---|
| HEX/RGB/HSL | Preserve when the current design source, compatibility policy, or migration cost requires it. |
| OKLCH | When selected by the approved token contract and supported by the browser/build matrix, keep new token specifications OKLCH-only and still measure contrast. |

```css
--s-shadow-deep: oklch(from var(--p-surface-black) calc(l + 0.1) c h);
```

### Fluid Typography

Use container units when a component establishes a query container and the browser matrix supports the feature. Otherwise use the repository's existing type scale, viewport approach, or another compatible fallback.

```css
font-size: clamp(1rem, 0.8rem + 1.5cqi, 1.5rem);
```

### Spacing and Themes

Use the repository's spacing scale. An 8/4-point scale can be useful for macro and micro alignment when it matches the design source; it is not a migration mandate.

Choose dark-mode-first only when product requirements and the design source require it. Use `color-scheme`, semantic tokens, `light-dark()`, a class-based theme, or the repository's established mechanism according to browser/build support and migration cost.

---

## 3. Component Patterns

Consider layout, skin, typography, animation, and state as a component review checklist. The owning repository decides how responsibilities are split.

| Component | Conditional safeguard |
|---|---|
| **Card** | Use a query container when local adaptation is valuable and supported. Let the parent own external spacing; reserve image geometry when it limits layout shift. |
| **Dialog** | Prefer native `<dialog>` when it fits browser and accessibility policy; otherwise preserve the established focus-management contract. |
| **Table** | Use native `<table>` structure and `scope` for tabular data. Use grid or subgrid only when the browser matrix and data semantics support it. |
| **Form** | Keep labels, validation association, keyboard order, and post-interaction states explicit. |
| **Navigation** | Use `<nav>` and list semantics where applicable. Make sticky or scroll-driven behavior conditional on product, browser, motion, and performance requirements. |
| **Hero** | Choose sizing and visual treatment from content, viewport behavior, and performance budget; do not require a fixed viewport height or gradient type. |
| **Information grid** | Choose bento-like grid, flex, named areas, or another topology from information hierarchy and responsive evidence. |

Use container queries for portable component recomposition when supported. Use viewport media queries for document-level layout or when the existing responsive system requires them. Choose mobile-first or desktop-first from product priorities and existing code.

---

## 4. Responsive Layout

- Use subgrid only after checking the browser matrix and a fallback where needed.
- Use named areas when they make the approved layout easier to review; do not impose them on another clear topology.
- Use `aspect-ratio`, dimensions, or an equivalent geometry contract when it prevents measured layout shift.
- Choose content-based breakpoints where they fit the design source and repository system; device labels are not evidence by themselves.
- Use `content-visibility` and `contain-intrinsic-size` only after validating accessibility, rendering behavior, and the relevant performance target.

---

## 5. Accessibility

Preserve semantic HTML and native controls before ARIA substitutes. Determine jurisdiction-specific requirements from the product scope, while keeping measurable contrast, visible focus, keyboard behavior, and reduced motion as baseline safeguards.

| Element | Safeguard |
|---|---|
| Standard text | Measure contrast against the applicable success criterion; 4.5:1 is a common baseline. |
| Large text, UI boundaries, and focus | Measure the relevant state and adjacent colors against the applicable criterion; 3:1 is a common baseline for relevant non-text contrast. |
| Focus indicator | Provide persistent visible geometry and measurable contrast with `:focus-visible`; keep focused content unobscured by sticky UI. |
| Touch target | Define size and spacing from product and accessibility scope; do not infer a legal requirement from a visual pattern. |
| Reduced motion | Honor `@media (prefers-reduced-motion: reduce)` with equivalent low-motion or static feedback. |
| ARIA | Use native semantics first; add ARIA only when native HTML cannot express the required contract. |

```css
:focus-visible {
  outline: 2px solid var(--s-focus);
  outline-offset: 4px;
}

@media (prefers-reduced-motion: reduce) {
  .transitioning {
    animation: none;
    transition-duration: 0ms;
  }
}
```

---

## 6. Micro-interactions and Animation

- Use the smallest motion mechanism that communicates state, hierarchy, or continuity.
- Prefer compositor-friendly `transform` and `opacity` when they satisfy the interaction. Avoid layout-property animation unless profiling and the user experience justify it.
- Gate WAAPI, scroll-driven CSS, observers, and scroll listeners on the browser matrix, reduced-motion policy, fallback, and measured main-thread cost.
- Restrict hover-only affordances to fine hover-capable input and provide equivalent touch/keyboard feedback.

```css
@media (hover: hover) and (pointer: fine) {
  .btn:hover { transform: translateY(-2px); }
}
.btn:active { transform: scale(0.98); }
```

For loading states, define `data-state="loading"` or the repository equivalent, maintain semantic status messaging where needed, and reduce or stop decorative animation under reduced-motion preferences.

---

## 7. Visual Direction

| Treatment | Decision gate |
|---|---|
| Bento-like grids | Use only when information hierarchy, responsive evidence, accessibility, and the design source support it. |
| Glass effects | Verify contrast, focus visibility, readability, rendering cost, and a fallback before use. |
| Neumorphic styling | Treat as high-risk for interactive UI; use only with demonstrated contrast, focus, and affordance compliance. |
| Bold or variable typography | Use when the selected font, loading strategy, readability, and performance budget support it. |
| Dark-first design | Use only when product requirements and the design source require it. |
| Mesh or aurora gradients | Use an implementation that fits browser support and performance evidence; do not prescribe CSS-only, WebGL, or Canvas without that evidence. |

Visual trends do not replace semantic structure, token/state contracts, or accessibility acceptance criteria.

---

## 8. Visual Performance

| Property or asset concern | Conditional use |
|---|---|
| `content-visibility` | Use for content where rendering, accessibility, and measured performance behavior are acceptable. |
| `contain` | Use when component isolation improves the measured target without breaking layout or paint dependencies. |
| `will-change` | Use transiently only when profiling justifies it; remove it when the animation no longer needs it. |
| Images and fonts | Select formats, fallbacks, dimensions, loading strategy, and metrics from the actual delivery/browser matrix and layout-shift evidence. |

Reserve media geometry and use compatible font metrics or fallbacks to reduce layout shift. Do not claim a format is universally supported, adopted, prohibited, or optimal without current project-specific evidence.

---

## 9. Local Design Source

A repository may use `Design.md`, `design.md`, token files, a design-system package, a design-tool export, or another approved artifact. Treat the actual project source as authoritative when present; do not require a filename or claim that a local handoff is an external standard.

```yaml
colors:
  primary: oklch(0.6 0.15 250)
  surface: light-dark(oklch(1 0 0), oklch(0.2 0.02 250))
typography:
  body: clamp(1rem, 0.8rem + 1cqi, 1.25rem)
spacing:
  base: 0.5rem
radius:
  card: 16px
```

When a design source exists, extract its token, semantic, component, and state contracts; reconcile them with repository conventions; then validate contrast, focus, reduced motion, responsive behavior, and performance in the target implementation.

---

## 10. Illustrative Snippet

Use this only when its layers, OKLCH tokens, container query, and viewport fallback fit the repository evidence.

```css
@layer tokens, reset, layout, components;

@layer tokens {
  :root {
    --p-hue-brand: 250;
    --p-brand-base: oklch(0.60 0.15 var(--p-hue-brand));
    --s-bg-surface: var(--p-surface-0);
    --s-font-size-fluid: clamp(1rem, 0.8rem + 1cqi, 1.25rem);
  }
}

@layer layout {
  .bento {
    display: grid;
    grid-template-columns: repeat(12, 1fr);
    gap: 1.5rem;
  }
  .card { grid-column: span 12; }
  @media (min-width: 768px) {
    .card { grid-column: span 4; }
    .card--hero { grid-column: span 8; }
  }
}

@layer components {
  .card {
    container-type: inline-size;
    background: var(--s-bg-surface);
    border-radius: 16px;
    padding: 1.5rem;
  }
  .card :focus-visible {
    outline: 2px solid var(--p-brand-base);
    outline-offset: 4px;
  }
  .card__title { font-size: var(--s-font-size-fluid); }
  @container (max-width: 320px) {
    .card__title { font-size: 1rem; }
  }
}
```

---

## 11. Decision Constraints

1. **Component ownership** — Keep reusable components free of unexplained external geometry; let parent layout or documented component constraints own placement.
2. **Responsive scope** — Use container queries for internal component changes when supported; use viewport rules when page-level topology or the repository system requires them.
3. **Color contract** — Keep new specifications OKLCH-only only when the approved contract and browser/build matrix select OKLCH; do not force legacy migrations.
4. **Accessibility contract** — Preserve semantic HTML, keyboard behavior, visible measurable focus, contrast, touch-target requirements, and reduced motion according to applicable scope.
5. **Motion and performance** — Choose scroll and animation mechanisms from browser support, user preference, fallback, and measured performance; do not ban an existing mechanism without evidence.

---

## Commands

Run a command only when its dependency, target, permission, and expected evidence are already available in the repository or approved environment. Prefer documented package-manager scripts; these examples are not instructions to install tools.

```bash
# Contrast check when the repository provides an OKLCH-aware checker and token input.
npx --no-install @adobe/spectrum-css-contrast-checker --token-file tokens.css

# Accessibility and performance audit when an approved target is available.
npx --no-install lighthouse https://example.com --only-categories=accessibility,performance

# CSS support validation when the project uses Browserslist.
npx --no-install browserslist "supports css-nesting and supports css-cascade-layers"

# WCAG audit when axe-core-cli is already available for the target.
npx --no-install axe-core-cli https://example.com --tags wcag22aa
```

If a command or environment is unavailable, report the missing evidence instead of inventing a successful validation result.

---

## Resources

- CSS Nesting W3C: https://www.w3.org/TR/css-nesting-1/
- OKLCH — Evil Martians: https://evilmartians.com/chronicles/oklch-in-css-why-quit-rgb-hsl
- MDN Container Queries: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_container_queries
- CSS Scroll-Driven Animations: https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Scroll-driven_animations
- WCAG 2.2: https://www.w3.org/TR/WCAG22/
