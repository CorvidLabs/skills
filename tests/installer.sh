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
"$installer" list | grep -qx 'spec-sync'
"$installer" list | grep -qx 'let'
"$installer" list | grep -qx 'rune'
"$installer" list --json | python3 -c '
import json
import sys

data = json.load(sys.stdin)
assert len(data["skills"]) == 15
assert data["skills"] == sorted(data["skills"])
'
for skill in \
    agent-3md \
    atlas \
    attest \
    augur \
    ci-release-hygiene \
    corvid-swift-package \
    corvid-web-bun \
    fledge-workflows \
    public-release-audit \
    spec-sync-routing \
    three-md
do
    "$installer" list | grep -qx "$skill"
    skill_repo="$test_dir/$skill"
    mkdir -p "$skill_repo"
    git -C "$skill_repo" init -q
    "$installer" install "$skill" --repo "$skill_repo" --host codex
    test -f "$skill_repo/.codex/skills/$skill/SKILL.md"
done
"$installer" install agent-coordination --repo "$test_dir/project/subdirectory" --host auto
"$installer" install spec-sync --repo "$test_dir" --host codex
"$installer" install let --repo "$test_dir" --host codex
"$installer" install rune --repo "$test_dir" --host codex

test -f "$test_dir/.codex/skills/agent-coordination/SKILL.md"
test -f "$test_dir/.codex/skills/spec-sync/SKILL.md"
test -f "$test_dir/.codex/skills/let/SKILL.md"
test -f "$test_dir/.codex/skills/rune/SKILL.md"
python3 - "$test_dir/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)

