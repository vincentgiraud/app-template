# Project Name

> SaaS web application with Microsoft 365 Copilot agent, hosted on Azure.

## Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Run tests
npm test

# Lint
npm run lint

# Build for production
npm run build

# Deploy to Azure
azd up
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 19 + TypeScript + Vite |
| Backend | Node.js + TypeScript |
| Database | Azure SQL / Cosmos DB |
| Auth | Azure AD B2C |
| Hosting | Azure Container Apps |
| IaC | Bicep |
| Deployment | Azure Developer CLI (azd) |
| M365 Agent | Declarative agent with API plugin |

## Project Structure

```
├── .github/
│   ├── agents/              # Custom Copilot cloud agent definitions
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

1. **Plan**: Use Copilot Chat (Plan mode) or `/ce-brainstorm` + `/ce-plan` for complex features.
2. **Build**: Switch to Agent mode for implementation.
3. **Parallel work**: Assign well-scoped issues to Copilot cloud agent on GitHub.
4. **Review**: All PRs require CI pass + code review.
5. **Deploy**: Merge to main triggers staging deploy → smoke test → production deploy.

## AI-Assisted Development

This repo is configured for GitHub Copilot cloud agent:
- **Custom instructions** in `.github/copilot-instructions.md` define conventions, security rules, and compliance requirements.
- **Custom agents** in `.github/agents/` specialize in frontend, testing, and documentation tasks.
- **Cloud agent** can be assigned issues directly — it creates branches, writes code, and opens PRs.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup, branching strategy, and PR process.

## Documentation

- [Architecture](docs/ARCHITECTURE.md) — system design and key decisions
- [Compliance](docs/COMPLIANCE.md) — GDPR data processing records
- [Security](docs/SECURITY.md) — OWASP checklist and threat model

## License

Proprietary. All rights reserved.
