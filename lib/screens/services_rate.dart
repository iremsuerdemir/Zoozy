import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/add_service_rate_page.dart';

class ServiceRatesPage extends StatelessWidget {
  const ServiceRatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Alt buton gradient renkleri
    const Color buttonColor1 = Color(0xFFB39DDB);
    const Color buttonColor2 = Color(0xFFF48FB1);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar yerine üst kısım
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Hizmet Fiyatları',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Responsive içerik alanı
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth = math.min(
                        constraints.maxWidth * 0.9,
                        900,
                      );
                      final double fontSize = constraints.maxWidth > 1000
                          ? 18
                          : (constraints.maxWidth < 360 ? 14 : 16);

                      return Center(
                        child: Container(
                          width: maxContentWidth,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 1. Mevcut Fiyat Kartı
                                      _rateCard(
                                        title: 'Evcil Hayvan Bakımı',
                                        subtitle: 'TRY225/gece\nEe',
                                        fontSize: fontSize,
                                        onTap: () {
                                          print(
                                            'Mevcut fiyat düzenleme tıklandı.',
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 12),

                                      // 2. Yeni Fiyat Ekle Kartı
                                      _rateCard(
                                        title: 'Hizmet Fiyatı Ekle',
                                        subtitle:
                                            'Hizmet fiyatınız evcil hayvan türüne veya boyutuna göre değişiyorsa, bu liste için birden fazla fiyat eklemek için buraya dokunun.',
                                        fontSize: fontSize,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddServiceRatePageFromPrefs(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              // Alt İLERİ butonu
                              GestureDetector(
                                onTap: () {
                                  print('İLERİ butonuna tıklandı.');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [buttonColor1, buttonColor2],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'İLERİ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kart widget'ı
  Widget _rateCard({
    required String title,
    required String subtitle,
    required double fontSize,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600, // biraz daha kalın
            color: Colors.black87, // koyu renk
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: fontSize - 2, color: Colors.black54),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
