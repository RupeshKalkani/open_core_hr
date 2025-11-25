import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Utils/app_constants.dart';
import '../Utils/app_widgets.dart';
import '../main.dart';
import 'Device/device_verification_screen.dart';
import 'Login/LoginScreen.dart';
import 'navigation_screen.dart';

class ServerUnreachableScreen extends StatefulWidget {
  const ServerUnreachableScreen({super.key});

  @override
  State<ServerUnreachableScreen> createState() =>
      _ServerUnreachableScreenState();
}

class _ServerUnreachableScreenState extends State<ServerUnreachableScreen> {
  bool isLoading = false;

  void checkStatus() async {
    setState(() {
      isLoading = true;
    });
    try {
      setState(() {});
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      if (getBoolAsync(isLoggedInPref)) {
        await sharedHelper.refreshAppSettings();
        toast(language.lblBackOnline);
        if (getBoolAsync(isDeviceVerifiedPref)) {
          if (!mounted) return;
          //const HomeScreen().launch(context, isNewTask: true);
          const NavigationScreen().launch(context, isNewTask: true);
        } else {
          if (!mounted) return;
          const DeviceVerificationScreen().launch(context, isNewTask: true);
        }
      } else {
        const LoginScreen().launch(context, isNewTask: true);
        return;
      }
    } catch (e) {
      toast(language.lblServerUnreachable);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblServerUnreachable),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/offline_server.json'),
          Text(
            language.lblWeAreUnableToConnectToTheServerPleaseTryAgainLater,
            style: primaryTextStyle(),
            textAlign: TextAlign.center,
          ),
          15.height,
          isLoading
              ? loadingWidgetMaker()
              : AppButton(
                  shapeBorder: buildButtonCorner(),
                  color: appStore.appColorPrimary,
                  textColor: Colors.white,
                  text: language.lblRetry,
                  onTap: () => checkStatus(),
                ),
        ],
      ),
    );
  }
}
