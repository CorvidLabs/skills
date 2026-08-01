---
name: agent-3md
description: Validate, route, inspect, or run agent.3md manifests and typed tool templates.
---

# Agent 3md

Let can locate an `agent.3md`; this skill validates and routes it. Treat the file as executable configuration.

## Validate and preview

```sh
cargo install agent3md
agent3md validate agent.3md
agent3md run agent.3md "<request>" key=value
```

The default `run` prints the selected command without executing it. Inspect the matched route,
substituted values, quoting, working directory, and referenced paths before taking action.

## Execute only when authorized

```sh
agent3md run agent.3md "<request>" key=value --exec
```

Use `--exec` only when the rendered command is within the user's authorization. It does not bypass Fledge workflows,
repository policy, the sandbox, or external-write approval. Prefer `fledge run` for repository-declared tasks. Use the
`three-md` skill for general documents that are not executable agent manifests.
