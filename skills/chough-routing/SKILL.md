---
name: chough-routing
description: Find and resume the product-owned Chough workflow bundle, or route authorized project initialization and skill updates. Use for Chough entry and discovery, not as a replacement workflow.
---

# Chough Routing

The complete workflow belongs to [CorvidLabs/chough](https://github.com/CorvidLabs/chough),
including its [chough-workflow bundle](https://github.com/CorvidLabs/chough/tree/main/skills/chough-workflow).
This entry locates that bundle; do not copy or fork it into this catalog.

## Discover the selected bundle

Read applicable `AGENTS.md` files. Confirm the `chough` executable's path, version
and hash in the execution environment, then read `chough --help` and
`chough skill status`. Status compares installed copies with that binary's bundle;
it does not prove host discovery or that the binary matches upstream main.

Locate `chough-workflow/SKILL.md` in the current host's project skill directories
and, when applicable, its user skill directories. Examples include `.agents/skills`,
`.codex/skills` and `.claude/skills`; mappings vary with helper and host. Follow the
project's selected copy and read it with its referenced stage/checkpoint guidance.
Preserve customizations. If copies disagree, resolve which one project guidance
and the host actually select before editing or updating. Confirm host discovery;
if it does not list the skill, give it the selected `SKILL.md` directly.

## Resume from current sources

From the project, run `chough next --environment <env>` for focused guidance and
`chough status --environment <env>` for the full JSON report. Follow the selected
session; do not initialize or reset an existing objective just to resume it.

Before the first write, read back the goal, binding and rejected choices with
reasons, latest failure and linked bug status, lesson sources, native freshness and
human gates, and next task with ownership. Cite the records and mark missing facts
as unknown. Read the current stage's reference from the selected workflow bundle.

Native status decides lifecycle gates; a checkpoint's stage and suggested action
do not grant approval. Check the recorded native change, blocking bugs and
`awaiting_human`. Follow reported evidence freshness: only current observations
count; historical, pruned or unavailable observations are not passing evidence.
Use the helper's input, artifact, case and environment checks rather than treating
a matching revision as sufficient.

If native state is missing or unreadable, surface the refusal and follow supported
recovery. A project without configured SpecSync or with SDD disabled can be ungated;
that is not approval or a reason to invent native records or adopt a lifecycle.
Use actual prior or standing human authority within its scope and limits; do not
ask again for routine authorized operations. Keep human acceptance, merge and
publication separate, and never manufacture gate replies or human identities.
Respect the designated checkpoint owner when several agents share the project.

## Initialize or refresh only within scope

If setup is requested and no checkpoint exists, read `chough init --help` and use
the supported `chough init --objective "<outcome>" --host <host>`, adding real intent
scope and module values where applicable. Init installs the binary's bundle without
overwriting existing files and may create other project records. For a project
already using per-change sessions, follow its session guidance instead of init.

For an authorized skill refresh, inspect the existing bundle and
`chough skill update --help`, then use the supported update command for the selected
host. It adds missing files and replaces only unmodified files from known earlier
bundles; edited or unknown copies need deliberate reconciliation. Inspect the diff,
rerun `chough skill status` and check host discovery. Do not delete custom files,
silently upgrade the helper, migrate schemas, or remove legacy copies as a side
effect of installing this routing entry.

Public docs can describe capabilities absent from the installed helper. Report that
difference and use supported commands; route an upgrade only when it is in scope.
