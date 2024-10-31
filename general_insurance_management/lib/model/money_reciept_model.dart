// money_receipt_model.dart
import 'package:general_insurance_management/model/bill_model.dart';

class MoneyReceiptModel {
  int? id;
  String? issuingOffice;
  String? classOfInsurance;
  String? date;
  String? modeOfPayment;
  String? issuedAgainst;
  BillModel? bill;

  // Constructor
  MoneyReceiptModel({
    this.id,
    this.issuingOffice,
    this.classOfInsurance,
    this.date,
    this.modeOfPayment,
    this.issuedAgainst,
    this.bill,
  });

  // Factory constructor for creating a new MoneyReceiptModel instance from a JSON map
  MoneyReceiptModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    issuingOffice = json['issuingOffice'];
    classOfInsurance = json['classOfInsurance'];
    date = json['date'];
    modeOfPayment = json['modeOfPayment'];
    issuedAgainst = json['issuedAgainst'];
    bill = json['bill'] != null ? BillModel.fromJson(json['bill']) : null;
  }

  // Method to convert an instance of MoneyReceiptModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['issuingOffice'] = issuingOffice;
    data['classOfInsurance'] = classOfInsurance;
    data['date'] = date;
    data['modeOfPayment'] = modeOfPayment;
    data['issuedAgainst'] = issuedAgainst;
    if (bill != null) {
      data['bill'] = bill!.toJson();
    }
    return data;
  }
}
