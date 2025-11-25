import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_colors.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/screens/navigation_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import '../../service/permission_service.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final PermissionService _permissionService = PermissionService();
  bool _locationGranted = false;
  bool _activityGranted = false;
  bool _notificationGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    _notificationGranted =
        await Permission.notification.status.isGranted ? true : false;
    _activityGranted = (isIOS
            ? await Permission.sensors.status.isGranted
            : await Permission.activityRecognition.status.isGranted)
        ? true
        : false;
    _locationGranted = isIOS
        ? await Geolocator.checkPermission() == LocationPermission.always ||
            await Geolocator.checkPermission() == LocationPermission.whileInUse
        : await Permission.locationAlways.status.isGranted
            ? true
            : false;
    setState(() {
      _locationGranted = _locationGranted;
      _activityGranted = _activityGranted;
      _notificationGranted = _notificationGranted;
    });
  }

  bool get _allPermissionsGranted =>
      _locationGranted && _activityGranted && _notificationGranted;

  Future<void> _showPermissionDetails(String title, String details) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: boldTextStyle()),
          content: Text(details, style: secondaryTextStyle(size: 14)),
          actions: [
            TextButton(
              child: Text(language.lblClose),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPermissionButton(String title, String description, IconData icon,
      bool granted, Function requestPermission, String details) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: cardDecoration(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    icon,
                    color: appColorPrimary,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () => _showPermissionDetails(title, details),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        RichText(
                          text: TextSpan(
                            text: description,
                            style: const TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: language.lblMoreDetails,
                                style: TextStyle(
                                  color: appColorPrimary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: !granted ? 3 : 2,
                  child: granted
                      ? Lottie.asset('assets/animations/success.json',
                          repeat: false, width: 40, height: 40)
                      : Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: granted
                                ? null
                                : () async {
                                    await requestPermission();
                                    await _checkPermissions();
                                  },
                            child: Text(language.lblAllow),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).paddingAll(8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblPermissions, hideBack: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(Icons.security, size: 80, color: appColorPrimary),
            const SizedBox(height: 20),
            Text(
              '${language.lblToEnsureProperFunctionalityTheFollowingPermissionsAreRequired}:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildPermissionButton(
              language.lblLocation,
              language
                  .lblAllowAccessToYourLocationForAttendanceAndTravelTrackingEvenWhenTheAppIsClosed,
              Icons.location_on,
              _locationGranted,
              isIOS
                  ? _permissionService.requestLocationPermissionIOS
                  : _permissionService.requestLocationPermissionAndroid,
              language
                  .lblLocationPermissionIsRequiredForTrackingAttendanceRecordingClientVisitsAndCalculatingDistancesTraveledEvenWhenTheAppIsNotInUse,
            ),
            _buildPermissionButton(
              language.lblActivity,
              language
                  .lblAllowAccessToYourActivityForAttendanceAndTravelTracking,
              Icons.directions_run,
              _activityGranted,
              isIOS
                  ? _permissionService.requestActivityPermissionIOS
                  : _permissionService.requestActivityPermissionAndroid,
              language
                  .lblActivityPermissionIsUsedToDetectYourPhysicalMovementsAndTravelEnablingTheAppToTrackAttendanceVisitsAndActivityStates,
            ),
            _buildPermissionButton(
              language.lblNotifications,
              language
                  .lblEnableNotificationsToKeepYouUpdatedWithImportantUpdates,
              Icons.notifications,
              _notificationGranted,
              _permissionService.requestNotificationPermissionAndroid,
              language
                  .lblNotificationPermissionEnsuresYouReceiveUpdatesOnAttendanceTasksAndOtherImportantEventsInRealTime,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_allPermissionsGranted) {
            NavigationScreen().launch(context, isNewTask: true);
          } else {
            toast(language.lblPleaseAllowAllPermissionsToContinue);
          }
        },
        icon: const Icon(Icons.arrow_forward),
        label: Text(language.lblNext),
        backgroundColor: appStore.appColorPrimary,
      ),
    );
  }
}
