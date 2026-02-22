# Claude Smart Memory

**Routing manifest + confidence-scored memory shards for Claude Code.**

Replace your monolithic 200-line `MEMORY.md` with a surgical system: a ~30-line router always loaded, relevant shards pulled in per-task, every entry scored for reliability. Pure markdown. Zero dependencies. No databases, no servers, no background processes.

## The Problem

Claude Code's built-in memory has three fundamental limitations:

1. **Retrieval is binary.** Your `MEMORY.md` (up to 200 lines) is dumped into every session regardless of what you're working on. Doing a git rebase? You're still paying context tokens for your database migration notes.

2. **No signal about reliability.** A fact noted once 4 months ago looks identical to something confirmed yesterday. Claude states both with equal confidence — even when the old one is wrong.

3. **Memory rots silently.** Your API used REST when you wrote that note. It uses GraphQL now. Nothing flags the stale entry. Claude confidently generates REST client code. You correct it. Repeat next session.

## The Solution

Smart Memory splits memory into two layers:

### The Router (~30 lines, always loaded)

A tiny routing table that maps **what you're doing** to **which memories matter**:

```markdown
# Memory Router

## By file pattern
*.py, requirements.txt  →  read @.claude/memory/shards/python.md
*.ts, *.tsx              →  read @.claude/memory/shards/typescript.md

## By task intent
commit, push, PR, branch →  read @.claude/memory/shards/git-workflow.md
test, spec, assert       →  read @.claude/memory/shards/testing.md
bug, fix, crash, error   →  read @.claude/memory/shards/debugging.md
```

When Claude starts a task, it checks the router and loads **only 1-2 relevant shards** (~80 lines) instead of everything. Context cost drops from 200 lines of grab-bag to ~30 lines of router + ~80 lines of precisely relevant knowledge.

### Confidence-Scored Entries

Every entry in a shard carries metadata:

```markdown
## Build Command [✓5 | 2026-02-20]
pnpm build — output goes to dist/

## Database Migrations [✓1 | 2025-12-15 | ⚠️ STALE]
npx prisma migrate dev — may have changed since the ORM discussion

## ~~API Format~~ [SUPERSEDED 2026-01-10]
~~REST endpoints at /api/v1~~ → migrated to GraphQL
```

The annotations change Claude's behavior:

| Annotation | Claude's behavior |
|---|---|
| `[✓3+]` | States as fact: *"The build command is..."* |
| `[✓1-2]` | Hedges slightly: *"Based on previous sessions..."* |
| `[⚠️ STALE]` | Flags uncertainty: *"This was noted a while ago — let me verify first."* |
| `[SUPERSEDED]` | Never uses. Kept only as audit trail. |

**The staleness flag is the key insight.** It turns Claude from "confidently wrong" into "appropriately cautious" — which means it checks the actual codebase before acting on old information.

## How It Compares

