---
name: spec-sync
description: Keep project contracts, implementation, and verification evidence synchronized through the SpecSync change lifecycle.
---

# Spec Sync

Use this baseline for meaningful source, test, public documentation, schema, or
configuration changes in a repository using SpecSync. Keep requirements, module contracts,
implementation, and test evidence together through delivery.

## Discover the supported workflow

Use repository-defined Fledge tasks and lanes first. `fledge spec` exposes part of
SpecSync; inspect its help before using it. For lifecycle operations it does not expose,
use the independently distributed **`specsync`** binary. Discover installed plugins too;
a wrapper's presence does not imply it supports the full lifecycle.

```sh
fledge spec --help
specsync --version
specsync change --help
```

Prefer the current supported workflow, including the latest maintainer-designated release
candidate while the next release is being qualified. Do not choose an older stable line
merely because it lacks an RC suffix. Resolve the actual release from
[upstream releases](https://github.com/CorvidLabs/spec-sync/releases) when installation or
an upgrade is needed; package-manager defaults may lag. Keep exact tool pins in project
configuration and CI, not in this shared skill.

Read the repository-generated skill and configuration for its command syntax, paths,
policy, and migration state. If the installed binary or generated instructions describe
an older workflow, identify the mismatch and use the documented upgrade/migration path
within the task's scope. Do not silently reinterpret an existing change ledger.

## One change workspace per delivery

1. Read the affected canonical specs and available companions. Define intent, affected
   modules and paths, semantic deltas, and acceptance criteria in one change workspace.
   Use `change new` and `change answer` as documented; fill only the artifacts selected
   for the change. Requirements need stable identifiers and testable outcomes.
2. Obtain the single digest-bound scope approval and record it with `change approve`.
   Never invent or self-grant approval. Reuse explicit user approval when it covers the
   exact definition; changed scope requires renewed approval.
3. Implement code, canonical contracts, and tests together on the delivery branch.
4. Run `change check <id>` for scoped verification and the repository's relevant Fledge
   checks. Apply stronger checks when repository policy or the change requires them.
   `change audit` checks active workspaces and living specs; archives are historical
   evidence, not a mandatory full-history validation pass on every edit.
5. Complete ordinary PR review and the required scoped review of the implementation,
   contract delta, and evidence. Record the actual reviewer with `change review`; do not
   manufacture identities or treat a local record as a required GitHub approval.
6. Run `change finalize <id>` before merge. Inspect and commit the resulting
   metadata/archive-only changes on the same delivery PR, then satisfy its current
   checks and merge through the repository's normal GitHub workflow.

Finalization closes and archives the reviewed package in the delivery PR. Do not add a
separate closing-approval ceremony or postpone archive until after merge for new changes.
Legacy accept/archive commands are for the workflow or repair path that actually requires
them; consult local migration guidance for an existing legacy change.

Edits to delivery inputs can invalidate verification or review evidence. Finish those
edits before recording evidence, and rerun the affected checks when it becomes stale.
Use `change status <id>` for the next action and handoff readiness instead of guessing
which lifecycle command will clear a blocker.

## Preserve context and generated guidance

Keep durable decisions in `context.md` or its project equivalent and requirement-to-test
evidence in `testing.md`. Update companions that exist or are required; do not create
empty files for ceremony. Preserve accepted history and use a successor change for new
behavior rather than rewriting historical evidence.

The shared catalog and generated skill can both target `.codex/skills/spec-sync` (and
other host equivalents). Prefer the generated local skill; never overwrite it with this
catalog entry. Use `spec-sync-routing` beside it for shared routing guidance. Refresh
with the selected binary's documented generator, commonly `specsync agents install`,
and inspect the diff. Project layout markers are not binary version pins; let supported
migration commands manage them.
