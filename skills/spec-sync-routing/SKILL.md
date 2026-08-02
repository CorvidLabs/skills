---
name: spec-sync-routing
description: Route shared Spec Sync guidance to each repository's generated local Spec Sync skill and configuration.
---

# Spec Sync Routing

This is routing guidance, not a replacement for a project's Spec Sync contract.

## Install

**This catalog skill** (safe to install beside a generated Spec Sync skill):

```sh
fledge plugins install CorvidLabs/skills
fledge skills install spec-sync-routing --host <codex|claude|cursor|gemini|grok|openai>
```

**Product CLI** — Spec Sync is not a Fledge plugin. Install `specsync` via Homebrew or cargo
(see the `spec-sync` skill). Refresh generated host skills with `specsync agents install`.

## Find local truth first

When a repository uses Spec Sync, locate its generated local skill, configuration, and
canonical specs before choosing commands or editing lifecycle files:

1. Confirm the CLI: `specsync --version` (binary name is **`specsync`**, not `spec-sync`).
2. Find project config (often `.specsync/config.toml`; also `.specsync/config.json` or
   `.specsync.toml` in some repos) and `specs/`.
3. Find the generated host skill after `specsync agents install` (exact host paths come
   from that command), for example:
   - `.codex/skills/spec-sync`
   - `.claude/skills/spec-sync`
   - `.cursor/skills/spec-sync`
   - `.gemini/skills/spec-sync`
4. Use the shared catalog `spec-sync` skill for **principles only** (including
   accept → merge → archive-after-merge).

The local generated skill and configuration are authoritative for that repository's
command syntax, paths, policy, and validation.

If the repository can generate or refresh its local Spec Sync skill, do that after
installing this non-colliding routing entry. Do not install the shared `spec-sync` catalog
entry over a generated local skill path. Do not overwrite or silently replace generated
local material with shared text.

## Route workflow questions

For change lifecycle, approval boundaries, evidence, finalization, and archive behavior,
read the shared `spec-sync` skill first and then follow the generated repository-local
skill and configuration. They define the workflow; this skill only tells you where to
find it.

For code↔spec graph inspection, see `atlas`. For deterministic change risk, see `augur`.
