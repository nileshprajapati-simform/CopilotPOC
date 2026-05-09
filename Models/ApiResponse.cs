namespace LMSWebAPI.Models;

public record ApiResponse<T>(string Message, T? Data);
