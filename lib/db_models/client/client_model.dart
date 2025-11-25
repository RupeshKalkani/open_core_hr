final String clientTable = 'client';

class ClientFields {
  static final List<String> values = [
    /// Add all fields
    id, clientId, clientName, createdAt
  ];

  static final String id = '_id';
  static final String clientId = 'clientId';
  static final String clientName = 'clientName';
  static final String createdAt = 'createdAt';
}

class Client {
  final int? id;
  final String clientId;
  final String clientName;
  final DateTime createdAt;

  const Client({
    this.id,
    required this.clientId,
    required this.clientName,
    required this.createdAt,
  });

  Client copy({
    int? id,
    String? clientId,
    String? clientName,
    DateTime? createdAt,
  }) =>
      Client(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        clientName: clientName ?? this.clientName,
        createdAt: createdAt ?? this.createdAt,
      );

  static Client fromJson(Map<String, Object?> json) => Client(
    id: json[ClientFields.id] as int?,
    clientId: json[ClientFields.clientId] as String,
    clientName: json[ClientFields.clientName] as String,
    createdAt: DateTime.parse(json[ClientFields.createdAt] as String),
  );

  Map<String, Object?> toJson() => {
    ClientFields.id: id,
    ClientFields.clientId: clientId,
    ClientFields.clientName: clientName,
    ClientFields.createdAt: createdAt.toIso8601String(),
  };
}