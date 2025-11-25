class VisitModel {
  int? id;
  String? clientName;
  String? clientAddress;
  String? clientPhoneNumber;
  String? clientEmail;
  String? clientContactPerson;
  String? visitImage;
  String? visitRemarks;
  String? visitDateTime;
  double? latitude;
  double? longitude;

  VisitModel({
    this.id,
    this.clientName,
    this.clientAddress,
    this.clientPhoneNumber,
    this.clientEmail,
    this.clientContactPerson,
    this.visitImage,
    this.visitRemarks,
    this.visitDateTime,
    this.latitude,
    this.longitude,
  });

  VisitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientName = json['clientName'];
    clientAddress = json['clientAddress'];
    clientPhoneNumber = json['clientPhoneNumber'];
    clientEmail = json['clientEmail'];
    clientContactPerson = json['clientContactPerson'];
    visitImage = json['visitImage'];
    visitRemarks = json['visitRemarks'];
    visitDateTime = json['visitDateTime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}

class VisitResponse {
  int? totalCount;
  List<VisitModel>? values;

  VisitResponse({this.totalCount, this.values});

  VisitResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['values'] != null) {
      values = <VisitModel>[];
      json['values'].forEach((v) {
        values!.add(VisitModel.fromJson(v));
      });
    }
  }
}
