---
description: 'Coding standards for LMS API documentation and test writing'
applyTo: '**/*.md, **/docs/**'
---

# LMS API Documentation Standards

This instruction file provides guidelines for documenting LMS API endpoints and writing API tests.

## When These Standards Apply

- Creating or updating API documentation files
- Writing request/response examples
- Documenting endpoint parameters, status codes, and error cases
- Creating API usage guides and reference documentation
- Writing API test specifications

## Core Documentation Principles

### 1. Endpoint Documentation Structure

Every documented endpoint MUST include:

#### Header
- Method and path (e.g., `GET /api/courses/{id}`)
- Brief one-line purpose
- Authentication requirement (if any)

#### Parameters
- **Path Parameters**: URL variables (e.g., `{id}`)
- **Query Parameters**: Filtering, pagination, sorting
- **Body Parameters**: For POST/PUT requests
- **Headers**: Authorization, Content-Type requirements

#### Request Example
- Complete HTTP request with headers
- Sample JSON body (if applicable)
- Real values that can be tested

#### Response Examples
- Success response (200, 201)
- Validation error response (400)
- Authentication error response (401)
- Not found response (404)
- Server error response (500)

#### Status Codes
Clear explanation of each possible status code:
- `200 OK`: Successful GET, return resource(s)
- `201 Created`: Successful POST, resource created
- `204 No Content`: Successful DELETE or update with no return
- `400 Bad Request`: Validation failed, missing/invalid parameters
- `401 Unauthorized`: Missing or invalid authentication
- `404 Not Found`: Resource does not exist
- `500 Internal Server Error`: Server error

### 2. Example Format

```markdown
## GET /api/courses/{id}

Retrieve a single course by ID.

### Authentication
Required: Bearer token

### Parameters

| Name | Type | Location | Description |
|------|------|----------|-------------|
| id | integer | path | Course identifier |

### Request
\`\`\`http
GET /api/courses/1
Authorization: Bearer <token>
Content-Type: application/json
\`\`\`

### Response - 200 OK
\`\`\`json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Introduction to C#",
    "description": "Learn C# fundamentals",
    "instructor": "John Doe",
    "enrollmentCount": 45
  },
  "message": null
}
\`\`\`

### Response - 404 Not Found
\`\`\`json
{
  "success": false,
  "data": null,
  "message": "Course with ID 999 not found"
}
\`\`\`
```

### 3. Response Format Standards

All API responses follow the `ApiResponse<T>` pattern:

```json
{
  "success": true|false,
  "data": <T>|null,
  "message": string|null
}
```

- `success`: Boolean indicating request success
- `data`: Response payload (null on error)
- `message`: Error or informational message

### 4. Common HTTP Status Codes

| Code | Use Case | Example |
|------|----------|---------|
| 200 | GET success, return data | Getting a course |
| 201 | POST success, resource created | Creating a new course |
| 400 | Validation error, bad input | Missing required field |
| 401 | Missing/invalid authentication | No Bearer token |
| 404 | Resource not found | Course ID doesn't exist |
| 500 | Server error | Database exception |

## API Testing Standards

### Test Structure

1. **Setup**: Create test data, initialize client
2. **Execute**: Call the endpoint with test input
3. **Assert**: Verify response status code and body
4. **Cleanup**: Delete test data (if needed)

### Example Test Cases for Each Endpoint

For every endpoint, create tests for:

- ✅ **Happy Path**: Valid input returns 200/201
- ❌ **Validation Error**: Invalid input returns 400
- 🔒 **Authentication Error**: No token returns 401
- 🚫 **Not Found**: Missing resource returns 404
- ⚠️ **Edge Cases**: Boundary values, special characters

### Naming Convention

```
Test_<Endpoint>_<Scenario>_<ExpectedResult>
```

Examples:
- `Test_GetCourse_ValidId_Returns200WithCourse`
- `Test_GetCourse_InvalidId_Returns404`
- `Test_CreateCourse_MissingName_Returns400`

### Parameter Validation Documentation

When documenting parameters, always include:

- **Required**: Whether the parameter is mandatory
- **Type**: Data type (string, integer, boolean, etc.)
- **Format**: Additional format constraints (email, UUID, enum values)
- **Example**: Sample valid value
- **Validation Rules**: Constraints (max length, min value, pattern)

Example:

| Parameter | Type | Required | Validation | Example |
|-----------|------|----------|-----------|---------|
| name | string | Yes | 1-100 chars | "Advanced C#" |
| description | string | No | Max 500 chars | "Advanced..." |
| enrollmentLimit | integer | No | > 0 | 100 |

## Quality Checklist

- [ ] All endpoints are documented
- [ ] Request/response examples are valid and runnable
- [ ] All status codes are documented
- [ ] Parameter validation rules are clear
- [ ] Error responses include error codes/messages
- [ ] Authentication requirements are stated
- [ ] Examples use realistic, testable values
- [ ] Documentation is current with code
- [ ] Response format follows `ApiResponse<T>` pattern
- [ ] Test cases cover happy path, errors, and edge cases

## Common Pitfalls to Avoid

❌ **Don't**:
- Document only happy path without error cases
- Use placeholder values that can't be tested
- Leave authentication requirements unclear
- Return inconsistent HTTP status codes
- Include sensitive data in examples
- Forget to document required vs optional parameters

✅ **Do**:
- Document all possible status codes
- Use real, meaningful test values
- Clearly state authentication needs
- Follow standard HTTP status code meanings
- Use sanitized, example data only
- Explicitly mark required parameters
