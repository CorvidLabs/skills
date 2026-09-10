---
module: corvid-skills
version: 1
status: active
files:
  - bin/corvid-skills
  - bin/fledge-skills
db_tables: []
depends_on: []
---

# corvid-skills

## Purpose

`bin/corvid-skills` is the installer that copies or links the shared skill directories under
`skills/` into an agent host directory, either repository-local or machine-global, and records
every managed install in a `.corvid-skills.json` manifest next to that target root. It owns the
catalog listing, install, status, update, and uninstall behavior for this repository.

`bin/fledge-skills` is the Fledge plugin entry point declared by `plugin.toml`. It resolves the
plugin source directory from `FLEDGE_PLUGIN_DIR` (falling back to the parent of its own
directory) and `exec`s `bin/corvid-skills` with the caller's arguments unchanged.

## Public API

SpecSync cannot parse extensionless shell executables, so this surface is documented as prose
rather than as an export table.

- `corvid-skills list [--json]` prints the catalog skill names from `skills/`, sorted with
  `LC_ALL=C`. `--json` emits `{"skills": [...]}`.
- `corvid-skills install <skill> [--repo <path>|--global] [--host <auto|codex|claude|cursor|gemini|grok|openai>] [--link] [--dry-run]`
  copies (default) or symlinks (`--link`) the skill into the host directory and appends a
  manifest entry recording destination, install mode, source revision, and `v2:` content digest.
- `corvid-skills status [--repo <path>|--global] [--json]` reports each manifest entry as
  `skill`, `host`, `destination`, `source_revision`, `install_mode`, `state`, where state is
  `current`, `legacy`, `modified`, or `missing`.
- `corvid-skills update <skill>|--all [--repo <path>|--global] [--host <host>] [--dry-run]`
  refreshes unmodified managed copies and manifest-owned links to the current catalog revision
  and digest.
- `corvid-skills uninstall <skill> [--repo <path>|--global] [--host <host>] [--dry-run]` removes
  a managed install and its manifest entry.
- `corvid-skills help`, `-h`, `--help`, or no arguments prints usage.
- `fledge-skills <args...>` is the Fledge plugin shim; it `exec`s `bin/corvid-skills` with the
  same arguments.

Host directories are fixed: `codex` to `.codex/skills`, `claude` to `.claude/skills`, `cursor` to
`.cursor/skills`, `gemini` to `.gemini/skills`, `grok` to `.grok/skills`, and `openai` to
`.agents/skills`.

## Invariants

- Install never overwrites an existing destination; it fails if the destination path exists.
- Install, update, and uninstall refuse any path component that is a symlink, and refuse a
  symlinked `.corvid-skills.json`.
- A skill name must match `^[a-z0-9][a-z0-9-]*$` and must resolve to a real directory under
  `skills/` that contains `SKILL.md` and only regular files and directories.
- The manifest is written atomically through a temporary file in the manifest directory followed
  by `os.replace`, and is always `schema_version = 1` with an `installs` list.
- A skill and host pair appears at most once in a manifest; a duplicate install is rejected.
- Update and uninstall act only on entries whose state is `current` (uninstall also accepts
  `legacy`), or, for `link` mode, on a symlink that still points at this checkout's source
  directory.
- `--global` and `--repo` are mutually exclusive; `--global` resolves to `CORVID_SKILLS_HOME`
  or `HOME`.
- Copy install and copy update stage into a temporary sibling path and roll back the filesystem
  change if the manifest write fails.
- `--dry-run` prints the intended action and makes no filesystem or manifest change.
- `--host auto` resolves only when exactly one host directory or host agent root is present.

## Behavioral Examples

- `corvid-skills list --json` on this checkout prints the sorted `skills/*/SKILL.md` directory
  names, which `tests/installer.sh` asserts is a 16 entry sorted list.
- `corvid-skills install agent-coordination --repo <repo> --host claude` creates
  `<repo>/.claude/skills/agent-coordination`, writes `<repo>/.corvid-skills.json` with
  `install_mode: "copy"`, and prints `Installed agent-coordination for claude at ...`.
