import 'dart:convert';

class PolicyModel {
  int? id;
  DateTime? date;
  String? bankName;
  String? policyholder;
  String? address;
  String? stockInsured;
  double? sumInsured;
  String? interestInsured;
  String? coverage;
  String? location;
  String? construction;
  String? owner;
  String? usedAs;
  DateTime? periodFrom;
  DateTime? periodTo;
  bool isHovered = false;

  PolicyModel({
    this.id,
    this.date,
    this.bankName,
    this.policyholder,
    this.address,
    this.stockInsured,
    this.sumInsured,
    this.interestInsured,
    this.coverage,
    this.location,
    this.construction,
    this.owner,
    this.usedAs,
    this.periodFrom,
    this.periodTo,
  });

  // Factory constructor for creating a PolicyModel instance from JSON
  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      bankName: json['bankName'],
      policyholder: json['policyholder'],
      address: json['address'],
      stockInsured: json['stockInsured'],
      sumInsured: json['sumInsured']?.toDouble(), // Ensure it's a double
      interestInsured: json['interestInsured'],
      coverage: json['coverage'],
      location: json['location'],
      construction: json['construction'],
      owner: json['owner'],
      usedAs: json['usedAs'],
      periodFrom: json['periodFrom'] != null ? DateTime.tryParse(json['periodFrom']) : null,
      periodTo: json['periodTo'] != null ? DateTime.tryParse(json['periodTo']) : null,
    );
  }

  // Method for converting the PolicyModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'bankName': bankName,
      'policyholder': policyholder,
      'address': address,
      'stockInsured': stockInsured,
      'sumInsured': sumInsured,
      'interestInsured': interestInsured,
      'coverage': coverage,
      'location': location,
      'construction': construction,
      'owner': owner,
      'usedAs': usedAs,
      'periodFrom': periodFrom?.toIso8601String(),
      'periodTo': periodTo?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PolicyModel{id: $id, date: $date, bankName: $bankName, policyholder: $policyholder, sumInsured: $sumInsured}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PolicyModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
