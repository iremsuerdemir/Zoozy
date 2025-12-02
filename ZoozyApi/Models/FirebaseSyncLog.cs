using System.ComponentModel.DataAnnotations;

namespace ZoozyApi.Models;

public class FirebaseSyncLog
{
    public Guid Id { get; set; }
    [MaxLength(128)]
    public string PayloadSource { get; set; } = "firebase";
    public int PetsProcessed { get; set; }
    public int ProvidersProcessed { get; set; }
    public int RequestsProcessed { get; set; }
    public DateTime SyncedAt { get; set; } = DateTime.UtcNow;
    public string? Notes { get; set; }
}

