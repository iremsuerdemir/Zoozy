namespace ZoozyApi.Dtos;

public class FirebaseSyncResult
{
    public int PetsCreated { get; set; }
    public int PetsUpdated { get; set; }
    public int ProvidersCreated { get; set; }
    public int ProvidersUpdated { get; set; }
    public int RequestsCreated { get; set; }
    public int RequestsUpdated { get; set; }
    public DateTime SyncedAt { get; set; } = DateTime.UtcNow;
    public int TotalChanges =>
        PetsCreated + PetsUpdated +
        ProvidersCreated + ProvidersUpdated +
        RequestsCreated + RequestsUpdated;
}

