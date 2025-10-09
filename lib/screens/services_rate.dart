import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/add_location.dart';
import 'package:zoozy/screens/add_service_rate_page.dart';

class ServiceRatesPage extends StatefulWidget {
  final String initialServiceName;

  const ServiceRatesPage({super.key, required this.initialServiceName});

  @override
  State<ServiceRatesPage> createState() => _ServiceRatesPageState();
}

class _ServiceRatesPageState extends State<ServiceRatesPage> {
  // ScrollController tanımla (Scrollbar hatası çözümü için)
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> _rateCards = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Yeni bir servis oranı eklemek için kullanılan fonksiyon
  Future<void> _navigateToAddServiceRate(String currentServiceName) async {
    final newRate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddServiceRatePageFromPrefs(),
        settings: RouteSettings(arguments: {'serviceName': currentServiceName}),
      ),
    );

    if (newRate != null && mounted) {
      setState(() {
        _rateCards.add({
          'title': newRate['title'],
          'subtitle': newRate['subtitle'],
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonColor1 = Color(0xFFB39DDB);
    const Color buttonColor2 = Color(0xFFF48FB1);

    // HATA DÜZELTİLDİ: serviceTitle, artık doğru kaynaktan (widget.initialServiceName) alınıyor.
    final String serviceTitle = widget.initialServiceName.isEmpty
        ? 'Seçilen Hizmet'
        : widget.initialServiceName;

    return Scaffold(
      body: Stack(
        children: [
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
                // Üst bar
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
                      Text(
                        '${serviceTitle} Fiyatları', // Dinamik başlık
                        style: const TextStyle(
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

                // İçerik
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
                                // Scrollbar ve Controller kullanıldı
                                child: Scrollbar(
                                  controller: _scrollController,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Dinamik olarak mevcut ve eklenen kartlar
                                        for (var card in _rateCards)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: _rateCard(
                                              title: card['title']!,
                                              subtitle: card['subtitle']!,
                                              fontSize: fontSize,
                                              onTap: () async {
                                                final serviceName =
                                                    card['title'] ??
                                                    widget.initialServiceName;
                                                _navigateToAddServiceRate(
                                                  serviceName,
                                                );
                                              },
                                            ),
                                          ),

                                        // Yeni Fiyat Ekle Kartı
                                        _rateCard(
                                          title:
                                              '${serviceTitle} İçin Fiyat Ekle',
                                          subtitle:
                                              'Hizmet fiyatınız evcil hayvan türüne veya boyutuna göre değişiyorsa, bu liste için birden fazla fiyat eklemek için buraya dokunun.',
                                          fontSize: fontSize,
                                          onTap: () {
                                            _navigateToAddServiceRate(
                                              serviceTitle,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              // Alt İLERİ butonu
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddLocation(),
                                    ),
                                  );
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
            fontWeight: FontWeight.w600,
            color: Colors.black87,
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
