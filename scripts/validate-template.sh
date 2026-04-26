#!/usr/bin/env bash
# Template validation script — run before committing to catch drift.
# Usage: ./scripts/validate-template.sh
# Exit code: 0 = pass, 1 = failures found

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

ERRORS=0
WARNINGS=0

pass()  { echo "  ✅ $1"; }
fail()  { echo "  ❌ $1"; ERRORS=$((ERRORS + 1)); }
warn()  { echo "  ⚠️  $1"; WARNINGS=$((WARNINGS + 1)); }

# ─── 1. YAML Syntax ───────────────────────────────────────────────────────────
echo ""
echo "── YAML Syntax ──"

for f in .github/workflows/*.yml .github/copilot-setup-steps.yml .github/ISSUE_TEMPLATE/*.yml; do
  [ -f "$f" ] || continue
  if python3 -c "import yaml; yaml.safe_load(open('$f'))" 2>/dev/null; then
    pass "$f"
  else
    fail "$f — invalid YAML"
  fi
done

# ─── 2. Agent Frontmatter ─────────────────────────────────────────────────────
echo ""
echo "── Agent Frontmatter ──"

for f in .github/agents/*.md .github/agents/*.agent.md; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  if ! head -1 "$f" | grep -q "^---"; then
    fail "$name — missing frontmatter (no opening ---)"
    continue
  fi
  if ! grep -q "^name:" "$f"; then
    fail "$name — missing 'name:' in frontmatter"
  elif ! grep -q "^description:" "$f"; then
    fail "$name — missing 'description:' in frontmatter"
  else
    pass "$name"
  fi
done

# ─── 3. Agent Cross-References ────────────────────────────────────────────────
echo ""
echo "── Agent Cross-References ──"

for orchestrator in .github/agents/spec-planner.agent.md .github/agents/az-saas-planner.agent.md; do
  [ -f "$orchestrator" ] || continue
  oname=$(basename "$orchestrator")
  # Extract agents list from frontmatter
  in_agents=false
  while IFS= read -r line; do
    if [[ "$line" =~ ^agents: ]]; then
      in_agents=true
      continue
    fi
    if $in_agents; then
      # Stop at next frontmatter field or closing ---
      if [[ "$line" =~ ^[a-z] && ! "$line" =~ ^\ +" " ]] || [[ "$line" == "---" ]]; then
        break
      fi
      # Extract agent name from YAML array
      agent=$(echo "$line" | tr -d '[] ,' | sed 's/#.*//')
      [ -z "$agent" ] && continue
      # Skip non-agent lines (argument-hint, etc.)
      [[ "$agent" == *":"* ]] && continue

      if [ -f ".github/agents/${agent}.agent.md" ] || [ -f ".github/agents/${agent}.md" ]; then
        pass "$oname → $agent"
      else
        fail "$oname → $agent — FILE NOT FOUND"
      fi
    fi
  done < "$orchestrator"
done

# ─── 4. Cycle Detection ──────────────────────────────────────────────────────
echo ""
echo "── Cycle Detection ──"

# Check if az-saas-planner references spec-planner in its agents list
if grep -A 15 "^agents:" .github/agents/az-saas-planner.agent.md 2>/dev/null | grep -q "spec-planner"; then
  fail "az-saas-planner lists spec-planner as sub-agent — CYCLE DETECTED"
else
  pass "No cycles (az-saas-planner does not call spec-planner)"
fi

# Check if any leaf agent declares an agents: field
for f in .github/agents/*.agent.md; do
  [ -f "$f" ] || continue
  name=$(basename "$f" .agent.md)
  [[ "$name" == "spec-planner" || "$name" == "az-saas-planner" ]] && continue
  if grep -q "^agents:" "$f"; then
    fail "$name is a leaf agent but declares 'agents:' — potential cycle risk"
  fi
done
pass "All leaf agents are cycle-free"

# ─── 5. Placeholder Scan ─────────────────────────────────────────────────────
echo ""
echo "── Placeholder Scan ──"

# These are expected template placeholders — warn but don't fail
expected_placeholders=(
  "OWNER/REPO"
  "\\[Your company name\\]"
  "\\[DPO or privacy contact email\\]"
)

for pattern in "${expected_placeholders[@]}"; do
  matches=$(grep -rn "$pattern" --include="*.md" --include="*.yml" . 2>/dev/null | grep -v '.git/' | grep -v 'node_modules/' | grep -v 'scripts/validate-template.sh' || true)
  if [ -n "$matches" ]; then
    warn "Template placeholder found (expected — fill after cloning): $pattern"
  fi
done

# These are unexpected and indicate a bug
unexpected_placeholders=(
  "{owner}"
  "{repo}"
  "FIXME"
  "XXX"
)

for pattern in "${unexpected_placeholders[@]}"; do
  matches=$(grep -rn "$pattern" --include="*.md" --include="*.yml" --include="*.json" . 2>/dev/null | grep -v '.git/' | grep -v 'node_modules/' | grep -v 'scripts/validate-template.sh' || true)
  if [ -n "$matches" ]; then
    fail "Unexpected placeholder '$pattern' found:"
    echo "$matches" | head -5 | sed 's/^/      /'
  fi
done

if [ $ERRORS -eq 0 ]; then
  pass "No unexpected placeholders"
fi

# ─── 6. Instruction Files ────────────────────────────────────────────────────
echo ""
echo "── Instruction Files ──"

for f in .github/instructions/*.md; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  if ! head -1 "$f" | grep -q "^---"; then
    fail "$name — missing frontmatter"
  elif ! grep -q "^description:" "$f"; then
    fail "$name — missing 'description:' in frontmatter"
  else
    pass "$name"
  fi
done

# ─── 7. Prompt Files ─────────────────────────────────────────────────────────
echo ""
echo "── Prompt Files ──"

for f in .github/prompts/*.md; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  if ! head -1 "$f" | grep -q "^---"; then
    fail "$name — missing frontmatter"
  elif ! grep -q "^description:" "$f" && ! grep -q "^agent:" "$f"; then
    fail "$name — missing 'description:' or 'agent:' in frontmatter"
  else
    pass "$name"
  fi
done

# ─── 8. File Naming Convention ────────────────────────────────────────────────
echo ""
echo "── Naming Conventions ──"

# Pipeline agents should be .agent.md, cloud agents should be .md
for f in .github/agents/*.agent.md; do
  [ -f "$f" ] || continue
  name=$(basename "$f" .agent.md)
  if ! echo "$name" | grep -qE '^[a-z][a-z0-9-]+$'; then
    fail "$name.agent.md — filename should be kebab-case"
  else
    pass "$name.agent.md — kebab-case ✓"
  fi
done

for f in .github/agents/*.md; do
  [ -f "$f" ] || continue
  [[ "$f" == *.agent.md ]] && continue  # skip pipeline agents
  name=$(basename "$f" .md)
  if ! echo "$name" | grep -qE '^[a-z][a-z0-9-]+$'; then
    fail "$name.md — filename should be kebab-case"
  else
    pass "$name.md — kebab-case ✓"
  fi
done

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
  echo "✅ All checks passed ($WARNINGS warnings)"
  exit 0
else
  echo "❌ $ERRORS error(s), $WARNINGS warning(s)"
  exit 1
fi
