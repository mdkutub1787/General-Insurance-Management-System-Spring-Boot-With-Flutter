import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarinePolicyService {
  final String baseUrl = 'http://localhost:8080/api/marinepolicy/';

  /// Fetches a list of marine policies.
  Future<List<MarinePolicyModel>> fetchMarinePolicies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson
          .map((json) => MarinePolicyModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Marine Policies: ${response.body}');
    }
  }

  /// Creates a new marine policy.
  Future<http.Response> createMarinePolicy(MarinePolicyModel marinePolicy) async {
    final response = await http.post(
      Uri.parse('${baseUrl}save'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(marinePolicy.toJson()), // Convert model to JSON
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response; // Successful response
    } else {
      throw Exception('Failed to create Marine Policy: ${response.body}');
    }
  }

  /// Deletes a marine policy by ID.
  Future<bool> deleteMarinePolicy(int id) async {
    final String apiUrl = '${baseUrl}delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true; // Deletion successful
      } else {
        throw Exception('Failed to delete Marine Policy: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting Marine Policy: $e');
    }
  }

  /// Updates a marine policy by ID.
  Future<void> updateMarinePolicy(int id, MarinePolicyModel marinePolicy) async {
    final response = await http.put(
      Uri.parse('${baseUrl}update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(marinePolicy.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update Marine Policy: ${response.body}');
    }
  }


}
