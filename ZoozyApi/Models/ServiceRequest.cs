using System.ComponentModel.DataAnnotations;

namespace ZoozyApi.Models;

public class ServiceRequest
{
    public Guid Id { get; set; }
    public string FirebaseId { get; set; } = string.Empty;
    public Guid PetProfileId { get; set; }
    public Guid ServiceProviderId { get; set; }
    [MaxLength(128)]
    public string ServiceType { get; set; } = string.Empty;
    public DateTime PreferredDate { get; set; }
    [MaxLength(64)]
    public string Status { get; set; } = "pending";
    public string? Notes { get; set; }
    [MaxLength(512)]
    public string? LiveTrackingUrl { get; set; }
    public bool VideoCallEnabled { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    public PetProfile? PetProfile { get; set; }
    public ServiceProvider? ServiceProvider { get; set; }
}

