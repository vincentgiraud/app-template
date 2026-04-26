# GDPR & Data Privacy Compliance

> This is a living document. Update it whenever data collection or processing changes.
> Last reviewed: 2026-04-26

## Data Controller

- **Entity**: [Your company name]
- **Contact**: [DPO or privacy contact email]
- **EU Representative** (if applicable): [Name and contact]

## Legal Basis for Processing

| Data Category | Legal Basis | Purpose | Retention |
|---------------|-------------|---------|-----------|
| Email address | Consent (sign-up) | Account authentication, notifications | Account lifetime + 30 days |
| Display name | Consent (sign-up) | Personalization | Account lifetime + 30 days |
| Usage analytics | Legitimate interest | Product improvement | 90 days (anonymized) |
| Payment info | Contract performance | Billing | As required by tax law |
| IP address | Legitimate interest | Security, rate limiting | 7 days (logs) |

## Data Processing Records

### Processors

| Processor | Purpose | Data Shared | DPA in Place |
|-----------|---------|-------------|-------------|
| Microsoft Azure | Hosting, compute, storage | All application data | Yes (Microsoft DPA) |
| Azure AD B2C | Authentication | Email, name | Yes (Microsoft DPA) |
| Application Insights | Monitoring | Anonymized telemetry | Yes (Microsoft DPA) |

### Sub-processors

Track any additional sub-processors here as they are added.

## Data Subject Rights Implementation

| Right | Implementation | Endpoint/Process |
|-------|---------------|-----------------|
| Right to access | Export all user data as JSON | `GET /api/v1/me/data-export` |
| Right to erasure | Delete user account and all associated data | `DELETE /api/v1/me` |
| Right to rectification | User can edit profile data | `PATCH /api/v1/me` |
| Right to data portability | Export in machine-readable format | `GET /api/v1/me/data-export` |
| Right to restrict processing | Deactivate account (retain data, stop processing) | `POST /api/v1/me/deactivate` |

## Technical Measures

### Data Minimization
- Only collect data strictly necessary for the feature being built.
- Review new data collection in PR reviews — any new PII field must be documented here.

### Encryption
- Data in transit: TLS 1.2+ enforced (Azure Front Door)
- Data at rest: Azure-managed encryption (AES-256)
- Secrets: Azure Key Vault with RBAC access control

### Logging
- Application logs NEVER contain PII (email, name, IP, tokens).
- Use correlation IDs for request tracing instead of user identifiers.
- Log retention: 30 days in Application Insights.

### Data Deletion
- Account deletion triggers cascading delete of all user data.
- Deletion is verified by automated tests.
- Backup retention does not exceed 30 days.

## Consent Management

- Cookie consent banner with granular opt-in for analytics.
- Marketing communications require explicit opt-in (double opt-in for email).
- Consent records stored with timestamp and version of privacy policy accepted.

## Incident Response

1. Identify and contain the breach.
2. Assess scope: what data, how many subjects affected.
3. Notify supervisory authority within 72 hours if risk to rights and freedoms.
4. Notify affected data subjects without undue delay if high risk.
5. Document in GitHub Issues with `incident` + `privacy` labels.
6. Post-incident review and update controls.

## Review Schedule

- This document is reviewed quarterly or whenever data processing changes.
- Next review date: 2026-07-26
