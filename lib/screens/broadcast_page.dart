import 'package:flutter/material.dart';

import 'package:zoozy/components/CaregiverCard.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';

import 'package:zoozy/screens/CaregiverProfilpage.dart';

const Color _primaryColor = Colors.deepPurple;
const Color _broadcastButtonColor = Color(0xFF9C7EB9);

const Color _lightLilacBackground = Color(0xFFF3E5F5);

class BackersNearbyScreen extends StatefulWidget {
  const BackersNearbyScreen({super.key});

  @override
  State<BackersNearbyScreen> createState() => _BackersNearbyScreenState();
}

class _BackersNearbyScreenState extends State<BackersNearbyScreen> {
  // 🔹 Çoğaltılmış Örnek Veri Listesi (Toplam 8 kart)
  final List<Map<String, dynamic>> _backers = [
    {
      'name': 'Tanks Corner Daycare',
      'imagePath': 'assets/images/caregiver3.jpg',
      'suitability': 'Köpekler',
      'price': 45.00,
      'isFavorite': false,
    },
    {
      'name': 'Istanbul Pet Buddy',
      'imagePath': 'assets/images/caregiver1.png',
      'suitability': 'Kediler',
      'price': 30.50,
      'isFavorite': true,
    },
    {
      'name': 'Can dost Pansiyonu',
      'imagePath': 'assets/images/caregiver2.jpeg',
      'suitability': 'Tüm Hayvanlar',
      'price': 65.00,
      'isFavorite': false,
    },
    {
      'name': 'Juliet Wan Gezdirme',
      'imagePath': 'assets/images/caregiver1.png',
      'suitability': 'Gezdirme',
      'price': 35.00,
      'isFavorite': true,
    },
    {
      'name': 'Animal Care Pro',
      'imagePath': 'assets/images/caregiver3.jpg',
      'suitability': 'Gündüz Bakımı',
      'price': 55.00,
      'isFavorite': false,
    },
    {
      'name': 'Pati Kafe & Pansiyon',
      'imagePath': 'assets/images/caregiver2.jpeg',
      'suitability': 'Pansiyon',
      'price': 80.00,
      'isFavorite': true,
    },
    {
      'name': 'Kadıköy Evde Bakım',
      'imagePath': 'assets/images/caregiver1.png',
      'suitability': 'Evde Bakım',
      'price': 40.00,
      'isFavorite': false,
    },
    {
      'name': 'Fıstık Aile Bakımı',
      'imagePath': 'assets/images/caregiver3.jpg',
      'suitability': 'Tüm Hayvanlar',
      'price': 50.00,
      'isFavorite': false,
    },
  ];

