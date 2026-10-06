# ADR-0007 — Policy applicability uses bounded reasoning plus deterministic verification
Status: Accepted

## Decision
Approved policies are retrieved from the policy repository/RAG store. The LLM may propose applicability with cited evidence. A deterministic verifier compares proposal criteria against trusted employee/request facts and policy metadata/effective dates before policy is accepted.
