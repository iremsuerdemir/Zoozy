# 🚀 Backend + Flutter Auth - Hızlı Başlangıç

## 1️⃣ SQL Server Setup (5 dakika)

SSMS'te aşağıdaki komutu çalıştır:

```sql
CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirebaseUid NVARCHAR(200) NULL,
    Email NVARCHAR(200) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(MAX) NULL,
    DisplayName NVARCHAR(200) NOT NULL,
    PhotoUrl NVARCHAR(500) NULL,
    Provider NVARCHAR(50) NOT NULL,
    CreatedAt DATETIME DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME NULL,
    IsActive BIT DEFAULT 1
);

CREATE INDEX IX_Email ON Users(Email);
CREATE INDEX IX_FirebaseUid ON Users(FirebaseUid);
CREATE INDEX IX_Provider ON Users(Provider);
```

---

## 2️⃣ Backend Setup (Backend klasöründe)

### NuGet paketini yükle:

```bash
dotnet add package BCrypt.Net-Next --version 4.0.3
```

### Backend'i çalıştır:

```bash
dotnet run
```

✅ Swagger: `http://localhost:5000/swagger`

---

## 3️⃣ Flutter Setup

### AuthService baseUrl'ini güncelle:

`lib/services/auth_service.dart`'ta:

```dart
// Lokal dev
static const String baseUrl = 'http://localhost:5000/api/auth';

// Android emülatör
static const String baseUrl = 'http://10.0.2.2:5000/api/auth';

// Gerçek server
static const String baseUrl = 'https://your-api.com/api/auth';
```

### Flutter'ı çalıştır:

```bash
flutter run
```

---

## 🧪 Hızlı Test (Postman)

### 1. Register

```
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "Test12345",
  "displayName": "Test User"
}
```

**Yanıt:**

```json
{
  "success": true,
  "message": "Kayıt başarılı!",
  "user": {
    "id": 1,
    "email": "test@example.com",
    "displayName": "Test User",
    "provider": "local"
  }
}
```

### 2. Login

```
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "Test12345"
}
```

### 3. Google Login

```
POST http://localhost:5000/api/auth/google-login
Content-Type: application/json

{
  "firebaseUid": "abc123xyz",
  "email": "user@gmail.com",
  "displayName": "Google User",
  "photoUrl": "https://...",
  "provider": "google"
}
```

### 4. Kullanıcı Al

```
GET http://localhost:5000/api/auth/user/1
GET http://localhost:5000/api/auth/user-by-email/test@example.com
```

---

## 📱 Flutter'da Test (UI)

### Test 1: Email + Şifre Signup

1. **Register Page** açılır
2. Email: `test@example.com`
3. Display Name: `Test User`
4. Şifre: `Test12345`
5. Kayıt Ol → ✅ ExploreScreen

### Test 2: Email + Şifre Login

1. **Login Page** açılır
2. Email: `test@example.com`
3. Şifre: `Test12345`
4. Giriş Yap → ✅ ExploreScreen

### Test 3: Google Login

1. Login Page → Google butonuna tıkla
2. Google hesabı seç
3. ✅ ExploreScreen (Firebase + Backend entegre)

---

## ⚡ Architecture

```
┌─────────────────────────────────────────┐
│        Flutter App                      │
│  (owner_Login_Page.dart)                │
│  (register_page.dart)                   │
└────────────┬────────────────────────────┘
             │
             │ HTTP POST/GET
             ↓
┌─────────────────────────────────────────┐
│    Backend (C# .NET)                    │
│  (AuthController)                       │
│  (AuthService + BCrypt)                 │
└────────────┬────────────────────────────┘
             │
             │ SQL Query
             ↓
┌─────────────────────────────────────────┐
│  SSMS (SQL Server)                      │
│  (Users Table)                          │
└─────────────────────────────────────────┘
```

---

## 🔑 Key Features

| Feature                   | Status |
| ------------------------- | ------ |
| Email + Password Signup   | ✅     |
| Email + Password Login    | ✅     |
| Google OAuth Login        | ✅     |
| BCrypt Password Hashing   | ✅     |
| SharedPreferences Storage | ✅     |
| User Profile Management   | ✅     |
| CORS Enabled              | ✅     |
| Error Handling            | ✅     |

---

## ⚙️ Yapılandırma

### Backend (appsettings.json)

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=your-server;Database=Zoozy;Trusted_Connection=True;"
  }
}
```

### Flutter (auth_service.dart)

```dart
static const String baseUrl = 'http://localhost:5000/api/auth';
```

---

## 🚨 Sık Hatalar

| Hata                 | Çözüm                                                    |
| -------------------- | -------------------------------------------------------- |
| Connection refused   | Backend'i başlat: `dotnet run`                           |
| Email already in use | DB'de email var: `SELECT * FROM Users WHERE Email='...'` |
| Password mismatch    | Şifreyi BCrypt.Verify() ile kontrol et                   |
| 401 Unauthorized     | Email/password yanlış                                    |
| CORS Error           | `appsettings.json`'da CORS açık mı?                      |

---

## 📚 Full Documentation

- **Backend Guide**: `AUTHENTICATION_GUIDE.md`
- **Migration Summary**: `MIGRATION_SUMMARY.md`
- **API Spec**: `AUTHENTICATION_GUIDE.md` → API Endpoints

---

## 🎯 Next Steps

1. ✅ Users tablosunu oluştur
2. ✅ Backend'i çalıştır
3. ✅ Flutter'ı çalıştır
4. ✅ Test et
5. ⏳ Email verification ekle
6. ⏳ JWT token ekle
7. ⏳ Refresh token ekle

---

**Başarılar!** 🚀
