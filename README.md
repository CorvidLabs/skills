# CorvidLabs Skills

Public, versioned operating knowledge for software agents working with CorvidLabs tools.
Each skill is a portable `SKILL.md`; Fledge provides safe repository-local installation,
status, update, and uninstall commands.

Product repositories remain authoritative for their own architecture, commands, and
generated Spec Sync material.

## Quick start

Install the catalog plugin, inspect it, and add **only the skills a repository needs**
(one skill per `install`—there is no `install --all`). Prefer a focused set over dumping
the whole catalog into every project.

**Minimal core** (good default for most CorvidLabs repos):

```sh
fledge plugins install CorvidLabs/skills
fledge skills list
fledge skills install agent-coordination --host codex
fledge skills install fledge-workflows --host codex
fledge skills status
```

Add product skills (`let`, `rune`, `augur`, `atlas`, …) only when that tool is actually used
in the project. `update --all` refreshes skills that are already managed; it does not
install missing ones.

To pin a published catalog release, add its tag to the source, for example:

```sh
fledge plugins install CorvidLabs/skills@v0.2.0
```

## Catalog

### Coordination and discovery

| Skill | Purpose |
| --- | --- |
| `agent-coordination` | Coordinate scoped discovery, Rune, Fledge, and Spec Sync verification. |
| `let` | Discover local agent context when its federated metadata scope is explicitly permitted. |
| `rune` | Observe or control a confirmed CLI-agent session through a bounded PTY. |
| `fledge-workflows` | Discover and use repository-defined Fledge tasks, lanes, plugins, and work commands. |

### Product tools

| Skill | Purpose |
| --- | --- |
| `augur` | Inspect deterministic Git change risk and apply explicit review or block gates. |
| `attest` | Verify or record provenance evidence for exact reviewed commits. |
| `atlas` | Map specifications to ownership, drift, review queues, and coverage gaps. |
| `three-md` | Author and validate layered `.3md` documents. |
| `agent-3md` | Validate, route, preview, and explicitly execute `agent.3md` tool templates. |

### Project engineering

| Skill | Purpose |
| --- | --- |
| `spec-sync` | Apply the shared, version-neutral baseline for bidirectional Spec Sync work. |
| `spec-sync-routing` | Route shared guidance to authoritative repository-generated Spec Sync instructions. |
| `corvid-swift-package` | Build CorvidLabs Swift packages with Fledge-first, Swift 6, and cross-platform practices. |
| `corvid-web-bun` | Build and verify local Bun/TypeScript web tools. |
| `ci-release-hygiene` | Tie CI and release evidence to the exact current commit. |
| `public-release-audit` | Audit a repository before an explicit public-release decision. |

## Agent compatibility

The skill content is agent-neutral Markdown. Any agent that can load a `SKILL.md` from
repository context can use it. Fledge currently provides automatic, collision-safe placement
for these hosts:

| Host | Repository-local destination | Automatic placement |
| --- | --- | --- |
| Codex | `.codex/skills/<skill>` | Yes |
| Claude | `.claude/skills/<skill>` | Yes |
| Cursor | `.cursor/skills/<skill>` | Yes |
| Gemini | `.gemini/skills/<skill>` | Yes |
| Grok | `.grok/skills/<skill>` | Yes |
| OpenAI | `.agents/skills/<skill>` | Yes |
| Other agents | Agent-defined | No; use the agent's documented skill path. |

Host placement does not translate private context or product-specific assumptions into a skill.
All catalog content and examples must remain usable from public CorvidLabs sources.
Fledge lifecycle tracking applies to the six automatic placements; a custom agent path remains
managed by that agent or by the user.

## Manage installed skills

Installs copy by default. Use `--link` only while developing this catalog locally.
Every placement is recorded in `.corvid-skills.json` with its source revision, mode,
destination, and content digest.

```sh
# Inspect human-readable or machine-readable state.
fledge skills status
fledge skills status --json

# Preview, then update one skill or every managed skill.
fledge skills update augur --dry-run
fledge skills update --all --dry-run
fledge skills update --all

# Preview, then remove one manifest-owned skill.
fledge skills uninstall augur --dry-run
fledge skills uninstall augur
```

`status` reports `current`, `legacy`, `modified`, or `missing`. A `legacy` OpenAI entry was
installed in the retired `.openai/skills` location; uninstall then reinstall it to move it to
`.agents/skills`. Update and uninstall refuse modified or missing copies, so local work is never
overwritten or removed. For a manifest-owned link,
Fledge verifies the exact link target before refreshing metadata or removing the link.

Update the catalog plugin separately when you want newer source content:

```sh
fledge plugins update fledge-plugin-skills
fledge skills status
fledge skills update --all --dry-run
fledge skills update --all
```

Use `--host codex`, `--host claude`, `--host cursor`, `--host gemini`, `--host grok`, or
`--host openai` to select one placement when a skill is installed for multiple hosts. `--host auto`
is available for install only when exactly one supported host directory already exists.

## Spec Sync placement

A project-generated Spec Sync skill owns its repository-local `spec-sync` destination.
The installer never overwrites an existing directory. Keep generated guidance in place and
install `spec-sync-routing` beside it when shared routing is useful. This policy does not
depend on a particular Spec Sync generator version or generated directory layout.

## Verify the catalog

Run the same Fledge-native checks used by CI:

```sh
fledge run --list
fledge lanes validate . --strict
fledge lanes run verify
fledge lanes run audit
```

The verification lane requires Bash, Python 3, and ShellCheck. The audit lane also requires
Gitleaks and redacts any finding output.

The direct installer is available for debugging or environments without plugin dispatch:

```sh
bin/corvid-skills list --json
bin/corvid-skills install agent-coordination --repo /path/to/project --host codex
bin/corvid-skills status --repo /path/to/project --json
bin/corvid-skills update agent-coordination --repo /path/to/project --dry-run
bin/corvid-skills uninstall agent-coordination --repo /path/to/project --dry-run
```

## Design rules

- Keep one concise skill per tool or workflow; avoid aliases and overlapping boilerplate.
- Verify real public commands before documenting them.
- Treat repository-local instructions as authoritative for that repository.
- Never include private paths, session content, secrets, user metadata, or private-repository assumptions.
- Make installation and lifecycle mutations explicit, manifest-owned, and repository-local.
