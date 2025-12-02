namespace ZoozyApi.Dtos;

public class FirebasePetProfileDto
{
    public string FirebaseId { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Species { get; set; } = string.Empty;
    public string? Breed { get; set; }
    public int? Age { get; set; }
    public string? VaccinationStatus { get; set; }
    public string? HealthNotes { get; set; }
    public string OwnerName { get; set; } = string.Empty;
    public string OwnerContact { get; set; } = string.Empty;
}

