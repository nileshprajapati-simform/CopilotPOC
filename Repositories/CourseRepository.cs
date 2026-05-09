using LMSWebAPI.Entities;
using Microsoft.EntityFrameworkCore;

namespace LMSWebAPI.Repositories;

public class CourseRepository : ICourseRepository
{
    private readonly LMSDbContext _context;

    public CourseRepository(LMSDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Course>> GetAllAsync()
    {
        return await _context.Courses.ToListAsync();
    }

    public async Task<Course?> GetByIdAsync(int id)
    {
        return await _context.Courses.FindAsync(id);
    }

    public async Task AddAsync(Course course)
    {
        await _context.Courses.AddAsync(course);
        await _context.SaveChangesAsync();
    }

    public async Task<bool> UpdateAsync(Course course)
    {
        var existingCourse = await _context.Courses.FindAsync(course.Id);
        if (existingCourse == null)
        {
            return false;
        }

        existingCourse.Name = course.Name;
        existingCourse.Description = course.Description;
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var course = await _context.Courses.FindAsync(id);
        if (course == null)
        {
            return false;
        }

        _context.Courses.Remove(course);
        await _context.SaveChangesAsync();
        return true;
    }
}
