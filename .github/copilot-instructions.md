# Copilot Custom Instructions

These instructions apply to GitHub Copilot in VS Code (agent mode, ask mode, chat) and Copilot cloud agent (issue-assigned tasks).

## Project Overview

This is a SaaS web application with a companion Microsoft 365 declarative agent, hosted on Azure. The product is built and maintained by a solo founder using AI-assisted development, with plans to onboard contributors.

## Tech Stack

The tech stack is determined when you run `@Spec Planner`. Common combinations:

- **Frontend**: React 19 + TypeScript + Vite
- **Backend**: Node.js + TypeScript, Python + FastAPI, .NET, or other (chosen per project)
- **Database**: Azure SQL or Cosmos DB (confirm per project)
- **Auth**: Azure AD B2C (customer-facing), Entra ID (admin/internal)
- **Hosting**: Azure Container Apps (web app), Azure Functions (event-driven tasks)
- **IaC**: Bicep (preferred) or Terraform
- **Deployment**: Azure Developer CLI (`azd`) via GitHub Actions
- **M365 Agent**: Declarative agent with API plugin, built with M365 Agents Toolkit

Once the Spec Planner generates `project-tech-architecture.instructions.md`, that file becomes the source of truth for the stack.

## Code Conventions

- Use strict typing everywhere. TypeScript strict mode for TS projects; type hints + mypy for Python; etc.
- Error handling: throw/raise typed errors, catch at boundaries. No silent swallows.
- File naming: `kebab-case` for files, `PascalCase` for components/classes.
- Tests: colocate test files next to source files when the framework supports it.
- Prefer small, focused functions. Each function should do one thing.
- Prefer named exports over default exports (JS/TS projects).
- Use `async`/`await` over callback chains.

## Security Requirements (OWASP)

- **Input validation**: Validate and sanitize all user input at API boundaries. Use zod (TS), pydantic (Python), or equivalent schema validation.
- **Authentication**: Never store secrets in code or environment variables in the repo. Use Azure Key Vault.
- **SQL injection**: Use parameterized queries or ORM only. No string concatenation in queries.
- **XSS**: Escape all user-generated content rendered in HTML. React handles this by default — never use `dangerouslySetInnerHTML`.
- **CSRF**: Use anti-CSRF tokens for state-changing requests.
- **Rate limiting**: Apply rate limiting to all public API endpoints.
- **Dependencies**: Keep dependencies minimal. Audit before adding new packages (`npm audit`, `pip audit`, `safety check`, etc.).
- **Secrets**: Never log secrets, tokens, passwords, or PII. Never commit `.env` files.

## GDPR / Data Privacy

- **PII handling**: Personal data (email, name, phone, IP address) must only be collected with explicit consent and a documented purpose.
- **Data minimization**: Only collect data that is strictly necessary for the feature.
- **Logging**: Never log PII in application logs. Mask or redact if needed for debugging.
- **Retention**: All stored personal data must have a defined retention period. Implement automatic deletion.
- **Right to erasure**: Design data models so a user's data can be fully deleted on request.
- **Data processing records**: Document any new data collection in `docs/COMPLIANCE.md`.

## SOC 2 Considerations

- **Access control**: Use least-privilege principle. Managed identities for Azure service-to-service auth.
- **Change management**: All changes go through PRs with CI checks. No direct pushes to main.
- **Monitoring**: All production services must emit logs to Application Insights.
- **Incident response**: Document incidents in GitHub Issues with the `incident` label.

## Testing

- Write unit tests for business logic. Use the project's test framework (Vitest for TS, pytest for Python, etc.).
- Write integration tests for API endpoints.
- Minimum test coverage goal: 80% for new code.
- Tests must pass before merge (enforced by CI).

## PR and Commit Conventions

- Commit messages: `type(scope): description` (conventional commits)
  - Types: `feat`, `fix`, `docs`, `test`, `refactor`, `ci`, `chore`
- PR descriptions: explain **what** changed and **why**. Link the issue.
- One logical change per PR. Keep PRs small and reviewable.

## Cloud Agent Specific

When working as a cloud agent on assigned issues:
- Read the full issue description and acceptance criteria before starting.
- Create a plan as the first commit message or PR description.
- Run the project's test and lint commands before pushing. Fix any failures.
- If tests don't exist for the area you're changing, add them.
- If you're unsure about a design decision, leave a comment on the PR asking for guidance rather than guessing.
