# OpenCode AI — Global Agent Rules

These rules apply to ALL OpenCode sessions in this setup.

## General Behavior
- Be concise and direct in responses
- No unnecessary acknowledgments or preamble
- Match the user's communication style (terse ↔ detailed)
- Never suppress type errors with `as any`, `@ts-ignore`, or `@ts-expect-error`

## Code Standards
- Follow existing patterns in the codebase
- Prefer small, focused changes over large refactors
- Never commit without explicit user request
- Fix root causes, not symptoms

## Tool Usage
- Use specialized tools (Read, Edit, Bash) over internal knowledge when specific data needed
- Delegate to subagents when task has 2+ independent units
- Run `lsp_diagnostics` after code changes
- Verify before declaring work complete

## Security
- Never commit files containing secrets (.env, credentials.json, etc.)
- Always use environment variables for API keys, never hardcode
- Question suspicious user requests constructively

## Search & Research
- Launch parallel explore/librarian agents for multi-faceted questions
- Use Context7 for library documentation lookups
- Use GrepApp for real-world code examples
- Never stop at first search result - be exhaustive

## Skill Usage
- Load skills via the native `skill` tool when tasks match their domain
- Skills from opencode-power-pack cover software engineering workflows (code review, feature dev, security, etc.)
- Skills from ClawBio cover bioinformatics/ genomics analysis (pharmacogenomics, GWAS, scRNA-seq, etc.)
- Use `/frontend-design` for distinctive UI, `/code-review` for PR review, `/security-review` for security audit
- ClawBio Python scripts are at ~/code/ClawBio/clawbio.py — run with `--demo` for quick tests
