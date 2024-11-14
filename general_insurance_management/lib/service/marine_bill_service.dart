import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarineBillService {
  final String baseUrl = "http://localhost:8080/api/marinebill/";

  // Fetch all marine bills
  Future<List<MarineBillModel>> fetchMarineBills() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> billJson = json.decode(response.body);
      return billJson.map((json) => MarineBillModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load marine bills: ${response.statusCode} ${response.body}');
    }
  }

  // Create a new marine bill
  Future<void> createMarineBill(MarineBillModel marinebill, String policyId,
      {String? token}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.post(Uri.parse(baseUrl + "save"),
      headers: headers,
      body: jsonEncode(marinebill.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create fire bill');
    }
  }


  Future<bool> deleteMarineBill(int id) async {
    final String apiUrl = '${baseUrl}delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true; // Deletion successful
      } else {
        throw Exception('Failed to delete Marine  bill: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting fire Policy: $e');
    }
  }

  // Update a marine bill by ID
  Future<void> updateMarineBill(int id, MarineBillModel marineBill) async {
    final response = await http.put(
      Uri.parse('${baseUrl}update/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(marineBill.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update marine bill: ${response.statusCode} ${response.body}');
    }
  }


}
