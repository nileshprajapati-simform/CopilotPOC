# Quiz API Reference

## Overview

The Quiz API manages assessments within the Learning Management System. Quizzes are associated with courses and contain test questions and scoring logic.

## Entity Properties

| Property | Type | Required | Validation |
|----------|------|----------|-----------|
| Id | int | Yes (generated) | Primary key |
| Title | string | Yes | Required, non-empty |
| CourseId | int | Yes | Foreign key to Course |

## Endpoints

### GET /api/quizzes

Retrieve all quizzes.

**Authentication**: Yes (`[Authorize]`)

**Request**: None (no body)

**Query Parameters**: None

**Response** (200 OK):
```json
{
  "data": [
    {
      "id": 1,
      "title": "C# Basics Quiz",
      "courseId": 1
    }
  ],
  "message": "Quizzes retrieved successfully.",
  "success": true
}
```

**Example**:
```bash
curl -X GET "https://localhost:5001/api/quizzes" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

---

### GET /api/quizzes/{id}

Retrieve a specific quiz by ID.

**Authentication**: Yes (`[Authorize]`)

**Path Parameters**:
- `id` (integer): The quiz ID

**Response** (200 OK):
```json
{
  "data": {
    "id": 1,
    "title": "C# Basics Quiz",
    "courseId": 1
  },
  "message": "Quiz retrieved successfully.",
  "success": true
}
```

**Response** (404 Not Found):
```json
{
  "data": null,
  "message": "Quiz not found.",
  "success": false
}
```

**Example**:
```bash
curl -X GET "https://localhost:5001/api/quizzes/1" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

---

### POST /api/quizzes

Create a new quiz.

**Authentication**: Yes (`[Authorize]`)

**Request Body**:
```json
{
  "title": "Advanced C# Quiz",
  "courseId": 1
}
```

**Validation Rules**:
- `title`: Required, non-empty string
- `courseId`: Required, must reference existing course

**Response** (201 Created):
```json
{
  "data": {
    "id": 2,
    "title": "Advanced C# Quiz",
    "courseId": 1
  },
  "message": "Quiz created successfully.",
  "success": true
}
```

**Response** (400 Bad Request):
```json
{
  "data": null,
  "message": "Quiz title is required.",
  "success": false
}
```

**Example**:
```bash
curl -X POST "https://localhost:5001/api/quizzes" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..." \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Advanced C# Quiz",
    "courseId": 1
  }'
```

---

### PUT /api/quizzes/{id}

Update an existing quiz.

**Authentication**: Yes (`[Authorize]`)

**Path Parameters**:
- `id` (integer): The quiz ID to update

**Request Body**:
```json
{
  "id": 1,
  "title": "C# Fundamentals Quiz",
  "courseId": 1
}
```

**Validation Rules**:
- `id` in URL must match `id` in request body
- `title`: Required, non-empty string
- `courseId`: Must reference existing course

**Response** (200 OK):
```json
{
  "data": {
    "id": 1,
    "title": "C# Fundamentals Quiz",
    "courseId": 1
  },
  "message": "Quiz updated successfully.",
  "success": true
}
```

**Response** (404 Not Found):
```json
{
  "data": null,
  "message": "Quiz not found.",
  "success": false
}
```

**Example**:
```bash
curl -X PUT "https://localhost:5001/api/quizzes/1" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..." \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "title": "C# Fundamentals Quiz",
    "courseId": 1
  }'
```

---

### DELETE /api/quizzes/{id}

Delete a quiz.

**Authentication**: Yes (`[Authorize]`)

**Path Parameters**:
- `id` (integer): The quiz ID to delete

**Response** (200 OK):
```json
{
  "data": null,
  "message": "Quiz deleted successfully.",
  "success": true
}
```

**Response** (404 Not Found):
```json
{
  "data": null,
  "message": "Quiz not found.",
  "success": false
}
```

**Example**:
```bash
curl -X DELETE "https://localhost:5001/api/quizzes/1" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

---

## Status Codes

| Code | Meaning | Scenario |
|------|---------|----------|
| 200 | OK | Successful GET, PUT, DELETE |
| 201 | Created | Successful POST |
| 400 | Bad Request | Validation error |
| 401 | Unauthorized | Missing/invalid auth token |
| 404 | Not Found | Quiz doesn't exist |
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

## Relationships

Quizzes are associated with Courses via the `courseId` property. When a course is deleted, consider handling quiz cleanup (cascade delete or soft delete based on business rules).
