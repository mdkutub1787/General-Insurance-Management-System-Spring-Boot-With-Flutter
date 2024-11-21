import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MarineMoneyReceiptService {
  final String baseUrl = 'http://localhost:8080/api/marinemoneyreceipt/';

  Future<List<MarineMoneyReceiptModel>> fetchMarineMoneyReceipts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson.map((json) => MarineMoneyReceiptModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Marine Money Receipts');
    }
  }



  // Create a new marine bill
  Future<MarineMoneyReceiptModel> createMarineMoneyReceipt(MarineMoneyReceiptModel receipt, String? token) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Adjust key based on your implementation

    final response = await http.post(
      Uri.parse(baseUrl + "save"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '', // Include token if available
      },
      body: json.encode(receipt.toJson()),
    );

    if (response.statusCode == 201) {
      return MarineMoneyReceiptModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create marine bill: ${response.statusCode} ${response.body}');
    }
  }

  /// Deletes a marine money receipt by ID.
  Future<bool> deleteMarineMoneyReceipt(int id) async {
    final String apiUrl = '${baseUrl}delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true; // Deletion successful
      } else {
        throw Exception('Failed to delete Marine Money Receipt: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting Marine Money Receipt: $e');
    }
  }

  Future<void> updateMarineMoneyReceipt(int id, MarineMoneyReceiptModel moneyreceipt) async {
    try {
      final response = await http.put(
        Uri.parse('${baseUrl}update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(moneyreceipt.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Money receipt updated successfully.');
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to update fire money receipt: $errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error updating money receipt: $e');
      throw Exception('Could not update money receipt. Please check your network connection and try again.');
    }
  }

}
