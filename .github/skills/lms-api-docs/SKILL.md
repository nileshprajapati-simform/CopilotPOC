---
name: lms-api-docs
description: 'Generate and maintain API documentation for LMS endpoints. Use when creating API reference docs, endpoint usage guides, request/response examples, or updating documentation to reflect code changes. Covers authentication, validation, error handling, and status codes for Course and Quiz APIs.'
---

# LMS API Documentation Skill

Generate clear, developer-friendly API documentation for the Learning Management System endpoints.

## When to Use This Skill

- Creating or updating API reference documentation
- Documenting new Course or Quiz endpoints
- Adding request/response payload examples
- Documenting authentication and authorization requirements
- Explaining error codes and validation rules
- Creating OpenAPI/Swagger specifications
- Generating integration guides for API consumers

## Project Context

The LMS Web API follows clean architecture:

```
Controllers → Services → Repositories → Entities (DbContext)
```

- **Authentication**: JWT Bearer tokens via `[Authorize]` attribute
- **Response Format**: Wrapped in `ApiResponse<T>` with status message
- **Database**: Entity Framework Core with SQL Server
- **Async**: All I/O operations use async/await patterns

## Endpoint Documentation Template

### Endpoint: [HTTP Method] [Route]

**Summary**: Brief description of what the endpoint does

**Authentication**: `[Authorize]` required? Yes/No

**Request**:
```json
{
  "propertyName": "type and description",
  "required": "yes/no"
}
```

**Response** (200 OK):
```json
{
  "data": { /* entity or list */ },
  "message": "Success message",
  "success": true
}
```

**Status Codes**:
- `200 OK`: Successful operation
- `400 Bad Request`: Validation failed
- `401 Unauthorized`: Missing/invalid auth token
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error

**Validation Rules**:
- List any `[Required]`, `[StringLength]`, or custom validation rules
- Explain what triggers validation errors

**Example Usage**:
```bash
curl -X GET "https://api.example.com/api/courses/1" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Current LMS Endpoints to Document

### Course Endpoints

1. **GET /api/courses** - Retrieve all courses
2. **GET /api/courses/{id}** - Get course by ID
3. **GET /api/courses/{id}/details** - Get course details
4. **POST /api/courses** - Create a course
5. **PUT /api/courses/{id}** - Update a course
6. **DELETE /api/courses/{id}** - Delete a course

### Quiz Endpoints

1. **GET /api/quizzes** - Retrieve all quizzes
2. **GET /api/quizzes/{id}** - Get quiz by ID
3. **POST /api/quizzes** - Create a quiz
4. **PUT /api/quizzes/{id}** - Update a quiz
5. **DELETE /api/quizzes/{id}** - Delete a quiz

## Documentation Guidelines

### Accuracy
- Document actual behavior, not intended behavior
- Verify status codes against controller implementation
- Check validation rules in entities and models
- Confirm async/await patterns are correctly described

### Clarity
- Use simple, technical language
- Provide realistic examples with actual properties
- Explain why errors occur, not just that they occur
- Include both happy-path and error scenarios

### Completeness
- Document all path parameters, query parameters, and body properties
- Explain required vs. optional fields
- Describe relationships between endpoints (e.g., Course and related Quizzes)
- Note pagination or filtering support if applicable

## Supporting Files

This skill includes:
- **SKILL.md**: This instruction file
- **references/course-api.md**: Course API detailed reference
- **references/quiz-api.md**: Quiz API detailed reference
- **templates/endpoint-template.md**: Reusable documentation template

## Best Practices

1. **Sync with Code**: After code changes, update documentation immediately
2. **Test Examples**: Run examples manually to ensure they work
3. **Consistent Formatting**: Use the provided template for all endpoints
4. **Version Tracking**: Note API version if using versioning
5. **Deprecation Notes**: Mark deprecated endpoints clearly
6. **Performance Notes**: Document timeout, size limits, or rate limits if applicable

## Common Patterns in LMS

### ApiResponse Wrapper

All endpoints return data wrapped in `ApiResponse<T>`:

```csharp
public class ApiResponse<T>
{
    public T Data { get; set; }
    public string Message { get; set; }
    public bool Success { get; set; }
}
```

### Null Handling

Resources that are not found return:
- HTTP Status: `404 Not Found`
- Data: `null`
- Success: `false`
- Message: "Course not found." or similar

### Validation

Request validation errors return:
- HTTP Status: `400 Bad Request`
- Data: `null`
- Success: `false`
- Message: Specific validation error message

## Output Requirements

When generating documentation, provide:

1. **Document Summary**: What was documented and why
2. **Endpoint List**: Table of documented endpoints with methods/routes
3. **Key Updates**: Notable changes from previous documentation
4. **Validation Checklist**:
   - [ ] All endpoints included
   - [ ] Status codes verified
   - [ ] Examples tested
   - [ ] Validation rules documented
   - [ ] Authentication requirements clear
5. **File References**: Which documentation files were created/updated

## Next Steps

After documentation is generated:
1. Review for accuracy against current code
2. Add to README.md or API_DOCUMENTATION.md
3. Consider creating OpenAPI/Swagger specs
4. Share with API consumers and gather feedback
