---
description: "Use when researching Azure compliance-ready SaaS stacks, comparing Azure service pricing, mapping compliance frameworks to Azure services, or sizing Azure infrastructure for startups. Loaded by all stack-finder agents."
---

# Compliance-Ready Azure Stack — Shared Configuration

## Configuration Schema

Every stack search begins with these parameters. Parse them from the user's input or prompt template. Use defaults when not specified.

| Parameter | Type | Required | Default | Valid Values |
|-----------|------|----------|---------|-------------|
| `industry` | string | **yes** | — | Healthcare, FinTech, EdTech, E-commerce, LegalTech, GovTech, InsurTech, PropTech, HRTech, RegTech, BioTech, MediaTech, TravelTech, CyberSecurity, General SaaS |
| `primary_region` | string | **yes** | — | Any Azure region code (e.g., westeurope, eastus) **or** a geographic name (e.g., Europe, US, UK). See **Geo-to-Region Mapping** below. |
| `target_markets` | string[] | no | ["EU"] | EU, US, APAC, Global, or specific countries |
| `compliance_frameworks` | string[] | no | ["auto"] | auto, GDPR, HIPAA, SOC2, PCI-DSS, ISO27001, FedRAMP, FERPA, CCPA, DORA, NIS2 |
| `workload_type` | string | no | "API-heavy" | API-heavy, data-intensive, event-driven, real-time, hybrid |
| `expected_users_y1` | string | no | "1K" | 100, 1K, 10K, 100K, 1M |
| `data_volume` | string | no | "1-10GB" | <1GB, 1-10GB, 10-100GB, 100GB-1TB, 1TB+ |
| `team_size` | string | no | "1-3" | 1-3, 4-10, 10+ |
| `monthly_budget_cap` | string | no | "$200" | $0, $50, $100, $200, $500, $1000, uncapped |
| `required_services` | string[] | no | ["auth"] | auth, payments, email, file-storage, search, queues, caching, CDN, analytics |
| `tech_stack` | string | no | "any" | Node.js, Python, .NET, Java, Go, Rust, any |
| `startup_stage` | string | no | "MVP" | idea, MVP, production, scaling |
| `multi_tenancy` | string | no | "shared" | shared, schema-per-tenant, db-per-tenant, silo |
| `sla_target` | string | no | "99.9%" | best-effort, 99.9%, 99.95%, 99.99% |
| `data_sensitivity` | string[] | no | ["PII"] | public, PII, PHI, financial, cardholder |
| `dr_region` | string | no | "auto" | auto (paired region), or any Azure region |
| `customer_sectors` | string[] | no | ["general"] | general, financial, healthcare, government, education, mixed |
| `annual_revenue` | string | no | "pre-revenue" | pre-revenue, <$1M, $1-25M, $25M+ |
| `company_size` | string | no | "<50" | <50, 50-249, 250+ |

## Compliance Framework × Industry Matrix

When `compliance_frameworks` is `auto`, derive from industry + target markets:

| Industry | EU | US | APAC | Global |
|----------|----|----|------|--------|
| Healthcare | GDPR, NIS2† | HIPAA, SOC2 | ISO27001 | GDPR, HIPAA, ISO27001, SOC2, NIS2† |
| FinTech | GDPR, PCI-DSS†, DORA† | SOC2, PCI-DSS† | ISO27001, PCI-DSS† | GDPR, SOC2, PCI-DSS†, DORA† |
| EdTech | GDPR | FERPA†, SOC2 | ISO27001 | GDPR, SOC2, FERPA† |
| E-commerce | GDPR, PCI-DSS† | SOC2, PCI-DSS†, CCPA† | ISO27001 | GDPR, SOC2, PCI-DSS†, CCPA† |
| LegalTech | GDPR, ISO27001 | SOC2 | ISO27001 | GDPR, SOC2, ISO27001 |
| GovTech | GDPR, ISO27001, NIS2† | FedRAMP†, SOC2 | ISO27001 | ISO27001, SOC2, FedRAMP† |
| InsurTech | GDPR, DORA† | SOC2 | ISO27001 | GDPR, SOC2, DORA† |
| PropTech | GDPR | SOC2 | ISO27001 | GDPR, SOC2 |
| HRTech | GDPR | SOC2, CCPA† | ISO27001 | GDPR, SOC2, CCPA† |
| General SaaS | GDPR | SOC2, CCPA† | ISO27001 | GDPR, SOC2, CCPA† |
| RegTech | GDPR, SOC2, DORA†, ISO27001, NIS2† | SOC2, CCPA† | ISO27001, SOC2 | GDPR, SOC2, DORA†, ISO27001, CCPA†, NIS2† |
| BioTech | GDPR, ISO27001 | HIPAA†, SOC2 | ISO27001 | GDPR, HIPAA†, ISO27001, SOC2 |
| MediaTech | GDPR | SOC2, CCPA† | ISO27001 | GDPR, SOC2, CCPA† |
| TravelTech | GDPR, PCI-DSS† | SOC2, PCI-DSS†, CCPA† | ISO27001, PCI-DSS† | GDPR, SOC2, PCI-DSS†, CCPA† |
| CyberSecurity | GDPR, ISO27001, SOC2, NIS2† | SOC2, ISO27001 | ISO27001, SOC2 | GDPR, SOC2, ISO27001, NIS2† |

