---
name: rune
description: Safely observe and control a confirmed CorvidLabs CLI-agent session through fledge rune PTYs.
---

# Rune Session Control

Use `fledge rune` only after the target repository, worktree, session, and active task are
confirmed. Rune gives a CLI process a PTY; it does not make a provider reachable, override
an agent's permissions, or turn a stale session record into a live connection.

## Observe first

Use a bounded non-interactive run for short status checks, and watch for a live session that
needs inspection:

```sh
fledge rune run --timeout=30 -- <agent-cli> --resume <session-id>
fledge rune watch --log=<event-log.ndjson> -- <agent-cli> --resume <session-id>
```

Keep `run` timeouts short when only inspecting output. Preserve the `watch` event log when it
is useful evidence for a handoff, but do not mistake terminal text for committed or CI-verified
work.

## Send one scoped instruction

Only send a prompt after observing the session and confirming that it is not in a critical
operation. State the one outcome, affected worktree, and verification expected. Avoid status
pings during tests, commits, pushes, migrations, or independent review; inspect Git and CI
instead.

Never send competing prompts to the same session. If another operator or agent is already
driving it, observe or coordinate first. Resume one confirmed session rather than starting a
second agent in the same worktree.

## Failure handling

- If the CLI asks for an action confirmation, do not assume edits happened; verify the
  worktree before continuing.
- If the provider or network is unavailable, stop retrying. Rune cannot bypass that boundary.
- If output is truncated, rerun a narrower command or increase `--max-output` deliberately.
- If a session is no longer valid, return to Let discovery and select the current owner.
