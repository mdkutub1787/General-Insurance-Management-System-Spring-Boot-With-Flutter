class MarinePolicyModel {
  int? id;
  DateTime? date;
  String? bankName;
  String? policyholder;
  String? address;
  String? voyageFrom;
  String? voyageTo;
  String? via;
  String? stockItem;
  double? sumInsuredUsd;
  double? usdRate;
  double? sumInsured;
  String? coverage;

  MarinePolicyModel({
    this.id,
    this.date,
    this.bankName,
    this.policyholder,
    this.address,
    this.voyageFrom,
    this.voyageTo,
    this.via,
    this.stockItem,
    this.sumInsuredUsd,
    this.usdRate,
    this.sumInsured,
    this.coverage,
  });

  MarinePolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'] != null ? DateTime.tryParse(json['date']) : null;
    bankName = json['bankName'];
    policyholder = json['policyholder'];
    address = json['address'];
    voyageFrom = json['voyageFrom'];
    voyageTo = json['voyageTo'];
    via = json['via'];
    stockItem = json['stockItem'];
    sumInsuredUsd = json['sumInsuredUsd']?.toDouble();
    usdRate = json['usdRate']?.toDouble();
    sumInsured = json['sumInsured']?.toDouble();
    coverage = json['coverage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date?.toIso8601String();
    data['bankName'] = bankName;
    data['policyholder'] = policyholder;
    data['address'] = address;
    data['voyageFrom'] = voyageFrom;
    data['voyageTo'] = voyageTo;
    data['via'] = via;
    data['stockItem'] = stockItem;
    data['sumInsuredUsd'] = sumInsuredUsd;
    data['usdRate'] = usdRate;
    data['sumInsured'] = sumInsured;
    data['coverage'] = coverage;
    return data;
  }
}
