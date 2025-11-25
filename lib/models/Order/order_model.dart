class OrderModel {
  int? id;
  String? orderNo;
  String? clientName;
  String? clientPhone;
  String? clientEmail;
  String? clientAddress;
  String? note;
  num? total;
  num? discount;
  num? tax;
  num? grandTotal;
  num? totalQuantity;
  String? adminRemarks;
  num? processedById;
  String? processedOn;
  num? completedById;
  String? completedOn;
  String? createdOn;
  String? status;
  List<OrderLine?>? orderLines;

  OrderModel(
      {this.id,
      this.orderNo,
      this.clientName,
      this.clientPhone,
      this.clientEmail,
      this.clientAddress,
      this.note,
      this.total,
      this.discount,
      this.tax,
      this.grandTotal,
      this.totalQuantity,
      this.adminRemarks,
      this.processedById,
      this.processedOn,
      this.completedById,
      this.completedOn,
      this.status,
      this.orderLines,
      this.createdOn});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['orderNo'];
    clientName = json['clientName'];
    clientPhone = json['clientPhone'];
    clientEmail = json['clientEmail'];
    clientAddress = json['clientAddress'];
    note = json['note'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
    grandTotal = json['grandTotal'];
    totalQuantity = json['totalQuantity'];
    adminRemarks = json['adminRemarks'];
    processedById = json['processedById'];
    processedOn = json['processedOn'];
    completedById = json['completedById'];
    completedOn = json['completedOn'];
    createdOn = json['createdOn'];
    status = json['status'];
    if (json['orderLines'] != null) {
      orderLines = <OrderLine>[];
      json['orderLines'].forEach((v) {
        orderLines!.add(OrderLine.fromJson(v));
      });
    }
  }
}

class OrderLine {
  int? id;
  int? orderId;
  int? productId;
  String? productName;
  int? quantity;
  num? price;
  num? total;
  num? discount;
  num? tax;

  OrderLine(
      {this.id,
      this.orderId,
      this.productId,
      this.productName,
      this.quantity,
      this.price,
      this.total,
      this.discount,
      this.tax});

  OrderLine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    productId = json['productId'];
    productName = json['productName'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
  }
}

class OrderResponse {
  int? totalCount;
  List<OrderModel>? values;

  OrderResponse({this.totalCount, this.values});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['values'] != null) {
      values = <OrderModel>[];
      json['values'].forEach((v) {
        values!.add(OrderModel.fromJson(v));
      });
    }
  }
}
