# ADR-0001 — Separate probabilistic reasoning from business authority
Status: Accepted

## Context
Natural-language and policy interpretation benefit from an LLM, but PTO authorization is consequential.

## Decision
LLM output is a proposal, never authority. Deterministic controls and trusted execution context own authorization and settled business rules.

## Consequences
Model outputs require schema validation. Capabilities reject calls lacking authoritative control decisions. Tests must prove model output cannot bypass authorization.
