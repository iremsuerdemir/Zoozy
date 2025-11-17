using Microsoft.EntityFrameworkCore;
using ZoozyApi.Data;
using ZoozyApi.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddEnvironmentVariables(prefix: "ZOOZY_");

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString =
    builder.Configuration.GetConnectionString("DefaultConnection") ??
    builder.Configuration["ConnectionStrings__DefaultConnection"] ??
    builder.Configuration["SQLCONNSTR_DefaultConnection"] ??
    builder.Configuration["ZOOZY_SQL_CONN"];

if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException("Veritabanı bağlantı bilgisi bulunamadı. Lütfen ConnectionStrings:DefaultConnection değerini User Secrets veya ortam değişkeni ile tanımlayın.");
}

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services.AddScoped<IFirebaseSyncService, FirebaseSyncService>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();

app.MapControllers();

app.Run();
