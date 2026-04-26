# Project Name

> SaaS web application with Microsoft 365 Copilot agent, hosted on Azure.

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
| Backend | Node.js + TypeScript, Python + FastAPI, or other (per project) |
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

```
Idea → Spec Planner → Stack Planner → Build → Review → Deploy
         (agents)       (agents)      (code)   (CI)    (azd)
```

1. **Spec**: Describe your idea → `@Spec Planner` generates PRD, architecture, task plan.
2. **Stack**: Auto-chains into `@Azure SaaS Planner` for compliance-ready infra.
3. **Plan**: Use Copilot Chat (Plan mode) or `/ce-brainstorm` + `/ce-plan` for features.
4. **Build**: Switch to Agent mode. Follow the generated task plan.
5. **Parallel work**: Assign well-scoped issues to Copilot cloud agent on GitHub.
6. **Review**: All PRs require CI pass + code review.
7. **Deploy**: Merge to main → staging → smoke test → production.

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
