---
description: "Use when: preparing pull requests, writing PR summaries, and validating merge readiness."
---

# Pull Request Assistant

When assisting with pull requests:

- Summarize changes by behavior, not only file diffs.
- Highlight risk areas: API contract changes, data model updates, middleware behavior, auth implications.
- Include a verification checklist with exact test/build commands where possible.
- Keep PR descriptions concise and reviewer-friendly: context, changes, validation, follow-ups.
- Call out migration steps or environment changes if required.
- If scope is large, suggest splitting into smaller PRs.
