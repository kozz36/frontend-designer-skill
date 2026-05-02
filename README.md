# 🎨 frontend-designer-skill

> **Framework-agnostic** frontend design skill for **UI/UX architecture**.
> Covers CSS layers, container queries, OKLCH design tokens, component patterns,
> WCAG 2.2 + EAA 2025 accessibility, scroll-driven animations, visual trends 2026,
> and Design.md (Google Labs standard for AI design-to-code).
> Based on real ecosystem research validated against live sources (May 2026).

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Why This Exists

AI agents (Cursor, Claude Code, Copilot) now consume our codebases directly. A poorly structured `SKILL.md` causes agents to hallucinate Tailwind defaults, propose deprecated BEM patterns, omit accessibility compliance, or generate non-deterministic color systems.

This skill is a **validated, opinionated reference** for frontend visual layer decisions — covering CSS architecture, design tokens, component patterns, accessibility mandates, animation strategy, performance visual, and the emerging `Design.md` AI-consumable specification.

Built from a 496-line research document analyzing the 2025–2026 frontend ecosystem (cascade layers, OKLCH, container queries, EAA 2025, bento grids), then cross-checked against live sources (W3C specifications, MDN, Evil Martians, Chromatic).

---

## 📦 Versions

| Version | File | Size | When to Use |
|---------|------|------|-------------|
| **v1.0** (Full) | [`versions/v1.0/SKILL.md`](versions/v1.0/SKILL.md) | ~400 lines | Senior designers, detailed token systems, full snippet reference, deep accessibility rules |
| **v1.0-lite** | [`versions/v1.0-lite/SKILL.md`](versions/v1.0-lite/SKILL.md) | ~270 lines | Rapid kickoffs, MVP decisions, CI/CD ingestion, under time pressure |

### What's Covered in v1.0

- ✅ **CSS Architecture 2026** — `@layer` cascade layers, native nesting, `:has()`, BEM obsolescence table
- ✅ **Design Tokens (3-Tier)** — Primitive → Semantic → Component, OKLCH mandatory, fluid typography (`clamp` + `cqi`), 8/4-point spacing
- ✅ **Component Patterns** — 5-responsibility model, card/modal/table/form/nav/hero/bento with container queries
- ✅ **Responsive & Layout** — Subgrid, named areas, `aspect-ratio`, content-based breakpoints
- ✅ **Accessibility** — WCAG 2.2 + EAA 2025, contrast 4.5:1 / 3:1, 2px focus, 44×44 touch targets, `prefers-reduced-motion`
- ✅ **Micro-interactions** — CSS transitions preferred, compositor-only properties, scroll-driven animations, hover without `:hover`
- ✅ **Visual Trends 2026** — Bento grids, glassmorphism (focalized), neumorphism prohibited, mesh/aurora gradients CSS-only
- ✅ **Performance Visual** — `content-visibility`, `contain`, AVIF/WebP table, variable fonts, CLS prevention
- ✅ **Design.md** — Google Labs AI design-to-code standard, YAML + Markdown, MCP consumption
- ✅ **Staff-Level Snippet** — Full HTML+CSS example with `@layer`, tokens, bento grid, dark mode
- ✅ **Architectural Dictates** — 5 non-negotiable rules for component independence, viewport rejection, OKLCH-only, EAA compliance, zero main-thread scroll orchestration

---

## 🚀 Quick Start

### For AI Agents (Cursor, Claude Code, etc.)

```bash
# Clone into your skills directory
git clone https://github.com/kozz36/frontend-designer-skill.git

# Use the version that matches your need:
# - Full  → detailed token systems, accessibility audits, full snippet
# - Lite  → rapid layout decisions, component patterns, quick checks
```

### For Human Architects

Open `versions/v1.0/SKILL.md` and jump to:
- **Section 1** — CSS Architecture (`@layer`, nesting, `:has()`)
- **Section 2** — Design Tokens (OKLCH, fluid typography, dark mode)
- **Section 5** — Accessibility (contrast, focus, EAA 2025)
- **Section 10** — Staff-Level Snippet (copy-paste production CSS)
- **Section 11** — Architectural Dictates (non-negotiable rules)

---

## 📁 Structure

```
versions/
├── v1.0/
│   └── SKILL.md              # Full reference (2026)
└── v1.0-lite/
    └── SKILL.md              # Condensed for rapid decisions
docs/
├── CHANGELOG.md              # Verified version history
└── CONTRIBUTING.md           # How to contribute improvements
```

---

## 🔍 Verification Methodology

Every claim was validated against authoritative sources:

| Claim | Verification Method | Status |
|-------|---------------------|--------|
| CSS `@layer` resolves specificity deterministically | W3C CSS Cascade Layers spec | ✅ Confirmed |
| Native CSS Nesting is production-ready (no preprocessor) | W3C CSS Nesting Module Level 1 | ✅ Confirmed |
| `:has()` supported universally (2024+) | MDN + Can I Use data | ✅ Confirmed |
| OKLCH perceptually uniform vs HSL | Evil Martians + CSS Color Module Level 5 | ✅ Confirmed |
| Container queries replace media queries for components | MDN Container Queries + LogRocket 2026 analysis | ✅ Confirmed |
| WCAG 2.2 focus indicator: 2px CSS minimum | W3C Understanding SC 2.4.13 | ✅ Confirmed |
| EAA 2025 enforceable since June 2025 | Chromatic + Telerik + WCAG.com | ✅ Confirmed |
| `animation-timeline: scroll()` / `view()` production-ready | MDN Scroll-Driven Animations | ✅ Confirmed |
| Neumorphism violates EAA 2025 contrast thresholds | UX Planet analysis + EAA technical docs | ✅ Confirmed |
| `light-dark()` CSS function native support | MDN + browser baseline 2024 | ✅ Confirmed |
| Design.md launched by Google Labs (Apr 2026) | Google Labs publication + MCP integration docs | ✅ Confirmed |
| Subgrid production-ready in all modern engines | MDN + Can I Use | ✅ Confirmed |

---

## 🤝 Contributing

This skill is maintained as a living document. See [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) for:
- How to propose additions (new CSS features, updated browser support)
- Verification requirements before merging
- Style guide (tables > narrative, decision trees > lists, prohibitions explicit)

---

## 📝 License

Apache-2.0

---

**Maintained by:** [@kozz36](https://github.com/kozz36)  
**Research base:** "Investigación Técnica: Arquitectura y Diseño Frontend Framework-Agnóstico (2026)" (496-line ecosystem analysis, May 2026)
