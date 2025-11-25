class LeaveRequestModel {
  int? id;
  String? fromDate;
  String? toDate;
  String? leaveType;
  String? comments;
  String? status;
  String? attachmentUrl;
  String? createdOn;
  String? approvedOn;
  String? approvedBy;
  String? requestedBy;

  LeaveRequestModel({
    id,
    fromDate,
    toDate,
    leaveType,
    comments,
    status,
    image,
    createdOn,
    approvedOn,
    approvedBy,
    requestedBy,
  });

  LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    leaveType = json['leaveType'];
    comments = json['comments'];
    status = json['status'];
    attachmentUrl = json['attachmentUrl'];
    createdOn = json['createdOn'];
    approvedOn = json['approvedOn'];
    approvedBy = json['approvedBy'];
    requestedBy = json['requestedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['leaveType'] = leaveType;
    data['comments'] = comments;
    data['status'] = status;
    data['attachmentUrl'] = attachmentUrl;
    data['createdOn'] = createdOn;
    data['approvedOn'] = approvedOn;
    data['approvedBy'] = approvedBy;
    data['requestedBy'] = requestedBy;
    return data;
  }
}

class LeaveRequestResponse {
  final int totalCount;
  final List<LeaveRequestModel> values;

  LeaveRequestResponse({required this.totalCount, required this.values});

  factory LeaveRequestResponse.fromJson(Map<String, dynamic> json) =>
      LeaveRequestResponse(
        totalCount: json['totalCount'],
        values: (json['values'] as List)
            .map((item) => LeaveRequestModel.fromJson(item))
            .toList(),
      );
}
