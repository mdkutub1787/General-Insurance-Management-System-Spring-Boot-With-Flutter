import 'dart:convert';
import 'package:general_insurance_management/model/marine_policy_model.dart';

class MarineBillModel {
  int? id; // Make ID nullable
  double marineRate;
  double warSrccRate;
  double netPremium;
  double tax;
  double stampDuty;
  double grossPremium;
  MarinePolicyModel marineDetails;

  /// Constructor for the MarineBillModel
  MarineBillModel({
    this.id, // Nullable ID
    required this.marineRate,
    required this.warSrccRate,
    required this.netPremium,
    required this.tax,
    required this.stampDuty,
    required this.grossPremium,
    required this.marineDetails,
  });

  /// Factory constructor to create a MarineBillModel from a JSON map
  factory MarineBillModel.fromJson(Map<String, dynamic> json) {
    return MarineBillModel(
      id: json['id'], // Nullable ID
      marineRate: (json['marineRate'] is num) ? json['marineRate'].toDouble() : 0.0,
      warSrccRate: (json['warSrccRate'] is num) ? json['warSrccRate'].toDouble() : 0.0,
      netPremium: (json['netPremium'] is num) ? json['netPremium'].toDouble() : 0.0,
      tax: (json['tax'] is num) ? json['tax'].toDouble() : 0.0,
      stampDuty: (json['stampDuty'] is num) ? json['stampDuty'].toDouble() : 0.0,
      grossPremium: (json['grossPremium'] is num) ? json['grossPremium'].toDouble() : 0.0,
      marineDetails: MarinePolicyModel.fromJson(json['marineDetails']),
    );
  }

  /// Convert the MarineBillModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marineRate': marineRate,
      'warSrccRate': warSrccRate,
      'netPremium': netPremium,
      'tax': tax,
      'stampDuty': stampDuty,
      'grossPremium': grossPremium,
      'marineDetails': marineDetails.toJson(),
    };
  }
}
