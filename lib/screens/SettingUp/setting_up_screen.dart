import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_constants.dart';
import '../../Utils/app_widgets.dart';
import '../../main.dart';
import '../Device/device_verification_screen.dart';
import '../Login/LoginScreen.dart';
import '../navigation_screen.dart';

class SettingUpScreen extends StatefulWidget {
  const SettingUpScreen({super.key});

  @override
  State<SettingUpScreen> createState() => _SettingUpScreenState();
}

class _SettingUpScreenState extends State<SettingUpScreen> {
  bool isDeviceVerified = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    appStore.isDemoMode = await apiService.checkDemoMode();
    await sharedHelper.setAppVersionToPref();
    await sharedHelper.refreshAppSettings();
    await moduleService.refreshModuleSettings();

    await checkDeviceByUid();

    if (getBoolAsync(isLoggedInPref)) {
      if (getBoolAsync(isDeviceVerifiedPref)) {
        if (!mounted) return;
        NavigationScreen().launch(context, isNewTask: true);
      } else {
        if (!mounted) return;
        const DeviceVerificationScreen().launch(context, isNewTask: true);
      }
    } else {
      if (!mounted) return;
      LoginScreen(
        isDeviceVerified: isDeviceVerified,
      ).launch(context, isNewTask: true);
    }
  }

  Future checkDeviceByUid() async {
    if (!moduleService.isUidLoginModuleEnabled()) return;
    try {
      var deviceId = await sharedHelper.getDeviceId();
      if (!deviceId.isEmptyOrNull) {
        isDeviceVerified = await apiService.checkDeviceUid(deviceId!);
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblSettingUp, hideBack: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lottie Animation
            SizedBox(
              height: 200,
              child: Lottie.asset(
                'assets/animations/system-setting.json',
                repeat: false,
                fit: BoxFit.contain,
              ),
            ),
            24.height, // Adds spacing
            Text(
              '${language.lblSettingThingsUpPleaseWait}...\n${language.lblThisWillOnlyTakeAFewSeconds}.',
              style: boldTextStyle(size: 18),
              textAlign: TextAlign.center,
            ),
            16.height,
            loadingWidgetMaker(),
          ],
        ),
      ),
    );
  }
}
