import 'dart:developer';

class ApprovalRequestModel {
  final int id;
  final String title;
  final String type;
  final String requestedBy;
  final String date;
  String? fromDate;
  String? toDate;
  num? amount;
  final String description;
  final String attachmentUrl;
  final String category;
  final String status;

  ApprovalRequestModel({
    required this.id,
    required this.title,
    required this.type,
    required this.requestedBy,
    required this.date,
    this.fromDate,
    this.toDate,
    this.amount,
    required this.description,
    required this.attachmentUrl,
    required this.category,
    required this.status,
  });

  /// Factory constructor that maps JSON differently based on requestType.
  factory ApprovalRequestModel.fromJson(
    Map<String, dynamic> json,
    String requestType,
  ) {
    if (requestType == 'leave') {
      log('JSON:>>> ' + json.toString());
      return ApprovalRequestModel(
        id: json['id'],
        title: 'Leave Request #${json['id']}',
        type: json['leaveType'] ?? 'Leave',
        requestedBy: json['requestedBy'] ?? 'N/A',
        fromDate: json['fromDate'] ?? '',
        toDate: json['toDate'] ?? '',
        date: json['fromDate'] ?? '',
        amount: json['amount'] ?? 0,
        description: json['comments'] ?? '',
        category: requestType,
        status: json['status'] ?? 'Pending',
        attachmentUrl: json['attachmentUrl'] ?? '',
      );
    } else if (requestType == 'expense') {
      return ApprovalRequestModel(
        id: json['id'],
        title: 'Expense Request #${json['id']}',
        type: json['type'] ?? 'Expense',
        requestedBy: json['requestedBy'] ?? 'N/A',
        fromDate: json['fromDate'] ?? '',
        toDate: json['toDate'] ?? '',
        amount: json['actualAmount'] ?? 0,
        date: json['date'] ?? '',
        description: json['comments'] ?? '',
        status: json['status'] ?? 'Pending',
        category: requestType,
        attachmentUrl: json['attachmentUrl'] ?? '',
      );
    } else {
      // For loan/other, use the JSON keys directly (or your sample data)
      return ApprovalRequestModel(
        id: json['id'],
        title: json['title'] ?? '',
        type: json['type'] ?? '',
        requestedBy: json['requestedBy'] ?? '',
        date: json['date'] ?? '',
        fromDate: json['fromDate'] ?? '',
        toDate: json['toDate'] ?? '',
        amount: json['amount'] ?? 0,
        description: json['comments'] ?? '',
        status: json['status'] ?? 'Pending',
        category: requestType,
        attachmentUrl: json['attachmentUrl'] ?? '',
      );
    }
  }
}
