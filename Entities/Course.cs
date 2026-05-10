using System.ComponentModel.DataAnnotations;

namespace LMSWebAPI.Entities;

public class Course
{
    public int Id { get; set; }

    [Required(ErrorMessage = "Course name is required.")]
    [StringLength(200, ErrorMessage = "Course name must not exceed 200 characters.")]
    public string Name { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;
}
