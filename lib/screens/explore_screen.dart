import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/components/CaregiverCard.dart';
import 'package:zoozy/components/SimplePetCard.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/screens/favori_page.dart';
import 'package:zoozy/screens/login_page.dart';
import 'package:zoozy/services/guest_access_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int selectedCategoryIndex = -1;
  Set<String> favoriIsimleri = {};
  bool _isGuest = false;
  double arrowOffset = 0.0;

  // ⭐ ScrollController EKLEDİK
  final ScrollController caregiverScrollController = ScrollController();

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

  @override
  void initState() {
    super.initState();
    _favorileriYukle();
    _loadGuestFlag();
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

  Future<void> _loadGuestFlag() async {
    final isGuest = await GuestAccessService.isGuest();
    if (mounted) {
      setState(() {
        _isGuest = isGuest;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  Future<void> _confirmLogout() async {
    if (!mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: Color(0xFF9C27B0), size: 50),
              const SizedBox(height: 12),
              const Text(
                'Oturumu kapatmak istediğine emin misin?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Giriş ekranına yönlendirileceksin.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(dialogContext).pop();

                  try {
                    await GuestAccessService.disableGuestMode();
                    await FirebaseAuth.instance.signOut();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Başarıyla çıkış yapıldı."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(16),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Çıkış hatası: ${e.toString()}"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Çıkış Yap',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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

    final pets = [
      {"image": "assets/images/pet1.jpeg", "name": "Buddy", "owner": "Alice"},
      {"image": "assets/images/pet2.jpeg", "name": "Charlie", "owner": "Bob"},
      {"image": "assets/images/pet3.jpg", "name": "Max", "owner": "Carol"},
    ];

    return SafeArea(
      child: Scaffold(
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
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.red,
                size: 28,
              ),
              onPressed: () async {
                if (!await GuestAccessService.ensureLoggedIn(context)) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriPage(
                      favoriTipi: "explore",
                      previousScreen: const ExploreScreen(),
                    ),
                  ),
                ).then((_) => _favorileriYukle());
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black87,
                size: 28,
              ),
              onPressed: _confirmLogout,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isGuest)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.deepPurple.shade100),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.deepPurple),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Misafir modundasınız. İşlem yapabilmek için lütfen giriş yapınız.',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // --- KATEGORİLER ---
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color:
                                isSelected ? Colors.deepPurple : Colors.black,
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

                  // ⭐ DÜZELTİLMİŞ DAHA FAZLA BUTONU — SCROLL YAPAR
                  TextButton(
                    onPressed: () {
                      caregiverScrollController.animateTo(
                        caregiverScrollController.offset + 260,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      setState(() {
                        arrowOffset = 8;
                      });
                    },
                    child: Row(
                      children: [
                        const Text(
                          "Daha Fazla",
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AnimatedPadding(
                          duration: const Duration(milliseconds: 250),
                          padding: EdgeInsets.only(left: 2 + arrowOffset),
                          child: const Text(
                            ">",
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // --- SCROLL CONTROLLER EKLENMİŞ CAREGIVER LİSTESİ ---
              SizedBox(
                height: 250,
                child: ListView.builder(
                  controller: caregiverScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: caregivers.length,
                  itemBuilder: (context, index) {
                    final c = caregivers[index];
                    final isFav = favoriIsimleri.contains(c["name"]);

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
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
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

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
          onTap: (index) async {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/explore');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/requests');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/moments');
            } else if (index == 3) {
              Navigator.pushNamed(context, '/jobs');
            } else if (index == 4) {
              await _confirmLogout();
            }
          },
          selectedColor: Colors.deepPurple,
          unselectedColor: Colors.grey,
        ),
      ),
    );
  }
}
