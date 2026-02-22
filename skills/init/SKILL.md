---
name: init
description: Use this skill when the user wants to set up Smart Memory in their project. Initializes the memory directory structure, router, core rules, and generates initial shards by analyzing the project.
version: 1.0.0
---

# Initialize Smart Memory

The user wants to set up Smart Memory in their project. Follow these steps exactly.

## Step 1: Create the directory structure

Create these directories in the project root:

```
.claude/memory/shards/
.claude/memory/archive/
.claude/rules/
```

## Step 2: Copy the core files

1. Copy the **router template** from `${CLAUDE_PLUGIN_ROOT}/templates/ROUTER.md` to `.claude/memory/ROUTER.md`
2. Copy the **core rules** from `${CLAUDE_PLUGIN_ROOT}/templates/core.md` to `.claude/memory/core.md`

## Step 3: Create the auto-loading rule

Create `.claude/rules/memory-router.md` with this content:

```markdown
---
description: Smart Memory router — loads relevant memory shards per task
globs: **/*
---

Before starting any task, read `.claude/memory/ROUTER.md` and follow its routing
rules to load the relevant memory shards. Follow the confidence behavioral rules
in `.claude/memory/core.md`.
```

## Step 4: Analyze the project and generate initial shards

Scan the project to understand its structure. Look at:
- The tech stack (languages, frameworks, package managers)
- Build system (scripts in package.json, Makefile, build configs)
- Test setup (test runner, test directories)
- Git workflow (branch naming, existing PR templates)
- Key directories and their purposes

For each major area you discover, create a shard in `.claude/memory/shards/` with
entries annotated as `[✓1 | TODAY'S_DATE]` (since this is the first observation).

Common shards to create:
- `build.md` — build commands, dev server, environment setup
- `git-workflow.md` — branch strategy, commit conventions, PR process
- `testing.md` — test commands, test patterns, coverage requirements
- `architecture.md` — key directories, module structure, patterns used

## Step 5: Update the router

Uncomment and fill in the relevant routing rules in `.claude/memory/ROUTER.md`
based on the shards you created and the file patterns in the project.

## Step 6: Add to .gitignore

Append these lines to `.gitignore` if not already present:

```
# Smart Memory (local-only)
.claude/memory/archive/
```

The router, core rules, and shards should be committable so teams can share memory.
Only the archive (stale/superseded entries) stays local.

## Step 7: Report

Tell the user what was created:
- Number of shards generated
- Total memory entries with their initial confidence scores
- How to customize the router
- Remind them about `/smart-memory:learn` to add entries and `/smart-memory:maintain` for upkeep
