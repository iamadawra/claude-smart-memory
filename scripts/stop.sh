#!/usr/bin/env bash
# Smart Memory — Stop hook
# Runs after Claude finishes a response. Checks if the session involved
# corrections that should be persisted to memory shards.
#
# Exit codes:
#   0 — no action needed (or reminder output for Claude)
#   2 — block (not used here)

set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Extract transcript path from the hook input
TRANSCRIPT_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('transcript_path', ''))
" 2>/dev/null || echo "")

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
    exit 0
fi

# Check the working directory for Smart Memory setup
CWD=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('cwd', ''))
" 2>/dev/null || echo "")

if [ -z "$CWD" ] || [ ! -d "$CWD/.claude/memory" ]; then
    exit 0
fi

# Look at the last 50 lines of the transcript for correction signals
# These patterns suggest the user corrected Claude during the session
CORRECTION_PATTERNS='actually|that.s wrong|that.s not right|no,? (it|the|that|you)|correction:|incorrect|not quite|wrong approach|should be .* instead|please update|remember that|don.t forget'

RECENT_CONTENT=$(tail -50 "$TRANSCRIPT_PATH" 2>/dev/null || echo "")

if echo "$RECENT_CONTENT" | grep -qiE "$CORRECTION_PATTERNS"; then
    # Output a reminder for Claude to see
    cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"Stop","notification":"[Smart Memory] Corrections detected in this session. If any corrections relate to knowledge in your memory shards (.claude/memory/shards/), update the relevant entries: mark old info as SUPERSEDED and add the corrected version with [✓1 | today's date]."}}
EOF
fi

exit 0
