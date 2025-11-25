import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/ChangePassword/change_password_screen.dart';
import 'package:open_core_hr/screens/Settings/modules_screen.dart';
import 'package:open_core_hr/screens/Settings/status_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_widgets.dart';
import '../DigitalId/digital_id_card_screen.dart';
import '../Support/support_screen.dart';
import '../language_screen.dart';
import '../navigation_screen.dart';

class AccountScreen extends StatefulWidget {
  static String tag = '/AccountScreen';
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late double width;
  bool isNotificationEnabled = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    sharedHelper.refreshUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        appBar: appBar(context, language.lblAccount, actions: [
          IconButton(
              icon: Icon(Iconsax.logout, color: appStore.iconColor),
              onPressed: () {
                //Show confirmation dialog
                showConfirmDialog(
                  context,
                  language.lblDoYouWantToLogoutFromTheApp,
                  positiveText: language.lblYes,
                  negativeText: language.lblNo,
                  onAccept: () {
                    if (!mounted) return;
                    sharedHelper.logout(context);
                  },
                );
              }),
        ]),
        body: isLoading
            ? Center(child: loadingWidgetMaker())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    profileSection(),
                    20.height,
                    Text('General', style: boldTextStyle(size: 16)),
                    Divider(height: 20, color: Colors.grey.withOpacity(0.2)),

                    // General Settings
                    _buildSettingsItem(
                      title: language.lblChangeLanguage,
                      icon: Iconsax.language_square,
                      onTap: () => const LanguageScreen().launch(context),
                    ),
                    _buildSettingsItem(
                      title: language.lblDarkMode,
                      icon:
                          appStore.isDarkModeOn ? Iconsax.sun_1 : Iconsax.moon,
                      trailing: Switch(
                        value: appStore.isDarkModeOn,
                        onChanged: (s) => appStore.toggleDarkMode(value: s),
                        activeTrackColor: appStore.appColorPrimary,
                        activeColor: white,
                      ),
                    ),
                    _buildSettingsItem(
                      title: language.lblNotification,
                      icon: Iconsax.notification,
                      trailing: Switch(
                        value: isNotificationEnabled,
                        onChanged: (value) async {
                          var instance = FirebaseMessaging.instance;
                          if (value) {
                            instance.subscribeToTopic('announcement');
                          } else {
                            instance.unsubscribeFromTopic('announcement');
                          }
                          setState(() => isNotificationEnabled = value);
                        },
                        activeTrackColor: appStore.appColorPrimary,
                        activeColor: white,
                      ),
                    ),
                    _buildSettingsItem(
                      title: language.lblSupport,
                      icon: Iconsax.support,
                      onTap: () => const SupportScreen().launch(context),
                    ),
                    _buildSettingsItem(
                      title: language.lblRateUs,
                      icon: Iconsax.star,
                      onTap: () async {
                        PackageInfo.fromPlatform().then((value) async {
                          String package = value.packageName;
                          launchUrl(Uri.parse('$playStoreUrl$package'));
                        });
                      },
                    ),
                    _buildSettingsItem(
                      title: language.lblShareApp,
                      icon: Iconsax.share,
                      onTap: () async {
                        PackageInfo.fromPlatform().then((value) async {
                          String package = value.packageName;
                          await Share.share(
                              'Download $mainAppName from Play Store\n\n\n$playStoreUrl$package');
                        });
                      },
                    ),

                    20.height,
                    Text(language.lblSettings, style: boldTextStyle(size: 16)),
                    Divider(height: 20, color: Colors.grey.withOpacity(0.2)),

                    // Settings Items Integrated
                    _buildSettingsItem(
                      title: language.lblRefreshAppConfiguration,
                      icon: Iconsax.refresh,
                      onTap: () async {
                        await sharedHelper.refreshAppSettings();
                        toast(language.lblSettingsRefreshed);
                      },
                    ),
                    _buildSettingsItem(
                      title: language.lblDeviceStatus,
                      icon: Iconsax.mobile,
                      onTap: () => const StatusScreen().launch(context),
                    ),
                    _buildSettingsItem(
                      title: language.lblModulesStatus,
                      icon: Iconsax.setting_2,
                      onTap: () => const ModulesScreen().launch(context),
                    ),
                    _buildSettingsItem(
                      title: language.lblChangePassword,
                      icon: Iconsax.lock,
                      onTap: () => const ChangePasswordScreen().launch(context),
                    ),
                    20.height, // Spacer
                    Text(language.lblChangeTheme,
                        style: boldTextStyle(size: 16)),
                    Divider(height: 20, color: Colors.grey.withOpacity(0.2)),

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

                    50.height,

                    // App Version
                    Center(
                      child: Text(getStringAsync(appVersionPref),
                          style: secondaryTextStyle(size: 12)),
                    ),
                    Center(
                      child: getStringAsync('organization').isNotEmpty
                          ? Text(
                              '${language.lblOrganization}: ${getStringAsync('organization')}',
                              style: secondaryTextStyle(size: 12),
                            )
                          : null,
                    ),
                    20.height,
                  ],
                ),
              ),
      ),
    );
  }

  Widget profileSection() {
    return Container(
      decoration: BoxDecoration(
        color: appStore.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Profile Image
          Hero(
            tag: 'profile',
            child: profileImageWidget(size: 40),
          ),
          16.width,

          // Employee Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sharedHelper.getFullName(),
                  style: boldTextStyle(size: 18),
                  overflow: TextOverflow.ellipsis,
                ),
                6.height,
                Text(
                  '${language.lblPhone}: ${sharedHelper.getPhoneNumber()}',
                  style: secondaryTextStyle(size: 14),
                ),
                4.height,
                Text(
                  '${language.lblCode}: ${sharedHelper.getEmployeeCode()}',
                  style: secondaryTextStyle(size: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // ID Card Icon Button
          moduleService.isDigitalIdCardModuleEnabled()
              ? IconButton(
                  icon: Icon(Iconsax.card,
                      color: appStore.appPrimaryColor, size: 28),
                  onPressed: () {
                    DigitalIDCardScreen().launch(context);
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  // Reusable Settings Item Widget
  Widget _buildSettingsItem({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: appStore.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: appStore.appPrimaryColor, size: 28),
        title: Text(title, style: boldTextStyle(size: 14)),
        trailing: trailing ??
            const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
