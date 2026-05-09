namespace LMSWebAPI.Models;

public class ApiResponse
{
    public int StatusCode { get; set; }

    public required string Message { get; set; }

    public IEnumerable<string> Errors { get; set; } = [];
}
