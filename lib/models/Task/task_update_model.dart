class TaskUpdateModel {
  int? id;
  String? comment;
  double? latitude;
  double? longitude;
  String? address;
  String? fileUrl;
  bool? isFromAdmin;
  String? taskUpdateType;
  String? createdAt;

  TaskUpdateModel(
      {this.id,
      this.comment,
      this.latitude,
      this.longitude,
      this.address,
      this.fileUrl,
      this.isFromAdmin,
      this.taskUpdateType,
      this.createdAt});

  TaskUpdateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
    address = json['address'];
    fileUrl = json['fileUrl'];
    isFromAdmin = json['isFromAdmin'];
    taskUpdateType = json['taskUpdateType'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['fileUrl'] = fileUrl;
    data['isFromAdmin'] = isFromAdmin;
    data['taskUpdateType'] = taskUpdateType;
    data['createdAt'] = createdAt;
    return data;
  }
}
