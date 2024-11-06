import 'dart:io';
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PolicyService {
  final String baseUrl = 'http://localhost:8080/api/policy/';

  // Fetch all policies (can generalize for different policy types)
  Future<List<PolicyModel>> fetchPolicies({String policyType = ''}) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + policyType));

      if (response.statusCode == 200) {
        final List<dynamic> policyJson = json.decode(response.body);
        return policyJson.map((json) => PolicyModel.fromJson(json)).toList();
      } else {
        String errorMessage = 'Failed to load Policies';
        if (response.statusCode == 404) {
          errorMessage = 'Policies not found';
        } else if (response.statusCode == 500) {
          errorMessage = 'Server error, please try again later';
        } else if (response.statusCode == 403) {
          errorMessage = 'Forbidden: Access is denied';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  //
  // // Create a new policy (generalized for different types)
  // Future<http.Response> createPolicy(PolicyModel policy, {String policyType = ''}) async {
  //   final response = await http.post(
  //     Uri.parse('${baseUrl}$policyType/save'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(policy.toJson()), // Convert model to JSON
  //   );
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return response; // Successful response
  //   } else {
  //     throw Exception('Failed to create Policy: ${response.body}');
  //   }
  // }

  //  Create a new marine policy
  Future<PolicyModel> createFireBill(PolicyModel policy, String? token) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Adjust key based on your implementation

    final response = await http.post(
      Uri.parse(baseUrl + "save"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '', // Include token if available
      },
      body: json.encode(policy.toJson()),
    );

    if (response.statusCode == 201) {
      return PolicyModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create policy bill: ${response.statusCode} ${response.body}');
    }
  }

  /// Deletes a fire policy by ID.
  Future<bool> deletePolicy(int id) async {
    final String apiUrl = '${baseUrl}delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true; // Deletion successful
      } else {
        throw Exception('Failed to delete fire Policy: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting fire Policy: $e');
    }
  }

  /// Updates a marine policy by ID.
  Future<void> updateFirePolicy(int id, PolicyModel policy) async {
    final response = await http.put(
      Uri.parse('${baseUrl}update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(policy.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update fire  Policy: ${response.body}');
    }
  }

}
