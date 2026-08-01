---
name: corvid-web-bun
description: Build, change, test, and release CorvidLabs web projects that use Bun. Use for TypeScript, HTML, CSS, browser UI, Bun servers, package scripts, or web CI; defer architecture and framework decisions to the repository's local instructions.
---

# CorvidLabs Web with Bun

Use Bun and the repository's Fledge tasks. This is a shared operating baseline, not a
replacement for a repository's `AGENTS.md`, framework conventions, or product specs.

## Start with the project

1. Locate the actual worktree and instructions before editing:

   ```sh
   fledge let context --pack brief --cwd <worktree> --json
   ```

2. Read the project instructions, `package.json`, and the affected spec or component.
3. Use the Fledge task named by the project. Inspect available tasks if it is unclear:

   ```sh
   fledge run --help
   fledge lanes --help
   ```

Do not copy generic commands into project documentation when the repository already
defines an authoritative lane.

## Build with Bun

- Use `bun`, never `npm`, `yarn`, or `pnpm`, for dependencies and scripts.
- Prefer `Bun.serve()` for a Bun server and Bun's built-in APIs before adding a server
  framework or runtime dependency.
- Keep TypeScript strict. Model uncertain external values as `unknown`, then validate
  them at the boundary; do not introduce `any` to make a build pass.
- Keep browser data, credentials, and server-only behavior on the correct side of the
  boundary. Never expose secrets in client bundles, fixtures, logs, or screenshots.
- Follow the repository's existing UI system and accessibility checks. Do not create a
  second component, styling, or state-management convention for one feature.

## Change and verify

Implement the smallest complete vertical change: user-visible behavior, accessible UI,
typed boundary, test coverage, and any canonical spec or documentation the project
requires. Exercise the real package scripts or Fledge lane, not an invented substitute:

First discover the project's declared Fledge task or lane, then run its exact name. Fall back
to the repository's Bun scripts only when there is no Fledge equivalent; do not assume every
project defines `test` or `verify`.

For UI changes, test keyboard navigation, focus behavior, loading/error/empty states,
and responsive layout where the product supports it. Run and report the project's AXE coverage
(or add it if none exists), and verify WCAG AA contrast and keyboard focus behavior. Use a
project-provided visual or end-to-end task when available. Do not claim a browser workflow
works solely because a TypeScript build passed.

## Before push

Read the exact diff, run the required project lane, and report the commands and results.
Treat a CI-only failure as a reproduction task: identify the repository-relative fixture,
environment assumption, platform difference, or missing generated artifact before
changing production code. Keep test data committed, deterministic, and free of absolute
local paths.

If the change affects public behavior, API shape, configuration, or documentation, keep
the corresponding project spec in the same pull request. Use the shared `spec-sync`
skill and the repository-generated Spec Sync skill for the lifecycle details.
