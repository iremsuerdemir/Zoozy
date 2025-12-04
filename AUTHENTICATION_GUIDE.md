# 🔐 Backend + Flutter Auth Entegrasyonu Rehberi

Bu doküman, Firebase Authentication'dan Backend merkezli authentication sistemine geçişin tüm adımlarını içerir.

---

## 📋 Sistem Mimarisi

```
Flutter App
    ↓
Auth Service (auth_service.dart)
    ↓
Backend API (C# .NET Core)
    ↓
SQL Server (SSMS)
```

---

## 🗄️ SQL Server Kurulumu

### 1. Users Tablosunu Oluştur

Aşağıdaki SQL komutunu SSMS'te çalıştır:

```sql
-- Users tablosunun oluşturulması (Authentication için)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        Id INT PRIMARY KEY IDENTITY(1,1),
        FirebaseUid NVARCHAR(200) NULL,
        Email NVARCHAR(200) NOT NULL UNIQUE,
        PasswordHash NVARCHAR(MAX) NULL,
        DisplayName NVARCHAR(200) NOT NULL,
        PhotoUrl NVARCHAR(500) NULL,
        Provider NVARCHAR(50) NOT NULL, -- 'local' ya da 'google'
        CreatedAt DATETIME DEFAULT GETUTCDATE(),
        UpdatedAt DATETIME NULL,
        IsActive BIT DEFAULT 1
    );

    CREATE INDEX IX_Email ON Users(Email);
    CREATE INDEX IX_FirebaseUid ON Users(FirebaseUid);
    CREATE INDEX IX_Provider ON Users(Provider);

    PRINT 'Users tablosu başarıyla oluşturuldu.'
END
ELSE
BEGIN
    PRINT 'Users tablosu zaten mevcut.'
END
```

### 2. Şifre Hash'i İçin Örnek Veri

```sql
-- Test kullanıcı (şifre: test123 - BCrypt hash)
INSERT INTO Users (Email, PasswordHash, DisplayName, Provider, IsActive)
VALUES (
    'test@example.com',
    '$2a$11$abcdefg...', -- BCrypt hash (C# backend tarafından oluşturulur)
    'Test User',
    'local',
    1
);
```

---

## ⚙️ Backend (C# .NET) Kurulumu

### 1. NuGet Paketini Ekle

`.csproj` dosyasında BCrypt paketi zaten eklenmiştir:

```xml
<PackageReference Include="BCrypt.Net-Next" Version="4.0.3" />
```

### 2. Dosya Yapısı

Backend projesinde aşağıdaki dosyalar eklenmiştir:

```
ZoozyApi/
├── Models/
│   └── User.cs (güncellenmiş)
├── Dtos/
│   ├── LoginRequest.cs
│   ├── RegisterRequest.cs
│   ├── GoogleLoginRequest.cs
│   └── AuthResponse.cs
├── Services/
│   └── AuthService.cs (yeni)
├── Controllers/
│   └── AuthController.cs (yeni)
└── Program.cs (güncellenmiş)
```

### 3. AppDbContext Güncellemesi

`Data/AppDbContext.cs`'te User DbSet zaten kayıtlı:

```csharp
public DbSet<User> Users => Set<User>();

// User indices
modelBuilder.Entity<User>()
    .HasIndex(u => u.Email)
    .IsUnique();

modelBuilder.Entity<User>()
    .HasIndex(u => u.FirebaseUid)
    .IsUnique()
    .HasFilter("[FirebaseUid] IS NOT NULL");
```

### 4. API Endpoints

#### a) Email + Şifre Kayıt

```
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePassword123",
  "displayName": "John Doe"
}

Response:
{
  "success": true,
  "message": "Kayıt başarılı!",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "displayName": "John Doe",
    "photoUrl": null,
    "provider": "local",
    "firebaseUid": null,
    "createdAt": "2025-01-15T10:30:00Z"
  }
}
```

#### b) Email + Şifre Login

```
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePassword123"
}

Response:
{
  "success": true,
  "message": "Login başarılı!",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "displayName": "John Doe",
    ...
  }
}
```

#### c) Google Login

```
POST /api/auth/google-login
Content-Type: application/json

{
  "firebaseUid": "firebase-uid-123456",
  "email": "user@gmail.com",
  "displayName": "John Doe",
  "photoUrl": "https://...",
  "provider": "google"
}

Response:
{
  "success": true,
  "message": "Google ile giriş başarılı!",
  "user": {
    "id": 2,
    "email": "user@gmail.com",
    "displayName": "John Doe",
    "photoUrl": "https://...",
    "provider": "google",
    "firebaseUid": "firebase-uid-123456",
    "createdAt": "2025-01-15T10:35:00Z"
  }
}
```

