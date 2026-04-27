using LMSWebAPI.Entities;
using Microsoft.EntityFrameworkCore;

namespace LMSWebAPI.Repositories;

public class QuizRepository : IQuizRepository
{
    private readonly LMSDbContext _context;

    public QuizRepository(LMSDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Quiz>> GetAllAsync()
    {
        return await _context.Quizzes.ToListAsync();
    }

    public async Task<Quiz> GetByIdAsync(int id)
    {
        return await _context.Quizzes.FindAsync(id);
    }

    public async Task AddAsync(Quiz quiz)
    {
        await _context.Quizzes.AddAsync(quiz);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Quiz quiz)
    {
        _context.Quizzes.Update(quiz);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        var quiz = await _context.Quizzes.FindAsync(id);
        if (quiz != null)
        {
            _context.Quizzes.Remove(quiz);
            await _context.SaveChangesAsync();
        }
    }
}