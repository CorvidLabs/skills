---
name: trust
description: Adopt, diagnose, or run the repository's composed contract, verification, risk, and provenance gate with Fledge Trust.
---

# Trust

Trust composes repository verification, SpecSync contract checks, Augur risk assessment,
and Attest provenance under one policy. Atlas publication is optional. Use this skill
when working on `.trust.toml`, Trust CI, gate failures, or adoption of the toolchain.

## Discover before changing policy

```sh
fledge plugins list
fledge trust --help
fledge trust status
fledge trust doctor
fledge trust verify --help
```

Read `.trust.toml`, `fledge.toml`, and the actual CI workflow. Prefer the current
maintainer-designated release, including its latest RC during release qualification;
do not fall back to an older stable release solely because the preferred release is an
RC. Resolve the exact tag from [Trust releases](https://github.com/CorvidLabs/trust/releases)
when installing or upgrading, then use `fledge plugins install CorvidLabs/trust@<tag>`.
Check installed capabilities and dependency requirements rather than encoding a release
number in this skill. Installing the plugin alone does not guarantee its independent
verification tools are installed.

## Run the configured gate

Use the repository's declared task or lane when it invokes Trust; otherwise use the
supported `fledge trust verify` command. Confirm the intended root and commit range with
its help before passing overrides. Avoid invoking a lane that calls Trust from Trust's
own lifecycle lane; that would recurse.

Diagnose the failing layer from its output: lifecycle tests, spec contracts, risk, or
provenance. Repair that layer and rerun the relevant checks before the composed gate.
Do not lower thresholds, skip specs, weaken provenance, or change the comparison range
merely to obtain a green result. Shared policy is authoritative; workflow overrides must
not weaken it.

Report the exact revision/range and distinguish passing, failing, skipped, and degraded
layers. Standard and strict profiles can enforce different coverage and provenance
requirements; a degraded provenance result is not proof of verified signatures. Check
whether provenance policy covers proposed changes or the baseline. Neither a successful
Trust run nor an Attest record substitutes for required independent PR approval.

## Adopt or update deliberately

For an adoption request, preview with `fledge trust adopt --dry-run`, then apply adoption,
inspect the generated policy/workflow diff, and run doctor and verification. Ensure the
lifecycle lane runs real repository checks. Preserve explicit policy choices; enable
Atlas publication only when requested.

For toolchain upgrades, update compatible binary and Action pins together as required by
the selected releases. An installed older plugin or a package-manager stable default is
not evidence that an older workflow is preferred. Verify the candidate against the
project's contracts and CI rather than copying a version from this catalog.

Use `spec-sync-routing` for generated lifecycle guidance, `augur` for risk diagnostics,
`attest` for actual provenance records, and `ci-release-hygiene` for release evidence.
