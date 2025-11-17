namespace ZoozyApi.Dtos;

public class FirebaseSyncRequest
{
    public string PayloadSource { get; set; } = "firebase";
    public List<FirebasePetProfileDto>? Pets { get; set; }
    public List<FirebaseServiceProviderDto>? Providers { get; set; }
    public List<FirebaseServiceRequestDto>? Requests { get; set; }
}