> **†** = Conditional framework. Applicability depends on company size, revenue, customer sectors, or data types. See **Framework Applicability Conditions** below. Frameworks without † always apply when the industry × market combination matches.

## Compliance Framework → Azure Requirements

| Framework | Encryption at Rest | Encryption in Transit | Audit Logging | Data Residency | Access Control | Network Isolation | Backup/DR |
|-----------|-------------------|----------------------|---------------|----------------|----------------|-------------------|-----------|
| GDPR | Required | Required (TLS 1.2+) | Required | Strict (EU regions) | RBAC + MFA | Recommended | Required |
| HIPAA | Required (AES-256) | Required (TLS 1.2+) | Required (365d retention) | US regions | RBAC + MFA + Conditional Access | Required (VNet) | Required (geo-redundant) |
| SOC2 | Required | Required | Required (90d min) | Flexible | RBAC + MFA | Recommended | Required |
| PCI-DSS | Required (AES-256) | Required (TLS 1.2+) | Required (365d retention) | Flexible | RBAC + MFA + WAF | Required (VNet + WAF) | Required |
| ISO27001 | Required | Required | Required | Flexible | RBAC + MFA | Recommended | Required |
| FedRAMP | Required (FIPS 140-2) | Required (TLS 1.2+) | Required (365d) | US Gov regions | RBAC + MFA + PIV | Required | Required (geo-redundant) |
| DORA | Required | Required (TLS 1.2+) | Required (5yr retention) | EU regions | RBAC + MFA | Required | Required (tested regularly) |
| FERPA | Required | Required (TLS 1.2+) | Required (90d min) | US regions | RBAC + MFA + role-based data access | Recommended | Required |
| CCPA | Required | Required (TLS 1.2+) | Required (24mo retention) | Flexible (data deletion capability required) | RBAC + MFA + consent management | Recommended | Required |
| NIS2 | Required | Required (TLS 1.2+) | Required (incident reporting within 24h) | EU regions | RBAC + MFA + supply chain controls | Required (network segmentation) | Required (business continuity plan) |

## Framework Applicability Conditions

Frameworks marked with **†** in the Industry Matrix are **conditional** — they only apply when specific thresholds are met. The orchestrator MUST evaluate these conditions during auto-resolution (Step 0) using the discriminator parameters (`customer_sectors`, `annual_revenue`, `company_size`, `data_sensitivity`).

### Condition Reference

