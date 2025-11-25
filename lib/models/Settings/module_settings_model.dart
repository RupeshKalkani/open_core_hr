class ModuleSettingsModel {
  bool? isProductModuleEnabled;
  bool? isTaskModuleEnabled;
  bool? isNoticeModuleEnabled;
  bool? isDynamicFormModuleEnabled;
  bool? isExpenseModuleEnabled;
  bool? isLeaveModuleEnabled;
  bool? isDocumentModuleEnabled;
  bool? isChatModuleEnabled;
  bool? isLoanModuleEnabled;
  bool? isAiChatModuleEnabled;
  bool? isPaymentCollectionModuleEnabled;
  bool? isGeofenceModuleEnabled;
  bool? isIpBasedAttendanceModuleEnabled;
  bool? isUidLoginModuleEnabled;
  bool? isClientVisitModuleEnabled;
  bool? isOfflineTrackingModuleEnabled;
  bool? isBiometricVerificationModuleEnabled;
  bool? isBreakModuleEnabled;
  bool? isDynamicQrCodeAttendanceEnabled;
  bool? isQrCodeAttendanceModuleEnabled;
  bool? isPayrollModuleEnabled;
  bool? isSalesTargetModuleEnabled;
  bool? isDigitalIdCardModuleEnabled;
  bool? isSosModuleEnabled;
  bool? isApprovalModuleEnabled;
  bool? isCalendarModuleEnabled;
  bool? isRecruitmentModuleEnabled;

  ModuleSettingsModel({
    this.isProductModuleEnabled,
    this.isTaskModuleEnabled,
    this.isNoticeModuleEnabled,
    this.isDynamicFormModuleEnabled,
    this.isExpenseModuleEnabled,
    this.isLeaveModuleEnabled,
    this.isDocumentModuleEnabled,
    this.isChatModuleEnabled,
    this.isLoanModuleEnabled,
    this.isAiChatModuleEnabled,
    this.isPaymentCollectionModuleEnabled,
    this.isGeofenceModuleEnabled,
    this.isIpBasedAttendanceModuleEnabled,
    this.isUidLoginModuleEnabled,
    this.isClientVisitModuleEnabled,
    this.isOfflineTrackingModuleEnabled,
    this.isBiometricVerificationModuleEnabled,
    this.isBreakModuleEnabled,
    this.isDynamicQrCodeAttendanceEnabled,
    this.isQrCodeAttendanceModuleEnabled,
    this.isPayrollModuleEnabled,
    this.isSalesTargetModuleEnabled,
    this.isDigitalIdCardModuleEnabled,
    this.isSosModuleEnabled,
    this.isApprovalModuleEnabled,
    this.isCalendarModuleEnabled,
    this.isRecruitmentModuleEnabled,
  });

  ModuleSettingsModel.fromJson(Map<String, dynamic> json) {
    isProductModuleEnabled = json['isProductModuleEnabled'];
    isTaskModuleEnabled = json['isTaskModuleEnabled'];
    isNoticeModuleEnabled = json['isNoticeModuleEnabled'];
    isDynamicFormModuleEnabled = json['isDynamicFormModuleEnabled'];
    isExpenseModuleEnabled = json['isExpenseModuleEnabled'];
    isLeaveModuleEnabled = json['isLeaveModuleEnabled'];
    isDocumentModuleEnabled = json['isDocumentModuleEnabled'];
    isChatModuleEnabled = json['isChatModuleEnabled'];
    isLoanModuleEnabled = json['isLoanModuleEnabled'];
    isAiChatModuleEnabled = json['isAiChatModuleEnabled'];
    isPaymentCollectionModuleEnabled = json['isPaymentCollectionModuleEnabled'];
    isGeofenceModuleEnabled = json['isGeofenceModuleEnabled'];
    isIpBasedAttendanceModuleEnabled = json['isIpBasedAttendanceModuleEnabled'];
    isUidLoginModuleEnabled = json['isUidLoginModuleEnabled'];
    isClientVisitModuleEnabled = json['isClientVisitModuleEnabled'];
    isOfflineTrackingModuleEnabled = json['isOfflineTrackingModuleEnabled'];
    isBiometricVerificationModuleEnabled =
        json['isBiometricVerificationModuleEnabled'];
    isBreakModuleEnabled = json['isBreakModuleEnabled'];
    isDynamicQrCodeAttendanceEnabled = json['isDynamicQrCodeAttendanceEnabled'];
    isQrCodeAttendanceModuleEnabled = json['isQrCodeAttendanceModuleEnabled'];
    isPayrollModuleEnabled = json['isPayrollModuleEnabled'];
    isSalesTargetModuleEnabled = json['isSalesTargetModuleEnabled'];
    isDigitalIdCardModuleEnabled = json['isDigitalIdCardModuleEnabled'];
    isSosModuleEnabled = json['isSosModuleEnabled'];
    isApprovalModuleEnabled = json['isApprovalModuleEnabled'];
    isCalendarModuleEnabled = json['isCalendarModuleEnabled'] ?? false;
    isRecruitmentModuleEnabled = json['isRecruitmentModuleEnabled'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isProductModuleEnabled'] = isProductModuleEnabled;
    data['isTaskModuleEnabled'] = isTaskModuleEnabled;
    data['isNoticeModuleEnabled'] = isNoticeModuleEnabled;
    data['isDynamicFormModuleEnabled'] = isDynamicFormModuleEnabled;
    data['isExpenseModuleEnabled'] = isExpenseModuleEnabled;
    data['isLeaveModuleEnabled'] = isLeaveModuleEnabled;
    data['isDocumentModuleEnabled'] = isDocumentModuleEnabled;
    data['isChatModuleEnabled'] = isChatModuleEnabled;
    data['isLoanModuleEnabled'] = isLoanModuleEnabled;
    data['isAiChatModuleEnabled'] = isAiChatModuleEnabled;
    data['isPaymentCollectionModuleEnabled'] = isPaymentCollectionModuleEnabled;
    data['isGeofenceModuleEnabled'] = isGeofenceModuleEnabled;
    data['isIpBasedAttendanceModuleEnabled'] = isIpBasedAttendanceModuleEnabled;
    data['isUidLoginModuleEnabled'] = isUidLoginModuleEnabled;
    data['isClientVisitModuleEnabled'] = isClientVisitModuleEnabled;
    data['isOfflineTrackingModuleEnabled'] = isOfflineTrackingModuleEnabled;
    data['isBiometricVerificationModuleEnabled'] =
        isBiometricVerificationModuleEnabled;
    data['isBreakModuleEnabled'] = isBreakModuleEnabled;
    data['isDynamicQrCodeAttendanceEnabled'] = isDynamicQrCodeAttendanceEnabled;
    data['isQrCodeAttendanceModuleEnabled'] = isQrCodeAttendanceModuleEnabled;
    data['isPayrollModuleEnabled'] = isPayrollModuleEnabled;
    data['isSalesTargetModuleEnabled'] = isSalesTargetModuleEnabled;
    data['isDigitalIdCardModuleEnabled'] = isDigitalIdCardModuleEnabled;
    data['isSosModuleEnabled'] = isSosModuleEnabled;
    data['isApprovalModuleEnabled'] = isApprovalModuleEnabled;
    data['isCalendarModuleEnabled'] = isCalendarModuleEnabled;
    data['isRecruitmentModuleEnabled'] = isRecruitmentModuleEnabled;
    return data;
  }
}
