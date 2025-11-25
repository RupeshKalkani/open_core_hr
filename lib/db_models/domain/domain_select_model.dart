class DomainSelectModel {
  String? domainId;
  String? domainName;

  DomainSelectModel({this.domainId, this.domainName});

  DomainSelectModel.fromJson(Map<String, dynamic> json) {
    domainId = json['domainId'];
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['domainId'] = domainId;
    data['domainName'] = domainName;
    return data;
  }
}