---
name: rea
description: Investigate software you are authorized to analyze with REA (Reverse Engineer Anything), using its installed CLI, MCP tools and workflow skill, and report findings with their evidence and limits.
---

# REA (Reverse Engineer Anything)

REA is a third-party, MIT-licensed CLI and MCP server (`rea-agents` on npm,
`morluto/rea` on GitHub) for inspecting native binaries, JavaScript and Electron
apps, .NET assemblies, Android APKs, websites and other artifacts without their
source. This entry routes to REA's own workflow instructions and adds the
boundaries for using it in CorvidLabs work. It does not authorize installation,
setup, or analysis of a target the user has not named.

## Read the installed tool first

REA changes quickly. Its installed help and workflow skill own current syntax,
tool names, providers and output shapes; this entry does not restate them.

```sh
rea --help
rea doctor --skill --json
```

If `rea` is not installed or `rea doctor` reports a missing skill or client
registration, report that boundary. Install or run `rea setup` only when the task
authorizes it, and review a dry run first:

```sh
npm install --global rea-agents
rea setup --client <client-id> --dry-run
```

Setup registers REA for the whole client, not one repository. Use REA's
documented client IDs and its installation guide for a project-scoped
registration instead.

## Confirm scope and authorization

Before any analysis, confirm with the user and record in the task:

- the exact target (path, package, URL or device) and the question to answer;
- that the user owns the target or is otherwise permitted to analyze it, and
  that its license or terms allow it;
- whether the work is static inspection only or may run, attach to or drive the
  target (runtime capture acts with the user's permissions).

Do not analyze credentials, other people's private data, or a target outside the
confirmed scope. Treat an unknown or suspicious sample as hostile: prefer static
inspection, and run it only in an isolated environment the user designates.

## Choose the narrowest readiness check

Check only what the task needs, for example:

```sh
rea analyze-javascript-application <absolute-path> --json
rea doctor --provider <provider> --json
rea doctor --client <client-id> --json
```

Native analysis needs a provider such as Hopper, Ghidra, IDA or Kuna; static
JavaScript, .NET and many header inspections need none. Do not install a provider
without authorization.

## Keep findings local and evidenced

REA's analysis runs locally, but tool results flow to the agent's model provider.
When the target or its contents must stay on the machine, use a local model, or
confirm the provider's data policy with the user before analysis.

Report each conclusion with the evidence REA returned (addresses, files, modules,
references) and its stated limitations. Separate observed facts from inferences,
and verify an inference with a second tool or a test before relying on it. Keep
private paths, extracted secrets and target contents out of public records and
commits; store evidence where the task assigns it.

When reimplementing an observed behavior, write original code from the explained
behavior, not copied target code, and test it in the project.
