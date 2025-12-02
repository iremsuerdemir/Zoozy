import 'package:zoozy/models/comment.dart';

class CommentService {
  static final CommentService _instance = CommentService._internal();
  factory CommentService() => _instance;
  CommentService._internal();

  final Map<String, List<Comment>> _comments = {};

  List<Comment> getCommentsForCard(String cardId) {
    return _comments[cardId] ?? [];
  }

  void addComment(String cardId, Comment comment) {
    if (_comments[cardId] == null) {
      _comments[cardId] = [];
    }
    _comments[cardId]!.add(comment);
  }

  void deleteCommentsForCard(String cardId) {
    _comments.remove(cardId);
  }

  void clearAllComments() {
    _comments.clear();
  }

  int getTotalCommentCount() {
    int total = 0;
    for (var comments in _comments.values) {
      total += comments.length;
    }
    return total;
  }

  int getCommentCountForCard(String cardId) {
    return _comments[cardId]?.length ?? 0;
  }
}
