# Course API Reference

## Overview

The Course API manages Learning Management System courses. Courses are the primary organizational unit containing content and assessments.

## Entity Properties

| Property | Type | Required | Validation |
|----------|------|----------|-----------|
| Id | int | Yes (generated) | Primary key |
| Name | string | Yes | Min: 1 char, Max: 200 chars |
| Description | string | No | Max: varies |

## Endpoints

### GET /api/courses

Retrieve all courses.

**Authentication**: Yes (`[Authorize]`)

**Request**: None (no body)

**Query Parameters**: None

**Response** (200 OK):
```json
{
  "data": [
    {
      "id": 1,
      "name": "Introduction to C#",
      "description": "Learn the basics of C# programming"
    }
  ],
  "message": "Courses retrieved successfully.",
  "success": true
}
```

**Example**:
```bash
curl -X GET "https://localhost:5001/api/courses" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

---

### GET /api/courses/{id}

Retrieve a specific course by ID.

**Authentication**: Yes (`[Authorize]`)

**Path Parameters**:
- `id` (integer): The course ID

**Response** (200 OK):
```json
{
  "data": {
    "id": 1,
    "name": "Introduction to C#",
    "description": "Learn the basics of C# programming"
  },
  "message": "Course retrieved successfully.",
  "success": true
}
```

**Response** (404 Not Found):
```json
{
  "data": null,
  "message": "Course not found.",
  "success": false
}
```

**Example**:
```bash
curl -X GET "https://localhost:5001/api/courses/1" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

---

### GET /api/courses/{id}/details

Retrieve detailed information about a course.

**Authentication**: Yes (`[Authorize]`)

**Path Parameters**:
- `id` (integer): The course ID

**Response**: Same as GET /api/courses/{id}

**Notes**: This endpoint returns the same data as GET /api/courses/{id} but can be used for explicit detail requests in UI flows.

---

### POST /api/courses

Create a new course.

**Authentication**: Yes (`[Authorize]`)

**Request Body**:
```json
{
  "name": "Advanced C# Programming",
  "description": "Deep dive into C# advanced features"
}
```

**Validation Rules**:
- `name`: Required, 1-200 characters
- `description`: Optional, no length limit enforced at model level

**Response** (201 Created):
```json
{
  "data": {
    "id": 2,
    "name": "Advanced C# Programming",
    "description": "Deep dive into C# advanced features"
  },
  "message": "Course created successfully.",
  "success": true
}
```

**Response** (400 Bad Request):
```json
{
  "data": null,
  "message": "Course name is required.",
  "success": false
}
```

**Example**:
```bash
curl -X POST "https://localhost:5001/api/courses" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..." \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Advanced C# Programming",
    "description": "Deep dive into C# advanced features"
  }'
```

---

### PUT /api/courses/{id}

Update an existing course.

**Authentication**: Yes (`[Authorize]`)

**Path Parameters**:
- `id` (integer): The course ID to update

**Request Body**:
```json
{
  "id": 1,
  "name": "Intermediate C# Programming",
  "description": "Learn intermediate concepts"
}
```

**Validation Rules**:
- `id` in URL must match `id` in request body
- `name`: Required, 1-200 characters
- `description`: Optional

**Response** (200 OK):
```json
{
  "data": {
    "id": 1,
    "name": "Intermediate C# Programming",
    "description": "Learn intermediate concepts"
  },
  "message": "Course updated successfully.",
  "success": true
}
```

**Response** (400 Bad Request):
```json
{
  "data": null,
  "message": "Course ID in the URL does not match the ID in the request body.",
  "success": false
}
```

**Response** (404 Not Found):
```json
{
  "data": null,
  "message": "Course not found.",
  "success": false
}
```

**Example**:
```bash
curl -X PUT "https://localhost:5001/api/courses/1" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..." \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "name": "Intermediate C# Programming",
    "description": "Learn intermediate concepts"
  }'
```

---

### DELETE /api/courses/{id}

Delete a course.

**Authentication**: Yes (`[Authorize]`)

**Path Parameters**:
- `id` (integer): The course ID to delete

**Response** (200 OK):
```json
{
  "data": null,
  "message": "Course deleted successfully.",
  "success": true
}
```

**Response** (404 Not Found):
```json
{
  "data": null,
  "message": "Course not found.",
  "success": false
}
```

**Example**:
```bash
curl -X DELETE "https://localhost:5001/api/courses/1" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

---

## Status Codes

| Code | Meaning | Scenario |
|------|---------|----------|
| 200 | OK | Successful GET, PUT, DELETE |
| 201 | Created | Successful POST |
| 400 | Bad Request | Validation error or ID mismatch |
| 401 | Unauthorized | Missing/invalid auth token |
| 404 | Not Found | Course doesn't exist |
| 500 | Server Error | Unexpected server error |

## Authentication

All endpoints require JWT Bearer token authentication. Include the token in the `Authorization` header:

```
Authorization: Bearer <your_jwt_token>
```

## Error Handling

Errors follow a consistent format:

```json
{
  "data": null,
  "message": "Human-readable error description",
  "success": false
}
```

The `message` field describes the specific error condition.
