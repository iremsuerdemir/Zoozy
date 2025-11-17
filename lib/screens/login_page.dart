import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zoozy/screens/explore_screen.dart';
import 'package:zoozy/screens/owner_login_page.dart';
import 'package:zoozy/services/guest_access_service.dart';

void main() {
  runApp(const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PageController _sayfaKontrol = PageController(viewportFraction: 0.8);
  int _aktifSayfa = 0;
  Timer? _timer;

  final List<Map<String, String>> _ekranlar = [
    {
      'image': 'assets/images/login_1.png',
      'title': 'Güvenilir Evcil Hayvan Bakıcıları Bulun',
      'description':
          'Evcil hayvan pansiyonu, evde bakım, köpek gezdirme ve daha fazlası',
    },
    {
      'image': 'assets/images/login_2.png',
      'title': 'Ödeme ve Evcil Hayvan Koruması Alın',
      'description': 'Her rezervasyon, güvenli ödemeleri ve korumayı içerir',
    },
    {
      'image': 'assets/images/login_3.png',
      'title': 'Evcil Hayvan Severlerle Bağlanın',
      'description':
          'Hizmetler rezervasyonu yapın ve diğer pet severlerle sohbet edin',
    },
    {
      'image': 'assets/images/login_4.png',
      'title': 'Köpeğinizin Gezilerini Kaydedin',
      'description': 'Yürüyüşlerini, mesafesini ve süresini görün',
    },
  ];

  @override
  void initState() {
    super.initState();

    _sayfaKontrol.addListener(() {
      int sonraki = _sayfaKontrol.page!.round();
      if (_aktifSayfa != sonraki) {
        setState(() {
          _aktifSayfa = sonraki;
        });
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_aktifSayfa < _ekranlar.length - 1) {
        _aktifSayfa++;
      } else {
        _aktifSayfa = 0;
      }
      _sayfaKontrol.animateToPage(
        _aktifSayfa,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _sayfaKontrol.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _noktaGosterge(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: _aktifSayfa == index ? 20.0 : 8.0,
      decoration: BoxDecoration(
        color: _aktifSayfa == index
            ? const Color(0xFF7A4FAD)
            : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  Widget _butonOlustur({
    required String metin,
    required Color renk,
    required Color metinRengi,
    required VoidCallback tiklamaFonksiyonu,
    bool cizgili = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: tiklamaFonksiyonu,
          style: ElevatedButton.styleFrom(
            backgroundColor: renk,
            foregroundColor: metinRengi,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: cizgili
                  ? const BorderSide(color: Color(0xFF7A4FAD), width: 2)
                  : BorderSide.none,
            ),
            elevation: 5,
          ),
          child: Text(
            metin,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
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
              // Başlık
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.pets, color: Colors.white, size: 30),
                    const SizedBox(width: 8),
                    const Text(
                      'Zoozy',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Sayfa Görüntüleyici
              Expanded(
                child: PageView.builder(
                  controller: _sayfaKontrol,
                  itemCount: _ekranlar.length,
                  itemBuilder: (context, index) {
                    double scale = _aktifSayfa == index ? 1.0 : 0.9;
                    return AnimatedScale(
                      duration: const Duration(milliseconds: 350),
                      scale: scale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 16.0,
                        ),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    _ekranlar[index]['image']!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _ekranlar[index]['title']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _ekranlar[index]['description']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Sayfa göstergesi
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_ekranlar.length, _noktaGosterge),
                ),
              ),

              // Butonlar
              _butonOlustur(
                metin: 'Evcil Hayvan Sahibi',
                renk: const Color(0xFF7A4FAD), // mor
                metinRengi: Colors.white,
                tiklamaFonksiyonu: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OwnerLoginPage(),
                    ),
                  );
                },
              ),
              _butonOlustur(
                metin: 'Bakıcı & Hizmetler',
                renk: const Color(0xFFFFA726), // turuncu
                metinRengi: Colors.white,
                tiklamaFonksiyonu: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OwnerLoginPage(),
                    ),
                  );
                },
              ),
              _butonOlustur(
                metin: 'Keşfet',
                renk: const Color(0xFFB2A4FF), // açık mor
                metinRengi: Colors.white,
                tiklamaFonksiyonu: () async {
                  await GuestAccessService.enableGuestMode();
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExploreScreen(),
                    ),
                  );
                },
                cizgili: true,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