#### d) Kullanıcı Bilgisi Al

```
GET /api/auth/user/1
GET /api/auth/user-by-email/user@example.com

Response:
{
  "success": true,
  "user": {
    "id": 1,
    "email": "user@example.com",
    ...
  }
}
```

### 5. Program.cs Konfigürasyonu

AuthService DI container'a eklenmiştir:

```csharp
// Program.cs
builder.Services.AddScoped<IAuthService, AuthService>();
```

---

## 📱 Flutter Kurulumu

### 1. AuthService Yapısı (`lib/services/auth_service.dart`)

```dart
class AuthService {
  static const String baseUrl = 'http://localhost:5000/api/auth';

  // Login
  Future<AuthResponse> login({
    required String email,
    required String password,
  })

  // Register
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String displayName,
  })

  // Google Login
  Future<AuthResponse> googleLogin({
    required String firebaseUid,
    required String email,
    required String displayName,
    String? photoUrl,
  })

  // Helper Methods
  Future<void> logout()
  Future<UserData?> getCurrentUser()
  Future<bool> isLoggedIn()
}
```

### 2. Backend URL Ayarı

`lib/services/auth_service.dart` dosyasında backend URL'i ayarla:

```dart
static const String baseUrl = 'http://your-backend-url:5000/api/auth';

// Lokal geliştirme için:
static const String baseUrl = 'http://localhost:5000/api/auth';

// Android emülatör için:
static const String baseUrl = 'http://10.0.2.2:5000/api/auth';

// iOS emülatör için:
static const String baseUrl = 'http://localhost:5000/api/auth';
```

### 3. Ekranları Güncelle

#### Owner Login Page (`lib/screens/owner_Login_Page.dart`)

- Email/password login backend API'yle çalışıyor
- Google login Firebase → Backend flow'u

#### Register Page (`lib/screens/register_page.dart`)

- Email/password signup backend API'yle çalışıyor
- Google signup Firebase → Backend flow'u

### 4. SharedPreferences Kullanımı

Giriş yapan kullanıcı bilgileri otomatik olarak saklanır:

```dart
// AuthService tarafından otomatik kaydedilir:
- userId (Int)
- email (String)
- displayName (String)
- photoUrl (String, optional)
- provider (String) - 'local' or 'google'
- firebaseUid (String, optional)
```

Mevcut kullanıcıyı almak:

```dart
final authService = AuthService();

// Kullanıcı oturum açmış mı?
bool isLoggedIn = await authService.isLoggedIn();

// Mevcut kullanıcı bilgisi
UserData? user = await authService.getCurrentUser();

// Çıkış yap
await authService.logout();
```

---

## 🔄 Veri Akışı

### Email + Şifre Login

```
1. Flutter Login Screen
   ↓ (email + password)
2. AuthService.login()
   ↓ (POST /api/auth/login)
3. Backend AuthController
   ↓ (BCrypt verify)
4. Database Query (Users)
   ↓ (return UserDto)
5. Flutter ← Response
   ↓ (save to SharedPreferences)
6. Navigate to ExploreScreen
```

### Google Login

```
1. Flutter Login Screen
   ↓ (Google button tapped)
2. Firebase Auth
   ↓ (Google OAuth)
3. FirebaseUser (uid, email, displayName, photoUrl)
   ↓ (AuthService.googleLogin())
4. Backend AuthController
   ↓ (FirebaseUid exists?)
5. If Exists: Update & Return
   If New: Insert & Return
6. Database: Users (INSERT/UPDATE)
   ↓ (return UserDto)
7. Flutter ← Response
   ↓ (save to SharedPreferences)
8. Navigate to ExploreScreen
```

---

## 🧪 Test Örnekleri

### Postman Test Requests

#### 1. Register

```
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "email": "newuser@example.com",
  "password": "Test12345",
  "displayName": "New User"
}
```

#### 2. Login

```
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "newuser@example.com",
  "password": "Test12345"
}
```

#### 3. Google Login

```
POST http://localhost:5000/api/auth/google-login
Content-Type: application/json

{
  "firebaseUid": "123abc456def789ghi",
  "email": "user@gmail.com",
  "displayName": "Google User",
  "photoUrl": "https://lh3.googleusercontent.com/...",
  "provider": "google"
}
```

