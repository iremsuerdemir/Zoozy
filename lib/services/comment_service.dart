import 'package:zoozy/models/comment.dart';

class CommentService {
  static final CommentService _instance = CommentService._internal();
  factory CommentService() => _instance;
  CommentService._internal();

  // Hafızada yorumları tutmak için Map kullanıyoruz
  // Key: cardId, Value: o karta ait yorumların listesi
  final Map<String, List<Comment>> _comments = {};

  // Belirli bir karta ait yorumları getir
  List<Comment> getCommentsForCard(String cardId) {
    return _comments[cardId] ?? [];
  }

  // Yeni yorum ekle
  void addComment(String cardId, Comment comment) {
    if (_comments[cardId] == null) {
      _comments[cardId] = [];
    }
    _comments[cardId]!.add(comment);
  }

  // Belirli bir kartın yorumlarını sil
  void deleteCommentsForCard(String cardId) {
    _comments.remove(cardId);
  }

  // Tüm yorumları temizle
  void clearAllComments() {
    _comments.clear();
  }

  // Toplam yorum sayısını getir
  int getTotalCommentCount() {
    int total = 0;
    for (var comments in _comments.values) {
      total += comments.length;
    }
    return total;
  }

  // Belirli bir kartın yorum sayısını getir
  int getCommentCountForCard(String cardId) {
    return _comments[cardId]?.length ?? 0;
  }
}
