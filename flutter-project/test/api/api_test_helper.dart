import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:8000/api';
const String testEmail = 'user@test.com';
const String testPassword = 'password';

Future<String?> apiLogin() async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'email': testEmail,
      'password': testPassword',
    }),
  );

  if (response.statusCode != 200) return null;

  final data = jsonDecode(response.body);
  return data['token'] ?? data['access_token'] ?? data['data']?['token'];
}
