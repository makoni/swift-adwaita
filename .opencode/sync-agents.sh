#!/usr/bin/env bash
# Generates OpenCode agents (.opencode/agents/<name>.md) from the Copilot
# agents in .github/agents/<name>.agent.md. The Copilot files stay the single
# source of truth; rerun this after editing them.
set -euo pipefail
src="${1:-.github/agents}"
dst="${2:-.opencode/agents}"
mkdir -p "$dst"
rm -f "$dst"/*.md
for f in "$src"/*.agent.md; do
    name=$(basename "$f" .agent.md)
    desc=$(awk '/^---$/{n++; next} n==1 && /^description:/{sub(/^description: */, ""); print; exit}' "$f")
    {
        echo "---"
        printf 'description: "%s"\n' "$(printf '%s' "$desc" | sed 's/[\\"]/\\&/g')"
        echo "mode: subagent"
        echo "permission:"
        echo "  edit: deny"
        echo "  webfetch: deny"
        echo "  bash: allow"
        echo "---"
        awk '/^---$/{n++; next} n>=2' "$f"
    } > "$dst/$name.md"
done
echo "Generated $(ls "$dst"/*.md | wc -l) agents in $dst"
