import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/components/moments_postCard.dart';
import 'package:zoozy/screens/explore_screen.dart';
import 'package:zoozy/screens/profile_screen.dart';
import 'package:zoozy/screens/reguests_screen.dart';
import 'package:zoozy/screens/favori_page.dart';
import 'package:zoozy/screens/caregiverProfilPage.dart';

const Color primaryPurple = Colors.deepPurple;
// 🎉 YENİ TANIM: Arka plan için çok hafif lila rengi
const Color _lightLilacBackground = Color(0xFFF3E5F5);

class MomentsScreen extends StatefulWidget {
  const MomentsScreen({super.key});

  @override
  State<MomentsScreen> createState() => _MomentsScreenState();
}

class _MomentsScreenState extends State<MomentsScreen> {
  // Post verileri DateTime içerdiği için toMap/toJson dönüşümüne ihtiyaç duyabilir.
  // Ancak bu sayfada sadece gösterim için kullandığınızdan şimdilik Map<String, dynamic> kalabilir.
  List<Map<String, dynamic>> posts = [
    {
      "userName": "berkshn",
      "displayName": "Berk",
      "userPhoto": "assets/images/caregiver3.jpg",
      "postImage": "assets/images/caregiver3.jpg",
      "description": "Bugün Bunny ile parkta yürüyüşteydik ",
      "likes": 15,
      "comments": 4,
      "timePosted": DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      "userName": "irem",
      "displayName": "iremsu",
      "userPhoto": "assets/images/caregiver2.jpeg",
      "postImage": "assets/images/caregiver2.jpeg",
      "description": "Yeni müşterimin köpeğiyle ilk günümdü ",
      "likes": 42,
      "comments": 10,
      "timePosted": DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      "userName": "beyzaa",
      "displayName": "beyza",
      "userPhoto": "assets/images/caregiver1.png",
      "postImage": "assets/images/caregiver1.png",
      "description": "Evcil dostlarımızı sevgiyle ağırlıyoruz ",
      "likes": 33,
      "comments": 6,
      "timePosted": DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  Set<String> favoriIsimleri = {};
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _favorileriYukle();
    _loadCurrentUserName();
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

  Future<void> _loadCurrentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserName = prefs.getString("username") ?? 'Bilinmeyen Kullanıcı';
    });
  }

  // Bakıcı profil sayfasının ihtiyaç duyduğu eksik verileri simüle eden fonksiyon
  Map<String, dynamic> _fetchCaregiverData(String userName) {
    // Postlar listesinden displayName ve userPhoto bulunur
    final post = posts.firstWhere(
      (p) => p["userName"] == userName,
      orElse: () => {
        "displayName": "Bilinmeyen Bakıcı",
        "userPhoto": "assets/images/default.png"
      },
    );

    // MomentsScreen'de gösterilen post'u (moment) simülasyon olarak kullan
    final List<Map<String, dynamic>> simuleMoments =
        posts.where((p) => p["userName"] == userName).map((item) {
      return item;
    }).toList();

    // CaregiverProfilpage'in beklediği verileri hazırlıyoruz
    return {
      "displayName": post["displayName"],
      "userName": userName,
      "location": "Bilinmeyen Konum",
      "bio": "${post["displayName"]}, hayvanları çok seven bir bakıcıdır.",
      "userPhoto": post["userPhoto"],
      "userSkills": "Köpek Gezdirme, Kedi Bakımı",
      "otherSkills": "İlk Yardım Bilgisi",
      "moments": simuleMoments,
      "reviews": [].cast<Map<String, dynamic>>().toList(),
      "followers": 75,
      "following": 30,
    };
  }

  // Yönlendirme fonksiyonu
  void _navigateToCaregiverProfile(String userName) {
    final data = _fetchCaregiverData(userName);

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
          moments: data["moments"],
          reviews: data["reviews"],
          followers: data["followers"],
          following: data["following"],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🎉 DÜZELTME: Arka plan rengi çok hafif lila olarak ayarlandı
      backgroundColor: _lightLilacBackground,

      appBar: AppBar(
        // AppBar'ın rengini beyaz tutmak genellikle iyi bir uygulamadır
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.deepPurple,
            size: 28,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExploreScreen()),
            );
          },
        ),
        title: const Text(
          "MOMENTS",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.red,
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriPage(
                    favoriTipi: "moments",
                    previousScreen: const MomentsScreen(),
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: MomentsPostCard(
              userName: post["userName"],
              displayName: post["displayName"],
              userPhoto: post["userPhoto"],
              postImage: post["postImage"],
              description: post["description"],
              likes: post["likes"],
              comments: post["comments"],
              timePosted: post["timePosted"],
              currentUserName: _currentUserName ?? 'Bilinmeyen Kullanıcı',
              // Profil resmine tıklama olayı
              onProfileTap: () => _navigateToCaregiverProfile(post["userName"]),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        selectedColor: primaryPurple,
        unselectedColor: Colors.grey[700]!,
        onTap: (index) {
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RequestsScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
