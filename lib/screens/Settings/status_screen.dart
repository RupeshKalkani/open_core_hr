import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_constants.dart';
import 'package:open_core_hr/Widgets/button_widget.dart';
import 'package:open_core_hr/main.dart';

import '../../Utils/app_widgets.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  int locationCount = 0, activityCount = 0;
  String backgroundStatus = '',
      locationUpdateDuration = '',
      trackingStartedAt = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();

    var duration = getIntAsync(locationUpdateIntervalPref);
    locationUpdateDuration =
        '${duration.toString()} ${getStringAsync(locationUpdateIntervalTypePref).toLowerCase() == 's' ? 'Seconds' : 'Minutes'}';

    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();

    setState(() {
      trackingStartedAt = appStore.getCurrentStatus?.checkInAt ?? 'Not Started';

      backgroundStatus = isRunning ? language.lblRunning : language.lblStopped;

      locationCount = prefs.getInt(locationCountPref) ?? 0;
      activityCount = prefs.getInt(activityCountPref) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, language.lblDeviceStatus),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tracking Started At
              if (!trackingStartedAt.isEmptyOrNull)
                _buildStatusCard(
                  title: language.lblTrackingStartedAt,
                  value: trackingStartedAt,
                  icon: Icons.access_time_rounded,
                ),

              // Activity Count
              _buildStatusCard(
                title: language.lblActivityCount,
                value: activityCount.toString(),
                icon: Icons.directions_run_outlined,
              ),

              // Location Count
              _buildStatusCard(
                title: language.lblLocationCount,
                value: locationCount.toString(),
                icon: Icons.location_on_outlined,
              ),

/*              // Last Location
              _buildStatusCard(
                title: language.lblLastLocation,
                value:
                    '${getDoubleAsync(latitudePref)}, ${getDoubleAsync(longitudePref)}',
                icon: Icons.map_rounded,
              ),*/

              // Update Interval
              _buildStatusCard(
                title: language.lblDeviceStatusUpdateInterval,
                value: locationUpdateDuration,
                icon: Icons.schedule_rounded,
              ),

              // Background Service Status
              _buildStatusCard(
                title: language.lblBackgroundServiceStatus,
                value: backgroundStatus,
                icon: Icons.settings_backup_restore_rounded,
              ),

              // Background Service Status
              /*   _buildStatusCard(
                title: 'Sync Detail',
                value: 'Click here',
                icon: Icons.refresh,
              ).onTap(() {
                OfflineSyncDashboard().launch(context);
              }),

              // AI Chat
               if (kDebugMode)
                _buildStatusCard(
                  title: 'AI Chat',
                  value: 'Click here',
                  icon: Icons.chat_bubble_outline_outlined,
                ).onTap(() {
                  AiChatScreen().launch(context);
                }),

              if (kDebugMode)
                _buildStatusCard(
                  title: 'Face Attendance',
                  value: 'Click here',
                  icon: Icons.settings,
                ).onTap(() {
                  FaceAttendanceScreen().launch(context);
                }),*/

              /*   // Location Tracker Status
              _buildStatusCard(
                title: language.lblBackgroundLocationTracker,
                value: locationStatus,
                icon: Icons.location_searching_rounded,
              ),*/

              const SizedBox(height: 20),

              // Refresh Button
              Center(
                child: button(
                  language.lblRefresh,
                  onTap: () => init(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Status Cards
  Widget _buildStatusCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: appStore.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, size: 32, color: appStore.appPrimaryColor),
        title: Text(title, style: boldTextStyle(size: 14)),
        subtitle: Text(
          value,
          style: primaryTextStyle(size: 12),
        ),
      ),
    ).paddingBottom(12);
  }
}
