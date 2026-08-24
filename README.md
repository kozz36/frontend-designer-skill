# frontend-designer-skill

Framework-agnostic frontend-design skills for UI architecture, tokens, responsive behavior, accessibility, motion, and visual performance decisions.

## Current skills

`skills/` is the only install surface. The current release family is v3.0.1.

| Skill | Canonical entrypoint | Use |
|---|---|---|
| `frontend-designer` | [`skills/frontend-designer/SKILL.md`](skills/frontend-designer/SKILL.md) | Full runtime contract with local decision references. |
| `frontend-designer-lite` | [`skills/frontend-designer-lite/SKILL.md`](skills/frontend-designer-lite/SKILL.md) | Standalone runtime with inline decision gates, safeguards, and examples. |

Both skills are version `3.0.1`. The full skill's detailed reference material is located beside its canonical entrypoint in [`skills/frontend-designer/references/`](skills/frontend-designer/references/).

## Install

Discover the public package on [skills.sh](https://skills.sh/kozz36/frontend-designer-skill), then install one or both canonical skills with the `skills` CLI:

```bash
# List the canonical skills from a checkout without installing
npx skills add . --list

# Install the full skill
npx skills add kozz36/frontend-designer-skill --skill frontend-designer

# Install the lite skill
npx skills add kozz36/frontend-designer-skill --skill frontend-designer-lite

# Install both current skills
npx skills add kozz36/frontend-designer-skill --skill frontend-designer --skill frontend-designer-lite
```

The CLI resolves canonical `SKILL.md` entrypoints under `skills/`; do not install from `versions/`.

## Runtime and reference split

- `skills/frontend-designer/SKILL.md` is the compact runtime contract: activation, evidence gates, safeguards, execution steps, and output requirements.
- `skills/frontend-designer/references/technical-reference.md` contains conditional decision guidance and examples.
- `skills/frontend-designer/references/source-index.md` contains source pointers and rules for verifying time-sensitive claims.
- `skills/frontend-designer-lite/SKILL.md` is a standalone runtime that keeps its decision gates, safeguards, and examples inline rather than using a separate reference directory.

The guidance is project-agnostic: it gates CSS architecture, naming, color notation, theming, layout, trends, browser features, commands, and migration work on repository evidence rather than prescribing a universal stack.

## Archive history

[`versions/`](versions/) preserves historical releases and current release snapshots for audit only. Archive entrypoints use `ARCHIVE.md`, not `SKILL.md`; they are intentionally non-installable. Historical content is preserved at its original release path apart from the archive-entrypoint filename.

| Archive | Purpose |
|---|---|
| [`versions/v1.0/`](versions/v1.0/) | Historical full release. |
| [`versions/v1.0-lite/`](versions/v1.0-lite/) | Historical lite release. |
| [`versions/v3.0/`](versions/v3.0/) | Historical compact-runtime release. |
| [`versions/v3.0.1/`](versions/v3.0.1/) | Snapshot of the canonical full v3.0.1 package. |
| [`versions/v3.0.1-lite/`](versions/v3.0.1-lite/) | Snapshot of the canonical lite v3.0.1 skill. |

## Contributing

See [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) for issue-first contribution policy and [`docs/CHANGELOG.md`](docs/CHANGELOG.md) for release history.

## License

Apache-2.0
