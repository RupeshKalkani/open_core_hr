const String trackingTable = 'trackings';

class TrackingFields {
  static final List<String> values = [
    /// Add all fields
    id, status, accuracy, latitude, longitude, altitude, bearing, locationAccuracy, speed, time, isMock, batteryPercentage, isGPSOn, isWifiOn, signalStrength, isSynced, createdAt
  ];

  static const String id = '_id';
  static const String status = 'status';
  static const String accuracy = 'accuracy';
  static const String activity = 'activity';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String altitude = 'altitude';
  static const String bearing = 'bearing';
  static const String locationAccuracy = 'locationAccuracy';
  static const String speed = 'speed';
  static const String time = 'time';
  static const String isMock = 'isMock';
  static const String batteryPercentage = 'batteryPercentage';
  static const String isGPSOn = 'isGPSOn';
  static const String isWifiOn = 'isWifiOn';
  static const String signalStrength = 'signalStrength';
  static const String isSynced = 'isSynced';
  static const String createdAt = 'createdAt';
}

class TrackingModel {
  final int? id;
  final String status;
  final String accuracy;
  final String activity;
  final String latitude;
  final String longitude;
  final int altitude;
  final int bearing;
  final int locationAccuracy;
  final int speed;
  final int time;
  final bool isMock;
  final String batteryPercentage;
  final bool isGPSOn;
  final bool isWifiOn;
  final int signalStrength;
  final bool isSynced;
  final String createdAt;

  const TrackingModel({
    this.id,
    required this.status,
    required this.accuracy,
    required this.activity,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.bearing,
    required this.locationAccuracy,
    required this.speed,
    required this.time,
    required this.isMock,
    required this.batteryPercentage,
    required this.isGPSOn,
    required this.isWifiOn,
    required this.signalStrength,
    required this.isSynced,
    required this.createdAt,
  });

  TrackingModel copy({
    int? id,
    String? status,
    String? accuracy,
    String? activity,
    String? latitude,
    String? longitude,
    int? altitude,
    int? bearing,
    int? locationAccuracy,
    int? speed,
    int? time,
    bool? isMock,
    String? batteryPercentage,
    bool? isGPSOn,
    bool? isWifiOn,
    int? signalStrength,
    bool? isSynced,
    String? createdAt,
  }) =>
      TrackingModel(
        id: id ?? this.id,
        status: status ?? this.status,
        accuracy: accuracy ?? this.accuracy,
        activity: activity ?? this.activity,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        altitude: altitude ?? this.altitude,
        bearing: bearing ?? this.bearing,
        locationAccuracy: locationAccuracy ?? this.locationAccuracy,
        speed: speed ?? this.speed,
        time: time ?? this.time,
        isMock: isMock ?? this.isMock,
        batteryPercentage: batteryPercentage ?? this.batteryPercentage,
        isGPSOn: isGPSOn ?? this.isGPSOn,
        isWifiOn: isWifiOn ?? this.isWifiOn,
        signalStrength: signalStrength ?? this.signalStrength,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt ?? this.createdAt,
      );

  static TrackingModel fromJson(Map<String, Object?> json) => TrackingModel(
    id: json[TrackingFields.id] as int?,
    status: json[TrackingFields.status] as String,
    accuracy: json[TrackingFields.accuracy] as String,
    activity: json[TrackingFields.activity] as String,
    latitude: json[TrackingFields.latitude] as String,
    longitude: json[TrackingFields.longitude] as String,
    altitude: json[TrackingFields.altitude] as int,
    bearing: json[TrackingFields.bearing] as int,
    locationAccuracy: json[TrackingFields.locationAccuracy] as int,
    speed: json[TrackingFields.speed] as int,
    time: json[TrackingFields.time] as int,
    isMock: json[TrackingFields.isMock] ==  1,
    batteryPercentage: json[TrackingFields.batteryPercentage] as String,
    isGPSOn: json[TrackingFields.isGPSOn] == 1,
    isWifiOn: json[TrackingFields.isWifiOn] == 1,
    signalStrength: json[TrackingFields.signalStrength] as int,
    isSynced: json[TrackingFields.isSynced] == 1,
    createdAt: json[TrackingFields.createdAt] as String,
  );

  Map<String, Object?> toJson() => {
    TrackingFields.id: id,
    TrackingFields.status: status,
    TrackingFields.accuracy: accuracy,
    TrackingFields.activity: activity,
    TrackingFields.latitude: latitude,
    TrackingFields.longitude: longitude,
    TrackingFields.altitude: altitude,
    TrackingFields.bearing: bearing,
    TrackingFields.locationAccuracy: locationAccuracy,
    TrackingFields.speed: speed,
    TrackingFields.time: time,
    TrackingFields.isMock: isMock ? 1 : 0,
    TrackingFields.batteryPercentage: batteryPercentage,
    TrackingFields.isGPSOn: isGPSOn ? 1 : 0,
    TrackingFields.isWifiOn: isWifiOn ? 1 : 0,
    TrackingFields.signalStrength: signalStrength,
    TrackingFields.isSynced: isSynced ? 1 : 0,
    TrackingFields.createdAt: createdAt,
  };
}