using ZoozyApi.Data;
using ZoozyApi.Dtos;
using ZoozyApi.Models;
using Microsoft.EntityFrameworkCore;
using BCrypt.Net;

namespace ZoozyApi.Services
{
    public interface IAuthService
    {
        Task<AuthResponse> RegisterAsync(RegisterRequest request);
        Task<AuthResponse> LoginAsync(LoginRequest request);
        Task<AuthResponse> GoogleLoginAsync(GoogleLoginRequest request);
        Task<UserDto?> GetUserByIdAsync(int id);
        Task<UserDto?> GetUserByEmailAsync(string email);
        Task<ResetPasswordResponse> ResetPasswordAsync(string email);
    }

    public class AuthService : IAuthService
    {
        private readonly AppDbContext _context;
        private readonly ILogger<AuthService> _logger;

        public AuthService(AppDbContext context, ILogger<AuthService> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// Email ve şifre ile yeni kullanıcı kaydı
        /// </summary>
        public async Task<AuthResponse> RegisterAsync(RegisterRequest request)
        {
            try
            {
                // Validasyon
                if (string.IsNullOrWhiteSpace(request.Email) || 
                    string.IsNullOrWhiteSpace(request.Password) ||
                    string.IsNullOrWhiteSpace(request.DisplayName))
                {
                    return new AuthResponse 
                    { 
                        Success = false, 
                        Message = "Email, şifre ve ad gereklidir." 
                    };
                }

                // Email zaten var mı?
                var existingUser = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email.ToLower() == request.Email.ToLower());

                if (existingUser != null)
                {
                    return new AuthResponse 
                    { 
                        Success = false, 
                        Message = "Bu email adresi zaten kayıtlı." 
                    };
                }

                // Şifre hash'le (BCrypt)
                string passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

                var newUser = new User
                {
                    Email = request.Email.ToLower(),
                    PasswordHash = passwordHash,
                    DisplayName = request.DisplayName,
                    Provider = "local",
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                };

                _context.Users.Add(newUser);
                await _context.SaveChangesAsync();

                _logger.LogInformation($"Yeni kullanıcı kaydı başarılı: {newUser.Email}");

                return new AuthResponse
                {
                    Success = true,
                    Message = "Kayıt başarılı!",
                    User = MapUserToDto(newUser)
                };
            }
            catch (Exception ex)
            {
                _logger.LogError($"Kayıt hatası: {ex.Message}");
                return new AuthResponse 
                { 
                    Success = false, 
                    Message = "Kayıt işlemi sırasında hata oluştu." 
                };
            }
        }

        /// <summary>
        /// Email ve şifre ile login
        /// </summary>
        public async Task<AuthResponse> LoginAsync(LoginRequest request)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(request.Email) || 
                    string.IsNullOrWhiteSpace(request.Password))
                {
                    return new AuthResponse 
                    { 
                        Success = false, 
                        Message = "Email ve şifre gereklidir." 
                    };
                }

