import 'package:flutter/material.dart';

class MomentsPostCard extends StatefulWidget {
  final String userName;
  final String displayName;
  final String userPhoto;
  final String postImage;
  final String description;
  final int likes;
  final int comments;
  final DateTime timePosted;

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
  }) : super(key: key);

  @override
  State<MomentsPostCard> createState() => _MomentsPostCardState();
}

class _MomentsPostCardState extends State<MomentsPostCard> {
  bool isLiked = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void onCommentTap() {
    // Yorum sayfasına yönlendirme kodu buraya
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Yorum sayfasına yönlendirildi!")),
    );
  }

  void onUserTap() {
    // Kullanıcı profiline yönlendirme kodu buraya
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.displayName} profiline gidiliyor...")),
    );
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
          // Kullanıcı bilgisi
          ListTile(
            onTap: onUserTap,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.userPhoto),
              radius: 24,
            ),
            title: Text(
              widget.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              '@${widget.userName}',
              style: const TextStyle(color: Colors.blueAccent),
            ),
            trailing: Text(
              timeAgo(widget.timePosted),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),

          // Gönderi resmi
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.postImage,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),

          // Beğeni ve yorum satırı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  iconSize: 28,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey[600],
                  ),
                  onPressed: toggleLike,
                ),
                Text(
                  '$likeCount',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 26,
                  icon: const Icon(Icons.mode_comment_outlined, color: Colors.grey),
                  onPressed: onCommentTap,
                ),
                Text(
                  '${widget.comments}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // Açıklama
          if (widget.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'az önce';
    if (diff.inHours < 1) return '${diff.inMinutes} dk önce';
    if (diff.inDays < 1) return '${diff.inHours} sa önce';
    return '${diff.inDays} gün önce';
  }
}
