import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarinePolicyService {
  final String apiUrl = 'http://localhost:8080/api/marinepolicy/';

  Future<List<MarinePolicyModel>> fetchMarinePolicies() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson.map((json) => MarinePolicyModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Marine Policies');
    }
  }
}
