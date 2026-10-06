# PTO Agent — Engineering Conventions

## TypeScript
Use strict TypeScript. Prefer explicit domain types and discriminated unions. Avoid `any`; boundary `unknown` must be validated.

## Validation
All external, database, API, model, and tool inputs cross Zod validation boundaries. Never cast model output into a trusted domain type.

## Errors
Use typed failure classes/codes from the TSD. Preserve retryability explicitly. Do not catch-and-ignore consequential errors.

## LLM/tool conventions
Every LLM-visible tool is classified READ or WRITE_INTENT. Tool schemas are narrow. Trusted identity/context is injected server-side, not accepted from model parameters. Tool responses distinguish authoritative facts from explanatory text.

## Business rules
Settled rules are pure/deterministic where possible and return stable reason codes. Do not hide business policy in prompts.

## Side effects
Writes occur only through capability modules. Consequential writes require authorization, stable idempotency keys, audit correlation, and verification.

## Database
Migrations are append-only after commit. RLS defaults deny. Privileged clients are server-only and narrowly scoped. Use transactions for state/evidence changes that must be atomic.

## Observability/privacy
Structured logs use request_id/workflow_id. Never log secrets. Avoid raw employee prompts, policy-sensitive PII, access tokens, or provider keys. Redact before Sentry/logging.

## Tests
Each material requirement has deterministic tests and/or evals appropriate to the responsibility. Tests must include negative authorization, duplicate/retry, stale-fact, ambiguous-policy, and verification-failure cases.

## Traceability
Material code/tasks/tests reference requirement/component IDs in task metadata, test names, or module docs. Do not add untraceable subsystems.
