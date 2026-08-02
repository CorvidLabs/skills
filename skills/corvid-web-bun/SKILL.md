---
name: corvid-web-bun
description: Build, modify, test, review, or release CorvidLabs Bun web projects for TypeScript, UI, servers, and CI.
---

# CorvidLabs Web with Bun

Use Bun and the repository's Fledge tasks when the project declares them. This is a shared
operating baseline, not a replacement for a repository's `AGENTS.md`, framework conventions,
product specs, or an existing non-Bun package manager.

## Install

**This catalog skill** (engineering baseline; not a product plugin):

```sh
fledge plugins install CorvidLabs/skills
fledge skills install corvid-web-bun --host <codex|claude|cursor|gemini|grok|openai>
```

Requires Fledge (and Bun when the project uses it); there is no separate product package
for this skill.

## Start with the project

1. Confirm the repository root and its tracked instructions before editing:

   ```sh
   fledge work status
   fledge run --list
   fledge introspect --json
   git status --short --branch
   git ls-files
   ```

   In public-only or public-evidence work, do not use federated Let discovery (project-scope
   still pulls user skill catalogs by default). When local agent metadata is explicitly
   authorized, use the `let` skill.

2. Read the project instructions, `package.json` / lockfile, and the affected spec or component.
3. Use the Fledge task named by the project. Inspect available tasks if it is unclear:

   ```sh
   fledge run --help
   fledge lanes list
   fledge lanes --help
   ```

Do not copy generic commands into project documentation when the repository already
defines an authoritative lane.

## Build with Bun

- Use Bun for dependencies and scripts when `package.json`, the lockfile, and local instructions
  declare Bun. Prefer `bun install`, `bun test`, `bun run <script>`, and `bun <file>`.
  Preserve another explicitly selected package manager, especially in workspaces;
  never introduce a second lockfile merely to apply this baseline.
- Prefer `Bun.serve()` for a Bun server and Bun's built-in APIs (`Bun.file`, `bun:sqlite`,
  `Bun.redis`, `Bun.sql` where the project already uses them) before adding a server
  framework or runtime dependency.
- Keep TypeScript strict. Model uncertain external values as `unknown`, then validate
  them at the boundary; do not introduce `any` to make a build pass.
- Keep browser data, credentials, and server-only behavior on the correct side of the
  boundary. Never expose secrets in client bundles, fixtures, logs, or screenshots.
- Follow the repository's existing UI system and accessibility checks. Do not create a
  second component, styling, or state-management convention for one feature.

## Change and verify

For an implementation request, make the smallest complete change across only the affected
layers: user-visible behavior and accessible UI for interface work, typed boundaries for data
or service work, focused tests, and any canonical spec or documentation the project requires.
Exercise the real package scripts or Fledge lane, not an invented substitute:

First discover the project's declared Fledge task or lane, then run its exact name. Fall back
to the repository's Bun scripts only when there is no Fledge equivalent; do not assume every
project defines `test` or `verify`.

For UI changes, test keyboard navigation, focus behavior, loading/error/empty states,
and responsive layout where the product supports it. Run and report the project's AXE coverage,
and verify WCAG AA contrast and keyboard focus behavior. Add missing accessibility coverage only
when implementation is authorized. Use a project-provided visual or end-to-end task when
available. Do not claim a browser workflow works solely because a TypeScript build passed.

## Review without mutating

For a review-only request, inspect the existing diff and report actionable findings with file
and line evidence. Do not edit files, add coverage, update specs, or run commands that mutate
the repository unless the user separately authorizes implementation.

## Before push

Read the exact diff, run the required project lane, and report the commands and results.
Treat a CI-only failure as a reproduction task: identify the repository-relative fixture,
environment assumption, platform difference, or missing generated artifact before
changing production code. Keep test data committed, deterministic, and free of absolute
local paths.

If the change affects public behavior, API shape, configuration, or documentation, keep
the corresponding project spec in the same pull request. Use the shared `spec-sync`
skill and the repository-generated Spec Sync skill for the lifecycle details. For revision-
tied CI language, use `ci-release-hygiene`.
