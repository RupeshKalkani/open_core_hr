import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Widgets/button_widget.dart';
import 'package:open_core_hr/screens/Device/DeviceStore.dart';
import 'package:open_core_hr/screens/Permission/permissions_screen.dart';
import 'package:open_core_hr/utils/app_widgets.dart';

import '../../main.dart';

class DeviceVerificationScreen extends StatefulWidget {
  const DeviceVerificationScreen({super.key});

  @override
  State<DeviceVerificationScreen> createState() =>
      _DeviceVerificationScreenState();
}

class _DeviceVerificationScreenState extends State<DeviceVerificationScreen> {
  final DeviceStore _store = DeviceStore();

  @override
  void initState() {
    super.initState();
    _store.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblDeviceVerification, hideBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Observer(
              builder: (_) {
                return Center(
                  child: Column(
                    children: [
                      // Lottie Animations based on status
                      _buildAnimation(_store.deviceVerificationStatus),
                      16.height,

                      // Verification Status Text
                      Text(
                        _getTitle(_store.deviceVerificationStatus),
                        style: boldTextStyle(size: 20),
                        textAlign: TextAlign.center,
                      ),
                      8.height,
                      Text(
                        _getSubtitle(_store.deviceVerificationStatus),
                        style: secondaryTextStyle(size: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            24.height,

            // Button based on status
            Observer(
              builder: (_) => _store.isLoading
                  ? loadingWidgetMaker()
                  : _buildButton(_store.deviceVerificationStatus),
            ),
          ],
        ),
      ),
    );
  }

  /// Build Lottie Animation Widget
  Widget _buildAnimation(DeviceVerificationStatus status) {
    switch (status) {
      case DeviceVerificationStatus.verifying:
        return Lottie.asset('assets/animations/phone_number_verification.json',
            height: 200);
      case DeviceVerificationStatus.verified:
        return Lottie.asset('assets/animations/success.json',
            height: 200, repeat: false);
      case DeviceVerificationStatus.alreadyRegistered:
      case DeviceVerificationStatus.failed:
        return Lottie.asset('assets/animations/failed.json',
            height: 200, repeat: false);
      case DeviceVerificationStatus.pending:
      case DeviceVerificationStatus.notRegistered:
        return Lottie.asset('assets/animations/phone-lock.json',
            height: 200, repeat: false);
    }
  }

  /// Get Title based on Verification Status
  String _getTitle(DeviceVerificationStatus status) {
    switch (status) {
      case DeviceVerificationStatus.verifying:
        return language.lblVerifying;
      case DeviceVerificationStatus.pending:
        return language.lblVerificationPending;
      case DeviceVerificationStatus.alreadyRegistered:
        return language.lblVerificationFailed;
      case DeviceVerificationStatus.notRegistered:
        return language.lblNewDevice;
      case DeviceVerificationStatus.verified:
        return language.lblVerificationCompleted;
      default:
        return language.lblVerificationFailed;
    }
  }

  /// Get Subtitle based on Verification Status
  String _getSubtitle(DeviceVerificationStatus status) {
    switch (status) {
      case DeviceVerificationStatus.verifying:
        return language.lblHoldOn;
      case DeviceVerificationStatus.pending:
        return language.lblYourDeviceVerificationIsPending;
      case DeviceVerificationStatus.alreadyRegistered:
        return language
            .lblThisDeviceIsAlreadyRegisteredWithOtherAccountPleaseContactAdministrator;
      case DeviceVerificationStatus.notRegistered:
        return language
            .lblThisDeviceIsNotRegisteredClickOnRegisterToAddItToYourAccount;
      case DeviceVerificationStatus.verified:
        return language.lblYourDeviceVerificationIsSuccessfullyCompleted;
      default:
        return language.lblVerificationFailedPleaseTryAgain;
    }
  }

  /// Build Action Button based on Status
  Widget _buildButton(DeviceVerificationStatus status) {
    if (status == DeviceVerificationStatus.verified) {
      return button(language.lblOk, onTap: () async {
        await sharedHelper.refreshAppSettings();
        await moduleService.refreshModuleSettings();
        toast(language.lblWelcomeBack);
        PermissionScreen().launch(context, isNewTask: true);
      });
    } else if (status == DeviceVerificationStatus.notRegistered) {
      return button(language.lblRegisterNow, onTap: () async {
        var result = await _store.registerDevice();
        if (result) {
          await sharedHelper.refreshAppSettings();
          await moduleService.refreshModuleSettings();
          PermissionScreen().launch(context, isNewTask: true);
        }
      });
    } else if (status == DeviceVerificationStatus.alreadyRegistered ||
        status == DeviceVerificationStatus.failed) {
      return button(language.lblLogOut, onTap: () {
        if (!mounted) return;
        sharedHelper.logout(context);
      });
    }
    return const SizedBox.shrink();
  }
}
