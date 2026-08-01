---
name: corvid-swift-package
description: Build, review, test, and release CorvidLabs Swift packages with Fledge-first discovery, Swift 6 concurrency, and cross-platform discipline.
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

- Keep public API explicitly `public`; use the narrowest access elsewhere and document public
  declarations.
- Treat Swift 6 strict concurrency as a design constraint: cross-boundary values are `Sendable`,
  shared mutable state uses actors, and asynchronous APIs use `async`/`await`.
- Do not add force unwraps, `try!`, `as!`, callback APIs, or `@unchecked Sendable` merely to make
  a build pass. Explain and isolate an unavoidable exception in review.
- Keep targets portable across the package's declared Apple, Linux, and Windows platforms.
  Gate platform APIs with conditional compilation and provide a real fallback where the contract
  requires one.

## Verify the actual release surface

Run the repository's Fledge test/release lane first. Cover the changed behavior with focused
tests, then run the package's required cross-platform or CI-equivalent lane before publishing.
Check the release artifact and public documentation when an exported API, platform support, or
version changes. Do not claim a release is ready from a macOS-only build.

## Keep reviews actionable

In a PR, state the changed contract, platform/concurrency impact, and exact validation run.
If the package has a generated Spec Sync skill, use it for the change record and bidirectional
checks; this skill does not replace that lifecycle.
