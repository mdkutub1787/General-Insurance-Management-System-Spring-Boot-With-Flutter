import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarinePolicyService {
  final String apiUrl = 'http://localhost:8080/api/marinepolicy/';

  Future<List<MarinePolicyModel>> fetchMarinePolicies() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson
          .map((json) => MarinePolicyModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Marine Policies');
    }
  }

// Delete a marine policy by ID
  Future<bool> deleteMarinePolicy(int id) async {
    final String apiUrl = 'http://localhost:8080/api/marinepolicy/delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true; // Deletion successful
      } else {
        throw Exception(
            'Failed to delete Marine Policy: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting Marine Policy: $e');
    }
  }
}

class CreateMarinePolicyService {
  final String apiUrl = 'http://localhost:8080/api/marinepolicy/save';
  final String currencyApiUrl = 'https://api.exchangerate-api.com/v4/latest/USD'; // Replace with your actual API

  Future<http.Response> createMarinePolicy(MarinePolicyModel marinePolicy) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(marinePolicy.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to create Marine Policy: ${response.body}');
    }
  }

  Future<double> getUsdToTkRate() async {
    final response = await http.get(Uri.parse(currencyApiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Assuming 'rates' is a field in the API response containing the conversion rates
      return jsonData['rates']['BDT'] ?? 0.0; // Adjust according to the actual response structure
    } else {
      throw Exception('Failed to fetch currency conversion rate: ${response.body}');
    }
  }
}
