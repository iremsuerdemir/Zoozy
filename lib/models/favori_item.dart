import 'dart:convert';

class FavoriteItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String profileImageUrl;
  final String tip; // "explore", "moments", "caregiver" gibi

  FavoriteItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.profileImageUrl,
    required this.tip,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "imageUrl": imageUrl,
      "profileImageUrl": profileImageUrl,
      "tip": tip,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      title: json["title"],
      subtitle: json["subtitle"],
      imageUrl: json["imageUrl"],
      profileImageUrl: json["profileImageUrl"],
      tip: json["tip"],
    );
  }

  static String encode(List<FavoriteItem> items) =>
      json.encode(items.map((e) => e.toJson()).toList());

  static List<FavoriteItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<FavoriteItem>((e) => FavoriteItem.fromJson(e))
          .toList();
}