| | Smart Memory | [claude-mem](https://github.com/thedotmack/claude-mem) | [total-recall](https://github.com/davegoldblatt/total-recall) | [Memory Bank](https://github.com/hudrazine/claude-code-memory-bank) |
|---|---|---|---|---|
| **Always-loaded cost** | ~30 lines (router only) | ~100 tokens (index) | ~1500 words | ~500 lines (6 files) |
| **Retrieval** | File-pattern + intent matching | Vector similarity search | Manual slash commands | Always load everything |
| **Knows what's reliable** | Yes (confidence scores) | No | No | No |
| **Detects stale info** | Yes (temporal decay) | No | No | No |
| **Handles corrections** | Yes (SUPERSEDED markers) | No | Yes (manual propagation) | No |
| **Dependencies** | None (pure markdown) | SQLite + ChromaDB + Bun + HTTP server | None (markdown + commands) | None (markdown) |
| **Setup time** | 2 minutes (one slash command) | ~10 minutes (plugin + worker) | ~5 minutes (copy CLAUDE.md rules) | ~5 minutes (copy template) |
| **Team shareable** | Yes (commit shards to git) | No (local DB) | Partially (working memory only) | Yes (commit all files) |

### Why not claude-mem?

claude-mem is powerful but heavy. It runs a background HTTP worker, requires SQLite + ChromaDB, auto-installs Bun and uv, and compresses observations with AI — adding latency and complexity. Smart Memory achieves selective retrieval through a 30-line routing table instead of a vector database. The tradeoff: claude-mem handles implicit recall ("what did I do last Tuesday?"), while Smart Memory handles explicit knowledge ("how do I build this project?"). If you need session replay, use claude-mem. If you need reliable, current project knowledge, use Smart Memory.

### Why not total-recall?

total-recall pioneered the "write gate" concept (not everything should be remembered) and correction propagation. Smart Memory builds on both ideas but adds two things total-recall lacks: **automatic staleness detection** (entries decay over time without manual intervention) and **context-aware routing** (memories load based on what you're doing, not just when you ask for them). total-recall's working memory also costs ~1500 words always-loaded; Smart Memory's router costs ~30 lines.

## Installation

### Via Plugin (recommended)

```
/plugin marketplace add iamadawra/claude-smart-memory
/plugin install smart-memory
```

Then in any project:
```
/smart-memory:init
```

### Manual Setup

1. Clone this repo:
   ```bash
   git clone https://github.com/iamadawra/claude-smart-memory.git
   ```

2. Load as a local plugin:
   ```bash
   claude --plugin-dir /path/to/claude-smart-memory
   ```

3. Initialize in your project:
   ```
   /smart-memory:init
   ```

### Minimal Manual Setup (no plugin)

If you just want the pattern without the plugin, copy the templates into your project manually:

```bash
mkdir -p .claude/memory/shards .claude/memory/archive .claude/rules

# Copy from the templates/ directory in this repo:
cp templates/ROUTER.md .claude/memory/ROUTER.md
cp templates/core.md .claude/memory/core.md
```

Create `.claude/rules/memory-router.md`:
```markdown
---
description: Smart Memory router
globs: **/*
---
Before starting any task, read `.claude/memory/ROUTER.md` and follow its
routing rules to load the relevant memory shards.
```

Then customize `ROUTER.md` and create your shards.

## Usage

### Initialize (`/smart-memory:init`)

Run once per project. Analyzes your codebase, creates the memory directory structure, generates initial shards, and wires up the router.

```
> /smart-memory:init

Created .claude/memory/ with 4 shards:
  - build.md (3 entries, all ✓1)
  - git-workflow.md (2 entries, all ✓1)
  - testing.md (2 entries, all ✓1)
  - architecture.md (4 entries, all ✓1)
Router configured with 6 routing rules.
```

### Learn (`/smart-memory:learn`)

Add a new memory or correct an existing one.

```
> /smart-memory:learn The CI requires Node 20 and runs on GitHub Actions

Added to shards/build.md:
  ## CI Environment [✓1 | 2026-02-22]
  CI requires Node 20 and runs on GitHub Actions.
```

Corrections are handled automatically:

```
> /smart-memory:learn Actually we moved CI to GitLab CI last week

Updated shards/build.md:
  ## ~~CI Environment~~ [SUPERSEDED 2026-02-22]
  ~~CI requires Node 20 and runs on GitHub Actions.~~

  ## CI Environment [✓1 | 2026-02-22]
  CI runs on GitLab CI. Requires Node 20.
```

### Status (`/smart-memory:status`)

Quick health check.

```
> /smart-memory:status

╔══════════════════════════════════════╗
║       Smart Memory Status            ║
╠══════════════════════════════════════╣
║ Shards:        4 files               ║
║ Entries:       11 total              ║
║   ✓3+ healthy: 6                     ║
║   ✓1-2 recent: 3                     ║
║   ⚠️  stale:    1                     ║
║   ✗ superseded: 1                    ║
║ Router Rules:  6 active              ║
╚══════════════════════════════════════╝

Run /smart-memory:maintain to clean up 1 stale entry.
```

### Maintain (`/smart-memory:maintain`)

Periodic cleanup. Run weekly or monthly.

```
> /smart-memory:maintain

Smart Memory Health Report
──────────────────────────
Scanned 4 shards, 11 entries.
  - Flagged STALE: "Database Migrations" in shards/build.md (45 days unconfirmed)
  - Archived: "Old Deploy Script" from shards/devops.md (90 days stale)
  - Router: removed 1 orphaned rule pointing to deleted shard
```

## Directory Structure

After initialization, your project will have:

```
your-project/
├── .claude/
│   ├── memory/
│   │   ├── ROUTER.md          # Routing manifest (always loaded via rule)
│   │   ├── core.md            # Confidence rules and universal conventions
│   │   ├── shards/
│   │   │   ├── build.md       # Build system, dev environment
│   │   │   ├── testing.md     # Test patterns, commands
│   │   │   ├── git-workflow.md
│   │   │   └── ...
│   │   └── archive/           # Stale entries moved here (gitignored)
│   │       └── 2026-01.md
│   └── rules/
│       └── memory-router.md   # Auto-loading rule for the router
```

**What to commit:** `ROUTER.md`, `core.md`, and all shards — so your team shares the same project knowledge.

**What to gitignore:** `archive/` — stale entries are local-only.

## Customizing the Router

The router is just a markdown file. Edit `.claude/memory/ROUTER.md` to add your own rules:

```markdown
## By file pattern
*.rb, Gemfile           →  read @.claude/memory/shards/ruby.md
*.go, go.mod            →  read @.claude/memory/shards/golang.md

## By task intent
deploy, release, ship   →  read @.claude/memory/shards/deployment.md
auth, login, session    →  read @.claude/memory/shards/authentication.md

## By project area
src/payments/*          →  read @.claude/memory/shards/payments.md
```

**Rules of thumb:**
- Keep the router under 50 lines
- Each shard under 80 lines — split if larger
- Load at most 2-3 shards per task
- More specific rules should come before general ones

## How Confidence Scoring Works

The lifecycle of a memory entry:

```
[New fact learned]
     │
     ▼
  [✓1 | today]  ──── used successfully ────→  [✓2 | today]  ───→  [✓3 | today] ...
     │                                              │
     │ (30 days, no confirmation)                   │ (user corrects)
     ▼                                              ▼
  [✓1 | old | ⚠️ STALE]                    [SUPERSEDED today]
     │                                       + new [✓1 | today]
     │ (60 more days)
     ▼
  [archived]
```

Confidence naturally increases through use and decreases through time. No manual bookkeeping needed — Claude bumps scores automatically when memories prove correct, and the maintain skill handles decay.

## Design Philosophy

1. **Pure markdown.** No databases. No servers. No build step. If you can `cat` a file, you can use Smart Memory.

2. **Claude does the thinking.** The routing table and confidence rules are instructions for Claude, not code that processes data. Claude's intelligence handles the matching, scoring, and behavioral adaptation.

3. **Minimal always-on cost.** The router costs ~30 tokens in every session. Everything else is loaded on demand. Compare this to systems that dump 200+ lines into every context.

4. **Self-correcting.** Corrections propagate immediately via SUPERSEDED markers. Stale entries decay naturally. Wrong memories don't persist — they get flagged, then archived.

5. **Team-friendly.** Shards are plain files in `.claude/`. Commit them to git and your whole team benefits from shared project knowledge.

## FAQ

**Can I use this alongside Claude's built-in auto-memory?**
Yes. Smart Memory lives in `.claude/memory/` while auto-memory uses `~/.claude/projects/<path>/memory/`. They don't conflict. You can disable auto-memory (`CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`) if you prefer Smart Memory exclusively.

**What if the router doesn't match anything?**
Claude proceeds normally without loading any shards. The universal rules in `core.md` still apply (loaded via the `@` import in the router).

**How many shards should I have?**
Start with 3-5 covering your main workflow areas. Add more as your project grows. There's no hard limit, but each shard should stay under 80 lines.

**Can I use this without the plugin?**
Yes. The plugin just provides the slash commands for convenience. The core system is just a file structure convention and a `.claude/rules/` file. See [Minimal Manual Setup](#minimal-manual-setup-no-plugin).

**Does this work with custom agents?**
Yes. Custom agents that have access to the project directory will see the `.claude/rules/memory-router.md` file and follow the routing instructions.

## License

[MIT](LICENSE)
