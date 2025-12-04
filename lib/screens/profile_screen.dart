import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/screens/agreement_screen.dart';
import 'package:zoozy/screens/edit_profile.dart';
import 'package:zoozy/screens/favori_page.dart';
import 'package:zoozy/screens/help_center_page.dart';
import 'package:zoozy/screens/indexbox_message.dart';
import 'package:zoozy/screens/listing_process_screen.dart';
import 'package:zoozy/screens/my_badgets_screen.dart';
import 'package:zoozy/screens/qr_code_screen.dart';
import 'package:zoozy/screens/settings_screen.dart';
import 'package:zoozy/services/guest_access_service.dart';
import 'package:provider/provider.dart';
import 'package:zoozy/providers/service_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'İrem Su Erdemir';
  String email = '7692003@gmail.com';
  ImageProvider? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'İrem Su Erdemir';
      email = prefs.getString('email') ?? '7692003@gmail.com';

      final imageString = prefs.getString('profileImagePath');
      if (imageString != null && imageString.isNotEmpty) {
        try {
          final bytes = base64Decode(imageString);
          _profileImage = MemoryImage(bytes);
        } catch (e) {
          print('Profil resmi yüklenirken hata: $e');
          _profileImage = null;
        }
      } else {
        _profileImage = null;
      }
    });
  }

  Widget buildMenuButton(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: () async {
        final allowed = await GuestAccessService.ensureLoggedIn(context);
        if (!allowed) return;
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF7A4FAD), size: 28),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatColumn(
    String label,
    String value, {
    String? subLabel,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
  }) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(icon, size: 28, color: color ?? const Color(0xFF7A4FAD)),
        if (value.isNotEmpty)
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A4FAD),
            ),
          ),
        if (subLabel != null)
          Text(subLabel,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );

    return GestureDetector(onTap: onTap, child: content);
  }

  // ------------------------ HİZMET İKON SEÇİCİ ------------------------
  IconData getServiceIcon(String name) {
    final lower = name.toLowerCase();

    if (lower.contains("gezdirme")) return Icons.directions_walk;
    if (lower.contains("pansiyonu") || lower.contains("otel"))
      return Icons.home_filled;
    if (lower.contains("günlük bakım")) return Icons.light_mode;
    if (lower.contains("bakımı")) return Icons.pets;
    if (lower.contains("taksi")) return Icons.local_taxi;
    if (lower.contains("tımar")) return Icons.cut;
    if (lower.contains("eğitim")) return Icons.school;
    if (lower.contains("fotoğraf")) return Icons.photo_camera;
    if (lower.contains("veteriner")) return Icons.health_and_safety;

    return Icons.miscellaneous_services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2A4FF), Color(0xFFFFC1C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------------- ÜST BAR --------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.pets, color: Colors.white, size: 28),
                          SizedBox(width: 6),
                          Text(
                            'Zoozy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                            onPressed: () async {
                              final allowed =
                                  await GuestAccessService.ensureLoggedIn(
                                      context);
                              if (!allowed) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsScreen()),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline,
                                color: Colors.white),
                            onPressed: () async {
                              final allowed =
                                  await GuestAccessService.ensureLoggedIn(
                                      context);
                              if (!allowed) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IndexboxMessageScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // -------------------- PROFİL KART --------------------
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: _profileImage,
                          child: _profileImage == null
                              ? const Icon(Icons.person,
                                  color: Colors.white, size: 50)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () async {
                                  final allowed =
                                      await GuestAccessService.ensureLoggedIn(
                                          context);
                                  if (!allowed) return;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfileScreen()),
                                  );
                                  _loadProfileData();
                                },
                                child: const Text(
                                  'Profilini düzenlemek için tıkla',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final allowed =
                                await GuestAccessService.ensureLoggedIn(
                                    context);
                            if (!allowed) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QrCodeScreen(
                                  qrData: 'https://example.com/pet/booking',
                                ),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color.fromARGB(206, 238, 231, 231),
                            child: Icon(Icons.qr_code, color: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // -------------------- İSTATİSTİKLER --------------------
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildStatColumn('Yorum', '0'),
                        buildStatColumn(
                          'Rozetlerim',
                          '',
                          icon: Icons.military_tech,
                          color: Colors.purple,
                          onTap: () async {
                            final allowed =
                                await GuestAccessService.ensureLoggedIn(
                                    context);
                            if (!allowed) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyBadgetsScreen(phoneVerified: true),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // -------------------- MENÜ GRID --------------------
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 0.68,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        buildMenuButton(Icons.favorite, 'Favorilerim', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoriPage(
                                favoriTipi: "profil",
                                previousScreen: widget,
                              ),
                            ),
                          );
                        }),
                        buildMenuButton(Icons.pets, 'Evcil Hayvanlarım', () {}),
                        buildMenuButton(Icons.military_tech, 'Rozetlerim', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyBadgetsScreen(
                                phoneVerified: true,
                              ),
                            ),
                          );
                        }),
                        buildMenuButton(Icons.help_center, 'Yardım Merkezi',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpCenterPage(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // -------------------- İLANLAR --------------------
                  Row(
                    children: [
                      const Text(
                        'İlanlar',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A4FAD),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.help_outline,
                            color: Color(0xFF7A4FAD), size: 25),
                        onPressed: () async {
                          final allowed =
                              await GuestAccessService.ensureLoggedIn(context);
                          if (!allowed) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ListingProcessScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // -------------------- HİZMET KARTLARI (Dinamik Liste) --------------------
                  Consumer<ServiceProvider>(
                    builder: (context, provider, child) {
                      if (provider.services.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children:
                            provider.services.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;

                          final serviceName = item["serviceName"] ?? "";
                          final address = item["address"] ?? "";
                          final iconName = item["serviceIcon"];
                          final price = item["price"];
                          final desc = item["description"];

                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: const Color(0xFFEDE4F6),
                                      child: Icon(
                                        getServiceIcon(serviceName),
                                        color: const Color(0xFF7A4FAD),
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            serviceName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (price != null)
                                            Text(
                                              "Fiyat: $price₺",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                          const SizedBox(height: 4),
                                          Text(
                                            address,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          if (desc != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: Text(
                                                desc,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// Çöp Kutusu İkonu (sağ alt köşe)
                              Positioned(
                                bottom: 30,
                                right: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Hizmeti Sil"),
                                        content: const Text(
                                            "Bu hizmeti kaldırmak istediğinizden emin misiniz?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("İptal"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child: const Text("Evet"),
                                            onPressed: () {
                                              Provider.of<ServiceProvider>(
                                                      context,
                                                      listen: false)
                                                  .removeService(index);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),

                  // -------------------- HİZMET EKLE BUTONU --------------------
                  InkWell(
                    onTap: () async {
                      final allowed =
                          await GuestAccessService.ensureLoggedIn(context);
                      if (!allowed) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AgreementScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 205, 196, 216),
                            radius: 28,
                            child: Icon(
                              Icons.add,
                              color: Color(0xFF7A4FAD),
                              size: 40,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Evcil Hayvan Hizmeti Ekle',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Bakıcı / Evcil Hayvan Oteli Ol',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0)
            Navigator.pushNamed(context, '/explore');
          else if (index == 1)
            Navigator.pushNamed(context, '/requests');
          else if (index == 2)
            Navigator.pushNamed(context, '/moments');
          else if (index == 3) Navigator.pushNamed(context, '/jobs');
        },
        selectedColor: const Color(0xFF7A4FAD),
        unselectedColor: Colors.grey,
      ),
    );
  }
}
