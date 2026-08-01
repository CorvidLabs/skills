---
name: three-md
description: Author, validate, inspect, or render CorvidLabs 3md documents. Use for planes, axes, links, and .3md files.
---

# 3md Documents

Use this skill for the general layered-document format. Use `agent-3md` for executable agent manifests.

## Use the repository CLI

The `threemd` executable ships with the Swift package; do not assume a universal global installation.

```sh
swift run threemd validate <file.3md>
swift run threemd info <file.3md> --json
swift run threemd links <file.3md> --json
swift run threemd check-links <file.3md> --json
swift run threemd html <file.3md>
```

The structured commands accept `-` for standard input. HTML renders to standard output, so
choose an explicit destination when saving it and inspect the result.

## Author safely

Keep the YAML frontmatter valid, define each declared plane and axis once, and preserve link
targets when moving content.
Validate after edits, then check links when the document references other planes or files. Validate Atlas-generated 3md
output before treating it as project truth.
