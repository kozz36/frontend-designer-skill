# Changelog

## [v3.0.1] - 2026-05-15

### Changed

- Published canonical `frontend-designer` and `frontend-designer-lite` runtime entrypoints under `skills/`, both with metadata version `3.0.1`.
- Kept the full runtime compact and moved its detailed, conditional guidance beside it in `skills/frontend-designer/references/`.
- Corrected project-agnostic guidance: CSS architecture and naming, OKLCH-only token use, dark-mode-first, layout, component, trend, browser-feature, tool-command, and migration decisions now require repository evidence.
- Preserved semantic HTML, token and component-state contracts, measurable contrast, visible focus, reduced motion, component/container safeguards, and performance evidence requirements.
- Corrected a historical runtime wording typo in the current full reference and removed ungated adoption and universal-support assertions from current guidance.

### Archive

- Made `versions/` archive-only by renaming every historical `SKILL.md` entrypoint to `ARCHIVE.md` without changing historical content.
- Added non-installable v3.0.1 full and lite archive snapshots that match their canonical current counterparts.

## [v3.0] - 2026-05-15

### Added

- Added `versions/v3.0/SKILL.md` using the skill-creator compact runtime contract.
- Added `versions/v3.0/references/technical-reference.md` as the curated v3.0 technical basis.
- Added `versions/v3.0/references/source-index.md` for source links and verification status.

### Changed

- Added a compact runtime and local reference split under the historical `versions/v3.0/` path.
- Curated technical reference material from the prior lite release.
- Preserved the prior full and lite release files as historical content.

## [v1.0] — 2026-05-02

### Added

- **CSS Architecture 2026** — `@layer` cascade layers, native nesting (`&`), `:has()` relational selector, BEM obsolescence table
- **Design Tokens (3-Tier)** — Primitive (`--p-`), Semantic (`--s-`), Component (`--c-`) tiers; OKLCH mandatory; fluid typography (`clamp` + `cqi`); 8/4-point spacing grid
- **Component Patterns** — 5-responsibility model (Layout, Skin, Typography, Animation, State); Card, Modal, Table, Form, Nav, Hero, Bento grid specifications
- **Responsive & Layout** — Subgrid, named `grid-template-areas`, `aspect-ratio`, content-based breakpoints via `@container`
- **Accessibility (WCAG 2.2 + EAA 2025)** — Contrast ratios (4.5:1 / 3:1), 2px focus indicators, 44×44 px touch targets, `prefers-reduced-motion`, ARIA minimalism
- **Micro-interactions & Animation** — CSS transitions preferred, compositor-only properties (`transform`, `opacity`), scroll-driven animations (`animation-timeline: scroll()` / `view()`), hover without `:hover`
- **Visual Trends 2026** — Bento grids CSS, glassmorphism (focalized), neumorphism documented as high-risk for interactive UI, mesh/aurora gradients CSS-only
- **Performance Visual** — `content-visibility`, `contain`, `will-change` (transient), AVIF/WebP/JPEG XL format decision table, variable fonts, CLS prevention
- **design.md** — local AI design-to-code handoff pattern (YAML front matter + Markdown prose)
- **Staff-Level Snippet** — Production HTML+CSS example consolidating `@layer`, tokens, bento grid, container queries, dark mode
- **Architectural Dictates** — 5 non-negotiable rules for component independence, viewport rejection, OKLCH-only, EAA compliance, zero main-thread scroll orchestration

### Infrastructure

- `.github/workflows/pr-validation.yml` — Automated PR validation enforcing issue linkage + type-label checks
- `.github/pull_request_template.md` — Aligned with workspace issue-first conventions
- `design.md` — Local design handoff demonstration with full token YAML + narrative rules

### Historical source note

The v3.0 release cited external sources for its examples. Those links are historical pointers, not current proof of browser support, ecosystem adoption, legal applicability, or repository fit. v3.0.1 moves current source pointers to the canonical package and requires verification before adding time-sensitive claims.
