import 'package:battery_plus/battery_plus.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:public_ip_address/public_ip_address.dart';

import '../main.dart';
import '../models/Visit/VisitCountModel.dart';
import '../models/status/status_response.dart';

part 'global_attendance_store.g.dart';

class GlobalAttendanceStore = GlobalAttendanceStoreBase
    with _$GlobalAttendanceStore;

abstract class GlobalAttendanceStoreBase with Store {
  @observable
  bool isInOutBtnLoading = false;

  @observable
  bool isBreakBtnLoading = false;

  final Location locationService = Location();

  @observable
  StatusResponse? currentStatus = StatusResponse();

  @observable
  bool isVisitsCountLoading = false;

  VisitCountModel? visitCount;

  @computed
  bool get isKillDevice {
    return currentStatus != null && currentStatus!.deviceStatus == 'kill';
  }

  @computed
  bool get isNew {
    return currentStatus != null && currentStatus!.status == 'new';
  }

  @computed
  bool get isCheckedIn {
    return currentStatus != null && currentStatus!.status == 'checkedin';
  }

  @computed
  bool get isLate {
    if (currentStatus != null && currentStatus!.isLate != null) {
      return currentStatus!.isLate!;
    } else {
      return false;
    }
  }

  @computed
  bool get isCheckedOut {
    return currentStatus != null && currentStatus!.status == 'checkedout';
  }

  @computed
  String get trackedHours {
    if (currentStatus != null && currentStatus!.trackedHours != null) {
      return currentStatus!.trackedHours.toString();
    } else {
      return '';
    }
  }

  @computed
  String get travelledDistance {
    if (currentStatus != null && currentStatus!.travelledDistance != null) {
      return currentStatus!.travelledDistance!.toStringAsFixed(0);
    } else {
      return '';
    }
  }

  @computed
  bool get isSiteEmployee {
    if (currentStatus != null && currentStatus!.isSiteEmployee != null) {
      return currentStatus!.isSiteEmployee!;
    } else {
      return false;
    }
  }

  @computed
  String get siteName {
    if (currentStatus != null && currentStatus!.siteName != null) {
      return currentStatus!.siteName!;
    } else {
      return '';
    }
  }

  @computed
  AttendanceType get attendanceType {
    if (currentStatus != null && currentStatus!.attendanceType != null) {
      switch (currentStatus!.attendanceType!) {
        case 'geofence':
          return AttendanceType.geofence;
        case 'ip':
          return AttendanceType.ipAddress;
        case 'staticqrcode':
          return AttendanceType.qr;
        case 'dynamicqrcode':
          return AttendanceType.dynamicQr;
        case 'face':
          return AttendanceType.face;
        default:
          return AttendanceType.none;
      }
    } else {
      return AttendanceType.none;
    }
  }

  @action
  Future<bool> validateQrCode(String qrCode) async {
    isInOutBtnLoading = true;
    var result = await apiService.verifyQr(qrCode);
    if (result) {
      isInOutBtnLoading = false;
      toast('Your QR code is verified');
      return true;
    }
    isInOutBtnLoading = false;
    return false;
  }

  @action
  Future<bool> validateDynamicQrCode(String qrCode) async {
    isInOutBtnLoading = true;
    var result = await apiService.verifyDynamicQr(qrCode);
    if (result) {
      isInOutBtnLoading = false;
      toast('Your QR code is verified');
      return true;
    }
    isInOutBtnLoading = false;
    return false;
  }

  @action
  Future<bool> validateIpAddress() async {
    isInOutBtnLoading = true;
    var ipAdd = IpAddress();
    var ip = await ipAdd.getIp();
    var result = await apiService.validateIpAddress(ip);
    if (result) {
      toast('Your IP address is verified');
      isInOutBtnLoading = false;
      return true;
    } else {
      toast('You are not in the IP address range');
    }
    isInOutBtnLoading = false;
    return false;
  }

  @action
  Future<bool> startStopBreak() async {
    isBreakBtnLoading = true;
    var result = await apiService.startStopBreak();
    await appStore.refreshAttendanceStatus();
    if (result) {
      isInOutBtnLoading = false;
      return false;
    }

    isBreakBtnLoading = false;
    return true;
  }

