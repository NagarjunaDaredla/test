var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHealthChecks();
var app = builder.Build();
app.MapGet("/", () => Results.Ok(new { application = "EnterpriseApp.Api", message = "Enterprise CI/CD sample application", version = Environment.GetEnvironmentVariable("APP_VERSION") ?? "local", environment = app.Environment.EnvironmentName }));
app.MapGet("/api/products", () => Results.Ok(new[] { new { Id = 1, Name = "Laptop", Price = 75000 }, new { Id = 2, Name = "Monitor", Price = 18000 }, new { Id = 3, Name = "Keyboard", Price = 2500 } }));
app.MapGet("/health", () => Results.Ok(new { status = "Healthy" }));
app.MapHealthChecks("/healthz");
app.Run();
