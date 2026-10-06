# ADR-0002 — Workflow owns durable state
Status: Accepted

## Decision
A durable workflow state machine owns progress, retries, waiting, approvals, and recovery. LLM conversation/session state is not authoritative workflow state.
