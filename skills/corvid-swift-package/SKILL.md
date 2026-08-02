---
name: corvid-swift-package
description: Build, modify, test, review, or release CorvidLabs Swift packages with Fledge-first and Swift 6 discipline.
---

# CorvidLabs Swift Package

Use this skill for a Swift package owned by CorvidLabs. It is a shared operating baseline,
not a substitute for product CLIs. The repository's `AGENTS.md`, `Package.swift`, local
skills, and CI configuration win whenever they are more specific.

## Install

**This catalog skill** (engineering baseline; not a product plugin):

```sh
fledge plugins install CorvidLabs/skills
fledge skills install corvid-swift-package --host <codex|claude|cursor|gemini|grok|openai>
```

Requires Fledge (and Swift) on the machine; there is no separate product package for this
skill.

## Discover before changing code

Start with the repository's instructions and Fledge surface. Use the native task or lane when
one exists; use `fledge introspect`, `fledge --help`, `fledge run --list`, or
`fledge plugins list` before falling back to direct `swift` or `git` commands. Read the
affected target, tests, platform conditions, and public API before proposing a change.

## Preserve package guarantees

- Give every type, extension, member, and other declaration that admits access control an
  explicit applicable level (`open`, `public`, `package`, `internal`, `fileprivate`, or
  `private`). Use `open` only for externally subclassable or overridable API and `package`
  only for package-scoped implementation API. Public API is explicit and documented. Local
  declarations do not admit access modifiers.
- Prefer descriptive generic parameters (`Value`, `Output`, `Key`) over single letters.
- Treat Swift 6 strict concurrency as a design constraint. Values shared across isolation
  domains are `Sendable`; ownership-transferred values may use Swift's `sending` and
  region-based isolation. Isolate mutable state with actors by default, or use a safe
  synchronization primitive when the repository's synchronous API requires one. Asynchronous
  APIs use `async`/`await`. For a Swift-5.9-compatible manifest, enable complete checking with
  `swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]`, but do not treat warnings
  in Swift 5 language mode as a release gate. Prefer Swift 6 tools / language mode; require a
  Swift 6 language-mode build, or an explicit warnings-as-errors CI equivalent, so concurrency
  violations fail verification.
- **Never** use force unwrap (`!`), `try!`, or `as!` in library code. Do not use callback APIs
  or `@unchecked Sendable` merely to make a build pass. Test-only or explicitly documented
  exceptions require review justification.
- Keep targets portable across the platforms **declared in `Package.swift` and actually
  verified in CI**. Read those sources before claiming multi-platform readiness—do not assume
  Windows (or any platform) unless declared and gated. When non-macOS platforms are claimed,
  do not treat a macOS-only build as a release gate.
- Prefer Apple frameworks and minimal dependencies; do not add a package dependency when the
  platform already provides the capability.

## Verify the actual release surface

Run the repository's Fledge test/release lane first. Cover the changed behavior with focused
tests, then run the package's required cross-platform or CI-equivalent lane before publishing.
Check the release artifact and public documentation when an exported API, platform support, or
version changes.

## Keep reviews actionable

In a PR, state the changed contract, platform/concurrency impact, and exact validation run.
If the package has a generated Spec Sync skill, use it for the change record and bidirectional
checks; this skill does not replace that lifecycle. For push/tag evidence language, use
`ci-release-hygiene`.
