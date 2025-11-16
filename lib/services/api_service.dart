import 'dart:convert';
import 'dart:async';
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
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Try different token locations
        String? token;
        if (jsonData['authorization'] != null &&
            jsonData['authorization']['token'] != null) {
          token = jsonData['authorization']['token'];
        } else if (jsonData['token'] != null) {
          token = jsonData['token'];
        } else if (jsonData['access_token'] != null) {
          token = jsonData['access_token'];
        }

        print('Extracted token: $token');

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<Mahasiswa?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('No token found');
        return null;
      }

      print('Getting profile with token: $token');

      final response = await http
          .get(
            Uri.parse('$baseUrl/me'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      print('Profile response status: ${response.statusCode}');
      print('Profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // Handle if data is nested in 'data' or 'user' field
        final userData = jsonData['data'] ?? jsonData['user'] ?? jsonData;
        return Mahasiswa.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Profile error: $e');
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return false;

      final response = await http
          .put(
            Uri.parse('$baseUrl/update'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Update error: $e');
      return false;
    }
  }

  Future<List<Mahasiswa>> getAllMahasiswa() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return [];

      final response = await http
          .get(
            Uri.parse('${baseUrl.replaceAll('/list', '')}/list'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      print('Get all mahasiswa response: ${response.statusCode}');
      print('Get all mahasiswa body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        List<dynamic> data;
        if (jsonData is List) {
          data = jsonData;
        } else if (jsonData['data'] != null) {
          data = jsonData['data'];
        } else {
          data = [];
        }

        return data.map((item) => Mahasiswa.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Get all mahasiswa error: $e');
      return [];
    }
  }

  Future<bool> createMahasiswa(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('${baseUrl.replaceAll('/mahasiswa', '')}/mahasiswa/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Create mahasiswa error: $e');
      return false;
    }
  }

  Future<bool> updateMahasiswa(int id, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('${baseUrl.replaceAll('/mahasiswa', '')}/mahasiswa/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Update mahasiswa error: $e');
      return false;
    }
  }

  Future<bool> deleteMahasiswa(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('${baseUrl.replaceAll('/mahasiswa', '')}/mahasiswa/$id'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete mahasiswa error: $e');
      return false;
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
