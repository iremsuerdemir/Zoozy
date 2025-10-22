import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/components/commentItem.dart';
import 'package:zoozy/components/moments_postCard.dart';
import 'package:zoozy/components/comment_dialog.dart';
import 'package:zoozy/components/comment_card.dart';
import 'package:zoozy/screens/profile_screen.dart';
import 'package:zoozy/screens/reguests_screen.dart';
import 'package:zoozy/screens/favori_page.dart';
import 'package:zoozy/models/favori_item.dart';
import 'package:zoozy/models/comment.dart';
import 'package:zoozy/services/comment_service.dart';

const Color primaryPurple = Colors.deepPurple;

class CaregiverProfilpage extends StatefulWidget {
  final String displayName;
  final String userName;
  final String location;
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
    required this.location,
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
  State<CaregiverProfilpage> createState() => _CaregiverProfilpageState();
}

class _CaregiverProfilpageState extends State<CaregiverProfilpage> {
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    setState(() {
      _comments = _commentService.getCommentsForCard(widget.userName);
    });
  }

  void _onCommentAdded(Comment comment) {
    _commentService.addComment(widget.userName, comment);
    _loadComments();
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }

  Future<void> _favoriyeEkle(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> mevcutFavoriler = prefs.getStringList("favoriler") ?? [];

    final item = FavoriteItem(
      title: widget.displayName,
      subtitle: "Bakıcı - ${widget.userName}",
      imageUrl: widget.userPhoto,
      profileImageUrl: widget.userPhoto,
      tip: "caregiver",
    );

    // Aynı favori zaten varsa ekleme
    bool zatenVar = mevcutFavoriler.any((f) {
      final decoded = jsonDecode(f);
      return decoded["title"] == item.title &&
          decoded["subtitle"] == item.subtitle &&
          decoded["tip"] == item.tip;
    });

    if (!zatenVar) {
      mevcutFavoriler.add(jsonEncode(item.toJson()));
      await prefs.setStringList("favoriler", mevcutFavoriler);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favorilere eklendi!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu kişi zaten favorilerde!")),
      );
    }
  }

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
                    child: const Text("OK"),
                  ),
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
          // 🔹 Favori sayfasına git butonu
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriPage(
                    favoriTipi: "caregiver",
                    previousScreen: CaregiverProfilpage(
                      displayName: widget.displayName,
                      userName: widget.userName,
                      location: widget.location,
                      bio: widget.bio,
                      userPhoto: widget.userPhoto,
                      userSkills: widget.userSkills,
                      otherSkills: widget.otherSkills,
                      moments: widget.moments,
                      reviews: widget.reviews,
                      followers: widget.followers,
                      following: widget.following,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.red,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(widget.userPhoto),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${widget.userName}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(widget.location),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(100, 36),
                            ),
                            child: const Text(
                              "Follow",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _favoriyeEkle(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(100, 36),
                            ),
                            child: const Text(
                              "Favoriye Ekle",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Yorum butonları
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CommentDialog(
                                  cardId: widget.userName,
                                  onCommentAdded: _onCommentAdded,
                                ),
                              );
                            },
                            icon: const Icon(Icons.comment, size: 18),
                            label: Text("Yorum Ekle (${_comments.length})"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(150, 36),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _toggleComments,
                            icon: Icon(
                              _showComments ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                            ),
                            label: Text(_showComments ? "Yorumları Gizle" : "Yorumları Göster"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(150, 36),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      widget.followers.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text("Followers"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.following.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text("Following"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.reviews.length.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text("Reviews"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'About Me',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(widget.bio),
            const SizedBox(height: 16),
            if (widget.userSkills.isNotEmpty) ...[
              const Text(
                'Skills & Qualifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.userSkills),
              const SizedBox(height: 16),
            ],
            if (widget.otherSkills.isNotEmpty) ...[
              const Text(
                'Other Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.otherSkills),
              const SizedBox(height: 16),
            ],
            if (widget.moments.isNotEmpty) ...[
              const Text(
                'Moments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: widget.moments
                    .map(
                      (moment) => MomentsPostCard(
                        userName: moment['userName'],
                        displayName: moment['displayName'],
                        userPhoto: moment['userPhoto'],
                        postImage: moment['postImage'],
                        description: moment['description'],
                        likes: moment['likes'],
                        comments: moment['comments'],
                        timePosted: moment['timePosted'],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (widget.reviews.isNotEmpty) ...[
              const Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: widget.reviews
                    .map(
                      (review) => CommentItem(
                        name: review['name'],
                        comment: review['comment'],
                        photoUrl: review['photoUrl'],
                        timePosted: review['timePosted'],
                      ),
                    )
                    .toList(),
              ),
            ],
            
            // Yorumlar bölümü
            if (_showComments) ...[
              const SizedBox(height: 20),
              const Text(
                'Yorumlar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Henüz yorum yok. İlk yorumu siz yapın!',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ..._comments.map((comment) => CommentCard(comment: comment)).toList(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4, // Profil sayfası index
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
