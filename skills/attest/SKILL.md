---
name: attest
description: Verify or record reviewed commit provenance, policy gates, and audit exports with fledge attest.
---

# Attest

Attest records review evidence for exact commits. The public plugin is currently macOS-only.

## Verify before writing

```sh
fledge plugins install CorvidLabs/fledge-plugin-attest
fledge attest --help
fledge attest log -C . --json
fledge attest verify -C . --commit <sha> --policy --json
fledge attest verify -C . --range <base>..<head> --policy --json
```

Treat a missing or failed attestation as evidence to investigate, not permission to fabricate one.

## Record proven evidence

Sign the exact reviewed SHA only after the verdict, confidence, tests, and reviewer identity are known:

```sh
fledge attest sign -C . --commit <sha> --reviewer <identity> --confidence <0-to-1> \
    --verdict <proceed-or-review-or-block> --note <summary> --sign --json
```

Add `--tests-passed` or `--human-approved` only when each statement is true. Signing requires
configured key material and authorization. Attestations live in Git notes under
`refs/notes/attest`; publishing those notes is a separate remote write.

Use `fledge attest export -C . --json` for an audit artifact, and preserve the commit SHA with every result.
