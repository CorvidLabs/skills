---
name: rune
description: Safely observe and control a confirmed CorvidLabs CLI-agent session through fledge rune PTYs.
---

# Rune Session Control

Use `fledge rune` only after the target repository, worktree, session, and active task are
confirmed. Rune wraps a CLI in a PTY; it does not make a provider reachable, override an
agent's permissions, or turn a stale session record into a live connection.

## Install

Rune is a Fledge plugin. Use the owner/repo form:

```sh
fledge plugins install CorvidLabs/rune
fledge rune --help
fledge rune run --help
fledge rune watch --help
```

Standalone Homebrew is also available (`corvidlabs/tap/rune`). Document the
supported command surface by checking the installed plugin's `--help`; command and
session capabilities can advance independently of this shared skill.

## Commands

| Command | Role |
| --- | --- |
| `run` | Non-interactive PTY: run a command, capture output, exit |
| `watch` | Interactive passthrough: live TTY + NDJSON event log |
| `session` | Start, read, send input to, attach to, or stop persistent named PTYs |
| `version` | Show rune version / environment |

Operators can type into `watch`. For persistent sessions, inspect
`fledge rune session --help`, then read the confirmed session before sending input:

```sh
fledge rune session read --name=<confirmed-name> --screen --tail=80
```

Use `session send` only after confirming its installed syntax and authorization to
intervene. Prefer reading an existing session over launching a resume probe that might
create a competing process. Keep discovery within the authorized project scope.

```sh
# Bounded status / resume probe (default timeout 30s)
fledge rune run --timeout=30 --json -- <agent-cli> --resume <session-id>

# Live observe (optional explicit log path; runs until the child exits)
fledge rune watch --log=<event-log.ndjson> -- <agent-cli> --resume <session-id>
```

Put **rune** flags before `--`. Without `--`, wrapped flags (for example tool `--json`)
can be stolen by rune.

Useful flags (before `--`):

- `run`: `--timeout=SECONDS` (default 30). On timeout, exit code is **124**.
- `watch`: `--log=PATH` (omit to use a temp file announced as `log_path`)
- Global: `--json`, `--ndjson`

JSON `run` results include both `clean_output` (ANSI-stripped) and `raw_output`.
Do not transfer flags between commands: for example, `session read` supports output
bounds such as `--max-output`, but `run` has its own flag set. `watch` requires a real
stdin TTY and cannot be nested under `run`.

Keep `run` timeouts short when only inspecting. Preserve the `watch` event log when it is
useful handoff evidence. Terminal text is not committed or CI-verified work.

## Intervene narrowly

Only send input after observing the session and confirming it is not in a critical
operation. State one outcome, the affected worktree, and the verification expected. Avoid
status pings during tests, commits, pushes, migrations, or independent review—inspect Git
and CI instead.

Never send competing prompts to the same session. If another operator or agent is already
driving it, observe or coordinate first. Resume one confirmed session rather than starting
a second agent in the same worktree.

## Failure handling

- If the CLI asks for confirmation, do not assume edits happened; verify the worktree.
- If the provider or network is unavailable, stop retrying. Rune cannot bypass that boundary.
- If output is huge or hard to parse, narrow the wrapped command or use `watch` with an
  explicit log, or use supported `session read` output bounds.
- If a session is no longer valid, return to authorized Let discovery (or public repo facts)
  and select the current owner.

For the full discovery → observe → execute → verify sequence, use `agent-coordination`.
