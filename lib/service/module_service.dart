import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';

import '../Utils/app_constants.dart';
import '../models/Settings/module_settings_model.dart';

class ModuleService {
  Future refreshModuleSettings() async {
    var moduleSettings = await apiService.getModuleSettings();
    if (moduleSettings != null) {
      setValue(appModuleSettingsPref, moduleSettings.toJson());
    }
  }

  ModuleSettingsModel? getModuleSettings() {
    var moduleSettings = getJSONAsync(appModuleSettingsPref);
    if (moduleSettings.isNotEmpty) {
      return ModuleSettingsModel.fromJson(moduleSettings);
    }
    return null;
  }

  bool isUidLoginModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isUidLoginModuleEnabled!;
  }

  bool isBioMetricVerificationModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isBiometricVerificationModuleEnabled!;
  }

  bool isBreakModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isBreakModuleEnabled!;
  }

  bool isTaskModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isTaskModuleEnabled!;
  }

  bool isNoticeModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isNoticeModuleEnabled!;
  }

  bool isDynamicFormModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isDynamicFormModuleEnabled!;
  }

  bool isExpenseModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isExpenseModuleEnabled!;
  }

  bool isLeaveModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isLeaveModuleEnabled!;
  }

  bool isDocumentModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isDocumentModuleEnabled!;
  }

  bool isDigitalIdCardModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isDigitalIdCardModuleEnabled!;
  }

  bool isSalesTargetModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isSalesTargetModuleEnabled!;
  }

  bool isPayrollModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isPayrollModuleEnabled!;
  }

  bool isChatModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isChatModuleEnabled!;
  }

  bool isLoanModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isLoanModuleEnabled!;
  }

  bool isAiChatModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isAiChatModuleEnabled!;
  }

  bool isPaymentCollectionModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isPaymentCollectionModuleEnabled!;
  }

  bool isGeofenceModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isGeofenceModuleEnabled!;
  }

  bool isIpBasedAttendanceModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isIpBasedAttendanceModuleEnabled!;
  }

  bool isClientVisitModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isClientVisitModuleEnabled!;
  }

  bool isOfflineTrackingModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isOfflineTrackingModuleEnabled!;
  }

  bool isDynamicQrCodeAttendanceEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isDynamicQrCodeAttendanceEnabled!;
  }

  bool isQrCodeAttendanceModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isQrCodeAttendanceModuleEnabled!;
  }

  bool isProductModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isProductModuleEnabled!;
  }

  bool isSosModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isSosModuleEnabled!;
  }

  bool isApprovalModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isApprovalModuleEnabled!;
  }

  bool isCalendarModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isCalendarModuleEnabled!;
  }

  bool isRecruitmentModuleEnabled() {
    var modules = getModuleSettings();
    if (modules == null) return false;
    return modules.isRecruitmentModuleEnabled!;
  }
}
