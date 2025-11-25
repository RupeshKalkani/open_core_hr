import 'package:open_core_hr/models/Client/client_model.dart';

class PaymentCollectionModel {
  int? id;
  int? clientId;
  ClientModel? client;
  String? paymentType;
  num? amount;
  String? remarks;
  String? createdAt;

  PaymentCollectionModel(
      {this.id,
      this.clientId,
      this.client,
      this.paymentType,
      this.amount,
      this.remarks,
      this.createdAt});

  PaymentCollectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    client =
        json['client'] != null ? ClientModel?.fromJson(json['client']) : null;
    paymentType = json['paymentType'];
    amount = json['amount'];
    remarks = json['remarks'];
    createdAt = json['createdAt'];
  }
}

class PaymentCollectionModelResponse {
  int? totalCount;
  List<PaymentCollectionModel>? values;

  PaymentCollectionModelResponse({this.totalCount, this.values});

  PaymentCollectionModelResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['values'] != null) {
      values = <PaymentCollectionModel>[];
      json['values'].forEach((v) {
        values!.add(PaymentCollectionModel.fromJson(v));
      });
    }
  }
}
