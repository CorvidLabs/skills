---
name: fledge-workflows
description: Discover and run repository-defined Fledge workflows without guessing commands.
---

# Fledge Workflows

Use Fledge first when working in a CorvidLabs repository. Treat the repository's own
tasks, lanes, plugins, and instructions as the source of truth. Fledge is the core CLI
(not a product plugin). Extra tools come from `fledge plugins install …` when a repository
needs them.

## Discover before running

Start from the repository root. Prefer machine-readable discovery when acting as an agent:

```sh
fledge --help
fledge introspect --json
fledge plugins list
fledge run --list --json
fledge lanes list --json
fledge work status --json
```

Use the documented task or lane that matches the change:

```sh
fledge run <task>
fledge lanes run <lane>
fledge lanes validate . --strict
```

If no appropriate Fledge task exists, report that fact and use the repository's documented
fallback; do not invent a new universal command. Prefer common lane names when present
(`pre-commit`, `check`, `verify`, `ci`) after listing—do not invent a `trust` lane name.

For agent runs, set non-interactive mode (`--non-interactive` / `--ni` or
`FLEDGE_NON_INTERACTIVE=1`) so prompts fail closed instead of hanging.

## Work deliberately

`fledge work start` takes a **name** argument that Fledge sanitizes and formats (default
shape is often `{author}/{type}/{name}` from config—pass a short slug such as `my-change`,
not a prebuilt `feat/my-change` path, unless you override with `--prefix`):

```sh
fledge work start my-change -t feat
fledge work status --json
# Stage and commit non-interactively (needs -m or --ai; use --all if nothing staged)
fledge work commit -m "feat: describe the change" --all
fledge work push
```

`work start` fails on a dirty tree—commit or stash first. `work push` refuses the default
branch (`main`/`master`). Before a commit or push, run the smallest relevant
repository-defined verification lane. Before a release, run the repository-defined
**verify / release-style** lane from the **committed** tree (discover via
`fledge lanes list --json`). Version bumps use `fledge release <bump>` when the repo uses
it—that is separate from `fledge lanes run`.

## Keep evidence honest

Record which committed revision was checked. A local result on an earlier tree does not
prove a later commit. Treat hosted CI as the final confirmation when the repository
requires it, and distinguish still-running checks from stale results on an old head.

For multi-agent session work, use `agent-coordination`. For CI/tag readiness language, use
`ci-release-hygiene`.
