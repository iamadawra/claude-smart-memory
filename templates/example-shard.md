# Build & Dev Environment

## Build Command [✓5 | 2026-02-20]
Run `npm run build` from the project root. Output goes to `dist/`.
The build uses esbuild — not webpack. Config is in `esbuild.config.mjs`.

## Dev Server [✓3 | 2026-02-18]
`npm run dev` starts the dev server on port 3000 with hot reload.
Environment variables are loaded from `.env.local` (gitignored).

## Node Version [✓2 | 2026-02-10]
Project requires Node 20+. There is an `.nvmrc` file at the root.
CI enforces this via the `setup-node` action.

## ~~Package Manager~~ [SUPERSEDED 2026-02-05]
~~Uses npm with package-lock.json~~ → Migrated to pnpm in commit c4a1f2e.
Lock file is now `pnpm-lock.yaml`.

## Package Manager [✓2 | 2026-02-05]
Uses pnpm. Run `pnpm install` for dependencies.
`pnpm-lock.yaml` is committed. Do not use npm or yarn.

## Database Migrations [✓1 | 2026-01-15 | ⚠️ STALE]
Migrations run via `npx prisma migrate dev`. The schema is at
`prisma/schema.prisma`. Note: haven't verified this since the
ORM discussion in January — may have changed.
