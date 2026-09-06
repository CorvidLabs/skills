---
name: ci-release-hygiene
description: Keep CI, pre-push verification, and release evidence tied to the current committed revision.
---

# CI and Release Hygiene

Use this skill when diagnosing CI, preparing a push, or deciding whether a release is
ready.

## Identify the revision

First confirm the PR head and the revision that each CI run tested:

```sh
git rev-parse HEAD
git status --short --branch
fledge work status
```

A red run on an old commit is stale evidence, not a failure of the current local repair; a
green run on an old commit is not approval for later changes. Say which case applies before
acting.

## Before push

Run the repository's relevant Fledge verification lane from the **current committed tree**
(commit first when the lane must match what CI will see). Discover the lane—do not assume
one command fits every project:

```sh
fledge run --list
fledge lanes list
fledge lanes run <verify-or-equivalent>
```

Keep the lane focused while iterating, and run the project-required full or release lane
before declaring a PR ready. When configured, deterministic risk gates (`augur`) and
provenance checks (`attest`) belong on the revision/range selected by repository policy.
When Trust composes these layers, use the `trust` skill and its configured gate; report
whether provenance covers the proposed commits or the baseline.

## Before tag or release

Require evidence for the exact release candidate:

- verification on the committed tree at the candidate SHA
- required hosted CI green on that SHA
- version / changelog / release validation the repo declares
- any configured trust or attestation checks on that SHA

Do not tag from uncommitted work or rely on verification evidence produced before the
final release-candidate commit. Prefer the repository's `fledge release` flow and its verify/release-style lanes (discover
via `fledge lanes list`) when present—lane names are repository-defined, not universal.
After a release bump creates a new commit, re-verify **that** SHA—not the pre-bump tree.

Prefer the maintainer-designated release candidate when that is the supported toolchain.
Resolve exact releases when updating binary and Action pins; an RC suffix alone is not a
reason to retain an older stable workflow. Verify compatibility and required checks on
the actual candidate.

## Communicate state clearly

Separate: local checks passed, CI running, CI failed on current head, and CI stale on a
previous head. Give one concrete next action rather than treating every CI transition as
a blocker. For private→public readiness, use `public-release-audit`.
