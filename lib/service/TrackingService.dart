import 'dart:async';
import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../utils/app_constants.dart';
import 'offline_tracking_sync_service.dart';

class TrackingService {
  Battery battery = Battery();
  var uuid = Uuid();
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");

  updateDeviceStatusV2(
    Position position,
  ) async {
    log('$mainAppName 🔥BG Service: updateDeviceStatusV2 Called');

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.reload();
    var newValue = getIntAsync(locationCountPref) + 1;
    setValue(locationCountPref, newValue);

    log('$mainAppName 🔥BG Service: Shared Pref Updated >> New LC: $newValue');

    // Instantiate it
    var battery = Battery();
    var connectivityResult = await (Connectivity().checkConnectivity());
    var gpsStatus = await Geolocator.isLocationServiceEnabled();
    Map<String, dynamic> req = {
      "uid": uuid.v1(),
      "batteryPercentage": await battery.batteryLevel,
      "isGPSOn": gpsStatus,
      "isWifiOn": connectivityResult
          .any((element) => element == ConnectivityResult.wifi),
      "signalStrength": 5,
      "latitude": position.latitude,
      "longitude": position.longitude,
      "altitude": position.altitude,
      "horizontalAccuracy": 0,
      "verticalAccuracy": position.altitudeAccuracy,
      "course": position.heading,
      "courseAccuracy": position.headingAccuracy,
      "speed": position.speed,
      "speedAccuracy": position.speedAccuracy,
      "isCharging": await battery.batteryState == BatteryState.charging,
      "isMock": position.isMocked,
      "createdAt": dateFormat.format(DateTime.now())
    };

    log('$mainAppName 🔥BG Service: Device Status Update via API >>');
    await apiService.updateDeviceStatus(req).catchError((error) async {
      log('$mainAppName 🔥BG Service: Device Status Update >> Error in API Call >> $error');
      try {
        log('$mainAppName 🔥BG Service: Device Status Update >> Saving Locally >>');
        var json = jsonEncode(req);
        await OfflineTrackingSyncService.saveDeviceStatus(json);
        log('$mainAppName 🔥BG Service: Device Status Update >> Saved Locally >>');
      } catch (e) {
        log('Request: $req');
        log('$mainAppName 🔥BG Service: Device Status Update >> Error in Saving Locally >> $e');
      }
    });
  }

  Future updateAttendanceStatus(Activity activity) async {
    log('$mainAppName 🔥BG Service: updateAttendanceStatus Called');

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.reload();
    var newValue = getIntAsync(activityCountPref) + 1;
    setValue(activityCountPref, newValue);

    log('$mainAppName 🔥BG Service: Shared Pref Updated >> New AC: $newValue');

    var location = await Geolocator.getCurrentPosition();
    final connectivityResult = await (Connectivity().checkConnectivity());

    log('$mainAppName 🔥BG Service: Location from Geo >> ${location.toJson()}');

    int confidence = 0;
    switch (activity.confidence) {
      case ActivityConfidence.HIGH:
        confidence = 100;
        break;
      case ActivityConfidence.MEDIUM:
        confidence = 50;
        break;
      case ActivityConfidence.LOW:
        confidence = 20;
        break;
    }

    var gpsStatus = await Geolocator.isLocationServiceEnabled();

    Map<String, dynamic> req = {
      "uid": uuid.v1(),
      "status": "string",
      "accuracy": confidence,
      "activity": activity.type.toString(),
      "latitude": location.latitude,
      "longitude": location.longitude,
      "altitude": location.altitude,
      "locationAccuracy": location.accuracy,
      "speed": location.speed,
      "speedAccuracy": location.speedAccuracy,
      "bearing": 0,
      "time": location.timestamp.toString(),
      "isMock": location.isMocked,
      "batteryPercentage": await battery.batteryLevel,
      'isCharging': await battery.batteryState == BatteryState.charging,
      "isGPSOn": gpsStatus,
      "isWifiOn": connectivityResult
          .any((element) => element == ConnectivityResult.wifi),
      "signalStrength": 5,
      "createdAt": dateFormat.format(DateTime.now())
    };

    log('$mainAppName 🔥BG Service: Attendance Status Update via API >>');
    await apiService.updateAttendanceStatus(req).catchError((error) async {
      log('$mainAppName 🔥BG Service: Attendance Status Update>> Error in API Call >> $error');
      try {
        log('$mainAppName 🔥BG Service: Attendance Status Update>> Saving Locally >>');
        var json = jsonEncode(req);
        await OfflineTrackingSyncService.saveActivityStatus(json);
        log('$mainAppName 🔥BG Service: Attendance Status Saved Locally >>');
      } catch (e) {
        log('Request: $req');
        log('$mainAppName 🔥BG Service: Attendance Status Update>> Error in Saving Locally >> $e');
      }
    });
  }

  Future startTrackingService() async {
    var isLocationActivityTrackingEnabled =
        getBoolAsync(locationActivityTrackingEnabledPref);
    if (!isLocationActivityTrackingEnabled) {
      log('$mainAppName 🔥BG Service: Location Activity Tracking is Disabled');
      return;
    }
    log('$mainAppName 🔥BG Service: startTrackingService Called');
    setValue(isTrackingOnPref, true);
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      service.invoke("startService");
      service.startService();
    }

    log('$mainAppName 🔥BG Service: Service Started >> $isRunning');
  }

  Future stopTrackingService() async {
    log('$mainAppName 🔥BG Service: stopTrackingService Called');
    setValue(isTrackingOnPref, false);
    setValue(locationCountPref, 0);
    setValue(activityCountPref, 0);
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }

    log('$mainAppName 🔥BG Service: Service Stopped >> $isRunning');
  }
}
