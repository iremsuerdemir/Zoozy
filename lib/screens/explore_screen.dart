import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/components/CaregiverCard.dart';
import 'package:zoozy/components/SimplePetCard.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/screens/broadcast_page.dart';
import 'package:zoozy/screens/favori_page.dart';
import 'package:zoozy/screens/caregiverProfilPage.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int selectedCategoryIndex = -1;
  Set<String> favoriIsimleri = {};

  final caregivers = [
    {
      "name": "İstanbul, Juliet Wan",
      "image": "assets/images/caregiver1.png",
      "suitability": "Gezdirme",
      "price": 315.0
    },
    {
      "name": "Emy Pansiyon",
      "image": "assets/images/caregiver2.jpeg",
      "suitability": "Pansiyon",
      "price": 1600.0
    },
    {
      "name": "Animal Care Pro",
      "image": "assets/images/caregiver3.jpg",
      "suitability": "Gündüz Bakımı",
      "price": 1175.0
    },
  ];

  final pets = [
    {"image": "assets/images/pet1.jpeg", "name": "Buddy", "owner": "Alice"},
    {"image": "assets/images/pet2.jpeg", "name": "Charlie", "owner": "Bob"},
    {"image": "assets/images/pet3.jpg", "name": "Max", "owner": "Carol"},
  ];

  @override
  void initState() {
    super.initState();
    _favorileriYukle();
  }

  Future<void> _favorileriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final favStrings = prefs.getStringList("favoriler") ?? [];
    final mevcutIsimler = favStrings.map((e) {
      final decoded = jsonDecode(e);
      return decoded["title"] as String;
    }).toSet();
    setState(() {
      favoriIsimleri = mevcutIsimler;
    });
  }

  void _navigateToCategoryScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const BackersNearbyScreen()));
  }

  Map<String, dynamic> _fetchCaregiverData(int index) {
    final caregiver = caregivers[index];
    final String name = caregiver["name"] as String;
    final String imagePath = caregiver["image"] as String;

    return {
      "displayName": name,
      "userName": name.toLowerCase().replaceAll(RegExp(r'[^\w]+'), '_'),
      "location": "İstanbul/Kadıköy",
      "bio": "Hayvan dostlarımıza sevgiyle bakıyoruz!",
      "userPhoto": imagePath,
      "userSkills": caregiver["suitability"],
      "otherSkills": "Oyun Zamanı, İlk Yardım",
      "moments": List<Map<String, dynamic>>.empty(),
      "reviews": List<Map<String, dynamic>>.empty(),
      "followers": 50 + index * 10,
      "following": 20,
    };
  }

  void _navigateToCaregiverProfile(int index) {
    final data = _fetchCaregiverData(index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaregiverProfilpage(
          displayName: data["displayName"],
          userName: data["userName"],
          location: data["location"],
          bio: data["bio"],
          userPhoto: data["userPhoto"],
          userSkills: data["userSkills"],
          otherSkills: data["otherSkills"],
          moments: data["moments"] as List<Map<String, dynamic>>,
          reviews: data["reviews"] as List<Map<String, dynamic>>,
          followers: data["followers"] as int,
          following: data["following"] as int,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"icon": Icons.house, "label": "Pansiyon"},
      {"icon": Icons.wb_sunny, "label": "Gündüz Bakımı"},
      {"icon": Icons.chair_alt, "label": "Evde Bakım"},
      {"icon": Icons.directions_walk, "label": "Gezdirme"},
      {"icon": Icons.local_taxi, "label": "Taksi"},
      {"icon": Icons.cut, "label": "Bakım"},
      {"icon": Icons.school, "label": "Eğitim"},
      {"icon": Icons.more_horiz, "label": "Diğer"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.pets, color: Colors.deepPurple, size: 28),
        ),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "ZOOZY",
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.5,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.favorite_border, color: Colors.red, size: 28),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriPage(
                    favoriTipi: "explore",
                    previousScreen: const ExploreScreen(),
                  ),
                ),
              ).then((_) {
                _favorileriYukle();
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KATEGORİLER ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = index == selectedCategoryIndex;
                return InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    _navigateToCategoryScreen();
                    setState(() {
                      selectedCategoryIndex = isSelected ? -1 : index;
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: isSelected
                            ? Colors.deepPurple
                            : Colors.purple.shade50,
                        child: Icon(
                          cat["icon"] as IconData,
                          color: isSelected
                              ? Colors.white
                              : Colors.purple.shade700,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat["label"] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.deepPurple : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // --- CAREGIVER BAŞLIK ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Yakınınızdaki Bakıcılar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BackersNearbyScreen()),
                    );
                  },
                  child: const Text(
                    "Daha Fazla >",
                    style: TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // --- CAREGIVER KARTLARI ---
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: caregivers.length,
                itemBuilder: (context, index) {
                  final c = caregivers[index];
                  final isFav = favoriIsimleri.contains(c["name"]);
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      // 🎉 DÜZELTME 1: HitTestBehavior.opaque eklendi
                      onTap: () => _navigateToCaregiverProfile(index),
                      behavior: HitTestBehavior.opaque,
                      child: CaregiverCardAsset(
                        name: c["name"] as String,
                        imagePath: c["image"] as String,
                        suitability: c["suitability"] as String,
                        price: c["price"] as double,
                        isFavorite: isFav,
                        onFavoriteChanged: () {
                          _favorileriYukle();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // --- PETS ---
            const Text(
              "Topluluktaki Evcil Hayvanlar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SimplePetCard(
                      imagePath: pet["image"] as String,
                      name: pet["name"] as String,
                      ownerName: pet["owner"] as String,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        selectedColor: Colors.deepPurple,
        unselectedColor: Colors.grey,
      ),
    );
  }
}
