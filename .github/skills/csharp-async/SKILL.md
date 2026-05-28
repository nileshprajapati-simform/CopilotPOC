---
name: csharp-async
description: 'Get best practices for C# async programming. Use when reviewing, writing, or refactoring asynchronous C# code, especially for Task-based APIs, cancellation, concurrency, and avoiding blocking calls.'
---

# C# Async Programming Best Practices

Use this skill when you need to write, review, or refactor asynchronous C# code.

## Naming Conventions

- Use the `Async` suffix for all async methods.
- Match method names with their synchronous counterparts when applicable, such as `GetDataAsync()` for `GetData()`.

## Return Types

- Return `Task<T>` when the method returns a value.
- Return `Task` when the method does not return a value.
- Consider `ValueTask<T>` only for high-performance scenarios where allocations matter and the usage pattern justifies it.
- Avoid returning `void` from async methods except for event handlers.

## Exception Handling

- Use `try`/`catch` around awaited operations when you need to translate, log, or enrich exceptions.
- Avoid swallowing exceptions in async methods.
- Use `ConfigureAwait(false)` in library code when you do not need the captured context.
- Prefer `Task.FromException()` for faulted task creation in async APIs instead of throwing before the task is returned.

## Performance

- Use `Task.WhenAll()` to run independent operations in parallel.
- Use `Task.WhenAny()` for timeouts or first-completed scenarios.
- Avoid unnecessary `async`/`await` when a method is only passing through an existing task result.
- Use cancellation tokens for long-running operations.

## Common Pitfalls

- Never use `.Wait()`, `.Result`, or `.GetAwaiter().GetResult()` in async code.
- Avoid mixing blocking and async code.
- Do not create `async void` methods except for event handlers.
- Always await `Task`-returning methods.

## Implementation Patterns

- Use the Task-based Asynchronous Pattern (TAP) for public APIs.
- Use async streams (`IAsyncEnumerable<T>`) for asynchronous sequence processing.
- Pass `CancellationToken` through layered calls whenever the operation may run for a long time or be cancelled.
- Prefer composing small async methods over creating large methods that do many unrelated awaits.

## Review Checklist

When reviewing C# code, look for:

- Missing `Async` suffixes on async methods
- Blocking calls inside async code
- Fire-and-forget patterns that are not intentional
- Missing cancellation support for long-running work
- Unnecessary context capture in library code
- Opportunities to use `Task.WhenAll()` for independent work

## Output

When you apply this skill, summarize the async issues you found and suggest concrete code changes that follow these best practices.