| Framework | Condition | Discriminator Param | Applies When | Does NOT Apply When |
|-----------|-----------|--------------------|--------------|--------------------------|
| **CCPA** | Revenue or consumer volume | `annual_revenue`, `target_markets` | Revenue ≥$25M **OR** processing data of 100K+ California consumers **OR** 50%+ revenue from selling personal data. Applies only when `target_markets` includes US or Global. | Revenue <$25M **AND** <100K CA consumers **AND** not selling data |
| **HIPAA** | Handling PHI for covered entities | `customer_sectors`, `data_sensitivity` | SaaS handles PHI (`data_sensitivity` includes `PHI`) **AND/OR** `customer_sectors` includes `healthcare` (acting as Business Associate) | No healthcare customers **AND** no PHI data |
| **PCI-DSS** | Storing/processing/transmitting cardholder data | `data_sensitivity`, `required_services` | `data_sensitivity` includes `cardholder` **OR** `required_services` includes `payments` (handling card data directly). Compliance *validation level* varies by txn volume: Level 1 (>6M txn/yr), Level 2 (1-6M), Level 3 (20K-1M e-commerce), Level 4 (<20K e-commerce or <1M other) | Using tokenized payment provider (e.g., Stripe) that handles all card data — PCI scope is minimal (SAQ-A) but not zero |
| **DORA** | ICT provider serving EU financial entities | `customer_sectors`, `target_markets` | `customer_sectors` includes `financial` **AND** `target_markets` includes EU or Global. DORA designates certain ICT providers as "critical" subject to direct EU oversight. | No financial-sector customers in EU |
| **NIS2** | EU entity in covered sector, medium+ size | `company_size`, `target_markets` | EU-based entity (`target_markets` includes EU or primary_region is EU) **AND** (`company_size` is `50-249` or `250+`, **OR** `annual_revenue` is `$25M+`). Digital infrastructure and ICT B2B service providers are in-scope sectors. | `company_size` <50 **AND** `annual_revenue` <€10M (~$11M). Note: some Member States may apply stricter thresholds. |
| **FedRAMP** | Selling cloud services to US federal agencies | `customer_sectors`, `target_markets` | `customer_sectors` includes `government` **AND** `target_markets` includes US or Global | No government customers in US |
| **FERPA** | Accessing student education records from US funded institutions | `customer_sectors`, `target_markets` | `customer_sectors` includes `education` **AND** `target_markets` includes US or Global | No education-sector customers in US |

### Always-Apply Frameworks (no conditions)

| Framework | Rule |
|-----------|------|
| **GDPR** | Always applies when `target_markets` includes EU or Global, regardless of company size or revenue. No threshold. |
| **SOC2** | Market-driven (not legally mandated). Effectively required for B2B SaaS selling to enterprises. Always included when matrix specifies it. |
| **ISO 27001** | Voluntary certification. Always included when matrix specifies it. Often required contractually by regulated customers. |

### Auto-Resolution with Conditions (2-step process)

When `compliance_frameworks` is `auto`, the orchestrator MUST:

1. **Candidate lookup** — Look up industry × market in the matrix. Collect all frameworks (including those marked †).
2. **Condition filter** — For each † framework, evaluate its condition from the table above:
   - **Applies** — Conditions clearly met → include in resolved list
   - **Likely applies** — Conditions cannot be ruled out (e.g., discriminator param is at default and could go either way) → include but flag: *"⚠ {Framework} included based on defaults. Confirm: {specific question about the condition}"*
   - **Does not apply** — Conditions clearly not met → remove with explanation: *"ℹ {Framework} excluded: {reason}"*
3. **Present result** — Show the user the resolved list with any flags before proceeding.

## Azure Pricing Principles

ALL sub-agents MUST follow these when estimating costs:

1. **Free tiers first** — Always check if a free tier or free monthly allowance covers the workload
2. **Dev/Test pricing** — For startups in early stage, Azure Dev/Test pricing can save 40-60% on VMs and PaaS
3. **Pay-as-you-go vs Reserved** — Report PAYG as default; note reserved (1yr/3yr) savings separately
4. **Microsoft for Startups** — Flag eligibility for $1K-$150K Azure credits (Founders Hub program)
5. **Region pricing varies** — Always price in the selected `primary_region`; some regions are 10-30% cheaper
6. **Hidden costs** — Account for: egress bandwidth, storage transactions, log ingestion, DNS queries, SSL certs
7. **Free tier overlap** — Some free tiers apply per-subscription (not per-service); don't double-count

### Common Free Tiers (as of 2026)

> **Note:** These prices are approximate starting points. Sub-agents MUST verify current pricing via web search in the target `primary_region` before reporting to the user. Do not treat this table as authoritative — Azure pricing changes frequently.

