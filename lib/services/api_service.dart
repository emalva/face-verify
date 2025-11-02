import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../constants/api_urls.dart';

class ApiService {
  // Retorna true si registro exitoso
  static Future<bool> registerUser({
    required String firstName,
    String? lastName,
    required String email,
    required Uint8List photoBytes,
  }) async {
    final uri = Uri.parse(ApiUrls.register);
    final body = jsonEncode({
      'first_name': firstName,
      'last_name': lastName ?? '',
      'email': email,
      'photo': base64Encode(photoBytes),
    });
    try {
      final res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body);
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Retorna mapa con match y user o null en error
  static Future<Map?> verifyUser({required String email, required Uint8List photoBytes}) async {
    final uri = Uri.parse(ApiUrls.verify);
    final body = jsonEncode({'email': email, 'photo': base64Encode(photoBytes)});
    try {
      final res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
