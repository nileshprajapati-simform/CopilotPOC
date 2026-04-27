using LMSWebAPI.Entities;
using LMSWebAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LMSWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class QuizController : ControllerBase
{
    private readonly IQuizService _quizService;

    public QuizController(IQuizService quizService)
    {
        _quizService = quizService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var quizzes = await _quizService.GetAllAsync();
        return Ok(quizzes);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var quiz = await _quizService.GetByIdAsync(id);
        if (quiz == null)
        {
            return NotFound();
        }
        return Ok(quiz);
    }

    [Authorize]
    [HttpPost]
    public async Task<IActionResult> Create(Quiz quiz)
    {
        await _quizService.AddAsync(quiz);
        return CreatedAtAction(nameof(GetById), new { id = quiz.Id }, quiz);
    }

    [Authorize]
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, Quiz quiz)
    {
        if (id != quiz.Id)
        {
            return BadRequest();
        }
        await _quizService.UpdateAsync(quiz);
        return NoContent();
    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        await _quizService.DeleteAsync(id);
        return NoContent();
    }
}