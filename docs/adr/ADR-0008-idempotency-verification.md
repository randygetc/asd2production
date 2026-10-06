# ADR-0008 — Consequential writes require idempotency and verification
Status: Accepted

## Decision
Every consequential write uses a stable idempotency key. After execution, the system reads authoritative state and verifies postconditions before declaring success. Uncertain outcomes never trigger blind duplicate writes.
