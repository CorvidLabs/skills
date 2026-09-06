---
name: let
description: Discover authoritative CorvidLabs agent, session, worktree, instruction, and skill context with fledge let.
---

# Let Discovery

Let is a host-neutral locator and workbed for agent assets. **Discovery commands**
(`doctor`, `where`, `find`, `show`, `open`, `context`, `history`, skill routing) are
read-oriented. **Workbed commands** (`init`, `worktree add|remove`, `memory set|delete`,
`super init-example`) can write under project or user `.let` paths—do not use them unless
the task authorizes local writes.

Let does not send prompts to an agent or expose live model reasoning.

## Install

Let is a Fledge plugin. Prefer the Fledge entrypoint (the shell builtin `let` is unrelated):

```sh
fledge plugins install CorvidLabs/let
fledge let --help
```

## Two modes

### Public-only (default when publishing or working from public evidence)

Do **not** invoke Let. Discovery can surface local host metadata outside the public
repository (`doctor` lists host homes; project-scope finds still pull user catalogs for
some kinds by default). Never rely on filtering or redaction after a broad query.

Stay inside the confirmed repository:

```sh
fledge work status
fledge run --list
git status --short --branch
git ls-files
```

Report the Let step as **blocked** by the current isolation boundary and continue with
repository-local Git and Fledge facts.

### Authorized local metadata

Use Let only when the task explicitly permits discovery of local agent metadata. Inspect
help, then choose the **narrowest** query. Prefer exact identifiers over a full context pack.

```sh
fledge let doctor --json
fledge let where .
fledge let find worktrees --scope project --json
fledge let find sessions --scope project --json
fledge let find skills --query <text> --json
fledge let find agents --json
fledge let skill route "<request>" --json
fledge let show skill <id-or-name> --json
fledge let open <path> --json
fledge let context --pack brief --json
fledge let history --scope project --json
```

Kinds include: `instructions`, `skills`, `agents`, `commands`, `worktrees`, `sessions`,
`tasks`, `memory`, `mcp`, `plugins`, `workflows`, `superskills`.

Scopes: `project` | `user` | `all`. Start with `project` when authorized; widen only with
cause. **`history` defaults to `user` if `--scope` is omitted**—always pass
`--scope project` for repo-bounded history.

### Project-scope privacy boundary

Check the installed tool's scope semantics and configuration before discovery.
`--scope project` alone is not proof of isolation; federated discovery can behave as follows:

| Safer under project scope | Still can pull user-global / sibling context |
| --- | --- |
| `sessions`, `memory`, `tasks` (repo-bound by design) | `skills`, `agents`, `commands`, `workflows` (user catalogs included by default via `find.include_user_skills`) |
| | `instructions` may include user-level CLAUDE.md / AGENTS.md |
| | `worktrees` / `where` can list sibling worktrees for the same repo |

Treat every returned path and session identifier as private unless public provenance is
independently established. `context` does not include sessions—call `find sessions`
explicitly when needed. Session and memory cards are path-oriented, not full transcripts.

Optional local dashboard (still local metadata; not for public-only work):

```sh
fledge let web
```

## Freshness and limits

- Session records are activity hints, not proof of completed work.
- Compare session timestamps with the worktree, commits, pull request, CI, and sandbox.
- A missing session does not prove no work exists; discovery only indexes configured hosts.
- Let cannot bypass a provider connection or message an agent.

When intervention is needed, pass the confirmed session and worktree to the `rune` skill.
For the full coordination sequence, use `agent-coordination`.
