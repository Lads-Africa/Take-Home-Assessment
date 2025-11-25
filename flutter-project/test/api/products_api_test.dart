import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

/// Laravel API base URL for local tests.
/// Ensure backend is running on 127.0.0.1:8000.
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

/// Extract a list of items from a decoded JSON response that could be:
/// - a bare list
/// - a map with "data" or "products"
List<dynamic> extractProducts(dynamic decoded) {
  if (decoded is List) {
    return decoded;
  }
  if (decoded is Map) {
    final inner = decoded['data'] ?? decoded['products'] ?? decoded;
    if (inner is List) return inner;
    if (inner is Map) return inner.values.toList();
  }
  return [];
}

void main() {
  group('Products API', () {
    String? token;

    setUpAll(() async {
      token = await loginAndGetToken();
    });

    test('PRECONDITION: login succeeds and returns a token', () async {
      expect(
        token,
        isNotNull,
        reason:
            'Login failed. Check baseUrl, credentials, and that Laravel API is running.',
      );
    });

    test('Authenticated user can fetch product list (GET /products)', () async {
      expect(token, isNotNull);

      final uri = Uri.parse('$baseUrl/products');
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
            'Expected 200 when fetching products as authenticated user. Got ${response.statusCode}: ${response.body}',
      );

      final decoded = jsonDecode(response.body);
      final products = extractProducts(decoded);

      expect(
        products,
        isA<List>(),
        reason:
            'Expected products collection to be a list-like structure. Actual top-level type: ${decoded.runtimeType}',
      );
      // Optional: enforce non-empty if you expect seeded data
      // expect(products, isNotEmpty);
    });

    test(
      'Unauthenticated request to products endpoint is rejected (GET /products without token)',
      () async {
        final uri = Uri.parse('$baseUrl/products');

        final response = await http.get(
          uri,
          headers: {
            'Accept': 'application/json',
          },
        );

        expect(
          response.statusCode,
          anyOf([401, 403]),
          reason:
              'Expected 401/403 for unauthenticated /products. If you get 200, log bug: products visible without auth.',
        );
      },
    );

    test(
      'Fetching non-existing product returns 404 or validation error (GET /products/{id})',
      () async {
        expect(token, isNotNull);

        const nonExistingId = 999999;
        final uri = Uri.parse('$baseUrl/products/$nonExistingId');

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
              'Expected 404/400/422 for non-existing product. If you get 500, log a bug: server error when fetching non-existing product. Actual: ${response.statusCode} ${response.body}',
        );
      },
    );

    test(
      'Creating product with invalid data fails with validation/authorization error (POST /products)',
      () async {
        expect(token, isNotNull);

        final uri = Uri.parse('$baseUrl/products');

        final invalidPayload = {
          'name': '',
          'price': -10,
          'description': 'Invalid test product (should fail validation)',
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
              'Expected validation or authorization error when creating product with invalid data. Actual: ${response.statusCode} ${response.body}',
        );

        if (response.statusCode == 422) {
          final data = jsonDecode(response.body);
          expect(data, contains('errors'));
        }
      },
    );
  });
}
