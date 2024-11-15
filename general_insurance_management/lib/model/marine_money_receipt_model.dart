import 'package:general_insurance_management/model/marine_bill_model.dart';

class MarineMoneyReceiptModel {
  int? id;
  String? issuingOffice;
  String? classOfInsurance;
  DateTime? date;
  String? modeOfPayment;
  String? issuedAgainst;
  MarineBillModel? marinebill;

  MarineMoneyReceiptModel({
    this.id,
    this.issuingOffice,
    this.classOfInsurance,
    this.date,
    this.modeOfPayment,
    this.issuedAgainst,
    this.marinebill,
  });

  // JSON deserialization
  MarineMoneyReceiptModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        issuingOffice = json['issuingOffice'],
        classOfInsurance = json['classOfInsurance'],
        date = json['date'] != null ? DateTime.parse(json['date']) : null, // Parse date string to DateTime
        modeOfPayment = json['modeOfPayment'],
        issuedAgainst = json['issuedAgainst'],
        marinebill = json['marinebill'] != null
            ? MarineBillModel.fromJson(json['marinebill'])
            : null;

  // JSON serialization
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['issuingOffice'] = issuingOffice;
    data['classOfInsurance'] = classOfInsurance;
    data['date'] = date?.toIso8601String(); // Convert DateTime to ISO 8601 string
    data['modeOfPayment'] = modeOfPayment;
    data['issuedAgainst'] = issuedAgainst;
    if (marinebill != null) {
      data['marinebill'] = marinebill!.toJson();
    }
    return data;
  }
}
