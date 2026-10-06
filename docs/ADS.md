# PTO Agent — Architecture Solution Design (ADS)

Status: Baseline v1.0

## 1. Business problem
Employees should be able to resolve routine PTO requests without waiting on HR intervention, while preserving existing business authority, policy compliance, auditability, safety, and measurable economics.

## 2. Business outcomes
- **BO-001**: Employees resolve routine PTO requests without HR intervention.
- **BO-002**: Exceptions remain under appropriate manager/HR authority.
- **BO-003**: Every consequential decision and action is reconstructable.
- **BO-004**: Automation has measurable unit economics and configurable cost limits.

## 3. Success measures
- **SM-001** Routine automation rate.
- **SM-002** Median time to verified resolution.
- **SM-003** HR intervention rate.
- **SM-004** Incorrect automation rate.
- **SM-005** Verification failure rate.
- **SM-006** Cost per verified resolution.
- **SM-007** Duplicate/unauthorized write count (target: zero).

## 4. Business requirements
- **BR-001** Employees can express PTO requests in natural language.
- **BR-002** The governing approved PTO policy must be identified for the employee and request.
- **BR-003** Eligibility, dates, balance, overlap, blackout, and approval rules must be evaluated correctly.
- **BR-004** Trusted employee identity and facts must come from authoritative sources, not model assertions.
- **BR-005** Routine eligible requests should execute without HR intervention.
- **BR-006** Non-routine, ambiguous, or high-impact cases must route to appropriate human authority.
- **BR-007** The system must establish what actually happened after a consequential action.
- **BR-008** Decisions, evidence, policy/rule versions, approvals, actions, and outcomes must be reconstructable.
- **BR-009** Workflow state must survive process/model failures and support safe continuation.
- **BR-010** Cost must be attributable per workflow and automation must obey configurable economic limits.
- **BR-011** The system must support safe degradation from automation to recommendation-only or human-only operation.

## 5. Architectural responsibilities
1. Maintain durable workflow state.
2. Interpret employee intent and extract a structured proposal.
3. Establish trusted identity and employee facts.
4. Discover approved policy evidence.
5. Determine policy applicability with bounded reasoning and deterministic verification.
6. Evaluate settled business rules deterministically.
7. Classify routine, denied, needs-information, or review-required cases.
8. Authorize consequential actions outside the LLM.
9. Execute through narrow capabilities.
10. Preserve the HRIS/system of record as authoritative business state.
11. Verify postconditions after writes.
12. Preserve audit/evidence and observability.
13. Account for workflow cost and enforce budgets.
14. Escalate ambiguity/failure to humans when required.

## 6. Concerns
- **CON-LLM-001** Model interpretation is probabilistic and may be wrong.
- **CON-POL-001** Multiple policies may appear applicable or policy may be stale.
- **CON-AUTH-001** Model/tool requests could exceed employee or workflow authority.
- **CON-EXEC-001** A write may succeed while the response is lost, creating uncertain outcome.
- **CON-TIME-001** Facts/approvals may become stale between evaluation and execution.
- **CON-SEC-001** Prompt injection, retrieved-content injection, cross-employee leakage, and privilege escalation.
- **CON-COST-001** Unbounded model/tool loops or hidden provider/human costs.
- **CON-AUD-001** A decision may become impossible to reconstruct after model/policy/rule changes.

## 7. Constraints
- **C-001** Existing HRIS remains authoritative for PTO records/balances.
- **C-002** Existing manager/HR authority remains authoritative for exceptions and approvals.
- **C-003** Only approved policy content may govern automated decisions.
- **C-004** Identity and employee facts must originate from trusted sources.
- **C-005** The LLM cannot grant itself authority or bypass deterministic controls.
- **C-006** Consequential writes require idempotency and verification.
- **C-007** Production must provide a non-code-deploy safety mode switch.

## 8. Quality attributes / architecture drivers
- Safety and authorization integrity.
- Auditability and explainability after the fact.
- Recoverability and durable workflow state.
- Temporal correctness and revalidation.
- Privacy/security and least privilege.
- Reliability/idempotency for side effects.
- Measurable cost efficiency.
- Replaceability of model/provider.
- Testability/evaluability.

## 9. Threat and failure model
Threats include impersonation, prompt injection, malicious retrieved policy text, tool argument manipulation, data leakage, replay/duplicate writes, secret leakage, cost exhaustion, stale decisions, and dependency/model outages. Controls are layered: trusted execution context, schema validation, deterministic authorization, least-privilege capabilities, RLS, idempotency, post-write verification, audit, budget guards, and safe degradation.

## 10. Architecture patterns
- **PAT-001 Reasoning / Authority Separation**: model proposes; deterministic controls authorize.
- **PAT-002 Durable Workflow**: workflow owns state and continuation, not the model session.
- **PAT-003 Bounded Capability**: narrow operations expose only the minimum action surface.
- **PAT-004 Idempotent Verified Action**: authorize → idempotency → execute → read back → verify.
- **PAT-005 Bounded Policy Applicability**: candidate discovery → model proposal → deterministic applicability verification.
- **PAT-006 Human Authority**: ambiguity/high impact routes to explicit human decision records.
- **PAT-007 Evidence Ledger**: decisions/actions retain versions, evidence, reason codes, and transitions.
- **PAT-008 Workflow Cost Ledger**: usage → versioned pricing → cost events → workflow economics.
- **PAT-009 Safe Degradation**: AUTOMATED → RECOMMENDATION_ONLY → HUMAN_ONLY.
- **PAT-010 Evaluation-Gated Autonomy**: autonomy expands only after defined evidence thresholds.

## 11. Logical layers
Business event → Workflow → Reasoning → Knowledge → Control → Human approval when required → Capability → System of Record → Verification → Observability/Evidence → Evaluation.

Cross-cutting: identity/security, privacy, cost accounting, versioning, audit, temporal validity.

## 12. Authority / source-of-truth matrix
| Fact/decision | Authority |
|---|---|
| Authenticated user | Identity provider/session |
| Employee mapping/attributes | Trusted employee directory/HRIS |
| PTO balance/request | HRIS |
| Workflow state | Workflow store |
| Approved policy | Policy repository |
| Applicability authority | Deterministic applicability control using approved evidence/facts |
| Settled PTO rules | Deterministic control layer |
| Manager/HR approval | Approval record by authorized human |
| Actual execution outcome | Verified system-of-record state |
| Workflow cost | Cost ledger |

## 13. Temporal correctness
Facts and approvals are classified as fresh, stale, expired, superseded, or unsettled. Consequential execution must revalidate facts whose validity window can change (balance, overlapping requests, policy effective dates, approval state).

## 14. Architecture acceptance
The architecture is acceptable only if no consequential action can be authorized solely by model output; writes are idempotent and verified; ambiguous cases have a human path; workflow state is durable; costs are attributable/bounded; and production evidence can map back to business outcomes.
