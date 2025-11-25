import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_constants.dart';
import '../../main.dart';
import '../Login/LoginScreen.dart';
import '../navigation_screen.dart';
import 'offline_mode_store.dart';

class OfflineModeScreen extends StatefulWidget {
  const OfflineModeScreen({super.key});

  @override
  State<OfflineModeScreen> createState() => _OfflineModeScreenState();
}

class _OfflineModeScreenState extends State<OfflineModeScreen> {
  final _store = OfflineModeStore();

  @override
  void initState() {
    super.initState();
  }

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
        if (!mounted) return;
        const NavigationScreen().launch(context, isNewTask: true);
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
      appBar: appBar(context, language.lblOfflineMode),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/offline_server.json'),
            16.height,
            Text(
              language.lblYouAreInOfflineMode,
              style: boldTextStyle(size: 20),
            ),
            16.height,
            Text(
              language
                  .lblOptionsWillBeLimitedUntilYouAreBackOnlinePleaseCheckYourInternetConnection,
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
            16.height,
            isLoading
                ? loadingWidgetMaker()
                : AppButton(
                    shapeBorder: buildButtonCorner(),
                    color: appStore.appColorPrimary,
                    textColor: Colors.white,
                    text: language.lblRefresh,
                    onTap: () => checkStatus(),
                  ),
          ],
        ),
      ),
    );
  }
}
