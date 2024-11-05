import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarinePolicyService {
  final String baseUrl = 'http://localhost:8080/api/marinepolicy/';

  Future<List<MarinePolicyModel>> fetchMarinePolicies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson
          .map((json) => MarinePolicyModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Marine Policies');
    }
  }

  Future<bool> deleteMarinePolicy(int id) async {
    final String apiUrl = '${baseUrl}delete/$id';

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

  // Update a Marine Policy by ID
  Future<void> updateMarinePolicy(int id, MarinePolicyModel marinePolicy) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/api/marinepolicy/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(marinePolicy.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update marinePolicy');
    }
  }
// Future<void> updateMarinePolicy(int id, MarinePolicyModel marinePolicy) async {
//   final response = await http.put(
//     Uri.parse('${baseUrl}update/$id'),
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode(marinePolicy.toJson()),
//   );
//
//   if (response.statusCode != 200 && response.statusCode != 204) {
//     throw Exception('Failed to update Marine Policy: ${response.body}');
//   }
// }
//
//
// // Get a Marine Policy by ID
// Future<MarinePolicyModel> getMarinePolicyById(int id) async {
//   final response = await http.get(Uri.parse('$baseUrl$id'));
//
//   if (response.statusCode == 200) {
//     return MarinePolicyModel.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load Marine Policy by ID: ${response.reasonPhrase}');
//   }
// }
}

class CreateMarinePolicyService {
  final String baseUrl = 'http://localhost:8080/api/marinepolicy/save';
  final String currencyApiUrl =
      'https://api.exchangerate-api.com/v4/latest/USD'; // Replace with your actual API

  Future<http.Response> createMarinePolicy(
      MarinePolicyModel marinePolicy) async {
    final response = await http.post(
      Uri.parse(baseUrl),
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
      return jsonData['rates']['BDT'] ?? 0.0;
    } else {
      throw Exception(
          'Failed to fetch currency conversion rate: ${response.body}');
    }
  }
}
