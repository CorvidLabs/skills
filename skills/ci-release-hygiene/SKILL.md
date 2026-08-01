---
name: ci-release-hygiene
description: Keep CI, pre-push verification, and release evidence tied to the current committed revision.
---

# CI and Release Hygiene

Use this skill when diagnosing CI, preparing a push, or deciding whether a release is
ready.

## Identify the revision

First confirm the PR head and the revision that each CI run tested. A red run on an old
commit is stale evidence, not a failure of the current local repair; a green run on an
old commit is not approval for later changes. Say which case applies before acting.

## Before push

Run the repository's relevant Fledge verification lane from the current committed tree.
Do not assume one command fits every project. Keep the lane focused while iterating, and
run the project-required full or release lane before declaring a PR ready.

## Before tag or release

Require evidence for the exact release candidate: committed-tree verification, required
hosted CI, version/release validation, and any configured trust or attestation checks.
Do not tag from uncommitted work or rely on verification evidence produced before the
final release-candidate commit.

## Communicate state clearly

Separate: local checks passed, CI running, CI failed on current head, and CI stale on a
previous head. Give one concrete next action rather than treating every CI transition as
a blocker.
