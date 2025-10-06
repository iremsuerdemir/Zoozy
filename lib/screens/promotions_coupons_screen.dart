import 'package:flutter/material.dart';
import 'package:zoozy/screens/profile_screen.dart';

class PromotionsCouponsScreen extends StatelessWidget {
  const PromotionsCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final promotions = [
      {
        'title': 'İlk Rezervasyon İndirimi',
        'description': 'İlk rezervasyonunda %20 indirim kazan!',
        'code': 'ZOOZY20',
        'expiry': '31 Aralık 2025'
      },
      {
        'title': 'Arkadaşını Davet Et',
        'description': 'Arkadaşını getir, ikiniz de 25₺ kazanın!',
        'code': 'REFER25',
        'expiry': '30 Kasım 2025'
      },
      {
        'title': 'Sadakat Bonusu',
        'description': '5 rezervasyon yap, 6. hizmet %50 indirimli!',
        'code': 'LOYALTY50',
        'expiry': '31 Ocak 2026'
      },
    ];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Başlık
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Stack(
                  alignment:
                      Alignment.center, // Ortadaki öğeyi tam merkeze alır
                  children: [
                    // Soldaki geri ikonu
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen())),
                      ),
                    ),
                    // Ortadaki ikon ve yazı
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Promosyonlar & Kuponlar',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // İçerik Kartları
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: promotions.length,
                    itemBuilder: (context, index) {
                      final promo = promotions[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_offer,
                                      color: Color(0xFF7A4FAD), size: 28),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      promo['title']!,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7A4FAD)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                promo['description']!,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      promo['code']!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7A4FAD)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                              '${promo['code']} kopyalandı!'),
                                          duration: const Duration(seconds: 2),
                                        ));
                                      },
                                      child: const Text(
                                        'KOPYALA',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7A4FAD),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Son kullanım: ${promo['expiry']}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 158, 158, 158)),
                              ),
                            ],
                          ),
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
