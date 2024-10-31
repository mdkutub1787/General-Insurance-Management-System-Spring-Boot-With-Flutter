
import 'package:general_insurance_management/model/marine_policy_model.dart';

class MarineBillModel {
  int? id;
  int? marineRate;
  int? warSrccRate;
  double? netPremium;
  double? tax;
  int? stampDuty;
  double? grossPremium;
  MarinePolicyModel? marineDetails;

  MarineBillModel({
    this.id,
    this.marineRate,
    this.warSrccRate,
    this.netPremium,
    this.tax,
    this.stampDuty,
    this.grossPremium,
    this.marineDetails,
  });

  MarineBillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    marineRate = json['marineRate'];
    warSrccRate = json['warSrccRate'];
    netPremium = json['netPremium'];
    tax = json['tax'];
    stampDuty = json['stampDuty'];
    grossPremium = json['grossPremium'];
    marineDetails = json['marineDetails'] != null
        ? MarinePolicyModel.fromJson(json['marineDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['marineRate'] = marineRate;
    data['warSrccRate'] = warSrccRate;
    data['netPremium'] = netPremium;
    data['tax'] = tax;
    data['stampDuty'] = stampDuty;
    data['grossPremium'] = grossPremium;
    if (marineDetails != null) {
      data['marineDetails'] = marineDetails!.toJson();
    }
    return data;
  }
}
