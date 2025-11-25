class SalesTargetModel {
  int? id;
  String? targetType;
  int? period;
  num? targetAmount;
  num? achievedAmount;
  num? remainingAmount;
  num? incentiveAmount;
  num? incentivePercentage;
  String? incentiveType;
  String? status;
  String? description;
  String? createdAt;

  SalesTargetModel(
      {this.id,
      this.targetType,
      this.period,
      this.targetAmount,
      this.achievedAmount,
      this.remainingAmount,
      this.incentiveAmount,
      this.incentivePercentage,
      this.incentiveType,
      this.status,
      this.description,
      this.createdAt});

  double get progress => achievedAmount! / targetAmount!;

  SalesTargetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    targetType = json['targetType'];
    period = json['period'];
    targetAmount = json['targetAmount'];
    achievedAmount = json['achievedAmount'];
    remainingAmount = json['remainingAmount'];
    incentiveAmount = json['incentiveAmount'];
    incentivePercentage = json['incentivePercentage'];
    incentiveType = json['incentiveType'];
    status = json['status'];
    description = json['description'];
    createdAt = json['createdAt'];
  }
}
