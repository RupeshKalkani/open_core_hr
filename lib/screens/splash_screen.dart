import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/OnBoarding/my_onboarding_screen.dart';
import 'package:open_core_hr/screens/Device/device_verification_screen.dart';
import 'package:open_core_hr/screens/OfflineMode/offline_mode_screen.dart';
import 'package:open_core_hr/screens/SettingUp/setting_up_screen.dart';
import 'package:open_core_hr/screens/navigation_screen.dart';
import 'package:open_core_hr/screens/server_unreachable_screen.dart';
import 'package:open_core_hr/utils/app_images.dart';
import 'package:open_core_hr/utils/app_widgets.dart';

import '../main.dart';
import '../utils/app_constants.dart';
import 'org_choose_screen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());

      bool isAnyConnection = connectivityResult.any((element) =>
          element == ConnectivityResult.mobile ||
          element == ConnectivityResult.wifi);

      if (isAnyConnection) {
        if (getBoolAsync(isLoggedInPref)) {
          await sharedHelper.refreshAppSettings();
          await moduleService.refreshModuleSettings();

          if (getBoolAsync(isDeviceVerifiedPref)) {
            FirebaseCrashlytics.instance.setUserIdentifier(
              getStringAsync(
                sharedHelper.getEmail(),
              ),
            );

            if (!mounted) return;
            if (sharedHelper.isAccountOnboarding()) {
              if (!mounted) return;
              toast('Please complete the onboarding process');
              MyOnboardingScreen().launch(context, isNewTask: true);
              return;
            }
            NavigationScreen().launch(context, isNewTask: true);
          } else {
            if (!mounted) return;
            if (sharedHelper.isAccountOnboarding()) {
              if (!mounted) return;
              toast('Please complete the onboarding process');
              MyOnboardingScreen().launch(context, isNewTask: true);
              return;
            }
            const DeviceVerificationScreen().launch(context, isNewTask: true);
          }
        } else {
          if (!mounted) return;
          if (isSaaSMode) {
            const OrgChooseScreen().launch(context, isNewTask: true);
          } else {
            const SettingUpScreen().launch(context, isNewTask: true);
          }
        }
      } else {
        if (!mounted) return;
        const OfflineModeScreen().launch(context, isNewTask: true);
      }
    } catch (e) {
      log('Exception at splash screen: $e');
      if (!mounted) return;
      if (getBoolAsync(isLoggedInPref) && getBoolAsync(isTrackingOnPref)) {
        const OfflineModeScreen().launch(context, isNewTask: true);
      } else {
        //Logout user if token is expired
        if (e.toString().contains('Please login again')) {
          log('Token expired');
          if (isSaaSMode) {
            sharedHelper.logoutAlt();
            if (!mounted) return;
            const OrgChooseScreen().launch(context, isNewTask: true);
          } else {
            sharedHelper.logoutAlt();
            if (!mounted) return;
            const SettingUpScreen().launch(context, isNewTask: true);
          }
        } else {
          const ServerUnreachableScreen().launch(context, isNewTask: true);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            Image.asset(appLogoImg, height: 100, width: 100),
            FooterSignature(
              textColor: appStore.textPrimaryColor!,
            )
          ],
        ),
      ),
    );
  }
}
