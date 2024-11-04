import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarineBillService {
  final String baseUrl = "http://localhost:8080/api/marinebill/";

  // Fetch all marine bills
  Future<List<MarineBillModel>> getMarineBill() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> billJson = json.decode(response.body);
      return billJson.map((json) => MarineBillModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load marine bills');
    }
  }





  // Create a new marine bill
  Future<MarineBillModel> createMarineBill(MarineBillModel marineBill, String? token) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Adjust key based on your implementation

    final response = await http.post(
      Uri.parse(baseUrl + "save"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '', // Include token if available
      },
      body: json.encode(marineBill.toJson()),
    );

    if (response.statusCode == 201) {
      return MarineBillModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create marine bill: ${response.statusCode} ${response.body}');
    }
  }


  // Delete a marine bill by ID
  Future<void> deleteMarineBill(int id) async {
    final response = await http.delete(Uri.parse(baseUrl + "delete/$id"));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete marine bill');
    }
  }

}
