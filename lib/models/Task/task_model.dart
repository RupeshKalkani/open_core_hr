import 'package:open_core_hr/models/Client/client_model.dart';

class TaskModel {
  int? id;
  String? title;
  String? description;
  String? taskType;
  int? assignedById;
  int? clientId;
  ClientModel? client;
  double? latitude;
  double? longitude;
  bool? isGeoFenceEnabled;
  int? maxRadius;
  String? startDateTime;
  String? endDateTime;
  String? status;
  String? forDate;

  TaskModel(
      {this.id,
      this.title,
      this.description,
      this.taskType,
      this.assignedById,
      this.clientId,
      this.client,
      this.latitude,
      this.longitude,
      this.isGeoFenceEnabled,
      this.maxRadius,
      this.startDateTime,
      this.endDateTime,
      this.status,
      this.forDate});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    taskType = json['taskType'];
    assignedById = json['assignedById'];
    clientId = json['clientId'];
    client =
        json['client'] != null ? ClientModel?.fromJson(json['client']) : null;
    // latitude = double.parse(json['latitude']);
    latitude = json['latitude'];
    // longitude = double.parse(json['longitude']);
    longitude = json['longitude'];
    isGeoFenceEnabled = json['isGeoFenceEnabled'];
    maxRadius = json['maxRadius'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    status = json['status'];
    forDate = json['forDate'];
  }
}
