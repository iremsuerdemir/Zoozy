import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/models/favori_item.dart';

class FavoriPage extends StatefulWidget {
  const FavoriPage({super.key});

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
      if (favStrings.isEmpty) {
        // Eğer hiç favori yoksa örnek bir veri ekleyebiliriz
        favoriler = [
          FavoriteItem(
            title: 'İstanbul',
            subtitle: 'İstanbul’dan',
            imageUrl: 'assets/image_3cde23_main.png',
            profileImageUrl: 'assets/image_3cde23_profile.png',
          ),
        ];
      } else {
        favoriler = favStrings
            .map((e) => FavoriteItem.fromJson(jsonDecode(e)))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorilerim',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: favoriler.isEmpty ? _bosDurum() : _favoriListesiOlustur(),
    );
  }

  Widget _favoriListesiOlustur() {
    return ListView.builder(
      itemCount: favoriler.length,
      itemBuilder: (context, index) {
        final item = favoriler[index];
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: AssetImage(item.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(item.profileImageUrl),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Lidyalılar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
            const Text(
              "Henüz favori listesi yok. Beğendiğin bir ilanı kalp ikonuna dokunarak buraya kaydedebilirsin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            const Text(
              "Henüz favori yok.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
