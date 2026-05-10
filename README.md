# OpenCode BioInfo

**75+ agentic AI skills. One-command setup. Zero external repos needed.**

A self-contained [OpenCode](https://opencode.ai) configuration combining **11 software engineering workflow skills** (code review, security audit, feature development) and **62 bioinformatics analysis skills** (pharmacogenomics, GWAS, scRNA-seq, variant annotation, proteomics, and more) — all shipped in a single repository that works immediately after cloning.

---

## Table of Contents

- [Quick Install](#quick-install)
- [Prerequisites](#prerequisites)
- [Model Providers](#model-providers)
  - [Cloudflare Workers AI (primary)](#cloudflare-workers-ai-primary)
  - [Ollama Local (fallback)](#ollama-local-fallback)
- [Agentic Orchestration](#agentic-orchestration)
- [Skill System](#skill-system)
- [Available Skills](#available-skills)
- [Usage Workflows](#usage-workflows)
- [Repo Structure](#repo-structure)
- [Troubleshooting](#troubleshooting)
- [Updating](#updating)
- [Credits](#credits)

---

## Quick Install

### Prerequisites

- **OpenCode** → Install from [opencode.ai](https://opencode.ai)
- **Python 3.10+** (required for bioinformatics skills)

### One-Command Setup

```bash
git clone https://github.com/MubasherMohammed/opencode-BioInfo.git
cd opencode-BioInfo
chmod +x setup.sh
./setup.sh
```

The script will:

1. Install configuration files to `~/.config/opencode/`
2. Register the unified OpenCode plugin (powers both engineering + bio skills)
3. Symlink 15+ slash commands (accessible via Ctrl+P / Cmd+P)
4. Install ClawBio Python dependencies in a virtual environment at `~/.local/venvs/clawbio/`
5. Verify everything is installed and configured correctly

### Finish

```bash
pkill -f opencode && opencode
```

Then test in a session:

```
List the skills you have available.
```

---

## Prerequisites

### Required: OpenCode Subscription

This setup uses OpenCode cloud-hosted models for agentic orchestration. An **OpenCode Pro subscription** is required for the following model IDs configured in `oh-my-openagent.json`:

| Model ID | Used By |
|----------|---------|
| `opencode/kimi-k2.5` | Sisyphus, Prometheus, Atlas, Deep, Ultrabrain |
| `opencode/glm-5` | Oracle, Visual-Engineering, Artistry, Writing |
| `opencode/minimax-m2.5` | Librarian (research agent) |
| `opencode/gpt-5-nano` | Explore, Sisyphus-Junior, Quick tasks |

Without a subscription, these model IDs will not resolve. You can replace them with models from another provider by editing `~/.config/opencode/oh-my-openagent.json` after setup.

### Required: API Keys (for bioinformatics skills)

Set these in your `~/.zshrc` (or equivalent shell config):

```bash
# Cloudflare Workers AI (primary LLM provider)
export CLOUDFLARE_ACCOUNT_ID="19277c7702363e6a2fd37c0a52b512c2"
export CLOUDFLARE_API_KEY="cfut_<your-api-key>"

# OpenAI (optional — for skills that need GPT)
export OPENAI_API_KEY="sk-..."
```

After adding, run `source ~/.zshrc` to apply.

---

## Model Providers

### Cloudflare Workers AI (primary)

Cloudflare Workers AI provides access to **55+ text generation models** via an OpenAI-compatible API endpoint. It offers a free tier with 10,000 neurons/day.

#### How it works

The `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_API_KEY` environment variables are read by OpenCode's built-in `cloudflare-workers-ai` provider. A custom provider (`cloudflare-custom`) is also configured in `opencode.json` to expose all 55 text generation models (the built-in provider only shows 8).

#### Best models for agentic coding

| Model | Function Calling | Reasoning | Notes |
|-------|:---:|:---:|-------|
| OpenAI GPT-OSS 120B | ✅ | ✅ | Largest, best for complex tasks |
| Kimi K2.5 | ✅ | ✅ | Strong agentic performance |
| Nemotron 3 120B | ✅ | ✅ | NVIDIA MoE, strong reasoning |
| Gemma 4 26B | ✅ | ✅ | Google, 256k context |
| GLM-4.7 Flash | ✅ | ✅ | Fast, multilingual |
| Llama 3.3 70B FP8 | ✅ | ❌ | Fast inference |
| Qwen3 30B-A3B | ✅ | ✅ | Good reasoning, FP8 |

After setup, type `/models` in OpenCode and select **Cloudflare (all models)** → pick any model.

#### Verify Cloudflare is working

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/ai/run/@cf/meta/llama-3.1-8b-instruct" \
  -H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
  -d '{"messages":[{"role":"user","content":"Return only OK"}]}'
```

Expected response: `{"success": true, "result": {"response": "OK"}}`

### Ollama Local (fallback)

For offline development or when you want to avoid API costs, you can run models locally with Ollama.

#### Setup

```bash
# Install Ollama
brew install ollama

# Pull a coding model
ollama pull qwen2.5-coder:3b

# Start Ollama
ollama serve &
```

#### Use in OpenCode

1. OpenCode auto-detects the Ollama provider if running
2. Type `/models` and select **Ollama (local)** → **qwen2.5-coder:3b**
3. Start coding — the model runs locally with Metal GPU acceleration

For detailed Ollama setup, see [`docker/README.md`](https://github.com/MubasherMohammed/opencode-BioInfo/blob/main/docker/README.md) in this repo.

---

## Agentic Orchestration

OpenCode BioInfo uses `oh-my-openagent` as its orchestration layer — a routing system that dispatches tasks to specialized AI agents, each optimized for a specific domain.

### Orchestration Architecture

```
Your Prompt
     │
     ▼
┌─────────────────────────────────────────────────┐
│              Sisyphus (Orchestrator)             │
│  Analyzes intent → classifies → routes → verify  │
└────┬──────┬──────┬──────┬──────┬─────────────────┘
     │      │      │      │      │
     ▼      ▼      ▼      ▼      ▼
┌────────┐┌────────┐┌────────┐┌────────┐┌──────────┐
│Oracle  ││Librarian││Explore ││Prometheus││Sis.-Jr. │
│Reason- ││Research││Codebase││Planner  ││Executor │
│ing/Arch││(docs)  ││(grep)  ││(strategy)││(code)   │
└────────┘└────────┘└────────┘└────────┘└──────────┘
     │          │
     ▼          ▼
┌─────────────────────────────────────────────────┐
│              75+ Domain Skills                    │
│  (auto-loaded based on your prompt's context)     │
└─────────────────────────────────────────────────┘
```

### Agent Roles

| Agent | Role | When It's Used |
|-------|------|----------------|
| **Sisyphus** | Orchestrator — analyzes your request, delegates to the right sub-agents, then verifies results | Every request. Routes work to specialists. |
| **Oracle** | High-IQ reasoning for debugging, architecture design, and complex logic | When you ask "why is X broken?" or "design the architecture for Y" |
| **Librarian** | Searches external documentation, GitHub repos, and web references | When you ask about an unfamiliar library or "find me an example of..." |
| **Explore** | Codebase pattern discovery — contextual grep across the project | When you ask "where is X implemented?" or "how does Y work here?" |
| **Prometheus** | Generates multi-step execution plans | For any non-trivial task (3+ steps or architectural decisions) |
| **Sisyphus-Junior** | Focused task executor — implements a single atomic change | After the plan is set, for actual code changes |

### How Orchestration Works in Practice

1. **Sisyphus receives your prompt** and classifies it (complexity × domain)
2. **For research questions** ("How does GWAS lookup work?"): Sisyphus fires Explore + Librarian in parallel, synthesizes results, and answers
3. **For implementation tasks** ("Add pharmacogenomic reporting"): Sisyphus consults Prometheus for a plan, delegates to Sisyphus-Junior for execution, runs Oracle for quality review, and verifies the result
4. **For debugging** ("This VCF annotation broke"): Sisyphus tries the obvious fix, escalates to Oracle after 2 failures, implements the solution Oracle prescribes, and verifies

---

## Skill System

Skills are the building blocks of OpenCode BioInfo. They come in three layers and are loaded automatically when your prompt matches their description.

### How Skills Auto-Trigger

1. OpenCode's `skill` tool keeps all skill descriptions (~100 words each) in context
2. When you ask a question or give a command, the AI matches keywords against skill descriptions
3. Matching skills are loaded, providing domain-specific methodology and instructions
4. You can also invoke skills explicitly via slash commands

### Three Ways to Use Skills

#### 1. Natural Language (auto-triggered)

Just describe what you need. The right skill loads automatically:

> "Look up rs3798220 across all genomic databases" → `gwas-lookup`
>
> "Run pharmacogenomic profiling on this VCF" → `pharmgx-reporter`
>
> "Process this scRNA-seq data from the 10x run" → `scrna-orchestrator`
>
> "Review the code changes in this branch" → `code-review`
>
> "Design an architecture for a variant annotation pipeline" → `code-architect`

#### 2. Slash Commands (Ctrl+P / Cmd+P)

| Command | What It Does |
|---------|-------------|
| `/code-review` | Review a PR or code changes before merging |
| `/security-review` | Audit code for OWASP vulnerabilities |
| `/feature-dev` | Build a new feature with structured 7-phase workflow |
| `/code-explorer` | Understand how existing code works end-to-end |
| `/code-architect` | Design architecture with implementation blueprint |
| `/frontend-design` | Generate distinctive, production-grade UI |
| `/mcp-builder` | Build an MCP server for an external API |
| `/skill-creator` | Author a reusable skill from a workflow |
| `/analyse` | Run a ClawBio bioinformatics analysis |
| `/list-skills` | List all available ClawBio bioinformatics skills |
| `/run-demo` | Run a ClawBio skill demo with built-in sample data |
| `/new-skill` | Build and register a new ClawBio skill |
| `/agents-md-improver` | Audit and improve project rules files |
| `/agents-md-revise` | Capture session learnings into project rules |

#### 3. Direct Python Execution (CLI)

Bioinformatics skills with Python implementations can run outside OpenCode:

```bash
source ~/.local/venvs/clawbio/bin/activate

# List all available skills
python <repo>/python/clawbio.py list

# Run a skill demo (uses built-in sample data)
python <repo>/python/clawbio.py run pharmgx-reporter --demo

# Run a skill with your own data
python <repo>/python/clawbio.py run variant-annotation --input my_variants.vcf --output ./results/
```

---

## Available Skills

### Software Engineering Skills (11)

| Skill | What It Does |
|-------|-------------|
| `code-review` | 7-parallel-reviewer PR analysis with confidence filtering |
| `security-review` | OWASP-bucketed audit with three-stage filtering |
| `feature-dev` | 7-phase guided workflow (discovery → architecture → implementation → review) |
| `code-explorer` | End-to-end codebase trace for a feature |
| `code-architect` | Architecture blueprint with file-level implementation map |
| `code-reviewer` | Two-pass adversarial review with edge-case checklist |
| `frontend-design` | Production-grade UI, no generic AI aesthetics |
| `mcp-builder` | Build MCP servers (Python/TypeScript) |
| `skill-creator` | Author new SKILL.md files |
| `agents-md-improver` | Audit and improve AGENTS.md / CLAUDE.md |
| `agents-md-revise` | Capture session learnings into project rules |

### Bioinformatics Skills (62)

| Domain | Skills |
|--------|--------|
| **GWAS & Population Genetics** | `claw-ancestry-pca`, `fine-mapping`, `gwas-lookup`, `gwas-pipeline`, `gwas-prs`, `mendelian-randomisation`, `wgs-prs` |
| **Pharmacogenomics** | `clinpgx`, `drug-photo`, `nutrigx-advisor`, `pharmgx-reporter` |
| **Single-cell & RNA-seq** | `cell-detection`, `diff-visualizer`, `rare-disease-rnaseq`, `rnaseq-de`, `scrna-embedding`, `scrna-orchestrator` |
| **Variant Analysis** | `clinical-variant-reporter`, `hla-typing`, `variant-annotation`, `vcf-annotator` |
| **Proteomics & Epigenetics** | `affinity-proteomics`, `methylation-clock`, `proteomics-clock`, `proteomics-de`, `struct-predictor` |
| **Metagenomics** | `claw-metagenomics` |
| **Literature & Translation** | `clinical-trial-finder`, `equity-scorer`, `lit-synthesizer`, `omics-target-evidence-mapper`, `pubmed-summariser` |
| **Infrastructure & Utilities** | `analyze-fasta`, `archaic-introgression`, `bgpt-mcp`, `bigquery-public`, `bio-orchestrator`, `bioconductor-bridge`, `claw-semantic-sim`, `clawpathy_autoresearch`, `data-extractor`, `de-summary`, `dnasp`, `flow-bio`, `galaxy-bridge`, `genome-compare`, `genome-match`, `illumina-bridge`, `labstep`, `multiqc-reporter`, `ncbi-datasets`, `profile-report`, `protocols-io`, `recombinator`, `repro-enforcer`, `seq-wrangler`, `skill-builder`, `soul2dna`, `target-validation-scorer`, `turingdb-graph`, `ukb-navigator`, `wes-clinical-report-en`, `wes-clinical-report-es` |

---

## Usage Workflows

### Daily Coding with Agentic Skills

```text
1. Start your session: opencode
2. Select a capable model (/models → Cloudflare → Kimi K2.5)
3. Just start typing what you need:

   "Review all unstaged changes in this repo"
     → /code-review triggers, analyzes every file

   "Add error handling to the API client"
     → Sisyphus plans the changes, implements, verifies

   "Explain how the variant annotation pipeline works"
     → Explore agent traces the code paths, summarizes
```

### Bioinformatics Analysis

```text
1. Make sure the ClawBio venv is active and your input data is ready
2. In an OpenCode session, describe your analysis:

   "Annotate these 1000 variants from my VCF file"
     → variant-annotation skill auto-loads, runs VEP + ClinVar + gnomAD

   "Run a GWAS on this PLINK dataset"
     → gwas-pipeline skill auto-loads, runs QC + association testing

3. Or run directly from the terminal:
   source ~/.local/venvs/clawbio/bin/activate
   python clawbio.py run variant-annotation --input variants.vcf --output ./anno/
```

### Full Development Cycle

```text
1. /code-explorer → Understand existing codebase
2. /code-architect → Design your change
3. Sisyphus implements the change
4. /code-review → Review what was built
5. /security-review → Check for vulnerabilities
6. Sisyphus verifies and iterates
```

### Cloudflare Model Selection Tips

- **Complex tasks** (architecture, analysis, multi-step): Use Kimi K2.5 or GPT-OSS 120B
- **Fast iterations** (debugging, simple changes): Use GLM-4.7 Flash or Llama 3.3 70B FP8
- **Reasoning-heavy** (math, logic): Use Qwen3 30B-A3B or Nemotron 3 120B
- **Long context** (large files, many files): Use Kimi K2.5 (262k context) or Gemma 4 26B (256k context)

---

## Repo Structure

```
opencode-BioInfo/
├── package.json                        # Plugin marker — OpenCode detects this
├── .opencode/plugins/
│   └── opencode-bioinfo.js             # Unified plugin shim (powers all skills)
├── configs/                            # Copied to ~/.config/opencode/ by setup.sh
│   ├── AGENTS.md                       # Full skill reference (auto-wired by OpenCode)
│   ├── Global_instructions.md          # Session rules & behavioral guidance
│   └── oh-my-openagent.json            # Agent routing config (Sisyphus, Oracle, etc.)
├── skills/
│   ├── power-pack/                     # 11 engineering skill definitions (SKILL.md)
│   └── clawbio/                        # 62 bioinformatics skill definitions (SKILL.md)
│       └── catalog.json                # Skill index for ClawBio CLI
├── python/
│   ├── clawbio.py                      # ClawBio CLI runner
│   ├── clawbio/                        # Python package (runner, skill intents)
│   ├── skills/                         # Python implementations for each skill
│   ├── requirements.txt                # Python dependencies (pinned with upper bounds)
│   ├── conftest.py                     # Pytest configuration
│   ├── pytest.ini                      # Pytest settings
│   ├── Makefile                        # Test/build shortcuts
│   └── scaffold_skill.py               # Skill scaffolding tool
├── commands/                           # 15 slash commands (opencode/*.md)
├── scripts/
│   └── verify.sh                       # Post-install verification (run by setup.sh)
├── setup.sh                            # One-command installer
└── README.md
```

---

## Troubleshooting

### "opencode-bioinfo plugin not loading"

```bash
# Clear plugin cache and restart
rm -rf ~/.cache/opencode/node_modules/opencode-bioinfo
pkill -f opencode && opencode
```

### ClawBio CLI says "[MISSING]"

```bash
# Reinstall Python dependencies
source ~/.local/venvs/clawbio/bin/activate
pip install -r <repo>/python/requirements.txt
```

### Cloudflare models not appearing in `/models`

```bash
# Verify env vars are set
echo $CLOUDFLARE_ACCOUNT_ID
echo $CLOUDFLARE_API_KEY

# If empty, source your shell config
source ~/.zshrc

# If still missing, verify the provider entry in opencode.json
cat ~/.config/opencode/opencode.json | grep cloudflare
```

### OpenCode shows "Insufficient balance" for model IDs

The `opencode/*` models require an OpenCode Pro subscription. Either:
- Upgrade your OpenCode plan at https://opencode.ai
- Or switch to Cloudflare models in `/models` (free tier available)

### Verify installation

```bash
cd <repo>
./scripts/verify.sh
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
- **oh-my-openagent** — Code Yeongyu. Agent routing and orchestration for OpenCode.
- **superpowers** — Jesse Vincent (obra). Plugin pattern and skill registration architecture.

---

*Built with OpenCode AI. Deploy once, skill anywhere.*
