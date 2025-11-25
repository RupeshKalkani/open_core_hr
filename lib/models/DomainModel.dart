class TenantModel {
  final String tenantId;
  final String tenantName;
  final String domain;
  final List<String> domains;

  TenantModel({
    required this.tenantId,
    required this.tenantName,
    required this.domain,
    required this.domains,
  });

  // Factory constructor to create an instance from JSON
  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      tenantId: json['tenantId'] as String,
      tenantName: json['tenantName'] as String,
      domain: json['domain'] as String,
      domains: List<String>.from(json['domains']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'tenantName': tenantName,
      'domain': domain,
      'domains': domains,
    };
  }
}
