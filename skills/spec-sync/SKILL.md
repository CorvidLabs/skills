---
name: spec-sync
description: Keep project contracts, implementation, and verification evidence synchronized with the repository's supported SpecSync workflow.
---

# Spec Sync

Use this catalog skill as **principles**. Read the repository-generated skill,
configuration and current CLI help for its syntax, paths, policy and migration
state. Never overwrite a generated local skill with this catalog entry. Use
Fledge where it covers the operation.

## Discover the actual implementation

```sh
fledge spec --help
specsync --version
specsync change --help
```

The independent binary is **specsync**, not spec-sync. Preserve repository and
CI pins unless an upgrade is in scope. When selecting or upgrading a toolchain,
check the [current releases](https://github.com/CorvidLabs/spec-sync/releases)
and maintainer guidance; a shared skill must not declare a permanent "latest"
version or reject a supported release candidate just because it is an RC.

Record the executable path, version and hash in the environment running the
check. An installed release, package-manager metadata and a source-built binary
can differ despite the same version string. Distinguish source revision,
observed executable identity and authenticated provenance.

For Action consumers, inspect the selected Action revision and its binary-version
input. Pin both explicitly to the intended compatible versions; do not assume an
Action tag fixes the downloaded binary. Read generated guidance before refreshing
it, inspect the diff, and use supported migration commands rather than rewriting
existing ledgers to fit a different workflow.

## Check is the product; SDD is opt-in

`specsync check` compares supported source structure with module specs.
Spec-driven development is enabled through `specsync change adopt`; a project
without adopted SDD does not need a change workspace just to check its specs.

Structural synchronization does not establish that every type, behavior or
requirement is correct. Run the repository's actual type and behavioral tests.
Inspect individual acceptance criteria and assertions: requirement-ID presence,
file coverage and a green aggregate suite are not proof of complete coverage.
Use `specsync deps --help` for the separate dependency check and its enforcement
options; ordinary `check --strict` is not automatically that gate.

## Adopted change path

Use the current local workflow and slug IDs returned by `change new`, not
historical CHG-number allocation. The supported modern path is:

```text
new → answer → scope approval → implement and test → check --commit → human review → ship/finalize
```

1. Finish the interview, selected artifacts, concrete scope and semantic deltas.
   Reuse applicable explicit human authorization for that definition; record the
   acting agent separately from the human authority source. Do not invent approval
   or use a person's name to imply they performed an agent action.
2. Implement code, canonical contracts and meaningful tests together. Complete
   actual tasks before marking them complete. A changed approved definition needs
   native reapproval under authority that covers the changed scope.
3. Run actual project tests through the declared Fledge tasks. Then use
   `specsync change check <id> --commit` for scoped spec↔code verification.
   This command does **not** run configured application test commands. A newer
   binary may disclose the unrun list; an older binary's silence is not execution.
4. Follow native status and the repository's delivery rules. For archive-first
   CI, open changes prevent the full hosted product lane; local verification and
   actual human review precede the archived-tip run.
5. Record scoped implementation review only after the required human review
   happened. Agent review, a reviewer label and a passing test are separate facts.
   The human may also be the scope approver.
6. Run `change ship` or `change finalize` immediately after recording review;
   do not insert edits or commits between them. Finalize one change at a time.
   Deliver the archive in the same PR and qualify its actual tip before any
   authorized merge. SpecSync does not merge the PR.

Legacy v1 verbs are recovery for existing legacy records, not the new-change
path. Native status and version-appropriate migration guidance decide recovery.

## Freshness, failures and archives

Use `change status <id>` to inspect approval, evidence currency and next action.
Finish evidence/checkpoint bookkeeping before final verification. Source,
contract and bookkeeping changes can affect structural freshness and review
history differently; neither an empty commit nor an ignored path is a universal
rule. Do not broaden ignore policies to make stale evidence green.

Preserve the exact failed command, exit, input identity and output before repair.
An early refusal may leave no durable native reason and may already have
materialized files. Inspect before/after state; never infer no-write behavior
from failure alone.

`change audit` checks active workspaces and living specs. Its archive-history
option is not automatically a terminal-evidence integrity gate. Likewise, a CI
gate that rejects open changes does not prove archive integrity. For that claim,
use the supported per-ID status/validator contract, inspect its integrity verdict
and explicitly reject corrupt, unknown, unreadable or nonarchived results as
appropriate. Status exit 0 alone is insufficient. Discover supported timeout
syntax rather than borrowing it from another binary.

An archive classification such as `authenticated-history` describes validation
against repository history; it does not authenticate an actor's identity.
Tamper/recovery tests belong in disposable copies, never real accepted history.

## Preserve context and generated guidance

Read and update the companions the project actually uses. Keep requirement/AC
assertion links and real execution receipts distinct. Record lessons in the
module's .3md lesson planes when configured, otherwise its context file.
Native structured state takes precedence over stale prose or a generated index;
refresh derived material and recheck freshness after authorized writes.

Use a successor change for new behavior rather than rewriting accepted evidence.
Refresh host skills only within the task's scope using the selected binary's
documented generator, commonly `specsync agents install`. Install
`spec-sync-routing` beside a generated local skill, never over it.
