# Core Memory Rules

## Confidence Annotation Format

Every memory entry carries an inline annotation after its heading:

    ## Entry Title [✓N | YYYY-MM-DD]

- `✓N`  — confirmed correct N times (higher = more reliable)
- `YYYY-MM-DD` — date the entry was last validated
- `⚠️ STALE` — appended when unconfirmed for >30 days
- `SUPERSEDED YYYY-MM-DD` — entry was contradicted and replaced

## How Confidence Changes Your Behavior

- **[✓3+]** entries — state as fact: "The build command is..."
- **[✓1-2]** entries — mild hedge: "Based on previous sessions..."
- **[⚠️ STALE]** entries — flag uncertainty: "This was noted a while ago and may be outdated — let me verify first."
- **[SUPERSEDED]** entries — never use. They exist only as audit trail.

## When to Update Entries

- **Bump ✓ count**: after using a memory successfully (no error, no user correction). Update the date.
- **Mark SUPERSEDED**: when a user corrects you, strike through the old entry and add the corrected version as `[✓1 | today]`.
- **Mark ⚠️ STALE**: during a `/smart-memory:maintain` sweep, any entry unconfirmed for >30 days.
- **Archive**: during maintenance, any entry marked STALE for >60 days moves to `.claude/memory/archive/`.
- **Promote**: entries with ✓10+ that represent stable, universal facts may be moved into this core file.
