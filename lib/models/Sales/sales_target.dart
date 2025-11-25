class SalesTarget {
  int? id;
  double? target;
  double? achieved;
  String? period;
  int? balance;
  int? percentage;
  String? remarks;
  int? incentive;

  SalesTarget(
      {this.id,
      this.target,
      this.achieved,
      this.period,
      this.balance,
      this.percentage,
      this.remarks,
      this.incentive});

  SalesTarget.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    target = json['target'];
    achieved = json['achieved'];
    period = json['period'];
    balance = json['balance'];
    percentage = json['percentage'];
    remarks = json['remarks'];
    incentive = json['incentive'];
  }
}
