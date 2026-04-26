# Copilot Custom Instructions

These instructions apply to GitHub Copilot in VS Code (agent mode, ask mode, chat) and Copilot cloud agent (issue-assigned tasks).

## Project Overview

This is a SaaS web application with a companion Microsoft 365 declarative agent, hosted on Azure. The product is built and maintained by a solo founder using AI-assisted development, with plans to onboard contributors.

## Tech Stack

- **Frontend**: React 19 + TypeScript + Vite
- **Backend**: Node.js + TypeScript (Express or Hono)
- **Database**: Azure SQL or Cosmos DB (confirm per project)
- **Auth**: Azure AD B2C (customer-facing), Entra ID (admin/internal)
- **Hosting**: Azure Container Apps (web app), Azure Functions (event-driven tasks)
- **IaC**: Bicep (preferred) or Terraform
- **Deployment**: Azure Developer CLI (`azd`) via GitHub Actions
- **M365 Agent**: Declarative agent with API plugin, built with M365 Agents Toolkit

## Code Conventions

- Use TypeScript strict mode everywhere. No `any` types unless absolutely necessary.
- Prefer named exports over default exports.
- Use `async`/`await` over `.then()` chains.
- Error handling: throw typed errors, catch at boundaries. No silent swallows.
- File naming: `kebab-case.ts` for files, `PascalCase` for components.
- Tests: colocate test files as `*.test.ts` next to source files.
- Prefer small, focused functions. Each function should do one thing.

## Security Requirements (OWASP)

- **Input validation**: Validate and sanitize all user input at API boundaries. Use zod or similar schema validation.
- **Authentication**: Never store secrets in code or environment variables in the repo. Use Azure Key Vault.
- **SQL injection**: Use parameterized queries only. No string concatenation in queries.
- **XSS**: Escape all user-generated content rendered in HTML. React handles this by default — never use `dangerouslySetInnerHTML`.
- **CSRF**: Use anti-CSRF tokens for state-changing requests.
- **Rate limiting**: Apply rate limiting to all public API endpoints.
- **Dependencies**: Keep dependencies minimal. Audit with `npm audit` before adding new packages.
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

- Write unit tests for business logic. Use Vitest.
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
- Run `npm test` and `npm run lint` before pushing. Fix any failures.
- If tests don't exist for the area you're changing, add them.
- If you're unsure about a design decision, leave a comment on the PR asking for guidance rather than guessing.
