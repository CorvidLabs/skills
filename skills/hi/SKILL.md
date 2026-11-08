---
name: hi
description: Capture, inspect, export and retire human intent with permanent criterion IDs using CorvidLabs HI. Use for repository intent and criteria, not implementation acceptance.
---

# Human Intent

HI owns what a person wants, in their words. Specs, tickets and implementation
derive from it; they do not supply the human decision.

## Find the intent and tool

Read applicable `AGENTS.md` guidance, root `INTENT.md` and the relevant feature's
`## Intent` in `hi/*.md` before changing criteria. Preserve project ownership and
local guidance, including `hi/AGENTS.md`.

Prefer `fledge hi --help` when the HI plugin is available; otherwise use the
standalone `hi` command. Confirm the selected executable's path, version and hash
in the execution environment: other products also use the name `hi`. Check current
subcommand help rather than assuming the public docs match an older binary.
Installation is a separate task; this catalog entry does not install HI.

## Capture and keep the human's words

- Capture agreed wording under permanent IDs; select new IDs within the task's
  authorization after checking existing IDs. Label agent proposals as proposals
  until the human adopts them; generated criteria, fixtures and reviews are not
  authority. Preserve applicable prior authorization without asking for it again.
- Read existing IDs first with `fledge hi ls --family <FAMILY> --retired`. IDs are
  permanent names: never renumber, reuse a retired ID or overwrite a taken ID.
  Numbers identify steps and letters cases, alternating as in `SEND-1.a.1`.
- Capture with `fledge hi --root <project> <ID> "<agreed sentence>"`. HI needs no
  init; first capture creates its files. Put `--root` before the ID because every
  argument after the ID belongs to the sentence. Keep each criterion on one line;
  do not impose an audience prefix or translate human wording into API details.
- A wanted behavior may remain unbuilt or fail a test. Keep that criterion intact.
  When the human changes the goal, use `fledge hi retire <ID> "<reason>"`; it moves
  the criterion and its cases to Retired and reserves their IDs forever. Retire
  only what the human actually withdrew, recording their reason when available.

## Export only the needed scope

Use `fledge hi export <scope>` for the relevant family or file stem, with intent
prose attached. Current public docs also describe criterion-ID exports with their
ancestors and cases; use that narrower form when the selected CLI supports it.
Omitting scope exports the repository, so do that only when the task needs it.
Carry the original IDs into downstream specs and tickets, keeping generated
proposals distinct from agreed intent. `hi issue` prints a ticket; `--create`
posts one remotely and needs authorization covering that publication.

## Protect guidance and report the right boundary

Capture does not refresh existing generated guidance. When a guidance refresh is
in scope, inspect `fledge hi seed --help` and use `seed`: it updates recognized
shipped templates and preserves edited `hi/AGENTS.md`. Never delete customized
guidance to force regeneration. Preserve root `INTENT.md` prose; `hi index`
regenerates its managed feature list when needed, not the human's explanation.

Run `fledge hi check` after authorized intent edits and inspect the diff. Report it
as structural validation only. HI does not judge prose, prove behavior, track
implementation status, bind evidence or establish acceptance. Keep product checks,
human acceptance and delivery authority with their actual owners.

See the [canonical HI documentation](https://github.com/CorvidLabs/hi#readme) for
format details and supported installation choices.
