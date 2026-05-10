# Global Instructions — OpenCode AI

These rules apply to every session across all projects.

## 1. Root-Cause Discipline
No quick fixes. Always diagnose to the root cause and devise proper solutions. Never apply patches or workarounds unless the user explicitly asks.

## 2. Security & Secrets
- Never hardcode secrets or commit them to git
- Use separate API tokens/credentials for dev, staging, and prod
- Validate all input server-side — never trust client data
- Add rate limiting on auth and write operations

## 3. Architecture & Code Quality
- Design architecture before building
- Break up large view controllers/components early
- Wrap external API calls in a clean service layer
- Version database schema changes through proper migrations
- Use real feature flags, not commented-out code

## 4. Observability
- Add crash reporting from day one
- Implement persistent logging (not just console output)
- Include a `/health` endpoint for every service

## 5. Environments & Deployment
- Maintain a real staging environment that mirrors production
- Set CORS to specific origins, never `*`
- Set up CI/CD early — deploys come from the pipeline, not a laptop

## 6. Testing & Resilience
- Test unhappy paths: network failures, unexpected API responses, malformed data
- Don't assume the happy path is sufficient

## 7. Time Handling
- Store all timestamps in UTC. Convert to local time only on display.

## 8. Workflow Orchestration

### Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately

### Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- One task per subagent for focused execution

### Self-Improvement Loop
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Review lessons at session start

### Verification Before Done
- Never mark a task complete without proving it works
- Run tests, check logs, demonstrate correctness

### Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests — then resolve them

## 9. Task Management
1. **Plan First**: Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`

## 10. Core Principles
- **Simplicity First**: Make every change as simple as possible
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary
