# Your First Custom Instructions

This repository is an ASP.NET Core Web API project for a Learning Management System (LMS).

When working in this project:

- Prefer clean architecture boundaries: `Controllers` call `Services`, `Services` call `Repositories`, and data access stays in `Entities`/`LMSDbContext`.
- Keep API behavior consistent and predictable. Validate request input and return clear HTTP status codes.
- Use asynchronous patterns (`async`/`await`) for I/O and database operations.
- Keep methods small and focused. Favor readability and explicit naming over clever code.
- Add concise XML comments only when behavior is not obvious from code.
- Avoid introducing breaking changes to existing route contracts unless explicitly requested.
- Add or update tests when adding behavior or fixing defects.
- For bug fixes, explain root cause and why the change prevents regression.
- For security-sensitive changes, call out authentication, authorization, validation, and data exposure considerations.
