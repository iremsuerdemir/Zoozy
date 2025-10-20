import 'dart:convert';

class FavoriteItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String profileImageUrl;

  FavoriteItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "imageUrl": imageUrl,
      "profileImageUrl": profileImageUrl,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      title: json["title"],
      subtitle: json["subtitle"],
      imageUrl: json["imageUrl"],
      profileImageUrl: json["profileImageUrl"],
    );
  }

  static String encode(List<FavoriteItem> items) =>
      json.encode(items.map((e) => e.toJson()).toList());

  static List<FavoriteItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<FavoriteItem>((e) => FavoriteItem.fromJson(e))
          .toList();
}
