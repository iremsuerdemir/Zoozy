import 'package:flutter/material.dart';
import 'package:zoozy/components/moments_postCard.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.pets, color: Colors.deepPurple, size: 28),
          ),
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
            onPressed: () {
              // İleride paylaşım ekleme
            },
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
          return MomentsPostCard(
            userName: post["userName"],
            displayName: post["displayName"],
            userPhoto: post["userPhoto"],
            postImage: post["postImage"],
            description: post["description"],
            likes: post["likes"],
            comments: post["comments"],
            timePosted: post["timePosted"],
          );
        },
      ),
    );
  }
}
