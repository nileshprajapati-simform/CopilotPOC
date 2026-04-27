# LMSWebAPI Setup Guide

## Step 1: Create a New Git Branch
Create a new Git branch named `feature/lms-api-setup` from the latest `main` branch.

## Step 2: Create a Boilerplate .NET 8 Web API Project
Set up a boilerplate .NET 8 Web API project for a Learning Management System (LMS) with:
- Folders: Entities, Repositories, Services, Controllers, Middleware
- Add global exception handling middleware
- Setup basic logging using ILogger
- Add JWT Authentication (can use a dummy secret key for now)
- Create an initial DbContext called LMSDbContext

## Step 3: Create the following for LMS Web API:
Create the following for LMS Web API:

Entity:
- Quiz entity with properties: Id (int), Title (string), CourseId (int)

Database:
- Add DbSet<Quiz> in LMSDbContext

Repository:
- IQuizRepository
- QuizRepository implementing basic CRUD operations

Service:
- IQuizService
- QuizService implementing CRUD using the repository

Controller:
- QuizController with basic CRUD APIs (GET all, GET by Id, POST, PUT, DELETE)
- Use [Authorize] attribute on POST, PUT, DELETE endpoints

Dependency Injection:
- Register IQuizRepository, IQuizService in Program.cs

## Step 4: Create the following for LMS Web API:

Entity:
- Course entity with properties: Id (int), Name (string), Description (string)

Database:
- Add DbSet<Course> in LMSDbContext

Repository:
- ICourseRepository
- CourseRepository implementing basic CRUD operations

Service:
- ICourseService
- CourseService implementing CRUD using the repository

Controller:
- CourseController with basic CRUD APIs

Dependency Injection:
- Register ICourseRepository, ICourseService in Program.cs

## Step 5: Improve the LMS Web API by:
- Adding FluentValidation for request validation
- Improving exception handling to return ProblemDetails format
- Adding Swagger UI with JWT Bearer authentication support
- Protecting APIs with [Authorize] attributes
