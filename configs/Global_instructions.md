# Global Instructions for OpenCode AI

These rules apply to every session.

---

## 1. Available Skill Ecosystem

You have access to **~75 skills** across three layers:

### Agentic Orchestration (`oh-my-openagent`)
- Sisyphus (orchestrator), Prometheus (planner), Oracle (reasoning), Librarian (research), Explore (discovery), Sisyphus-Junior (executor)
- Configured in `oh-my-openagent.json`

### Software Engineering (`opencode-power-pack` — 11 skills)
`code-review`, `security-review`, `feature-dev`, `code-explorer`, `code-architect`, `code-reviewer`, `frontend-design`, `mcp-builder`, `skill-creator`, `agents-md-improver`, `agents-md-revise`

### Bioinformatics (`ClawBio` — 64 skills)
Pharmacogenomics, GWAS, scRNA-seq, variant annotation, proteomics, metagenomics, literature, infrastructure. See AGENTS.md for the full list.

---

## 2. ClawBio Skill Usage

ClawBio skills auto-trigger when a query matches their domain. For direct execution:

```bash
source ~/.local/venvs/clawbio/bin/activate
python <path-to-repo>/python/clawbio.py run <skill> --input <file> --output <dir>
```

The Python venv is at `~/.local/venvs/clawbio/`. Always activate it before running ClawBio scripts.

### Common Skill Triggers

| User says | Skill triggered |
|-----------|----------------|
| "Look up rs3798220" / "GWAS lookup" | `gwas-lookup` |
| "Pharmacogenomic report" / "CPIC" | `pharmgx-reporter` |
| "Process scRNA-seq" / "single-cell" | `scrna-orchestrator` |
| "Annotate variants" / "VEP" | `variant-annotation` |
| "Differential expression" / "RNA-seq DE" | `rnaseq-de` |
| "Epigenetic age" / "methylation" | `methylation-clock` |
| "Metagenomics" / "shotgun" | `claw-metagenomics` |
| "PubMed search" / "literature" | `pubmed-summariser` |
| "PRS" / "polygenic risk" | `gwas-prs` |
| "Drug photo" / "medication" | `drug-photo` |
| "Clinical trial" / "trial finder" | `clinical-trial-finder` |
| "Fine-mapping" / "credible sets" | `fine-mapping` |
| "Ancestry" / "PCA" | `claw-ancestry-pca` |
| "Protein structure" / "Boltz" | `struct-predictor` |

---

## 3. Root-Cause Discipline

No quick fixes. Always diagnose to the root cause and devise proper solutions. Never apply patches or workarounds unless the user explicitly asks.

---

## 4. Security & Secrets

- Never hardcode secrets or commit them to git
- Use separate API tokens/credentials for dev, staging, and prod environments
- Validate all input server-side — never trust client data

---

## 5. Architecture & Code Quality

- Design architecture before building — don't let it emerge from spaghetti
- Wrap external API calls in a clean service layer
- Version database schema changes through proper migrations

---

## 6. Testing & Resilience

- Test unhappy paths: network failures, unexpected API responses, malformed data
- Never mark a task complete without proving it works
- Run tests, check logs, demonstrate correctness

---

## 7. Workflow Orchestration

- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Use subagents liberally to keep main context window clean
- One task per subagent for focused execution

---

## 8. Task Management

1. Plan First: Write plan with checkable items
2. Verify Plan: Check in before starting implementation
3. Track Progress: Mark items complete as you go
4. Capture Lessons: Document patterns after corrections
