---
name: attest
description: Verify or record reviewed commit provenance, policy gates, and audit exports with fledge attest.
---

# Attest

Attest records review evidence for exact commits in Git notes (`refs/notes/attest`). Signing
is optional—an unsigned attestation is still a valid local record.

## Install

Use the Fledge plugin repo `CorvidLabs/fledge-plugin-attest` (not the standalone `attest`
kit alone). The public Fledge plugin targets **macOS 13+**.

```sh
fledge plugins install CorvidLabs/fledge-plugin-attest
fledge attest --help
fledge attest help sign
fledge attest help verify
```

## Verify before writing

```sh
fledge attest log -C . --json
fledge attest verify -C . --commit <sha> --json
fledge attest verify -C . --range <base>..<head> --json
```

Policy loads from `.attest.json` in the current working directory when present. Override
with `--policy <path>` only when using a non-default file (the path must exist). Treat a
missing or failed attestation as evidence to investigate, not permission to fabricate one.

## Record proven evidence

Sign or record the exact reviewed SHA only after the verdict, confidence, tests, and
reviewer identity are known:

```sh
fledge attest sign -C . --commit <sha> --reviewer <identity> --confidence <0-to-1> \
    --verdict <proceed-or-review-or-block> --note <summary> --json

# Optional cryptographic signature (requires a signing key; generate with
# `fledge attest keygen` when that subcommand is present on the installed plugin)
fledge attest sign -C . --commit <sha> --reviewer <identity> --confidence <0-to-1> \
    --verdict proceed --sign --json

# Optional: fold in prior Augur JSON (file path or `-` for stdin)
fledge attest sign -C . --commit <sha> --reviewer <identity> --from-augur <file-or--> --json
```

Add `--tests-passed` or `--human-approved` only when each statement is true. Publishing
`refs/notes/attest` is a separate remote write from creating the local note.

`export` always emits JSON (no `--json` flag):

```sh
fledge attest export -C .
fledge attest export -C . --range <base>..<head> --policy .attest.json
```

Preserve the commit SHA with every result.
