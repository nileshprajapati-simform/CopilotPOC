using LMSWebAPI.Entities;
using LMSWebAPI.Models;
using LMSWebAPI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace LMSWebAPI.Controllers;

/// <summary>
/// Manages course resources in the LMS.
/// </summary>
/// <remarks>
/// All endpoints require a valid JWT Bearer token in the <c>Authorization: Bearer &lt;token&gt;</c> header.
/// Responses follow the <c>ApiResponse&lt;T&gt;</c> envelope: <c>{ "message": "...", "data": ... }</c>.
/// </remarks>
[ApiController]
[Route("api/[controller]")]
[Authorize]
[Produces("application/json")]
public class CourseController : ControllerBase
{
    private readonly ICourseService _courseService;

    public CourseController(ICourseService courseService)
    {
        _courseService = courseService;
    }

    /// <summary>
    /// Retrieves all courses.
    /// </summary>
    /// <returns>A list of all courses.</returns>
    /// <remarks>
    /// Sample response:
    /// <code>
    /// {
    ///   "message": "Courses retrieved successfully.",
    ///   "data": [
    ///     { "id": 1, "name": "Introduction to C#...", "description": "Beginner C# course." },
    ///     { "id": 2, "name": "Advanced ASP.NET Core...", "description": "Deep dive into ASP.NET Core." }
    ///   ]
    /// }
    /// </code>
    /// </remarks>
    /// <response code="200">Returns the list of all courses.</response>
    /// <response code="401">Missing or invalid JWT Bearer token.</response>
    [HttpGet]
    [ProducesResponseType(typeof(ApiResponse<IEnumerable<Course>>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetAll()
    {
        var courses = await _courseService.GetAllAsync();
        return Ok(new ApiResponse<IEnumerable<Course>>("Courses retrieved successfully.", courses));
    }

    /// <summary>
    /// Retrieves a single course by its unique identifier.
    /// </summary>
    /// <param name="id">The unique integer ID of the course.</param>
    /// <returns>The course matching the specified ID.</returns>
    /// <remarks>
    /// Sample response (200):
    /// <code>
    /// {
    ///   "message": "Course retrieved successfully.",
    ///   "data": { "id": 1, "name": "Introduction to C#...", "description": "Beginner C# course." }
    /// }
    /// </code>
    /// Sample response (404):
    /// <code>
    /// {
    ///   "message": "Course not found.",
    ///   "data": null
    /// }
    /// </code>
    /// </remarks>
    /// <response code="200">Returns the requested course.</response>
    /// <response code="401">Missing or invalid JWT Bearer token.</response>
    /// <response code="404">No course with the given ID was found.</response>
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(ApiResponse<Course>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponse<Course>), StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetById(int id)
    {
        var course = await _courseService.GetByIdAsync(id);
        if (course == null)
        {
            return NotFound(new ApiResponse<Course>("Course not found.", null));
        }

        return Ok(new ApiResponse<Course>("Course retrieved successfully.", course));
    }

    /// <summary>
    /// Creates a new course.
    /// </summary>
    /// <param name="course">The course to create. <c>Name</c> is required (max 200 characters). <c>Id</c> should be omitted or set to 0.</param>
    /// <returns>The newly created course, including its assigned ID.</returns>
    /// <remarks>
    /// Sample request body:
    /// <code>
    /// {
    ///   "name": "Introduction to C#",
    ///   "description": "A beginner-friendly course covering C# fundamentals."
    /// }
    /// </code>
    /// Sample response (201):
    /// <code>
    /// {
    ///   "message": "Course created successfully.",
    ///   "data": { "id": 3, "name": "Introduction to C#...", "description": "A beginner-friendly course covering C# fundamentals." }
    /// }
    /// </code>
    /// Sample response (400 — validation failure):
    /// <code>
    /// {
    ///   "statusCode": 400,
    ///   "message": "Validation failed.",
    ///   "errors": ["Course name is required."]
    /// }
    /// </code>
    /// </remarks>
    /// <response code="201">Course created successfully. The <c>Location</c> header points to the new resource.</response>
    /// <response code="400">The request body failed validation (e.g. missing required <c>Name</c>).</response>
    /// <response code="401">Missing or invalid JWT Bearer token.</response>
    [HttpPost]
    [Consumes("application/json")]
    [ProducesResponseType(typeof(ApiResponse<Course>), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Create(Course course)
    {
        await _courseService.AddAsync(course);
        return CreatedAtAction(
            nameof(GetById),
            new { id = course.Id },
            new ApiResponse<Course>("Course created successfully.", course));
    }

    /// <summary>
    /// Updates an existing course.
    /// </summary>
    /// <param name="id">The unique integer ID of the course to update. Must match the <c>id</c> field in the request body.</param>
    /// <param name="course">The updated course data. The <c>id</c> field must match the URL parameter.</param>
    /// <returns>The updated course.</returns>
    /// <remarks>
    /// Sample request body (PUT /api/course/1):
    /// <code>
    /// {
    ///   "id": 1,
    ///   "name": "Introduction to C# — Updated",
    ///   "description": "Updated description for the C# course."
    /// }
    /// </code>
    /// Sample response (200):
    /// <code>
    /// {
    ///   "message": "Course updated successfully.",
    ///   "data": { "id": 1, "name": "Introduction to C# — Updated...", "description": "Updated description for the C# course." }
    /// }
    /// </code>
    /// Sample response (400 — ID mismatch):
    /// <code>
    /// {
    ///   "message": "Course ID in the URL does not match the ID in the request body.",
    ///   "data": null
    /// }
    /// </code>
    /// Sample response (404):
    /// <code>
    /// {
    ///   "message": "Course not found.",
    ///   "data": null
    /// }
    /// </code>
    /// </remarks>
    /// <response code="200">Course updated successfully. Returns the updated course.</response>
    /// <response code="400">The ID in the URL does not match the <c>id</c> in the request body, or validation failed.</response>
    /// <response code="401">Missing or invalid JWT Bearer token.</response>
    /// <response code="404">No course with the given ID was found.</response>
    [HttpPut("{id}")]
    [Consumes("application/json")]
    [ProducesResponseType(typeof(ApiResponse<Course>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponse<Course>), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ApiResponse<Course>), StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Update(int id, Course course)
    {
        if (id != course.Id)
        {
            return BadRequest(new ApiResponse<Course>("Course ID in the URL does not match the ID in the request body.", null));
        }

        var updatedCourse = await _courseService.UpdateAsync(course);
        if (updatedCourse == null)
        {
            return NotFound(new ApiResponse<Course>("Course not found.", null));
        }

        return Ok(new ApiResponse<Course>("Course updated successfully.", updatedCourse));
    }

    /// <summary>
    /// Deletes a course by its unique identifier.
    /// </summary>
    /// <param name="id">The unique integer ID of the course to delete.</param>
    /// <returns>Confirmation that the course was deleted.</returns>
    /// <remarks>
    /// Sample response (200):
    /// <code>
    /// {
    ///   "message": "Course deleted successfully.",
    ///   "data": null
    /// }
    /// </code>
    /// Sample response (404):
    /// <code>
    /// {
    ///   "message": "Course not found.",
    ///   "data": null
    /// }
    /// </code>
    /// </remarks>
    /// <response code="200">Course deleted successfully.</response>
    /// <response code="401">Missing or invalid JWT Bearer token.</response>
    /// <response code="404">No course with the given ID was found.</response>
    [HttpDelete("{id}")]
    [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _courseService.DeleteAsync(id);
        if (!deleted)
        {
            return NotFound(new ApiResponse<object>("Course not found.", null));
        }

        return Ok(new ApiResponse<object>("Course deleted successfully.", null));
    }
}
