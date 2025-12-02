using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZoozyApi.Data;
using ZoozyApi.Models;

namespace ZoozyApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PetProfilesController : ControllerBase
{
    private readonly AppDbContext _context;

    public PetProfilesController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<PetProfile>>> GetAllAsync(CancellationToken cancellationToken)
    {
        var pets = await _context.PetProfiles
            .AsNoTracking()
            .OrderByDescending(p => p.UpdatedAt)
            .ToListAsync(cancellationToken);

        return Ok(pets);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<PetProfile>> GetByIdAsync(Guid id, CancellationToken cancellationToken)
    {
        var pet = await _context.PetProfiles
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.Id == id, cancellationToken);

        if (pet is null)
        {
            return NotFound();
        }

        return Ok(pet);
    }

    [HttpPost]
    public async Task<ActionResult<PetProfile>> CreateAsync(PetProfile petProfile, CancellationToken cancellationToken)
    {
        petProfile.Id = Guid.NewGuid();
        petProfile.CreatedAt = DateTime.UtcNow;
        petProfile.UpdatedAt = DateTime.UtcNow;

        _context.PetProfiles.Add(petProfile);
        await _context.SaveChangesAsync(cancellationToken);

        return CreatedAtAction(nameof(GetByIdAsync), new { id = petProfile.Id }, petProfile);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateAsync(Guid id, PetProfile updated, CancellationToken cancellationToken)
    {
        var existing = await _context.PetProfiles.FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
        if (existing is null)
        {
            return NotFound();
        }

        existing.Name = updated.Name;
        existing.Species = updated.Species;
        existing.Breed = updated.Breed;
        existing.Age = updated.Age;
        existing.VaccinationStatus = updated.VaccinationStatus;
        existing.HealthNotes = updated.HealthNotes;
        existing.OwnerName = updated.OwnerName;
        existing.OwnerContact = updated.OwnerContact;
        existing.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync(cancellationToken);
        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAsync(Guid id, CancellationToken cancellationToken)
    {
        var existing = await _context.PetProfiles.FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
        if (existing is null)
        {
            return NotFound();
        }

        _context.PetProfiles.Remove(existing);
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }
}

