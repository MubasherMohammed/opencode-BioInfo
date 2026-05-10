#!/usr/bin/env bash
set -euo pipefail

# ╔══════════════════════════════════════════════════════════════╗
# ║  OpenCode AI — Automated Setup                              ║
# ║  Installs: opencode-power-pack + ClawBio + all configs      ║
# ╚══════════════════════════════════════════════════════════════╝

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config/opencode"
CODE_DIR="${HOME}/code"
POWER_PACK_DIR="${CODE_DIR}/opencode-power-pack"
CLAWBIO_DIR="${CODE_DIR}/ClawBio"
VENV_DIR="${HOME}/.local/venvs/clawbio"

echo "▸ Setting up OpenCode AI Starter..."
echo ""

# ── Step 1: Ensure OpenCode is installed ──────────────────────
if ! command -v opencode &>/dev/null; then
    echo "✗ OpenCode not found. Install it first: https://opencode.ai"
    exit 1
fi
echo "✓ OpenCode $(opencode --version 2>/dev/null || echo 'found')"

# ── Step 2: Ensure ~/code/ exists ──────────────────────────────
mkdir -p "${CODE_DIR}"

# ── Step 3: Clone skill repos ──────────────────────────────────
echo ""
echo "▸ Cloning skill repos..."

if [ ! -d "${POWER_PACK_DIR}" ]; then
    git clone https://github.com/waybarrios/opencode-power-pack.git "${POWER_PACK_DIR}"
    echo "✓ opencode-power-pack cloned"
else
    echo "✓ opencode-power-pack already exists (skipping clone)"
fi

if [ ! -d "${CLAWBIO_DIR}" ]; then
    git clone https://github.com/ClawBio/ClawBio.git "${CLAWBIO_DIR}"
    echo "✓ ClawBio cloned"
else
    echo "✓ ClawBio already exists (skipping clone)"
fi

# ── Step 4: Inject ClawBio OpenCode plugin shim ────────────────
echo ""
echo "▸ Adding OpenCode plugin shim to ClawBio..."

CLAWBIO_PLUGIN_DIR="${CLAWBIO_DIR}/.opencode/plugins"
mkdir -p "${CLAWBIO_PLUGIN_DIR}"
cp "${SCRIPT_DIR}/patches/clawbio-plugin.js" "${CLAWBIO_PLUGIN_DIR}/clawbio.js"
cp "${SCRIPT_DIR}/patches/clawbio-package.json" "${CLAWBIO_DIR}/package.json"
echo "✓ ClawBio plugin shim installed"

# ── Step 5: Set up OpenCode config files ───────────────────────
echo ""
echo "▸ Installing configuration files..."

mkdir -p "${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}/commands"

# Generate opencode.json with user's actual home directory
cat > "${CONFIG_DIR}/opencode.json" << OCFGEOF
{
    "\$schema": "https://opencode.ai/config.json",
    "instructions": [
        "Global_instructions.md"
    ],
    "plugin": [
        "opencode-lmstudio@latest",
        "oh-my-openagent@latest",
        "opencode-power-pack@git+file://${POWER_PACK_DIR}",
        "clawbio@git+file://${CLAWBIO_DIR}"
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

cp "${SCRIPT_DIR}/AGENTS.md" "${CONFIG_DIR}/AGENTS.md"
cp "${SCRIPT_DIR}/Global_instructions.md" "${CONFIG_DIR}/Global_instructions.md"
cp "${SCRIPT_DIR}/oh-my-openagent.json" "${CONFIG_DIR}/oh-my-openagent.json"

echo "✓ OpenCode configuration installed"

# ── Step 6: Symlink power-pack slash commands ──────────────────
echo ""
echo "▸ Symlinking slash commands..."

for cmd in "${POWER_PACK_DIR}/commands/"*.md; do
    ln -sf "$cmd" "${CONFIG_DIR}/commands/$(basename "$cmd")"
done
echo "✓ $(ls -1 "${POWER_PACK_DIR}/commands/"*.md 2>/dev/null | wc -l | xargs) commands symlinked"

# ── Step 7: Install ClawBio Python dependencies ────────────────
echo ""
echo "▸ Installing ClawBio Python dependencies..."

if [ ! -d "${VENV_DIR}" ]; then
    python3 -m venv "${VENV_DIR}"
    echo "✓ Python venv created at ${VENV_DIR}"
fi

source "${VENV_DIR}/bin/activate"
pip install -q -r "${CLAWBIO_DIR}/requirements.txt" 2>/dev/null
echo "✓ ClawBio Python dependencies installed"

# ── Step 8: Clear plugin cache ────────────────────────────────
echo ""
echo "▸ Clearing plugin cache..."
rm -rf "${HOME}/.cache/opencode/node_modules/opencode-power-pack" 2>/dev/null || true
rm -rf "${HOME}/.cache/opencode/node_modules/clawbio" 2>/dev/null || true
echo "✓ Plugin cache cleared"

# ── Step 9: Verify ────────────────────────────────────────────
echo ""
echo "▸ Running verification..."
"${SCRIPT_DIR}/scripts/verify.sh" || {
    echo "⚠ Verification found issues. Check output above."
    exit 1
}

# ── Done ───────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  OpenCode AI Setup Complete!                                ║"
echo "║                                                              ║"
echo "║  Restart OpenCode:  pkill -f opencode && opencode            ║"
echo "║  Verify skills:     List the skills you have available.      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