assert manifest["schema_version"] == 1
assert manifest["source"] == "CorvidLabs/skills"
assert {entry["skill"] for entry in manifest["installs"]} == {
    "agent-coordination",
    "let",
    "rune",
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
if "$installer" status --repo "$manifest_repo"; then
    echo "expected status to reject a symlinked manifest" >&2
    exit 1
fi
test -L "$manifest_repo/.corvid-skills.json"

invalid_manifest_repo="$test_dir/invalid-manifest-repo"
mkdir -p "$invalid_manifest_repo"
git -C "$invalid_manifest_repo" init -q
printf '{"schema_version":999,"installs":[]}\n' > "$invalid_manifest_repo/.corvid-skills.json"
if "$installer" install agent-coordination --repo "$invalid_manifest_repo" --host codex --link; then
    echo "expected an unsupported manifest to reject a link install" >&2
    exit 1
fi
test ! -e "$invalid_manifest_repo/.codex/skills/agent-coordination"
test ! -L "$invalid_manifest_repo/.codex/skills/agent-coordination"

malformed_manifest_repo="$test_dir/malformed-manifest-repo"
mkdir -p "$malformed_manifest_repo"
git -C "$malformed_manifest_repo" init -q
"$installer" install augur --repo "$malformed_manifest_repo" --host codex
python3 - "$malformed_manifest_repo/.corvid-skills.json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as source:
    manifest = json.load(source)
manifest["installs"].append({})
with open(path, "w", encoding="utf-8") as output:
    json.dump(manifest, output)
    output.write("\n")
PY
if "$installer" status --repo "$malformed_manifest_repo"; then
    echo "expected status to reject a manifest with a malformed later entry" >&2
    exit 1
fi
if "$installer" update augur --repo "$malformed_manifest_repo"; then
    echo "expected update to reject a manifest with a malformed later entry" >&2
    exit 1
fi
if "$installer" uninstall augur --repo "$malformed_manifest_repo"; then
    echo "expected uninstall to reject a manifest with a malformed later entry" >&2
    exit 1
fi
test -d "$malformed_manifest_repo/.codex/skills/augur"

if "$installer" install ../skills/agent-coordination --repo "$test_dir" --host codex; then
    echo "expected a path-like skill name to be rejected" >&2
    exit 1
fi

link_repo="$test_dir/link-repo"
mkdir -p "$link_repo"
git -C "$link_repo" init -q
"$installer" install spec-sync --repo "$link_repo" --host claude --link
test -L "$link_repo/.claude/skills/spec-sync"
"$installer" status --repo "$link_repo" | grep -q $'^spec-sync\tclaude\t.claude/skills/spec-sync\t.*\tlink\tcurrent$'

gemini_repo="$test_dir/gemini-repo"
mkdir -p "$gemini_repo/.gemini/skills"
git -C "$gemini_repo" init -q
"$installer" install agent-coordination --repo "$gemini_repo" --host auto
test -f "$gemini_repo/.gemini/skills/agent-coordination/SKILL.md"
"$installer" status --repo "$gemini_repo" |
    grep -q $'^agent-coordination\tgemini\t.gemini/skills/agent-coordination\t.*\tcopy\tcurrent$'

gemini_link_repo="$test_dir/gemini-link-repo"
mkdir -p "$gemini_link_repo"
git -C "$gemini_link_repo" init -q
"$installer" install spec-sync --repo "$gemini_link_repo" --host gemini --link
test -L "$gemini_link_repo/.gemini/skills/spec-sync"
"$installer" status --repo "$gemini_link_repo" |
    grep -q $'^spec-sync\tgemini\t.gemini/skills/spec-sync\t.*\tlink\tcurrent$'

status_repo="$test_dir/status-repo"
mkdir -p "$status_repo"
git -C "$status_repo" init -q
"$installer" install augur --repo "$status_repo" --host codex
"$installer" status --repo "$status_repo" | grep -q $'^augur\t.*\tcurrent$'
printf '\nlocal edit\n' >> "$status_repo/.codex/skills/augur/SKILL.md"
"$installer" status --repo "$status_repo" | grep -q $'^augur\t.*\tmodified$'
mv "$status_repo/.codex/skills/augur" "$status_repo/.codex/skills/augur.moved"
"$installer" status --repo "$status_repo" | grep -q $'^augur\t.*\tmissing$'

extra_entry_repo="$test_dir/extra-entry-repo"
mkdir -p "$extra_entry_repo"
git -C "$extra_entry_repo" init -q
"$installer" install augur --repo "$extra_entry_repo" --host codex
ln -s "$root_dir/README.md" "$extra_entry_repo/.codex/skills/augur/user-added-link"
"$installer" status --repo "$extra_entry_repo" | grep -q $'^augur\t.*\tmodified$'
if "$installer" update augur --repo "$extra_entry_repo"; then
    echo "expected update to reject a copied skill with an added symlink" >&2
    exit 1
fi
if "$installer" uninstall augur --repo "$extra_entry_repo"; then
    echo "expected uninstall to reject a copied skill with an added symlink" >&2
    exit 1
fi
test -L "$extra_entry_repo/.codex/skills/augur/user-added-link"

mode_change_repo="$test_dir/mode-change-repo"
mkdir -p "$mode_change_repo"
git -C "$mode_change_repo" init -q
"$installer" install augur --repo "$mode_change_repo" --host codex
chmod +x "$mode_change_repo/.codex/skills/augur/SKILL.md"
"$installer" status --repo "$mode_change_repo" | grep -q $'^augur\t.*\tmodified$'
if "$installer" update augur --repo "$mode_change_repo"; then
    echo "expected update to reject a copied skill with a mode-only change" >&2
    exit 1
fi
if "$installer" uninstall augur --repo "$mode_change_repo"; then
    echo "expected uninstall to reject a copied skill with a mode-only change" >&2
    exit 1
fi
test -x "$mode_change_repo/.codex/skills/augur/SKILL.md"

legacy_digest_repo="$test_dir/legacy-digest-repo"
mkdir -p "$legacy_digest_repo"
git -C "$legacy_digest_repo" init -q
"$installer" install augur --repo "$legacy_digest_repo" --host codex
python3 - "$legacy_digest_repo/.corvid-skills.json" "$legacy_digest_repo/.codex/skills/augur" <<'PY'
import hashlib
import json
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
skill_root = Path(sys.argv[2])
entries = []
for entry in sorted(skill_root.rglob("*"), key=lambda path: f"./{path.relative_to(skill_root).as_posix()}"):
    relative = f"./{entry.relative_to(skill_root).as_posix()}".encode()
    if entry.is_dir():
        entries.append(b"directory\0" + relative + b"\0")
    else:
        digest = hashlib.sha256(entry.read_bytes()).hexdigest().encode()
        entries.append(b"file\0" + relative + b"\0" + digest + b"\0")
legacy_digest = hashlib.sha256(b"".join(entries)).hexdigest()
with manifest_path.open(encoding="utf-8") as source:
    manifest = json.load(source)
manifest["installs"][0]["content_digest"] = legacy_digest
with manifest_path.open("w", encoding="utf-8") as output:
    json.dump(manifest, output, indent=2, sort_keys=True)
    output.write("\n")
PY
"$installer" status --repo "$legacy_digest_repo" | grep -q $'^augur\t.*\tcurrent$'
"$installer" update augur --repo "$legacy_digest_repo" --dry-run
chmod +x "$legacy_digest_repo/.codex/skills/augur/SKILL.md"
"$installer" status --repo "$legacy_digest_repo" | grep -q $'^augur\t.*\tmodified$'

unsafe_status_repo="$test_dir/unsafe-status-repo"
mkdir -p "$unsafe_status_repo"
git -C "$unsafe_status_repo" init -q
"$installer" install atlas --repo "$unsafe_status_repo" --host codex
python3 - "$unsafe_status_repo/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)
manifest["installs"][0]["destination"] = "../../outside"
with open(sys.argv[1], "w", encoding="utf-8") as output:
    json.dump(manifest, output)
PY
"$installer" status --repo "$unsafe_status_repo" | grep -q $'^atlas\t.*\tmodified$'
if "$installer" update atlas --repo "$unsafe_status_repo"; then
    echo "expected update to reject an unsafe manifest destination" >&2
    exit 1
fi
if "$installer" uninstall atlas --repo "$unsafe_status_repo"; then
    echo "expected uninstall to reject an unsafe manifest destination" >&2
    exit 1
fi

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

root_status="$("$installer" status --repo "$test_dir")"
grep -q $'^spec-sync\t.*\tcurrent$' <<< "$root_status"
nested_status="$("$installer" status --repo "$test_dir/project/subdirectory")"
grep -q $'^spec-sync\t.*\tcurrent$' <<< "$nested_status"
"$installer" status --repo "$test_dir" | grep -q '^agent-coordination'

status_json="$test_dir/status.json"
"$installer" status --repo "$test_dir" --json > "$status_json"
python3 - "$status_json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    data = json.load(source)
assert data["schema_version"] == 1
assert len(data["installs"]) == 4
assert {item["state"] for item in data["installs"]} == {"current"}
PY

lifecycle_source="$test_dir/lifecycle-source"
lifecycle_repo="$test_dir/lifecycle-repo"
mkdir -p "$lifecycle_source/bin" "$lifecycle_source/skills" "$lifecycle_repo"
cp "$installer" "$lifecycle_source/bin/corvid-skills"
cp -R "$root_dir/skills/augur" "$lifecycle_source/skills/augur"
cp -R "$root_dir/skills/attest" "$lifecycle_source/skills/attest"
git -C "$lifecycle_source" init -q
git -C "$lifecycle_repo" init -q
lifecycle_installer="$lifecycle_source/bin/corvid-skills"
"$lifecycle_installer" install augur --repo "$lifecycle_repo" --host codex
"$lifecycle_installer" install attest --repo "$lifecycle_repo" --host codex
printf '\nupdated catalog marker\n' >> "$lifecycle_source/skills/augur/SKILL.md"
"$lifecycle_installer" update augur --repo "$lifecycle_repo" --dry-run
if grep -q 'updated catalog marker' "$lifecycle_repo/.codex/skills/augur/SKILL.md"; then
    echo "expected dry-run update not to change installed content" >&2
    exit 1
fi
"$lifecycle_installer" update --all --repo "$lifecycle_repo" --host codex
grep -q 'updated catalog marker' "$lifecycle_repo/.codex/skills/augur/SKILL.md"
"$lifecycle_installer" status --repo "$lifecycle_repo" | grep -q $'^augur\t.*\tcurrent$'
python3 - "$lifecycle_repo/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)
augur = next(item for item in manifest["installs"] if item["skill"] == "augur")
assert augur["updated_at"]
PY

printf '\nconsumer edit\n' >> "$lifecycle_repo/.codex/skills/augur/SKILL.md"
if "$lifecycle_installer" update augur --repo "$lifecycle_repo"; then
    echo "expected update to reject a modified install" >&2
    exit 1
fi
if "$lifecycle_installer" uninstall augur --repo "$lifecycle_repo"; then
    echo "expected uninstall to reject a modified install" >&2
    exit 1
fi
grep -q 'consumer edit' "$lifecycle_repo/.codex/skills/augur/SKILL.md"

"$lifecycle_installer" uninstall attest --repo "$lifecycle_repo" --dry-run
test -d "$lifecycle_repo/.codex/skills/attest"
"$lifecycle_installer" uninstall attest --repo "$lifecycle_repo"
test ! -e "$lifecycle_repo/.codex/skills/attest"
python3 - "$lifecycle_repo/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)
assert all(item["skill"] != "attest" for item in manifest["installs"])
PY

link_update_repo="$test_dir/link-update-repo"
mkdir -p "$link_update_repo"
git -C "$link_update_repo" init -q
"$lifecycle_installer" install augur --repo "$link_update_repo" --host claude --link
printf '\nsecond catalog marker\n' >> "$lifecycle_source/skills/augur/SKILL.md"
"$lifecycle_installer" status --repo "$link_update_repo" | grep -q $'^augur\t.*\tmodified$'
"$lifecycle_installer" update augur --repo "$link_update_repo"
test -L "$link_update_repo/.claude/skills/augur"
"$lifecycle_installer" status --repo "$link_update_repo" | grep -q $'^augur\t.*\tcurrent$'
"$lifecycle_installer" uninstall augur --repo "$link_update_repo"
test ! -e "$link_update_repo/.claude/skills/augur"

grok_repo="$test_dir/grok-repo"
mkdir -p "$grok_repo"
git -C "$grok_repo" init -q
"$installer" install agent-coordination --repo "$grok_repo" --host grok
test -f "$grok_repo/.grok/skills/agent-coordination/SKILL.md"
"$installer" status --repo "$grok_repo" | grep -q $'^agent-coordination\tgrok\t.grok/skills/agent-coordination\t.*\tcopy\tcurrent$'
python3 - "$grok_repo/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)
assert len(manifest["installs"]) == 1
assert manifest["installs"][0]["host"] == "grok"
assert manifest["installs"][0]["destination"] == ".grok/skills/agent-coordination"
PY
"$installer" uninstall agent-coordination --repo "$grok_repo" --dry-run
test -d "$grok_repo/.grok/skills/agent-coordination"
"$installer" uninstall agent-coordination --repo "$grok_repo"
test ! -e "$grok_repo/.grok/skills/agent-coordination"
python3 - "$grok_repo/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)
assert manifest["installs"] == []
PY

grok_auto_repo="$test_dir/grok-auto-repo"
mkdir -p "$grok_auto_repo/.grok/skills"
git -C "$grok_auto_repo" init -q
"$installer" install let --repo "$grok_auto_repo" --host auto
test -f "$grok_auto_repo/.grok/skills/let/SKILL.md"
"$installer" status --repo "$grok_auto_repo" | grep -q $'^let\tgrok\t.grok/skills/let\t.*\tcurrent$'

# Prove Grok project placement is visible to Let find skills when Let is available.
# Let 0.2 may still federate user-global skills; only project-scope rows are asserted.
if command -v fledge >/dev/null 2>&1 && fledge let version >/dev/null 2>&1; then
    grok_let_repo="$test_dir/grok-let-repo"
    mkdir -p "$grok_let_repo"
    git -C "$grok_let_repo" init -q
    "$installer" install agent-coordination --repo "$grok_let_repo" --host grok
    "$installer" install fledge-workflows --repo "$grok_let_repo" --host grok
    fledge let find skills --scope project --host grok \
        --repo "$grok_let_repo" --cwd "$grok_let_repo" --json \
        > "$test_dir/let-find-skills-grok.json"
    python3 - "$test_dir/let-find-skills-grok.json" "$grok_let_repo" <<'PY'
import json
import sys
from pathlib import Path

payload = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
repo = Path(sys.argv[2]).resolve()
assert payload.get("ok") is True, payload
items = payload.get("data", {}).get("items", [])
project = []
for item in items:
    if item.get("scope") != "project" or item.get("host") != "grok":
        continue
    path = Path(item.get("path", "")).resolve()
    try:
        path.relative_to(repo)
    except ValueError:
        continue
    project.append(item)
names = {item["name"] for item in project}
assert names >= {"agent-coordination", "fledge-workflows"}, names
for item in project:
    expected = repo / ".grok" / "skills" / item["name"] / "SKILL.md"
    assert Path(item["path"]).resolve() == expected.resolve(), (item["path"], expected)
PY
    fledge let find skills --scope project --host grok \
        --repo "$grok_let_repo" --cwd "$grok_let_repo" \
        --query agent-coordination --json \
        > "$test_dir/let-find-query-agent-coordination.json"
    python3 - "$test_dir/let-find-query-agent-coordination.json" "$grok_let_repo" <<'PY'
import json
import sys
from pathlib import Path

payload = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
repo = Path(sys.argv[2]).resolve()
assert payload.get("ok") is True, payload
project = []
for item in payload.get("data", {}).get("items", []):
    if (
        item.get("scope") != "project"
        or item.get("host") != "grok"
        or item.get("name") != "agent-coordination"
    ):
        continue
    path = Path(item.get("path", "")).resolve()
    try:
        path.relative_to(repo)
    except ValueError:
        continue
    project.append(item)
assert len(project) == 1, project
assert project[0]["path"].endswith(".grok/skills/agent-coordination/SKILL.md")
PY
    "$installer" uninstall agent-coordination --repo "$grok_let_repo" --host grok
    fledge let find skills --scope project --host grok \
        --repo "$grok_let_repo" --cwd "$grok_let_repo" \
        --query agent-coordination --json \
        > "$test_dir/let-find-after-uninstall.json"
    python3 - "$test_dir/let-find-after-uninstall.json" "$grok_let_repo" <<'PY'
import json
import sys
from pathlib import Path

payload = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
repo = Path(sys.argv[2]).resolve()
assert payload.get("ok") is True, payload
project = []
for item in payload.get("data", {}).get("items", []):
    if (
        item.get("scope") != "project"
        or item.get("host") != "grok"
        or item.get("name") != "agent-coordination"
    ):
        continue
    path = Path(item.get("path", "")).resolve()
    try:
        path.relative_to(repo)
    except ValueError:
        continue
    project.append(item)
assert project == [], project
PY
fi

openai_repo="$test_dir/openai-repo"
mkdir -p "$openai_repo"
git -C "$openai_repo" init -q
"$installer" install agent-coordination --repo "$openai_repo" --host openai
test -f "$openai_repo/.agents/skills/agent-coordination/SKILL.md"
"$installer" status --repo "$openai_repo" | grep -q $'^agent-coordination\topenai\t.agents/skills/agent-coordination\t.*\tcopy\tcurrent$'
python3 - "$openai_repo/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)
assert len(manifest["installs"]) == 1
assert manifest["installs"][0]["host"] == "openai"
assert manifest["installs"][0]["destination"] == ".agents/skills/agent-coordination"
PY
"$installer" uninstall agent-coordination --repo "$openai_repo" --dry-run
test -d "$openai_repo/.agents/skills/agent-coordination"
"$installer" uninstall agent-coordination --repo "$openai_repo"
test ! -e "$openai_repo/.agents/skills/agent-coordination"
python3 - "$openai_repo/.corvid-skills.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    manifest = json.load(source)
assert manifest["installs"] == []
PY

openai_auto_repo="$test_dir/openai-auto-repo"
mkdir -p "$openai_auto_repo/.agents/skills"
git -C "$openai_auto_repo" init -q
"$installer" install let --repo "$openai_auto_repo" --host auto
test -f "$openai_auto_repo/.agents/skills/let/SKILL.md"
"$installer" status --repo "$openai_auto_repo" | grep -q $'^let\topenai\t.agents/skills/let\t.*\tcurrent$'

legacy_openai_repo="$test_dir/legacy-openai-repo"
mkdir -p "$legacy_openai_repo"
git -C "$legacy_openai_repo" init -q
"$installer" install agent-coordination --repo "$legacy_openai_repo" --host openai
mkdir -p "$legacy_openai_repo/.openai/skills"
mv "$legacy_openai_repo/.agents/skills/agent-coordination" "$legacy_openai_repo/.openai/skills/agent-coordination"
python3 - "$legacy_openai_repo/.corvid-skills.json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as source:
    manifest = json.load(source)
manifest["installs"][0]["destination"] = ".openai/skills/agent-coordination"
with open(path, "w", encoding="utf-8") as output:
    json.dump(manifest, output, indent=2, sort_keys=True)
    output.write("\n")
PY
"$installer" status --repo "$legacy_openai_repo" | grep -q $'^agent-coordination\topenai\t.openai/skills/agent-coordination\t.*\tcopy\tlegacy$'
if "$installer" update agent-coordination --repo "$legacy_openai_repo"; then
    echo "expected update to reject a legacy OpenAI placement" >&2
    exit 1
fi
"$installer" uninstall agent-coordination --repo "$legacy_openai_repo" --host openai
test ! -e "$legacy_openai_repo/.openai/skills/agent-coordination"

echo "installer tests passed"
