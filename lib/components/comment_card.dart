import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zoozy/models/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) return '${difference.inDays} gün önce';
    if (difference.inHours > 0) return '${difference.inHours} saat önce';
    if (difference.inMinutes > 0) return '${difference.inMinutes} dakika önce';
    return 'Az önce';
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> _resolveAvatar(String avatar) {
      try {
        if (avatar.startsWith('base64:')) {
          final base64Str = avatar.substring(7);
          final bytes = base64Decode(base64Str);
          return MemoryImage(bytes);
        }
        final assetPath =
            avatar.startsWith('asset:') ? avatar.substring(6) : avatar;
        return AssetImage(assetPath);
      } catch (_) {
        return const AssetImage('assets/images/caregiver1.png');
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: _resolveAvatar(comment.authorAvatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatDate(comment.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < comment.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comment.message,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
