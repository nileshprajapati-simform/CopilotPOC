---
description: 'Prompt for creating a new LMS API endpoint from specification'
---

# Create LMS API Endpoint

## Your Mission

You are tasked with implementing a new LMS API endpoint. This prompt guides you through the design, implementation, testing, and documentation of the endpoint while following clean architecture patterns.

## Step 1: Understand the Specification

Before writing code, gather the following information:

- **Endpoint Purpose**: What does this endpoint do? (e.g., "Create a new course")
- **HTTP Method**: GET, POST, PUT, DELETE, PATCH?
- **Route Path**: The URL path (e.g., `/api/courses`, `/api/courses/{id}`)
- **Input Requirements**: What parameters/body does it accept?
- **Output Expectations**: What should it return?
- **Authentication**: Is authentication required?
- **Status Codes**: What success/error codes should it return?
- **Related Endpoints**: Are there related endpoints that follow patterns I should match?

**Ask the user for clarification on any of these points if not provided.**

## Step 2: Design the Endpoint

Follow this design process:

### 2a. Analyze Existing Patterns
- Review similar endpoints in `Controllers/` directory
- Check `Services/` for reusable business logic
- Look at `Repositories/` for data access patterns
- Verify response format matches `Models/ApiResponse.cs`

### 2b. Plan the Architecture Flow
Document how your endpoint will flow:

```
HTTP Request
  ↓
Controller (validate, authorize, call service)
  ↓
Service (business logic)
  ↓
Repository (data access)
  ↓
Database
```

### 2c. Identify Required Changes
- Which Controller needs the new endpoint?
- Does the Service need a new method?
- Does the Repository need a new query?
- Do we need a new Model class?
- Are there any Entity updates needed?

## Step 3: Implement the Endpoint

### 3a. Implement in Order
1. **Service Method**: Write the business logic (async)
2. **Repository Method**: Write the data access query (async)
3. **Controller Action**: Write the HTTP endpoint
4. **Models**: Add any required request/response models

### 3b. Code Quality Standards
- Use `async`/`await` for all I/O operations
- Validate input in the Controller
- Return appropriate HTTP status codes
- Include XML comments for public methods
- Keep methods small and focused
- Use meaningful variable names
- Follow existing code style

### 3c. Implementation Checklist
- [ ] Service method is `async Task<>`
- [ ] Repository method is `async Task<>`
- [ ] Controller action is `async Task<IActionResult>`
- [ ] All HTTP status codes are handled
- [ ] Input is validated before processing
- [ ] Response follows `ApiResponse<T>` format
- [ ] XML comments document the public API
- [ ] No breaking changes to existing routes

## Step 4: Write Tests

Create at least these test scenarios:

1. **Happy Path**: Valid input returns expected result with 200/201
2. **Validation Error**: Missing required field returns 400
3. **Not Found**: Resource doesn't exist returns 404
4. **Authentication Error**: No auth token returns 401
5. **Edge Case**: Boundary values or special inputs

**Test Format**:
```csharp
[Fact]
public async Task Create_ValidCourse_Returns201WithId()
{
    // Arrange
    var request = new { Name = "C# Basics", Instructor = "John" };
    
    // Act
    var response = await _httpClient.PostAsync("/api/courses", ...);
    
    // Assert
    Assert.Equal(HttpStatusCode.Created, response.StatusCode);
}
```

## Step 5: Document the Endpoint

Create endpoint documentation following the `api-documentation.instructions.md` standards:

- **Endpoint**: Method and path
- **Purpose**: One-line description
- **Authentication**: Required or not
- **Parameters**: All inputs (path, query, body)
- **Request Example**: Complete HTTP request
- **Response Examples**: Success and error cases
- **Status Codes**: Each code with explanation

Example:
```markdown
## POST /api/courses

Create a new course.

### Request
\`\`\`json
{
  "name": "Advanced C#",
  "instructor": "Jane Smith",
  "description": "Learn advanced C# patterns"
}
\`\`\`

### Response - 201 Created
\`\`\`json
{
  "success": true,
  "data": {
    "id": 5,
    "name": "Advanced C#",
    ...
  }
}
\`\`\`

### Response - 400 Bad Request
\`\`\`json
{
  "success": false,
  "message": "Course name is required"
}
\`\`\`
```

## Step 6: Verify and Validate

- [ ] All tests pass
- [ ] No compiler errors
- [ ] Endpoint follows clean architecture
- [ ] Response format is consistent
- [ ] Status codes are correct
- [ ] Input validation is complete
- [ ] Documentation is accurate
- [ ] No breaking changes to existing routes
- [ ] Code review checklist passes

## Step 7: Provide Summary

After implementation, provide:

1. **What Was Done**: Brief description of changes
2. **Files Modified**: List all edited files
3. **New Classes/Methods**: List significant new code
4. **Tests Written**: Summary of test coverage
5. **Documentation Updated**: What documentation changed
6. **Validation Status**: All tests passing? ✅
7. **Next Steps**: Any follow-up work needed

## Common Patterns and Examples

### Pattern: GET Single Resource
```csharp
[HttpGet("{id}")]
public async Task<IActionResult> GetById(int id)
{
    var item = await _service.GetByIdAsync(id);
    if (item == null) return NotFound(new ApiResponse<object> { Message = "Not found" });
    return Ok(new ApiResponse<Item> { Data = item });
}
```

### Pattern: POST Create Resource
```csharp
[HttpPost]
public async Task<IActionResult> Create(CreateItemRequest request)
{
    if (string.IsNullOrWhiteSpace(request.Name)) 
        return BadRequest(new ApiResponse<object> { Message = "Name required" });
    
    var item = await _service.CreateAsync(request);
    return CreatedAtAction(nameof(GetById), new { id = item.Id }, new ApiResponse<Item> { Data = item });
}
```

### Pattern: Input Validation
```csharp
if (string.IsNullOrWhiteSpace(request.Name) || request.Name.Length > 100)
    return BadRequest(new { Message = "Name must be 1-100 characters" });

if (request.Count <= 0)
    return BadRequest(new { Message = "Count must be greater than 0" });
```

## HTTP Status Code Reference

- **200 OK**: GET success
- **201 Created**: POST success
- **204 No Content**: DELETE success, no body
- **400 Bad Request**: Validation failed
- **401 Unauthorized**: Auth required, missing/invalid token
- **404 Not Found**: Resource doesn't exist
- **500 Internal Server Error**: Unhandled exception

## Need Help?

If you encounter issues:
1. Check existing similar endpoints for patterns
2. Review the Architecture guidelines in copilot-instructions.md
3. Look at existing tests for examples
4. Check clean architecture: does your change violate layer boundaries?
