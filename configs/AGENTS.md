# OpenCode BioInfo — Complete Skill Reference

This AGENTS.md is auto-wired. Every skill listed here is available via OpenCode's native `skill` tool and auto-triggers when your task matches its description.

---

## Agentic Orchestration (`oh-my-openagent`)

| Agent | Role |
|-------|------|
| **Sisyphus** | Orchestrator — prompt → subagent delegation → verification |
| **Prometheus** | Planner — multi-step plan generation |
| **Oracle** | High-IQ reasoning for debugging & architecture |
| **Librarian** | Reference search (docs, GitHub, web) |
| **Explore** | Codebase pattern discovery |
| **Sisyphus-Junior** | Focused task executor |

Models for each agent are configured in `oh-my-openagent.json`.

---

## Software Engineering Skills (`opencode-power-pack` — 11 skills)

| Skill | Description |
|-------|-------------|
| `agents-md-improver` | Audit and improve project-rules files (AGENTS.md, CLAUDE.md) |
| `agents-md-revise` | Capture session learnings into project-rules file |
| `code-architect` | Architecture blueprint design with file-level implementation map |
| `code-explorer` | Deep end-to-end codebase trace for a feature |
| `code-review` | 7-parallel-reviewer PR analysis with confidence filtering |
| `code-reviewer` | Two-pass adversarial review with edge-case checklist |
| `feature-dev` | 7-phase guided workflow (discovery → architecture → implementation → review) |
| `frontend-design` | Distinctive, anti-AI-slop production-grade UI |
| `mcp-builder` | Build MCP servers (Python/TypeScript) |
| `security-review` | OWASP-bucketed audit with three-stage filtering |
| `skill-creator` | Author new SKILL.md files |

---

## Bioinformatics Skills (`ClawBio` — 64 skills)

### GWAS & Population Genetics
- **claw-ancestry-pca**: Ancestry decomposition PCA against the Simons Genome Diversity Project
- **fine-mapping**: Fine-mapping of GWAS loci with SuSiE/ABF credible sets
- **gwas-lookup**: Federated variant lookup across 9 genomic databases — GWAS Catalog, Open Targets, PheWeb (UKB, FinnGen, BBJ), GTEx, eQTL Catalogue
- **gwas-pipeline**: End-to-end GWAS pipeline with PLINK, SAIGE, and REGENIE wrappers
- **gwas-prs**: Calculate polygenic risk scores from DTC genetic data using the PGS Catalog
- **mendelian-randomisation**: Mendelian randomisation analysis with instrument selection and MR-PRESSO
- **wgs-prs**: PRS calculation from whole-genome sequencing VCF

### Pharmacogenomics
- **clinpgx**: Query the ClinPGx API for pharmacogenomic gene-drug data, clinical annotations, CPIC guidelines, and FDA drug labels
- **drug-photo**: Medication photo to personalised PGx dosage card via vision — snap a pill, get genotype-informed guidance
- **nutrigx-advisor**: Personalised nutrition report from consumer genetic data (23andMe, AncestryDNA, VCF)
- **pharmgx-reporter**: Pharmacogenomic report from DTC genetic data — 12 genes, 31 SNPs, 51 drugs

### Single-cell & RNA-seq
- **cell-detection**: Cell type detection and annotation from scRNA-seq expression profiles
- **diff-visualizer**: Rich visualisation and reporting for bulk RNA-seq differential expression and scRNA marker/contrast outputs
- **rare-disease-rnaseq**: Blood RNA-seq expression-outlier detection for rare-disease diagnostics
- **rnaseq-de**: Differential expression analysis for bulk RNA-seq with QC, PCA, and contrast testing
- **scrna-embedding**: Local scVI/scANVI single-cell latent embedding and batch-aware integration
- **scrna-orchestrator**: Local Scanpy pipeline for scRNA-seq QC, clustering, marker discovery, and annotation

### Variant Analysis
- **clinical-variant-reporter**: ACMG/AMP variant classification and clinical reporting
- **hla-typing**: HLA typing from NGS reads (WGS/WES/targeted)
- **variant-annotation**: Annotate VCF variants with Ensembl VEP REST, ClinVar significance, gnomAD frequency
- **vcf-annotator**: Annotate VCF variants with Ensembl VEP, ClinVar, and gnomAD with ranked reporting

### Proteomics & Epigenetics
- **affinity-proteomics**: Affinity proteomics data analysis and quality control
- **methylation-clock**: Compute epigenetic age from DNA methylation arrays using PyAging clocks
- **proteomics-clock**: Proteomic aging clock and organ-age prediction
- **proteomics-de**: Differential expression for label-free quantitative (LFQ) proteomics data
- **struct-predictor**: Protein structure prediction with Boltz-2 (pLDDT, PAE, markdown reports)

