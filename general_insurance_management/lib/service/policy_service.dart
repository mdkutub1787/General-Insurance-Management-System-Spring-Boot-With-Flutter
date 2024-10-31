import 'package:general_insurance_management/model/policy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PolicyService {
  final String apiUrl = 'http://localhost:8080/api/policy/';

  Future<List<PolicyModel>> fetchFirePolicies() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

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
}

class CreateFirePolicyService {
  Future<http.Response> createFirePolicy(PolicyModel policy,
      {Map<String, String>? headers}) async {
    final Uri url = Uri.parse(
        'http://localhost:8080/api/policy/save'); // Replace with your API URL

    final response = await http.post(
      url,
      headers: headers ?? {'Content-Type': 'application/json'},
      body: json
          .encode(policy.toJson()), // Ensure PolicyModel has a toJson method
    );

    return response;
  }
}