  // 🔹
  void _navigateToCaregiverProfile(int index) {
    final backer = _backers[index];

    // Zorunlu parametreler, dinamik ve örnek verilerle gönderiliyor.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaregiverProfilpage(
          // DİNAMİK VERİLER
          displayName: backer['name'] as String,
          userName: backer['name']
              .toString()
              .toLowerCase()
              .replaceAll(RegExp(r'[^\w]+'), '_'),
          userPhoto: backer['imagePath'] as String,

          // ZORUNLU SABİT/ÖRNEK VERİLER
          location: "İstanbul / Kadıköy",
          bio:
              "7 yılı aşkın süredir evcil hayvan bakımı yapıyorum. Güvenli ve sevgi dolu bir ortam sağlarım.",
          userSkills: "Köpek Gezdirme, Kedi Pansiyonu",
          otherSkills: "İlk Yardım Sertifikası",
          followers: 125,
          following: 30,
          reviews: const [
            {
              'id': 'r1',
              'name': 'Örnek Kullanıcı',
              'comment': 'Harika bir deneyimdi!',
              'rating': 5,
              'timePosted': '2023-01-01T12:00:00Z',
              'photoUrl': 'assets/images/profile_placeholder.png'
            }
          ],
          moments: const [
            {
              'userName': '@tankscornermoments',
              'displayName': 'Moments',
              'userPhoto': 'assets/images/caregiver3.jpg',
              'postImage': 'assets/images/caregiver3.jpg',
              'description': 'Güzel bir gün...',
              'likes': 10,
              'comments': 5,
              'timePosted': '2023-01-01T12:00:00Z'
            },
          ],
        ),
      ),
    );
  }

  // Favori durumu değiştiğinde _backers listesini güncelleyen fonksiyon.
  void _updateFavoriteStatus(int index) {
    setState(() {
      _backers[index]['isFavorite'] = !_backers[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final rowCount = (_backers.length / 2).ceil();

    return Scaffold(
      backgroundColor: _lightLilacBackground,

      // --- 1. Uygulama Çubuğu (App Bar) ---
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Backers nearby',
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _primaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      // --- 2. Sayfa İçeriği ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Broadcast Request Bölümü ---
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: _buildBroadcastRequestCard(context),
            ),

            // --- Filtre Butonu ---
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  side: const BorderSide(color: _primaryColor, width: 1.5),
                  foregroundColor: _primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.filter_list, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Başlık
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                "Popüler Bakıcılar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),

            // 🔹 Bakıcı Listesi (Tıklama İşlevi Geri Eklendi ve Yatay Padding 35.0 olarak korundu)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rowCount,
              itemBuilder: (context, rowIndex) {
                final firstIndex = rowIndex * 2;
                final secondIndex = firstIndex + 1;

                return Padding(
                  // 🔹 İsteğiniz üzerine Padding değeri 35.0 olarak KORUNDU.
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // --- 1. Kart ---
                      Flexible(
                        // Tıklama işlevi için GestureDetector eklendi
                        child: GestureDetector(
                          onTap: () => _navigateToCaregiverProfile(firstIndex),
                          behavior: HitTestBehavior
                              .opaque, // Tıklama sorununu çözebilir
                          child: CaregiverCardAsset(
                            name: _backers[firstIndex]['name'] as String,
                            imagePath:
                                _backers[firstIndex]['imagePath'] as String,
                            suitability:
                                _backers[firstIndex]['suitability'] as String,
                            price: _backers[firstIndex]['price'] as double,
                            isFavorite:
                                _backers[firstIndex]['isFavorite'] as bool,
                            onFavoriteChanged: () =>
                                _updateFavoriteStatus(firstIndex),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // --- 2. Kart (Liste sonu kontrolü) ---
                      if (secondIndex < _backers.length)
                        Flexible(
                          // Tıklama işlevi için GestureDetector eklendi
                          child: GestureDetector(
                            onTap: () =>
                                _navigateToCaregiverProfile(secondIndex),
                            behavior: HitTestBehavior
                                .opaque, // Tıklama sorununu çözebilir
                            child: CaregiverCardAsset(
                              name: _backers[secondIndex]['name'] as String,
                              imagePath:
                                  _backers[secondIndex]['imagePath'] as String,
                              suitability: _backers[secondIndex]['suitability']
                                  as String,
                              price: _backers[secondIndex]['price'] as double,
                              isFavorite:
                                  _backers[secondIndex]['isFavorite'] as bool,
                              onFavoriteChanged: () =>
                                  _updateFavoriteStatus(secondIndex),
                            ),
                          ),
                        )
                      else
                        const Flexible(child: SizedBox(width: 0)),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        selectedColor: _primaryColor,
        unselectedColor: Colors.grey,
      ),
    );
  }

  // Yayın İsteği Kartı (Broadcast Request Card)
  Widget _buildBroadcastRequestCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Resim ve Üst Kısım
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  'assets/images/broadcast_illustration.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.mail_outline,
                            size: 60, color: _broadcastButtonColor),
                        const SizedBox(height: 8),
                        Text('İllüstrasyon',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Başlık (Mor renk)
            const Text(
              'Broadcast Request',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            // Açıklama
            const Text(
              'Do a broadcast to notify Backers nearby that you need help with your pets.',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Buton (Mor renk - Ortaya hizalamak için Center'a alındı)
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _broadcastButtonColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'BROADCAST REQUEST',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
