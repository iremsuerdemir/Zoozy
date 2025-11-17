namespace ZoozyApi.Dtos;

public class FirebaseServiceProviderDto
{
    public string FirebaseId { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string ServiceType { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Location { get; set; } = string.Empty;
    public string? ContactInfo { get; set; }
    public decimal? Rating { get; set; }
    public bool OffersLiveTracking { get; set; }
    public bool OffersVideoCall { get; set; }
}

