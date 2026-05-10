using LMSWebAPI.Entities;
using LMSWebAPI.Repositories;

namespace LMSWebAPI.Services;

public class CourseService : ICourseService
{
    private const string TitleSuffix = "...";

    private readonly ICourseRepository _courseRepository;

    public CourseService(ICourseRepository courseRepository)
    {
        _courseRepository = courseRepository;
    }

    public async Task<IEnumerable<Course>> GetAllAsync()
    {
        var courses = await _courseRepository.GetAllAsync();
        return courses.Select(FormatCourseTitle);
    }

    public async Task<Course?> GetByIdAsync(int id)
    {
        var course = await _courseRepository.GetByIdAsync(id);
        if (course == null) return null;
        return FormatCourseTitle(course);
    }

    public async Task AddAsync(Course course)
    {
        await _courseRepository.AddAsync(course);
    }

    public async Task<Course?> UpdateAsync(Course course)
    {
        return await _courseRepository.UpdateAsync(course);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        return await _courseRepository.DeleteAsync(id);
    }
}
