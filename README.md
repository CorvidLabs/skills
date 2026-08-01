# CorvidLabs Skills

Versioned, shared skills for CorvidLabs agents. This repository holds cross-project
operating knowledge; each product repository keeps its own architecture and generated
Spec Sync material.

## Initial skills

- `agent-coordination` — use `fledge let` to discover the correct context, then use
  `fledge rune` only to observe or send a scoped message to that confirmed agent session.
- `let` — locate the authoritative repository context, worktrees, sessions, instructions,
  skills, and recent activity before acting.
- `rune` — safely observe or drive a confirmed CLI-agent session through a bounded PTY.
- `augur` — inspect deterministic Git change risk and enforce explicit review or block gates.
- `attest` — verify or record provenance evidence for exact reviewed commits.
- `atlas` — map specifications to code ownership, drift, review queues, and coverage gaps.
- `three-md` — author and validate general layered `.3md` documents.
- `agent-3md` — validate, route, preview, and explicitly execute `agent.3md` tool templates.
- `spec-sync` — the shared baseline for bidirectional Spec Sync work. A project may
  generate a richer local version from its own configuration.
- `corvid-swift-package` — the shared operating baseline for CorvidLabs Swift packages:
  Fledge-first discovery, Swift 6 concurrency, cross-platform support, and release hygiene.
- `corvid-web-bun` — build and validate CorvidLabs Bun web projects while deferring
  framework, architecture, and release policy to the repository-local guides.
- `fledge-workflows` — discover and use repository-defined Fledge tasks and lanes.
- `spec-sync-routing` — route shared guidance to the repo-generated Spec Sync truth.
- `ci-release-hygiene` — keep CI and release evidence tied to the current commit.
- `public-release-audit` — audit a private repository before an explicit public-release decision.

## Install with Fledge

Bootstrap the Skills plugin once:

```sh
fledge plugins install CorvidLabs/skills
```

Pin the source to a released tag when a catalog release is available.

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

`status` reports each managed install as `current`, `modified`, or `missing` by comparing
the recorded digest with safe repository-local placement. A generated Spec Sync skill owns
`.codex/skills/spec-sync`; do not install the shared skill over it. Install
`spec-sync-routing` beside generated guidance when shared routing is useful.

The initial plugin deliberately supports `list`, `install`, and `status` only.
Safe managed `update` and `uninstall` will follow after their ownership and
local-modification rules are tested.

## Verify the catalog

Use the repository-defined Fledge lanes:

```sh
fledge run --list
fledge lanes validate . --strict
fledge lanes run verify
fledge lanes run audit
```

The verification lane requires Bash, Python 3, and ShellCheck. The audit lane also
requires Gitleaks and redacts any finding output.

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
- A generated Spec Sync skill is authoritative and must not be overwritten by the shared baseline.
- Installer changes are explicit and repository-local by default.
