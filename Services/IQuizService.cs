using LMSWebAPI.Entities;

namespace LMSWebAPI.Services;

public interface IQuizService
{
    Task<IEnumerable<Quiz>> GetAllAsync();
    Task<Quiz> GetByIdAsync(int id);
    Task AddAsync(Quiz quiz);
    Task UpdateAsync(Quiz quiz);
    Task DeleteAsync(int id);
}