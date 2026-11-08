---
name: rune
description: Safely observe and control a confirmed CorvidLabs CLI-agent session through fledge rune PTYs.
---

# Rune Session Control

Use `fledge rune` only after the target repository, worktree, session, and active task are
confirmed. Rune wraps a CLI in a PTY; it does not make a provider reachable, override an
agent's permissions, or turn a stale session record into a live connection.
If the project requires Herdr/HC, follow that harness instead; Rune guidance does
not authorize replacing it or starting another process for an already owned task.

## Install

Rune is a Fledge plugin. Use the owner/repo form:

```sh
fledge plugins install CorvidLabs/rune
fledge rune --help
```

Standalone Homebrew is also available (`corvidlabs/tap/rune`). Check the installed
plugin's `--help`; command and session capabilities can advance independently of this
shared skill.

## Commands

| Command | Role |
| --- | --- |
| `run` | Non-interactive PTY: run a command, capture output, exit |
| `watch` | Interactive passthrough: live TTY + NDJSON event log |
| `session` | Named PTY sessions that outlive the invocation |
| `version` | Show rune version / environment |

`session` is the model to reach for when driving another agent across more than one turn. Its
subcommands are `start`, `send`, `read`, `attach`, `list`, `stop`, `archive`. The child outlives the
`rune` process that started it: `start` returns immediately, and a detached supervisor owns the pty.

Inspect `fledge rune session --help`, then read the confirmed session before sending input.
Use `session send` only after confirming its installed syntax and authorization to
intervene. Prefer reading an existing session over launching a resume probe that might
create a competing process. Keep discovery within the authorized project scope.

```sh
fledge rune session start --name=reviewer -- <agent-cli>
fledge rune session send  --name=reviewer --settle-ms=30000 --timeout-ms=300000 "<prompt>"
fledge rune session read  --name=reviewer --screen
fledge rune session list
fledge rune session stop --name=reviewer && fledge rune session archive --name=reviewer
```

## Knowing when the other agent is done

This is the hard part and the part most likely to mislead you.

**`settled: true` means the child went quiet. It does not mean the work finished.**
The turn may have ended, the child may be waiting on a human, or background work
may still be running. Confirm the actual outcome and artifacts.

**`--settle-ms` can return your own input as the answer.** A child that redraws the line on submit —
`irb`, `python3 -q`, and agent CLIs with composers — sends your prompt a second time, and rune
can count that as the child speaking. Inspect whether the reply contains the actual
answer or only echoed input; do not treat a prior timing sample as a guarantee.

For a terminal-output completion marker, use `--wait-for-regex` when the installed
version supports it. In Rune 0.9.0's help, regex waiting **replaces** the settle
window; increasing `--settle-ms` does not add a second completion gate:

```sh
fledge rune session send --name=x \
  --wait-for-regex='DONE_[0-9]+' --timeout-ms=300000 \
  "...when finished, print DONE_ followed by the number of files changed"
```

Choose a pattern that **cannot appear in your own prompt**, and check `matched`
and process/timeout state. No match is not proof the task failed: the marker may
have been captured in a file or omitted. Inspect the retained command receipt
before retrying a mutation.

## Reading output

`--screen` renders what a terminal would be showing, rather than every frame of
every repaint. It can expose the current answer more clearly than the raw stream;
retain full logs separately when needed.

It is the *end state*, so anything scrolled away is gone, and it renders from the last 256KB.

`--grep=RE --context=N` filters the reply instead of pulling the whole transcript into your context.
It matches the **cleaned** text, not the raw stream, because repaint frames split words across
escape sequences. Note that `--context` is near-useless against a full-screen TUI: the cleaned text
has almost no line breaks, so the surrounding "lines" are the whole frame.

`--max-output=BYTES` and `--tail=N` bound `run` and `read` replies. Prefer `--tail`: it returns a
true suffix, while `--max-output` splices head and tail together.

## Flags and the `--` separator

Put **rune** flags before `--`. Everything after `--` belongs to the child.

- `run`: `--timeout=SECONDS` (default 30; timeout gives exit code **124**), `--max-output=BYTES`,
  `--tail=N`, `--separate-streams`
- `session send`: `--settle-ms`, `--timeout-ms`, `--wait-for-regex`, `--no-wait`, `--no-newline`
- `session read`: `--since`, `--tail`, `--grep`, `--context`, `--max-output`, `--screen`
- Global: `--json`, `--ndjson`

`run` results carry both `clean_output` (ANSI-stripped) and `raw_output`. The `command` field is a
shell-escaped **display** reconstruction for humans — it is not what the child received, so do not
diagnose quoting problems from it.

`watch` requires a real stdin TTY and cannot be nested under `run`.

## Traps worth knowing before you hit them

- **`start` returning `status: ok` does not mean the child is running.** A missing binary still
  gives exit 0, with `state: "exited"` and `exit_code: 127` in the body. Check `state`.
- **`exit_code` means the process ended, not that the work succeeded.** For an agent CLI it is 0
  almost always.
- **`rune run` does not forward its own stdin.** Put redirects inside the command:
  `rune run -- sh -c 'cmd < file'`.
- **One send in flight per session.** A second concurrent send is refused.
- **Archiving puts a session out of `read`'s reach.** Pull anything you still want first.
- **`prompt_detected` answers "does the last line look like a prompt"**, which is not "is it waiting
  for me" — and it is false for a permission dialog. Do not gate on it.

## Intervene narrowly

Only send input after observing the session and confirming it is not in a critical
operation. State one outcome, the affected worktree, and the verification expected. Avoid
status pings during tests, commits, pushes, migrations, or independent review — inspect Git
and CI instead.

Never send competing prompts to the same session. If another operator or agent is already
driving it, observe or coordinate first. Resume one confirmed session rather than starting
a second agent in the same worktree.

Terminal text is not committed or CI-verified work.

## Failure handling

- If the CLI asks for confirmation, do not assume edits happened; verify the worktree.
- If the provider or network is unavailable, stop retrying. Rune cannot bypass that boundary.
- If a reply looks like your own prompt, it probably is — see the settle limitation above.
- If output is huge or hard to parse, use supported output bounds or a `watch` log.
- If a session is no longer valid, return to authorized Let discovery (or public repo facts)
  and select the current owner.

For the full discovery → observe → execute → verify sequence, use `agent-coordination`.
