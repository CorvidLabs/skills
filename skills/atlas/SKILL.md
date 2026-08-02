---
name: atlas
description: Inspect spec ownership, drift, coverage, review queues, and gaps with fledge atlas.
---

# Atlas

Atlas maps code to specifications. A spec-less result is valid evidence, not a command failure.

```sh
fledge plugins install CorvidLabs/fledge-plugin-atlas
fledge atlas --help
```

## Inspect first (agent-friendly JSON)

```sh
fledge atlas . --json
fledge atlas . --review
fledge atlas . --owns <path>
fledge atlas . --since <revision>
fledge atlas . --spec <spec-name>
fledge atlas . --gaps
```

Agent modes (`--review`, `--owns`, `--since`, `--spec`, `--gaps`) already print JSON; an
extra `--json` is unnecessary for those modes.

`--gaps` prints a coverage-gap worklist. It is a **boolean**—it does not take an LCOV path.
The optional path argument is the **project root**. LCOV is auto-discovered, first match
wins among: `lcov.info`, `coverage/lcov.info`, `coverage/lcov-report/lcov.info`,
`target/llvm-cov/lcov.info`, `target/coverage/lcov.info`, `target/tarpaulin/lcov.info`.
Without a report, the result is `{ "note": "no lcov coverage found", "gaps": [] }` (not a
failure). Record the repository revision with findings.

Other helpers: `--svg <COMPONENT>` for a single SVG on stdout. Current product supports
`coverage`, `langmix`, `treemap`, `sunburst`, and `calendar`—confirm the installed list
with `fledge atlas --help` (older builds may advertise only the first three).

## Generate deliberately

Default HTML, `--3md`, and `--timeline` write files under the **current working directory**
(for example `<project>.atlas.html`), not necessarily inside the analyzed project root.
`-o <path>` sets an explicit HTML destination. `--scaffold` prints a draft `*.spec.md`
skeleton to standard output. Preview before writing, choose an explicit destination, and
inspect the result. When Atlas creates Spec Sync material, follow the repository-generated
Spec Sync skill for validation and lifecycle policy. Validate Atlas-generated `.3md` with
the `three-md` skill before treating it as project truth.
