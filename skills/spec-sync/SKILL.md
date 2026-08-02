---
name: spec-sync
description: Keep project specs and code synchronized with Spec Sync while using one clear change workflow.
---

# Spec Sync

Use this baseline whenever code, tests, public documentation, schemas, or configuration
change in a repository that uses Spec Sync. The CLI binary is **`specsync`** (not
`spec-sync`). Exact verbs and paths come from the **installed** binary and the
**repository-generated** local skill—not from this shared catalog entry.

## Install

Spec Sync is **not** a Fledge plugin. Install the **`specsync`** binary separately:

```sh
brew install CorvidLabs/tap/spec-sync
# or: cargo install specsync
specsync --version
specsync --help
```

Prefer the repository-generated Spec Sync skill when present; this catalog entry is
shared principles only (see collision notes below). Use `spec-sync-routing` to locate
local truth without overwriting generated skills.

## One change workspace per delivery

Keep plan, requirements, context, testing notes, semantic deltas, implementation, and
tests together in one change workspace through closing. Use the repository's generated
Spec Sync skill and configuration for the exact commands and file requirements.

## Core flow

1. Read the affected canonical spec and available companion files.
2. Create and define the change; obtain **definition approval**
   (commonly `specsync change approve`)—a human, digest-bound gate. Do not self-grant.
3. Implement code, canonical spec updates, and tests together after approval.
4. Run the repository's bidirectional checks and ordinary review
   (commonly `specsync check --strict` when that is what the local skill requires).
5. Obtain **closing approval** and **accept** on the delivery branch
   (commonly `specsync change accept`)—a second human gate, not covered by definition
   approval.
6. **Merge** the delivery branch.
7. **`change archive` after merge** (separately). Do not archive while the active change
   still covers unmerged delivery paths; archiving before merge can fail and is not the
   product flow.

Renew definition approval when the stable user-facing scope, affected area, or semantic
requirement changes—not when implementation evidence, tests, review output, or archival
metadata changes. Closing approval is always its own gate.

## Context and learning

Use `context.md` or the project equivalent for relevant decisions and prior lessons;
record regression coverage in `testing.md`. Keep archives immutable. Later work that
changes a prior capability normally creates a successor change rather than rewriting the
old accepted record.

## Project-specific generation

The catalog entry and a repository-generated skill both use host paths such as
`.codex/skills/spec-sync` (also `.claude`, `.cursor`, `.gemini` when installed). Do not
install this shared entry over an existing generated skill, and do not install it first
when generation will immediately replace it. In an initialized repository, prefer the
generated local skill and install the non-colliding `spec-sync-routing` catalog skill when
shared routing guidance is useful.

Refresh generated agent guidance only with the installed version's documented command
(commonly `specsync agents install`), then inspect the resulting diff. Public documentation
on the default branch may describe an unreleased version; the installed binary and generated
skill are authoritative.
