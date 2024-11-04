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

  // Future<MarineMoneyReceiptModel> createMarineMoneyReceipt(MarineMoneyReceiptModel receipt) async {
  //   final response = await http.post(
  //     Uri.parse(apiUrl + 'save'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(receipt.toJson()), // Serialize the receipt to JSON
  //   );
  //
  //   if (response.statusCode == 201) {
  //     // Return the created receipt from the response
  //     return MarineMoneyReceiptModel.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to create Marine Money Receipt');
  //   }
  // }


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

}
