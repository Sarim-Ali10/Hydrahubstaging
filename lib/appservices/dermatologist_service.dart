import 'dart:convert';
import 'package:http/http.dart' as http;

class DermatologistService {
  static const String _baseUrl =
      'https://hydra-hub-nu3pkryb6-touseef-ahmeds-projects.vercel.app/api';
  static Future<List<dynamic>> getNearbyDermatologists({
    required double latitude,
    required double longitude,
    bool problemDetected = true,
    int radius = 5000,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/dermatologists/nearby?latitude=$latitude&longitude=$longitude&radius=$radius&problemDetected=$problemDetected',
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        return jsonData['data'];
      } else {
        throw Exception("API returned success: false");
      }
    } else {
      throw Exception("Failed to fetch dermatologists: ${response.statusCode}");
    }
  }
}
