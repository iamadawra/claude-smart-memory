---
name: status
description: Use this skill to show the current state of Smart Memory — shard count, entry health, staleness, and router coverage. A quick health check for the memory system.
version: 1.0.0
---

# Smart Memory Status

Generate a health dashboard for the project's Smart Memory system.

## Step 1: Check if Smart Memory is initialized

Look for `.claude/memory/ROUTER.md` and `.claude/memory/core.md`.
If they don't exist, tell the user to run `/smart-memory:init` first and stop.

## Step 2: Inventory all shards

Read all `.md` files in `.claude/memory/shards/`. For each file, count:
- Total entries (## headings with confidence annotations)
- Healthy entries (✓3+ and validated within 30 days)
- Recent entries (✓1-2, validated within 30 days)
- Stale entries (marked ⚠️ STALE or unconfirmed >30 days)
- Superseded entries (marked SUPERSEDED)

## Step 3: Check router coverage

Read `.claude/memory/ROUTER.md` and determine:
- How many routing rules are active (uncommented)
- How many shards have at least one routing rule
- Any orphan shards (no rule points to them)

## Step 4: Check archive

If `.claude/memory/archive/` exists, count archived entries.

## Step 5: Display the dashboard

```
╔══════════════════════════════════════╗
║       Smart Memory Status            ║
╠══════════════════════════════════════╣
║ Shards:        N files               ║
║ Entries:       X total               ║
║   ✓3+ healthy: Y                     ║
║   ✓1-2 recent: Z                     ║
║   ⚠️  stale:    W                     ║
║   ✗ superseded: V                    ║
║                                      ║
║ Router Rules:  N active              ║
║ Coverage:      M/N shards routed     ║
║ Archived:      P entries             ║
║                                      ║
║ Last Maintenance: YYYY-MM-DD         ║
╚══════════════════════════════════════╝
```

If there are stale entries or orphan shards, add a recommendation:
- "Run `/smart-memory:maintain` to clean up N stale entries"
- "N shards have no routing rule — consider adding them to ROUTER.md"
