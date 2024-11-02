import 'dart:io';
import 'dart:convert';
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:http/http.dart' as http;

class CreateFirePolicyService {
  final String apiUrl = 'http://localhost:8080/api/policy/save';


  Future<void> createFirePolicy(PolicyModel policy, {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(policy.toJson()),
      );

      switch (response.statusCode) {
        case 201:
          print('Policy created successfully.');
          break;
        case 400:
          throw Exception('Bad request: Please check your input.');
        case 403:
          throw Exception(
              'Permission denied: You do not have permission to create this policy.');
        case 409:
          throw Exception('Conflict: Fire policy already exists.');
        case 500:
          throw Exception('Server error: Please try again later.');
        default:
        // Log any unexpected status code and response
          print('Unexpected status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          throw Exception(
              'An unexpected error occurred. Please try again later.');
      }
    } on SocketException {
      print('Network error: No internet connection.');
      throw Exception('Network error: Please check your internet connection.');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again later.');
    }
  }
}


