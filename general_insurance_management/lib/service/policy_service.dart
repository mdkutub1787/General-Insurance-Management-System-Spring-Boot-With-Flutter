import 'package:general_insurance_management/model/policy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PolicyService {
  final String baseUrl = 'http://localhost:8080/api/policy/';

  // Fetch all Fire Policies
  Future<List<PolicyModel>> fetchFirePolicies() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> policyJson = json.decode(response.body);
        return policyJson.map((json) => PolicyModel.fromJson(json)).toList();
      } else {
        String errorMessage = 'Failed to load Fire Policies';
        if (response.statusCode == 404) {
          errorMessage = 'Policy not found';
        } else if (response.statusCode == 500) {
          errorMessage = 'Server error, please try again later';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create a new Fire Policy
  Future<http.Response> createFirePolicy(PolicyModel policy, {Map<String, String>? headers}) async {
    final Uri url = Uri.parse('${baseUrl}save'); // Adjust this endpoint as per your API

    final response = await http.post(
      url,
      headers: headers ?? {'Content-Type': 'application/json'},
      body: json.encode(policy.toJson()),
    );

    return response;
  }

  // Delete a Fire Policy by ID
  Future<void> deletePolicy(int policyId) async {
    final Uri deleteUrl = Uri.parse('${baseUrl}delete/$policyId');

    final response = await http.delete(deleteUrl);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete the policy');
    }
  }
}
