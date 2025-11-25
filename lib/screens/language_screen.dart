import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_constants.dart';
import 'package:open_core_hr/screens/navigation_screen.dart';

import '../Utils/app_widgets.dart';
import '../main.dart';
import 'SettingUp/setting_up_screen.dart';
import 'org_choose_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Scaffold(
        appBar: appBar(context, language.lblChangeLanguage),
        body: LanguageListWidget(
          widgetType: WidgetType.LIST,
          onLanguageChange: (v) async {
            if (!mounted) return;
            finish(context);
            await appStore.setLanguage(v.languageCode!, context: context);
            toast(language.lblLanguageChanged);
            if (!mounted) return;
            if (getBoolAsync(isLoggedInPref)) {
              NavigationScreen().launch(context);
            } else {
              if (isSaaSMode) {
                OrgChooseScreen().launch(context, isNewTask: true);
              } else {
                SettingUpScreen().launch(context, isNewTask: true);
              }
            }
          },
        ),
      ),
    );
  }
}
