# Zoozy

Zoozy, evcil hayvan sahipleri ile veteriner, bakıcı, kuaför ve eğitimci hizmet sağlayıcılarını tek çatı altında buluşturan bir ekosistemdir. Proje iki bileşenden oluşur:

1. **Flutter mobil uygulaması** – raporlamayı ve REST API verilerini aynı arayüzde sunar.
2. **C#/.NET 8 Web API (ZoozyApi)** – Firebase’den gelen verileri MSSQL üzerinde saklayan servisler.

## Backend (ZoozyApi) kurulumu

```bash
cd ZoozyApi
dotnet restore
dotnet build
```

### Bağlantı dizesini güvenli şekilde yönetme

1. User Secrets etkinleştirin (tek seferlik):
   ```bash
   dotnet user-secrets init
   ```
2. Yerel/veri merkezi bağlantınızı secrets veya ortam değişkeni olarak girin:
   ```bash
   dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Server=sqlserver.domain.com,1433;Database=ZoozyDb;User Id=zoozy_app;Password=Strong!Pass;TrustServerCertificate=True"
   ```
   Alternatif olarak `ZOOZY_SQL_CONN` ortam değişkenini tanımlayabilirsiniz; uygulama sırasıyla User Secrets → ortam değişkeni → `appsettings*.json` dosyalarını okur.

### MSSQL şemasını oluşturma

Repo, `InitialCreate` migrasyonunu içerir. Aşağıdaki komutlar ile şemayı oluşturup güncel tutabilirsiniz:

```bash
dotnet ef database update
```

### API’yı çalıştırma

```bash
dotnet watch run
```

Swagger arayüzü varsayılan olarak `https://localhost:5001/swagger` adresinde açılır. API uçları:

- `GET /api/petprofiles`
- `GET /api/serviceproviders`
- `GET /api/servicerequests`
- `POST /api/firebase/sync`

## Flutter uygulaması

### Hazırlık

```bash
flutter pub get
```

API taban adresini build sırasında `ZOOZY_API_URL` ile geçebilirsiniz:

```bash
flutter run --dart-define=ZOOZY_API_URL=https://10.0.2.2:5001/api
```



Servis katmanı `lib/services/zoozy_api_service.dart` dosyasında yer alır ve `ZoozyApiService.fetchDashboardData()` metodu üzerinden tüm veri akışını sunar.
