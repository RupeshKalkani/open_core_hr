import 'package:open_core_hr/models/Client/client_model.dart';

import '../Order/product_model.dart';

class CartModel {
  ClientModel? client;
  List<CartItemModel> cartItems = [];
  String? remarks;
}

class CartItemModel {
  int? id;

  ProductModel? product;

  int? quantity;

  num? total;

  CartItemModel({this.id, this.product, this.quantity, this.total});

  // CopyWith method to create a new instance with updated fields
  CartItemModel copyWith({
    int? id,
    ProductModel? product,
    int? quantity,
    double? total,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }
}
