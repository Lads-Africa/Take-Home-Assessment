import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders();

    http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response = await http.post(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'PUT':
        response = await http.put(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers);
        break;
      default:
        throw Exception('Unsupported HTTP method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Request failed with status: ${response.statusCode} - ${response.body}');
    }
  }

  // -------------------------------
  // AUTH
  // -------------------------------
  Future<User> login(String email, String password) async {
    final response = await _makeRequest(
      'POST',
      '/login',
      body: {'email': email, 'password': password},
    );

    final token = response['access_token'];
    await _saveToken(token);

    return User.fromJson(response['user']);
  }

  Future<void> logout() async {
    try {
      await _makeRequest('POST', '/logout');
      await _removeToken();
    } catch (e) {
      await _removeToken();
      rethrow;
    }
  }

  Future<User> getCurrentUser() async {
    final response = await _makeRequest('GET', '/user');
    return User.fromJson(response);
  }

  // -------------------------------
  // PRODUCTS
  // -------------------------------
  Future<List<Product>> getProducts() async {
    final response = await _makeRequest('GET', '/products');

    // response may be: List OR {data: [...]} depending on API
    dynamic raw = response;

    if (response is Map) {
      if (response['data'] is List) {
        raw = response['data'];
      } else if (response['products'] is List) {
        raw = response['products'];
      } else {
        raw = response.values.toList();
      }
    }

    if (raw is! List) {
      throw Exception('Unexpected products shape: ${response.runtimeType}');
    }

    return raw
        .map<Product>((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProduct(int id) async {
    final response = await _makeRequest('GET', '/products/$id');
    return Product.fromJson(response);
  }

  // -------------------------------
  // ORDERS
  // -------------------------------
  Future<List<Order>> getOrders() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/orders'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load orders: ${res.statusCode} ${res.body}');
    }

    final decoded = jsonDecode(res.body);
    dynamic raw = decoded;

    // Support multiple possible response shapes
    if (decoded is Map) {
      if (decoded['data'] is List) {
        raw = decoded['data'];
      } else if (decoded['orders'] is List) {
        raw = decoded['orders'];
      } else {
        raw = decoded.values.toList();
      }
    }

    if (raw is! List) {
      throw Exception(
        'Unexpected orders response shape: ${decoded.runtimeType}',
      );
    }

    return raw
        .map<Order>(
          (json) => Order.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Order> getOrder(int id) async {
    final response = await _makeRequest('GET', '/orders/$id');
    return Order.fromJson(response);
  }
}
