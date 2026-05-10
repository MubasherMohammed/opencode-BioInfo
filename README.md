# OpenCode BioInfo

**75+ agentic AI skills. One-command setup. Zero external repos needed.**

A self-contained OpenCode configuration combining **11 software engineering workflow skills** (code review, security audit, feature development) and **64 bioinformatics analysis skills** (pharmacogenomics, GWAS, scRNA-seq, variant annotation, proteomics, and more) — all shipped in a single repository.

---

## Quick Install

### Prerequisites
- **OpenCode** → https://opencode.ai
- **Python 3.10+** (for bioinformatics skills)

### One-Command Setup

```bash
git clone https://github.com/MubasherMohammed/opencode-BioInfo.git
cd opencode-BioInfo
chmod +x setup.sh
./setup.sh
```

The script will:
1. Install configuration files to `~/.config/opencode/`
2. Register the unified plugin (powers both engineering + bio skills)
3. Symlink 15+ slash commands (Ctrl+P accessible)
4. Install ClawBio Python dependencies in a virtual environment
5. Verify everything is correct

### Finish

```bash
pkill -f opencode && opencode
```

Then test in a session:
```
List the skills you have available.
```

---

## What You Get

### Architecture

```
OpenCode AI (your session)
├── oh-my-openagent          Agent routing & orchestration
│   ├── Sisyphus (orchestrator)    Prompt → subagent → verify
│   ├── Prometheus (planner)       Multi-step plan generation
│   ├── Oracle (reasoning)         High-IQ debugging & architecture
│   ├── Librarian (research)       Documentation & reference
│   ├── Explore (discovery)        Codebase pattern finding
│   └── 6 category models          Optimized per domain
│
├── opencode-BioInfo (this repo)  75+ skills, self-contained
│   ├── Software Engineering       11 skills (code-review, etc.)
│   └── Bioinformatics             64 skills (ClawBio)
│
└── Built-in skills          OpenCode native
    ├── review-work           Multi-agent review
    ├── frontend-ui-ux        UI development
    ├── git-master            Git operations
    ├── playwright            Browser automation
    └── ai-slop-remover       Code quality
```

### Software Engineering Skills (11)

| Skill | What It Does |
|-------|-------------|
| `code-review` | 7-parallel-reviewer PR analysis with confidence filtering |
| `security-review` | OWASP-bucketed audit with three-stage filtering |
| `feature-dev` | 7-phase guided workflow (discovery → review) |
| `code-explorer` | End-to-end codebase trace for a feature |
| `code-architect` | Architecture blueprint with file-level implementation map |
| `code-reviewer` | Two-pass adversarial review with edge-case checklist |
| `frontend-design` | Production-grade UI, no generic AI aesthetics |
| `mcp-builder` | Build MCP servers (Python/TypeScript) |
| `skill-creator` | Author new SKILL.md files |
| `agents-md-improver` | Audit and improve AGENTS.md / CLAUDE.md |
| `agents-md-revise` | Capture session learnings into project rules |

### Bioinformatics Skills (64)

| Domain | Skills |
|--------|--------|
| **Pharmacogenomics** | `pharmgx-reporter`, `clinpgx`, `drug-photo`, `nutrigx-advisor` |
| **GWAS & Population** | `gwas-lookup`, `gwas-prs`, `fine-mapping`, `mendelian-randomisation`, `claw-ancestry-pca`, `equity-scorer` |
| **Single-cell & RNA-seq** | `scrna-orchestrator`, `scrna-embedding`, `rnaseq-de`, `rare-disease-rnaseq`, `diff-visualizer`, `cell-detection` |
| **Variant Analysis** | `variant-annotation`, `vcf-annotator`, `hla-typing`, `clinical-variant-reporter` |
| **Proteomics & Epigenetics** | `proteomics-de`, `proteomics-clock`, `methylation-clock`, `struct-predictor`, `affinity-proteomics` |
| **Metagenomics** | `claw-metagenomics` |
| **Literature** | `pubmed-summariser`, `lit-synthesizer`, `clinical-trial-finder`, `omics-target-evidence-mapper` |
| **Infrastructure** | `galaxy-bridge`, `illumina-bridge`, `bigquery-public`, `multiqc-reporter`, `seq-wrangler`, `ukb-navigator`, `ncbi-datasets`, `bioconductor-bridge`, and 20+ more |

---

## Using the Skills

### Slash Commands (Ctrl+P / Cmd+P)

| Command | When to Use |
|---------|-------------|
| `/code-review` | Review a PR or code changes before merging |
| `/security-review` | Audit code for OWASP vulnerabilities |
| `/feature-dev` | Build a new feature with structured 7-phase workflow |
| `/code-explorer` | Understand how existing code works end-to-end |
| `/frontend-design` | Generate distinctive, production-grade UI |
| `/mcp-builder` | Build an MCP server for an external API |
| `/skill-creator` | Author a reusable skill from a workflow |
| `/analyse` | Run a ClawBio bioinformatics analysis |
| `/list-skills` | List all available ClawBio bioinformatics skills |
| `/run-demo` | Run a ClawBio skill demo with built-in sample data |

### Auto-Triggered Skills

ClawBio skills are loaded automatically when your prompt matches their domain:

> "Look up rs3798220 across all genomic databases" → triggers `gwas-lookup`
> "Run pharmacogenomic profiling on this VCF" → triggers `pharmgx-reporter`
> "Process this scRNA-seq data" → triggers `scrna-orchestrator`

### Direct Python Execution

Bioinformatics skills with Python implementations are also executable from the command line:

```bash
source ~/.local/venvs/clawbio/bin/activate
python <repo>/python/clawbio.py list
python <repo>/python/clawbio.py run pharmgx --demo
python <repo>/python/clawbio.py run <skill> --input <file> --output <dir>
```

---

## Repo Structure

```
opencode-BioInfo/
├── package.json                        # Plugin marker for OpenCode
├── .opencode/plugins/
│   └── opencode-bioinfo.js             # Unified plugin shim
├── configs/
│   ├── AGENTS.md                       # Full skill reference (auto-wired)
│   ├── Global_instructions.md          # Session rules & guidance
│   └── oh-my-openagent.json            # Agent routing (Sisyphus, Oracle, etc.)
├── skills/
│   ├── power-pack/                     # 11 engineering SKILL.md files
│   └── clawbio/                        # 64 bioinformatics SKILL.md + Python
├── python/
│   ├── clawbio.py                      # ClawBio CLI runner
│   ├── requirements.txt                # Python dependencies
│   ├── conftest.py                     # Test configuration
│   └── pytest.ini                      # Pytest settings
├── commands/                           # 15+ slash command markdown files
├── scripts/
│   └── verify.sh                       # Post-install verification
├── setup.sh                            # One-command installer
└── README.md
```

---

## Updating

```bash
cd <repo>
git pull
source ~/.local/venvs/clawbio/bin/activate
pip install -r python/requirements.txt
rm -rf ~/.cache/opencode/node_modules/opencode-bioinfo
pkill -f opencode && opencode
```

---

## Credits

- **opencode-power-pack** — Wayner Barrios. Ports of Anthropic's Claude Code skills to OpenCode.
- **ClawBio** — Manuel Corpas et al. Bioinformatics-native AI agent skill library (MIT license).
- **oh-my-openagent** — Code Yeongyu. Agent routing for OpenCode.
- **superpowers** — Jesse Vincent (obra). Plugin pattern and skill registration architecture.
