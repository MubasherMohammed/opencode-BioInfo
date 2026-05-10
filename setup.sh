#!/usr/bin/env bash
set -euo pipefail

# ╔══════════════════════════════════════════════════════════════╗
# ║  OpenCode BioInfo — Automated Setup                         ║
# ║  Self-contained: no external repos needed at install time.  ║
# ║  11 engineering skills + 64 bioinformatics skills.          ║
# ╚══════════════════════════════════════════════════════════════╝

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config/opencode"
VENV_DIR="${HOME}/.local/venvs/clawbio"

echo "▸ Setting up OpenCode BioInfo..."
echo ""

# ── Step 1: Ensure OpenCode is installed ──────────────────────
if ! command -v opencode &>/dev/null; then
    echo "✗ OpenCode not found. Install it first: https://opencode.ai"
    exit 1
fi
echo "✓ OpenCode $(opencode --version 2>/dev/null || echo 'found')"

# ── Step 2: Set up OpenCode config files ───────────────────────
echo ""
echo "▸ Installing configuration files..."

mkdir -p "${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}/commands"

# Generate or update opencode.json
# If config already exists, only update the plugin entry to preserve providers & settings
if [ -f "${CONFIG_DIR}/opencode.json" ]; then
    echo "  Existing opencode.json found — updating plugin entry only..."
    python3 -c "
import json, sys
path = '${CONFIG_DIR}/opencode.json'
with open(path) as f:
    cfg = json.load(f)
# Replace old plugin entries with unified entry
old_plugins = ['opencode-power-pack', 'clawbio', 'opencode-lmstudio', '@guard22/opencode-multi-auth-codex']
new_plugins = [p for p in cfg.get('plugin', []) if not any(old in p for old in old_plugins)]
# Ensure the unified entry is present
unified = 'opencode-bioinfo@git+file://${SCRIPT_DIR}'
if unified not in new_plugins:
    new_plugins.append(unified)
if 'oh-my-openagent@latest' not in new_plugins:
    new_plugins.insert(0, 'oh-my-openagent@latest')
cfg['plugin'] = new_plugins
with open(path, 'w') as f:
    json.dump(cfg, f, indent=4)
    f.write('\n')
print('  ✓ Plugin entry updated')
" 2>&1 || echo "  ⚠ Could not update opencode.json"
else
    cat > "${CONFIG_DIR}/opencode.json" << OCFGEOF
{
    "\$schema": "https://opencode.ai/config.json",
    "instructions": [
        "Global_instructions.md"
    ],
    "plugin": [
        "oh-my-openagent@latest",
        "opencode-bioinfo@git+file://${SCRIPT_DIR}"
    ],
    "provider": {
        "openai": {
            "options": {
                "apiKey": "{env:OPENAI_API_KEY}"
            }
        },
        "ollama": {
            "npm": "@ai-sdk/openai-compatible",
            "name": "Ollama (local)",
            "options": {
                "baseURL": "http://127.0.0.1:11434/v1",
                "apiKey": "ollama"
            }
        }
    }
}
OCFGEOF
fi

cp "${SCRIPT_DIR}/configs/AGENTS.md" "${CONFIG_DIR}/AGENTS.md"
cp "${SCRIPT_DIR}/configs/Global_instructions.md" "${CONFIG_DIR}/Global_instructions.md"
cp "${SCRIPT_DIR}/configs/oh-my-openagent.json" "${CONFIG_DIR}/oh-my-openagent.json"

echo "✓ OpenCode configuration installed"

# ── Step 3: Symlink slash commands ──────────────────────────
echo ""
echo "▸ Symlinking slash commands..."

for cmd in "${SCRIPT_DIR}/commands/"*.md; do
    if [ -f "$cmd" ]; then
        ln -sf "$cmd" "${CONFIG_DIR}/commands/$(basename "$cmd")"
    fi
done
echo "✓ $(ls -1 "${SCRIPT_DIR}/commands/"*.md 2>/dev/null | wc -l | xargs) commands symlinked"

# ── Step 4: Install ClawBio Python dependencies ────────────────
echo ""
echo "▸ Installing ClawBio Python dependencies..."

if [ ! -d "${VENV_DIR}" ]; then
    python3 -m venv "${VENV_DIR}"
    echo "✓ Python venv created at ${VENV_DIR}"
fi

source "${VENV_DIR}/bin/activate"
pip install -q -r "${SCRIPT_DIR}/python/requirements.txt" 2>/dev/null
echo "✓ ClawBio Python dependencies installed"

# ── Step 5: Clear plugin cache ────────────────────────────────
echo ""
echo "▸ Clearing plugin cache..."
rm -rf "${HOME}/.cache/opencode/node_modules/opencode-bioinfo" 2>/dev/null || true
rm -rf "${HOME}/.cache/opencode/node_modules/opencode-power-pack" 2>/dev/null || true
rm -rf "${HOME}/.cache/opencode/node_modules/clawbio" 2>/dev/null || true
echo "✓ Plugin cache cleared"

# ── Step 6: Verify ───────────────────────────────────────────
echo ""
echo "▸ Running verification..."
"${SCRIPT_DIR}/scripts/verify.sh" || {
    echo "⚠ Verification found issues. Check output above."
    exit 1
}

# ── Done ───────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  OpenCode BioInfo Setup Complete!                           ║"
echo "║                                                              ║"
echo "║  Restart OpenCode:  pkill -f opencode && opencode            ║"
echo "║                                                              ║"
echo "║  Skills: 11 engineering + 64 bioinformatics = ~75 total      ║"
echo "║  Commands: Ctrl+P → /analyse, /list-skills, /code-review...  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
