final String domainTable = 'domain';

class DomainFields {
  static final List<String> values = [
    /// Add all fields
    id, domainId, domainName, createdAt
  ];

  static final String id = '_id';
  static final String domainId = 'domainId';
  static final String domainName = 'domainName';
  static final String createdAt = 'createdAt';
}

class Domain {
  final int? id;
  final String domainId;
  final String domainName;
  final DateTime createdAt;

  const Domain({
    this.id,
    required this.domainId,
    required this.domainName,
    required this.createdAt,
  });

  Domain copy({
    int? id,
    String? domainId,
    String? domainName,
    DateTime? createdAt,
  }) =>
      Domain(
        id: id ?? this.id,
        domainId: domainId ?? this.domainId,
        domainName: domainName ?? this.domainName,
        createdAt: createdAt ?? this.createdAt,
      );

  static Domain fromJson(Map<String, Object?> json) => Domain(
    id: json[DomainFields.id] as int?,
    domainId: json[DomainFields.domainId] as String,
    domainName: json[DomainFields.domainName] as String,
    createdAt: DateTime.parse(json[DomainFields.createdAt] as String),
  );

  Map<String, Object?> toJson() => {
    DomainFields.id: id,
    DomainFields.domainId: domainId,
    DomainFields.domainName: domainName,
    DomainFields.createdAt: createdAt.toIso8601String(),
  };
}