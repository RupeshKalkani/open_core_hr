class DocumentRequestModel {
  int? id;
  int? documentTypeId;
  String? documentTypeName;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? approverId;
  String? approverName;
  String? approverComment;
  String? approvedOn;
  String? documentUrl;

  DocumentRequestModel(
      {this.id,
      this.documentTypeId,
      this.documentTypeName,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.approverId,
      this.approverName,
      this.approverComment,
      this.approvedOn,
      this.documentUrl});

  DocumentRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentTypeId = json['documentTypeId'];
    documentTypeName = json['documentTypeName'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    approverId = json['approverId'];
    approverName = json['approverName'];
    approverComment = json['approverComment'];
    approvedOn = json['approvedOn'];
    documentUrl = json['documentUrl'];
  }
}

class DocumentRequestResponse {
  final int totalCount;
  final List<DocumentRequestModel> values;

  DocumentRequestResponse({
    required this.totalCount,
    required this.values,
  });

  factory DocumentRequestResponse.fromJson(Map<String, dynamic> json) =>
      DocumentRequestResponse(
        totalCount: json['totalCount'],
        values: (json['values'] as List)
            .map((item) => DocumentRequestModel.fromJson(item))
            .toList(),
      );
}
