
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarineMoneyReceiptService {
  final String apiUrl = 'http://localhost:8080/api/marinemoneyreceipt/';

  Future<List<MarineMoneyReceiptModel>> fetchMarineMoneyReceipts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> policyJson = json.decode(response.body);
      return policyJson.map((json) => MarineMoneyReceiptModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Fire Bills');
    }
  }
}