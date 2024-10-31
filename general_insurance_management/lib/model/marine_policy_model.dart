class MarinePolicyModel {
  int? id;
  String? date;
  String? bankName;
  String? policyholder;
  String? address;
  String? voyageFrom;
  String? voyageTo;
  String? via;
  String? stockItem;
  int? sumInsuredUsd;
  double? usdRate;
  int? sumInsured;
  String? coverage;

  MarinePolicyModel(
      {this.id,
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
        this.coverage});

  MarinePolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    bankName = json['bankName'];
    policyholder = json['policyholder'];
    address = json['address'];
    voyageFrom = json['voyageFrom'];
    voyageTo = json['voyageTo'];
    via = json['via'];
    stockItem = json['stockItem'];
    sumInsuredUsd = json['sumInsuredUsd'];
    usdRate = json['usdRate'];
    sumInsured = json['sumInsured'];
    coverage = json['coverage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['bankName'] = this.bankName;
    data['policyholder'] = this.policyholder;
    data['address'] = this.address;
    data['voyageFrom'] = this.voyageFrom;
    data['voyageTo'] = this.voyageTo;
    data['via'] = this.via;
    data['stockItem'] = this.stockItem;
    data['sumInsuredUsd'] = this.sumInsuredUsd;
    data['usdRate'] = this.usdRate;
    data['sumInsured'] = this.sumInsured;
    data['coverage'] = this.coverage;
    return data;
  }
}