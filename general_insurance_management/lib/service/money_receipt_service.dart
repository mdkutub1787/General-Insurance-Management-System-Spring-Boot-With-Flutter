
import 'package:general_insurance_management/model/money_receipt_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MoneyReceiptService {
  final String baseUrl = 'http://localhost:8080/api/moneyreceipt/';

  Future<List<MoneyReceiptModel>> fetchMoneyReceipts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson.map((json) => MoneyReceiptModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Fire Bills');
    }
  }

  // Create a new marine bill
  Future<void> createMoneyReceipt(MoneyReceiptModel receipt, String policyId, {String? token}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.post(Uri.parse(baseUrl + "save"),
      headers: headers,
      body: jsonEncode(receipt.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create fire bill');
    }
  }

  /// Deletes a fire money receipt by ID.
  Future<bool> deleteMoneyReceipt(int id) async {
    final String apiUrl = '${baseUrl}delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true; // Deletion successful
      } else {
        throw Exception('Failed to delete fire Money Receipt: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting Marine Money Receipt: $e');
    }
  }

}