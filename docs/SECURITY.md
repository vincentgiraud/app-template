# Security Posture

> This is a living document. Update it whenever security controls change.
> Last reviewed: 2026-04-26

## OWASP Top 10 Checklist

| # | Vulnerability | Status | Controls |
|---|--------------|--------|----------|
| A01 | Broken Access Control | ✅ | Azure AD B2C for auth, RBAC on API, managed identities for service-to-service |
| A02 | Cryptographic Failures | ✅ | TLS 1.2+ enforced, AES-256 at rest, secrets in Key Vault |
| A03 | Injection | ✅ | Parameterized queries only, zod input validation at API boundaries |
| A04 | Insecure Design | ✅ | Threat modeling in design phase, security review in PRs |
| A05 | Security Misconfiguration | ✅ | IaC (Bicep) for reproducible infra, Azure Front Door WAF |
| A06 | Vulnerable Components | ✅ | Dependabot enabled, `npm audit` in CI, minimal dependencies |
| A07 | Auth Failures | ✅ | Azure AD B2C (no custom auth), MFA available, token validation |
| A08 | Software/Data Integrity | ✅ | CI/CD with signed commits, branch protection, no direct pushes |
| A09 | Logging Failures | ✅ | Application Insights, structured logging, no PII in logs |
| A10 | SSRF | ✅ | No user-controlled URLs in server-side requests, Azure Front Door WAF |

## STRIDE Threat Model

| Threat | Mitigation |
|--------|-----------|
| **Spoofing** | Azure AD B2C with MFA, JWT validation on every API request |
| **Tampering** | Signed commits, branch protection, immutable container images |
| **Repudiation** | Audit logs in Application Insights with correlation IDs |
| **Information Disclosure** | Encryption in transit/at rest, no PII in logs, Key Vault for secrets |
| **Denial of Service** | Azure Front Door WAF, rate limiting on API, Container Apps auto-scaling |
| **Elevation of Privilege** | Least-privilege RBAC, managed identities, no shared service accounts |

## Authentication & Authorization

### Customer-Facing
- **Provider**: Azure AD B2C
- **Flows**: Sign-up/sign-in with email+password, social identity providers (Google, Microsoft)
- **MFA**: Available and encouraged
- **Tokens**: JWT with short expiry (1 hour), refresh tokens (14 days)

### Service-to-Service
- **Method**: Managed identities (no secrets exchanged)
- **Scope**: Container Apps → Key Vault, Container Apps → Database, Functions → Database

### Admin/Internal
- **Provider**: Microsoft Entra ID
- **Access**: Conditional Access policies, MFA required

## Dependency Management

- Dependabot enabled for automated security updates.
- `npm audit --audit-level=high` runs in CI — blocks merge on high/critical vulnerabilities.
- Dependencies reviewed before addition — prefer well-maintained, minimal packages.
- Lock file (`package-lock.json`) committed to ensure reproducible installs.

## Secret Management

- All secrets stored in Azure Key Vault.
- Application accesses secrets via managed identity — no connection strings in code.
- `.env` files are gitignored and never committed.
- GitHub repository secrets used only for CI/CD (Azure credentials).
- Secret rotation: automated where possible, manual review quarterly.

## Security Scanning

Three layers — deterministic tools catch known patterns, AI catches logic flaws:

| Layer | Tool | What | When |
|-------|------|------|------|
| **Deterministic SAST** | Semgrep | OWASP Top 10 patterns, secrets, injection | Every PR (CI) |
| **Semantic SAST** | GitHub CodeQL | Data flow analysis, taint tracking | Every PR (CI) |
| **Dependency audit** | npm audit / pip-audit / dotnet list --vulnerable | Known CVEs in dependencies | Every CI run |
| **Dependency updates** | Dependabot | Automated security PRs | Continuous |
| **Secret detection** | GitHub Secret Scanning | Leaked secrets in commits | Continuous |
| **Runtime protection** | Azure Front Door WAF | OWASP rules at edge | Runtime |
| **Adversarial review** | `security-reviewer` agent | Exploit-focused PR review | On request / high-risk PRs |

### Why both Semgrep AND CodeQL AND an AI reviewer?

- **Semgrep**: Fast, deterministic, pattern-based. Catches known OWASP patterns (SQL injection via string concat, XSS via unsafe rendering) with zero false negatives for its ruleset.
- **CodeQL**: Slower, deeper. Traces data flow across functions to find taint propagation that pattern matching misses.
- **security-reviewer agent**: Thinks like an attacker. Catches logic flaws (IDOR, auth bypass, race conditions) that no SAST tool can detect — but is probabilistic, not guaranteed. Never reviews code it wrote in the same session.

## Incident Response

1. **Detect**: Application Insights alerts, Dependabot alerts, user reports.
2. **Contain**: Disable affected endpoint or revoke compromised credentials.
3. **Investigate**: Review logs, identify scope and root cause.
4. **Remediate**: Fix vulnerability, deploy patch, rotate secrets if needed.
5. **Notify**: Per GDPR requirements if personal data affected (see `docs/COMPLIANCE.md`).
6. **Document**: GitHub Issue with `incident` + `security` labels.
7. **Review**: Post-incident review, update controls and this document.

## SOC 2 Control Mapping

| SOC 2 Criteria | Control | Evidence |
|----------------|---------|----------|
| CC6.1 — Logical access | Azure AD B2C + Entra ID, RBAC | Azure AD logs, RBAC assignments |
| CC6.6 — System boundaries | Azure Front Door WAF, NSGs | WAF rules, network config in Bicep |
| CC7.2 — System monitoring | Application Insights, alerts | Dashboard, alert rules |
| CC8.1 — Change management | GitHub PRs, branch protection, CI | PR history, CI logs |
| CC9.1 — Risk mitigation | Threat modeling, security scanning | This document, CodeQL results |

## Review Schedule

- Security posture reviewed quarterly or after any incident.
- Next review date: 2026-07-26
