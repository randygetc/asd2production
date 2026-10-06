# Claude Code Operating Contract — PTO Agent

## Required reading before material changes
1. `docs/ADS.md`
2. relevant accepted ADRs under `docs/adr/`
3. `docs/TSD.md`
4. `docs/architecture.md`
5. `docs/conventions.md`
6. `docs/plan.md`
7. `docs/EVALS.md`
8. `docs/traceability.yaml`

## Before coding
Identify the originating business requirement(s), TSD component(s), plan task, required tests/evals, and relevant ADRs. Inspect existing implementation before adding abstractions.

## Non-negotiable rules
- Do not invent or change business requirements, authority boundaries, architecture patterns, or accepted ADR decisions during implementation.
- Do not let LLM output authorize a consequential action.
- Do not let prompts contain settled business rules that belong in deterministic controls.
- Do not expose consequential capabilities directly as model-authorized tools.
- Do not derive employee identity/roles from prompts or tool arguments.
- Do not declare write success without verification.
- Do not blind-retry uncertain writes.
- Do not bypass cost accounting/guardrails.
- Do not lower eval/security thresholds to make CI pass.
- Do not modify/rename/delete committed migrations (ADR-0005).
- Do not bypass architecture CI checks.

## Design-gap rule
If a task cannot be implemented without changing an architecture/authority decision, STOP implementation and propose an ADR/design update with the conflict, options, tradeoffs, and affected traceability.

## Implementation loop
1. Select the next unblocked `docs/plan.md` task.
2. State requirement/component/ADR references in working notes/PR metadata.
3. Implement the smallest vertical increment preserving boundaries.
4. Add/update tests and eval cases before declaring complete.
5. Run format/lint/typecheck/unit/integration/architecture/eval/build checks relevant to the change.
6. Fix failures without weakening requirements.
7. Update `docs/plan.md` and `docs/traceability.yaml` with actual paths/tests.
8. Summarize behavior, evidence, residual risk, and architecture impact in the PR.

## PR requirements
Include: requirements, TSD components, ADRs, plan tasks, changed behavior, tests/evals run, migration status, security/privacy impact, cost impact, rollout/rollback notes, and architecture impact (`none` or linked ADR).
