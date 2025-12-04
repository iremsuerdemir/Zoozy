import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  // Platforma göre API Base URL seçimi
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5001";
    }
    if (Platform.isAndroid) {
      return "http://192.168.135.35:5001"; // ← gerçek PC IP (USB tethering)
    }

    if (Platform.isIOS) {
      return "http://192.168.135.35:5001";
    }

    return "http://localhost:5001";
  }

  // ------------------------------ AUTOCOMPLETE ------------------------------
  static Future<List<dynamic>> getPlaces(String input) async {
    if (input.isEmpty) return [];

    final url = Uri.parse("$baseUrl/places/autocomplete?input=$input");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["predictions"];
    } else {
      throw Exception("Failed to fetch places: ${response.statusCode}");
    }
  }

  // ------------------------------ DETAILS ------------------------------
  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.parse("$baseUrl/places/details?place_id=$placeId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch place details: ${response.statusCode}");
    }
  }
}
