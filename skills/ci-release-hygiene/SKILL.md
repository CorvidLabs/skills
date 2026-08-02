---
name: ci-release-hygiene
description: Keep CI, pre-push verification, and release evidence tied to the current committed revision.
---

# CI and Release Hygiene

Use this skill when diagnosing CI, preparing a push, or deciding whether a release is
ready.

## Install

**This catalog skill** (practice guidance; not a product plugin):

```sh
fledge plugins install CorvidLabs/skills
fledge skills install ci-release-hygiene --host <codex|claude|cursor|gemini|grok|openai>
```

Uses core Fledge (`work`, `lanes`, optional `release`) and any repo-configured plugins
(e.g. augur/attest) when present.

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
provenance checks (`attest`) belong on the same SHA you intend to push.

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

## Communicate state clearly

Separate: local checks passed, CI running, CI failed on current head, and CI stale on a
previous head. Give one concrete next action rather than treating every CI transition as
a blocker. For private→public readiness, use `public-release-audit`.
