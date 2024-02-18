using Grpc.Core;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Serilog;
using Serilog.Events;
using Serilog.Formatting.Compact.Utf8;

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
            .SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("hello-world-proto"))
            .AddAspNetCoreInstrumentation()
            .AddHttpClientInstrumentation()
            .AddOtlpExporter()
        );
    // Register the configuration section
    var helloWorldSection = builder.Configuration.GetSection("HelloWorld");
    builder.Services.Configure<HelloWorldOptions>(helloWorldSection);
    // Add HttpClient to connect to HelloWorld service
    builder.Services.AddSingleton<HelloWorldClient>();
    // Add gRPC service
    builder.Services.AddGrpc();
    builder.Services.AddHealthChecks()
        .AddCheck<HelloWorldHealthCheck>("hello-world");
    var app = builder.Build();
    app.UseSerilogRequestLogging(); // Use Serilog Request Logging
    app.MapPrometheusScrapingEndpoint();
    app.MapGrpcService<GrpcService>();
    app.UseHealthChecks("/health");
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


class HelloWorldOptions
{
    public string BaseUrl { get; set; } = string.Empty;
}

class HelloWorldClient
{
    private readonly HttpClient _client;
    public HelloWorldClient(IOptions<HelloWorldOptions> options)
    {
        var socketHandler = new SocketsHttpHandler
        {
            PooledConnectionLifetime = TimeSpan.FromMinutes(15)
        };
        _client = new HttpClient(socketHandler)
        {
            BaseAddress = new Uri(options.Value.BaseUrl)
        };
    }
    public async Task<string> GetHelloWorld()
    {
        var response = await _client.GetAsync("/hello-world");
        return await response.Content.ReadAsStringAsync();
    }
}

class GrpcService : HelloService.HelloServiceBase
{
    private readonly HelloWorldClient _client;
    public GrpcService(HelloWorldClient client)
    {
        _client = client;
    }

    public async override Task<HelloReply> SayHello(
        Google.Protobuf.WellKnownTypes.Empty _,
        ServerCallContext context)
    {
        return new HelloReply
        {
            Result = await _client.GetHelloWorld()
        };
    }
}

class HelloWorldHealthCheck : IHealthCheck
{
    private readonly IOptions<HelloWorldOptions> _options;
    public HelloWorldHealthCheck(IOptions<HelloWorldOptions> options)
    {
        _options = options;
    }

    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            var client = new HelloWorldClient(_options);
            var response = await client.GetHelloWorld();
            if (response == "Hello World!")
            {
                return HealthCheckResult.Healthy("A healthy result.");
            }
            return HealthCheckResult.Unhealthy("An unhealthy result.");
        }
        catch (Exception ex)
        {
            return new HealthCheckResult(
                context.Registration.FailureStatus,
                "An unhealthy result.",
                ex);
        }
    }
}