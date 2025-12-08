import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zoozy/models/user_model.dart';

class UserService {
  static const String baseUrl = "http:// 192.168.86.149:5001/api/users";

  // -------------------------------------------------------------
  // 🔥 Kullanıcı var mı?
  // -------------------------------------------------------------
  Future<bool> userExists(String firebaseUid) async {
    final url = Uri.parse("$baseUrl/exists/$firebaseUid");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["exists"] == true;
    }
    return false;
  }

  // -------------------------------------------------------------
  // 🆕 İlk kayıt (register)
  // -------------------------------------------------------------
  Future<String?> registerUser(AppUser user) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 409) return "USER_EXISTS";
    if (response.statusCode == 201 || response.statusCode == 200) {
      return "SUCCESS";
    }

    return null;
  }

  // -------------------------------------------------------------
  // 🔄 Login sonrası senkronizasyon (her girişte)
  // -------------------------------------------------------------
  Future<bool> syncUser(AppUser user) async {
    final url = Uri.parse("$baseUrl/sync");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 200;
  }

  // -------------------------------------------------------------
  // 🔥 Backend'den kullanıcı bilgisi çek
  // -------------------------------------------------------------
  Future<AppUser?> getUser(String firebaseUid) async {
    final url = Uri.parse("$baseUrl/$firebaseUid");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return AppUser.fromJson(jsonDecode(response.body));
    }

    return null;
  }
}
