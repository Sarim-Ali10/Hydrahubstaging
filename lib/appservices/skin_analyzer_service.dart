import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as _client;

class SkinAnalyzerService {
  static const String _baseUrl = 'https://hydra-hub-mf38ztuwu-touseef-ahmeds-projects.vercel.app';
  static const String _analyzeEndpoint = '/api/ai/analyze';

  final http.Client _client = http.Client();

  Future<Map<String, dynamic>> analyzeImageWithMessage(String imageUrl, String message) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl$_analyzeEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'imageUrl': imageUrl,
          'message': message,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }


  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 429) {
      return {
        'success': false,
        'error': 'Rate limit exceeded. Please try again later.',
      };
    } else {
      return {
        'success': false,
        'error': 'An error occurred. Please try again.',
      };
    }
  }
  Future<Map<String, dynamic>> analyzeMessageOnly(String message) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl$_analyzeEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
