using System.ComponentModel.DataAnnotations;

namespace ZoozyApi.Models;

public class PetProfile
{
    public Guid Id { get; set; }
    public string FirebaseId { get; set; } = string.Empty;
    [MaxLength(256)]
    public string Name { get; set; } = string.Empty;
    [MaxLength(128)]
    public string Species { get; set; } = string.Empty;
    [MaxLength(128)]
    public string? Breed { get; set; }
    public int? Age { get; set; }
    [MaxLength(256)]
    public string? VaccinationStatus { get; set; }
    public string? HealthNotes { get; set; }
    [MaxLength(256)]
    public string OwnerName { get; set; } = string.Empty;
    [MaxLength(256)]
    public string OwnerContact { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    public ICollection<ServiceRequest> ServiceRequests { get; set; } = new List<ServiceRequest>();
}

