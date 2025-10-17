import 'package:flutter/material.dart';
import 'package:zoozy/components/commentItem.dart';
import 'package:zoozy/components/moments_postCard.dart';

class CaregiverProfilpage extends StatelessWidget {
  final String displayName;
  final String userName;
  final String location; // Email yerine
  final String bio;
  final String userPhoto;
  final String userSkills;
  final String otherSkills;
  final List<Map<String, dynamic>> moments;
  final List<Map<String, dynamic>> reviews;
  final int followers;
  final int following;

  const CaregiverProfilpage({
    Key? key,
    required this.displayName,
    required this.userName,
    required this.location, // email yerine
    required this.bio,
    required this.userPhoto,
    this.userSkills = "",
    this.otherSkills = "",
    this.moments = const [],
    this.reviews = const [],
    this.followers = 0,
    this.following = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: const Text("Zoozy App Logo"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(Icons.pets, color: Colors.deepPurple, size: 28),
          ),
        ),
        title: const Text(
          "Zoozy",
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
            onPressed: () {}, // ileride paylaşım ekleme
            icon: const Icon(Icons.add_a_photo_outlined,
                color: Colors.deepPurple, size: 26),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil üst kısmı
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(userPhoto),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '@$userName',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(location), // email yerine location
                      const SizedBox(height: 8),
                      // Follow butonu
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          minimumSize: const Size(100, 36),
                        ),
                        child: const Text("Follow",style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Followers / Following / Reviews
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(followers.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Followers"),
                  ],
                ),
                Column(
                  children: [
                    Text(following.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Following"),
                  ],
                ),
                Column(
                  children: [
                    Text(reviews.length.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Reviews"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // About Me
            const Text(
              'About Me',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(bio),
            const SizedBox(height: 16),

            // Skills & Qualifications
            if (userSkills.isNotEmpty) ...[
              const Text(
                'Skills & Qualifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(userSkills),
              const SizedBox(height: 16),
            ],

            // Other Skills
            if (otherSkills.isNotEmpty) ...[
              const Text(
                'Other Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(otherSkills),
              const SizedBox(height: 16),
            ],

            // Moments
            if (moments.isNotEmpty) ...[
              const Text(
                'Moments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: moments
                    .map((moment) => MomentsPostCard(
                          userName: moment['userName'],
                          displayName: moment['displayName'],
                          userPhoto: moment['userPhoto'],
                          postImage: moment['postImage'],
                          description: moment['description'],
                          likes: moment['likes'],
                          comments: moment['comments'],
                          timePosted: moment['timePosted'],
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Reviews
            if (reviews.isNotEmpty) ...[
              const Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: reviews
                    .map((review) => CommentItem(
                          name: review['name'],
                          comment: review['comment'],
                          photoUrl: review['photoUrl'],
                          timePosted: review['timePosted'],
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
