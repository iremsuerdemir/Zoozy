class AppUser {
  final int? id;
  final String email;
  final String? firebaseUid;
  final String? passwordHash;
  final String? displayName;
  final String? photoUrl;
  final String provider; // 'local' or 'google'
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  AppUser({
    this.id,
    required this.email,
    this.firebaseUid,
    this.passwordHash,
    this.displayName,
    this.photoUrl,
    this.provider = 'local',
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  // JSON'dan AppUser'a dönüşüm
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      email: json['email'] ?? '',
      firebaseUid: json['firebaseUid'],
      passwordHash: json['passwordHash'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      provider: json['provider'] ?? 'local',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  // AppUser'ı JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firebaseUid': firebaseUid,
      'passwordHash': passwordHash,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'provider': provider,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Kopya oluştur (copyWith)
  AppUser copyWith({
    int? id,
    String? email,
    String? firebaseUid,
    String? passwordHash,
    String? displayName,
    String? photoUrl,
    String? provider,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      passwordHash: passwordHash ?? this.passwordHash,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() =>
      'AppUser(id: $id, email: $email, displayName: $displayName, provider: $provider)';
}
