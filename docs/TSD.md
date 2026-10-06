# PTO Agent — Technical Solution Design (TSD)

Status: Baseline v1.0. Upstream authority: ADS.md + accepted ADRs.

## 1. Purpose
Define the implementable technical design for the PTO Agent. If implementation requires changing an architectural decision, create/propose an ADR rather than silently changing this design.

## 2. Technology baseline
- Next.js + TypeScript application deployed on Vercel.
- Supabase: PostgreSQL, Auth with Google OAuth, Row Level Security, pgvector, Edge Functions where server-side edge execution is appropriate.
- Anthropic model behind a provider-neutral `ReasoningPort`.
- Zod for boundary/schema validation.
- Resend for email notifications.
- Sentry for application observability and release/source-map handling.
- GitHub for source control/PR/CI.
- Vitest for unit/integration tests, Playwright for E2E, k6 for load tests, dependency-cruiser for architecture boundaries.

## 3. Physical architecture
Browser → Next.js/Vercel → application/workflow services. Server-side adapters connect to Supabase, Anthropic, Resend, Sentry, and the HRIS gateway. Supabase stores workflow/evidence/policy/vector/cost data; HRIS remains authoritative for PTO business state.

## 4. Component catalog
- **CMP-WF-001 PtoWorkflowService** — durable state transitions and orchestration.
- **CMP-ID-001 ExecutionContextFactory** — trusted identity, employee, tenant, roles.
- **CMP-LLM-001 ReasoningPort** — provider-neutral reasoning contract.
- **CMP-LLM-002 AnthropicReasoningAdapter** — Anthropic implementation.
- **CMP-POL-001 PolicyCatalog** — candidate metadata discovery.
- **CMP-POL-002 PolicyRetriever** — approved chunk retrieval from Supabase/pgvector.
- **CMP-POL-003 PolicyApplicabilityVerifier** — deterministic applicability authority.
- **CMP-CTL-001 PtoControlEvaluator** — deterministic PTO rule evaluation.
- **CMP-CTL-002 RoutineRequestClassifier** — ROUTINE / REVIEW_REQUIRED / DENIED / NEEDS_INFORMATION.
- **CMP-APR-001 ApprovalService** — manager/HR review records and decisions.
- **CMP-CAP-001 SubmitPtoCapability** — authorized/idempotent write boundary.
- **CMP-CAP-002 CancelPtoCapability** — authorized/idempotent cancellation boundary.
- **CMP-INT-001 HrisGateway** — system-of-record adapter.
- **CMP-VER-001 PtoSubmissionVerifier** — post-write verification.
- **CMP-AUD-001 EvidenceRecorder** — audit/decision evidence.
- **CMP-COST-001 UsageRecorder** — raw usage events.
- **CMP-COST-002 PricingService** — versioned rates.
- **CMP-COST-003 WorkflowCostAggregator** — workflow totals.
- **CMP-COST-004 WorkflowCostGuardrail** — deterministic budgets.

## 5. Domain contracts
```ts
type PtoRequestInput = {
  leaveType: string;
  startDate: string;
  endDate: string;
  requestedHours?: number;
};

type ExecutionContext = {
  requestId: string;
  workflowId: string;
  userId: string;
  employeeId: string;
  tenantId: string;
  roles: string[];
};

type PtoClassification =
  | { type: "ROUTINE"; reasons: string[] }
  | { type: "REVIEW_REQUIRED"; reasons: string[] }
  | { type: "DENIED"; reasons: string[] }
  | { type: "NEEDS_INFORMATION"; reasons: string[] };
```
LLM-produced structures have separate Zod schemas and are untrusted until parsed.

## 6. Workflow state machine
`RECEIVED → INTERPRETING → POLICY_DISCOVERY → POLICY_APPLICABILITY → VALIDATING → CONTROLS`.

Controls transition to `NEEDS_INFORMATION`, `PENDING_MANAGER_APPROVAL`, `PENDING_HR_REVIEW`, `DENIED`, or `READY_TO_EXECUTE`.

Execution path: `READY_TO_EXECUTE → EXECUTING → VERIFYING → VERIFIED | VERIFICATION_FAILED`.

All transitions persist atomically with evidence. Waiting states are durable. Terminal states are VERIFIED, DENIED, CANCELLED, and manually resolved failure states.

## 7. LLM design
### Role
Interpret PTO language, extract structured proposals, identify missing information, reason over retrieved approved policy evidence, and produce explanations/tool intents.

### Must not
Establish authenticated identity, invent trusted employee facts, authorize writes, decide settled PTO rules, declare unverified execution success, or bypass budgets/approval.

### Context
System instructions + employee message + minimum workflow context + trusted facts required for the task + approved retrieved evidence + registered tool schemas. Context is minimized for privacy.

### LLM-visible tools
- `search_policy_catalog` — READ.
- `get_policy` / `search_pto_policy` — READ.
- `get_pto_balance` — READ using employeeId from trusted context, not tool arguments.
- `get_employee_schedule` — READ.
- `propose_pto_request` — WRITE_INTENT; creates/updates proposal only.

Consequential `SubmitPtoCapability` is not directly LLM-authorized.

