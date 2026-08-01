#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
installer="$root_dir/bin/corvid-skills"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

git -C "$test_dir" init -q
mkdir -p "$test_dir/.codex/skills"

"$installer" list | grep -qx 'agent-coordination'
for skill in fledge-workflows spec-sync-routing ci-release-hygiene public-release-audit; do
    "$installer" list | grep -qx "$skill"
    skill_repo="$test_dir/$skill"
    mkdir -p "$skill_repo"
    git -C "$skill_repo" init -q
    "$installer" install "$skill" --repo "$skill_repo" --host codex
    test -f "$skill_repo/.codex/skills/$skill/SKILL.md"
done
"$installer" install agent-coordination --repo "$test_dir" --host auto
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

"$installer" status --repo "$test_dir" | grep -q '^spec-sync'
echo "installer tests passed"
