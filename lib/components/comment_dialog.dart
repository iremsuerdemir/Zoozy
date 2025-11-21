import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/models/comment.dart';

class CommentDialog extends StatefulWidget {
  final String cardId;
  final Function(Comment) onCommentAdded;
  final String currentUserName;
  const CommentDialog({
    Key? key,
    required this.cardId,
    required this.onCommentAdded,
    required this.currentUserName,
  }) : super(key: key);

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _messageController = TextEditingController();
  int _selectedRating = 5;
  String? _currentUserAvatar;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAvatar();
  }

  Future<void> _loadCurrentUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final imageString = prefs.getString('profileImagePath');
    if (!mounted) return;
    if (imageString != null && imageString.isNotEmpty) {
      setState(() {
        _currentUserAvatar = 'base64:$imageString';
      });
    } else {
      setState(() {
        _currentUserAvatar = 'asset:assets/images/caregiver1.png';
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen bir yorum yazın!")),
      );
      return;
    }

    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: _messageController.text.trim(),
      rating: _selectedRating,
      createdAt: DateTime.now(),
      authorName: widget.currentUserName,
      authorAvatar: _currentUserAvatar ?? 'asset:assets/images/caregiver1.png',
    );

    widget.onCommentAdded(comment);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Yorumunuz eklendi!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Yorum Ekle"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Değerlendirme:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  child: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text(
              "Yorumunuz:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Yorumunuzu buraya yazın...",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("İptal"),
        ),
        ElevatedButton(
          onPressed: _submitComment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          child: const Text("Yorum Ekle"),
        ),
      ],
    );
  }
}
