import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/mahasiswa.dart';

class ApiService {
  // Choose host depending on platform: web (localhost) vs Android emulator (10.0.2.2)
  late final String baseUrl;

  ApiService() {
    if (kIsWeb) {
      baseUrl = 'http://localhost:8000/api/mahasiswa';
    } else {
      // Android emulator uses 10.0.2.2 to reach host machine
      baseUrl = 'http://10.0.2.2:8000/api/mahasiswa';
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      // support multiple possible token locations
      final token = jsonData['authorization']?['token'] ?? jsonData['token'] ?? jsonData['access_token'];
      if (token != null) {
        await prefs.setString('token', token);
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<Mahasiswa?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Mahasiswa.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (_) {}
    await prefs.remove('token');
  }
}
