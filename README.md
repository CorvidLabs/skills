# CorvidLabs Skills

Versioned, shared skills for CorvidLabs agents. This repository holds cross-project
operating knowledge; each product repository keeps its own architecture and generated
Spec Sync material.

## Initial skills

- `agent-coordination` — use `fledge let` to discover the correct context, then use
  `fledge rune` only to observe or send a scoped message to that confirmed agent session.
- `spec-sync` — the shared baseline for bidirectional Spec Sync work. A project may
  generate a richer local version from its own configuration.
- `corvid-swift-package` — the shared operating baseline for CorvidLabs Swift packages:
  Fledge-first discovery, Swift 6 concurrency, cross-platform support, and release hygiene.

## Install with Fledge

Bootstrap the private Skills plugin once, preferably at a released tag:

```sh
fledge plugins install CorvidLabs/skills@v0.1.0
```

Then install a selected skill into the current Git repository:

```sh
fledge skills list
fledge skills install agent-coordination --host codex
fledge skills status
```

`--host auto` is supported only when exactly one of the supported repository-local
host directories already exists. Use `--host` when setting up a new project or
when more than one host is present. Installs copy by default; `--link` is for
local skill development only.

The initial plugin deliberately supports `list`, `install`, and `status` only.
Safe managed `update` and `uninstall` will follow after their ownership and
local-modification rules are tested.

## Direct installer

Install a named skill into a repository-local agent directory:

```sh
bin/corvid-skills install agent-coordination --repo /path/to/project --host codex
bin/corvid-skills install spec-sync --repo /path/to/project --host claude
```

Supported hosts are `codex`, `claude`, and `cursor`. Installations copy the selected
skill and record its source revision, destination, install mode, and content digest
in `.corvid-skills.json`. Existing skill directories are never overwritten.

```sh
bin/corvid-skills list
bin/corvid-skills install agent-coordination --repo . --host codex --link
```

## Design rules

- Shared skills teach reusable operating practices.
- Repo-local skills are authoritative for that repo's commands, architecture, and policy.
- A generated Spec Sync skill supplements this baseline; it does not overwrite it silently.
- Installer changes are explicit and repository-local by default.
