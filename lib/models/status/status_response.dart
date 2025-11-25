class StatusResponse {
  String? status = 'new';
  String? checkInAt;
  String? checkOutAt;
  String? userStatus;
  String? shiftStartAt;
  String? shiftEndAt;
  bool? isLate;
  bool? isOnLeave;
  bool? isOnBreak;
  String? breakStartedAt;
  num? travelledDistance;
  String? attendanceType;
  num? trackedHours;
  bool? isSiteEmployee;
  String? siteName;
  String? siteAttendanceType;
  String? deviceStatus;

  StatusResponse({
    this.status,
    this.checkInAt,
    this.checkOutAt,
    this.userStatus,
    this.shiftStartAt,
    this.shiftEndAt,
    this.isLate,
    this.isOnLeave,
    this.isOnBreak,
    this.breakStartedAt,
    this.travelledDistance,
    this.trackedHours,
    this.attendanceType,
    this.isSiteEmployee,
    this.siteName,
    this.siteAttendanceType,
    this.deviceStatus,
  });

  StatusResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    checkInAt = json['checkInAt'];
    checkOutAt = json['checkOutAt'];
    userStatus = json['userStatus'];
    shiftStartAt = json['shiftStartTime'];
    shiftEndAt = json['shiftEndTime'];
    isLate = json['isLate'];
    isOnLeave = json['isOnLeave'];
    isOnBreak = json['isOnBreak'];
    breakStartedAt = json['breakStartedAt'];
    travelledDistance = json['travelledDistance'];
    trackedHours = json['trackedHours'];
    attendanceType = json['attendanceType'];
    isSiteEmployee = json['isSiteEmployee'];
    siteName = json['siteName'];
    siteAttendanceType = json['siteAttendanceType'];
    deviceStatus = json['deviceStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['checkInAt'] = checkInAt;
    data['checkOutAt'] = checkOutAt;
    data['userStatus'] = userStatus;
    data['shiftStartTime'] = shiftStartAt;
    data['shiftEndTime'] = shiftEndAt;
    data['isLate'] = isLate;
    data['isOnLeave'] = isOnLeave;
    data['isOnBreak'] = isOnBreak;
    data['breakStartedAt'] = breakStartedAt;
    data['travelledDistance'] = travelledDistance;
    data['trackedHours'] = trackedHours;
    data['attendanceType'] = attendanceType;
    data['isSiteEmployee'] = isSiteEmployee;
    data['siteName'] = siteName;
    data['siteAttendanceType'] = siteAttendanceType;
    data['deviceStatus'] = deviceStatus;
    return data;
  }
}
