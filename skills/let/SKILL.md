---
name: let
description: Discover authoritative CorvidLabs agent, session, worktree, instruction, and skill context with fledge let.
---

# Let Discovery

Let is a locator and read-only context source; it does not expose an agent's private live
reasoning and it does not deliver prompts. Use it only when the task permits discovery of
local agent metadata.

## Public-only boundary

Read-only does not mean public-safe. Let 0.2 discovery is federated: even a `--scope project`
query can enumerate user-global instructions or sibling-worktree paths. `doctor`, `where`,
`context`, `find`, `history`, and skill routing can therefore touch local metadata outside the
public repository.

Do not invoke Let in a public-only workflow unless the installed version has been independently
verified to isolate the requested repository. Never rely on filtering or redaction after a broad
query, because the private metadata has already been read. Use repository-local Git and Fledge
facts instead, and report the Let discovery step as blocked by its current isolation boundary.

## Start with the local facts

For public-only work, stay within the confirmed repository:

```sh
fledge work status
fledge run --list
git status --short --branch
git ls-files
```

Read only tracked repository instructions and declared workflows. Do not inspect sibling
worktrees, user-level agent directories, sessions, or global instruction roots. Do not infer
ownership from a branch name or a stale session title.

## Find the right asset

When local metadata discovery is explicitly in scope, inspect the installed command surface
before selecting the narrowest query:

```sh
fledge let --help
```

Prefer an exact identifier over a broad context pack. Treat returned paths and session metadata
as private unless their public provenance is independently established.

## Freshness and limits

- Treat session records as activity hints, not proof of completed work.
- Compare session timestamps with the worktree, commits, pull request, CI, and sandbox.
- A missing session does not prove no work exists; discovery only indexes configured hosts.
- Let can locate a session and its context, but cannot read live model reasoning, bypass a
  provider connection, or send a message.

When intervention is needed, pass the confirmed session and worktree to the Rune skill.
