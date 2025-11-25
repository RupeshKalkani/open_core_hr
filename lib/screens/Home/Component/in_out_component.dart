import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart'; /*
import 'package:local_auth_ios/local_auth_ios.dart';*/
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:open_core_hr/screens/FaceAttendance/face_attendance_screen.dart';
import 'package:open_core_hr/screens/Scanner/qr_scanner_screen.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../Utils/app_constants.dart';
import '../../../Utils/app_widgets.dart';
import '../../../Widgets/button_widget.dart';
import '../../../store/global_attendance_store.dart';

class InOutComponent extends StatefulWidget {
  const InOutComponent({super.key});

  @override
  State<InOutComponent> createState() => _InOutComponentState();
}

class _InOutComponentState extends State<InOutComponent> {
  bool isBreakModuleEnabled = false;

  final lateReasonController = TextEditingController();
  final lateReasonFocus = FocusNode();

  final earlyCheckOutReasonController = TextEditingController();
  final earlyCheckOutReasonFocus = FocusNode();

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  //Local Auth
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;
  bool _authorized = false;

  @override
  void initState() {
    super.initState();
    isBreakModuleEnabled = moduleService.isBreakModuleEnabled();
    init();
    refreshTimer();
  }

  void init() {
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });

      authenticated = await auth.authenticate(
          localizedReason: language.lblScanYourFingerprintToCheckIn,
          authMessages: <AuthMessages>[
            /*        IOSAuthMessages(
              cancelButton: language.lblCancel,
              goToSettingsButton: language.lblSettings,
              goToSettingsDescription: language.lblPleaseSetUpYourTouchId,
              lockOut: language.lblPleaseReEnableYourTouchId,
            ),*/
            AndroidAuthMessages(
                signInTitle: language.lblFingerprintAuthentication,
                //fingerprintRequiredTitle: "Connect to Login",
                cancelButton: language.lblCancel,
                goToSettingsButton: language.lblSettings,
                goToSettingsDescription: 'Please setup your fingerprint',
                biometricRequiredTitle:
                    language.lblAuthenticateWithFingerprintOrPasswordToProceed
                //fingerprintSuccess: "Authentication Successfully authenticated",
                ),
          ]);
      _authorized = authenticated;
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      log('Auth error $e');
      toast(language.lblPleaseSetupYourFingerprint);
    }
    if (!mounted) return false;

    setState(() {
      _authorized = authenticated;
    });
  }

  refreshTimer() async {
    if (globalAttendanceStore.isOnBreak) {
      var startTime = globalAttendanceStore.breakStartAt;
      var now = DateTime.now();

      var diff = now.difference(startTime);

      _stopWatchTimer.setPresetTime(mSec: diff.inMilliseconds);
      _stopWatchTimer.onStartTimer();
    } else {
      _stopWatchTimer.setPresetTime(mSec: 0);
      _stopWatchTimer.onStopTimer();
    }
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  void checkIn() async {
    globalAttendanceStore.isInOutBtnLoading = true; // Start Loading Indicator
    hideKeyboard(context);

    try {
      // Biometric Verification
      if (moduleService.isBioMetricVerificationModuleEnabled()) {
        await _authenticate();
        if (!_authorized) {
          globalAttendanceStore.isInOutBtnLoading = false;
          return;
        }
      }

      //Face Verification
      if (globalAttendanceStore.attendanceType == AttendanceType.face) {
        if (!mounted) return;

        var result = await FaceAttendanceScreen().launch(context);

        if (!result) {
          globalAttendanceStore.isInOutBtnLoading = false;
          return;
        }
      }

      // Geofence Validation
      if (globalAttendanceStore.attendanceType == AttendanceType.geofence) {
        var result = await globalAttendanceStore.validateGeofence();
        if (!result) {
          globalAttendanceStore.isInOutBtnLoading = false;
          return;
        }
      }

      // IP Address Validation
      if (globalAttendanceStore.attendanceType == AttendanceType.ipAddress) {
        var result = await globalAttendanceStore.validateIpAddress();
        if (!result) {
          globalAttendanceStore.isInOutBtnLoading = false;
          return;
        }
      }

      // QR Validation
      if (globalAttendanceStore.attendanceType == AttendanceType.qr) {
        var result = await verifyQr();
        if (!result) {
          globalAttendanceStore.isInOutBtnLoading = false;
          return;
        }
      }

      // Dynamic QR Validation
      if (globalAttendanceStore.attendanceType == AttendanceType.dynamicQr) {
        var result = await verifyDynamicQr();
        if (!result) {
          globalAttendanceStore.isInOutBtnLoading = false;
          return;
        }
      }

      // Confirmation Dialog
      if (!mounted) {
        globalAttendanceStore.isInOutBtnLoading = false;
        return;
      }

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(language.lblCheckIn),
            content: Text(language.lblAreYouSureYouWantToCheckIn),
            actions: [
              TextButton(
                child: Text(
                  language.lblNo,
                  style: primaryTextStyle(color: appStore.textPrimaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  globalAttendanceStore.isInOutBtnLoading =
                      false; // Reset on cancel
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appStore.appColorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  language.lblYes,
                  style: primaryTextStyle(color: white),
                ),
                onPressed: () {
                  globalAttendanceStore.checkInOut(
                    AttendanceStatus.checkIn,
                    lateCheckInReason: lateReasonController.text,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      toast(language.lblSomethingWentWrong);
      globalAttendanceStore.isInOutBtnLoading = false;
    }
  }

  Future<bool> verifyQr() async {
    var result = await const BarcodeScannerWithOverlay().launch(context);
    if (result == null) {
      return false;
    }
    String resultString = result as String;
    if (resultString.isEmptyOrNull) {
      toast('${language.lblInvalid} QR');
      return false;
    }
    var verificationResult =
        await globalAttendanceStore.validateQrCode(resultString);
    if (verificationResult) {
      return true;
    }
    return false;
  }

  Future<bool> verifyDynamicQr() async {
    var result = await const BarcodeScannerWithOverlay().launch(context);
    if (result == null) {
      return false;
    }
    String resultString = result as String;
    if (resultString.isEmptyOrNull) {
      toast('${language.lblInvalid} QR');
      return false;
    }
    var verificationResult =
        await globalAttendanceStore.validateDynamicQrCode(resultString);
    if (verificationResult) {
      return true;
    }
    return false;
  }

  void checkOut() async {
    globalAttendanceStore.isInOutBtnLoading = true;
    if (moduleService.isBioMetricVerificationModuleEnabled()) {
      await _authenticate();
      if (!_authorized) {
        globalAttendanceStore.isInOutBtnLoading = false;
        return;
      }
    }

    if (globalAttendanceStore.attendanceType == AttendanceType.geofence) {
      var result = await globalAttendanceStore.validateGeofence();
      if (!result) {
        globalAttendanceStore.isInOutBtnLoading = false;
        return;
      }
    }

    if (globalAttendanceStore.attendanceType == AttendanceType.ipAddress) {
      var result = await globalAttendanceStore.validateIpAddress();
      if (!result) {
        globalAttendanceStore.isInOutBtnLoading = false;
        return;
      }
    }

    //Face Verification
    if (globalAttendanceStore.attendanceType == AttendanceType.face) {
      if (!mounted) return;

      var result = await FaceAttendanceScreen().launch(context);

      if (!result) {
        globalAttendanceStore.isInOutBtnLoading = false;
        return;
      }
    }

    if (globalAttendanceStore.attendanceType == AttendanceType.qr) {
      var result = await verifyQr();
      if (!result) {
        globalAttendanceStore.isInOutBtnLoading = false;
        return;
      }
    }

    if (globalAttendanceStore.attendanceType == AttendanceType.dynamicQr) {
      var result = await verifyDynamicQr();
      if (!result) {
        globalAttendanceStore.isInOutBtnLoading = false;
        return;
      }
    }

    AlertDialog checkOutAlert = AlertDialog(
      title: Text(language.lblCheckOut),
      content: Text(language.lblAreYouSureYouWantToCheckOut),
      actions: [
        TextButton(
          child: Text(
            language.lblNo,
            style: primaryTextStyle(color: appStore.textPrimaryColor),
          ),
          onPressed: () {
            globalAttendanceStore.isInOutBtnLoading = false;
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appStore.appColorPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            language.lblYes,
            style: primaryTextStyle(color: white),
          ),
          onPressed: () {
            globalAttendanceStore.checkInOut(AttendanceStatus.checkOut);
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    if (!mounted) {
      globalAttendanceStore.isInOutBtnLoading = false;
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return checkOutAlert;
      },
    );
  }

  void startBreak() async {
    if (!isBreakModuleEnabled) {
      toast(language.lblBreakModuleIsNotEnabled);
      return;
    }
    //Show alert confirmation
    AlertDialog alert = AlertDialog(
      title: Text(language.lblBreak),
      content: Text(language.lblAreYouSureYouWantToTakeABreak),
      actions: [
        TextButton(
          child: Text(
            language.lblNo,
            style: primaryTextStyle(color: appStore.textPrimaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appStore.appColorPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            language.lblYes,
            style: primaryTextStyle(color: white),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            var result = await globalAttendanceStore.startStopBreak();
            if (result) {
              _stopWatchTimer.setPresetTime(mSec: 0);
              _stopWatchTimer.onStartTimer();
            }
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void earlyCheckOutReason() async {
    AlertDialog alert = AlertDialog(
      title: Text(language.lblEarlyCheckOut),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(language.lblPleaseEnterYourEarlyCheckOutReason),
          10.height,
          TextFormField(
            controller: earlyCheckOutReasonController,
            focusNode: earlyCheckOutReasonFocus,
            style: TextStyle(
                fontSize: fontSizeLargeMedium,
                fontFamily: fontRegular,
                color: appStore.textPrimaryColor),
            onChanged: (value) => {},
            decoration: newEditTextDecoration(
                Icons.text_fields, language.lblEarlyCheckOutReason,
                borderColor: white, bgColor: white),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(language.lblConfirm),
          onPressed: () async {
            if (earlyCheckOutReasonController.text.isEmptyOrNull) {
              toast(language.lblPleaseEnterYourEarlyCheckOutReason);
              earlyCheckOutReasonFocus.requestFocus();
              return;
            }

            var result = await globalAttendanceStore
                .setEarlyCheckoutReason(earlyCheckOutReasonController.text);
            if (!mounted) return;
            if (result) {
              globalAttendanceStore.checkInOut(AttendanceStatus.checkOut);
            }
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            language.lblCancel,
            style: primaryTextStyle(color: appStore.textPrimaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void stopBreak() async {
    if (!isBreakModuleEnabled) {
      toast(language.lblBreakModuleIsNotEnabled);
      return;
    }
    AlertDialog alert = AlertDialog(
      title: Text(language.lblResume),
      content: Text(language.lblAreYouSureYouWantToResume),
      actions: [
        TextButton(
          child: Text(
            language.lblNo,
            style: primaryTextStyle(color: appStore.textPrimaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appStore.appColorPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            language.lblYes,
            style: primaryTextStyle(color: white),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            var result = await globalAttendanceStore.startStopBreak();
            if (result) {
              refreshTimer();
            }
            if (!mounted) return;
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        child: globalAttendanceStore.isNew
            ? checkInWidget()
            : globalAttendanceStore.isOnBreak
                ? onBreakWidget()
                : globalAttendanceStore.isCheckedIn
                    ? checkOutWidget()
                    : allDoneWidget(),
      ),
    );
  }

  Widget checkInWidget() {
    return Observer(
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shiftText(),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              globalAttendanceStore.isInOutBtnLoading
                  ? loadingWidgetMaker()
                  : globalAttendanceStore.attendanceType == AttendanceType.qr ||
                          globalAttendanceStore.attendanceType ==
                              AttendanceType.dynamicQr
                      ? iconButton(
                          language.lblScanQRToCheckIn,
                          Icons.qr_code_scanner_rounded,
                          onTap: () => checkIn(),
                        ).center()
                      : globalAttendanceStore.attendanceType ==
                              AttendanceType.face
                          ? iconButton(
                              language.lblScanFace,
                              Icons.face,
                              onTap: () => checkIn(),
                            ).center()
                          : button(
                              language.lblCheckIn,
                              onTap: () => checkIn(),
                            ).center(),
            ],
          )
        ],
      ),
    );
  }

  Widget checkOutWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${language.lblYouCheckedInAt} ${globalAttendanceStore.currentStatus!.checkInAt.toString()}',
                    maxLines: 2,
                  ),
                ),
                10.width,
              ],
            ),
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                globalAttendanceStore.isInOutBtnLoading
                    ? loadingWidgetMaker()
                    : globalAttendanceStore.attendanceType ==
                                AttendanceType.qr ||
                            globalAttendanceStore.attendanceType ==
                                AttendanceType.dynamicQr
                        ? iconButton(
                            language.lblCheckOut,
                            Icons.qr_code_scanner_rounded,
                            onTap: () => checkOut(),
                          )
                        : Flexible(
                            flex: 3,
                            child: button(
                              language.lblCheckOut,
                              onTap: () => checkOut(),
                            ),
                          ),
                isBreakModuleEnabled && !globalAttendanceStore.isInOutBtnLoading
                    ? Flexible(
                        flex: 2,
                        child: button(
                          language.lblBreak,
                          color: white,
                          textColor: black,
                          onTap: () => startBreak(),
                        ).paddingLeft(8),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget onBreakWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              language.lblYouAreOnBreak,
              style: primaryTextStyle(),
            ),
          ],
        ),
        10.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: 0,
              builder: (context, snap) {
                final value = snap.data;
                final displayTime =
                    StopWatchTimer.getDisplayTime(value!, milliSecond: false);
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        displayTime,
                        style: boldTextStyle(
                          size: largeSize,
                          color: appStore.appColorPrimary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            button(
              language.lblResume,
              color: white,
              textColor: black,
              onTap: () => stopBreak(),
            )
          ],
        ),
      ],
    );
  }

  Widget allDoneWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.height,
        Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Iconsax.clock, color: Colors.white),
                  5.width,
                  Text(
                    '${language.lblYouCheckedInAt}${globalAttendanceStore.currentStatus!.checkInAt.toString()}',
                    style: primaryTextStyle(color: white),
                  ),
                ],
              ),
              5.height,
              Row(
                children: [
                  const Icon(Iconsax.clock, color: Colors.white),
                  5.width,
                  Text(
                    '${language.lblYouCheckedOutAt}${globalAttendanceStore.currentStatus!.checkOutAt.toString()}',
                    style: primaryTextStyle(color: white),
                  ),
                ],
              ),
            ],
          ),
        ),
        5.height,
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(16),
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language.lblAllDoneForToday,
                  style: boldTextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Text shiftText() {
  return Text(
    '${language.lblYourShiftStartsAt} ${globalAttendanceStore.shiftStartAt}',
  );
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
