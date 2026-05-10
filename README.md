# OpenCode AI Starter Pack

**80+ agentic skills. One-command setup. Ready for software engineering and bioinformatics work.**

A curated OpenCode configuration combining **11 software engineering workflow skills** (code review, security audit, feature development) and **63 bioinformatics analysis skills** (pharmacogenomics, GWAS, scRNA-seq, variant annotation, proteomics, and more) — all discoverable through OpenCode's native skill system.

---

## What You Get

### Agentic Orchestration (`oh-my-openagent`)
- **Sisyphus** — Orchestrator AI with subagent delegation, verification loops, and multi-file execution
- **Prometheus** — Planning agent for complex multi-step tasks
- **Oracle** — High-IQ reasoning consultant for debugging and architecture
- **Librarian** — Reference search (docs, GitHub, web)
- **Explore** — Codebase pattern discovery
- **Sisyphus-Junior** — Focused task executor

### Software Engineering Skills (`opencode-power-pack` — 11 skills)

| Skill | What It Does |
|-------|-------------|
| `code-review` | 7-parallel-reviewer PR analysis with confidence filtering |
| `security-review` | OWASP-bucketed audit with three-stage filtering |
| `feature-dev` | 7-phase guided workflow (discovery → architecture → implementation → review) |
| `code-explorer` | Deep end-to-end codebase trace for a feature |
| `code-architect` | Architecture blueprint with file-level implementation map |
| `code-reviewer` | Two-pass adversarial review with edge-case checklist |
| `frontend-design` | Distinctive, anti-"AI slop" production-grade UI |
| `mcp-builder` | Build MCP servers (Python/TypeScript) |
| `skill-creator` | Author new SKILL.md files |
| `agents-md-improver` | Audit and improve AGENTS.md / CLAUDE.md |
| `agents-md-revise` | Capture session learnings into project rules |

### Bioinformatics Skills (`ClawBio` — 63 skills)

| Domain | Skills |
|--------|-------|
| **Pharmacogenomics** | `pharmgx-reporter` (CPIC-guided drug-gene reports), `clinpgx` (gene-drug database), `drug-photo` (identify drugs from packaging), `nutrigx-advisor` (nutrigenomics) |
| **GWAS & Population** | `gwas-lookup` (9 databases), `gwas-prs` (polygenic risk scores), `fine-mapping`, `mendelian-randomisation`, `claw-ancestry-pca`, `equity-scorer` |
| **Single-cell & RNA-seq** | `scrna-orchestrator` (Scanpy pipeline), `scrna-embedding` (scVI), `rnaseq-de` (DESeq2), `rare-disease-rnaseq`, `diff-visualizer` |
| **Variant Analysis** | `variant-annotation` (VEP/ClinVar/gnomAD), `vcf-annotator`, `hla-typing`, `clinical-variant-reporter` (ACMG/AMP) |
| **Proteomics & Epigenetics** | `proteomics-de`, `proteomics-clock` (organ aging), `methylation-clock` (Horvath/GrimAge), `struct-predictor` (AlphaFold) |
| **Metagenomics** | `claw-metagenomics` (Kraken2/HUMAnN3) |
| **Literature & Translation** | `pubmed-summariser`, `lit-synthesizer`, `clinical-trial-finder`, `omics-target-evidence-mapper` |
| **Infrastructure** | `galaxy-bridge`, `illumina-bridge`, `bioconductor-bridge`, `bigquery-public`, `multiqc-reporter`, `seq-wrangler`, `repro-enforcer` |

> Each ClawBio skill pairs a **SKILL.md specification** with a **validated Python implementation** and reproducibility bundle (commands.sh + environment.yml + SHA-256 checksums). The specification encodes domain-expert analytical decisions so the AI executes correctly — not improvising from training data.

### Built-in Skills (OpenCode native)
- `review-work` — Multi-agent post-implementation review
- `frontend-ui-ux` — Everyday UI development
- `git-master` — Git operations workflow
- `playwright` — Browser automation
- `ai-slop-remover` — Code quality improvement

---

## Quick Install

