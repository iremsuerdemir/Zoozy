import 'package:flutter/material.dart';
import 'package:zoozy/screens/agreement_screen.dart';

// Services ekranı
class Services extends StatelessWidget {
  const Services({super.key});

  // Tüm Servicesin listesi
  final List<Map<String, String>> Service = const [
    {
      'title': 'Evcil Hayvan Pansiyonu',
      'description': 'Evcil hayvanınız gece boyunca bakıma ihtiyaç duyuyorsa.',
    },
    {
      'title': 'Günlük Bakım',
      'description':
          'Evcil hayvanınızın gündüz bakımı, evcil hayvan dostu evde.',
    },
    {
      'title': 'Evcil Hayvan Bakımı',
      'description': 'Ev ziyaretleri veya evde bakım Servicesi için.',
    },
    {
      'title': 'Köpek Gezdirme',
      'description': 'Köpeğinizin yürüyüşe ihtiyacı varsa.',
    },
    {
      'title': 'Evcil Hayvan Taksi',
      'description': 'Evcil hayvanınız bir yere gitmesi gerektiğinde.',
    },
    {
      'title': 'Evcil Hayvan Tımarı',
      'description': 'Evcil hayvanınıza yeni bir görünüm kazandırın.',
    },
    {
      'title': 'Evcil Hayvan Eğitimi',
      'description': 'Evcil hayvanınızı en iyi davranış biçimine eğitin.',
    },
    {
      'title': 'Evcil Hayvan Fotoğrafçılığı',
      'description': 'Evcil hayvanınızın profesyonel fotoğraflarını çekin.',
    },
    {
      'title': 'Veteriner',
      'description': 'Evcil hayvanınız kendini iyi hissetmediğinde.',
    },
  ];

  final String resimYolu = 'assets/images/login_3.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan gradyanı LoginPage temasıyla uyumlu
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2A4FF), Color(0xFFFFC1C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Başlık
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ortadaki Hizmetler + Pet ikonu
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Hizmetler',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.pets,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),

                    // Sol üstte geri ikonu

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AgreementScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Services listesi
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: Service.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: HizmetKart(
                          baslik: Service[index]['title']!,
                          aciklama: Service[index]['description']!,
                          resimYolu: resimYolu,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Her bir hizmet için özel kart widget'ı
class HizmetKart extends StatelessWidget {
  final String baslik;
  final String aciklama;
  final String resimYolu;

  const HizmetKart({
    required this.baslik,
    required this.aciklama,
    required this.resimYolu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Resim
              ClipOval(
                child: Image.asset(
                  resimYolu,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: const Icon(Icons.pets, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Başlık ve açıklama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baslik,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      aciklama,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
