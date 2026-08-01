---
name: agent-coordination
description: Safely discover, observe, and coordinate CorvidLabs CLI agents with fledge let and fledge rune.
---

# Agent Coordination

Use this skill before asking an agent for status, intervening in its work, or choosing a
worktree for an agent task.

## Discover first

Use `fledge let` to establish the facts before acting:

```sh
fledge let where <path> --json
fledge let context --pack brief --cwd <worktree> --json
fledge let history --scope project --cwd <worktree> --json
```

Confirm the repository, worktree, branch, applicable instructions, and latest agent
session. Do not infer ownership from a branch name alone.

## Observe by default

Use `fledge rune watch` to open a confirmed CLI-agent session in a PTY. Observe current
work before sending anything. Use a short timeout when only inspecting a session.

```sh
fledge rune watch --timeout=60 -- <agent-cli> --resume <session-id>
```

## Intervene narrowly

Only message an agent after confirming its session and active task. Send one scoped,
non-conflicting instruction. Do not interrupt tests, commits, pushes, or an independent
review merely to ask for a status update; inspect the worktree, PR, and CI instead.

## Source of truth

Session metadata describes activity. The worktree, commit history, pull request, CI,
and sandbox results determine whether work is complete.