### Metagenomics
- **claw-metagenomics**: Shotgun metagenomics profiling — taxonomy, resistome, and functional pathways

### Literature & Translation
- **clinical-trial-finder**: Find clinical trials for a gene, variant, or condition from ClinicalTrials.gov + EUCTR
- **equity-scorer**: Compute HEIM diversity and equity metrics from VCF or ancestry data
- **lit-synthesizer**: Multi-paper literature synthesis with structured evidence extraction
- **omics-target-evidence-mapper**: Aggregate target-level evidence across omics and translational sources
- **pubmed-summariser**: PubMed literature search and structured summarisation

### Infrastructure & Utilities
- **analyze-fasta**: Analyze FASTA files (nucleotide/protein) with Biopython — GC, ORFs, MW, pI, GRAVY
- **archaic-introgression**: Detect Neanderthal and Denisovan introgression segments
- **bgpt-mcp**: BGPT MCP bridge for external tool integration
- **bigquery-public**: Query public bioinformatics BigQuery datasets (GNOMAD, TCGA, GTEx)
- **bio-orchestrator**: Meta-agent that routes bioinformatics requests to specialised sub-skills
- **bioconductor-bridge**: Bioconductor package discovery and workflow recommendation
- **claw-semantic-sim**: Semantic similarity for disease research using PubMedBERT embeddings
- **clawpathy_autoresearch**: Automated pathogenicity research pipeline
- **data-extractor**: Extract numerical data from scientific figure images (26+ plot types)
- **de-summary**: Summarise differential expression results with ranked gene lists and biological themes
- **dnasp**: DnaSP integration for population genetics statistics
- **flow-bio**: Flow cytometry data analysis pipeline
- **galaxy-bridge**: Galaxy tool discovery and execution (8,000+ tools from usegalaxy.org)
- **genome-compare**: Compare genomes to reference (George Church PGP-1) with IBS admixture
- **genome-match**: Score genetic compatibility across pairings in a Genomebook generation
- **illumina-bridge**: Import DRAGEN-exported Illumina result bundles for tertiary analysis
- **labstep**: LabStep protocol integration and execution tracking
- **multiqc-reporter**: MultiQC report generation from analysis outputs
- **ncbi-datasets**: NCBI Datasets API client for genomic data retrieval
- **profile-report**: Comprehensive genomic profile report generation
- **protocols-io**: Protocols.io integration for method sharing
- **recombinator**: Produce offspring genomes via meiotic recombination and mutation
- **repro-enforcer**: Export analyses as reproducible bundles (Conda, Singularity, Nextflow)
- **seq-wrangler**: NGS read QC, alignment, and BAM processing pipeline
- **skill-builder**: Scaffold new ClawBio skills from spec files
- **soul2dna**: Compile character profiles into synthetic diploid genomes
- **target-validation-scorer**: Evidence-grounded target validation with GO/NO-GO decisions
- **turingdb-graph**: TuringDB graph database queries for genomic relationships
- **ukb-navigator**: Semantic search across UK Biobank's 12,000+ data fields
- **wes-clinical-report-en**: WES clinical report generation (English)
- **wes-clinical-report-es**: WES clinical report generation (Spanish)

---

## Built-in Skills (OpenCode Native)

| Skill | Description |
|-------|-------------|
| `review-work` | Multi-agent post-implementation review |
| `frontend-ui-ux` | Everyday UI development |
| `git-master` | Git operations workflow |
| `playwright` | Browser automation |
| `ai-slop-remover` | Code quality improvement |

---

## How Auto-Triggering Works

1. OpenCode's `skill` tool keeps all skill descriptions (~100 words each) in context
2. When you ask a question, the AI matches keywords against skill descriptions
3. Matching skills are loaded, providing domain-specific methodology
4. ClawBio skills with Python implementations are executable via `clawbio.py`:
   ```bash
   source ~/.local/venvs/clawbio/bin/activate
   python <repo>/python/clawbio.py list
   python <repo>/python/clawbio.py run <skill> --demo
   python <repo>/python/clawbio.py run <skill> --input <file> --output <dir>
   ```

## Slash Commands

Available via Ctrl+P / Cmd+P palette:
- `/analyse` — Run a ClawBio bioinformatics analysis
- `/list-skills` — List available ClawBio skills
- `/new-skill` — Build a new ClawBio skill
- `/run-demo` — Run a ClawBio skill demo
- Plus all power-pack commands: `/code-review`, `/security-review`, `/feature-dev`, etc.
