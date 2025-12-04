using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZoozyApi.Data;
using ZoozyApi.Models;
using ZoozyApi.Models.Dto;

namespace ZoozyApi.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _db;

        public UsersController(AppDbContext db)
        {
            _db = db;
        }

        // -------------------------------------------------------------
        // ✅ Kullanıcı bilgisi getir
        // GET: api/users/{firebaseUid}
        // -------------------------------------------------------------
        [HttpGet("{firebaseUid}")]
        public async Task<IActionResult> GetUser(string firebaseUid)
        {
            if (string.IsNullOrEmpty(firebaseUid))
                return BadRequest("firebaseUid boş olamaz");

            var user = await _db.Users.FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);

            if (user == null)
                return NotFound(new { message = "Kullanıcı bulunamadı" });

            return Ok(user);
        }

        // -------------------------------------------------------------
        // ✅ Kullanıcı var mı kontrolü
        // GET: api/users/exists/{firebaseUid}
        // -------------------------------------------------------------
        [HttpGet("exists/{firebaseUid}")]
        public async Task<IActionResult> UserExists(string firebaseUid)
        {
            if (string.IsNullOrEmpty(firebaseUid))
                return BadRequest("firebaseUid boş olamaz");

            var exists = await _db.Users.AnyAsync(u => u.FirebaseUid == firebaseUid);
            return Ok(new { exists });
        }

        // -------------------------------------------------------------
        // 🔄 Kullanıcı senkronizasyonu (login sonrası)
        // POST: api/users/sync
        // -------------------------------------------------------------
        [HttpPost("sync")]
        public async Task<IActionResult> SyncUser([FromBody] SyncUserDto dto)
        {
            if (dto == null)
                return BadRequest("Dto gelmedi");

            if (string.IsNullOrEmpty(dto.FirebaseUid))
                return BadRequest("Uid zorunludur");

            var user = await _db.Users.FirstOrDefaultAsync(x => x.FirebaseUid == dto.FirebaseUid);

            if (user == null)
            {
                // Yeni kullanıcı oluştur
                user = new User
                {
                    FirebaseUid = dto.FirebaseUid,
                    Email = dto.Email,
                    DisplayName = dto.DisplayName,
                    PhotoUrl = dto.PhotoUrl,
                    Provider = dto.Provider,
                    CreatedAt = DateTime.Now
                };

                _db.Users.Add(user);
            }
            else
            {
                // Var olan kullanıcı güncelle
                user.Email = dto.Email;
                user.DisplayName = dto.DisplayName;
                user.PhotoUrl = dto.PhotoUrl;
                user.Provider = dto.Provider;
                user.UpdatedAt = DateTime.Now;

                _db.Users.Update(user);
            }

            await _db.SaveChangesAsync();

            return Ok(new
            {
                message = "User synced",
                id = user.Id
            });
        }

        // -------------------------------------------------------------
        // 🆕 İlk kayıt (register)
        // POST: api/users/register
        // -------------------------------------------------------------
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] SyncUserDto dto)
        {
            if (dto == null)
                return BadRequest("Dto gelmedi");

            if (string.IsNullOrEmpty(dto.FirebaseUid))
                return BadRequest("Uid zorunludur");

            var existingUser = await _db.Users.FirstOrDefaultAsync(x => x.FirebaseUid == dto.FirebaseUid);

            if (existingUser != null)
            {
                return Conflict(new { message = "User already exists" }); // 409
            }

            var newUser = new User
            {
                FirebaseUid = dto.FirebaseUid,
                Email = dto.Email,
                DisplayName = dto.DisplayName,
                PhotoUrl = dto.PhotoUrl,
                Provider = dto.Provider,
                CreatedAt = DateTime.Now
            };

            _db.Users.Add(newUser);
            await _db.SaveChangesAsync();

            return StatusCode(201, new
            {
                message = "User created",
                id = newUser.Id
            });
        }
    }
}
