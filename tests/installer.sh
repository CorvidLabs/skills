#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
installer="$root_dir/bin/corvid-skills"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

git -C "$test_dir" init -q
mkdir -p "$test_dir/.codex/skills"
mkdir -p "$test_dir/project/subdirectory"

"$installer" list | grep -qx 'agent-coordination'
"$installer" install agent-coordination --repo "$test_dir/project/subdirectory" --host auto
"$installer" install spec-sync --repo "$test_dir" --host codex

test -f "$test_dir/.codex/skills/agent-coordination/SKILL.md"
test -f "$test_dir/.codex/skills/spec-sync/SKILL.md"
python3 - "$test_dir/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)

assert manifest["schema_version"] == 1
assert manifest["source"] == "CorvidLabs/skills"
assert {entry["skill"] for entry in manifest["installs"]} == {
    "agent-coordination",
    "spec-sync",
}
assert all(entry["content_digest"] for entry in manifest["installs"])
assert all(entry["source_revision"] for entry in manifest["installs"])
PY

if "$installer" install spec-sync --repo "$test_dir" --host codex; then
    echo "expected existing destination to be rejected" >&2
    exit 1
fi

escape_repo="$test_dir/escape-repo"
outside_directory="$test_dir/outside"
mkdir -p "$escape_repo/.codex" "$outside_directory"
git -C "$escape_repo" init -q
ln -s "$outside_directory" "$escape_repo/.codex/skills"
if "$installer" install agent-coordination --repo "$escape_repo" --host codex; then
    echo "expected a symlinked host directory to be rejected" >&2
    exit 1
fi
test ! -e "$outside_directory/agent-coordination"
test ! -e "$escape_repo/.corvid-skills.json"

manifest_repo="$test_dir/manifest-repo"
mkdir -p "$manifest_repo"
git -C "$manifest_repo" init -q
ln -s "$root_dir/README.md" "$manifest_repo/.corvid-skills.json"
if "$installer" install agent-coordination --repo "$manifest_repo" --host codex; then
    echo "expected a symlinked manifest to be rejected" >&2
    exit 1
fi
test -L "$manifest_repo/.corvid-skills.json"

if "$installer" install ../skills/agent-coordination --repo "$test_dir" --host codex; then
    echo "expected a path-like skill name to be rejected" >&2
    exit 1
fi

link_repo="$test_dir/link-repo"
mkdir -p "$link_repo"
git -C "$link_repo" init -q
"$installer" install spec-sync --repo "$link_repo" --host claude --link
test -L "$link_repo/.claude/skills/spec-sync"
"$installer" status --repo "$link_repo" | grep -q $'^spec-sync\tclaude\t.claude/skills/spec-sync\t.*\tlink$'

dry_run_repo="$test_dir/dry-run-repo"
mkdir -p "$dry_run_repo"
git -C "$dry_run_repo" init -q
"$installer" install agent-coordination --repo "$dry_run_repo" --host cursor --dry-run
test ! -e "$dry_run_repo/.cursor"
test ! -e "$dry_run_repo/.corvid-skills.json"

spaced_repo="$test_dir/repository with spaces"
mkdir -p "$spaced_repo/nested directory"
git -C "$spaced_repo" init -q
"$installer" install agent-coordination --repo "$spaced_repo/nested directory" --host codex
test -f "$spaced_repo/.codex/skills/agent-coordination/SKILL.md"
"$installer" status --repo "$spaced_repo/nested directory" | grep -q '^agent-coordination'

"$installer" status --repo "$test_dir" | grep -q '^spec-sync'
"$installer" status --repo "$test_dir/project/subdirectory" | grep -q '^spec-sync'
echo "installer tests passed"
