class LoanRequestModel {
  int? id;
  String? remarks;
  String? status;
  double? amount;
  double? approvedAmount;
  int? approvedById;
  String? adminRemarks;
  String? createdAt;
  String? updatedAt;
  String? approvedAt;

  LoanRequestModel(
      {this.id,
      this.remarks,
      this.status,
      this.amount,
      this.approvedAmount,
      this.approvedById,
      this.adminRemarks,
      this.createdAt,
      this.updatedAt,
      this.approvedAt});

  LoanRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    remarks = json['remarks'];
    status = json['status'];
    amount = double.parse(json['amount']);
    approvedAmount = json['approvedAmount'];
    approvedById = json['approvedById'];
    adminRemarks = json['adminRemarks'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    approvedAt = json['approvedAt'];
  }
}

class LoanRequestResponse {
  final int totalCount;
  final List<LoanRequestModel> values;

  LoanRequestResponse({
    required this.totalCount,
    required this.values,
  });

  factory LoanRequestResponse.fromJson(Map<String, dynamic> json) =>
      LoanRequestResponse(
        totalCount: json['totalCount'],
        values: (json['values'] as List)
            .map((item) => LoanRequestModel.fromJson(item))
            .toList(),
      );
}
