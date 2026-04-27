using LMSWebAPI.Entities;

namespace LMSWebAPI.Repositories;

public interface IQuizRepository
{
    Task<IEnumerable<Quiz>> GetAllAsync();
    Task<Quiz> GetByIdAsync(int id);
    Task AddAsync(Quiz quiz);
    Task UpdateAsync(Quiz quiz);
    Task DeleteAsync(int id);
}