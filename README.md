# PTO Agent

Design-to-production repository for the PTO agent. The repository intentionally begins with authoritative design, agent governance, traceability, evaluation, operational scaffolding, and empty implementation directories. Application code is generated incrementally under `docs/plan.md` rather than fabricated in advance.

## Authority hierarchy

1. `docs/ADS.md` — business outcome, requirements, concerns, constraints, architecture drivers, patterns and logical architecture.
2. Accepted `docs/adr/` — consequential architecture decisions.
3. `docs/TSD.md` — implementable technical design.
4. `docs/traceability.yaml` — requirement/design/implementation/evidence mapping.
5. `docs/architecture.md`, `docs/conventions.md`, `docs/EVALS.md`, `docs/KICKOFF.md`, `docs/plan.md` — implementation-facing controls.
6. `CLAUDE.md` / `AGENTS.md` — coding-agent operating rules.
7. Source, tests and deployment artifacts — implementation evidence; they do not silently redefine upstream authority.

## Start with Claude Code

Launch Claude Code from the repository root. First ask it to read `CLAUDE.md` and perform an orientation pass without modifying files. It should identify the next unblocked task in `docs/plan.md`, its business requirement(s), ADRs, TSD components, tests/evals, expected files, and any design ambiguity before coding.

Production learning flows back through `docs/learnings.md`; unresolved owner decisions belong in `docs/owner-decisions/` rather than being guessed by the coding agent.