### Prerequisites
- **OpenCode** installed → https://opencode.ai
- **git** (for cloning skill repos)
- **Python 3.10+** (for ClawBio bioinformatics skills)
- **Node.js 18+** (for OpenCode plugin system, bundled with OpenCode)

### One-Command Setup

```bash
git clone https://github.com/MubasherMohammed/opencode-ai-starter.git
cd opencode-ai-starter
chmod +x setup.sh
./setup.sh
```

The script will:
1. Clone `opencode-power-pack` (11 software engineering skills)
2. Clone `ClawBio` (63 bioinformatics skills)
3. Install OpenCode plugin shims for both
4. Copy configuration files to `~/.config/opencode/`
5. Symlink 11 slash commands
6. Install ClawBio Python dependencies in a virtual environment
7. Verify everything is correct

### Finish

```bash
pkill -f opencode && opencode
```

Then in an OpenCode session:
```
List the skills you have available.
```

You should see all ~80 skills listed. Also try `Ctrl+P` and search for any of:
`/code-review`, `/security-review`, `/feature-dev`, `/frontend-design`, `/skill-creator`

---

## Manual Configuration

If you prefer to configure manually, here is what the setup script does:

### 1. Install Plugins

Edit `~/.config/opencode/opencode.json`:

```json
{
  "plugin": [
    "oh-my-openagent@latest",
    "opencode-power-pack@git+file:///Users/you/code/opencode-power-pack",
    "clawbio@git+file:///Users/you/code/ClawBio"
  ]
}
```

### 2. Add Agent Routing

Copy `oh-my-openagent.json` to `~/.config/opencode/` — this configures the Sisyphus agent with category-optimized models for different task types.

### 3. Symlink Slash Commands

```bash
mkdir -p ~/.config/opencode/commands
ln -s ~/code/opencode-power-pack/commands/*.md ~/.config/opencode/commands/
```

### 4. Install ClawBio Dependencies

```bash
python3 -m venv ~/.local/venvs/clawbio
source ~/.local/venvs/clawbio/bin/activate
pip install -r ~/code/ClawBio/requirements.txt
```

### 5. Clear Cache & Restart

```bash
rm -rf ~/.cache/opencode/node_modules/opencode-power-pack
rm -rf ~/.cache/opencode/node_modules/clawbio
pkill -f opencode && opencode
```

---

## Using the Skills

### Software Engineering Skills

Invoke via `Ctrl+P` command palette or type directly:

| Command | When to Use |
|---------|-------------|
| `/code-review` | Review a PR or code changes before merging |
| `/security-review` | Audit code for OWASP vulnerabilities |
| `/feature-dev` | Build a new feature with structured 7-phase workflow |
| `/code-explorer` | Understand how existing code works end-to-end |
| `/code-architect` | Design architecture before implementing |
| `/code-reviewer` | Two-pass adversarial review of small changes |
| `/frontend-design` | Generate distinctive, production-grade UI |
| `/mcp-builder` | Build an MCP server for an external API |
| `/skill-creator` | Author a reusable skill from a workflow |
| `/agents-md-improver` | Audit and improve project rules files |
| `/agents-md-revise` | Capture session learnings into AGENTS.md |

### Bioinformatics Skills

ClawBio skills are **auto-triggering** — the AI model loads them via the native `skill` tool when your task matches their domain. For example:

- *"Look up rs3798220 across all genomic databases"* → triggers `gwas-lookup` skill
- *"Run pharmacogenomic profiling on this VCF"* → triggers `pharmgx-reporter` skill
- *"Process this scRNA-seq data"* → triggers `scrna-orchestrator` skill

Skills with Python implementations are directly executable:

```bash
source ~/.local/venvs/clawbio/bin/activate
python ~/code/ClawBio/clawbio.py list                    # List all skills
python ~/code/ClawBio/clawbio.py run pharmgx --demo      # Run demo
python ~/code/ClawBio/clawbio.py run <skill> --input <file> --output <dir>
```

---

## Architecture

