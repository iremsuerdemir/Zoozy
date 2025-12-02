import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/agreement_screen.dart';

class ListingProcessScreen extends StatelessWidget {
  const ListingProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = 60.0;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB39DDB), // Açık mor
                  Color(0xFFF48FB1), // Açık pembe
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Başlık
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Listeleme Süreci',
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
                              // Scrollable içerik
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Üstte geniş resim
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          'assets/images/login_3.png',
                                          width: double.infinity,
                                          height: 350,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 40),

                                      // Bilgilendirme kutusu
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 244, 198),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                                fontSize: fontSize,
                                                height: 1.5,
                                                color: Colors.black),
                                            children: [
                                              const TextSpan(
                                                text:
                                                    'Başvurunuz, işlere yanıt verebilmeniz için sıkı bir onay sürecinden geçecektir. '
                                                    'Bu, evcil hayvanların iyi Pet Hostlar, Gezdiriciler ve diğer bakım sağlayıcıları tarafından güvenle bakıldığından emin olmak içindir. '
                                                    'Tüm aşağıdaki adımları tamamladıktan sonra süreç ',
                                              ),
                                              TextSpan(
                                                text: '7 iş günü',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const TextSpan(
                                                  text: ' sürecektir.'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),

                                      /// Adım 1
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.purple,
                                              child: const Text(
                                                '1',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),

                                            // Metin ve link
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'KİMLİK DOĞRULAMA',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'Resmi kimliğinizin (TC Kimlik, Pasaport veya Ehliyet) fotokopisini, kimlik numarası gizlenmiş şekilde gönderin. Ardından, kimliğinizle birlikte bir selfie gönderin.',
                                                    style: TextStyle(
                                                        fontSize: fontSize),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'Daha Fazla Bilgi',
                                                    style: TextStyle(
                                                        fontSize: fontSize,
                                                        color: const Color(
                                                            0xFF7B4FDA),
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Resim
                                            Image.asset(
                                              'assets/images/login_3.png',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(width: 16),
                                          ],
                                        ),
                                      ),
                                      const Divider(indent: 16, endIndent: 16),

                                      /// Adım 2
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.purple,
                                              child: const Text(
                                                '2',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'REFERANSLAR',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'Yeniyseniz, hayvanları ne kadar sevdiğinizi bilen 3 veya daha fazla arkadaşınızdan yorum alın. Yorumlar, arkadaşlarınızın sizi onaylaması gibidir. Sayfanızı arkadaşlarınıza veya müşterilerinize gönderin.',
                                                    style: TextStyle(
                                                        fontSize: fontSize),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'Daha Fazla Bilgi',
                                                    style: TextStyle(
                                                        fontSize: fontSize,
                                                        color: const Color(
                                                            0xFF7B4FDA),
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Image.asset(
                                              'assets/images/login_3.png',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(width: 16),
                                          ],
                                        ),
                                      ),
                                      const Divider(indent: 16, endIndent: 16),

                                      /// Adım 3
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.purple,
                                              child: const Text(
                                                '3',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'BAKICI TANITIM TESTİ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'PetBacker hakkında hızlı bir bilgilendirme alın, olası hatalardan kaçının ve daha fazla iş alma şansınızı artırın. Testi tamamlayarak rozet kazanın.',
                                                    style: TextStyle(
                                                        fontSize: fontSize),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'Daha Fazla Bilgi',
                                                    style: TextStyle(
                                                        fontSize: fontSize,
                                                        color: const Color(
                                                            0xFF7B4FDA),
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Image.asset(
                                              'assets/images/login_3.png',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 40),

                                      /// İlk kez kullanıcı rehberi
                                      Container(
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 244, 198),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                fontSize: fontSize,
                                                color: Colors.black),
                                            children: [
                                              const TextSpan(
                                                  text:
                                                      'İlk kez bizimle misiniz ? '),
                                              TextSpan(
                                                text: 'Temel rehberi',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF7B4FDA),
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              const TextSpan(
                                                  text:
                                                      ' okuyarak başlayabilirsiniz.'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 80),
                                    ],
                                  ),
                                ),
                              ),

                              // Alt buton
                              SizedBox(
                                height: buttonHeight,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AgreementScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    backgroundColor: Colors.purple,
                                  ),
                                  child: const Text(
                                    'Liste Oluştur',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
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
}
