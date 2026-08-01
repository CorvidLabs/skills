---
name: fledge-workflows
description: Discover and run repository-defined Fledge workflows without guessing commands.
---

# Fledge Workflows

Use Fledge first when working in a CorvidLabs repository. Treat the repository's own
tasks, lanes, plugins, and instructions as the source of truth.

## Discover before running

Start from the repository root. Inspect available work rather than assuming a universal
test, build, or release command:

```sh
fledge --help
fledge plugins list
fledge run --help
fledge lanes --help
fledge let context --pack brief --cwd . --json
```

Use the documented task or lane that matches the change. If no appropriate Fledge task
exists, report that fact and use the repository's documented fallback; do not invent a
new universal command.

## Work deliberately

Use `fledge work` to create, inspect, commit, and push a focused branch. Before a
commit or push, run the smallest relevant repository-defined verification lane. Before a
release, run the repository-defined release or trust lane from the committed tree.

## Keep evidence honest

Record which committed revision was checked. A local result on an earlier tree does not
prove a later commit. Treat hosted CI as the final confirmation when the repository
requires it, and distinguish still-running checks from stale results on an old head.
