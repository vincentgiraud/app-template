# Project Name

> SaaS web application with Microsoft 365 Copilot agent, hosted on Azure.

## Who This Is For

- **Solo founders / indie hackers** shipping SaaS on Azure with AI-assisted development
- **Microsoft ISV partners** building apps for the Microsoft marketplace (web + M365 agents)
- **Small teams** wanting a ready-made repo template with CI/CD, compliance (GDPR, SOC 2), and security (OWASP) baked in
- **Copilot Enterprise / Pro+ users** who want to assign issues to the cloud agent and parallelize work

Not for you if: you're on Claude Code / Cursor / Windsurf (see alternatives below), you don't use Azure, or you need a framework-specific starter (this is stack-agnostic).

## Why Use This Template

### What you get vs doing it manually

| Task | Without this template | With this template |
|------|----------------------|-------------------|
| Write PRD + architecture | 1–3 days | 30 min (review `@Spec Planner` output) |
| Research Azure stack + pricing | 1–2 days | 20 min (review `@Azure SaaS Planner` output) |
| Set up CI/CD with security scanning | 4–8 hours | Already done |
| Write GDPR/SOC 2 compliance docs | 1–2 days | Already done (fill in company details) |
| Write tests for a feature | 2–3 hours | Assign issue to cloud agent |
| Security review a PR | 1–2 hours | Semgrep + CodeQL (deterministic) + security-reviewer agent |
| Update docs after shipping | 1 hour (usually skipped) | Assign issue to cloud agent |

### Cost: AI tokens vs human hours

The template uses ~2–4x more Copilot premium requests than plain vibe coding. Here's what that replaces:

| Role replaced | Day rate (contractor) | AI cost/day | Saving |
|---------------|----------------------|-------------|--------|
| Product Manager (spec writing) | $800–1,200 | ~$5 in premium requests | 99% |
| Solutions Architect (Azure stack) | $1,000–1,500 | ~$5 in premium requests | 99% |
| QA Engineer (test writing) | $500–800 | ~$2 in premium requests | 99% |
| Security Consultant (OWASP review) | $1,200–2,000 | $0 (Semgrep/CodeQL free) + ~$3 for AI review | 99% |
| Technical Writer (docs) | $400–600 | ~$1 in premium requests | 99% |
| **Total daily equivalent** | **$3,900–6,100** | **~$16** | |

> These are not full-time replacements — they're per-task equivalents. The AI handles the 80% that's routine; you handle the 20% that requires judgment. Day rates are US contractor averages (2026). Token costs assume Copilot Enterprise where premium requests are included in your plan. Actual costs vary by project complexity and model usage.

### What you still need to do yourself

- **Product vision**: The Spec Planner interviews you — it can't dream up the product.
- **Design decisions**: Review and approve what agents generate. Don't ship blindly.
- **Complex architecture**: The agents suggest, you decide. Especially for auth flows and data models.
- **Customer conversations**: No AI replaces talking to users.

## Platform

This template is **opinionated and built for the GitHub + Azure stack**:

- **AI coding**: GitHub Copilot (VS Code agent mode + cloud agent)
- **Work tracking**: GitHub Issues + GitHub Projects
- **CI/CD**: GitHub Actions
- **Hosting**: Azure (Container Apps, Functions, AD B2C, Key Vault)
- **M365**: Declarative agents via M365 Agents Toolkit

