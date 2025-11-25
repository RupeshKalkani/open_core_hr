import 'package:hive/hive.dart';

part 'notice_model.g.dart';

@HiveType(typeId: 1)
class NoticeModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? contents;
  @HiveField(3)
  String? createdAt;

  NoticeModel({
    this.id,
    this.title,
    this.contents,
    this.createdAt,
  });

  NoticeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    contents = json['contents'];
    createdAt = json['createdAt'];
  }
}
