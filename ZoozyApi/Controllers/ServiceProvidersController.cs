using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZoozyApi.Data;
using ZoozyApi.Models;
using ServiceProviderModel = ZoozyApi.Models.ServiceProvider;

namespace ZoozyApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ServiceProvidersController : ControllerBase
{
    private readonly AppDbContext _context;

    public ServiceProvidersController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ServiceProviderModel>>> GetAllAsync(CancellationToken cancellationToken)
    {
        var providers = await _context.ServiceProviders
            .AsNoTracking()
            .OrderByDescending(p => p.UpdatedAt)
            .ToListAsync(cancellationToken);

        return Ok(providers);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<ServiceProviderModel>> GetByIdAsync(Guid id, CancellationToken cancellationToken)
    {
        var provider = await _context.ServiceProviders
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.Id == id, cancellationToken);

        if (provider is null)
        {
            return NotFound();
        }

        return Ok(provider);
    }

    [HttpPost]
    public async Task<ActionResult<ServiceProviderModel>> CreateAsync(ServiceProviderModel provider, CancellationToken cancellationToken)
    {
        provider.Id = Guid.NewGuid();
        provider.CreatedAt = DateTime.UtcNow;
        provider.UpdatedAt = DateTime.UtcNow;

        _context.ServiceProviders.Add(provider);
        await _context.SaveChangesAsync(cancellationToken);

        return CreatedAtAction(nameof(GetByIdAsync), new { id = provider.Id }, provider);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, ServiceProviderModel updated, CancellationToken cancellationToken)
    {
        var existing = await _context.ServiceProviders.FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
        if (existing is null)
        {
            return NotFound();
        }

        existing.Name = updated.Name;
        existing.ServiceType = updated.ServiceType;
        existing.Description = updated.Description;
        existing.Location = updated.Location;
        existing.ContactInfo = updated.ContactInfo;
        existing.Rating = updated.Rating;
        existing.OffersLiveTracking = updated.OffersLiveTracking;
        existing.OffersVideoCall = updated.OffersVideoCall;
        existing.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync(cancellationToken);
        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id, CancellationToken cancellationToken)
    {
        var existing = await _context.ServiceProviders.FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
        if (existing is null)
        {
            return NotFound();
        }

        _context.ServiceProviders.Remove(existing);
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }
}

