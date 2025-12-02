import 'package:flutter/material.dart';

void main() {
  runApp(const ZoozyGirisUygulamasi());
}

class ZoozyGirisUygulamasi extends StatelessWidget {
  const ZoozyGirisUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ZoozyGirisEkrani(),
    );
  }
}

class ZoozyGirisEkrani extends StatefulWidget {
  const ZoozyGirisEkrani({super.key});

  @override
  State<ZoozyGirisEkrani> createState() => _ZoozyGirisEkraniState();
}

class _ZoozyGirisEkraniState extends State<ZoozyGirisEkrani> {
  final PageController _sayfaKontrol = PageController();
  int _aktifSayfa = 0;

  // Kaydırmalı ekranlar
  final List<Map<String, String>> _ekranlar = [
    {
      'image': 'assets/images/login_1.png',
      'title': 'Güvenilir Evcil Hayvan Bakıcıları',
      'description':
          'Evcil hayvan pansiyonu, evde bakım, köpek gezdirme ve daha fazlasını bulun',
    },
    {
      'image': 'assets/images/login_2.png',
      'title': 'Ödeme ve Evcil Hayvan Koruması',
      'description':
          'Her rezervasyon, evcil hayvan koruması ve güvenli ödemeleri içerir',
    },
    {
      'image': 'assets/images/login_3.png',
      'title': 'Evcil Hayvan Severlerle Bağlanın',
      'description':
          'Evcil hayvan anlarını paylaşın, hatırlatıcılar ayarlayın ve hizmetler rezervasyonu yapın',
    },
    {
      'image': 'assets/images/login_4.png',
      'title': 'Köpeğinizin Gezilerini Kaydedin',
      'description':
          'Evcil hayvanınızın yürüyüşlerini, mesafesini ve süresini yerleşik GPS ile görün',
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
  }

  @override
  void dispose() {
    _sayfaKontrol.dispose();
    super.dispose();
  }

  // Sayfa göstergesi (dot)
  Widget _noktaGosterge(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: _aktifSayfa == index
            ? const Color(0xFF7A4FAD)
            : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  // Buton oluşturucu
  Widget _butonOlustur({
    required String metin,
    required Color renk,
    required Color metinRengi,
    required VoidCallback tiklamaFonksiyonu,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: tiklamaFonksiyonu,
          style: ElevatedButton.styleFrom(
            backgroundColor: renk,
            foregroundColor: metinRengi,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Text(
            metin,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Başlık
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  Icon(Icons.pets, color: Color(0xFF7A4FAD), size: 30),
                  SizedBox(width: 8),
                  Text(
                    'Zoozy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _sayfaKontrol,
                itemCount: _ekranlar.length,
                itemBuilder: (context, index) {
                  return _ekranIcerigiOlustur(_ekranlar[index]);
                },
              ),
            ),

            // Nokta göstergeleri
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _ekranlar.length,
                  (index) => _noktaGosterge(index),
                ),
              ),
            ),

            // Butonlar
            Column(
              children: [
                _butonOlustur(
                  metin: 'Evcil Hayvan Sahibi',
                  renk: const Color(0xFF7A4FAD),
                  metinRengi: Colors.white,
                  tiklamaFonksiyonu: () {
                    debugPrint('Evcil Hayvan Sahibi tıklandı');
                  },
                ),
                _butonOlustur(
                  metin: 'Bakıcı & Hizmetler',
                  renk: const Color(0xFFC7846E),
                  metinRengi: Colors.white,
                  tiklamaFonksiyonu: () {
                    debugPrint('Bakıcı & Hizmetler tıklandı');
                  },
                ),
                _butonOlustur(
                  metin: 'Keşfet',
                  renk: Colors.transparent,
                  metinRengi: const Color(0xFF7A4FAD),
                  tiklamaFonksiyonu: () {
                    debugPrint('Keşfet tıklandı');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ekranIcerigiOlustur(Map<String, String> veri) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(veri['image']!, fit: BoxFit.contain),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  veri['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  veri['description']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
