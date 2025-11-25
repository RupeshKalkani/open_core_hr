import 'package:hive/hive.dart';

part 'leave_type_model.g.dart';

@HiveType(typeId: 2)
class LeaveTypeModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  bool? isImgRequired;

  LeaveTypeModel({this.id, this.name, this.isImgRequired});

  LeaveTypeModel.fromJson(Map<String, dynamic> json) {
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
