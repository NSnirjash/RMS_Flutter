import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:rms_flutter/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService{
  final String baseUrl = 'http://localhost:8090';

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];
      final user = data['user'];

      // Decode token to get role
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'];

      // Store token and role
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      await prefs.setString('userRole', role);
      await prefs.setString('user', jsonEncode(user));

      return true;
    } else {
      print('Failed to log in: ${response.body}');
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> user) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(user);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);

      return true;
    } else {
      print('Failed to register: ${response.body}');
      return false;
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userRole'));
    return prefs.getString('userRole');
  }

  Future<bool> isTokenExpired() async {
    String? token = await getToken();
    if (token != null) {
      DateTime expiryDate = Jwt.getExpiryDate(token)!;
      return DateTime.now().isAfter(expiryDate);
    }
    return true;
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    if (token != null && !(await isTokenExpired())) {
      return true;
    } else {
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userRole');
  }

  Future<bool> hasRole(List<String> roles) async {
    String? role = await getUserRole();
    return role != null && roles.contains(role);
  }

  Future<bool> isAdmin() async {
    return await hasRole(['ADMIN']);
  }

  Future<bool> isWaiter() async {
    return await hasRole(['WAITER']);
  }

  Future<bool> isUser() async {
    return await hasRole(['USER']);
  }

  Future<User?> getCurrentUser() async {
    final sp = await SharedPreferences.getInstance();
    final userJson = sp.getString('user');
    if (userJson != null) {
      User user = User.fromJson(jsonDecode(userJson));
      return user;
    } else {
      return null;
    }
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token == null) {
      throw Exception("Authorization token not found.");
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Fetch all users
  Future<List<User>> getAllUsers() async {
    final url = Uri.parse('$baseUrl/getAllUsers');
    final headers = await _getAuthHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception(
          'Failed to fetch users. Error ${response.statusCode}: ${response.body}');
    }
  }

  // Fetch all waiters
  Future<List<User>> getAllWaiters() async {
    final url = Uri.parse('$baseUrl/getAllWaiters');
    final headers = await _getAuthHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception(
          'Failed to fetch waiters. Error ${response.statusCode}: ${response.body}');
    }
  }
}

