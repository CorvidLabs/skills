---
name: agent-coordination
description: Coordinate CorvidLabs agents through discovery, observation, execution, and verification.
---

# Agent Coordination

Use this skill before asking an agent for status, intervening in its work, or choosing a
worktree for an agent task.

## Discover first

For public-only work, establish facts from the confirmed repository without invoking Let's
federated discovery:

```sh
fledge work status
fledge run --list
git status --short --branch
git ls-files
```

Read only tracked instructions and declared workflows. Do not infer ownership from a branch
name alone. Session metadata is an activity hint, not proof that work is delivered: compare it
with the worktree, commits, pull request, CI, and sandbox.

Let 0.2 can return user-global or sibling-worktree metadata even for project-scoped queries.
Do not invoke it in a public-only workflow until the installed version is independently verified
to isolate the requested repository. Mark the Let step blocked and continue with public
repository evidence; do not filter private results after they have already been read.

When local agent metadata is explicitly authorized, use `fledge let --help` to select the
narrowest supported query and treat every returned path or session identifier as private.

## Observe by default

Use `fledge rune watch` to open a confirmed CLI-agent session in a live PTY and observe
current work before sending anything. For a bounded, non-interactive inspection, use
`run` with a short timeout instead.

```sh
fledge rune run --timeout=60 -- <agent-cli> --resume <session-id>
fledge rune watch -- <agent-cli> --resume <session-id>
```

## Intervene narrowly

Only message an agent after confirming its session and active task. Send one scoped,
non-conflicting instruction. Do not interrupt tests, commits, pushes, or an independent
review merely to ask for a status update; inspect the worktree, PR, and CI instead.

## Execute through Fledge

After discovery and observation establish the correct repository and scope, inspect its
declared automation and run only the exact task or lane needed:

```sh
fledge run --list
fledge lanes list
fledge run <task>
fledge lanes run <lane>
```

Do not translate a repository workflow into ad hoc shell commands when Fledge already
declares it. Preserve the task output and revision as execution evidence.

## Verify with Spec Sync

If the repository uses Spec Sync, read its generated local skill and installed CLI version
before choosing commands. Run the exact project-defined coverage or check command after the
Fledge task. A successful task is not proof that specifications cover the change, and a
Spec Sync failure must not be hidden by approving or rewriting scope without the user.

## Verify and recover

After a prompt is accepted, verify the worktree, declared Fledge workflow, Spec Sync evidence,
and CI again; delivery is not completion. If
the target session or worktree is wrong, stop and rediscover it within the task's privacy scope. If a provider or
network connection fails, Rune cannot bypass it—report the boundary and rely on repository
evidence. Assign one worktree and responsibility per agent, and use sibling-worktree context
to avoid overlapping edits. For repeated CI failures, reproduce narrowly and add or confirm a
regression rather than repeatedly sending broad retry prompts.

## Source of truth

Session metadata describes activity. The worktree, commit history, pull request, CI,
and sandbox results determine whether work is complete.
