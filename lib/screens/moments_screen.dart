import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/components/moments_postCard.dart';
import 'package:zoozy/screens/explore_screen.dart';
import 'package:zoozy/screens/profile_screen.dart';
import 'package:zoozy/screens/reguests_screen.dart';
import 'package:zoozy/models/favori_item.dart';
import 'package:zoozy/screens/favori_page.dart';

const Color primaryPurple = Colors.deepPurple;

class MomentsScreen extends StatefulWidget {
  const MomentsScreen({super.key});

  @override
  State<MomentsScreen> createState() => _MomentsScreenState();
}

class _MomentsScreenState extends State<MomentsScreen> {
  final List<Map<String, dynamic>> posts = [
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

  // ✅ Favoriye ekleme fonksiyonu
  Future<void> _favoriyeEkle(Map<String, dynamic> post) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> mevcutFavoriler = prefs.getStringList("favoriler") ?? [];

    final item = FavoriteItem(
      title: post["displayName"],
      subtitle: post["description"],
      imageUrl: post["postImage"],
      profileImageUrl: post["userPhoto"],
    );

    mevcutFavoriler.add(jsonEncode(item.toJson()));
    await prefs.setStringList("favoriler", mevcutFavoriler);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Favorilere eklendi!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            onPressed: () {},
            icon: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.deepPurple,
              size: 26,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Stack(
            children: [
              MomentsPostCard(
                userName: post["userName"],
                displayName: post["displayName"],
                userPhoto: post["userPhoto"],
                postImage: post["postImage"],
                description: post["description"],
                likes: post["likes"],
                comments: post["comments"],
                timePosted: post["timePosted"],
              ),
            ],
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
