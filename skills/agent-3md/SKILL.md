---
name: agent-3md
description: Validate, route, inspect, or run agent.3md manifests and typed tool templates.
---

# Agent 3md

An `agent.3md` is executable configuration: plane 0 is identity; other planes are skills
with triggers, typed inputs, optional `tool=` command templates, and dependency links.
Let can **locate** the file; this skill **validates, routes, and optionally runs** it.

## Install

**This catalog skill** (agent guidance):

```sh
fledge plugins install CorvidLabs/skills
fledge skills install agent-3md --host <codex|claude|cursor|gemini|grok|openai>
```

**Product tooling** — CorvidLabs/agent-3md is **not** a Fledge plugin. There is no
`fledge plugins install` / `fledge agent3md` surface.

**TypeScript library** (embed; npm latest is the library path):

```sh
npm install @corvidlabs/agent3md
# or: bun add @corvidlabs/agent3md
```

**CLI (prefer current main, not a stale crates.io-only install for `run`):**

The Rust CLI on GitHub main supports `manifest`, `skills`, `route`, `get`, `resolve`,
`validate`, and `run` (`--exec`). Published `cargo install agent3md` may lag and ship only
the inspect/validate subset without `run`/`--exec`—verify `agent3md --help` after install.

```sh
# From a clone of CorvidLabs/agent-3md (current surface)
cd /path/to/agent-3md
cargo install --path loaders/rust
# or without a global install:
bun run cli --help
```

Inside the agent-3md repo:

| Action | Command |
| --- | --- |
| Inspect / route / run | `bun run cli <cmd> …` |
| Validate | `bun run validate <file>` (not `bun run cli validate`) |
| Scaffold | `bun run cli new …` (TS-only) |

## Inspect without executing

```sh
agent3md validate agent.3md
agent3md manifest agent.3md
agent3md skills agent.3md
agent3md route agent.3md "<request>"
agent3md get agent.3md <skill-name>
agent3md resolve agent.3md <skill-name>
```

If `validate` rejects a modern manifest after `cargo install agent3md` from crates.io, use
repo-local `bun run validate` or a git/`--path` install of the current loader—published
crates.io **0.1.0** still requires `model:` in frontmatter and does not ship `run`/`--exec`.

## Preview, then execute only when authorized

Confirm `run` exists in `agent3md --help` first:

```sh
# Route + fill tool template; print the command (does not run it)
agent3md run agent.3md "<request>" key=value

# Run the rendered command
agent3md run agent.3md "<request>" key=value --exec
```

Repo-local equivalent: `bun run cli run agent.3md "<request>" key=value [--exec]`.

Inspect the matched skill, substituted values, quoting, working directory, and referenced
paths before `--exec`. `--exec` does not bypass Fledge workflows, repository policy, the
sandbox, or external-write approval. Prefer `fledge run` for repository-declared tasks.

Skills without a `tool=` attribute are playbook-only—follow them with the host's own tools.
Use the `three-md` skill for general `.3md` documents that are not agent manifests.
