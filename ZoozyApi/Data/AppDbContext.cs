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

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<PetProfile>()
            .HasIndex(p => p.FirebaseId)
            .IsUnique();

        modelBuilder.Entity<ServiceProviderModel>()
            .HasIndex(p => p.FirebaseId)
            .IsUnique();

        modelBuilder.Entity<ServiceProviderModel>()
            .Property(p => p.Rating)
            .HasPrecision(3, 2);

        modelBuilder.Entity<ServiceRequest>()
            .HasIndex(r => r.FirebaseId)
            .IsUnique();

        modelBuilder.Entity<ServiceRequest>()
            .HasOne(r => r.PetProfile)
            .WithMany(p => p.ServiceRequests)
            .HasForeignKey(r => r.PetProfileId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<ServiceRequest>()
            .HasOne(r => r.ServiceProvider)
            .WithMany(p => p.ServiceRequests)
            .HasForeignKey(r => r.ServiceProviderId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}

