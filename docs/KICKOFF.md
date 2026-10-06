# PTO Agent — Implementation Kickoff

## Objective
Deliver a production-ready vertical slice in which an authenticated employee can request routine PTO in natural language and receive a verified result without HR intervention when policy and deterministic controls permit it.

## Hero workflow
Employee: “I want next Thursday and Friday off.”

Expected path: authenticate → create durable workflow → interpret request → retrieve approved policy candidates/evidence → determine applicable policy → evaluate trusted balance/dates/eligibility → classify routine → execute bounded/idempotent PTO submission → read back/verify HRIS state → persist evidence/cost → report verified result.

## Out of scope for first slice
Broad HR chatbot behavior, arbitrary HRIS operations, policy authoring, autonomous exception approval, payroll/benefits workflows.

## First milestone exit criteria
- End-to-end routine PTO path works in preview/test environment.
- Ambiguous policy and approval-required cases do not auto-execute.
- Negative authorization/RLS tests pass.
- Duplicate submission test proves idempotency.
- Verification failure path is visible and recoverable.
- Workflow usage/cost events are captured.
- Required eval regression suite passes.
- Traceability from BR-005/BR-007/BR-010 to code/tests exists.
