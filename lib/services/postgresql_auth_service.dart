import 'dart:convert';
import 'package:http/http.dart' as http;

class PostgresqlAuthService {
  // Use 10.0.2.2 for Android emulator (maps to host machine's localhost)
  // For physical phone on same network, use: http://172.16.100.201:3000/api
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  /// Register a new user
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    String? password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password ?? 'defaultpass123', // Default password if not provided
          'first_name': firstName ?? username,
          'last_name': lastName ?? '',
          'phone': phone ?? '',
        }),
      );

      print('📤 Registration request sent to: $baseUrl/auth/register');
      print('📊 Status code: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'user': data['user'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      print('❌ Registration error: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  /// Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('📤 Login request sent to: $baseUrl/auth/login');
      print('📊 Status code: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('❌ Login error: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  /// Test API connection
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/properties?limit=1'),
      ).timeout(Duration(seconds: 5));
      print('🔍 Testing connection to: $baseUrl/properties?limit=1');
      print('📊 Status code: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}
