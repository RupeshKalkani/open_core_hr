class UserStatusModel {
  final int userId;
  final String status;
  final String? message;
  final String? expiresAt;

  UserStatusModel({
    required this.userId,
    required this.status,
    this.message,
    this.expiresAt,
  });

  // Factory to create UserStatusModel from JSON
  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
      userId: json['userId'],
      status: json['status'],
      message: json['message'],
      expiresAt: json['expiresAt'],
    );
  }

  // Convert UserStatusModel to JSON for updating status
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'expires_at': expiresAt,
    };
  }
}
