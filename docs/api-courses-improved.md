# Course Endpoints — API Reference

**Base URL**: `https://<host>/api/course`

**Authentication**: All endpoints require JWT Bearer token in Authorization header

---

## API Response Format

All endpoints return a consistent response structure:

```json
{
  "success": true,
  "data": <payload>,
  "message": null
}
```

**Fields**:
- `success`: Boolean indicating request success
- `data`: Response payload (null on error)
- `message`: Error or informational message

---

## Authentication

Every request requires a valid JWT Bearer token:

```
Authorization: Bearer <your-jwt-token>
```

**Status Code 401**: Missing, expired, or invalid token

---

## GET /api/course

List all courses.

### Authentication
✅ Required: Bearer token

### Parameters
None

### Request
```http
GET /api/course
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

### Response — 200 OK

Success response with list of courses:

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Introduction to C#",
      "description": "Learn C# fundamentals",
      "instructor": "John Doe",
      "enrollmentCount": 45
    },
    {
      "id": 2,
      "name": "Advanced .NET",
      "description": "Advanced .NET development",
      "instructor": "Jane Smith",
      "enrollmentCount": 32
    }
  ],
  "message": null
}
```

### Response — 401 Unauthorized

No valid authentication token:

```json
{
  "success": false,
  "data": null,
  "message": "Missing or invalid authentication token"
}
```

### Status Codes
| Code | Meaning | Scenario |
|------|---------|----------|
| 200 | OK | Successfully retrieved courses |
| 401 | Unauthorized | Missing or invalid bearer token |
| 500 | Server Error | Internal server error |

---

## GET /api/course/{id}

Retrieve a single course by ID.

### Authentication
✅ Required: Bearer token

### Parameters

| Name | Type | Location | Required | Validation | Example |
|------|------|----------|----------|-----------|---------|
| id | integer | path | Yes | > 0 | 1 |

### Request
```http
GET /api/course/1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

### Response — 200 OK

Successfully retrieved course:

```json
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
```

### Response — 400 Bad Request

Invalid course ID format:

```json
{
  "success": false,
  "data": null,
  "message": "Course ID must be a positive integer"
}
```

### Response — 404 Not Found

Course does not exist:

```json
{
  "success": false,
  "data": null,
  "message": "Course with ID 999 not found"
}
```

### Response — 401 Unauthorized

Missing authentication:

```json
{
  "success": false,
  "data": null,
  "message": "Missing or invalid authentication token"
}
```

### Status Codes
| Code | Meaning | Scenario |
|------|---------|----------|
| 200 | OK | Course found and returned |
| 400 | Bad Request | Invalid ID format |
| 401 | Unauthorized | Missing/invalid bearer token |
| 404 | Not Found | Course does not exist |
| 500 | Server Error | Internal server error |

---

## POST /api/course

Create a new course.

### Authentication
✅ Required: Bearer token

### Parameters

| Name | Type | Location | Required | Validation | Example |
|------|------|----------|----------|-----------|---------|
| name | string | body | Yes | 1-100 characters | "Advanced C#" |
| description | string | body | No | Max 500 characters | "Learn advanced patterns..." |
| instructor | string | body | Yes | 1-100 characters | "Jane Smith" |
| enrollmentLimit | integer | body | No | > 0 | 100 |

### Request
```http
POST /api/course
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "name": "Advanced C#",
  "description": "Learn advanced C# design patterns and best practices",
  "instructor": "Jane Smith",
  "enrollmentLimit": 50
}
```

### Response — 201 Created

Course successfully created:

```json
{
  "success": true,
  "data": {
    "id": 3,
    "name": "Advanced C#",
    "description": "Learn advanced C# design patterns and best practices",
    "instructor": "Jane Smith",
    "enrollmentCount": 0,
    "enrollmentLimit": 50
  },
  "message": "Course created successfully"
}
```

### Response — 400 Bad Request

Validation failed - missing required field:

```json
{
  "success": false,
  "data": null,
  "message": "Course name is required (1-100 characters)"
}
```

### Response — 401 Unauthorized

Missing authentication:

```json
{
  "success": false,
  "data": null,
  "message": "Missing or invalid authentication token"
}
```

### Status Codes
| Code | Meaning | Scenario |
|------|---------|----------|
| 201 | Created | Course successfully created |
| 400 | Bad Request | Validation failed (missing/invalid fields) |
| 401 | Unauthorized | Missing/invalid bearer token |
| 500 | Server Error | Internal server error |

---

## PUT /api/course/{id}

Update an existing course.

### Authentication
✅ Required: Bearer token

### Parameters

| Name | Type | Location | Required | Validation | Example |
|------|------|----------|----------|-----------|---------|
| id | integer | path | Yes | > 0 | 1 |
| name | string | body | No | 1-100 characters | "Updated Name" |
| description | string | body | No | Max 500 characters | "Updated description" |
| instructor | string | body | No | 1-100 characters | "New Instructor" |

### Request
```http
PUT /api/course/1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "name": "Intermediate C#",
  "instructor": "Sarah Johnson"
}
```

### Response — 200 OK

Course successfully updated:

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Intermediate C#",
    "description": "Learn C# fundamentals",
    "instructor": "Sarah Johnson",
    "enrollmentCount": 45
  },
  "message": "Course updated successfully"
}
```

