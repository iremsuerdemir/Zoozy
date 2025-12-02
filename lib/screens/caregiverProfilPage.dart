import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/components/comment_card.dart';
import 'package:zoozy/components/comment_dialog.dart';
import 'package:zoozy/components/moments_postCard.dart';
import 'package:zoozy/screens/profile_screen.dart';
import 'package:zoozy/screens/reguests_screen.dart';
import 'package:zoozy/screens/favori_page.dart';
import 'package:zoozy/models/favori_item.dart';
import 'package:zoozy/models/comment.dart';
import 'package:zoozy/services/comment_service.dart';
import 'package:zoozy/services/guest_access_service.dart';

// Tema Renkleri
const Color primaryPurple = Colors.deepPurple; // Ana Mor
const Color _lightLilacBackground =
    Color.fromARGB(255, 244, 240, 245); // Sayfa Arka Planı (Hafif lila)
const Color accentRed = Colors.red; // Favori için
const Color statCardColor = Color(
    0xFFF0EFFF); // İstatistik kartı arka planı (Çok açık mor, daha yumuşak)
const Color skillChipColor = Color(0xFF7E57C2); // Yetenek çipi koyu mor tonu

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
  String? _currentUserName;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadComments();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> mevcutFavoriler = prefs.getStringList("favoriler") ?? [];

    _isFavorite = mevcutFavoriler.any((f) {
      final decoded = jsonDecode(f);
      return decoded["title"] == widget.displayName &&
          decoded["tip"] == "caregiver";
    });
    setState(() {});
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

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserName = prefs.getString('username') ?? 'Bilinmeyen Kullanıcı';
    });
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    if (!await GuestAccessService.ensureLoggedIn(context)) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    List<String> mevcutFavoriler = prefs.getStringList("favoriler") ?? [];

    final item = FavoriteItem(
      title: widget.displayName,
      subtitle: "Bakıcı - ${widget.userName}",
      imageUrl: widget.userPhoto,
      profileImageUrl: widget.userPhoto,
      tip: "caregiver",
    );

    bool zatenVar = mevcutFavoriler.any((f) {
      final decoded = jsonDecode(f);
      return decoded["title"] == item.title && decoded["tip"] == item.tip;
    });

    if (zatenVar) {
      mevcutFavoriler.removeWhere((f) {
        final decoded = jsonDecode(f);
        return decoded["title"] == item.title && decoded["tip"] == item.tip;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favorilerden çıkarıldı.")),
      );
    } else {
      mevcutFavoriler.add(jsonEncode(item.toJson()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favorilere eklendi!")),
      );
    }

    await prefs.setStringList("favoriler", mevcutFavoriler);
    _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfa arka planı
      backgroundColor: _lightLilacBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryPurple, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Zoozy",
          style: TextStyle(
            color: primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await _toggleFavorite(context);
            },
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? accentRed : primaryPurple,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. PROFIL ÜST KISMI (Fotoğraf, İsim, Lokasyon) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(widget.userPhoto),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.displayName,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryPurple),
                    ),
                    Text(
                      '@${widget.userName}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: primaryPurple, size: 16),
                        const SizedBox(width: 4),
                        Text(widget.location,
                            style: TextStyle(color: Colors.grey.shade700)),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- 2. HAREKETE GEÇİRİCİ BUTONLAR ---
            Row(
              children: [
                // Follow Butonu (Ana Mor Dolgulu)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Follow mantığı buraya
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text("Follow",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                // Message Butonu (Mor Çizgili)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Mesajlaşma başlatılıyor...")),
                      );
                    },
                    icon: const Icon(Icons.message, color: primaryPurple),
                    label: const Text("Message",
                        style: TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(
                          color: primaryPurple,
                          width: 1.5), // Tema moru çizgisi
                      elevation: 0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- 3. İSTATİSTİKLER (Tema rengiyle uyumlu) ---
            _buildStatsRow(),

            const SizedBox(height: 24),

            // --- 4. HAKKINDA ---
            _buildSectionTitle('About Me'),
            const SizedBox(height: 8),
            Text(widget.bio,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15)),

            const SizedBox(height: 24),

            // --- 5. SKILLS & QUALIFICATIONS ---
            if (widget.userSkills.isNotEmpty || widget.otherSkills.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Skills & Qualifications'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      // Koyu mor zemin ve beyaz metin çipleri
                      ...widget.userSkills
                          .split(',')
                          .map((skill) => _buildSkillChip(skill.trim())),
                      ...widget.otherSkills
                          .split(',')
                          .map((skill) => _buildSkillChip(skill.trim())),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),

            // --- 6. MOMENTS ---
            if (widget.moments.isNotEmpty) ...[
              _buildSectionTitle('Moments'),
              const SizedBox(height: 12),
              Column(
                children: widget.moments
                    .map(
                      (moment) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: MomentsPostCard(
                          userName: moment['userName'],
                          displayName: moment['displayName'],
                          userPhoto: moment['userPhoto'],
                          postImage: moment['postImage'],
                          description: moment['description'],
                          likes: moment['likes'],
                          comments: moment['comments'],
                          timePosted: moment['timePosted'] is String
                              ? DateTime.parse(moment['timePosted'])
                              : moment['timePosted'] as DateTime,
                          currentUserName:
                              _currentUserName ?? 'Bilinmeyen Kullanıcı',
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // --- 7. REVIEWS ve Yorumlar ---
            _buildSectionTitle('Reviews'),
            const SizedBox(height: 12),

            Column(
              children: [
                ...widget.reviews.map((review) => CommentCard(
                      comment: Comment(
                        id: review['id'] ?? '',
                        message: review['comment'] ?? '',
                        rating: review['rating']?.toInt() ?? 0,
                        createdAt: review['timePosted'] != null
                            ? (review['timePosted'] is String
                                ? DateTime.parse(review['timePosted'])
                                : review['timePosted'] as DateTime)
                            : DateTime.now(),
                        authorName: review['name'] ?? '',
                        authorAvatar: review['photoUrl'] ?? '',
                      ),
                    )),
                ..._comments.map((comment) => CommentCard(comment: comment)),
                const SizedBox(height: 20),

                // Yorum Ekle Butonu
                ElevatedButton.icon(
                  onPressed: () async {
                    if (!await GuestAccessService.ensureLoggedIn(context)) {
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) => CommentDialog(
                        cardId: widget.userName,
                        onCommentAdded: _onCommentAdded,
                        currentUserName:
                            _currentUserName ?? 'Bilinmeyen Kullanıcı',
                      ),
                    );
                  },
                  icon: const Icon(Icons.rate_review, size: 20),
                  label: Text(
                      "Yorum Ekle (${widget.reviews.length + _comments.length})"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple, // Tema rengi
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(200, 48),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
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

  // --- YARDIMCI WIDGETLAR ---

  // İstatistik Kutusu (Tema rengi ve yuvarlak kenarlık kullanıldı)
  Widget _buildStatsRow() {
    return Container(
      decoration: BoxDecoration(
          color: statCardColor, // Çok açık mor kart rengi
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryPurple), // Hafif kenarlık
          boxShadow: [
            BoxShadow(
                color: primaryPurple.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ]),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(widget.followers.toString(), "Followers"),
          _buildStatItem(widget.following.toString(), "Following"),
          _buildStatItem(widget.reviews.length.toString(), "Reviews"),
        ],
      ),
    );
  }

  // İstatistik Öğesi (Metin tema rengi)
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: primaryPurple),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  // Başlık Stili (Metin tema rengi)
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: primaryPurple),
    );
  }

  // Skill Chip (Koyu mor zemin, Beyaz yazı)
  Widget _buildSkillChip(String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        // Çip için koyu, belirgin mor tonu kullanıldı
        color: skillChipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, // Beyaz yazı
              fontWeight: FontWeight.w500,
              fontSize: 13)),
    );
  }
}
