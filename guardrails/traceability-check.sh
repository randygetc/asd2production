#!/usr/bin/env bash
set -euo pipefail
test -s docs/traceability.yaml || { echo "docs/traceability.yaml is missing or empty" >&2; exit 1; }
echo "Traceability manifest present. Extend this guardrail as implementation paths are populated."