```
OpenCode AI
├── oh-my-openagent          Agent routing & delegation layer
│   ├── Sisyphus (orchestrator)    Prompt → subagent → verify
│   ├── Prometheus (planner)       Multi-step plan generation
│   ├── Oracle (reasoning)         High-IQ debugging & architecture
│   ├── Librarian (research)       Documentation & reference search
│   ├── Explore (discovery)        Codebase pattern finding
│   └── 6 category models          Optimized for domain tasks
│
├── opencode-power-pack      11 engineering skills
│   ├── code-review           7-parallel-reviewer PR analysis
│   ├── security-review       OWASP audit with PoC requirement
│   ├── feature-dev           7-phase guided workflow
│   ├── code-explorer         End-to-end codebase tracing
│   ├── code-architect        Architecture blueprint design
│   ├── code-reviewer         Adversarial change review
│   ├── frontend-design       Distinctive UI generation
│   ├── mcp-builder           MCP server creation
│   ├── skill-creator         SKILL.md authoring
│   ├── agents-md-improver    Project rules audit
│   └── agents-md-revise      Session learning capture
│
├── ClawBio                  63 bioinformatics skills
│   ├── pharmgx-reporter      CPIC-guided drug-gene reports
│   ├── gwas-lookup           Federated 9-database variant query
│   ├── scrna-orchestrator    Single-cell Scanpy pipeline
│   ├── variant-annotation    VEP + ClinVar + gnomAD
│   ├── rnaseq-de             Bulk RNA-seq differential expression
│   ├── fine-mapping          SuSiE/ABF credible sets
│   ├── methylation-clock     Epigenetic age prediction
│   ├── proteomics-de         Protein differential expression
│   ├── pubmed-summariser     Literature synthesis
│   └── 55+ more             Genomics, proteomics, metagenomics...
│
└── Built-in skills          OpenCode native
    ├── review-work           Multi-agent implementation review
    ├── frontend-ui-ux        Everyday UI development
    ├── git-master            Git operations
    ├── playwright            Browser automation
    └── ai-slop-remover       Code quality
```

### How Skills Auto-Trigger

1. OpenCode's `skill` tool keeps all skill descriptions in context (~100 words each)
2. When you ask a question, the model matches keywords in your request against skill descriptions
3. Matching skills are loaded, providing the model with domain-specific methodology
4. For ClawBio skills with Python implementations, the model can execute scripts via OpenCode's bash tool
5. Results include reproducibility bundles (commands.sh, environment.yml, checksums)

---

## Updating

```bash
# Update opencode-power-pack
cd ~/code/opencode-power-pack && git pull

# Update ClawBio
cd ~/code/ClawBio && git pull

# Update Python deps
source ~/.local/venvs/clawbio/bin/activate
pip install -r ~/code/ClawBio/requirements.txt

# Clear cache
rm -rf ~/.cache/opencode/node_modules/opencode-power-pack
rm -rf ~/.cache/opencode/node_modules/clawbio

# Restart
pkill -f opencode && opencode
```

---

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Skills not listed in OpenCode | Plugin cache stale | `rm -rf ~/.cache/opencode/node_modules/* && restart` |
| `/code-review` not in palette | Commands not symlinked | Re-run the `ln -s` step from setup |
| ClawBio CLI not found | Python venv not activated | `source ~/.local/venvs/clawbio/bin/activate` |
| ClawBio skills not triggering | Skill descriptions too long for context | Ask explicitly: "Use the pharmgx-reporter skill" |
| Plugin install fails with git error | Bad URL or network | Check `git ls-remote <url>` manually |
| OpenCode won't start after config change | Invalid JSON | `python3 -m json.tool ~/.config/opencode/opencode.json` |

---

## Credits

- **opencode-power-pack** — Wayner Barrios. Ports of Anthropic's Claude Code plugins to OpenCode: https://github.com/waybarrios/opencode-power-pack
- **ClawBio** — Manuel Corpas et al. Bioinformatics-native AI agent skill library: https://github.com/ClawBio/ClawBio
- **oh-my-openagent** — Code Yeongyu. Agent routing for OpenCode: https://github.com/code-yeongyu/oh-my-openagent
- **superpowers** — Jesse Vincent (obra). Meta-workflow skills and OpenCode plugin pattern: https://github.com/obra/superpowers
