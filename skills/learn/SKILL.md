---
name: learn
description: Use this skill when the user wants to add or update a memory entry. Takes a topic and content, places it in the right shard with proper confidence scoring, and updates the router if needed.
version: 1.0.0
---

# Learn — Add or Update Memory

The user wants to record something in Smart Memory. Parse their input using $ARGUMENTS.

Expected formats:
- `/smart-memory:learn The build command is pnpm build`
- `/smart-memory:learn testing: Always run unit tests before integration tests`
- `/smart-memory:learn` (no args — ask the user what to remember)

## Step 1: Parse the input

Determine:
- **Topic category**: What shard does this belong to? (build, testing, git, api, architecture, etc.)
- **Content**: The actual fact, pattern, or rule to remember
- **Is this a correction?**: Does it contradict an existing entry?

If no arguments were provided, ask the user what they want to remember.

## Step 2: Find or create the shard

1. Check existing shards in `.claude/memory/shards/` for the best match
2. If no shard fits, create a new one with a descriptive filename
3. If creating a new shard, add a routing rule to `.claude/memory/ROUTER.md`

## Step 3: Write the entry

### New entry
Add to the appropriate shard with initial confidence:

```markdown
## Entry Title [✓1 | YYYY-MM-DD]
Content of the memory entry. Keep it concise but include enough
detail to be actionable.
```

### Correction of existing entry
If this contradicts an existing entry:

1. Strike through the old entry and mark it SUPERSEDED:
```markdown
## ~~Old Entry Title~~ [SUPERSEDED YYYY-MM-DD]
~~Old content that is no longer accurate~~
```

2. Add the corrected entry directly below:
```markdown
## New Entry Title [✓1 | YYYY-MM-DD]
Corrected content.
```

### Update to existing entry
If this adds detail to an existing entry (not a contradiction), update the entry
in place and bump the ✓ count by 1. Update the date.

## Step 4: Confirm

Tell the user:
- What was recorded and in which shard
- The initial confidence score
- Whether it was a new entry, correction, or update
- If a new shard was created, mention the routing rule that was added
