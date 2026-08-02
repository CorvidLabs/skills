---
name: three-md
description: Author, validate, inspect, or render CorvidLabs 3md documents. Use for planes, axes, links, and .3md files.
---

# 3md Documents

Use this skill for the general layered-document format (Markdown plus one free axis of
planes). Use `agent-3md` for executable agent manifests (`agent.3md`).

## Install

**This catalog skill** (agent guidance):

```sh
fledge plugins install CorvidLabs/skills
fledge skills install three-md --host <codex|claude|cursor|gemini|grok|openai>
```

**Product CLI** — CorvidLabs/3md is **not** a Fledge plugin. There is no
`fledge plugins install` for `threemd`. Use the package CLI from a clone (or the project's
declared entrypoint):

## Use the repository CLI

The `threemd` executable ships with the Swift package in CorvidLabs/3md. Do not assume a
universal global install:

```sh
swift run threemd validate <file.3md>
swift run threemd info --json <file.3md>
swift run threemd links --json <file.3md>
swift run threemd check-links --json <file.3md>
swift run threemd html <file.3md>
```

`validate` / `info` / `links` / `check-links` accept optional `--json` (before or after the
file). `html` does not. A file of `-` reads standard input. HTML prints to stdout—redirect
deliberately and inspect the result. Human `validate` prints `ok` or fails nonzero;
`validate --json` emits JSON. `check-links` fails on dangling cross-plane links.

The repo also maintains TypeScript (`js/`) and Rust parsers kept in lockstep with Swift;
prefer `swift run threemd` when working inside the 3md package unless the project documents
another entrypoint.

## Author safely

Keep frontmatter valid (`3md:` version, axis, title as required by the document), define
each plane once, and preserve `[[z=…|…]]` link targets when moving content. Validate after
edits; run `check-links` when planes or files cross-reference each other. Validate
Atlas-generated `.3md` (`--3md`, `--timeline`) before treating it as project truth.
