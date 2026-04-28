---
description: "Use when: creating or troubleshooting GitHub Actions workflows, CI checks, and automation."
---

# GitHub Actions Helper

When helping with GitHub Actions in this project:

- Prefer workflows that build and test this .NET solution on push and pull request.
- Use explicit action versions and pin major versions responsibly.
- Cache NuGet packages when it improves CI time without adding complexity.
- Keep secrets out of logs and never print sensitive values.
- Fail fast on build/test errors and surface clear diagnostics.
- Recommend matrix builds only when justified by target SDK or OS needs.
- Keep workflow files readable with minimal duplication.
