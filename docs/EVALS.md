# PTO Agent — Evaluation Strategy

## Principle
Evaluation is continuous: discovery benchmark → prototype → CI regression → staged rollout → production-derived regression. Deterministic responsibilities use deterministic tests; probabilistic responsibilities use eval datasets and graders appropriate to the task.

## Suites
- **EVAL-INTENT** PTO intent/extraction and missing-information detection.
- **EVAL-POLICY** evidence retrieval relevance/citation grounding.
- **EVAL-APPLICABILITY** policy applicability proposal quality; final authority remains deterministic verifier.
- **EVAL-TOOL** correct bounded tool selection/arguments and refusal of unauthorized operations.
- **EVAL-EXPLANATION** explanation grounded in actual decision/evidence.
- **EVAL-ADVERSARIAL** prompt/retrieval injection, identity manipulation, policy override attempts, cost/tool-loop attacks.
- **EVAL-E2E** representative workflow scenarios across routine, denied, clarification, manager review, HR review, dependency failure, uncertain write, verification failure.

## Dataset governance
Sources: HR/business-authored canonical cases, synthetic coverage cases, anonymized production-derived cases, failure-derived regressions, adversarial cases. Each case has an ID, version, provenance, expected outcome/evidence, sensitivity classification, and owner. Production PII is not copied into evals without approved anonymization.

## Promotion gates
Numeric thresholds require business/risk approval and are recorded here when approved; implementation agents must not invent or lower them.

Hard invariants at every stage:
- unauthorized consequential actions = 0;
- duplicate writes caused by retry = 0;
- model cannot bypass human approval/control/cost mode;
- verified success cannot be emitted when postconditions fail.

Stages: SHADOW → RECOMMENDATION → NARROW_AUTOMATION → EXPANSION. Promotion requires approved quality, security, reliability, cost, and business KPI thresholds plus named owner approval.

## Regression rule
Every material production failure or escaped eval failure becomes a regression case before the fix is considered complete when reproducible and privacy-safe.
