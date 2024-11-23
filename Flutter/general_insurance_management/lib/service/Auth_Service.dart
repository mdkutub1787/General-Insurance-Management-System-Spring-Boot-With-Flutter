import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8080'; // Your backend API base URL

  /// Login method: Authenticates the user and stores the token and role.
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        // Decode token to get role
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        String role = payload['role'];

        // Store token and role
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setString('userRole', role);

        return true;
      } else {
        print('Failed to log in: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  /// Register method: Registers a new user and stores the token.
  Future<bool> register(Map<String, dynamic> user) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(user);

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        // Store the token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        return true;
      } else {
        print('Failed to register: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  /// Retrieve the stored authentication token.
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  /// Retrieve the stored user role.
  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  /// Check if the authentication token is expired.
  Future<bool> isTokenExpired() async {
    String? token = await getToken();
    if (token != null) {
      DateTime expiryDate = Jwt.getExpiryDate(token)!;
      return DateTime.now().isAfter(expiryDate);
    }
    return true;
  }

  /// Check if the user is logged in (token exists and is valid).
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    if (token != null && !(await isTokenExpired())) {
      return true;
    } else {
      await logout();
      return false;
    }
  }

  /// Notify the backend about logout to invalidate the token.
  Future<void> notifyServerLogout() async {
    final url = Uri.parse('$baseUrl/logout');
    final token = await getToken();

    if (token != null) {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      try {
        final response = await http.post(url, headers: headers);
        if (response.statusCode != 200) {
          print('Failed to notify server of logout: ${response.body}');
        }
      } catch (e) {
        print('Error notifying server of logout: $e');
      }
    }
  }

  /// Log out the user by clearing stored data and notifying the server.
  /// Log out the user by clearing stored data and notifying the server.
  Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      final url = Uri.parse('$baseUrl/logout');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      try {
        // Notify backend server about logout
        final response = await http.post(url, headers: headers);

        if (response.statusCode == 200) {
          print('Successfully notified server about logout.');
        } else {
          print('Server logout notification failed: ${response.body}');
        }
      } catch (e) {
        print('Error notifying server of logout: $e');
      }
    }

    // Clear all stored user-related data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all user-related data
    print('Local user data cleared.');
  }


  /// Check if the user has a specific role.
  Future<bool> hasRole(List<String> roles) async {
    String? role = await getUserRole();
    return role != null && roles.contains(role);
  }

  /// Check if the user is an Admin.
  Future<bool> isAdmin() async {
    return await hasRole(['ADMIN']);
  }

  /// Check if the user is a regular user.
  Future<bool> isUser() async {
    return await hasRole(['USER']);
  }

  /// Fetch the current user's information from the API and print it.
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/user/me');
    final token = await getToken();

    if (token == null) {
      print('No token found');
      return null;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Current User Details:');
        data.forEach((key, value) {
          print('$key: $value');
        });
        return data;
      } else {
        print('Failed to fetch current user: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching current user: $e');
      return null;
    }
  }
}
