var builder = WebApplication.CreateBuilder(args);
builder.Logging.ClearProviders(); // disable logging
var app = builder.Build();
app.MapGet("/hello-world", () => "Hello World!");
app.Run();