using Microsoft.EntityFrameworkCore;
using ZoozyApi.Data;
using ZoozyApi.Services;

var builder = WebApplication.CreateBuilder(args);

// Ortam değişkenlerini yükle
builder.Configuration.AddEnvironmentVariables(prefix: "ZOOZY_");

// Servisler
builder.Services.AddControllers();
builder.Services.AddHttpClient();

// CORS ayarları
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy
            .WithOrigins(
                "http://localhost:5000", // Flutter Web development port
                "https://zoozy-proje.web.app" // Prod Web app
            )
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials();
    });
});

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Database bağlantısı
var connectionString =
    builder.Configuration.GetConnectionString("DefaultConnection") ??
    builder.Configuration["ConnectionStrings__DefaultConnection"] ??
    builder.Configuration["SQLCONNSTR_DefaultConnection"] ??
    builder.Configuration["ZOOZY_SQL_CONN"];

if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException(
        "Veritabanı bağlantı bilgisi bulunamadı. Lütfen ConnectionStrings:DefaultConnection değerini User Secrets veya ortam değişkeni ile tanımlayın."
    );
}

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

// Firebase servis
builder.Services.AddScoped<IFirebaseSyncService, FirebaseSyncService>();

var app = builder.Build();

// Swagger UI (development)
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Middleware sırası önemli: Cors -> HTTPS -> Auth -> Controllers
app.UseCors();
app.UseHttpsRedirection();
app.UseAuthorization();

app.MapControllers();

app.Run();
