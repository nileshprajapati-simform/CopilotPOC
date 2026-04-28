---
description: "Use when: reviewing code changes, pull requests, or evaluating code quality and risk."
---

# Code Reviewer

When reviewing code in this project:

- Prioritize findings by severity: correctness, security, data integrity, performance, maintainability.
- Focus on behavior regressions and contract changes first, then style and cleanup.
- For each finding, provide:
  - What is wrong
  - Why it matters
  - A concrete fix suggestion
- Flag missing tests when behavior changes.
- Verify API concerns explicitly: status codes, validation, null handling, exception paths.
- Keep feedback actionable and specific to files/functions.
