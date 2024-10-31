
import 'package:general_insurance_management/model/policy_model.dart';

class BillModel {
  int? id;
  int? fire;
  int? rsd;
  int? netPremium;
  int? tax;
  int? grossPremium;
  PolicyModel? policy;

  BillModel({
    this.id,
    this.fire,
    this.rsd,
    this.netPremium,
    this.tax,
    this.grossPremium,
    this.policy,
  });


  BillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fire = json['fire'];
    rsd = json['rsd'];
    netPremium = json['netPremium'];
    tax = json['tax'];
    grossPremium = json['grossPremium'];
    policy = json['policy'] != null ? PolicyModel.fromJson(json['policy']) : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fire'] = fire;
    data['rsd'] = rsd;
    data['netPremium'] = netPremium;
    data['tax'] = tax;
    data['grossPremium'] = grossPremium;
    if (policy != null) {
      data['policy'] = policy!.toJson();
    }
    return data;
  }
}
