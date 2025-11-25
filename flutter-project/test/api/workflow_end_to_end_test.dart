import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:8000/api';
const String testEmail = 'user@test.com';
const String testPassword = 'password';

Future<String?> loginAndGetToken() async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
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
  return data['token'] ?? data['access_token'] ?? data['data']?['token'];
}

List<dynamic> extractProducts(dynamic decoded) {
  if (decoded is List) return decoded;
  if (decoded is Map) {
    final inner = decoded['data'] ?? decoded['products'] ?? decoded;
    if (inner is List) return inner;
    if (inner is Map) return inner.values.toList();
  }
  return [];
}

void main() {
  group('END-TO-END WORKFLOW', () {
    String? token;
    int? firstProductId;

    test('Step 1: Login works and we get token', () async {
      token = await loginAndGetToken();
      expect(token, isNotNull);
    });

    test('Step 2: Fetch products and pick first product', () async {
      expect(token, isNotNull);

      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      expect(response.statusCode, 200);

      final decoded = jsonDecode(response.body);
      final products = extractProducts(decoded);

      expect(
        products,
        isA<List>(),
        reason:
            'Expected products collection to be list-like. Actual top-level type: ${decoded.runtimeType}',
      );
      expect(
        products,
        isNotEmpty,
        reason:
            'No products returned; cannot complete workflow test. If products should exist, log as bug.',
      );

      final dynamic first = products.first;

      if (first is Map && first['id'] != null) {
        final idValue = first['id'];
        if (idValue is int) {
          firstProductId = idValue;
        } else if (idValue is String) {
          firstProductId = int.tryParse(idValue);
        }
      }

      expect(
        firstProductId,
        isNotNull,
        reason:
            'First product does not contain a valid "id" field. This is either a response shape issue or a missing field bug.',
      );
    });

      test('Step 3: Create an order for selected product', () async {
        expect(token, isNotNull);
        expect(firstProductId, isNotNull);

        // According to API validation, it expects an "items" array.
        final payload = {
          'items': [
            {
              'product_id': firstProductId,
              'quantity': 1,
            },
          ],
        };

        final response = await http.post(
          Uri.parse('$baseUrl/orders'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payload),
        );

        expect(
          response.statusCode,
          anyOf([200, 201]),
          reason:
              'Expected successful order creation. Got ${response.statusCode}: ${response.body}',
        );

        final data = jsonDecode(response.body);
        expect(data, isA<Map>());
      });

  });
}