| Service | Free Tier | Monthly Allowance |
|---------|-----------|-------------------|
| App Service | F1 | 1 app, 1GB RAM, 60 min/day compute |
| Azure Functions | Consumption | 1M executions, 400K GB-s |
| Container Apps | Consumption | 180K vCPU-s, 360K GiB-s |
| SQL Database | — | No free tier (Basic starts ~$5/mo) |
| Cosmos DB | Free tier | 1000 RU/s, 25GB storage |
| PostgreSQL Flexible | Burstable B1ms | ~$12.41/mo (no free tier) |
| Storage Account | — | 5GB free for 12 months (new accounts) |
| Key Vault | Standard | 10K operations free |
| App Insights | — | 5GB/month free ingestion |
| Log Analytics | — | 5GB/month free ingestion (shared with App Insights) |
| Entra ID | Free | 50K objects, basic MFA |
| Front Door | — | No free tier |
| Application Gateway | — | No free tier (~$18+/mo) |

## Sub-Agent Output Format

Every sub-agent MUST structure its response using this format so the orchestrator can merge them:

```markdown
## [Domain Name] Assessment

### Configuration Context
- Parameters used: [list relevant params from config]
- Compliance requirements addressed: [list frameworks]

### Recommended Services

#### Cost-Optimized Tier
| Service | SKU/Tier | Monthly Cost | Compliance Coverage | Limitations |
|---------|----------|-------------|--------------------:|-------------|
| ... | ... | $X.XX | GDPR ✓ SOC2 ✓ | ... |

**Subtotal: $X.XX/month**

#### Recommended Tier
| Service | SKU/Tier | Monthly Cost | Compliance Coverage | Limitations |
|---------|----------|-------------|--------------------:|-------------|
| ... | ... | $X.XX | GDPR ✓ SOC2 ✓ | ... |

**Subtotal: $X.XX/month**

#### Enterprise-Ready Tier
| Service | SKU/Tier | Monthly Cost | Compliance Coverage | Limitations |
|---------|----------|-------------|--------------------:|-------------|
| ... | ... | $X.XX | All ✓ | ... |

**Subtotal: $X.XX/month**

### Compliance Notes
- [Framework]: [How this domain satisfies requirements]

### Alternatives Considered
- [Service A vs Service B]: [Why B was chosen]

### Risks & Trade-offs
- [Risk]: [Mitigation]
```

## Input Validation Rules

The orchestrator (`az-saas-planner`) MUST validate all parameters before proceeding. Sub-agents may assume inputs are already validated.

### Enum Parameter Validation

For every parameter with a fixed set of valid values (`industry`, `workload_type`, `compliance_frameworks`, `tech_stack`, `startup_stage`, `multi_tenancy`, `sla_target`, `data_sensitivity`, `expected_users_y1`, `data_volume`, `team_size`, `monthly_budget_cap`):

1. **Exact match** — If the value matches a valid option (case-insensitive), accept it.
2. **Fuzzy match** — If no exact match, attempt a fuzzy match against the valid values:
   - Common misspellings: "Healthcar" → "Healthcare", "Fintech" → "FinTech", "ecommerce" → "E-commerce"
   - Synonyms: "Finance" → "FinTech", "Medical" / "HealthTech" → "Healthcare", "Legal" → "LegalTech", "Insurance" → "InsurTech", "Real Estate" → "PropTech", "HR" → "HRTech", "Government" → "GovTech", "Education" → "EdTech", "Regulation" / "Compliance" → "RegTech", "Life Sciences" / "Pharma" / "Biotech" → "BioTech", "Media" / "Advertising" / "AdTech" → "MediaTech", "Travel" / "Hospitality" / "Tourism" → "TravelTech", "Cybersecurity" / "InfoSec" / "SecOps" / "Security" → "CyberSecurity"
   - If a close match is found, present it to the user: *"Did you mean '{match}'? [Yes / No, show valid options]"*
3. **No match** — If no close match exists, reject and show the valid values:
   - *"'{value}' is not a recognized {parameter}. Valid options: {list}. Please choose one, or use 'General SaaS' for unlisted industries."*

### Required Parameter Validation

- `industry` and `primary_region` are required. If missing, prompt the user before proceeding.
- For `primary_region`, accept either a recognized Azure region code **or** a geographic name. Apply the **Geographic Name Resolution** rules below.

### Geographic Name Resolution

Users may provide a friendly geographic name instead of an Azure region code. The orchestrator MUST resolve it before passing to sub-agents:

