// services.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoozy/providers/service_provider.dart';
import 'package:zoozy/screens/about_me_page.dart'; // İlk durak
import 'package:zoozy/screens/agreement_screen.dart';

// Services ekranı
class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final ScrollController _scrollController = ScrollController();

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                        Icon(Icons.pets, color: Colors.white, size: 30),
                      ],
                    ),
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
                                builder: (context) => const AgreementScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: Service.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: HizmetKart(
                          baslik: Service[index]['title']!,
                          aciklama: Service[index]['description']!,
                          resimYolu: resimYolu,
                          onTap: () {
                            final selectedService = Service[index]['title']!;

                            Provider.of<ServiceProvider>(context, listen: false)
                                .setService(selectedService);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutMePage(),
                                settings: RouteSettings(
                                  arguments: {
                                    'serviceName': selectedService,
                                  },
                                ),
                              ),
                            );
                          },
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

// Hizmet Kart Widget (Değişmedi)
class HizmetKart extends StatelessWidget {
  final String baslik;
  final String aciklama;
  final String resimYolu;
  final VoidCallback? onTap;

  const HizmetKart({
    required this.baslik,
    required this.aciklama,
    required this.resimYolu,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
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
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
