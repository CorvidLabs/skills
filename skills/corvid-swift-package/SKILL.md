---
name: corvid-swift-package
description: Build, modify, test, review, or release CorvidLabs Swift packages with Fledge-first and Swift 6 discipline.
---

# CorvidLabs Swift Package

Use this skill for a Swift package owned by CorvidLabs. It is a shared operating baseline;
the repository's `AGENTS.md`, `Package.swift`, local skills, and CI configuration win whenever
they are more specific.

## Discover before changing code

Start with the repository's instructions and Fledge surface. Use the native task or lane when
one exists; use `fledge introspect`, `fledge --help`, or `fledge plugins list` before falling
back to direct `swift` or `git` commands. Read the affected target, tests, platform conditions,
and public API before proposing a change.

## Preserve package guarantees

- Give every type, extension, member, and other declaration that admits access control an
  explicit applicable level (`open`, `public`, `package`, `internal`, `fileprivate`, or
  `private`). Use `open` only for externally subclassable or overridable API and `package`
  only for package-scoped implementation API. Public API is explicit and documented. Local
  declarations do not admit access modifiers.
- Treat Swift 6 strict concurrency as a design constraint. Values shared across isolation
  domains are `Sendable`; ownership-transferred values may use Swift's `sending` and
  region-based isolation. Isolate mutable state with actors by default, or use a safe
  synchronization primitive when the repository's synchronous API requires one. Asynchronous
  APIs use `async`/`await`. For a Swift-5.9-compatible manifest, enable complete checking with
  `swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]`, but do not treat warnings
  in Swift 5 language mode as a release gate. Require a Swift 6 language-mode build, or an explicit
  warnings-as-errors CI equivalent, so concurrency violations fail verification.
- Do not add force unwraps, `try!`, `as!`, callback APIs, or `@unchecked Sendable` merely to make
  a build pass. Explain and isolate an unavoidable exception in review.
- Keep targets portable across the package's declared Apple, Linux, and Windows platforms.
  Gate platform APIs with conditional compilation and provide a real fallback where the contract
  requires one.

## Verify the actual release surface

Run the repository's Fledge test/release lane first. Cover the changed behavior with focused
tests, then run the package's required cross-platform or CI-equivalent lane before publishing.
Check the release artifact and public documentation when an exported API, platform support, or
version changes. When a package declares non-macOS platforms, do not claim a release is ready
from a macOS-only build.

## Keep reviews actionable

In a PR, state the changed contract, platform/concurrency impact, and exact validation run.
If the package has a generated Spec Sync skill, use it for the change record and bidirectional
checks; this skill does not replace that lifecycle.