                var user = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email.ToLower() == request.Email.ToLower() && 
                                              u.Provider == "local");

                if (user == null || !user.IsActive)
                {
                    return new AuthResponse 
                    { 
                        Success = false, 
                        Message = "Email veya şifre yanlış." 
                    };
                }

                // Şifre doğrula (BCrypt) - trim et ve doğrula
                bool isValidPassword = BCrypt.Net.BCrypt.Verify(request.Password.Trim(), user.PasswordHash ?? "");

                if (!isValidPassword)
                {
                    return new AuthResponse 
                    { 
                        Success = false, 
                        Message = "Email veya şifre yanlış." 
                    };
                }

                user.UpdatedAt = DateTime.UtcNow;
                _context.Users.Update(user);
                await _context.SaveChangesAsync();

                _logger.LogInformation($"Başarılı login: {user.Email}");

                return new AuthResponse
                {
                    Success = true,
                    Message = "Login başarılı!",
                    User = MapUserToDto(user)
                };
            }
            catch (Exception ex)
            {
                _logger.LogError($"Login hatası: {ex.Message}");
                return new AuthResponse 
                { 
                    Success = false, 
                    Message = "Login işlemi sırasında hata oluştu." 
                };
            }
        }

        /// <summary>
        /// Google Firebase UID ile login/register
        /// </summary>
        public async Task<AuthResponse> GoogleLoginAsync(GoogleLoginRequest request)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(request.FirebaseUid) || 
                    string.IsNullOrWhiteSpace(request.Email))
                {
                    return new AuthResponse 
                    { 
                        Success = false, 
                        Message = "FirebaseUid ve Email gereklidir." 
                    };
                }

                // Var mı kontrol et (FirebaseUid ile)
                var existingUser = await _context.Users
                    .FirstOrDefaultAsync(u => u.FirebaseUid == request.FirebaseUid);

                if (existingUser != null && existingUser.IsActive)
                {
                    existingUser.UpdatedAt = DateTime.UtcNow;
                    // Profil güncelleme
                    existingUser.DisplayName = request.DisplayName;
                    existingUser.PhotoUrl = request.PhotoUrl;
                    
                    _context.Users.Update(existingUser);
                    await _context.SaveChangesAsync();

                    _logger.LogInformation($"Google login başarılı: {existingUser.Email}");

                    return new AuthResponse
                    {
                        Success = true,
                        Message = "Google login başarılı!",
                        User = MapUserToDto(existingUser)
                    };
                }

                // Email ile de kontrol et (yeni Google hesabı eski email ile)
                var emailUser = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email.ToLower() == request.Email.ToLower());

                if (emailUser != null)
                {
                    // Mevcut kullanıcıya Google uid bağla
                    emailUser.FirebaseUid = request.FirebaseUid;
                    emailUser.Provider = "google";
                    emailUser.DisplayName = request.DisplayName;
                    emailUser.PhotoUrl = request.PhotoUrl;
                    emailUser.UpdatedAt = DateTime.UtcNow;
                    
                    _context.Users.Update(emailUser);
                    await _context.SaveChangesAsync();

                    _logger.LogInformation($"Email kullanıcısına Google uid bağlandı: {emailUser.Email}");

                    return new AuthResponse
                    {
                        Success = true,
                        Message = "Google hesabı bağlandı!",
                        User = MapUserToDto(emailUser)
                    };
                }

                // Yeni Google kullanıcısı oluştur
                var newGoogleUser = new User
                {
                    FirebaseUid = request.FirebaseUid,
                    Email = request.Email.ToLower(),
                    DisplayName = request.DisplayName,
                    PhotoUrl = request.PhotoUrl,
                    Provider = "google",
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                };

                _context.Users.Add(newGoogleUser);
                await _context.SaveChangesAsync();

                _logger.LogInformation($"Yeni Google kullanıcısı oluşturuldu: {newGoogleUser.Email}");

                return new AuthResponse
                {
                    Success = true,
                    Message = "Google ile kayıt başarılı!",
                    User = MapUserToDto(newGoogleUser)
                };
            }
            catch (Exception ex)
            {
                _logger.LogError($"Google login hatası: {ex.Message}");
                return new AuthResponse 
                { 
                    Success = false, 
                    Message = "Google login sırasında hata oluştu." 
                };
            }
        }

        /// <summary>
        /// ID ile kullanıcı al
        /// </summary>
        public async Task<UserDto?> GetUserByIdAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            return user == null ? null : MapUserToDto(user);
        }

        /// <summary>
        /// Email ile kullanıcı al
        /// </summary>
        public async Task<UserDto?> GetUserByEmailAsync(string email)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Email.ToLower() == email.ToLower());
            return user == null ? null : MapUserToDto(user);
        }

        /// <summary>
        /// User entity'yi UserDto'ya dönüştür
        /// </summary>
        private UserDto MapUserToDto(User user)
        {
            return new UserDto
            {
                Id = user.Id,
                Email = user.Email,
                DisplayName = user.DisplayName,
                PhotoUrl = user.PhotoUrl,
                Provider = user.Provider,
                FirebaseUid = user.FirebaseUid,
                CreatedAt = user.CreatedAt
            };
        }

        /// <summary>
        /// Şifre sıfırlama - yeni rastgele şifre üret ve SSMS'e kaydet
        /// </summary>
        public async Task<ResetPasswordResponse> ResetPasswordAsync(string email)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(email))
                {
                    return new ResetPasswordResponse
                    {
                        Success = false,
                        Message = "Email gereklidir."
                    };
                }

                var user = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email.ToLower() == email.ToLower());

                if (user == null)
                {
                    return new ResetPasswordResponse
                    {
                        Success = false,
                        Message = "Bu email adresine sahip kullanıcı bulunamadı."
                    };
                }

                // Yeni rastgele şifre oluştur (8 karakterli)
                string newPassword = GenerateRandomPassword(8);
                // Şifreyi trim et ve hash'le
                string passwordHash = BCrypt.Net.BCrypt.HashPassword(newPassword.Trim());

                // Veritabanında şifreyi güncelle
                user.PasswordHash = passwordHash;
                user.Provider = "local";
                user.UpdatedAt = DateTime.UtcNow;

                _context.Users.Update(user);
                await _context.SaveChangesAsync();

                _logger.LogInformation($"Şifre sıfırlama başarılı: {user.Email}");

                // TODO: Gerçek ortamda email gönder
                // await SendPasswordResetEmailAsync(user.Email, newPassword);

                return new ResetPasswordResponse
                {
                    Success = true,
                    Message = "Yeni şifreniz e-mail adresinize gönderilmiştir.",
                    NewPassword = newPassword // Sadece demo için (gerçek ortamda döndürme!)
                };
            }
            catch (Exception ex)
            {
                _logger.LogError($"Şifre sıfırlama hatası: {ex.Message}");
                return new ResetPasswordResponse
                {
                    Success = false,
                    Message = "Şifre sıfırlama işlemi sırasında hata oluştu."
                };
            }
        }

        /// <summary>
        /// Rastgele şifre oluştur
        /// </summary>
        private string GenerateRandomPassword(int length)
        {
            const string validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%";
            var random = new Random();
            return new string(Enumerable.Range(0, length)
                .Select(_ => validChars[random.Next(validChars.Length)])
                .ToArray());
        }
    }
}
