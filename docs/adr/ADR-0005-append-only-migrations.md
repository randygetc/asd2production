# ADR-0005 — Committed database migrations are append-only
Status: Accepted

## Decision
Committed migrations are never modified, renamed, or deleted. Schema evolution uses new migrations. CI enforces this rule.
