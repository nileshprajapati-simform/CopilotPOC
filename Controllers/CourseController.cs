using LMSWebAPI.Entities;
using LMSWebAPI.Models;
using LMSWebAPI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace LMSWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CourseController : ControllerBase
{
    private readonly ICourseService _courseService;

    public CourseController(ICourseService courseService)
    {
        _courseService = courseService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var courses = await _courseService.GetAllAsync();
        return Ok(new ApiResponse<IEnumerable<Course>>("Courses retrieved successfully.", courses));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var course = await _courseService.GetByIdAsync(id);
        if (course == null)
        {
            return NotFound(new ApiResponse<Course>("Course not found.", null));
        }

        return Ok(new ApiResponse<Course>("Course retrieved successfully.", course));
    }

    [HttpPost]
    public async Task<IActionResult> Create(Course course)
    {
        await _courseService.AddAsync(course);
        return CreatedAtAction(
            nameof(GetById),
            new { id = course.Id },
            new ApiResponse<Course>("Course created successfully.", course));
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, Course course)
    {
        if (id != course.Id)
        {
            return BadRequest(new ApiResponse<Course>("Course ID in the URL must match the request body.", null));
        }

        var updated = await _courseService.UpdateAsync(course);
        if (!updated)
        {
            return NotFound(new ApiResponse<Course>("Course not found.", null));
        }

        return Ok(new ApiResponse<Course>("Course updated successfully.", course));
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _courseService.DeleteAsync(id);
        if (!deleted)
        {
            return NotFound(new ApiResponse<Course>("Course not found.", null));
        }

        return Ok(new ApiResponse<Course>("Course deleted successfully.", null));
    }
}