#### 4. Get User

```
GET http://localhost:5000/api/auth/user/1
GET http://localhost:5000/api/auth/user-by-email/user@example.com
```

---

## ⚠️ Önemli Notlar

### Şifre Güvenliği

- Tüm şifreler BCrypt ile hash'leniyor
- Plain-text şifreler asla saklanmıyor
- Her giriş şifresi BCrypt.Verify() ile kontrol ediliyor

### Provider Alanı

- `provider = 'local'` → Email/password ile kayıtlı
- `provider = 'google'` → Google ile kayıtlı
- Aynı email'le hem local hem google oturum açılabilir (bağlanmış sayılır)

### FirebaseUid Alanı

- Google login'de FirebaseUid kaydedilir
- Local login'de NULL kalır
- Unique constraint var (NULL değerleri yok sayar)

### CORS Ayarı

Backend CORS açık bırakılmıştır:

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

app.UseCors("AllowAll");
```

### Timeout

HTTP requests 15 saniye timeout'u var (AuthService)

---

## 🚀 Deployment

### Backend Deployment Checklist

- [ ] Connection string production'a göre güncelle
- [ ] BCrypt paketini yükle (`dotnet add package BCrypt.Net-Next`)
- [ ] HTTPS'yi etkinleştir
- [ ] CORS policy'i kısıtla (production domains'e göre)
- [ ] Logging'i ayarla
- [ ] Database migration'ları çalıştır

### Flutter Deployment Checklist

- [ ] Backend URL'i production'a göre güncelle
- [ ] SharedPreferences encrpytion'u etkinleştir
- [ ] Error handling'i iyileştir
- [ ] API timeout'larını ayarla

---

## 📞 Troubleshooting

### Problem: "Connection refused" hatası

**Çözüm**: Backend'in çalıştığını kontrol et

```bash
# Backend çalış
dotnet run
```

### Problem: "Email already in use" Firebase'de ama kayıt başarısız

**Çözüm**: Backend email unique constraint'ini kontrol et

```sql
SELECT * FROM Users WHERE Email = 'user@example.com'
```

### Problem: Google login sonrası profile redirect olmaz

**Çözüm**: AuthResponse'ı kontrol et ve Firebase UID'nin doğru gönderildiğini kontrol et

### Problem: Şifre verify başarısız

**Çözüm**:

1. BCrypt hash'in doğru kaydedildiğini kontrol et
2. Password'ün boş olmadığını kontrol et

---

## 📊 Database Query Örnekleri

### Tüm Kullanıcıları Listele

```sql
SELECT * FROM Users ORDER BY CreatedAt DESC;
```

### Provider'a Göre Kullanıcıları Listele

```sql
-- Sadece Email/Password kullanıcılar
SELECT * FROM Users WHERE Provider = 'local';

-- Sadece Google kullanıcılar
SELECT * FROM Users WHERE Provider = 'google';
```

### Son 24 Saatte Kaydolan Kullanıcılar

```sql
SELECT * FROM Users
WHERE CreatedAt >= DATEADD(DAY, -1, GETUTCDATE())
ORDER BY CreatedAt DESC;
```

### Aktif Olmayan Kullanıcılar

```sql
SELECT * FROM Users WHERE IsActive = 0;
```

---

## 🎓 Best Practices

1. **Şifre Güvenliği**: Asla plain-text şifre gönderme veya kaydetme
2. **API Security**: Production'da HTTPS kullan
3. **Error Handling**: Spesifik hata mesajları kullanıcıya gösterme
4. **Rate Limiting**: Brute force saldırıları önlemek için rate limiting ekle
5. **Audit Logging**: Giriş/kayıt işlemlerini log'la
6. **Token'lar**: Bearer token implement etmeyi düşün (JWT)
7. **Refresh Token**: Long-lived session'lar için refresh token'lar ekle

---

## 📝 Sonraki Adımlar

1. **JWT Token Authentication** ekle
2. **Email Verification** flow'u implement et
3. **Password Reset** functionality'si ekle
4. **Two-Factor Authentication** (2FA) ekle
5. **User Profile** güncellemesi fonksiyonalitesi ekle
6. **Session Management** ekle
7. **Audit Trail** logging'i implement et

---

Sorularınız için backend ve frontend'in aynı Authentication mantığını kullandığını unutmayın. 🔐
