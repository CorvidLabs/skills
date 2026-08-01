---
name: let-rune-operations
description: Coordinate CorvidLabs CLI agents safely by discovering with Let before observing or intervening with Rune.
---

# Let + Rune Operations

Use this protocol for live agent supervision. It avoids duplicate work, contradictory prompts,
and reports based only on stale terminal output.

## The protocol

1. **Discover:** use Let to resolve the repository, worktree, instructions, sibling worktrees,
   recent session records, and relevant skills.
2. **Confirm:** inspect the worktree, commit history, pull request, CI, and sandbox. These are
   the sources of truth for delivery state.
3. **Observe:** use Rune to open the one confirmed active session with a bounded watch window.
4. **Intervene only when safe:** send one non-conflicting, outcome-based prompt. Do not inject
   a status request into a test, commit, push, migration, or independent review.
5. **Verify the result:** read the worktree and CI again. A successful prompt delivery is not a
   completed change.

## CI and status triage

For a failing pull request, identify the failing check and inspect its log and commit before
messaging the agent. For a quiet session, compare session freshness with Git activity and CI;
the agent may be waiting on an external runner rather than idle. Prefer concise reports with:
current artifact, verified gate state, concrete blocker, and next action.

## Recovery patterns

- **Wrong worktree or session:** stop, re-run Let discovery, and do not edit or message it.
- **Prompt not delivered:** distinguish a local PTY launch from a provider response. If the
  network/provider is unavailable, report that boundary and use repository evidence instead.
- **Concurrent agents:** assign one worktree and responsibility per agent. Use sibling-worktree
  information to avoid overlapping edits.
- **Repeated CI failure:** reproduce narrowly, add or confirm a regression test, and record the
  lesson in the change package rather than repeatedly sending broad retry prompts.

Let supplies the map; Rune supplies the console. Neither replaces Git history, pull requests,
CI, sandbox evidence, or human review.
