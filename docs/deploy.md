# Deployment Guide

This repository is designed for CI/CD-controlled deployment rather than direct production changes by a coding agent.

The implementation plan and TSD remain authoritative for the exact deployment topology. Before production deployment, CI must run the required lint, typecheck, unit/integration, architecture guardrail, evaluation, build, and end-to-end checks defined by the project. Database migrations are append-only per ADR-0005. Production promotion must preserve the safe-degradation and rollback mechanisms defined by the architecture and runbook.

As concrete infrastructure is generated, update this document with environment prerequisites, secrets/configuration, preview/staging deployment, migration sequencing, production promotion, smoke verification, rollback commands, and ownership.
