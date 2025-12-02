namespace ZoozyApi.Dtos;

public class FirebaseServiceRequestDto
{
    public string FirebaseId { get; set; } = string.Empty;
    public string PetFirebaseId { get; set; } = string.Empty;
    public string ProviderFirebaseId { get; set; } = string.Empty;
    public string ServiceType { get; set; } = string.Empty;
    public DateTime PreferredDate { get; set; }
    public string Status { get; set; } = "pending";
    public string? Notes { get; set; }
    public string? LiveTrackingUrl { get; set; }
    public bool VideoCallEnabled { get; set; }
}

