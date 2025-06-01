import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String baseUrl = 'https://api-qi2qpwg2aa-uc.a.run.app';

  static Future<String> getAIResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/test-ai'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? 'No response';
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
