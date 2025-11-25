import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_device_unique_id/flutter_device_unique_id_platform_interface.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/OnBoarding/my_onboarding_screen.dart';
import 'package:open_core_hr/models/Settings/app_settings_model.dart';
import 'package:open_core_hr/screens/Login/LoginScreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vibration/vibration.dart';

import '../main.dart';
import '../screens/Device/device_verification_screen.dart';
import '../screens/org_choose_screen.dart';
import '../utils/app_constants.dart';

class SharedHelper {
  void vibrate() async {
    var result = await Vibration.hasVibrator();
    if (result ?? false) {
      Vibration.vibrate();
    }
  }

  Future<String> setAppVersionToPref() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    var versionString = '$version build($buildNumber)';
    setValue(appVersionPref, versionString);
    return versionString;
  }

  String getFullName() {
    return '${getStringAsync(firstNamePref)} ${getStringAsync(lastNamePref)}';
  }

  String getPhoneNumber() {
    return getStringAsync(phoneNumberPref);
  }

  String getProfileImage() {
    return getStringAsync(avatarPref);
  }

  String getDesignation() {
    var designation = getStringAsync(designationPref);
    return designation == '' ? 'N/A' : designation;
  }

  bool hasProfileImage() {
    return getStringAsync(avatarPref) != '';
  }

  String getEmployeeCode() {
    var code = getStringAsync(employeeCodePref);
    return code == '' ? 'N/A' : code;
  }

  String getEmail() {
    return getStringAsync(emailPref);
  }

  String getCompanyAddress() {
    return getStringAsync(appCompanyAddressPref);
  }

  String getCompanyName() {
    return getStringAsync(appCompanyNamePref);
  }

  void logout(BuildContext context) async {
    clearSharedPref();
    trackingService.stopTrackingService();
    toast('Logged out successfully');
    if (isSaaSMode) {
      OrgChooseScreen().launch(context, isNewTask: true);
    } else {
      LoginScreen().launch(context, isNewTask: true);
    }
  }

  void logoutAlt() async {
    clearSharedPref();
    trackingService.stopTrackingService();
    toast('Logged out successfully');
  }

  Future<String?> getDeviceId() async {
    String? uuid;
    try {
      uuid = await FlutterDevicePlatform.instance.getUniqueId();
    } catch (e) {
      uuid = null;
    }

    return uuid;
  }

  Future<bool> validateDevice() async {
    var deviceId = await getDeviceId();
    if (deviceId == null) {
      toast('Unable to get device id');
      return false;
    }

    var result = await apiService.validateDevice(
        platformName().toLowerCase(), (await getDeviceId()).toString());
    return result;
  }

  void setAppSettings(AppSettingsModel settings) {
    setValue(appVersionPref, settings.appVersion);
    setValue(privacyPolicyUrlPref, settings.privacyPolicyUrl);
    setValue(
        locationUpdateIntervalTypePref, settings.locationUpdateIntervalType);
    setValue(locationUpdateIntervalPref, settings.locationUpdateInterval);
    setValue(distanceFilterPref, settings.locationDistanceFilter);
    setValue(appCurrencySymbolPref, settings.currencySymbol);
    setValue(appDistanceUnitPref, settings.distanceUnit);
    setValue(appCountryPhoneCodePref, settings.countryPhoneCode);

    setValue(appSupportEmailPref, settings.supportEmail);
    setValue(appSupportPhonePref, settings.supportPhone);
    setValue(appSupportWhatsAppPref, settings.supportWhatsapp);
    setValue(appWebsiteUrlPref, settings.website);
    setValue(appCompanyLogoPref, settings.companyLogo);

    //Company
    setValue(appCompanyNamePref, settings.companyName);
    setValue(appCompanyAddressPref, settings.companyAddress);
  }

  int getUpdateInterval() {
    var interval = getIntAsync(locationUpdateIntervalPref);
    return interval == 0 ? 30 : interval;
  }

  bool isSettingsRefreshed() {
    return getBoolAsync(isSettingsRefreshedPref);
  }

  String getUserInitials() {
    return getStringAsync(firstNamePref).substring(0, 1).toUpperCase() +
        getStringAsync(lastNamePref).substring(0, 1).toUpperCase();
  }

  Duration getUpdateIntervalDuration() {
    try {
      var interval = getUpdateInterval();

      var type = getStringAsync(locationUpdateIntervalTypePref);
      log('Location update interval value is $interval type is $type');
      if (type == '') {
        return Duration(seconds: interval);
      } else {
        return type == 's'
            ? Duration(seconds: interval)
            : Duration(minutes: interval);
      }
    } catch (e) {
      log('Error getting update interval duration $e : using default 5 seconds');
      return Duration(seconds: 5);
    }
  }

  int getDistanceFilter() {
    try {
      return getIntAsync(distanceFilterPref);
    } catch (e) {
      log('Error getting distance filter $e : using default 2 meters');
      return 2;
    }
  }

  Future refreshAppSettings() async {
    var appSettings = await apiService.getAppSettings();
    if (appSettings != null) {
      setAppSettings(appSettings);
      setValue(isSettingsRefreshedPref, true);
    }
    if (getBoolAsync(isLoggedInPref)) {
      await refreshUserData();
    }
  }

  Future refreshUserData() async {
    var user = await apiService.me();
    if (user != null) {
      await setValue(firstNamePref, user.firstName);
      await setValue(lastNamePref, user.lastName);
      await setValue(genderPref, user.gender);
      if (!user.avatar.isEmptyOrNull) {
        await setValue(avatarPref, user.avatar ?? '');
      }
      await setValue(locationActivityTrackingEnabledPref,
          user.locationActivityTrackingEnabled);
      await setValue(employeeCodePref, user.employeeCode);
      await setValue(approverPref, user.isApprover);
      await setValue(addressPref, user.address);
      await setValue(phoneNumberPref, user.phoneNumber);
      await setValue(alternateNumberPref, user.alternateNumber);
      await setValue(statusPref, user.status);
      await setValue(emailPref, user.email);
      await setValue(designationPref, user.designation);
    }
  }

  void routeBasedOnStatus(BuildContext context, String status) {
    sharedHelper.refreshAppSettings();

    if (status == 'onboarding') {
      toast('Please complete the onboarding process');
      const MyOnboardingScreen().launch(context, isNewTask: true);
      return;
    } else if (status == 'active') {
      const DeviceVerificationScreen().launch(context, isNewTask: true);
    } else {
      toast('Unknown status. Please contact your administrator.');
    }
  }

  bool isAccountActive() {
    var status = getStringAsync(statusPref);
    return status == 'active';
  }

  bool isAccountOnboarding() {
    var status = getStringAsync(statusPref);
    return status == 'onboarding';
  }

  void login() async {
    addFirebaseToken();
  }

  void addFirebaseToken() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging
        .getToken()
        .then((value) => apiService.addFirebaseToken(platformName(), value!));
    messaging.subscribeToTopic('announcement');
    messaging.subscribeToTopic('chat');
    messaging.subscribeToTopic('attendance');
    messaging.subscribeToTopic('general');

    setValue(notiAnnouncementPref, true);
    setValue(notiChatPref, true);
    setValue(notiAttendancePref, true);
    setValue(notiGeneralPref, true);
  }
}
