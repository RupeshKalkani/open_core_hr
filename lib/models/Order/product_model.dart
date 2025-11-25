class ProductModel {
  int? id;
  String? name;
  String? productCode;
  String? description;
  String? status;
  int? productCategoryId;
  String? productCategoryName;
  num? basePrice;
  num? discount;
  num? tax;
  num? price;
  int? stocks;
  List<String?>? images;

  ProductModel(
      {this.id,
      this.name,
      this.productCode,
      this.description,
      this.status,
      this.productCategoryId,
      this.productCategoryName,
      this.basePrice,
      this.discount,
      this.tax,
      this.price,
      this.stocks,
      this.images});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productCode = json['productCode'];
    description = json['description'];
    status = json['status'];
    productCategoryId = json['productCategoryId'];
    productCategoryName = json['productCategoryName'];
    basePrice = json['basePrice'];
    discount = json['discount'];
    tax = json['tax'];
    price = json['price'];
    stocks = json['stocks'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images!.add(v);
      });
    }
  }
}
