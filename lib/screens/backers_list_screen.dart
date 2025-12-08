import 'package:flutter/material.dart';

// Gerekli component import'ları
// import 'package:zoozy/components/CaregiverCard.dart'; // Eğer CaregiverCardAsset kullanılmıyorsa silinebilir.
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/components/caregivercardModern.dart'; // Fiyatsız yeni versiyonun burada olduğunu varsayıyoruz.

import 'package:zoozy/screens/CaregiverProfilpage.dart';

// Tema Renkleri
const Color _primaryColor = Colors.deepPurple;
const Color _lightLilacBackground = Color(0xFFF3E5F5);
const Color _accentColor = Color(0xFFF06292); // Filtreler için pembe tonu

class BackersListScreen extends StatefulWidget {
  const BackersListScreen({super.key});

  @override
  State<BackersListScreen> createState() => _BackersListScreenState();
}

class _BackersListScreenState extends State<BackersListScreen> {
  // 🔹 Örnek Veri Listesi (Aynı Kaldı)
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

  // 🔹 Profil sayfasına navigasyon işlevi (Aynı Kaldı)
  void _navigateToCaregiverProfile(int index) {
    final backer = _backers[index];

    // Örnek verilerin tamamı burada atanır
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

  // Favori durumu değiştiğinde _backers listesini güncelleyen fonksiyon. (Aynı Kaldı)
  void _updateFavoriteStatus(int index) {
    setState(() {
      _backers[index]['isFavorite'] = !_backers[index]['isFavorite'];
    });
  }

  // Filtre Butonuna basıldığında BottomSheet açan fonksiyon (Aynı Kaldı)
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrele',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const Divider(height: 20, thickness: 1),
              // Örnek Filtre Seçenekleri
              ListTile(
                leading: const Icon(Icons.pets, color: _primaryColor),
                title: const Text('Köpekler İçin'),
                onTap: () {
                  // Filtreleme işlemi buraya eklenebilir
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.pets, color: _primaryColor),
                title: const Text('Kediler İçin'),
                onTap: () {
                  // Filtreleme işlemi buraya eklenebilir
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: _primaryColor),
                title: const Text('Yakınlığa Göre'),
                onTap: () {
                  // Filtreleme işlemi buraya eklenebilir
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ekran genişliği
    final double screenWidth = MediaQuery.of(context).size.width;
    // Padding'i dinamik olarak hesapla (Ekranın %5'i boşluk olarak bırakılabilir)
    final double horizontalPadding = screenWidth * 0.05;

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
          'Tüm Bakıcılar', // Başlık sadeleştirildi
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Filtre butonu buraya taşındı
          IconButton(
            icon: const Icon(Icons.filter_list, color: _accentColor),
            onPressed: _showFilterBottomSheet,
            tooltip: 'Filtrele',
          ),
          IconButton(
            icon: const Icon(Icons.search, color: _primaryColor),
            onPressed: () {
              // Arama işlevi
            },
            tooltip: 'Ara',
          ),
          const SizedBox(width: 8),
        ],
      ),

      // --- 2. Sayfa İçeriği ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 🔹 Bakıcı Listesi (Responsive GridView)
            Padding(
              // Üstten de biraz boşluk eklendi
              padding: EdgeInsets.fromLTRB(
                  horizontalPadding, 16.0, horizontalPadding, 0.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _backers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 sütunlu düzen
                  crossAxisSpacing: 12.0, // Sütunlar arası boşluk
                  mainAxisSpacing: 12.0, // Satırlar arası boşluk
                  childAspectRatio: 0.7, // Kart yüksekliğini ayarla
                ),
                // YENİ KOD: GridView.builder içindeki itemBuilder
                itemBuilder: (context, index) {
                  final backer = _backers[index];

                  return GestureDetector(
                    onTap: () => _navigateToCaregiverProfile(index),
                    behavior: HitTestBehavior.opaque,
                    // ✨ DÜZELTME: CaregiverCardModern'dan 'price' parametresi kaldırıldı.
                    // BackersListScreenState sınıfı içindeki itemBuilder fonksiyonu:
// ...
                    child: CaregiverCardBalanced(
                      // <--- Burası değişti
                      name: backer['name'] as String,
                      imagePath: backer['imagePath'] as String,
                      suitability: backer['suitability'] as String,
                      // Fiyat yok
                      isFavorite: backer['isFavorite'] as bool,
                      onFavoriteChanged: () => _updateFavoriteStatus(index),
                    ),
// ...
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // Alt navigasyon çubuğu için boşluk
          ],
        ),
      ),
      // --- BOTTOM NAVIGATION BAR (Aynı Kaldı) ---
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        selectedColor: _primaryColor,
        unselectedColor: Colors.grey,
      ),
    );
  }
}
