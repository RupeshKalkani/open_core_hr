class ProductCategoryModel {
  int? id;
  String? name;
  String? description;
  List<SubCategory?>? subCategories;

  ProductCategoryModel(
      {this.id, this.name, this.description, this.subCategories});

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    if (json['subCategories'] != null) {
      subCategories = <SubCategory>[];
      json['subCategories'].forEach((v) {
        subCategories!.add(SubCategory.fromJson(v));
      });
    }
  }
}

class SubCategory {
  int? id;
  String? name;
  String? description;
  int? parentId;

  SubCategory({this.id, this.name, this.description, this.parentId});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    parentId = json['parentId'];
  }
}
