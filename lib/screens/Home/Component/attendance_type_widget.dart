import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/store/global_attendance_store.dart';
import 'package:public_ip_address/public_ip_address.dart';

import '../../../main.dart';
import '../../../service/map_helper.dart';

class AttendanceTypeWidget extends StatefulWidget {
  final AttendanceType type;
  const AttendanceTypeWidget({super.key, required this.type});

  @override
  State<AttendanceTypeWidget> createState() => _AttendanceTypeWidgetState();
}

class _AttendanceTypeWidgetState extends State<AttendanceTypeWidget> {
  String ipAddress = language.lblGettingYourIPAddress;
  String address = language.lblGettingYourAddress;
  String attendanceType = '...';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.type == AttendanceType.ipAddress) {
      attendanceType = 'IP Based';
      var ip = IpAddress();
      var ipAdd = await ip.getIp();
      ipAddress = '$ipAdd ${language.lblIsYourIPAddress}';
    } else if (widget.type == AttendanceType.geofence) {
      attendanceType = 'Geofence';
      var mapHelper = MapHelper();
      address =
          await mapHelper.getCurrentAddress() ?? language.lblUnableToGetAddress;
    } else if (widget.type == AttendanceType.qr) {
      attendanceType = 'QR Code';
    } else if (widget.type == AttendanceType.dynamicQr) {
      attendanceType = 'Dynamic QR Code';
    } else if (widget.type == AttendanceType.face) {
      attendanceType = 'Face';
    } else {
      attendanceType = 'Open';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Site Employee Information
            if (globalAttendanceStore.isSiteEmployee)
              Row(
                children: [
                  Icon(Iconsax.building, color: appStore.iconColor, size: 20),
                  8.width,
                  Text(
                    '${language.lblSite}: ${globalAttendanceStore.siteName}',
                    style: boldTextStyle(size: 14),
                  ),
                ],
              ).paddingBottom(8),

            // Attendance Type Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.information,
                        color: appStore.iconColor, size: 20),
                    8.width,
                    Text(
                      '${language.lblAttendanceType}: $attendanceType',
                      style: boldTextStyle(size: 16),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    appStore.refreshAttendanceStatus();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Icon(Iconsax.refresh,
                          color: appStore.appPrimaryColor, size: 20),
                      4.width,
                      Text(
                        language.lblRefresh,
                        style: boldTextStyle(
                            color: appStore.appPrimaryColor, size: 14),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 8, vertical: 4),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dynamic Content Based on Attendance Type
            _buildAttendanceDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceDetails() {
    if (widget.type == AttendanceType.ipAddress) {
      return Row(
        children: [
          Icon(Iconsax.global, color: appStore.iconColor, size: 20),
          8.width,
          Expanded(
            child: Text(
              ipAddress,
              style: primaryTextStyle(size: 14),
            ),
          ),
        ],
      );
    } else if (widget.type == AttendanceType.geofence) {
      return Row(
        children: [
          Icon(Iconsax.location, color: appStore.iconColor, size: 20),
          8.width,
          Expanded(
            child: Text(
              address,
              style: primaryTextStyle(size: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else if (widget.type == AttendanceType.qr) {
      return Row(
        children: [
          Icon(Iconsax.scan, color: appStore.iconColor, size: 20),
          8.width,
          Text(
            language.lblScanQRCodeToMarkAttendance,
            style: primaryTextStyle(size: 14),
          ),
        ],
      );
    } else if (widget.type == AttendanceType.dynamicQr) {
      return Row(
        children: [
          Icon(Icons.qr_code, color: appStore.iconColor, size: 20),
          8.width,
          Text(
            language.lblDynamicQRCodeIsEnabled,
            style: primaryTextStyle(size: 14),
          ),
        ],
      );
    } else if (widget.type == AttendanceType.face) {
      return Row(
        children: [
          Icon(Icons.face, color: appStore.iconColor, size: 20),
          8.width,
          Text(
            language.lblFaceRecognitionIsEnabled,
            style: primaryTextStyle(size: 14),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Iconsax.unlock, color: appStore.iconColor, size: 20),
          8.width,
          Text(
            language.lblOpenAttendance,
            style: primaryTextStyle(size: 14),
          ),
        ],
      );
    }
  }
}
