# PTO Agent — Production Runbook

## Operational modes
- `AUTOMATED`: eligible routine requests may execute.
- `RECOMMENDATION_ONLY`: reasoning/controls continue; no autonomous consequential writes.
- `HUMAN_ONLY`: automated decision/execution disabled; route to human process.
Mode changes are deterministic, access-controlled, and audited.

## Incident priorities
1. Unauthorized/incorrect write: switch to RECOMMENDATION_ONLY or HUMAN_ONLY; preserve evidence; stop affected capability; investigate scope; follow incident process.
2. Duplicate-write risk: disable affected write capability; query HRIS authoritative state; do not replay blindly.
3. Verification failures: do not report success; queue reconciliation/human review.
4. Policy/RAG uncertainty: stop autonomous execution for affected policy scope; use human review.
5. Model outage/degradation: retry only safe calls per policy; degrade to human/recommendation mode.
6. Supabase/workflow outage: do not continue statelessly; recover from durable state when available.
7. HRIS outage/timeout: read back before retry; uncertain state requires reconciliation.
8. Cost anomaly: enforce configured budget; investigate loops/provider pricing/version.

## Rollback
Application rollback uses the last known-good Vercel deployment. Database migrations are forward-fix/append-only; do not edit committed migrations. Rollout mode can disable autonomous execution independently of deployment.

## Evidence to preserve
workflow_id, request_id, state transitions, control reasons, approval record, policy/rule/prompt/model/tool/capability versions, idempotency record, HRIS response/read-back references, verification result, cost events, deployment/release identifier.

## Ownership placeholders
Business owner, HR policy owner, engineering on-call, security contact, and incident commander must be assigned before production launch.
