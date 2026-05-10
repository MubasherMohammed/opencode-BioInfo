#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

pass() { echo "  ✓ $1"; PASS=$((PASS + 1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL + 1)); }

echo "  ── Verifying OpenCode BioInfo Setup ──"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# OpenCode installed
command -v opencode &>/dev/null && pass "OpenCode is installed" || fail "OpenCode not found"

# Config directory
[ -d "${HOME}/.config/opencode" ] && pass "Config directory exists" || fail "Config directory missing"

# Core config files
for f in opencode.json AGENTS.md Global_instructions.md oh-my-openagent.json; do
    [ -f "${HOME}/.config/opencode/${f}" ] && pass "${f} exists" || fail "${f} missing"
done

# Validate JSON configs
python3 -m json.tool "${HOME}/.config/opencode/opencode.json" >/dev/null 2>&1 && pass "opencode.json is valid JSON" || fail "opencode.json is invalid"
python3 -m json.tool "${HOME}/.config/opencode/oh-my-openagent.json" >/dev/null 2>&1 && pass "oh-my-openagent.json is valid JSON" || fail "oh-my-openagent.json is invalid"

# Plugin JS exists in repo
[ -f "${REPO_DIR}/.opencode/plugins/opencode-bioinfo.js" ] && pass "Unified plugin JS exists" || fail "Unified plugin JS missing"
[ -f "${REPO_DIR}/package.json" ] && pass "Plugin package.json exists" || fail "Plugin package.json missing"

# Plugin JS exports correctly
node -e "
import('file://${REPO_DIR}/.opencode/plugins/opencode-bioinfo.js').then(m => {
    if (typeof m.OpencodeBioinfo === 'function') { console.log('OK'); process.exit(0); }
    else { process.exit(1); }
}).catch((e) => { console.error(e.message); process.exit(1); });
" 2>/dev/null && pass "Plugin JS exports correctly" || fail "Plugin JS export issue"

# Skills directories
POWER_SKILLS=$(find "${REPO_DIR}/skills/power-pack" -name "SKILL.md" -maxdepth 2 2>/dev/null | wc -l | xargs)
CLAW_SKILLS=$(find "${REPO_DIR}/skills/clawbio" -name "SKILL.md" -maxdepth 2 2>/dev/null | wc -l | xargs)
[ "$POWER_SKILLS" -ge 11 ] && pass "power-pack: $POWER_SKILLS skills found" || fail "power-pack skills incomplete ($POWER_SKILLS)"
[ "$CLAW_SKILLS" -ge 60 ] && pass "ClawBio: $CLAW_SKILLS skills found" || fail "ClawBio skills incomplete ($CLAW_SKILLS)"

# ClawBio Python package
[ -d "${REPO_DIR}/python/clawbio" ] && pass "ClawBio Python package (clawbio/) exists" || fail "ClawBio Python package missing"
[ -f "${REPO_DIR}/python/clawbio/runner.py" ] && pass "ClawBio runner.py exists" || fail "ClawBio runner.py missing"
[ -f "${REPO_DIR}/python/clawbio/skill_intents.py" ] && pass "ClawBio skill_intents.py exists" || fail "ClawBio skill_intents.py missing"

# ClawBio Python CLI
[ -f "${REPO_DIR}/python/clawbio.py" ] && pass "ClawBio CLI (clawbio.py) exists" || fail "ClawBio CLI missing"
[ -f "${REPO_DIR}/python/requirements.txt" ] && pass "Python requirements.txt exists" || fail "Python requirements.txt missing"
[ -d "${HOME}/.local/venvs/clawbio" ] && pass "ClawBio Python venv exists" || fail "ClawBio Python venv missing"

if [ -d "${HOME}/.local/venvs/clawbio" ]; then
    source "${HOME}/.local/venvs/clawbio/bin/activate"
    python3 -c "import pandas; import requests; import numpy" 2>/dev/null && pass "ClawBio core Python deps installed" || fail "ClawBio Python deps issue"
    # Test CLI list shows all skills with [OK]
    LIST_OUTPUT=$(cd "${REPO_DIR}/python" && python clawbio.py list 2>/dev/null)
    echo "$LIST_OUTPUT" | grep -q "\[OK\]" && pass "ClawBio CLI lists skills with [OK]" || fail "ClawBio CLI skill scripts not found"
    SKIP_COUNT=$(echo "$LIST_OUTPUT" | grep -c "\[MISSING\]" || true)
    [ "$SKIP_COUNT" -eq 0 ] && pass "ClawBio CLI: 0 missing scripts" || fail "ClawBio CLI: $SKIP_COUNT missing scripts"
fi

# Python skill implementation scripts
SKILL_SCRIPT_COUNT=$(find "${REPO_DIR}/python/skills" -name "*.py" -maxdepth 2 2>/dev/null | wc -l | xargs)
[ "$SKILL_SCRIPT_COUNT" -ge 30 ] && pass "Python skill scripts: $SKILL_SCRIPT_COUNT found" || fail "Python skill scripts incomplete ($SKILL_SCRIPT_COUNT)"

# Commands symlinked
CMD_COUNT=$(ls -1 "${HOME}/.config/opencode/commands/"*.md 2>/dev/null | wc -l | xargs)
[ "$CMD_COUNT" -ge 11 ] && pass "$CMD_COUNT slash commands symlinked" || fail "Commands incomplete ($CMD_COUNT)"

# Config files in repo
[ -f "${REPO_DIR}/configs/AGENTS.md" ] && pass "Repo AGENTS.md exists" || fail "Repo AGENTS.md missing"
[ -f "${REPO_DIR}/configs/Global_instructions.md" ] && pass "Repo Global_instructions.md exists" || fail "Repo Global_instructions.md missing"
[ -f "${REPO_DIR}/configs/oh-my-openagent.json" ] && pass "Repo oh-my-openagent.json exists" || fail "Repo oh-my-openagent.json missing"

echo ""
echo "  ── Results: ${PASS} passed, ${FAIL} failed ──"

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
