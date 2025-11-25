class AppSettingsModel {
  String? appVersion;
  String? locationUpdateIntervalType;
  num? locationUpdateInterval;
  int? locationDistanceFilter;
  String? currency;
  String? currencySymbol;
  String? privacyPolicyUrl;
  String? distanceUnit;
  String? countryPhoneCode;
  String? supportEmail;
  String? supportPhone;
  String? supportWhatsapp;
  String? website;
  String? companyName;
  String? companyAddress;
  String? companyLogo;

  AppSettingsModel({
    this.appVersion,
    this.locationUpdateIntervalType,
    this.locationUpdateInterval,
    this.locationDistanceFilter,
    this.currency,
    this.currencySymbol,
    this.distanceUnit,
    this.privacyPolicyUrl,
    this.countryPhoneCode,
    this.supportEmail,
    this.supportPhone,
    this.supportWhatsapp,
    this.website,
    this.companyName,
    this.companyAddress,
    this.companyLogo,
  });

  AppSettingsModel.fromJson(Map<String, dynamic> json) {
    appVersion = json['appVersion'];
    locationUpdateIntervalType = json['locationUpdateIntervalType'];
    locationUpdateInterval = json['locationUpdateInterval'];
    locationDistanceFilter = json['locationDistanceFilter'];
    currency = json['currency'];
    currencySymbol = json['currencySymbol'];
    privacyPolicyUrl = json['privacyPolicyUrl'];
    distanceUnit = json['distanceUnit'];
    countryPhoneCode = json['countryPhoneCode'];
    supportEmail = json['supportEmail'];
    supportPhone = json['supportPhone'];
    supportWhatsapp = json['supportWhatsapp'];
    website = json['website'];
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    companyLogo = json['companyLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appVersion'] = appVersion;
    data['locationUpdateIntervalType'] = locationUpdateIntervalType;
    data['locationUpdateInterval'] = locationUpdateInterval;
    data['privacyPolicyUrl'] = privacyPolicyUrl;
    data['currency'] = currency;
    data['currencySymbol'] = currencySymbol;
    data['distanceUnit'] = distanceUnit;
    data['countryPhoneCode'] = countryPhoneCode;
    data['supportEmail'] = supportEmail;
    data['supportPhone'] = supportPhone;
    data['supportWhatsapp'] = supportWhatsapp;
    data['website'] = website;
    data['companyName'] = companyName;
    data['companyAddress'] = companyAddress;
    data['companyLogo'] = companyLogo;
    return data;
  }
}
