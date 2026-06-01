# Course Endpoints — API Reference

Base URL: `https://<host>/api/course`

All Course endpoints require **JWT Bearer authentication** (see [Authentication](#authentication)).  
All responses use the `ApiResponse<T>` envelope:

```json
{ "message": "<human-readable message>", "data": <payload or null> }
```

Validation errors use the flat `ApiResponse` format:

```json
{ "statusCode": 400, "message": "Validation failed.", "errors": ["<error 1>", ...] }
```

---

## Authentication

Every request must include a valid JWT token in the `Authorization` header:

```
Authorization: Bearer <your-jwt-token>
```

Missing or expired tokens return **HTTP 401** with no body.

---

## Endpoints

| Method   | Route                  | Description              | Auth Required |
|----------|------------------------|--------------------------|---------------|
| `GET`    | `/api/course`          | List all courses         | ✅ Yes        |
| `GET`    | `/api/course/{id}`     | Get a course by ID       | ✅ Yes        |
| `POST`   | `/api/course`          | Create a new course      | ✅ Yes        |
| `PUT`    | `/api/course/{id}`     | Update an existing course| ✅ Yes        |
| `DELETE` | `/api/course/{id}`     | Delete a course          | ✅ Yes        |

---

## GET /api/course

Returns all courses.

### Response — 200 OK

```json
{
  "message": "Courses retrieved successfully.",
  "data": [
    {
      "id": 1,
      "name": "Introduction to C#...",
      "description": "Beginner C# course."
    },
    {
      "id": 2,
      "name": "Advanced ASP.NET Core...",
      "description": "Deep dive into ASP.NET Core."
    }
  ]
}
```

### Error Responses

| Status | Scenario                        |
|--------|---------------------------------|
| 401    | Missing or invalid Bearer token |

---

## GET /api/course/{id}

Returns a single course by its integer ID.

### Path Parameters

| Parameter | Type  | Required | Description          |
|-----------|-------|----------|----------------------|
| `id`      | `int` | Yes      | Unique course ID     |

### Response — 200 OK

```json
{
  "message": "Course retrieved successfully.",
  "data": {
    "id": 1,
    "name": "Introduction to C#...",
    "description": "Beginner C# course."
  }
}
```

### Error Responses

| Status | Scenario                                |
|--------|-----------------------------------------|
| 401    | Missing or invalid Bearer token         |
| 404    | No course found with the specified `id` |

#### 404 Example

```json
{
  "message": "Course not found.",
  "data": null
}
```

---

## POST /api/course

Creates a new course. Returns the created resource with its assigned `id`.

### Request Body (`application/json`)

| Field         | Type     | Required | Constraints              |
|---------------|----------|----------|--------------------------|
| `name`        | `string` | Yes      | Max 200 characters       |
| `description` | `string` | No       | Free text                |

> **Note:** Omit `id` or set it to `0`. The server assigns the ID.

#### Sample Request

```json
{
  "name": "Introduction to C#",
  "description": "A beginner-friendly course covering C# fundamentals."
}
```

### Response — 201 Created

The `Location` response header points to the newly created resource (e.g. `/api/course/3`).

```json
{
  "message": "Course created successfully.",
  "data": {
    "id": 3,
    "name": "Introduction to C#...",
    "description": "A beginner-friendly course covering C# fundamentals."
  }
}
```

### Error Responses

| Status | Scenario                                     |
|--------|----------------------------------------------|
| 400    | Validation failure (e.g. `Name` is missing)  |
| 401    | Missing or invalid Bearer token              |

#### 400 Example — Missing Name

```json
{
  "statusCode": 400,
  "message": "Validation failed.",
  "errors": ["Course name is required."]
}
```

---

## PUT /api/course/{id}

Updates an existing course. The `id` in the URL **must match** the `id` field in the request body.

### Path Parameters

| Parameter | Type  | Required | Description                        |
|-----------|-------|----------|------------------------------------|
| `id`      | `int` | Yes      | Unique ID of the course to update  |

### Request Body (`application/json`)

| Field         | Type     | Required | Constraints                         |
|---------------|----------|----------|-------------------------------------|
| `id`          | `int`    | Yes      | Must match the `{id}` path param    |
| `name`        | `string` | Yes      | Max 200 characters                  |
| `description` | `string` | No       | Free text                           |

#### Sample Request (PUT /api/course/1)

```json
{
  "id": 1,
  "name": "Introduction to C# — Updated",
  "description": "Updated description for the C# course."
}
```

### Response — 200 OK

```json
{
  "message": "Course updated successfully.",
  "data": {
    "id": 1,
    "name": "Introduction to C# — Updated...",
    "description": "Updated description for the C# course."
  }
}
```

### Error Responses

| Status | Scenario                                              |
|--------|-------------------------------------------------------|
| 400    | `id` in URL does not match `id` in body               |
| 401    | Missing or invalid Bearer token                       |
| 404    | No course found with the specified `id`               |

#### 400 Example — ID Mismatch

```json
{
  "message": "Course ID in the URL does not match the ID in the request body.",
  "data": null
}
```

#### 404 Example

```json
{
  "message": "Course not found.",
  "data": null
}
```

---

## DELETE /api/course/{id}

Permanently deletes a course.

### Path Parameters

| Parameter | Type  | Required | Description                       |
|-----------|-------|----------|-----------------------------------|
| `id`      | `int` | Yes      | Unique ID of the course to delete |

### Response — 200 OK

```json
{
  "message": "Course deleted successfully.",
  "data": null
}
```

### Error Responses

| Status | Scenario                                |
|--------|-----------------------------------------|
| 401    | Missing or invalid Bearer token         |
| 404    | No course found with the specified `id` |

#### 404 Example

```json
{
  "message": "Course not found.",
  "data": null
}
```

---

## Data Model — Course

| Field         | Type     | Description                               |
|---------------|----------|-------------------------------------------|
| `id`          | `int`    | Unique identifier (auto-assigned on POST) |
| `name`        | `string` | Course name. Required, max 200 characters |
| `description` | `string` | Optional free-text description            |

---

## Error Reference

| HTTP Status | Meaning                                                                       |
|-------------|-------------------------------------------------------------------------------|
| 200         | Request succeeded                                                             |
| 201         | Resource created successfully                                                 |
| 400         | Bad request — validation error or ID mismatch                                 |
| 401         | Unauthorized — missing, expired, or invalid JWT Bearer token                  |
| 404         | Not found — the specified course does not exist                               |
| 500         | Internal server error — unexpected failure; see `detail` field in response    |

### 500 Example (ProblemDetails)

```json
{
  "type": null,
  "title": "An unexpected error occurred.",
  "status": 500,
  "detail": "<exception message>",
  "instance": "/api/course"
}
```
