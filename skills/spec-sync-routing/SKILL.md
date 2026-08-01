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

## Route the change

Use one change for one mergeable PR unless the repository's local policy requires an
atomic multi-PR change. Scope approval covers the stable promise, affected areas, and
semantic requirements. Evidence, test attempts, review output, rebases, and archive
metadata normally do not require renewed approval; an actual scope expansion does.

Keep code, tests, and canonical spec updates aligned. Use the local workflow to verify
both code-to-spec and spec-to-code consistency, then finalize/archive according to the
project's configured lifecycle.
