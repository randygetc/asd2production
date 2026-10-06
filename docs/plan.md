# PTO Agent — Implementation Plan

Status legend: `[ ]` not started, `[~]` active, `[x]` complete. A task is complete only when code, tests/evals, traceability, and required docs are updated.

## Phase 0 — Repository guardrails
- [ ] **TASK-P0-001** Configure strict TS, lint, formatting, test runners. Reqs: BR-008. Components: cross-cutting.
- [ ] **TASK-P0-002** Configure dependency-cruiser architecture rules. Reqs: BR-008. ADR: 0001/0004.
- [ ] **TASK-P0-003** Add CI migration append-only guardrail. ADR-0005.
- [ ] **TASK-P0-004** Add PR template requiring traceability/security/cost/eval metadata.

## Phase 1 — Identity and durable workflow
- [ ] **TASK-P1-001** Supabase Auth + Google OAuth session integration. Reqs: BR-004.
- [ ] **TASK-P1-002** Trusted employee mapping and `ExecutionContextFactory`. Component: CMP-ID-001.
- [ ] **TASK-P1-003** Workflow schema/state transitions/repository. Reqs: BR-009. CMP-WF-001. ADR-0002.
- [ ] **TASK-P1-004** RLS policies + negative tests.

## Phase 2 — Policy knowledge/RAG
- [ ] **TASK-P2-001** Policy document/chunk schema, metadata, vector index. BR-002. CMP-POL-001/002.
- [ ] **TASK-P2-002** Approved policy ingestion/versioning pipeline.
- [ ] **TASK-P2-003** Catalog and semantic retrieval with effective-date/scope filters.
- [ ] **TASK-P2-004** Policy retrieval eval set. EVAL-POLICY.

## Phase 3 — Reasoning and applicability
- [ ] **TASK-P3-001** `ReasoningPort` + Anthropic adapter. BR-001. CMP-LLM-001/002.
- [ ] **TASK-P3-002** Versioned PTO interpretation prompt + Zod proposal schema.
- [ ] **TASK-P3-003** Bounded READ/WRITE_INTENT tool registry.
- [ ] **TASK-P3-004** Applicability proposal + deterministic verifier. BR-002. CMP-POL-003. ADR-0007.
- [ ] **TASK-P3-005** Intent/applicability/tool/adversarial evals.

## Phase 4 — Deterministic PTO controls
- [ ] **TASK-P4-001** Eligibility/date/hour/balance/overlap/blackout evaluators. BR-003. CMP-CTL-001. ADR-0003.
- [ ] **TASK-P4-002** Routine classifier + reason codes. BR-005/006. CMP-CTL-002.
- [ ] **TASK-P4-003** Temporal freshness/revalidation rules. BR-003/007.
- [ ] **TASK-P4-004** Unit/property tests for control matrix.

## Phase 5 — Human authority
- [ ] **TASK-P5-001** Approval schema/service/UI authorization. BR-006. CMP-APR-001.
- [ ] **TASK-P5-002** Manager/HR queues and decision endpoints.
- [ ] **TASK-P5-003** Revalidate volatile facts after approval and before execution.

## Phase 6 — Capability, idempotency, verification
- [ ] **TASK-P6-001** `HrisGateway` port + test adapter. CMP-INT-001. ADR-0006.
- [ ] **TASK-P6-002** Idempotency record/key strategy. ADR-0008.
- [ ] **TASK-P6-003** `SubmitPtoCapability`. BR-005. CMP-CAP-001. ADR-0004/0008.
- [ ] **TASK-P6-004** `PtoSubmissionVerifier`. BR-007. CMP-VER-001.
- [ ] **TASK-P6-005** Failure-injection tests: timeout-after-write, duplicate retry, mismatch, reconciliation.

## Phase 7 — Evidence, observability, cost
- [ ] **TASK-P7-001** Decision/audit evidence recorder and version fields. BR-008. CMP-AUD-001. ADR-0009.
- [ ] **TASK-P7-002** Structured Sentry/log correlation with privacy filters.
- [ ] **TASK-P7-003** Usage/pricing/cost tables and services. BR-010. CMP-COST-001/002/003. ADR-0010.
- [ ] **TASK-P7-004** Deterministic call/cost budget guardrail. CMP-COST-004.
- [ ] **TASK-P7-005** Cost reporting: verified workflow, escalation, retries, baseline comparison.

## Phase 8 — Product experience + E2E
- [ ] **TASK-P8-001** Employee PTO conversation/request UI.
- [ ] **TASK-P8-002** Status/explanation UI grounded in actual evidence.
- [ ] **TASK-P8-003** E2E hero workflow and non-routine paths.
- [ ] **TASK-P8-004** Accessibility and UX checks.

## Phase 9 — Deployment and production readiness
- [ ] **TASK-P9-001** GitHub CI and Vercel preview/production config.
- [ ] **TASK-P9-002** Supabase migration and Edge Function deployment workflow.
- [ ] **TASK-P9-003** Runtime safety modes. BR-011. ADR-0011.
- [ ] **TASK-P9-004** Load/performance tests and SLO dashboards.
- [ ] **TASK-P9-005** Runbook validation, rollback drill, ownership assignment.
- [ ] **TASK-P9-006** Promotion-gate review per EVALS.md. ADR-0012.

## Phase 10 — Production learning/reuse
- [ ] **TASK-P10-001** Monitor business KPIs, reliability, economics, and eval drift.
- [ ] **TASK-P10-002** Convert production failures into regression cases.
- [ ] **TASK-P10-003** Capture evidence-backed learnings and reusable patterns/field signals.
