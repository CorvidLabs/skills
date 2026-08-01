---
name: spec-sync-routing
description: Route shared Spec Sync guidance to each repository's generated local Spec Sync skill and configuration.
---

# Spec Sync Routing

This is routing guidance, not a replacement for a project's Spec Sync contract.

## Find local truth first

When a repository uses Spec Sync, locate its generated local skill, configuration, and
canonical specs before choosing commands or editing lifecycle files. Use the shared
`spec-sync` baseline for principles only; the local generated skill and configuration
are authoritative for that repository's command syntax, paths, policy, and validation.

If the repository can generate or refresh its local Spec Sync skill, do that after
installing this shared catalog entry. Do not overwrite or silently replace its local
material with shared text.

## Route workflow questions

For change lifecycle, approval boundaries, evidence, finalization, and archive behavior,
read the shared `spec-sync` skill first and then follow the generated repository-local
skill and configuration. They define the workflow; this skill only tells you where to
find it.
