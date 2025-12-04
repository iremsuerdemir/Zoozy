using ZoozyApi.Dtos;

namespace ZoozyApi.Services;

public interface IFirebaseSyncService
{
    Task<FirebaseSyncResult> SyncAsync(FirebaseSyncRequest request, CancellationToken cancellationToken = default);
}

