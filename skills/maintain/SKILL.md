---
name: maintain
description: Use this skill to run a maintenance sweep on Smart Memory. Detects stale entries, archives old ones, checks for contradictions, and reports memory health. Run this periodically (weekly or monthly) to keep memory accurate.
version: 1.0.0
---

# Maintain Smart Memory

Run a full maintenance sweep across all memory shards. Follow each phase in order.

## Phase 1: Inventory

Read all `.md` files in `.claude/memory/shards/`. For each file, parse every entry
(identified by `##` headings with confidence annotations). Build an inventory:

- Entry title
- Confidence score (✓N)
- Last validated date
- Current flags (STALE, SUPERSEDED, or clean)

## Phase 2: Staleness Detection

For each entry, apply these rules using today's date:

| Condition | Action |
|---|---|
| Last validated >30 days ago AND ✓ count < 3 | Add `⚠️ STALE` flag |
| Already STALE AND last validated >60 days ago | Move to archive (Phase 3) |
| ✓ count >= 10 AND never been STALE | Candidate for promotion to `core.md` |

Update the annotations inline. For example:
- `[✓2 | 2025-12-15]` becomes `[✓2 | 2025-12-15 | ⚠️ STALE]`

## Phase 3: Archival

For entries that are >60 days stale:

1. Move the entry text to `.claude/memory/archive/YYYY-MM.md` (grouped by month)
2. Remove it from the active shard
3. If the shard becomes empty after archival, delete the shard file and remove its routing rule from `ROUTER.md`

## Phase 4: Contradiction Scan

Scan across all shards for potential contradictions:
- Two entries about the same topic with different claims
- SUPERSEDED entries whose replacements are also now STALE
- Entries that reference files or commands that no longer exist in the project

Flag contradictions for the user to resolve — do not auto-resolve them.

## Phase 5: Router Hygiene

Check `ROUTER.md` for:
- Rules pointing to shards that no longer exist (remove them)
- Shards that exist but have no routing rule (suggest adding one)
- Rules with file patterns that match no files in the project (suggest removal)

## Phase 6: Report

Present a summary table:

```
Smart Memory Health Report
─────────────────────────
Shards:           N active, M archived
Entries:          X total (Y healthy, Z stale, W superseded)
Archived today:   N entries moved to archive
Contradictions:   N found (details below)
Router:           N rules, M orphaned

Entries needing attention:
- [STALE] "Database Migrations" in shards/build.md — last confirmed 45 days ago
- [CONTRADICTION] "API Format" claimed in both shards/api.md and shards/backend.md
```

End by reminding the user they can verify stale entries by checking the actual
project state, then bump the ✓ count if the entry is still correct.
