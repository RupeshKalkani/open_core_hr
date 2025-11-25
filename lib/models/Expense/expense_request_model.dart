class ExpenseRequestModel {
  int? id;
  String? date;
  String? type;
  num? actualAmount;
  num? approvedAmount;
  String? status;
  String? createdAt;
  String? approvedBy;
  String? comments;
  String? attachmentUrl;
  String? requestedBy;

  ExpenseRequestModel({
    this.id,
    this.date,
    this.type,
    this.actualAmount,
    this.approvedAmount,
    this.status,
    this.createdAt,
    this.approvedBy,
    this.comments,
    this.attachmentUrl,
    this.requestedBy,
  });

  ExpenseRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    type = json['type'];
    actualAmount = json['actualAmount'];
    approvedAmount = json['approvedAmount'];
    status = json['status'];
    createdAt = json['createdAt'];
    approvedBy = json['approvedBy'];
    comments = json['comments'];
    requestedBy = json['requestedBy'];
    attachmentUrl = json['attachmentUrl'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['type'] = type;
    data['actualAmount'] = actualAmount;
    data['approvedAmount'] = approvedAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['approvedBy'] = approvedBy;
    data['comments'] = comments;
    data['requestedBy'] = requestedBy;
    data['attachmentUrl'] = attachmentUrl ?? '';
    return data;
  }
}

class ExpenseRequestResponse {
  final int totalCount;
  final List<ExpenseRequestModel> values;

  ExpenseRequestResponse({required this.totalCount, required this.values});

  factory ExpenseRequestResponse.fromJson(Map<String, dynamic> json) =>
      ExpenseRequestResponse(
        totalCount: json['totalCount'],
        values: (json['values'] as List)
            .map((item) => ExpenseRequestModel.fromJson(item))
            .toList(),
      );
}
