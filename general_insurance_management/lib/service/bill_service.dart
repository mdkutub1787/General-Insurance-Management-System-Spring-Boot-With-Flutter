import 'package:general_insurance_management/model/bill_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BillService {
  final String baseUrl = 'http://localhost:8080/api/bill/';



  Future<List<BillModel>> fetchFireBill() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson.map((json) => BillModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Fire Bills');
    }
  }

  //  Create a new marine bill
  Future<void> createFireBill(BillModel bill, String policyId,
      {String? token}) async {
    final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

   final response = await http.post(Uri.parse(baseUrl + "save"),
      headers: headers,
      body: jsonEncode(bill.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create fire bill');
    }
  }

  // Deletes a fire policy by ID.
  Future<bool> deleteBill(int id) async {
    final String apiUrl = '${baseUrl}delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true; // Deletion successful
      } else {
        throw Exception('Failed to delete fire bill: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting fire Policy: $e');
    }
  }

  // Updates a fire bill by ID.
  Future<void> updateBill(int id, BillModel bill) async {
    final response = await http.put(
      Uri.parse('${baseUrl}update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bill.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update fire bill: ${response.statusCode}');
    }
  }
}
