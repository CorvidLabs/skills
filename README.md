# CorvidLabs Skills

Versioned, shared skills for CorvidLabs agents. This repository holds cross-project
operating knowledge; each product repository keeps its own architecture and generated
Spec Sync material.

## Initial skills

- `agent-coordination` — use `fledge let` to discover the correct context, then use
  `fledge rune` only to observe or send a scoped message to that confirmed agent session.
- `spec-sync` — the shared baseline for bidirectional Spec Sync work. A project may
  generate a richer local version from its own configuration.

## Install

Install a named skill into a repository-local agent directory:

```sh
bin/corvid-skills install agent-coordination --repo /path/to/project --host codex
bin/corvid-skills install spec-sync --repo /path/to/project --host claude
```

Supported hosts are `codex`, `claude`, and `cursor`. Installations copy the selected
skill and record its source revision in `.corvid-skills.json`. Use `--link` for a
development symlink instead of a copy.

```sh
bin/corvid-skills list
bin/corvid-skills install agent-coordination --repo . --host codex --link
```

## Design rules

- Shared skills teach reusable operating practices.
- Repo-local skills are authoritative for that repo's commands, architecture, and policy.
- A generated Spec Sync skill supplements this baseline; it does not overwrite it silently.
- Installer changes are explicit and repository-local by default.
