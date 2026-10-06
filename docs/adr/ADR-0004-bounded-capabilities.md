# ADR-0004 — Use narrow bounded capabilities
Status: Accepted

## Decision
Consequential side effects are performed only by narrow application capabilities. LLM-visible operations are READ or WRITE_INTENT; WRITE_INTENT does not directly mutate authoritative business state.
