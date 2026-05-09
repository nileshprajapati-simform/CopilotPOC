namespace LMSWebAPI.Models;

public class ApiResponse
{
    public int StatusCode { get; set; }

    public string Message { get; set; } = string.Empty;

    public IEnumerable<string> Errors { get; set; } = [];
}
