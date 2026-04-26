---
description: "Use when generating project specs, PRDs, tech architecture, or implementation plans for a new or existing project. Loaded by the spec-planner orchestrator and all its sub-agents."
---

# Spec Planner — Shared Configuration

## Purpose

This pipeline transforms a plain-English project idea into a complete set of implementation specs and a GitHub Project board. The output is:
1. **Convention specs** (`.instructions.md` files) — patterns and rules for how to build, consumed by Copilot as context
2. **Product context** — added to `copilot-instructions.md` so Copilot understands *what* the product is
3. **GitHub Project board + Issues** — the living tracker for features and tasks, with self-contained issue bodies

## Output Files

Convention specs are written to `.github/instructions/` with `applyTo` patterns so Copilot loads them automatically when editing relevant files.

| File | Purpose | `applyTo` |
|------|---------|-----------|
| `copilot-instructions.md` | Product context (identity, personas, scope) — appended to existing | `**` (implicit) |
| `project-tech-architecture.instructions.md` | Tech stack, architecture decisions, directory structure, naming conventions | `src/**,apps/**,packages/**,infra/**` |
| `project-frontend.instructions.md` | UI conventions — component patterns, design system, state management rules | `src/components/**,src/pages/**,src/app/**,apps/web/**` |
| `project-backend.instructions.md` | API conventions — endpoint patterns, database modeling rules, auth flows, error handling | `src/api/**,src/server/**,src/lib/**,apps/api/**,functions/**,packages/shared/**` |

### What is NOT a file

| Concern | Where it lives | Why |
|---------|---------------|-----|
| Feature list / user stories | GitHub Issues (one issue per feature) | Issues are the living tracker — files go stale |
| Task plan / implementation order | GitHub Project board (columns, milestones) | Status changes constantly |
| Project status | Queried live via `gh` CLI when needed | Never committed — ephemeral per session |

## Convention vs Registry Rule

Spec files define **how to build** (patterns, naming, conventions), not **what exists** (specific endpoints, tables, components). The distinction:

| Convention (goes in spec files) | Registry (does NOT go in spec files) |
|---------------------------------|--------------------------------------|
| "Tables must have id, created_at, updated_at" | "Users table has email, name, role columns" |
| "REST endpoints follow /api/v1/{resource}" | "GET /api/v1/users returns user list" |
| "Components use PascalCase in features/ dir" | "UserProfile component takes name, avatar props" |

Specific tables, endpoints, and components are defined in **GitHub Issue bodies** for each feature and exist in **the code itself**.

## Spec Quality Standards

Every spec must meet these criteria:

### Specificity
- No vague requirements like "should be fast" — use measurable criteria: "page load < 2s on 3G"
- No "etc." or "and more" — enumerate all items explicitly
- Name specific libraries, versions, and configuration approaches

### Consistency
- All specs must reference the same tech stack (defined by tech-architect)
- Backend conventions must align with the architecture's framework choices
- Frontend conventions must align with the architecture's UI library and directory structure
- Convention specs must not contradict each other

### Actionability
- A developer (or AI agent) reading the specs + an issue body should be able to implement without asking clarifying questions
- Include file paths, naming conventions, and directory structure
- Include example patterns with concrete code skeletons
- Convention specs should have ONE example per pattern to illustrate usage

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
