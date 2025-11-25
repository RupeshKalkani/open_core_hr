class ChatFile {
  final String filePath;
  final String fileType;
  final String fileExtension;
  final String fileSize;
  final String fileName;

  ChatFile(
      {required this.filePath,
      required this.fileType,
      required this.fileExtension,
      required this.fileSize,
      required this.fileName});

  factory ChatFile.fromJson(Map<String, dynamic> json) {
    return ChatFile(
      filePath: json['filePath'],
      fileType: json['fileType'],
      fileExtension: json['fileExtension'],
      fileSize: json['fileSize'],
      fileName: json['fileName'],
    );
  }
}

class ChatMessage {
  int id;
  final int userId;
  final String content;
  final String messageType;
  final String createdAt;
  final String createdAtHuman;
  final String userName;
  final String time;
  final ChatFile? file; // For files and images

  ChatMessage({
    required this.id,
    required this.userId,
    required this.content,
    required this.messageType,
    required this.createdAt,
    required this.createdAtHuman,
    required this.userName,
    required this.time,
    this.file,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      userId: json['userId'],
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      createdAt: json['createdAt'] ?? '',
      createdAtHuman: json['createdAtHuman'] ?? '',
      userName: json['userName'] ?? '',
      time: json['time'] ?? '',
      file: json['file'] != null ? ChatFile.fromJson(json['file']) : null,
    );
  }
}

class ChatResponse {
  int? totalCount;
  List<ChatMessage>? values;

  ChatResponse({this.totalCount, this.values});

  ChatResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['values'] != null) {
      values = <ChatMessage>[];
      json['values'].forEach((v) {
        values!.add(ChatMessage.fromJson(v));
      });
    }
  }
}
