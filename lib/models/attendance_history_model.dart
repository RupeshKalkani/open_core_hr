class AttendanceHistoryModel {
  String? checkInTime;
  String? checkOutTime;
  num? totalHours;
  String? date;
  String? shift;
  String? status;
  String? lateReason;
  String? earlyCheckoutReason;
  int? visitCount;
  int? ordersCount;
  int? formsSubmissionCount;
  num? distanceTravelled;

  AttendanceHistoryModel(
      {this.checkInTime,
      this.checkOutTime,
      this.totalHours,
      this.date,
      this.shift,
      this.status,
      this.lateReason,
      this.earlyCheckoutReason,
      this.visitCount,
      this.ordersCount,
      this.formsSubmissionCount,
      this.distanceTravelled});

  AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    checkInTime = json['checkInTime'];
    checkOutTime = json['checkOutTime'];
    totalHours = json['totalHours'];
    date = json['date'];
    shift = json['shift'];
    status = json['status'];
    lateReason = json['lateReason'];
    earlyCheckoutReason = json['earlyCheckoutReason'];
    visitCount = json['visitCount'];
    ordersCount = json['ordersCount'];
    formsSubmissionCount = json['formsSubmissionCount'];
    distanceTravelled = json['distanceTravelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checkInTime'] = checkInTime;
    data['checkOutTime'] = checkOutTime;
    data['totalHours'] = totalHours;
    data['date'] = date;
    data['shift'] = shift;
    data['status'] = status;
    data['lateReason'] = lateReason;
    data['earlyCheckoutReason'] = earlyCheckoutReason;
    data['visitCount'] = visitCount;
    data['ordersCount'] = ordersCount;
    data['formsSubmissionCount'] = formsSubmissionCount;
    data['distanceTravelled'] = distanceTravelled;
    return data;
  }
}

class AttendanceHistoryResponse {
  int? totalCount;
  List<AttendanceHistoryModel>? values;

  AttendanceHistoryResponse({this.totalCount, this.values});

  AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['values'] != null) {
      values = <AttendanceHistoryModel>[];
      json['values'].forEach((v) {
        values!.add(AttendanceHistoryModel.fromJson(v));
      });
    }
  }
}
