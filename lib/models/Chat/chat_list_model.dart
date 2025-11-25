import 'package:hive/hive.dart';

part 'chat_list_model.g.dart';

@HiveType(typeId: 0)
class Chat {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  String? avatar;
  @HiveField(3)
  final String? lastMessage;
  @HiveField(4)
  final String updatedAt;
  @HiveField(5)
  final int? userId;
  @HiveField(6)
  final bool isGroupChat;

  Chat({
    required this.id,
    required this.name,
    this.avatar,
    this.lastMessage,
    required this.updatedAt,
    this.userId,
    required this.isGroupChat,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      avatar: json['avatar'],
      lastMessage: json['lastMessage'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      isGroupChat: json['isGroupChat'] ?? false,
    );
  }
}
