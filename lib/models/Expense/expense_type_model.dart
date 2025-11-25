import 'package:hive/hive.dart';

part 'expense_type_model.g.dart';

@HiveType(typeId: 3)
class ExpenseTypeModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  bool? isImgRequired;

  ExpenseTypeModel({id, name, isImgRequired});

  ExpenseTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isImgRequired = json['isImgRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isImgRequired'] = isImgRequired;
    return data;
  }
}