### Response — 404 Not Found

Course does not exist:

```json
{
  "success": false,
  "data": null,
  "message": "Course with ID 999 not found"
}
```

### Response — 401 Unauthorized

Missing authentication:

```json
{
  "success": false,
  "data": null,
  "message": "Missing or invalid authentication token"
}
```

### Status Codes
| Code | Meaning | Scenario |
|------|---------|----------|
| 200 | OK | Course successfully updated |
| 400 | Bad Request | Validation failed |
| 401 | Unauthorized | Missing/invalid bearer token |
| 404 | Not Found | Course does not exist |
| 500 | Server Error | Internal server error |

---

## DELETE /api/course/{id}

Delete a course.

### Authentication
✅ Required: Bearer token

### Parameters

| Name | Type | Location | Required | Validation | Example |
|------|------|----------|----------|-----------|---------|
| id | integer | path | Yes | > 0 | 1 |

### Request
```http
DELETE /api/course/1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Response — 204 No Content

Course successfully deleted (no response body):

```http
HTTP/1.1 204 No Content
```

### Response — 404 Not Found

Course does not exist:

```json
{
  "success": false,
  "data": null,
  "message": "Course with ID 999 not found"
}
```

### Response — 401 Unauthorized

Missing authentication:

```json
{
  "success": false,
  "data": null,
  "message": "Missing or invalid authentication token"
}
```

### Status Codes
| Code | Meaning | Scenario |
|------|---------|----------|
| 204 | No Content | Course successfully deleted |
| 401 | Unauthorized | Missing/invalid bearer token |
| 404 | Not Found | Course does not exist |
| 500 | Server Error | Internal server error |

---

## Test Coverage

Below are recommended test cases for comprehensive API validation:

### GET /api/course Tests
- ✅ `Test_GetAllCourses_NoAuth_Returns401` - No bearer token
- ✅ `Test_GetAllCourses_ValidAuth_Returns200WithList` - Valid token, returns all courses
- ✅ `Test_GetAllCourses_ExpiredAuth_Returns401` - Expired token

### GET /api/course/{id} Tests
- ✅ `Test_GetCourseById_ValidId_Returns200` - Valid ID returns course
- ✅ `Test_GetCourseById_InvalidId_Returns404` - Non-existent ID
- ✅ `Test_GetCourseById_InvalidIdFormat_Returns400` - Non-integer ID
- ✅ `Test_GetCourseById_NoAuth_Returns401` - Missing authentication

### POST /api/course Tests
- ✅ `Test_CreateCourse_ValidData_Returns201` - All required fields provided
- ✅ `Test_CreateCourse_MissingName_Returns400` - Name field missing
- ✅ `Test_CreateCourse_InvalidNameLength_Returns400` - Name too long (>100 chars)
- ✅ `Test_CreateCourse_NoAuth_Returns401` - Missing authentication
- ✅ `Test_CreateCourse_DuplicateName_Returns400` - Duplicate course name (if validation enforced)

### PUT /api/course/{id} Tests
- ✅ `Test_UpdateCourse_ValidData_Returns200` - Valid update
- ✅ `Test_UpdateCourse_InvalidId_Returns404` - Non-existent course
- ✅ `Test_UpdateCourse_PartialUpdate_Returns200` - Update only some fields
- ✅ `Test_UpdateCourse_NoAuth_Returns401` - Missing authentication

### DELETE /api/course/{id} Tests
- ✅ `Test_DeleteCourse_ValidId_Returns204` - Valid deletion
- ✅ `Test_DeleteCourse_InvalidId_Returns404` - Non-existent course
- ✅ `Test_DeleteCourse_NoAuth_Returns401` - Missing authentication
