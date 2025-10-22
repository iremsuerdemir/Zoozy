import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/models/favori_item.dart';

class CaregiverCardAsset extends StatefulWidget {
  final String name;
  final String imagePath;
  final String suitability;
  final double price;
  final bool isFavorite; // Dışarıdan favori durumunu al
  final VoidCallback? onFavoriteChanged; // Favori durumu değiştiğinde callback

  const CaregiverCardAsset({
    super.key,
    required this.name,
    required this.imagePath,
    required this.suitability,
    required this.price,
    this.isFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  State<CaregiverCardAsset> createState() => _CaregiverCardAssetState();
}

class _CaregiverCardAssetState extends State<CaregiverCardAsset> {
  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> mevcutFavoriler = prefs.getStringList("favoriler") ?? [];

    final item = FavoriteItem(
      title: widget.name,
      subtitle: widget.suitability,
      imageUrl: widget.imagePath,
      profileImageUrl: "assets/images/caregiver1.png",
      tip: "explore",
    );

    bool zatenFavoride = mevcutFavoriler.any((f) {
      final decoded = jsonDecode(f);
      return decoded["title"] == item.title && decoded["tip"] == item.tip;
    });

    if (zatenFavoride) {
      // Favoriden çıkar
      mevcutFavoriler.removeWhere((f) {
        final decoded = jsonDecode(f);
        return decoded["title"] == item.title && decoded["tip"] == item.tip;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Favorilerden çıkarıldı.")));
    } else {
      // Favoriye ekle
      mevcutFavoriler.add(jsonEncode(item.toJson()));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Favorilere eklendi!")));
    }

    await prefs.setStringList("favoriler", mevcutFavoriler);

    // Callback'i çağır
    if (widget.onFavoriteChanged != null) {
      widget.onFavoriteChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${widget.name} seçildi')));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(widget.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color.fromARGB(255, 67, 30, 100).withOpacity(0.7),
                      const Color.fromARGB(255, 51, 27, 90).withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () async {
                  await _toggleFavorite();
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.favorite,
                    color: widget.isFavorite ? Colors.redAccent : Colors.white,
                    size: 20,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 12,
              bottom: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 3,
                          color: Colors.black45,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.suitability,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
