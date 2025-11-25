import 'package:hive/hive.dart';

import '../main.dart';

class OfflineTrackingSyncService {
  static const String _deviceStatusBox = 'deviceStatus';
  static const String _activityStatusBox = 'activityStatus';

  /// Initialize Hive Boxes
  static Future<void> initializeHive() async {
    await Hive.openBox<List<String>>(_deviceStatusBox);
    await Hive.openBox<List<String>>(_activityStatusBox);
  }

  /// Add Device Status Data to Local Storage
  static Future<void> saveDeviceStatus(String data) async {
    final box = Hive.box<List<String>>(_deviceStatusBox);
    final existingData = box.get('records', defaultValue: <String>[])!;
    existingData.add(data); // Add new data
    await box.put('records', existingData); // Save updated list
  }

  /// Add Activity Status Data to Local Storage
  static Future<void> saveActivityStatus(String data) async {
    final box = Hive.box<List<String>>(_activityStatusBox);
    final existingData = box.get('records', defaultValue: <String>[])!;
    existingData.add(data); // Add new data
    await box.put('records', existingData); // Save updated list
  }

  /// Retrieve all unsynced Device Status Data
  static List<String> getAllDeviceStatusData() {
    final box = Hive.box<List<String>>(_deviceStatusBox);
    return box.get('records',
        defaultValue: <String>[])!.cast<String>(); // Ensure proper casting
  }

  ///Get count of unsynced Device Status Data
  static int getDeviceStatusCount() {
    final box = Hive.box<List<String>>(_deviceStatusBox);
    return box.get('records', defaultValue: <String>[])!.length;
  }

  /// Retrieve all unsynced Activity Status Data
  static List<String> getAllActivityStatusData() {
    final box = Hive.box<List<String>>(_activityStatusBox);
    return box.get('records',
        defaultValue: <String>[])!.cast<String>(); // Ensure proper casting
  }

  ///Get count of unsynced Activity Status Data
  static int getActivityStatusCount() {
    final box = Hive.box<List<String>>(_activityStatusBox);
    return box.get('records', defaultValue: <String>[])!.length;
  }

  /// Sync Device Status Data
  static Future<void> syncDeviceStatus() async {
    final List<String> data = getAllDeviceStatusData();
    if (data.isEmpty) return;

    bool success = await apiService.bulkDeviceStatusUpdate(data);
    if (success) {
      final box = Hive.box<List<String>>(_deviceStatusBox);
      await box.delete('records'); // Clear all synced records
    }
  }

  /// Sync Activity Status Data
  static Future<void> syncActivityStatus() async {
    final List<String> data = getAllActivityStatusData();
    if (data.isEmpty) return;

    bool success = await apiService.bulkActivityStatusUpdate(data);
    if (success) {
      final box = Hive.box<List<String>>(_activityStatusBox);
      await box.delete('records'); // Clear all synced records
    }
  }

  /// Periodic Sync for Both Types of Data
  static Future<void> periodicSync() async {
    await syncDeviceStatus();
    await syncActivityStatus();
  }

  /// Delete All Records
  static Future<void> deleteAll() async {
    final deviceBox = Hive.box<List<String>>(_deviceStatusBox);
    final activityBox = Hive.box<List<String>>(_activityStatusBox);
    await deviceBox.clear();
    await activityBox.clear();
  }
}
