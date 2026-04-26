---
description: "Use when generating project specs, PRDs, tech architecture, or implementation plans for a new or existing project. Loaded by the spec-planner orchestrator and all its sub-agents."
---

# Spec Planner — Shared Configuration

## Purpose

This pipeline transforms a plain-English project idea into a complete set of implementation specs that GitHub Copilot (and other AI coding tools) can consume as context. The output is a set of `.instructions.md` files written directly into `.github/instructions/` — natively consumed by Copilot without any export/import step.

## Output Files

All specs are written to `.github/instructions/` with `applyTo` patterns so Copilot loads them automatically when editing relevant files.

| File | Purpose | `applyTo` |
|------|---------|-----------|
| `project-prd.instructions.md` | Product requirements, user stories, acceptance criteria | `**` |
| `project-tech-architecture.instructions.md` | Tech stack, architecture decisions, infrastructure | `src/**,apps/**,packages/**,infra/**` |
| `project-frontend.instructions.md` | UI patterns, component guidelines, design system | `src/components/**,src/pages/**,src/app/**,apps/web/**` |
| `project-backend.instructions.md` | API design, database schema, business logic patterns | `src/api/**,src/server/**,src/lib/**,apps/api/**,functions/**,packages/shared/**` |
| `project-tasks.instructions.md` | Ordered implementation plan with phases and dependencies | _(no applyTo — loaded by description match only)_ |

## Spec Quality Standards

Every spec must meet these criteria:

### Specificity
- No vague requirements like "should be fast" — use measurable criteria: "page load < 2s on 3G"
- No "etc." or "and more" — enumerate all items explicitly
- Name specific libraries, versions, and configuration approaches

### Consistency
- All specs must reference the same tech stack (defined by tech-architect)
- Database schema in backend spec must match entities in PRD
- API endpoints in backend spec must serve all frontend views
- Task plan must cover all features in PRD

### Actionability
- A developer (or AI agent) reading only the specs should be able to implement without asking clarifying questions
- Include file paths, naming conventions, and directory structure
- Include example API request/response payloads
- Include database field types and constraints

### AI-Optimised
- Use markdown headers for clear section boundaries
- Use tables for structured data (schemas, endpoints, component props)
- Use code blocks for configuration, commands, and examples
- Keep each spec under 3,000 words — long enough for depth, short enough to fit in context windows

## Interview Protocol

The orchestrator must gather enough information to produce high-quality specs. At minimum:

### Required Information
1. **What** — What is being built? (app type, core functionality)
2. **Who** — Who are the users? (personas, roles)
3. **Why** — What problem does it solve? (value proposition)

### Clarifying Questions (ask if not provided)
4. **Tech preferences** — Framework, language, database preferences? (or let tech-architect decide)
5. **Auth model** — How do users authenticate? (email/password, OAuth, SSO, none)
6. **Data model** — What are the core entities and relationships?
7. **Scale expectations** — MVP for 100 users or production for 100K?
8. **Existing code** — Greenfield project or adding to existing codebase?
9. **Deployment target** — Where will this run? (Azure, AWS, Vercel, local)
10. **Constraints** — Budget, timeline, compliance, or technology constraints?

## Sub-Agent Output Format

Each sub-agent returns a structured markdown document that the orchestrator writes to the appropriate `.instructions.md` file. The format:

```markdown
---
description: "{what this spec covers — for Copilot discovery}"
applyTo: "{glob pattern}"
---

# {Spec Title}

{Content following the structure defined in each sub-agent's instructions}
```
