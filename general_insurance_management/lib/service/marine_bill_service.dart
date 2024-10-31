
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarineBillService {
  final String apiUrl = 'http://localhost:8080/api/marinebill/';

  Future<List<MarineBillModel>> fetchMarineBills() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson.map((json) => MarineBillModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Fire Bills');
    }
  }
}