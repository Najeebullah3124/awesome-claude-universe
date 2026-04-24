# Changelog

All notable milestones for this **aggregate index** repository are documented here.  
Upstream projects keep their own changelogs; see each folder’s upstream link in [`MANIFEST.tsv`](MANIFEST.tsv).

## [1.0.0] — 2026-04-25

### Added

- Flat-layout monorepo bundling **70+** upstream snapshots (Claude Code, MCP, skills, hooks, editors, workflow tools).
- [`MANIFEST.tsv`](MANIFEST.tsv) mapping local folder names to canonical GitHub URLs.
- [`claude.txt`](claude.txt) as the human-readable source list with categories and notes.
- [`README.md`](README.md) with navigation, quick links, workflow diagram, full index, FAQ, and star history.
- [`scripts/sync_from_claude_txt.py`](scripts/sync_from_claude_txt.py) and [`scripts/clone_manifest.sh`](scripts/clone_manifest.sh) for regenerating and extending clones.

### Notes

- Some manifest URLs do not yet have a local folder (moved/404 upstream); see README FAQ.
- Example secrets in a few upstream test or env files were **sanitized** so pushes pass GitHub secret scanning.
- **GitHub Packages** is not used: this repository is not published as an npm or container artifact.

### Attribution

Each subdirectory retains its upstream authors and license files. This collection is **not affiliated** with Anthropic or the listed projects.

[1.0.0]: https://github.com/Najeebullah3124/awesome-claude-universe/releases/tag/v1.0.0
