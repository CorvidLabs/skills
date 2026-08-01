---
name: let
description: Discover authoritative CorvidLabs agent, session, worktree, instruction, and skill context with fledge let.
---

# Let Discovery

Use `fledge let` before selecting a worktree, resuming an agent, reporting status, or
installing a skill. Let is a locator and read-only context source; it does not expose an
agent's private live reasoning and it does not deliver prompts.

## Start with the local facts

Run the health check and resolve the target from a concrete path or repository:

```sh
fledge let doctor --json
fledge let where <path> --json
fledge let context --pack brief --cwd <worktree> --json
```

Confirm the repository root, current worktree, branch, sibling worktrees, and applicable
instructions. Do not infer ownership from a branch name or a stale session title.

## Find the right asset

Use structured output when another agent or tool will consume the result:

```sh
fledge let find sessions --scope project --repo <repo> --json
fledge let find worktrees --scope project --repo <repo> --json
fledge let find instructions --scope project --cwd <worktree> --json
fledge let history --scope project --cwd <worktree> --json
fledge let skill route "<task>" --json
```

Use `show` to inspect a specific returned identifier. Prefer a brief context pack unless a
task genuinely needs all instructions; excessive context is a coordination failure.

## Freshness and limits

- Treat session records as activity hints, not proof of completed work.
- Compare session timestamps with the worktree, commits, pull request, CI, and sandbox.
- A missing session does not prove no work exists; discovery only indexes configured hosts.
- Let can locate a session and its context, but cannot read live model reasoning, bypass a
  provider connection, or send a message.

When intervention is needed, pass the confirmed session and worktree to the Rune skill.
