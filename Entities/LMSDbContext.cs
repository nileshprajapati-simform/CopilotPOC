using Microsoft.EntityFrameworkCore;

namespace LMSWebAPI.Entities
{
    public class LMSDbContext : DbContext
    {
        public LMSDbContext(DbContextOptions<LMSDbContext> options) : base(options)
        {
        }

        // Define DbSets for your entities here
        // Example: public DbSet<Course> Courses { get; set; }
        public DbSet<Quiz> Quizzes { get; set; }
        public DbSet<Course> Courses { get; set; }
    }
}