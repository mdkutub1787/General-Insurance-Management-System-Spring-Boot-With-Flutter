import 'package:general_insurance_management/model/bill_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BillService {
  final String apiUrl = 'http://localhost:8080/api/bill/';

  Future<List<BillModel>> fetchFirePolicies() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson.map((json) => BillModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Fire Bills');
    }
  }
}