import 'dart:convert';

class NotificationModel {
  int? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  MessageData? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;
  String? createdAtHuman;
  String? typeRaw;

  NotificationModel(
      {this.id,
      this.type,
      this.notifiableType,
      this.notifiableId,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt,
      this.typeRaw});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiableType'];
    notifiableId = json['notifiableId'];
    data = json['data'] != null
        ? MessageData?.fromJson(jsonDecode(json['data']))
        : null;
    readAt = json['readAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAtHuman = json['createdAtHuman'];
    typeRaw = json['typeRaw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['notifiableType'] = notifiableType;
    data['notifiableId'] = notifiableId;
    data['data'] = MessageData().toJson();
    data['readAt'] = readAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['updatedAtHuman'] = createdAtHuman;
    data['typeRaw'] = typeRaw;
    return data;
  }
}

class MessageData {
  int? userid;
  String? message;
  String? title;

  MessageData({this.userid, this.message});

  MessageData.fromJson(Map<String, dynamic> json) {
    userid = json['user_id'];
    title = json['title'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userid;
    data['message'] = message;
    data['title'] = title;
    return data;
  }
}

class NotificationResponse {
  int? totalCount;
  List<NotificationModel>? values;

  NotificationResponse({this.totalCount, this.values});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      values = <NotificationModel>[];
      json['items'].forEach((v) {
        values!.add(NotificationModel.fromJson(v));
      });
    }
  }
}
