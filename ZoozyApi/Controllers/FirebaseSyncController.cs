using Microsoft.AspNetCore.Mvc;
using ZoozyApi.Dtos;
using ZoozyApi.Services;

namespace ZoozyApi.Controllers;

[ApiController]
[Route("api/firebase")]
public class FirebaseSyncController : ControllerBase
{
    private readonly IFirebaseSyncService _firebaseSyncService;

    public FirebaseSyncController(IFirebaseSyncService firebaseSyncService)
    {
        _firebaseSyncService = firebaseSyncService;
    }

    [HttpPost("sync")]
    public async Task<ActionResult<FirebaseSyncResult>> SyncAsync(
        [FromBody] FirebaseSyncRequest request,
        CancellationToken cancellationToken)
    {
        if (request is null)
        {
            return BadRequest("İstek gövdesi boş olamaz.");
        }

        var result = await _firebaseSyncService.SyncAsync(request, cancellationToken);
        return Ok(result);
    }
}