  @computed
  bool get isOnBreak {
    if (currentStatus != null &&
        currentStatus!.isOnBreak != null &&
        currentStatus!.isOnBreak!) {
      return true;
    } else {
      return false;
    }
  }

  @computed
  DateTime get breakStartAt {
    if (isOnBreak) {
      var format = DateFormat('dd-MM-yy HH:mm:ss a');

      var nowDateString = DateFormat('dd-MM-yy').format(DateTime.now());

      return format.parse('$nowDateString ${currentStatus!.breakStartedAt}');
    } else {
      return DateTime.now();
    }
  }

  @computed
  String get shiftStartAt {
    if (currentStatus != null && currentStatus!.shiftStartAt != null) {
      return currentStatus!.shiftStartAt!;
    } else {
      return '';
    }
  }

  @computed
  String get shiftEndAt {
    if (currentStatus != null && currentStatus!.shiftEndAt != null) {
      return currentStatus!.shiftEndAt!;
    } else {
      return '';
    }
  }

  @action
  Future<bool> validateGeofence() async {
    isInOutBtnLoading = true;
    var location = await locationService.getLocation();
    if (location.latitude == null || location.longitude == null) {
      toast('Unable to get device location');
      isInOutBtnLoading = false;
      return false;
    }
    var result = await apiService.validateGeofence(
        location.latitude!, location.longitude!);
    if (result) {
      toast('Your location is verified');
      isInOutBtnLoading = false;
      return true;
    }

    toast('You are not in the geofence area');
    isInOutBtnLoading = false;
    return false;
  }

  @action
  Future<bool> setEarlyCheckoutReason(String reason) async {
    isInOutBtnLoading = true;
    var result = await apiService.setEarlyCheckoutReason(reason);
    if (result) {
      toast('Reason updated');
      isInOutBtnLoading = false;
      return true;
    }
    toast('Failed to update reason');
    isInOutBtnLoading = false;
    return false;
  }

  @action
  void setCurrentStatus(StatusResponse status) {
    currentStatus = status;
  }

  @action
  Future checkInOut(AttendanceStatus status,
      {String? lateCheckInReason}) async {
    isInOutBtnLoading = true;

    var location = await locationService.getLocation();
    if (location.latitude == null || location.longitude == null) {
      toast('Unable to get device location');
      return false;
    }
    ;
    var battery = Battery();

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map req = {
      "status": status == AttendanceStatus.checkIn ? 'checkin' : 'checkout',
      "lateReason": lateCheckInReason,
      "latitude": location.latitude,
      "longitude": location.longitude,
      "altitude": location.altitude ?? 0,
      "bearing": 0,
      "locationAccuracy": location.accuracy ?? 0,
      "speed": location.speed ?? 0,
      "time": location.time ?? 0,
      "isMock": location.isMock ?? false,
      "batteryPercentage": await battery.batteryLevel,
      "isLocationOn": true,
      "isWifiOn": connectivityResult
          .where((element) => element == ConnectivityResult.wifi)
          .isNotEmpty,
      "signalStrength": 5
    };

    var result = await apiService.checkInOut(req);
    if (!result.isSuccess) {
      toast(result.message);
      return false;
    }
    var statusResult = await apiService.checkAttendanceStatus();
    if (statusResult != null) {
      appStore.setCurrentStatus(statusResult);
    }
    if (status == AttendanceStatus.checkIn) {
      trackingService.startTrackingService();
    } else {
      trackingService.stopTrackingService();
    }
    toast(
        'Successfully ${status == AttendanceStatus.checkIn ? 'checked in' : 'checked out'}');
    isInOutBtnLoading = false;
    return true;
  }

  @action
  refreshVisitsCount() async {
    isVisitsCountLoading = true;
    visitCount = await apiService.getVisitsCount();
    isVisitsCountLoading = false;
  }
}

enum AttendanceStatus { checkIn, checkOut, newStatus }

enum AttendanceType { geofence, ipAddress, none, qr, dynamicQr, face }
