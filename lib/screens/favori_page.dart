import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/models/favori_item.dart';
import 'package:zoozy/screens/backers_list_screen.dart';
import 'explore_screen.dart';
import 'moments_screen.dart';
import '../components/bottom_navigation_bar.dart'; // CustomBottomNavBar importu

class FavoriPage extends StatefulWidget {
  final String favoriTipi; // "explore", "moments", "caregiver"
  final Widget previousScreen; // Geri dönülecek ekran

  const FavoriPage({
    super.key,
    required this.favoriTipi,
    required this.previousScreen,
  });

  @override
  State<FavoriPage> createState() => _FavoriPageState();
}

class _FavoriPageState extends State<FavoriPage> {
  List<FavoriteItem> favoriler = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriler();
  }

  Future<void> _loadFavoriler() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favStrings = prefs.getStringList("favoriler") ?? [];

    setState(() {
      favoriler = favStrings
          .map((e) => FavoriteItem.fromJson(jsonDecode(e)))
          .where((item) => item.tip == widget.favoriTipi)
          .toList();
    });
  }

  Future<void> _favoridenKaldir(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favStrings = prefs.getStringList("favoriler") ?? [];

    final item = favoriler[index];
    favStrings.removeWhere((f) {
      final decoded = jsonDecode(f);
      return decoded["title"] == item.title &&
          decoded["subtitle"] == item.subtitle &&
          decoded["tip"] == item.tip;
    });

    await prefs.setStringList("favoriler", favStrings);

    setState(() {
      favoriler.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item.title} favorilerden kaldırıldı.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan gradyanı
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
                    horizontal: 16,
                    vertical: 8,
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.previousScreen,
                            ),
                          );
                        },
                      ),
                      const Text(
                        "Favorilerim",
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

                // İçerik
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth = math.min(
                        constraints.maxWidth * 0.9,
                        800,
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
                          child: favoriler.isEmpty
                              ? _bosDurum()
                              : _favoriListesiOlustur(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
        selectedColor: Colors.deepPurple,
        unselectedColor: Colors.grey,
      ),
    );
  }

  Widget _favoriListesiOlustur() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: favoriler.length,
      itemBuilder: (context, index) {
        final item = favoriler[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      item.imageUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () => _favoridenKaldir(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.subtitle,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage(item.profileImageUrl),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.title, // Favori item'ın title'ını göster
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1.2, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }

  Widget _bosDurum() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.shade50,
              ),
              child: const Icon(Icons.pets, size: 60, color: Colors.purple),
            ),
            const SizedBox(height: 30),
            Text(
              "Henüz ${widget.favoriTipi} favori listesi yok.\nBeğendiğin bir ${widget.favoriTipi == 'explore' ? 'ilanı' : widget.favoriTipi == 'moments' ? 'anı' : 'bakıcıyı'} kalp ikonuna dokunarak kaydedebilirsin.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (widget.favoriTipi == 'explore') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExploreScreen(),
                    ),
                  );
                } else if (widget.favoriTipi == 'moments') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MomentsScreen(),
                    ),
                  );
                } else if (widget.favoriTipi == 'caregivers') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BackersListScreen(),
                    ),
                  );
                }
                

              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.purpleAccent,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.favoriTipi == 'explore'
                      ? 'Keşfetmeye Başla'
                      : widget.favoriTipi == 'moments'
                          ? 'Anları Gör'
                          : 'Bakıcıları Keşfet',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