### Loop limits
Per-workflow model/tool call counts and variable-cost budgets are checked before each iteration. Exhaustion yields `COST_LIMIT_REACHED` or human escalation, never self-extension by the model.

## 8. Policy/RAG design
Approved policy documents and chunks live in Supabase PostgreSQL/pgvector with metadata: policy_id, version, status, effective dates, jurisdiction, employee class/scope, source, checksum, and approval metadata. Retrieval applies metadata/effective-date filters before semantic ranking. Model applicability proposals cite policy/chunk evidence. `PolicyApplicabilityVerifier` compares applicability criteria with trusted facts and can return CONFIRMED, NOT_APPLICABLE, NEEDS_INFORMATION, or AMBIGUOUS.

## 9. Deterministic controls
`PtoControlEvaluator` evaluates eligibility, valid dates, requested hours, balance, overlap, blackout, policy limits, approval requirement, and temporal freshness. Every result carries stable reason codes. Ambiguity is never coerced into routine approval.

## 10. Data model
Core tables:
- `profiles` / trusted employee mapping references.
- `workflow_runs`, `workflow_transitions`, `pto_proposals`.
- `policy_documents`, `policy_chunks` (vector), `policy_applicability_records`.
- `decision_records`, `approvals`, `audit_events`.
- `idempotency_records`.
- `usage_events`, `service_pricing`, `workflow_cost_events`.

RLS defaults to deny. Employees see own workflow/request views; managers see authorized reports; HR sees authorized org scope; service roles are narrowly scoped and server-only.

## 11. API surface
- `POST /api/pto/workflows` create workflow.
- `POST /api/pto/workflows/{id}/message` add employee message/continue workflow.
- `GET /api/pto/workflows/{id}` get authorized status.
- `GET /api/pto/requests` / `{id}` authorized views.
- `POST /api/pto/requests/{id}/cancel` bounded cancellation flow.
- `GET /api/manager/approvals` and `POST /api/manager/approvals/{id}/decision`.

Every write endpoint requires authentication, authorization, Zod validation, CSRF-safe server patterns as applicable, idempotency where consequential, and audit correlation IDs.

## 12. Capability + verification
`SubmitPtoCapability` accepts only validated request, trusted execution context, authoritative control decision, and idempotency key. It revalidates volatile facts, authorizes, obtains idempotency, calls `HrisGateway`, reads authoritative state, and invokes `PtoSubmissionVerifier`. Verified success requires matching employee, leave type, dates, hours/status, and exactly one intended record. Timeouts trigger read-back before retry.

## 13. Cost accounting
`UsageEvent` records workflowId, operation, provider/service/model/SKU, quantity/unit, timestamp, and provider usage identifiers when available. `PricingService` applies versioned rates. `CostEvent` stores amount/currency and classification MEASURED, ESTIMATED, or ALLOCATED. Human-review cost can be allocated using approved business rates and is kept distinguishable from automated variable cost. Production reporting includes cost/verified workflow, cost/escalation, retry waste, and savings versus baseline.

## 14. Security/privacy
Least privilege; no secrets/client-private keys in browser bundles; service-role keys server-only; prompt/context minimization; PII redaction from logs; untrusted retrieved text treated as data, not instructions; tool arguments validated; RLS negative tests; secret rotation supported. Audit records avoid raw prompt/body capture unless explicitly approved.

## 15. Versioning
Record consequential `policy_version`, `rule_version`, `prompt_version`, `model`, `tool_schema_version`, `workflow_version`, `capability_version`, and `pricing_version` on decision/evidence records as applicable.

## 16. Failure/recovery
Typed classes: INPUT_ERROR, NEEDS_INFORMATION, POLICY_AMBIGUITY, BUSINESS_RULE_FAILURE, AUTHORIZATION_FAILURE, DEPENDENCY_FAILURE, EXECUTION_FAILURE, VERIFICATION_FAILURE, MODEL_FAILURE, SECURITY_EVENT, COST_LIMIT_REACHED. Retry only explicitly retryable operations. Never blind-retry uncertain writes. Escalate when safe automated recovery is unavailable.

## 17. Observability
Correlate `request_id` and `workflow_id`. Emit structured events for workflow/model/tool/control/capability/verification/cost lifecycle. Sentry captures application errors/performance without prohibited PII. Release/source-map upload uses Sentry build credentials, never runtime client secrets.

## 18. Deployment/CI
Feature branch → GitHub PR → CI + Vercel Preview → review → main → production. Supabase schema changes are append-only migrations and validated in CI. Edge Functions are deployed through an explicit CI/deployment path, not assumed to be deployed by Vercel.

Required CI: install, lint, typecheck, unit, integration, DB/RLS tests, eval smoke/regression gates, dependency-cruiser, migration guardrails, build, E2E smoke. Production promotion follows EVALS.md gates.

## 19. Safe modes
Runtime config supports `AUTOMATED`, `RECOMMENDATION_ONLY`, `HUMAN_ONLY`. The LLM cannot change the mode. Emergency mode changes are audited.

## 20. Production SLO candidates
Availability, p95 workflow API latency excluding human waits, verified completion rate, verification failure rate, unauthorized/duplicate writes, dependency/model failure rate, cost/verified workflow, escalation rate. Numeric targets are business/ops approval items and must not be invented by implementation agents.
