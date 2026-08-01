---
name: augur
description: Assess working-tree, staged, range, or CI change risk and gates with fledge augur.
---

# Augur

Use Augur for deterministic change-risk evidence. It supplements tests and review; it does not approve a change.

## Inspect risk

```sh
fledge plugins install CorvidLabs/fledge-plugin-augur
fledge augur --help
fledge augur check -C . --json
fledge augur check -C . --staged --json
fledge augur check -C . --range <base>..<head> --json
```

`check` reports findings but exits successfully. Working-tree and staged diffs do not include
untracked files, so inventory those separately before relying on a clean report.

## Enforce a gate

```sh
fledge augur gate -C . --threshold review --json
fledge augur gate -C . --threshold block --json
```

`gate` exits nonzero when the selected threshold is met. Record the exact revision and scope with the result.
