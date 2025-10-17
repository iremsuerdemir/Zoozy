import 'package:flutter/material.dart';
import 'package:zoozy/components/CaregiverCard.dart';
import 'package:zoozy/components/SimplePetCard.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart'; // bottom nav import
import 'package:zoozy/screens/jobs_screen.dart';
import 'package:zoozy/screens/profile_screen.dart';
import 'package:zoozy/screens/reguests_screen.dart'; // doğru ekranı import et

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int selectedCategoryIndex = -1;

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

    final caregivers = [
      {
        "name": "İstanbul, Juliet Wan",
        "image": "assets/images/caregiver1.png",
        "suitability": "Gezdirme",
        "price": 315.0,
      },
      {
        "name": "Emy Pansiyon",
        "image": "assets/images/caregiver2.jpeg",
        "suitability": "Pansiyon",
        "price": 1600.0,
      },
      {
        "name": "Animal Care Pro",
        "image": "assets/images/caregiver3.jpg",
        "suitability": "Gündüz Bakımı",
        "price": 1175.0,
      },
    ];

    final pets = [
      {"image": "assets/images/pet1.jpeg", "name": "Buddy", "owner": "Alice"},
      {"image": "assets/images/pet2.jpeg", "name": "Charlie", "owner": "Bob"},
      {"image": "assets/images/pet3.jpg", "name": "Max", "owner": "Carol"},
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
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
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
                  "Yakınınızdaki Backer'lar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Daha Fazla >",
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
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
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CaregiverCardAsset(
                      name: c["name"] as String,
                      imagePath: c["image"] as String,
                      suitability: c["suitability"] as String,
                      price: c["price"] as double,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // --- PETS IN THE COMMUNITY ---
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
            // --- BANNER ---
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/sitter_banner.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 180,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xAA6B46C1),
                              Color(0xFF6B46C1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 0.3, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Bakıcı Olun",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Topluluğumuza katılın ve yakınınızdaki evcil hayvanlara bakım yapmaya başlayın. Sevdiğiniz işi yaparken kazanın!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF6B46C1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              "Detaylı Bilgi",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0, // Keşfet aktif
        selectedColor: Colors.deepPurple,
        unselectedColor: Colors.grey,
      ),
    );
  }
}
