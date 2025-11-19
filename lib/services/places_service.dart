import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  static Future<List<dynamic>> getPlaces(String input) async {
    if (input.isEmpty) return [];

    final url =
        Uri.parse("http://localhost:5182/places/autocomplete?input=$input");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["predictions"];
    } else {
      throw Exception("Failed to fetch places");
    }
  }
}
