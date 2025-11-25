class PayslipModel {
  int? id;
  String? code;
  num? basicSalary;
  num? totalDeductions;
  num? totalBenefits;
  num? netSalary;
  num? totalWorkedDays;
  num? totalAbsentDays;
  num? totalLeaveDays;
  num? totalLateDays;
  num? totalEarlyCheckoutDays;
  num? totalOvertimeDays;
  num? totalHolidays;
  num? totalWeekends;
  num? totalWorkingDays;
  List<PayrollAdjustment>? payrollAdjustments;
  String? status;
  String? payrollPeriod;
  String? createdAt;

  PayslipModel(
      {this.id,
      this.code,
      this.basicSalary,
      this.totalDeductions,
      this.totalBenefits,
      this.netSalary,
      this.totalWorkedDays,
      this.totalAbsentDays,
      this.totalLeaveDays,
      this.totalLateDays,
      this.totalEarlyCheckoutDays,
      this.totalOvertimeDays,
      this.totalHolidays,
      this.totalWeekends,
      this.totalWorkingDays,
      required this.payrollAdjustments,
      this.status,
      this.payrollPeriod,
      this.createdAt});

  //Deserialize the data
  PayslipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    basicSalary = json['basicSalary'];
    totalDeductions = json['totalDeductions'];
    totalBenefits = json['totalBenefits'];
    netSalary = json['netSalary'];
    totalWorkedDays = json['totalWorkedDays'];
    totalAbsentDays = json['totalAbsentDays'];
    totalLeaveDays = json['totalLeaveDays'];
    totalLateDays = json['totalLateDays'];
    totalEarlyCheckoutDays = json['totalEarlyCheckoutDays'];
    totalOvertimeDays = json['totalOvertimeDays'];
    totalHolidays = json['totalHolidays'];
    totalWeekends = json['totalWeekends'];
    totalWorkingDays = json['totalWorkingDays'];
    if (json['payrollAdjustments'] != null) {
      payrollAdjustments = <PayrollAdjustment>[];
      json['payrollAdjustments'].forEach((v) {
        payrollAdjustments!.add(PayrollAdjustment.fromJson(v));
      });
    }
    status = json['status'];
    payrollPeriod = json['payrollPeriod'];
    createdAt = json['createdAt'];
  }

  //Serialize the data
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['code'] = code;
    data['basicSalary'] = basicSalary;
    data['totalDeductions'] = totalDeductions;
    data['totalBenefits'] = totalBenefits;
    data['netSalary'] = netSalary;
    data['totalWorkedDays'] = totalWorkedDays;
    data['totalAbsentDays'] = totalAbsentDays;
    data['totalLeaveDays'] = totalLeaveDays;
    data['totalLateDays'] = totalLateDays;
    data['totalEarlyCheckoutDays'] = totalEarlyCheckoutDays;
    data['totalOvertimeDays'] = totalOvertimeDays;
    data['totalHolidays'] = totalHolidays;
    data['totalWeekends'] = totalWeekends;
    data['totalWorkingDays'] = totalWorkingDays;
    data['payrollAdjustments'] = payrollAdjustments != null
        ? payrollAdjustments!.map((v) => v?.toJson()).toList()
        : null;
    data['status'] = status;
    data['payrollPeriod'] = payrollPeriod;
    data['createdAt'] = createdAt;
    return data;
  }
}

class PayrollAdjustment {
  String? name;
  String? code;
  int? percentage;
  int? amount;
  String? type;

  PayrollAdjustment(
      {this.name, this.code, this.percentage, this.amount, this.type});

  PayrollAdjustment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    percentage = json['percentage'];
    amount = json['amount'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['code'] = code;
    data['percentage'] = percentage;
    data['amount'] = amount;
    data['type'] = type;
    return data;
  }
}
