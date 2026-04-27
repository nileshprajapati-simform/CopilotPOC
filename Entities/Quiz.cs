namespace LMSWebAPI.Entities;

public class Quiz
{
    public int Id { get; set; }
    public string Title { get; set; }
    public int CourseId { get; set; }
}