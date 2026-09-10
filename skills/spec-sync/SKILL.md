---
name: spec-sync
description: Keep project contracts, implementation, and verification evidence synchronized through shipped SpecSync 6.0.
---

# Spec Sync

Use this catalog skill as **principles** for repositories using SpecSync. The
repository-generated local skill and configuration are authoritative for that
repo's command syntax, paths, policy, and migration state. Never overwrite a
generated local skill with this catalog entry.

Keep requirements, module contracts, implementation, and test evidence together
through delivery. Use Fledge where it covers the operation.

## Discover first

Use repository-defined Fledge tasks and lanes first. `fledge spec` exposes part of
SpecSync; inspect its help. For lifecycle operations it does not expose, use the
independently distributed **`specsync`** binary (not `spec-sync`).

```sh
fledge spec --help
specsync --version
specsync change --help
```

Prefer shipped **6.0.0** from cargo (`cargo install specsync`) or
[GitHub Releases](https://github.com/CorvidLabs/spec-sync/releases). Homebrew may
still lag on 5.2.0. 6.0.0 is Latest; do not prefer a maintainer-designated
release candidate. Keep exact pins in project configuration and CI.

Action consumers pin both the Action ref and the downloaded binary:

```yaml
- uses: CorvidLabs/spec-sync@v6.0.0
  with:
    version: '6.0.0'
```

The tagged Action's default `version` input is still `6.0.0-rc.14`; set
`version` explicitly.

If the installed binary or generated instructions describe an older workflow,
identify the mismatch and use the documented upgrade/migration path within the
task's scope. Do not silently reinterpret an existing change ledger.

## Check is the product; SDD is opt-in

`specsync check` is the product. Spec-driven development is off until
`specsync change adopt`. When SDD is not adopted, keep specs and code
synchronized with `specsync check` (and Fledge tasks that wrap it). Do not
invent a change workspace.

## Adopted change path

When adopted, one path. Use slug ids returned by `change new` (for example
`add-passkeys`), not `CHG-NNNN` allocation.

```text
new → answer → approve --actor → implement → change check --commit → review --reviewer → ship/finalize
```

1. `specsync change new`, then `change answer` until the interview and selected
   artifacts are complete. Requirements need stable identifiers and testable
   outcomes.
2. Record the single digest-bound scope approval with
   `change approve --actor`. Reuse explicit user approval when it covers the
   exact definition; changed scope requires renewed approval.
3. Implement code, canonical contracts, and tests together on the delivery
   branch.
4. `specsync change check <id> --commit` for scoped spec↔code verification of
   this change. It does not run project tests; use the repository's Fledge
   checks for those. `change audit` is project health over active workspaces
   and living specs; archives are history.
5. Record the scoped implementation review with `change review --reviewer`.
   The same actor may approve and review. A local reviewer label is not a
   GitHub approval.
6. `change ship` or `change finalize`. Do not commit between review and
   ship/finalize. Commit the archive result on the same delivery PR, wait for
   required checks, then merge on GitHub. SpecSync does not merge.

v1 `start` / `verify` / `accept` / `archive` are recovery only for existing
legacy changes. Consult local migration guidance; do not use them for new work.

Edits to delivery inputs stale verification or review. Finish those edits
before recording evidence, and rerun the affected checks when stale. Use
`change status <id>` for the next action.

## Preserve context and generated guidance

Keep durable decisions in `context.md` or its project equivalent and
requirement-to-test evidence in `testing.md`. Update companions that exist or
are required; do not create empty files for ceremony. Preserve accepted history
and use a successor change for new behavior rather than rewriting historical
evidence.

Refresh generated host skills with the selected binary's documented generator,
commonly `specsync agents install`, and inspect the diff. Install
`spec-sync-routing` beside a generated local skill; never install this catalog
entry over that path. Project layout markers are not binary version pins; let
supported migration commands manage them.
