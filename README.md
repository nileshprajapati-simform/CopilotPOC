# LMSWebAPI Setup Guide

## Step 1: Create a New Git Branch
Create a new Git branch named `feature/lms-api-setup` from the latest `main` branch.

## Step 2: Create a Boilerplate .NET 8 Web API Project
Set up a boilerplate .NET 8 Web API project for a Learning Management System (LMS) with:
- Folders: Entities, Repositories, Services, Controllers, Middleware
- Add global exception handling middleware
- Setup basic logging using ILogger
- Add JWT Authentication (can use a dummy secret key for now)
- Create an initial DbContext called LMSDbContext

## Step 3: Create the following for LMS Web API:
Create the following for LMS Web API:

Entity:
- Quiz entity with properties: Id (int), Title (string), CourseId (int)

Database:
- Add DbSet<Quiz> in LMSDbContext

Repository:
- IQuizRepository
- QuizRepository implementing basic CRUD operations

Service:
- IQuizService
- QuizService implementing CRUD using the repository

Controller:
- QuizController with basic CRUD APIs (GET all, GET by Id, POST, PUT, DELETE)
- Use [Authorize] attribute on POST, PUT, DELETE endpoints

Dependency Injection:
- Register IQuizRepository, IQuizService in Program.cs

## Step 4: Create the following for LMS Web API:

Entity:
- Course entity with properties: Id (int), Name (string), Description (string)

Database:
- Add DbSet<Course> in LMSDbContext

Repository:
- ICourseRepository
- CourseRepository implementing basic CRUD operations

Service:
- ICourseService
- CourseService implementing CRUD using the repository

Controller:
- CourseController with basic CRUD APIs

Dependency Injection:
- Register ICourseRepository, ICourseService in Program.cs

## Step 5: Improve the LMS Web API by:
- Adding FluentValidation for request validation
- Improving exception handling to return ProblemDetails format
- Adding Swagger UI with JWT Bearer authentication support
- Protecting APIs with [Authorize] attributes

## GitHub Copilot Hooks

This repository includes production-oriented GitHub Copilot hook policies under `.github/hooks/` using the official hooks schema (`version: 1`).

### Hook files

- `.github/hooks/pr-validation.json`
	- Uses `preToolUse` to gate file mutation tools.
	- Executes `scripts/pr-validation.sh`.
	- Runs `dotnet build` and `dotnet test` before allowing edits.
	- Returns structured `permissionDecision` JSON (`allow` or `deny`) with a meaningful reason.

- `.github/hooks/code-review.json`
	- Uses `postToolUse` after mutation tools.
	- Executes `scripts/code-review.sh`.
	- Prints warnings for:
		- potential hardcoded secrets
		- direct `DbContext` usage in Controllers (clean architecture boundary concern)
		- async methods missing `await` (heuristic)

### Supporting scripts

- `scripts/pr-validation.sh`
	- Reusable pre-tool validation script.
	- Blocks `edit` and `create` when build/tests fail.

- `scripts/code-review.sh`
	- Reusable post-tool static check script.
	- Produces advisory warnings and audit logs in `.github/hooks/logs/code-review-warnings.log`.

### How hooks work

1. Copilot loads all JSON files under `.github/hooks/*.json`.
2. `preToolUse` hooks run before a tool executes and may deny execution.
3. `postToolUse` hooks run after execution for analysis and guidance.
4. For this repo, hooks reinforce .NET 8 quality gates and clean architecture constraints (Controller -> Service -> Repository).

### How to enable hooks

1. Keep `.github/hooks/*.json` on the default branch (`main`).
2. Ensure runtime dependencies are available:
	 - `dotnet` SDK (for build/test validation)
	 - `bash` and `python3` (for script execution)
	 - `rg` (ripgrep) for fast scanning
3. Start a Copilot agent session in this repository; hooks are auto-discovered.

### Linux/macOS executable permissions

Run the following once on Unix-like environments:

```bash
chmod +x scripts/pr-validation.sh
chmod +x scripts/code-review.sh
```

### How to test hooks locally

You can test scripts directly with sample hook payloads.

1. Test pre-tool validation allow path:

```bash
echo '{"toolName":"view","toolArgs":"{}"}' | ./scripts/pr-validation.sh
```

2. Test pre-tool validation gate path (runs build/tests):

```bash
echo '{"toolName":"edit","toolArgs":"{\"filePath\":\"Program.cs\"}"}' | ./scripts/pr-validation.sh
```

3. Test post-tool review checks:

```bash
echo '{"toolName":"edit","toolArgs":"{\"filePath\":\"Controllers/CourseController.cs\"}","toolResult":{"resultType":"success","textResultForLlm":"ok"}}' | ./scripts/code-review.sh
```

4. Review warnings log:

```bash
cat .github/hooks/logs/code-review-warnings.log
```

### Design notes

- Application business logic is not modified by these hook files.
- Hooks are separated by concern:
	- pre-edit quality gate (`pr-validation`)
	- post-edit policy checks (`code-review`)
- Checks align with repository/service pattern and clean architecture expectations for this .NET 8 Web API.
