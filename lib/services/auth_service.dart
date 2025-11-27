import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; 
  static const String _registerUrl = '$_baseUrl/register';
  static const String _loginUrl = '$_baseUrl/login';
  static const String _logoutUrl = '$_baseUrl/logout';

  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? nim,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'role': role,
          'nim': nim, 
          'phone': phone,
        }),
      );

      return _handleAuthResponse(response);
    } catch (e) {
      throw Exception('Network error during registration: $e'); 
    }
  }

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      return _handleAuthResponse(response);
    } catch (e) {
      throw Exception('Network error during login: $e');
    }
  }


  Future<void> logout() async {
    final prefs = await _getPrefs();
    final token = prefs.getString(_tokenKey);

    try {
      if (token != null) {
        await http.post(
          Uri.parse(_logoutUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      print('Warning: API logout failed ($e), clearing local data.');
    } finally {
    
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    }
  }

  Future<Map<String, dynamic>> _handleAuthResponse(http.Response response) async {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && data['success'] == true) {
        final prefs = await _getPrefs();
        await prefs.setString(_tokenKey, data['token']);
        await prefs.setString(_userKey, jsonEncode(data['user']));
        return data;
      } else {
    
        throw Exception(data['message'] ?? 'Authentication failed (Status ${response.statusCode})');
      }
    } on FormatException {
      throw Exception('Invalid response format from server (Status ${response.statusCode})');
    }
  }
  
  Future<String?> getToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await _getPrefs();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}