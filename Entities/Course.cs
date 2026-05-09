using System.ComponentModel.DataAnnotations;

namespace LMSWebAPI.Entities;

public class Course
{
    public int Id { get; set; }

    [Required(AllowEmptyStrings = false)]
    [StringLength(200)]
    public string Name { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;
}
