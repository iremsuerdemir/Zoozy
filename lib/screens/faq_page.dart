import 'dart:math' as math;

import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        "question": "Zoozy nedir?",
        "answer":
            "Zoozy, hayvanseverlerin gönüllü olarak evcil hayvanlara destek olabildiği bir topluluk uygulamasıdır.",
      },
      {
        "question": "Gönüllü olarak nasıl katılabilirim?",
        "answer":
            "Profil oluşturduktan sonra 'Gönüllü Ol' bölümünden katılım formunu doldurabilir ve uygun olduğunuz zaman aralıklarını seçebilirsiniz.",
      },
      {
        "question": "Gönüllüler hangi görevleri üstlenebilir?",
        "answer":
            "Yürüyüşe çıkarma, kısa süreli bakım, besleme veya sahiplenmeye destek gibi birçok alanda gönüllü olabilirsiniz.",
      },
      {
        "question": "Zoozy’deki tüm hizmetler ücretsiz mi?",
        "answer":
            "Evet. Zoozy tamamen gönüllülük esasına dayanır ve hiçbir hizmet için ücret talep edilmez.",
      },
      {
        "question": "Evcil hayvanım için gönüllü bulmak güvenli mi?",
        "answer":
            "Evet, tüm gönüllüler profil doğrulamasından geçer. Ayrıca yorum ve puanlama sistemi ile güven ortamı sağlanır.",
      },
      {
        "question": "Gönüllüyle iletişime nasıl geçebilirim?",
        "answer":
            "Profil sayfasındaki 'Mesaj Gönder' butonu ile uygulama içi sohbet üzerinden iletişim kurabilirsiniz.",
      },
      {
        "question": "Uygulamayı kullanmak için ücret ödemem gerekiyor mu?",
        "answer":
            "Hayır, Zoozy tamamen ücretsizdir. Tek şart, hayvanları gerçekten sevmek ve gönüllü olarak destek olmak!",
      },
      {
        "question": "Nasıl daha fazla gönüllüye ulaşabilirim?",
        "answer":
            "Profilinizi tamamlayın, fotoğraflar ekleyin ve aktif olun. Uygulama, yakınınızdaki gönüllülerle eşleşmenizi kolaylaştırır.",
      },
      {
        "question": "Zoozy hangi şehirlerde kullanılabiliyor?",
        "answer":
            "Şu anda Türkiye genelinde hizmet vermekteyiz. Ancak bazı bölgelerde gönüllü yoğunluğu daha fazladır.",
      },
    ];

    // Gradient arka plan
    Widget _buildBackground() {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }

    // Başlık
    Widget _buildHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            const Text(
              "Sıkça Sorulan Sorular",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // İçerik kartı
    Widget _buildContentBody() {
      return Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxContentWidth = math.min(
              constraints.maxWidth * 0.9,
              900,
            );

            return Center(
              child: Container(
                width: maxContentWidth,
                padding: const EdgeInsets.all(16),
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
                child: ListView.builder(
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    final faq = faqs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: Text(
                          faq["question"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A4FAD),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              faq["answer"]!,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildContentBody(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
