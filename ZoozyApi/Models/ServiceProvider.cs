using System.ComponentModel.DataAnnotations;

namespace ZoozyApi.Models;

public class ServiceProvider
{
    public Guid Id { get; set; }
    public string FirebaseId { get; set; } = string.Empty;
    [MaxLength(256)]
    public string Name { get; set; } = string.Empty;
    [MaxLength(128)]
    public string ServiceType { get; set; } = string.Empty;
    public string? Description { get; set; }
    [MaxLength(256)]
    public string Location { get; set; } = string.Empty;
    [MaxLength(256)]
    public string? ContactInfo { get; set; }
    public decimal? Rating { get; set; }
    public bool OffersLiveTracking { get; set; }
    public bool OffersVideoCall { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    public ICollection<ServiceRequest> ServiceRequests { get; set; } = new List<ServiceRequest>();
}

