# Endpoint Documentation Template

Use this template when creating documentation for new LMS API endpoints.

## Endpoint: [HTTP METHOD] [ROUTE]

**Summary**: One-sentence description of what this endpoint does

**Authentication**: Yes/No (`[Authorize]` attribute)

### Request

**Path Parameters** (if any):
- `paramName` (type): Description

**Query Parameters** (if any):
- `paramName` (type): Description
- `paramName` (type): Optional? Description

**Request Body** (if any):
```json
{
  "propertyName": "type - description",
  "requiredProperty": "type - description, required"
}
```

### Response

**Response** (200 OK / 201 Created):
```json
{
  "data": { /* entity or list */ },
  "message": "Success message",
  "success": true
}
```

**Response** (400 Bad Request - if applicable):
```json
{
  "data": null,
  "message": "Validation error description",
  "success": false
}
```

**Response** (404 Not Found - if applicable):
```json
{
  "data": null,
  "message": "Resource not found",
  "success": false
}
```

### Validation Rules

- `propertyName`: Required/Optional, constraints (length, format, etc.)
- `anotherProperty`: Required/Optional, constraints
- Explanation of business logic validation if applicable

### Status Codes

| Code | Condition |
|------|-----------|
| 200 | Successful GET, PUT, DELETE |
| 201 | Successful POST (resource created) |
| 400 | Bad request or validation failure |
| 401 | Authentication required but not provided |
| 404 | Resource not found |
| 500 | Server error |

### Example Request

```bash
curl -X [METHOD] "https://localhost:5001/api/[endpoint]" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "propertyName": "value"
  }'
```

### Example Response

```json
{
  "data": {
    "id": 1,
    "propertyName": "value"
  },
  "message": "Operation successful",
  "success": true
}
```

### Notes

- Any additional notes or considerations
- Related endpoints
- Performance characteristics
- Rate limiting (if applicable)
- Deprecation warnings (if applicable)