The `.agent.md` and `.instructions.md` files use [GitHub Copilot's agent/instruction format](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions). The cloud agent setup (`copilot-setup-steps.yml`) is GitHub-specific. The CI/CD workflows are GitHub Actions.

**This will not work with** Claude Code CLI, Cursor, Windsurf, or other AI coding tools — those use different file formats (CLAUDE.md, .cursorrules, etc.). If you use those tools, look at [gstack](https://github.com/garrytan/gstack), [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin), or [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) instead.

## Quick Start

### Option A: Start from an idea (Spec Planner)

Open Copilot Chat in Agent mode and describe your project:

```
@Spec Planner I want to build a multi-tenant invoice management SaaS for
small businesses in Europe. Users create, send, and track invoices with
automated VAT calculations. Needs Stripe payments, PDF generation, and
a client portal. Deploy to Azure, budget ~$150/mo.
```

The Spec Planner interviews you, then generates implementation-ready specs (PRD, architecture, frontend/backend design, task plan) as `.instructions.md` files that Copilot loads automatically. If it detects Azure/compliance signals, it chains into the Stack Planner for infrastructure research.

### Option B: Start building directly

```bash
npm install        # Install dependencies
npm run dev        # Start development server
npm test           # Run tests
npm run lint       # Lint
npm run build      # Build for production
azd up             # Deploy to Azure
```

### Option C: Find your Azure stack independently

```
/find-cost-optimized-stack Industry: FinTech, Region: Europe, Budget: $500, Users: 10K
```

## What's Included

### 19 AI Agents (2 Pipelines + 3 Cloud Agents)

**Pipeline 1: Spec Planner** — Generates a complete project spec from a plain-English idea.

| Agent | Role |
|-------|------|
| `spec-planner` | Orchestrator — interviews user, coordinates 5 specialists |
| `prd-writer` | User stories, features, acceptance criteria |
| `tech-architect` | Stack selection, architecture, directory structure |
| `frontend-designer` | Component hierarchy, page layouts, design system |
| `backend-designer` | API endpoints, database schema, auth flows |
| `task-planner` | Phased implementation plan with dependencies |

**Pipeline 2: Stack Planner** — Researches a compliance-ready Azure stack.

| Agent | Role |
|-------|------|
| `az-saas-planner` | Orchestrator — coordinates 9 specialists |
| `compliance-mapper` | Maps frameworks (GDPR, SOC2, HIPAA, PCI-DSS, etc.) |
| `workload-profiler` | Sizes compute, storage, bandwidth |
| `compute-advisor` | Compares App Service / Container Apps / Functions / AKS |
| `data-advisor` | Compares SQL / PostgreSQL / Cosmos DB / storage |
| `security-advisor` | Entra ID, Key Vault, RBAC, Defender |
| `observability-advisor` | App Insights, Log Analytics, alerts |
| `networking-advisor` | VNet, Front Door, WAF, CDN, private endpoints |
| `cost-validator` | Cross-validates pricing, finds free-tier overlap |
| `growth-advisor` | 10x/100x projections, scaling cliffs |

**Cloud Agents** — Specialized agents for Copilot cloud agent (issue → PR).

| Agent | Role |
|-------|------|
| `frontend-dev` | React/TypeScript feature implementation |
| `test-writer` | Test coverage and quality |
| `docs-updater` | Documentation sync with code changes |
| `security-reviewer` | Adversarial security review — thinks like an attacker |

### CI/CD Pipelines

| Workflow | Steps |
|----------|-------|
| `ci.yml` | Lint → Type check → Test (coverage) → CodeQL security scan → Build |
| `deploy.yml` | Staging deploy → Smoke test → Production deploy (via `azd`) |

### Compliance & Security Documentation

| Document | Contents |
|----------|----------|
| [Architecture](docs/ARCHITECTURE.md) | System design, Mermaid diagram, key decisions |
| [Compliance](docs/COMPLIANCE.md) | GDPR data processing records, data subject rights |
| [Security](docs/SECURITY.md) | OWASP Top 10 checklist, STRIDE model, SOC2 mapping |

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 19 + TypeScript + Vite |
| Backend | Node.js + TypeScript, Python + FastAPI, .NET, or other (per project) |
| Database | Azure SQL / Cosmos DB |
| Auth | Azure AD B2C |
| Hosting | Azure Container Apps |
| IaC | Bicep |
| Deployment | Azure Developer CLI (azd) |
| M365 Agent | Declarative agent with API plugin |

## Project Structure

```
├── .github/
│   ├── agents/              # 19 AI agents (spec planner + stack planner + cloud agents)
│   ├── instructions/        # Shared config for agent pipelines
│   ├── prompts/             # Slash-command prompt templates
│   ├── ISSUE_TEMPLATE/      # Structured issue templates
│   ├── workflows/           # CI/CD pipelines
│   ├── copilot-instructions.md   # Copilot custom instructions
│   └── copilot-setup-steps.yml   # Cloud agent environment setup
├── docs/
│   ├── ARCHITECTURE.md      # System design decisions
│   ├── COMPLIANCE.md        # GDPR data processing records
│   └── SECURITY.md          # OWASP checklist, threat model
├── infra/                   # Bicep / Terraform IaC files
├── src/                     # Application source code
└── tests/                   # Integration and E2E tests
```

## Development Workflow

Every feature follows the same loop. Each phase has tools ready — you pick where to start.

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   1. IDEATE ──→ 2. SPEC ──→ 3. STACK ──→ 4. BUILD         │
│      (you)      (6 agents)   (10 agents)  (you + cloud     │
│                                             agents)         │
│                                               │             │
│   7. REFLECT ←── 6. DEPLOY ←── 5. REVIEW ←───┘             │
│   (compliance    (azd +        (CI + Semgrep +              │
│    docs)          GitHub        CodeQL +                    │
│                   Actions)      security-reviewer)          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

| Phase | What happens | You do | Agents/tools do |
|-------|-------------|--------|-----------------|
| **1. Ideate** | Describe what you want to build | Write a plain-English description | — |
| **2. Spec** | Generate implementation-ready specs | Answer clarifying questions | `@Spec Planner` → PRD, architecture, frontend/backend design, task plan (6 agents) |
| **3. Stack** | Research Azure infrastructure | Confirm parameters | `@Azure SaaS Planner` → compliance mapping, service comparison, cost estimate (10 agents, auto-chained) |
| **4. Build** | Write code, implement features | Work on complex features in Agent mode | Cloud agent handles parallel issues (frontend-dev, test-writer, docs-updater) |
| **5. Review** | Verify quality and security | Review PRs, approve/reject | CI: lint → test → CodeQL → Semgrep → build. `security-reviewer` agent for high-risk PRs |
| **6. Deploy** | Ship to Azure | Merge to main (or manual trigger) | GitHub Actions: staging → smoke test → production via `azd` |
| **7. Reflect** | Update compliance and security posture | Review docs quarterly | docs-updater agent keeps ARCHITECTURE.md, COMPLIANCE.md, SECURITY.md current |

**Where to start:**
- **New project, no idea yet?** Start at Phase 1 — describe your idea to `@Spec Planner`.
- **Know what to build?** Start at Phase 4 — create issues, assign to cloud agent.
- **Existing project, need Azure infra?** Start at Phase 3 — run `/find-cost-optimized-stack`.
- **Code ready, need to ship?** Start at Phase 6 — run `azd up`.

## AI-Assisted Development

This repo is configured for GitHub Copilot at every level:

- **Spec generation**: 6 agents turn ideas into implementation-ready `.instructions.md` files.
- **Azure stack research**: 10 agents find the cheapest compliant Azure stack for your SaaS.
- **Custom instructions** in `.github/copilot-instructions.md` enforce conventions, security, and GDPR rules.
- **Cloud agents** in `.github/agents/` handle frontend, testing, and docs tasks autonomously.
- **Slash commands**: `/find-cost-optimized-stack` for one-click Azure stack research.

## Customize After Cloning

After creating a repo from this template, update these files:

| File | What to change |
|------|---------------|
| `.github/ISSUE_TEMPLATE/config.yml` | Replace `OWNER/REPO` with your actual GitHub path |
| `docs/COMPLIANCE.md` | Fill in `[Your company name]`, `[DPO or privacy contact email]`, and review dates |
| `docs/SECURITY.md` | Review OWASP checklist status and update review dates |
| `.github/copilot-instructions.md` | Adjust conventions to your preferences (or let `@Spec Planner` generate `project-tech-architecture.instructions.md` which overrides these) |
| `package.json` | Replace `app-template` name, or delete entirely if using Python-only |
| `README.md` | Replace this file with your project's actual README |

**What you don't need to touch** (auto-configured):
- CI/CD workflows auto-detect your stack (Node.js, Python, or both)
- Cloud agent setup installs both Node.js and Python — remove whichever you don't need
- Spec Planner and Stack Planner agents work out of the box
- Issue templates are ready to use immediately

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup, branching strategy, and PR process.

## License

MIT
