using Microsoft.EntityFrameworkCore;
using ZoozyApi.Models;
using ServiceProviderModel = ZoozyApi.Models.ServiceProvider;

namespace ZoozyApi.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<PetProfile> PetProfiles => Set<PetProfile>();
    public DbSet<ServiceProviderModel> ServiceProviders => Set<ServiceProviderModel>();
    public DbSet<ServiceRequest> ServiceRequests => Set<ServiceRequest>();
    public DbSet<FirebaseSyncLog> FirebaseSyncLogs => Set<FirebaseSyncLog>();
    public DbSet<User> Users => Set<User>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // PetProfile FirebaseId unique
        modelBuilder.Entity<PetProfile>()
            .HasIndex(p => p.FirebaseId)
            .IsUnique();

        // ServiceProvider FirebaseId unique
        modelBuilder.Entity<ServiceProviderModel>()
            .HasIndex(p => p.FirebaseId)
            .IsUnique();

        // Rating precision
        modelBuilder.Entity<ServiceProviderModel>()
            .Property(p => p.Rating)
            .HasPrecision(3, 2);

        // ServiceRequest FirebaseId unique
        modelBuilder.Entity<ServiceRequest>()
            .HasIndex(r => r.FirebaseId)
            .IsUnique();

        // ServiceRequest -> PetProfile (FK)
        modelBuilder.Entity<ServiceRequest>()
            .HasOne(r => r.PetProfile)
            .WithMany(p => p.ServiceRequests)
            .HasForeignKey(r => r.PetProfileId)
            .OnDelete(DeleteBehavior.Restrict);

        // User Email unique
        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();

        // User FirebaseUid unique (nullable olabilir)
        modelBuilder.Entity<User>()
            .HasIndex(u => u.FirebaseUid)
            .IsUnique()
            .HasFilter("[FirebaseUid] IS NOT NULL");

        // ServiceRequest -> ServiceProvider (FK)
        modelBuilder.Entity<ServiceRequest>()
            .HasOne(r => r.ServiceProvider)
            .WithMany(p => p.ServiceRequests)
            .HasForeignKey(r => r.ServiceProviderId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
