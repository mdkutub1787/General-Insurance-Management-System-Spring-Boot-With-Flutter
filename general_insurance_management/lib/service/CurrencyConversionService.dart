import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConversionService {
  final String currencyApiUrl = 'https://api.exchangerate-api.com/v4/latest/USD';

  /// Fetches the current USD to BDT conversion rate.
  Future<double> getUsdToTkRate() async {
    final response = await http.get(Uri.parse(currencyApiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['rates']['BDT'] ?? 0.0; // Return the conversion rate
    } else {
      throw Exception('Failed to fetch currency conversion rate: ${response.body}');
    }
  }

  /// Converts an amount from USD to BDT.
  Future<double> convertUsdToTk(double amountInUsd) async {
    final double conversionRate = await getUsdToTkRate();
    return amountInUsd * conversionRate; // Convert amount to BDT
  }
}
