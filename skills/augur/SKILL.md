---
name: augur
description: Assess working-tree, staged, range, or CI change risk and gates with fledge augur.
---

# Augur

Use Augur for deterministic change-risk evidence (churn, coupling, test gaps, sensitive
paths, ownership, revert history). Verdicts are `proceed`, `review`, or `block`. It
supplements tests and review; it does not approve a change. No API key or LLM required.

## Install

Use the Fledge plugin repo `CorvidLabs/fledge-plugin-augur` (not the standalone `augur`
kit alone). The public plugin targets **macOS 13+**. Confirm with `fledge augur --help`
after install.

```sh
fledge plugins install CorvidLabs/fledge-plugin-augur
fledge augur --help
fledge augur help check
fledge augur help gate
```

## Inspect risk

```sh
fledge augur check -C . --json
fledge augur check -C . --staged --json
fledge augur check -C . --range <base>..<head> --json
fledge augur check -C . --verbose --json
```

`check` reports findings but exits successfully. Default scope is the working-tree diff.
Working-tree assessment **includes** non-ignored untracked files. **Staged** and **range**
scopes do not—inventory untracked files separately before relying on a clean staged or
range report.

## Enforce a gate

```sh
fledge augur gate -C . --threshold review --json
fledge augur gate -C . --threshold block --json
fledge augur gate -C . --range <base>..<head> --threshold review --json
```

Thresholds: `proceed`, `review` (default), or `block`. `gate` exits nonzero when the
verdict meets or exceeds the selected threshold. Record the exact revision and scope with
the result.

To attach Augur output when recording provenance, see the `attest` skill (`--from-augur`).
