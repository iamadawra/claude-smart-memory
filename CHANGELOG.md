# Changelog

All notable changes to Claude Smart Memory will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.0] - 2026-02-22

### Added
- Routing manifest system (`ROUTER.md`) for context-aware memory loading
- Confidence-scored memory entries with `[✓N | date]` annotations
- Temporal decay with automatic staleness detection
- Correction propagation via SUPERSEDED markers
- Four skills: `init`, `maintain`, `learn`, `status`
- Stop hook for automatic correction detection
- Templates for router, core rules, and example shards
- Full documentation with comparison to existing tools
