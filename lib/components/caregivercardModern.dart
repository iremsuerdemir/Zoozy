import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/models/favori_item.dart';
import 'package:zoozy/services/guest_access_service.dart';

// Tema Renkleri
const Color _primaryColor = Colors.deepPurple;
const Color _accentColor = Color(0xFFF06292); // Pembe tonu
const Color _backgroundColor = Color(0xFFF3E5F5); // Açık lila arka plan

class CaregiverCardBalanced extends StatefulWidget {
  final String name;
  final String imagePath;
  final String suitability;
  final bool isFavorite;
  final VoidCallback? onFavoriteChanged;

  const CaregiverCardBalanced({
    super.key,
    required this.name,
    required this.imagePath,
    required this.suitability,
    this.isFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  State<CaregiverCardBalanced> createState() => _CaregiverCardBalancedState();
}

class _CaregiverCardBalancedState extends State<CaregiverCardBalanced> {
  Future<void> _toggleFavorite() async {
    if (!await GuestAccessService.ensureLoggedIn(context)) {
      return;
    }

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
      mevcutFavoriler.removeWhere((f) {
        final decoded = jsonDecode(f);
        return decoded["title"] == item.title && decoded["tip"] == item.tip;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Favorilerden çıkarıldı.")));
    } else {
      mevcutFavoriler.add(jsonEncode(item.toJson()));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Favorilere eklendi!")));
    }

    await prefs.setStringList("favoriler", mevcutFavoriler);
    widget.onFavoriteChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // IMAGE AREA
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.25),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // FAVORITE BUTTON (Glassmorphism effect)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _toggleFavorite,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 22,
                            color: widget.isFavorite
                                ? _accentColor
                                : Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // INFO AREA
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                          letterSpacing: 0.2,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _primaryColor.withOpacity(0.12),
                              _primaryColor.withOpacity(0.06),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _primaryColor.withOpacity(0.2),
                            width: 0.7,
                          ),
                        ),
                        child: Text(
                          widget.suitability,
                          style: TextStyle(
                            color: _primaryColor.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
