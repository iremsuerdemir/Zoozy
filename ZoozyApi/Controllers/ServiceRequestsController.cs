using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZoozyApi.Data;
using ZoozyApi.Models;

namespace ZoozyApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ServiceRequestsController : ControllerBase
{
    private readonly AppDbContext _context;

    public ServiceRequestsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ServiceRequest>>> GetAllAsync(CancellationToken cancellationToken)
    {
        var requests = await _context.ServiceRequests
            .AsNoTracking()
            .Include(r => r.PetProfile)
            .Include(r => r.ServiceProvider)
            .OrderByDescending(r => r.UpdatedAt)
            .ToListAsync(cancellationToken);

        return Ok(requests);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<ServiceRequest>> GetByIdAsync(Guid id, CancellationToken cancellationToken)
    {
        var request = await _context.ServiceRequests
            .AsNoTracking()
            .Include(r => r.PetProfile)
            .Include(r => r.ServiceProvider)
            .FirstOrDefaultAsync(r => r.Id == id, cancellationToken);

        if (request is null)
        {
            return NotFound();
        }

        return Ok(request);
    }

    [HttpPost]
    public async Task<ActionResult<ServiceRequest>> CreateAsync(ServiceRequest request, CancellationToken cancellationToken)
    {
        if (!await _context.PetProfiles.AnyAsync(p => p.Id == request.PetProfileId, cancellationToken))
        {
            return BadRequest("Geçersiz pet profili.");
        }

        if (!await _context.ServiceProviders.AnyAsync(p => p.Id == request.ServiceProviderId, cancellationToken))
        {
            return BadRequest("Geçersiz hizmet sağlayıcı.");
        }

        request.Id = Guid.NewGuid();
        request.CreatedAt = DateTime.UtcNow;
        request.UpdatedAt = DateTime.UtcNow;

        _context.ServiceRequests.Add(request);
        await _context.SaveChangesAsync(cancellationToken);

        return CreatedAtAction(nameof(GetByIdAsync), new { id = request.Id }, request);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, ServiceRequest updated, CancellationToken cancellationToken)
    {
        var existing = await _context.ServiceRequests.FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
        if (existing is null)
        {
            return NotFound();
        }

        if (!await _context.PetProfiles.AnyAsync(p => p.Id == updated.PetProfileId, cancellationToken) ||
            !await _context.ServiceProviders.AnyAsync(p => p.Id == updated.ServiceProviderId, cancellationToken))
        {
            return BadRequest("Geçersiz pet veya hizmet sağlayıcı bilgisi.");
        }

        existing.PetProfileId = updated.PetProfileId;
        existing.ServiceProviderId = updated.ServiceProviderId;
        existing.ServiceType = updated.ServiceType;
        existing.PreferredDate = updated.PreferredDate;
        existing.Status = updated.Status;
        existing.Notes = updated.Notes;
        existing.LiveTrackingUrl = updated.LiveTrackingUrl;
        existing.VideoCallEnabled = updated.VideoCallEnabled;
        existing.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync(cancellationToken);
        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id, CancellationToken cancellationToken)
    {
        var existing = await _context.ServiceRequests.FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
        if (existing is null)
        {
            return NotFound();
        }

        _context.ServiceRequests.Remove(existing);
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }
}

