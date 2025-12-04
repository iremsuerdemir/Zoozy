using Microsoft.EntityFrameworkCore;
using ZoozyApi.Data;
using ZoozyApi.Dtos;
using ZoozyApi.Models;
using ServiceProviderModel = ZoozyApi.Models.ServiceProvider;

namespace ZoozyApi.Services;

public class FirebaseSyncService : IFirebaseSyncService
{
    private readonly AppDbContext _context;
    private readonly ILogger<FirebaseSyncService> _logger;

    public FirebaseSyncService(AppDbContext context, ILogger<FirebaseSyncService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<FirebaseSyncResult> SyncAsync(FirebaseSyncRequest request, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(request);

        var result = new FirebaseSyncResult
        {
            SyncedAt = DateTime.UtcNow
        };

        if (request.Pets?.Any() == true)
        {
            foreach (var dto in request.Pets)
            {
                var entity = await _context.PetProfiles
                    .FirstOrDefaultAsync(p => p.FirebaseId == dto.FirebaseId, cancellationToken);

                if (entity is null)
                {
                    entity = CreatePetFromDto(dto);
                    await _context.PetProfiles.AddAsync(entity, cancellationToken);
                    result.PetsCreated++;
                }
                else
                {
                    UpdatePet(entity, dto);
                    result.PetsUpdated++;
                }
            }
        }

        if (request.Providers?.Any() == true)
        {
            foreach (var dto in request.Providers)
            {
                var entity = await _context.ServiceProviders
                    .FirstOrDefaultAsync(p => p.FirebaseId == dto.FirebaseId, cancellationToken);

                if (entity is null)
                {
                    entity = CreateProviderFromDto(dto);
                    await _context.ServiceProviders.AddAsync(entity, cancellationToken);
                    result.ProvidersCreated++;
                }
                else
                {
                    UpdateProvider(entity, dto);
                    result.ProvidersUpdated++;
                }
            }
        }

        if (request.Requests?.Any() == true)
        {
            foreach (var dto in request.Requests)
            {
                var entity = await _context.ServiceRequests
                    .FirstOrDefaultAsync(r => r.FirebaseId == dto.FirebaseId, cancellationToken);

                var pet = await EnsurePetExistsAsync(dto.PetFirebaseId, cancellationToken);
                var provider = await EnsureProviderExistsAsync(dto.ProviderFirebaseId, dto.ServiceType, cancellationToken);

                if (entity is null)
                {
                    entity = CreateServiceRequestFromDto(dto, pet.Id, provider.Id);
                    await _context.ServiceRequests.AddAsync(entity, cancellationToken);
                    result.RequestsCreated++;
                }
                else
                {
                    UpdateServiceRequest(entity, dto, pet.Id, provider.Id);
                    result.RequestsUpdated++;
                }
            }
        }

        await _context.SaveChangesAsync(cancellationToken);

        await _context.FirebaseSyncLogs.AddAsync(new FirebaseSyncLog
        {
            PayloadSource = request.PayloadSource,
            PetsProcessed = result.PetsCreated + result.PetsUpdated,
            ProvidersProcessed = result.ProvidersCreated + result.ProvidersUpdated,
            RequestsProcessed = result.RequestsCreated + result.RequestsUpdated,
            SyncedAt = result.SyncedAt,
            Notes = $"Toplam değişiklik: {result.TotalChanges}"
        }, cancellationToken);

        await _context.SaveChangesAsync(cancellationToken);
        _logger.LogInformation(
            "Firebase verisi MSSQL'e aktarıldı. {Changes} değişiklik uygulandı.",
            result.TotalChanges);

        return result;
    }

    private static PetProfile CreatePetFromDto(FirebasePetProfileDto dto) => new()
    {
        Id = Guid.NewGuid(),
        FirebaseId = dto.FirebaseId,
        Name = dto.Name,
        Species = dto.Species,
        Breed = dto.Breed,
        Age = dto.Age,
        VaccinationStatus = dto.VaccinationStatus,
        HealthNotes = dto.HealthNotes,
        OwnerName = dto.OwnerName,
        OwnerContact = dto.OwnerContact
    };

    private static void UpdatePet(PetProfile entity, FirebasePetProfileDto dto)
    {
        entity.Name = dto.Name;
        entity.Species = dto.Species;
        entity.Breed = dto.Breed;
        entity.Age = dto.Age;
        entity.VaccinationStatus = dto.VaccinationStatus;
        entity.HealthNotes = dto.HealthNotes;
        entity.OwnerName = dto.OwnerName;
        entity.OwnerContact = dto.OwnerContact;
        entity.UpdatedAt = DateTime.UtcNow;
    }

    private static ServiceProviderModel CreateProviderFromDto(FirebaseServiceProviderDto dto) => new()
    {
        Id = Guid.NewGuid(),
        FirebaseId = dto.FirebaseId,
        Name = dto.Name,
        ServiceType = dto.ServiceType,
        Description = dto.Description,
        Location = dto.Location,
        ContactInfo = dto.ContactInfo,
        Rating = dto.Rating,
        OffersLiveTracking = dto.OffersLiveTracking,
        OffersVideoCall = dto.OffersVideoCall
    };

    private static void UpdateProvider(ServiceProviderModel entity, FirebaseServiceProviderDto dto)
    {
        entity.Name = dto.Name;
        entity.ServiceType = dto.ServiceType;
        entity.Description = dto.Description;
        entity.Location = dto.Location;
        entity.ContactInfo = dto.ContactInfo;
        entity.Rating = dto.Rating;
        entity.OffersLiveTracking = dto.OffersLiveTracking;
        entity.OffersVideoCall = dto.OffersVideoCall;
        entity.UpdatedAt = DateTime.UtcNow;
    }

    private static ServiceRequest CreateServiceRequestFromDto(
        FirebaseServiceRequestDto dto,
        Guid petId,
        Guid providerId) => new()
        {
            Id = Guid.NewGuid(),
            FirebaseId = dto.FirebaseId,
            PetProfileId = petId,
            ServiceProviderId = providerId,
            ServiceType = dto.ServiceType,
            PreferredDate = dto.PreferredDate,
            Status = dto.Status,
            Notes = dto.Notes,
            LiveTrackingUrl = dto.LiveTrackingUrl,
            VideoCallEnabled = dto.VideoCallEnabled
        };

    private static void UpdateServiceRequest(
        ServiceRequest entity,
        FirebaseServiceRequestDto dto,
        Guid petId,
        Guid providerId)
    {
        entity.PetProfileId = petId;
        entity.ServiceProviderId = providerId;
        entity.ServiceType = dto.ServiceType;
        entity.PreferredDate = dto.PreferredDate;
        entity.Status = dto.Status;
        entity.Notes = dto.Notes;
        entity.LiveTrackingUrl = dto.LiveTrackingUrl;
        entity.VideoCallEnabled = dto.VideoCallEnabled;
        entity.UpdatedAt = DateTime.UtcNow;
    }

    private async Task<PetProfile> EnsurePetExistsAsync(string firebaseId, CancellationToken cancellationToken)
    {
        var entity = await _context.PetProfiles
            .FirstOrDefaultAsync(p => p.FirebaseId == firebaseId, cancellationToken);

        if (entity != null)
        {
            return entity;
        }

        entity = new PetProfile
        {
            Id = Guid.NewGuid(),
            FirebaseId = firebaseId,
            Name = "Bilinmeyen",
            Species = "unknown",
            OwnerName = "Bilinmiyor",
            OwnerContact = string.Empty
        };

        await _context.PetProfiles.AddAsync(entity, cancellationToken);
        return entity;
    }

    private async Task<ServiceProviderModel> EnsureProviderExistsAsync(string firebaseId, string serviceType, CancellationToken cancellationToken)
    {
        var entity = await _context.ServiceProviders
            .FirstOrDefaultAsync(p => p.FirebaseId == firebaseId, cancellationToken);

        if (entity != null)
        {
            return entity;
        }

        entity = new ServiceProviderModel
        {
            Id = Guid.NewGuid(),
            FirebaseId = firebaseId,
            Name = "Bilinmeyen",
            ServiceType = serviceType,
            Location = "Bilinmiyor"
        };

        await _context.ServiceProviders.AddAsync(entity, cancellationToken);
        return entity;
    }
}

