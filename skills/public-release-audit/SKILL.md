---
name: public-release-audit
description: Audit a private repository for safe public release without changing visibility prematurely.
---

# Public Release Audit

Use this skill before making a private repository public or creating its first public
release.

## Audit the repository

Check the current tree and relevant history for:

- credentials, tokens, private endpoints, and secret-bearing configuration;
- personal paths, local machine assumptions, internal data, and sensitive fixtures;
- portable fixtures and CI that run without private local dependencies;
- accurate README, examples, license, contributing guidance, and security reporting;
- public-safe issue templates, release notes, package metadata, and documentation.

Run the repository's portability and CI checks with repository-relative fixtures. Record
findings and remediations in the PR or release checklist.

## Make the decision explicit

Do not change repository visibility as part of the audit. Complete the audit, present
the remaining risks, and obtain an explicit owner decision to make the repository
public. If the live testbed contains internal context or experimental behavior, publish
a sanitized demo or template instead of the working sandbox.
