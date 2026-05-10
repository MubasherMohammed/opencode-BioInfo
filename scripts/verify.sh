#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

pass() { echo "  ✓ $1"; PASS=$((PASS + 1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL + 1)); }

echo "  ── Verifying OpenCode AI Setup ──"
echo ""

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

# Plugin repos
[ -d "${HOME}/code/opencode-power-pack" ] && pass "opencode-power-pack cloned" || fail "opencode-power-pack missing"
[ -d "${HOME}/code/ClawBio" ] && pass "ClawBio cloned" || fail "ClawBio missing"

# Plugin JS
[ -f "${HOME}/code/opencode-power-pack/.opencode/plugins/opencode-power-pack.js" ] && pass "power-pack plugin JS exists" || fail "power-pack plugin JS missing"
[ -f "${HOME}/code/ClawBio/.opencode/plugins/clawbio.js" ] && pass "ClawBio plugin JS exists" || fail "ClawBio plugin JS missing"
[ -f "${HOME}/code/ClawBio/package.json" ] && pass "ClawBio package.json exists" || fail "ClawBio package.json missing"

# Plugin JS exports
node -e "
import('file://${HOME}/code/opencode-power-pack/.opencode/plugins/opencode-power-pack.js').then(m => {
    if (typeof m.OpencodePowerPack === 'function') { console.log('OK'); process.exit(0); }
    else { process.exit(1); }
}).catch(() => process.exit(1));
" 2>/dev/null && pass "power-pack plugin JS exports correctly" || fail "power-pack plugin JS export issue"

node -e "
import('file://${HOME}/code/ClawBio/.opencode/plugins/clawbio.js').then(m => {
    if (typeof m.ClawBio === 'function') { console.log('OK'); process.exit(0); }
    else { process.exit(1); }
}).catch(() => process.exit(1));
" 2>/dev/null && pass "ClawBio plugin JS exports correctly" || fail "ClawBio plugin JS export issue"

# Skills directories
POWER_SKILLS=$(find "${HOME}/code/opencode-power-pack/skills" -name "SKILL.md" -maxdepth 2 2>/dev/null | wc -l | xargs)
CLAW_SKILLS=$(find "${HOME}/code/ClawBio/skills" -name "SKILL.md" -maxdepth 2 2>/dev/null | wc -l | xargs)
[ "$POWER_SKILLS" -ge 11 ] && pass "power-pack: $POWER_SKILLS skills found" || fail "power-pack skills incomplete"
[ "$CLAW_SKILLS" -ge 60 ] && pass "ClawBio: $CLAW_SKILLS skills found" || fail "ClawBio skills incomplete ($CLAW_SKILLS)"

# Commands symlinked
CMD_COUNT=$(ls -1 "${HOME}/.config/opencode/commands/"*.md 2>/dev/null | wc -l | xargs)
[ "$CMD_COUNT" -ge 11 ] && pass "$CMD_COUNT slash commands symlinked" || fail "Commands incomplete ($CMD_COUNT)"

# ClawBio Python deps
[ -d "${HOME}/.local/venvs/clawbio" ] && pass "ClawBio Python venv exists" || fail "ClawBio Python venv missing"
if [ -d "${HOME}/.local/venvs/clawbio" ]; then
    source "${HOME}/.local/venvs/clawbio/bin/activate"
    python3 -c "import pandas; import requests; import numpy" 2>/dev/null && pass "ClawBio core Python deps installed" || fail "ClawBio Python deps issue"
fi

echo ""
echo "  ── Results: ${PASS} passed, ${FAIL} failed ──"

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
