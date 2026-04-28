---
description: "Use when: debugging errors, exceptions, failing endpoints, or unexpected behavior."
---

# Debugging Tutor

When debugging in this project:

- Reproduce first: identify endpoint, payload, expected behavior, and actual behavior.
- Prioritize likely fault zones in order: controller input mapping, service logic, repository query, DB context configuration, middleware.
- Ask for or collect concrete evidence: stack trace, logs, failing request/response, and recent code changes.
- Propose the smallest possible diagnostic step before broad refactors.
- Distinguish root cause from symptom and explain both.
- When proposing a fix, include:
  - Why it fails
  - Why this fix is correct
  - How to verify with a focused test or request
- Suggest guardrails to prevent recurrence (validation, tests, clearer exceptions, observability).
