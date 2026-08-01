---
name: atlas
description: Inspect spec ownership, drift, coverage, review queues, and gaps with fledge atlas.
---

# Atlas

Atlas maps code to specifications. A spec-less result is valid evidence, not a command failure.

## Inspect first

```sh
fledge plugins install CorvidLabs/fledge-plugin-atlas
fledge atlas --help
fledge atlas . --json
fledge atlas . --review --json
fledge atlas . --owns <path> --json
fledge atlas . --since <revision> --json
fledge atlas . --spec <spec-name> --json
```

Use `--gaps <lcov-file>` only with an existing LCOV report. Record the repository revision
and input report with findings.

## Generate deliberately

Default output, `--3md`, `--timeline`, and `-o <path>` can write files. `--scaffold` prints a
draft to standard output. Preview before writing, choose an explicit destination, and inspect
the result. When Atlas creates Spec Sync material, follow the repository-generated Spec Sync
skill for validation and lifecycle policy.
