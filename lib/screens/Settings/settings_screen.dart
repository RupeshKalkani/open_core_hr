import 'package:open_core_hr/screens/ChangePassword/change_password_screen.dart';
import 'package:open_core_hr/screens/Settings/modules_screen.dart';
import 'package:open_core_hr/screens/Settings/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_widgets.dart';
import '../../main.dart';
import '../navigation_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblSettings),
      body: isLoading
          ? loadingWidgetMaker()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SettingItemWidget(
                    title: language.lblRefreshAppConfiguration,
                    trailing: Icon(Icons.keyboard_arrow_right_rounded,
                        color: context.dividerColor),
                    decoration: BoxDecoration(borderRadius: radius()),
                    onTap: () async {
                      await sharedHelper.refreshAppSettings();
                      toast(language.lblSettingsRefreshed);
                    },
                  ),
                  SettingItemWidget(
                    title: language.lblDeviceStatus,
                    trailing: Icon(Icons.keyboard_arrow_right_rounded,
                        color: context.dividerColor),
                    decoration: BoxDecoration(borderRadius: radius()),
                    onTap: () async {
                      const StatusScreen().launch(context);
                    },
                  ),
                  SettingItemWidget(
                    title: language.lblModulesStatus,
                    trailing: Icon(Icons.keyboard_arrow_right_rounded,
                        color: context.dividerColor),
                    decoration: BoxDecoration(borderRadius: radius()),
                    onTap: () async {
                      const ModulesScreen().launch(context);
                    },
                  ),
                  SettingItemWidget(
                    title: language.lblChangePassword,
                    trailing: Icon(Icons.keyboard_arrow_right_rounded,
                        color: context.dividerColor),
                    decoration: BoxDecoration(borderRadius: radius()),
                    onTap: () async {
                      const ChangePasswordScreen().launch(context);
                    },
                  ),
                  Text(language.lblChangeTheme, style: primaryTextStyle()),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemCount: appStore.availableThemes.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var color = appStore.availableThemes[index];
                        return CircleAvatar(
                          backgroundColor: color,
                          radius: 20,
                          child: appStore.appColorPrimary == color
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ).onTap(() async {
                          setState(() {
                            isLoading = true;
                          });
                          appStore.changeColorTheme(color);
                          setState(() {
                            isLoading = false;
                          });
                          toast(language.lblColorChangedSuccessfully);
                          if (!mounted) return;
                          const NavigationScreen()
                              .launch(context, isNewTask: true);
                        }).paddingRight(5);
                      },
                    ),
                  ),
                ],
              ).paddingOnly(top: 5),
            ),
    );
  }
}
