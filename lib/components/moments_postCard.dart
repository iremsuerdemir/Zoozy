import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/models/favori_item.dart';
import 'package:zoozy/models/comment.dart';
import 'package:zoozy/services/comment_service.dart';
import 'package:zoozy/components/comment_card.dart';
import 'package:zoozy/components/comment_dialog.dart';

class MomentsPostCard extends StatefulWidget {
  final String userName;
  final String displayName;
  final String userPhoto;
  final String postImage;
  final String description;
  final int likes;
  final int comments;
  final DateTime timePosted;
  final currentUserName;
  // 👇 YENİ: Profil fotoğrafına tıklama olayını yakalamak için geri çağırım
  final VoidCallback? onProfileTap;

  const MomentsPostCard({
    Key? key,
    required this.userName,
    required this.displayName,
    required this.userPhoto,
    required this.postImage,
    required this.description,
    required this.likes,
    required this.comments,
    required this.timePosted,
    required this.currentUserName,
    this.onProfileTap, // Parametreyi ekledik
  }) : super(key: key);

  @override
  State<MomentsPostCard> createState() => _MomentsPostCardState();
}

class _MomentsPostCardState extends State<MomentsPostCard> {
  bool isFavorite = false;
  late int likeCount;
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
    _checkIfFavorite();
    _loadComments();
  }

  void _loadComments() {
    // Moment kartı için unique cardId kullanıyoruz
    final cardId =
        "moment_${widget.userName}_${widget.timePosted.millisecondsSinceEpoch}";
    setState(() {
      _comments = _commentService.getCommentsForCard(cardId);
    });
  }

  void _onCommentAdded(Comment comment) {
    final cardId =
        "moment_${widget.userName}_${widget.timePosted.millisecondsSinceEpoch}";
    _commentService.addComment(cardId, comment);
    _loadComments();
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList("favoriler") ?? [];

    final exists = favs.any((element) {
      final item = FavoriteItem.fromJson(jsonDecode(element));
      return item.imageUrl == widget.postImage && item.tip == "moments";
    });

    setState(() {
      isFavorite = exists;
      // Favoriye ekliyse like'ı zaten artırdık, burada sadece kontrol ediyoruz.
      // Basitlik adına, mevcut likeCount'u koruyoruz veya yeniden hesaplıyoruz.
      // Sadece isFavorite durumunu doğru yansıtmak yeterli.
      // Like sayısını sadece favori butonuna basıldığında değiştirmek daha doğru olur.
    });
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
      likeCount += isFavorite ? 1 : -1;
    });

    if (isFavorite) {
      await _favoriyeEkle();
    } else {
      await _favoridenSil();
    }
  }

  Future<void> _favoriyeEkle() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> mevcutFavoriler = prefs.getStringList("favoriler") ?? [];

    final favItem = FavoriteItem(
      title: widget.displayName,
      subtitle: widget.description,
      imageUrl: widget.postImage,
      profileImageUrl: widget.userPhoto,
      tip: "moments",
    );

    if (!mevcutFavoriler.any((element) =>
        FavoriteItem.fromJson(jsonDecode(element)).imageUrl ==
        favItem.imageUrl)) {
      mevcutFavoriler.add(jsonEncode(favItem.toJson()));
      await prefs.setStringList("favoriler", mevcutFavoriler);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Favorilere eklendi!")));
    }
  }

  Future<void> _favoridenSil() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> mevcutFavoriler = prefs.getStringList("favoriler") ?? [];

    mevcutFavoriler.removeWhere((element) {
      final item = FavoriteItem.fromJson(jsonDecode(element));
      return item.imageUrl == widget.postImage && item.tip == "moments";
    });

    await prefs.setStringList("favoriler", mevcutFavoriler);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favorilerden kaldırıldı!")));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            // 👇 Profil resmine tıklama ekleme
            leading: GestureDetector(
              onTap: widget.onProfileTap,
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.userPhoto),
                radius: 24,
              ),
            ),
            // 👇 DisplayName'e tıklama ekleme (isteğe bağlı, ListTile'ın onTap'i yerine)
            title: GestureDetector(
              onTap: widget.onProfileTap,
              child: Text(widget.displayName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            subtitle: Text('@${widget.userName}',
                style: const TextStyle(color: Colors.blueAccent)),
            trailing: Text(
              timeAgo(widget.timePosted),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.postImage,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  iconSize: 28,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey[600],
                  ),
                  onPressed: toggleFavorite,
                ),
                Text('$likeCount',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 26,
                  icon: const Icon(Icons.mode_comment_outlined,
                      color: Colors.grey),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CommentDialog(
                        currentUserName: widget.currentUserName,
                        cardId:
                            "moment_${widget.userName}_${widget.timePosted.millisecondsSinceEpoch}",
                        onCommentAdded: _onCommentAdded,
                      ),
                    );
                  },
                ),
                Text('${_comments.length}',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (_showComments)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: _comments
                    .map((comment) => CommentCard(comment: comment))
                    .toList(),
              ),
            ),
          TextButton(
            onPressed: _toggleComments,
            child: Text(_showComments ? 'Yorumları Gizle' : 'Yorumları Göster'),
          ),
        ],
      ),
    );
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 1) return '${difference.inDays} gün önce';
    if (difference.inHours >= 1) return '${difference.inHours} saat önce';
    if (difference.inMinutes >= 1) return '${difference.inMinutes} dakika önce';
    return 'Az önce';
  }
}
