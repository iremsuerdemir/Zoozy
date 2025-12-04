using Microsoft.EntityFrameworkCore;
using ZoozyApi.Data;
using ZoozyApi.Services;

var builder = WebApplication.CreateBuilder(args);



// Ortam değişkenleri
builder.Configuration.AddEnvironmentVariables(prefix: "ZOOZY_");

// Servisler
builder.Services.AddControllers();
builder.Services.AddHttpClient();

// CORS — Flutter Web + Android + iOS + Desktop için OPEN
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .AllowAnyOrigin()   // Her IP'ye izin ver
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Database
var connectionString =
    builder.Configuration.GetConnectionString("DefaultConnection") ??
    builder.Configuration["ConnectionStrings__DefaultConnection"] ??
    builder.Configuration["SQLCONNSTR_DefaultConnection"] ??
    builder.Configuration["ZOOZY_SQL_CONN"];

if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException(
        "Veritabanı bağlantı bilgisi bulunamadı. ConnectionStrings:DefaultConnection tanımlayın."
    );
}

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

// Auth servis
builder.Services.AddScoped<IAuthService, AuthService>();

// Firebase servis
builder.Services.AddScoped<IFirebaseSyncService, FirebaseSyncService>();

var app = builder.Build();

// Swagger UI
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Middleware sırası
app.UseCors("AllowAll");

// Lokal geliştirme HTTPS kullanmıyorsan sorun olmaz
app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
