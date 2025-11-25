/*
import 'package:open_core_hr/screens/Permission/activity_permission_screen.dart';
import 'package:open_core_hr/screens/navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/Permission/location_permission_screen.dart';

class PermissionService {
  Future<PermissionsEnum> getPermissionStatusAndroid() async {
    var locationPermission = await Geolocator.checkPermission();
    var activityPermission = await Permission.activityRecognition.isGranted;

    if (locationPermission != LocationPermission.always) {
      return PermissionsEnum.location;
    }
    if (!activityPermission) {
      return PermissionsEnum.activity;
    }

    return PermissionsEnum.all;
  }

  Future<bool> hasGrantedAll() async {
    var locationPermission = await Geolocator.checkPermission();
    var activityPermission = await Permission.activityRecognition.isGranted;

    if (locationPermission != LocationPermission.always) {
      return false;
    }
    if (!activityPermission) {
      return false;
    }

    return true;
  }

  Future<void> routeBasedOnPermission(BuildContext context) async {
    var permission = await getPermissionStatusAndroid();
    if (!context.mounted) return;
    if (permission == PermissionsEnum.all) {
      const NavigationScreen().launch(context, isNewTask: true);
    } else if (permission == PermissionsEnum.location) {
      const LocationPermissionScreen().launch(context, isNewTask: true);
    } else if (permission == PermissionsEnum.activity) {
      const ActivityPermissionScreen().launch(context, isNewTask: true);
    }
  }

  Future<PermissionStatusEnum> requestLocationPermissionAndroid() async {
    var result = await Permission.locationAlways.request();
    //toast(result.toString());
    if (result.isGranted) {
      return PermissionStatusEnum.granted;
    } else if (result.isPermanentlyDenied) {
      return PermissionStatusEnum.permanentlyDenied;
    } else {
      return PermissionStatusEnum.denied;
    }
  }

  Future checkNotificationPermissionAndroid() async {
    var result = await Permission.notification.status;
    //toast(result.toString());
    if (result.isDenied) {
      requestNotificationPermissionAndroid();
    }
  }

  Future requestNotificationPermissionAndroid() async {
    var result = await Permission.notification.request();
    //toast(result.toString());
  }

  Future<PermissionStatusEnum> requestActivityPermissionAndroid() async {
    var result = await Permission.activityRecognition.request();
    //toast(result.toString());
    if (result.isGranted) {
      return PermissionStatusEnum.granted;
    } else if (result.isDenied) {
      return PermissionStatusEnum.denied;
    } else {
      return PermissionStatusEnum.permanentlyDenied;
    }
  }

  Future<PermissionStatusEnum> requestActivityPermissionIOS() async {
    var result = await Permission.sensors.request();
    //toast(result.toString());
    if (result.isGranted) {
      return PermissionStatusEnum.granted;
    } else if (result.isDenied) {
      return PermissionStatusEnum.denied;
    } else {
      return PermissionStatusEnum.permanentlyDenied;
    }
  }

  Future<PermissionStatusEnum> requestLocationPermissionIOS() async {
    var result = await Permission.locationWhenInUse.request();
    //toast(result.toString());
    if (result.isGranted) {
      return PermissionStatusEnum.granted;
    } else if (result.isPermanentlyDenied) {
      return PermissionStatusEnum.permanentlyDenied;
    } else {
      return PermissionStatusEnum.denied;
    }
  }
}

enum PermissionsEnum { all, location, activity }

enum PermissionStatusEnum { denied, granted, permanentlyDenied }
*/

import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> hasGrantedAll() async {
    var locationPermission = await Geolocator.checkPermission();
    var activityPermission = await Permission.activityRecognition.isGranted;
    var notificationPermission = await Permission.notification.isGranted;

    if (locationPermission != LocationPermission.always) {
      return false;
    }
    if (!activityPermission) {
      return false;
    }
    if (!notificationPermission) {
      return false;
    }

    return true;
  }

  Future<PermissionStatusEnum> requestLocationPermissionAndroid() async {
    var result = await Permission.locationWhenInUse.request();
    toast(result.toString());
    if (result.isGranted) {
      var result2 = await Permission.locationAlways.request();
      if (result2.isGranted) {
        return PermissionStatusEnum.granted;
      } else if (result2.isPermanentlyDenied) {
        return PermissionStatusEnum.permanentlyDenied;
      } else {
        return PermissionStatusEnum.denied;
      }
    } else if (result.isPermanentlyDenied) {
      return PermissionStatusEnum.permanentlyDenied;
    } else {
      openAppSettings();
      return PermissionStatusEnum.denied;
    }
  }

  Future checkNotificationPermissionAndroid() async {
    var result = await Permission.notification.status;
    //toast(result.toString());
    if (result.isDenied) {
      requestNotificationPermissionAndroid();
    }
  }

  Future requestNotificationPermissionAndroid() async {
    var result = await Permission.notification.request();
    if (result.isGranted) {
      return true;
    }
    return false;
  }

  Future<PermissionStatusEnum> requestActivityPermissionAndroid() async {
    var result = await Permission.activityRecognition.request();
    toast(result.toString());
    if (result.isGranted) {
      return PermissionStatusEnum.granted;
    } else if (result.isDenied) {
      return PermissionStatusEnum.denied;
    } else {
      return PermissionStatusEnum.permanentlyDenied;
    }
  }

  Future<PermissionStatusEnum> requestActivityPermissionIOS() async {
    var result = await Permission.sensors.request();
    toast(result.toString());
    if (result.isGranted) {
      return PermissionStatusEnum.granted;
    } else if (result.isDenied) {
      return PermissionStatusEnum.denied;
    } else {
      return PermissionStatusEnum.permanentlyDenied;
    }
  }

  Future<PermissionStatusEnum> requestLocationPermissionIOS() async {
    var result = await Permission.locationWhenInUse.request();
    //toast(result.toString());
    if (result.isGranted) {
      return PermissionStatusEnum.granted;
    } else if (result.isPermanentlyDenied) {
      return PermissionStatusEnum.permanentlyDenied;
    } else {
      return PermissionStatusEnum.denied;
    }
  }
}

enum PermissionsEnum { all, location, activity, notification }

enum PermissionStatusEnum { denied, granted, permanentlyDenied }
