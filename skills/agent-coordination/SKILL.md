---
name: agent-coordination
description: Coordinate CorvidLabs agents through discovery, observation, execution, and verification.
---

# Agent Coordination

Use this skill as the hub before asking an agent for status, intervening in its work, or
choosing a worktree. Product detail lives in sibling skills: `let`, `rune`,
`fledge-workflows`, and `spec-sync` / `spec-sync-routing`.

## Sequence

1. **Discover** the repository, worktree, and (when authorized) session owner.
2. **Observe** a confirmed CLI session before sending anything.
3. **Execute** only through the repository's declared Fledge tasks and lanes.
4. **Verify** with Spec Sync (when the repo uses it), then Git, PR, and CI.

Do not skip ahead on session titles or branch names alone.

## Discover

### Public-only work

Stay inside the confirmed repository. Do not invoke Let:

```sh
fledge work status
fledge run --list
git status --short --branch
git ls-files
```

Read only tracked instructions and declared workflows. Mark Let discovery **blocked** and
continue with repository evidence. Let project-scope finds can pull user catalogs for
skills/agents (and related kinds) by default, and `where`/worktrees can list siblings; do
not filter private results after they have already been read. Details and kind matrix: `let`
skill.

### Authorized local metadata

When the task explicitly permits local agent metadata, use the `let` skill with the
narrowest supported query (prefer `find worktrees` / `find sessions` with
`--scope project`). Treat every returned path and session id as private until public
provenance is proven independently. Do not run Let workbed write commands unless writes
are authorized.

## Observe, then intervene

Confirm repository, worktree, session, and active task first. Use the `rune` skill
(and `fledge rune run|watch --help` for the installed flag set):

- `fledge rune run --timeout=30 --json -- <agent-cli> …` — bounded, non-interactive
- `fledge rune watch --log=<path> -- <agent-cli> …` — live PTY; keystrokes go here

For persistent sessions, discover `fledge rune session --help`; use its read/send
operations when supported. Send **one** scoped instruction only after
observation, and never while tests, commits, pushes, migrations, or independent review
are in progress—inspect Git and CI instead. Never drive the same session from two
operators, and never start a second agent in a worktree that already has an owner.

## Execute through Fledge

```sh
fledge run --list
fledge lanes list
fledge run <task>
fledge lanes run <lane>
```

Prefer declared tasks and lanes over ad hoc shell. Record task output with the exact
revision. Details: `fledge-workflows` skill.

## Verify

- If the repository uses Spec Sync, follow `spec-sync-routing` to the generated local
  skill; use shared `spec-sync` only for version-neutral principles.
- Current SpecSync changes finalize and archive in the delivery PR before merge. Use
  the local migration guidance for legacy changes. Details: `spec-sync` skill.
- When Trust is configured, run its composed gate and distinguish its result from
  required PR approval. Details: `trust` skill.
- A green Fledge task is not proof that specs cover the change.
- After any intervention, re-check worktree, PR, CI, and sandbox. Session text is an
  activity hint, not delivery.

## Evidence hierarchy

Highest trust first: committed tree and CI on that SHA → PR and review → Fledge/Spec Sync
results on that SHA → worktree diff → Rune/session output → Let session cards.

## Recover

- Wrong session or worktree: stop; rediscover within the task's privacy scope.
- Provider or network failure: Rune cannot bypass it; report the boundary.
- Repeated CI failure: reproduce narrowly and add or confirm a regression—do not spam
  retry prompts into a live session.
- One worktree and one responsible agent per task.
