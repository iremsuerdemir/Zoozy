import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  /// Backend API base URL
  static const String baseUrl = 'http://192.168.193.149:5001/api/auth';

  /// Http client
  final http.Client httpClient;

  AuthService({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  /// ==========================================
  /// 1. EMAIL + ŞİFRE İLE KAYIT OL
  /// ==========================================
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'displayName': displayName,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Kullanıcı bilgilerini SharedPreferences'a kaydet
          await _saveUserToPrefs(data['user']);

          return AuthResponse(
            success: true,
            message: data['message'] ?? 'Kayıt başarılı!',
            user: UserData.fromJson(data['user']),
          );
        } else {
          return AuthResponse(
            success: false,
            message: data['message'] ?? 'Kayıt başarısız.',
          );
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Hatalı istek.',
        );
      } else {
        return AuthResponse(
          success: false,
          message: 'Kayıt sırasında hata oluştu. (${response.statusCode})',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Ağ hatası: ${e.toString()}',
      );
    }
  }

  /// ==========================================
  /// 2. EMAIL + ŞİFRE İLE GİRİŞ YAP
  /// ==========================================
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Kullanıcı bilgilerini SharedPreferences'a kaydet
          await _saveUserToPrefs(data['user']);

          return AuthResponse(
            success: true,
            message: data['message'] ?? 'Giriş başarılı!',
            user: UserData.fromJson(data['user']),
          );
        } else {
          return AuthResponse(
            success: false,
            message: data['message'] ?? 'Giriş başarısız.',
          );
        }
      } else if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Email veya şifre yanlış.',
        );
      } else {
        return AuthResponse(
          success: false,
          message: 'Giriş sırasında hata oluştu. (${response.statusCode})',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Ağ hatası: ${e.toString()}',
      );
    }
  }

  /// ==========================================
  /// 3. GOOGLE FIREBASE AUTH İLE GİRİŞ
  /// ==========================================
  Future<AuthResponse> googleLogin({
    required String firebaseUid,
    required String email,
    required String displayName,
    String? photoUrl,
  }) async {
    try {
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/google-login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'firebaseUid': firebaseUid,
              'email': email,
              'displayName': displayName,
              'photoUrl': photoUrl,
              'provider': 'google',
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Kullanıcı bilgilerini SharedPreferences'a kaydet
          await _saveUserToPrefs(data['user']);

          return AuthResponse(
            success: true,
            message: data['message'] ?? 'Google ile giriş başarılı!',
            user: UserData.fromJson(data['user']),
          );
        } else {
          return AuthResponse(
            success: false,
            message: data['message'] ?? 'Google giriş başarısız.',
          );
        }
      } else {
        return AuthResponse(
          success: false,
          message:
              'Google giriş sırasında hata oluştu. (${response.statusCode})',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Ağ hatası: ${e.toString()}',
      );
    }
  }

  /// ==========================================
  /// 4. ŞİFRE SIFLAMA (Firebase)
  /// ==========================================
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
  }

  /// ==========================================
  /// 5. KULLANICI BİLGİLERİNİ AL (ID ile)
  /// ==========================================
  Future<UserData?> getUserById(int id) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/user/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return UserData.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      print('Kullanıcı alma hatası: $e');
      return null;
    }
  }

  /// ==========================================
  /// 5. KULLANICI BİLGİLERİNİ AL (Email ile)
  /// ==========================================
  Future<UserData?> getUserByEmail(String email) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/user-by-email/$email'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return UserData.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      print('Kullanıcı alma hatası: $e');
      return null;
    }
  }

  /// ==========================================
  /// 6. LOGOUT - SharedPreferences temizle
  /// ==========================================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('email');
    await prefs.remove('displayName');
    await prefs.remove('photoUrl');
    await prefs.remove('provider');
    await prefs.remove('firebaseUid');
  }

  /// ==========================================
  /// 7. KULLANICI BİLGİSİNİ PREFS'E KAYDET
  /// ==========================================
  Future<void> _saveUserToPrefs(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user['id']);
    await prefs.setString('email', user['email']);
    await prefs.setString('displayName', user['displayName']);
    if (user['photoUrl'] != null) {
      await prefs.setString('photoUrl', user['photoUrl']);
    }
    await prefs.setString('provider', user['provider']);
    if (user['firebaseUid'] != null) {
      await prefs.setString('firebaseUid', user['firebaseUid']);
    }
  }

  /// ==========================================
  /// 8. OTURUM AÇTIĞI KULLANICININ BİLGİSİNİ AL
  /// ==========================================
  Future<UserData?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      return null;
    }

    return UserData(
      id: userId,
      email: prefs.getString('email') ?? '',
      displayName: prefs.getString('displayName') ?? '',
      photoUrl: prefs.getString('photoUrl'),
      provider: prefs.getString('provider') ?? 'local',
      firebaseUid: prefs.getString('firebaseUid'),
      createdAt: DateTime.now(),
    );
  }

  /// ==========================================
  /// 9. KULLANICI OTURUM AÇMIŞ MI KONTROL ET
  /// ==========================================
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') != null;
  }
}

/// ==========================================
/// AUTH RESPONSE MODEL
/// ==========================================
class AuthResponse {
  final bool success;
  final String message;
  final UserData? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.user,
  });
}

/// ==========================================
/// USER DATA MODEL
/// ==========================================
class UserData {
  final int id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String provider;
  final String? firebaseUid;
  final DateTime createdAt;

  UserData({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.provider,
    this.firebaseUid,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      photoUrl: json['photoUrl'],
      provider: json['provider'] ?? 'local',
      firebaseUid: json['firebaseUid'],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'provider': provider,
      'firebaseUid': firebaseUid,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// ==========================================
/// ŞİFRE SIFLAMA YANITI
/// ==========================================
