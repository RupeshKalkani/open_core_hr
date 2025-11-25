class ClientSelectModel {
  String? clientId;
  String? clientName;

  ClientSelectModel({this.clientId, this.clientName});

  ClientSelectModel.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    clientName = json['clientName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['clinetName'] = clientName;
    return data;
  }
}