---
description: "Find the most cost-optimized compliance-ready Azure stack for a SaaS startup. Configurable by industry, region, compliance frameworks, workload type, scale, budget, and tech stack."
agent: "az-saas-planner"
argument-hint: "Industry: RegTech, Region: Europe, Budget: $200, Users: 1K, Services: auth+payments"
---

# Find Cost-Optimized Compliance-Ready Azure Stack

Research and recommend the most cost-optimized Azure infrastructure stack for a SaaS startup that meets compliance requirements for the given industry and target markets.

## Your Parameters

Parameters are organized in three groups by impact. Fill in what you know — leave blank for smart defaults.

### Group 1 — Identity & Compliance Profile *(most impactful)*

These determine which compliance frameworks apply. Getting them wrong means the wrong stack.

| Parameter | Your Value | Default | Why It Matters |
|-----------|-----------|---------|----------------|
| **Industry** | ${input:industry} | *(required)* | Base compliance frameworks |
| **Region** | ${input:region} | *(required)* | Data residency & pricing. Use a geo name (Europe, US, UK) or Azure code (westeurope) |
| **Target markets** | ${input:markets} | EU | Triggers region-specific regulations (GDPR, CCPA, etc.) |
| **Customer sectors** | ${input:customer_sectors} | general | Who buys your SaaS? `financial` → DORA, `healthcare` → HIPAA, `government` → FedRAMP, `education` → FERPA |
| **Annual revenue** | ${input:annual_revenue} | pre-revenue | CCPA kicks in at $25M+; NIS2 at €10M+ |
| **Company size** | ${input:company_size} | <50 | NIS2 applies to 50+ employees in the EU |
| **Data sensitivity** | ${input:data_sensitivity} | PII | PHI/cardholder/financial triggers stricter frameworks |
| **Compliance** | ${input:compliance} | auto | Leave as `auto` to derive from above, or specify explicitly |

### Group 2 — Workload & Scale *(sizes the infrastructure)*

These determine resource sizing. Defaults are safe for most early-stage startups.

| Parameter | Your Value | Default | Why It Matters |
|-----------|-----------|---------|----------------|
| **Workload type** | ${input:workload} | API-heavy | API-heavy / data-intensive / event-driven / real-time / hybrid |
| **Expected users (Y1)** | ${input:users} | 1K | Drives compute & database sizing |
| **Data volume** | ${input:data_volume} | 1-10GB | Storage + log ingestion estimates |
| **Required services** | ${input:services} | auth | auth, payments, email, file-storage, search, queues, caching, CDN, analytics |
| **Tech stack** | ${input:tech_stack} | any | Affects which Azure services are compatible |
| **Multi-tenancy** | ${input:multi_tenancy} | shared | shared / schema-per-tenant / db-per-tenant / silo |

### Group 3 — Budget & Operations *(constraints)*

These are guardrails. Defaults are reasonable for MVP startups.

| Parameter | Your Value | Default | Why It Matters |
|-----------|-----------|---------|----------------|
| **Monthly budget cap** | ${input:budget} | $200 | Hard cap for the PAYG cost estimate |
| **Startup stage** | ${input:startup_stage} | MVP | Affects Microsoft for Startups credit eligibility |
| **Team size** | ${input:team_size} | 1-3 | Dev/ops team — affects per-seat security costs (Entra ID P1 is $6/user/mo) |
| **SLA target** | ${input:sla_target} | 99.9% | 99.99% requires multi-region — significant cost jump |
| **DR region** | ${input:dr_region} | auto | Disaster recovery region (auto = Azure paired region) |

## What You'll Get

A detailed markdown report (`docs/stack-report.md`) with:

1. **Three-tier comparison**: Cost-Optimized / Recommended / Enterprise-ready stacks
2. **Per-service breakdown**: Compute, data, security, observability, networking — each with cost estimates
3. **Compliance mapping**: Which services satisfy which framework requirements
4. **Growth projections**: Costs at 10x and 100x scale, scaling cliffs to watch for
5. **Startup credit opportunities**: Microsoft for Startups eligibility and savings
6. **Alternative options**: For each service category, what was considered and why

## Example Invocation

```
Industry: RegTech
Region: Europe
Budget: $200
Markets: Global
Users: 10K
Services: auth, analytics, queues
Tech stack: Python
```