1. **Exact region code** — If the value matches a known Azure region code (case-insensitive), accept it as-is.
2. **Geo name lookup** — If no region code match, attempt a case-insensitive match against the **Geo-to-Region Mapping** table below. If found, present the resolved region to the user for confirmation: *"'{input}' → {azure_region} ({location}). Is this correct?"*
3. **No match** — If neither matches, reject and show common geographic names:
   - *"'{value}' is not a recognized Azure region or geographic name. Examples: Europe, US, UK, Asia, Australia, Canada, Brazil, Middle East, Africa — or use an Azure region code like westeurope, eastus."*

#### Geo-to-Region Mapping

| Geo / Common Name | Azure Region | Location |
|---|---|---|
| Europe, EU, Western Europe | westeurope | Netherlands |
| Northern Europe, Nordics, Ireland | northeurope | Ireland |
| US, USA, North America, East US | eastus | Virginia |
| West US, US West | westus3 | Arizona |
| UK, Britain, England | uksouth | London |
| Germany | germanywestcentral | Frankfurt |
| France | francecentral | Paris |
| Switzerland | switzerlandnorth | Zürich |
| Asia, APAC, Southeast Asia, Singapore | southeastasia | Singapore |
| East Asia, Hong Kong | eastasia | Hong Kong |
| Japan | japaneast | Tokyo |
| Australia, Oceania | australiaeast | Sydney |
| India | centralindia | Pune |
| Canada | canadacentral | Toronto |
| Brazil, South America, Latin America | brazilsouth | São Paulo |
| Middle East, UAE | uaenorth | Dubai |
| Africa, South Africa | southafricanorth | Johannesburg |
| Korea, South Korea | koreacentral | Seoul |

### Auto-Resolution Safety Check

When `compliance_frameworks` is `auto`, apply the **2-step process** described in **Auto-Resolution with Conditions** (under Framework Applicability Conditions):

1. **Candidate lookup** — Look up `industry` + `target_markets` in the **Compliance Framework × Industry Matrix**.
2. **Condition filter** — For each †-marked framework, evaluate its condition against `customer_sectors`, `annual_revenue`, `company_size`, and `data_sensitivity`. Classify as Applies / Likely applies / Does not apply.
3. If the lookup returns **an empty set** (no frameworks resolved after filtering), **STOP and warn the user**:
   - *"No compliance frameworks could be determined for industry '{industry}' in markets '{markets}' with your company profile. Please specify `compliance_frameworks` explicitly, or adjust discriminator parameters."*
4. Never proceed with an empty compliance framework list — this would produce a non-compliant stack.

### Data Sensitivity Cross-Check

If `data_sensitivity` includes values that conflict with or extend the resolved compliance frameworks, flag the discrepancy:
- `PHI` without HIPAA → warn: *"You indicated PHI data but HIPAA was not resolved. Consider adding HIPAA to compliance_frameworks, or set `customer_sectors` to include 'healthcare'."*
- `cardholder` without PCI-DSS → warn: *"You indicated cardholder data but PCI-DSS was not resolved. Consider adding PCI-DSS."*
- `financial` without SOC2 or PCI-DSS → warn: *"You indicated financial data — verify compliance framework coverage."*
- `financial` in `data_sensitivity` without `financial` in `customer_sectors` → info: *"You handle financial data. If your customers are financial institutions, consider setting `customer_sectors` to 'financial' to evaluate DORA applicability."*

## Model Override

Sub-agents leave `model` unset to use the user's default. To override per agent, add to its frontmatter:

```yaml
model: "Claude Sonnet 4"        # faster, good for research
model: "Claude Opus 4.6"            # deeper analysis
model: ["Claude Opus 4.6", "Claude Sonnet 4"]  # fallback chain
```

## MCP Tool Availability

Several sub-agents reference Azure MCP tools (e.g., `azure-mcp/sql`, `azure-mcp/cosmos`, `azure-mcp/quota`). These require the Azure MCP extension to be installed and configured.

- **If MCP tools are available**: Use them for live data (quota checks, resource lookups, best practices).
- **If MCP tools are unavailable**: Fall back to web search for the same information. Do not fail silently — note in the output that live data could not be retrieved and results are based on web search.
