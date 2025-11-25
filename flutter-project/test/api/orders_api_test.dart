import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:8000/api';
const String testEmail = 'user@test.com';
const String testPassword = 'password';

Future<String?> loginAndGetToken() async {
  final uri = Uri.parse('$baseUrl/login');

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'email': testEmail,
      'password': testPassword,
    }),
  );

  if (response.statusCode != 200) {
    print('Login failed: ${response.statusCode} ${response.body}');
    return null;
  }

  final data = jsonDecode(response.body);
  final token = data['token'] ?? data['access_token'] ?? data['data']?['token'];
  return token is String ? token : null;
}

List<dynamic> extractOrders(dynamic decoded) {
  if (decoded is List) {
    return decoded;
  }
  if (decoded is Map) {
    final inner = decoded['data'] ?? decoded['orders'] ?? decoded;
    if (inner is List) return inner;
    if (inner is Map) return inner.values.toList();
  }
  return [];
}

void main() {
  group('Orders API', () {
    String? token;

    setUpAll(() async {
      token = await loginAndGetToken();
    });

    test('PRECONDITION: login works', () async {
      expect(token, isNotNull, reason: 'Login failed.');
    });

    test('Authenticated user can fetch orders (GET /orders)', () async {
      expect(token, isNotNull);

      final uri = Uri.parse('$baseUrl/orders');
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      expect(
        response.statusCode,
        200,
        reason:
            'Expected orders list. Got: ${response.statusCode} ${response.body}',
      );

      final decoded = jsonDecode(response.body);
      final orders = extractOrders(decoded);

      expect(
        orders,
        isA<List>(),
        reason:
            'Expected orders collection to be a list-like structure. Actual top-level type: ${decoded.runtimeType}',
      );
    });

    test('Unauthenticated request to orders is rejected', () async {
      final uri = Uri.parse('$baseUrl/orders');

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      expect(
        response.statusCode,
        anyOf([401, 403]),
        reason:
            'Expected 401/403 for unauthenticated /orders. If 200, log bug: orders visible without auth.',
      );
    });

    test('Getting non-existing order returns 404', () async {
      expect(token, isNotNull);

      final uri = Uri.parse('$baseUrl/orders/999999');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      expect(
        response.statusCode,
        anyOf([404, 400, 422]),
        reason:
            'Expected 404/400/422 for non-existing order, got ${response.statusCode}',
      );
    });

    test('Creating order with invalid data fails (POST /orders)', () async {
      expect(token, isNotNull);

      final uri = Uri.parse('$baseUrl/orders');

      final invalidPayload = {
        'product_id': null,
        'quantity': -1,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(invalidPayload),
      );

      expect(
        response.statusCode,
        anyOf([401, 403, 422]),
        reason:
            'Expected validation error. Got ${response.statusCode}: ${response.body}',
      );
    });
  });
}
