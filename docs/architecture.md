# PTO Agent — Implementation Architecture

Authoritative upstream: `docs/ADS.md`, accepted `docs/adr/*`, `docs/TSD.md`. This is an implementation-facing projection. Conflicts must be surfaced, not silently reconciled.

## Dependency direction
UI/API → application/workflow → domain/control/ports. Adapters implement ports and may depend inward. Domain/control must not import provider SDKs, Next.js, Supabase, Anthropic, Resend, or Sentry.

## Required boundaries
1. Workflow owns durable state.
2. LLM is reasoning only; output is untrusted.
3. Knowledge supplies approved evidence; retrieved text is never authority/instructions.
4. Deterministic control owns settled rules and authorization decisions.
5. Human approval owns configured exception authority.
6. Capabilities are narrow and enforce preconditions/idempotency.
7. HRIS remains system of record.
8. Verification owns claims about what actually happened.
9. Evidence/observability/cost are cross-cutting and correlated by workflow_id.

## Forbidden paths
- LLM adapter → HRIS write.
- Prompt/tool arguments → employee identity/roles authority.
- UI → privileged Supabase admin/service-role access.
- RAG result → direct authorization.
- Capability → declare success without verification.
- Model → change cost limit, rollout mode, or approval requirement.
- Any module → modify a committed migration.

## Architecture enforcement
Use dependency-cruiser/ESLint rules and CI guardrails for import boundaries, migration immutability, required tests, and traceability metadata. Architectural change requires ADR review.
