# Memory Router

Before starting any task, match the user's request and the files involved against
the rules below. Read **at most 2-3 matching shards** — prefer the most specific match.
If no rule matches, proceed without loading shards.

Shards live in `.claude/memory/shards/`. Each entry inside a shard carries a
confidence annotation — follow the behavioral rules in `core.md`.

---

## Universal (always applies)

@.claude/memory/core.md

## By file pattern

<!-- Map glob patterns to the shard that covers them.
     Examples — uncomment and edit to match your project:

*.py, requirements.txt, pyproject.toml  →  read @.claude/memory/shards/python.md
*.ts, *.tsx, package.json               →  read @.claude/memory/shards/typescript.md
*.swift, *.xib, Info.plist              →  read @.claude/memory/shards/ios.md
Dockerfile, docker-compose*             →  read @.claude/memory/shards/docker.md
*.sql, migrations/*                     →  read @.claude/memory/shards/database.md
-->

## By task intent

<!-- Match keywords in the user's request to the right shard.
     Examples — uncomment and edit:

commit, push, PR, branch, merge, rebase →  read @.claude/memory/shards/git-workflow.md
test, spec, assert, coverage            →  read @.claude/memory/shards/testing.md
bug, fix, crash, error, debug           →  read @.claude/memory/shards/debugging.md
deploy, CI, CD, pipeline, release       →  read @.claude/memory/shards/devops.md
API, endpoint, route, schema, graphql   →  read @.claude/memory/shards/api.md
-->

## By project area

<!-- Map subdirectories or modules to shards.
     Examples — uncomment and edit:

src/auth/*          →  read @.claude/memory/shards/auth.md
src/components/*    →  read @.claude/memory/shards/ui-components.md
infra/*             →  read @.claude/memory/shards/infrastructure.md
-->

## Shard rules

- Load at most 2-3 shards per task. Prefer the most specific match.
- Each shard should stay under 80 lines. Split if it grows larger.
- After a user correction, update the relevant shard immediately.
- When creating a new shard, add a routing rule to this file.
