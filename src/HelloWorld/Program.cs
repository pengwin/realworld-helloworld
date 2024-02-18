using Serilog;
using Serilog.Events;
using Serilog.Formatting.Compact.Utf8;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Override("Microsoft.AspNetCore", LogEventLevel.Warning)
    .WriteTo.Background(a => a.RawConsole(new CompactUtf8JsonFormatter()))
    .CreateLogger();

try 
{
    var builder = WebApplication.CreateBuilder(args);
    builder.Host.UseSerilog(); // Use Serilog
    builder.Services.AddOpenTelemetry()
        .WithMetrics(builder =>
        {
            builder.AddPrometheusExporter();

            builder.AddMeter("Microsoft.AspNetCore.Hosting",
                            "Microsoft.AspNetCore.Server.Kestrel");
            builder.AddView("http.server.request.duration",
                new ExplicitBucketHistogramConfiguration
                {
                    Boundaries = new double[] { 0, 0.005, 0.01, 0.025, 0.05,
                        0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10 }
                });
        })
        .WithTracing(b => b
            .SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("hello-world"))
            .AddAspNetCoreInstrumentation()
            .AddOtlpExporter()
        );
    builder.Services.AddHealthChecks();
    var app = builder.Build();
    app.UseHealthChecks("/health");
    app.UseSerilogRequestLogging(); // Use Serilog Request Logging
    app.MapPrometheusScrapingEndpoint();
    app.MapGet("/hello-world", () => "Hello World!");
    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Application terminated unexpectedly");
}
finally 
{
    await Log.CloseAndFlushAsync();
}

