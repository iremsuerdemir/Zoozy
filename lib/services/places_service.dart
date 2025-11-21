import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String _baseUrl = "http://localhost:5001";

  static Future<List<dynamic>> getPlaces(String input) async {
    if (input.isEmpty) return [];

    final url = Uri.parse("$_baseUrl/places/autocomplete?input=$input");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["predictions"];
    } else {
      throw Exception("Failed to fetch places");
    }
  }

  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.parse("$_baseUrl/places/details?place_id=$placeId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch place details");
    }
  }
}
