using LMSWebAPI.Entities;

namespace LMSWebAPI.Repositories;

public interface ICourseRepository
{
    Task<IEnumerable<Course>> GetAllAsync();
    Task<Course?> GetByIdAsync(int id);
    Task AddAsync(Course course);
    Task<Course?> UpdateAsync(Course course);
    Task<bool> DeleteAsync(int id);
}
