import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/app_constants.dart';

part 'DeviceStore.g.dart';

class DeviceStore = DeviceStoreBase with _$DeviceStore;

abstract class DeviceStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  DeviceVerificationStatus deviceVerificationStatus =
      DeviceVerificationStatus.verifying;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @action
  Future init() async {
    deviceVerificationStatus = DeviceVerificationStatus.verifying;
    await checkDevice();
  }

  Future checkDevice() async {
    await Future.delayed(const Duration(seconds: 2));
    var device = await sharedHelper.getDeviceId();
    var result = await apiService.checkDevice(
        platformName().toLowerCase(), device.toString());
    if (result == null) {
      deviceVerificationStatus = DeviceVerificationStatus.failed;
      toast(language.lblUnableToCheckDeviceStatus);
    } else if (result.toLowerCase() == 'device verified successfully') {
      deviceVerificationStatus = DeviceVerificationStatus.verified;
      await setValue(isDeviceVerifiedPref, true);
      sharedHelper.login();
    } else if (result.toLowerCase() ==
            'this account is already registered with another device' ||
        result.toLowerCase() ==
            'this device is already registered with another user') {
      deviceVerificationStatus = DeviceVerificationStatus.alreadyRegistered;
      await setValue(isDeviceVerifiedPref, true);
      sharedHelper.login();
    } else if (result.toLowerCase() == 'not registered' ||
        result.toLowerCase() == 'device verification is disabled') {
      deviceVerificationStatus = DeviceVerificationStatus.notRegistered;
    } else {
      deviceVerificationStatus = DeviceVerificationStatus.failed;
      toast(result);
    }
  }

  Future<bool> registerDevice() async {
    isLoading = true;

    var deviceId = await sharedHelper.getDeviceId();
    if (deviceId == null) {
      toast('Unable to get device id');
      isLoading = false;
      return false;
    }

    try {
      var request = <String, Object>{};
      if (isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        request = {
          "deviceType": "ios",
          "deviceId": deviceId,
          "brand": 'Apple',
          "board": build.systemName ?? "",
          "sdkVersion": build.systemVersion.toString(),
          "model": build.model ?? "",
          "appVersion": build.systemVersion.toString()
        };
      } else {
        AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
        request = {
          "deviceType": "android",
          "deviceId": deviceId,
          "brand": build.brand,
          "board": build.board,
          "sdkVersion": build.version.sdkInt.toString(),
          "model": build.model,
          "appVersion": await sharedHelper.setAppVersionToPref(),
        };
      }

      var result = await apiService.registerDevice(request);
      if (result) {
        toast(language.lblDeviceSuccessfullyRegistered);
        sharedHelper.login();
        await setValue(isDeviceVerifiedPref, true);
        isLoading = false;
        return true;
      } else {
        toast(language.lblUnableToRegisterDevice);
      }
    } catch (e) {
      log(e.toString());
    }
    isLoading = false;
    return false;
  }
}

enum DeviceVerificationStatus {
  pending,
  verifying,
  verified,
  alreadyRegistered,
  notRegistered,
  failed
}