- `corvid-skills status --repo <repo> --json` after that install reports one entry with
  `"state": "current"`.
- `corvid-skills update --all --repo <repo> --host claude --dry-run` prints one
  `Would update ...` line per matching entry and changes nothing.
- `corvid-skills uninstall agent-coordination --repo <repo> --host claude` removes the
  destination directory and drops the manifest entry.
- Editing a file inside an installed copy moves its status to `modified`, and update then
  refuses that entry.

## Error Cases

All failures exit with status 2 through `fail()` and write `corvid-skills: <message>` to stderr,
except rollback paths that exit 1 after restoring the previous filesystem state.

| Condition | Message |
|-----------|---------|
| Unknown subcommand | `unknown command: <arg>` |
| Unknown flag | `unknown option: <arg>` |
| `--repo` or `--host` without a value | `--repo needs a path` / `--host needs a value` |
| Skill name fails the name pattern | `invalid skill name: <name>` |
| Skill directory or `SKILL.md` missing | `unknown skill: <name>` |
| Skill directory holds a device, socket, or symlink entry | `skill contains unsupported filesystem entries: <name>` |
| Unsupported `--host` value | `unsupported host: <host>` |
| `--host auto` with zero or several host directories | `cannot infer an agent host; pass --host ...` / `multiple agent hosts are present (...); pass --host explicitly` |
| Target path is not a directory or not a Git repository | `not a directory: <path>` / `not a Git repository: <path>` |
| `--global` combined with `--repo` | `--global cannot be combined with --repo` |
| `--global` with no usable home | `HOME is unset; cannot use --global` / `skills home is not a directory: <path>` |
| Install destination already exists | `destination already exists: <path>` |
| Any symlinked path component or manifest | `refusing symlinked install path: ...`, `refusing symlinked managed path: ...`, `refusing symlinked managed copy: ...`, `refusing symlinked manifest: ...` |
| Manifest missing for update, uninstall | `managed-skills manifest not found: <path>` |
| Manifest is not schema 1 or has malformed entries | `unsupported managed-skills manifest: <path>` / `invalid managed-skills manifest entry` / `invalid control character in managed-skills manifest` / `invalid managed-skills manifest: <path>` |
| Manifest destination does not match the host layout | `refusing unsafe manifest destination: <path>` |
| Update or uninstall matches nothing | `no matching managed skills are installed` / `no matching managed skill is installed: <name>` |
| Managed copy drifted from its recorded digest | `refusing to update <skill> on <host>: state is <state>` |
| Managed link no longer points at this checkout | `refusing to update ...` / `refusing to uninstall <skill> on <host>: managed link was changed or removed` |
| Legacy `.openai/skills` placement on update | `OpenAI skill <skill> uses legacy .openai placement; uninstall then reinstall it for OpenAI` |
| Staging path collision | `temporary update path already exists for <skill> on <host>` / `temporary removal path already exists for <skill> on <host>` |
| `python3` unavailable for a manifest operation | `python3 is required to maintain .corvid-skills.json safely` |

## Dependencies

- `bash` 4 or newer, run with `set -euo pipefail`.
- `python3` for every manifest read, write, and JSON output path.
- `git` for `rev-parse --show-toplevel` (repository resolution) and `rev-parse --verify HEAD`
  (recorded source revision; falls back to the literal `working-tree`).
- Coreutils and findutils: `find`, `sort`, `awk`, `cp`, `mv`, `rm`, `ln`, `mkdir`, `dirname`,
  `basename`, `readlink`, `uname`.
- `shasum -a 256` when present, otherwise `sha256sum`, for content digests.
- `stat -f '%Lp'` on Darwin, `stat -c '%a'` elsewhere, for entry modes.
- Environment: `FLEDGE_PLUGIN_DIR`, `CORVID_SKILLS_HOME`, `HOME`.

## Change Log

| Change | Date | Version |
|--------|------|---------|
| Created | 2026-09-10 | 1 |
