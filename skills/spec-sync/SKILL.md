---
name: spec-sync
description: Keep project specs and code synchronized with Spec Sync while using one clear change workflow.
---

# Spec Sync

Use this baseline whenever code, tests, public documentation, schemas, or configuration
change in a repository that uses Spec Sync.

## One change, one PR

Create one change package for each mergeable pull request. Keep its plan, requirements,
context, testing notes, semantic deltas, implementation, and tests together on the
branch. Use the repository's generated Spec Sync skill and configuration for the exact
commands and file requirements.

## Core flow

1. Read the affected canonical spec and available companion files.
2. Create and define the change; obtain the required human scope approval once.
3. Implement code, canonical spec updates, and tests together.
4. Run the repository's bidirectional checks and ordinary review.
5. Finalize and archive the completed package in the same pull request before merge.

Do not create a second archive-only pull request for ordinary work. A renewed approval is
only needed when the stable user-facing scope, affected area, or semantic requirement
changes—not when implementation evidence, tests, review output, or archival metadata changes.

## Context and learning

Use `context.md` or the project equivalent for relevant decisions and prior lessons;
record regression coverage in `testing.md`. Keep archives immutable. Later work that
changes a prior capability normally creates a successor change rather than rewriting the
old accepted record.

## Project-specific generation

When a repository provides a Spec Sync skill generator, generate or refresh its local
skill after installing this shared baseline. The generated skill is authoritative for
that repository's command syntax, policy, and module layout.
