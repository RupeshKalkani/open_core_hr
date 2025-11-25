import 'package:hive/hive.dart';

part 'document_type_model.g.dart';

@HiveType(typeId: 4)
class DocumentTypeModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;

  DocumentTypeModel({this.id, this.name});

  DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
