const String visitTable = 'visit';

class VisitFields {
  static final List<String> values = [
    /// Add all fields
    id, imageURL, comments, clientId, objective, product, quantity,
    prescription, observation
  ];

  static const String id = '_id';
  static const String imageURL = 'imageURL';
  static const String comments = 'comments';
  static const String clientId = 'clientId';
  static const String objective = 'objective';
  static const String product = 'product';
  static const String quantity = 'quantity';
  static const String prescription = 'prescription';
  static const String observation = 'observation';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String address = 'address';
  static const String isSynced = 'isSynced';
  static const String createdAt = 'createdAt';
}

class Visit {
  final int? id;
  final String imageURL;
  final String comments;
  final String clientId;
  final String objective;
  final String product;
  final String quantity;
  final String prescription;
  final String observation;
  final String latitude;
  final String longitude;
  final String address;
  final bool isSynced;
  final String createdAt;

  const Visit({
    this.id,
    required this.imageURL,
    required this.comments,
    required this.clientId,
    required this.objective,
    required this.product,
    required this.quantity,
    required this.prescription,
    required this.observation,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isSynced,
    required this.createdAt,
  });

  Visit copy({
    int? id,
    String? imageURL,
    String? comments,
    String? clientId,
    String? objective,
    String? product,
    String? quantity,
    String? prescription,
    String? observation,
    String? latitude,
    String? longitude,
    String? address,
    bool? isSynced,
    String? createdAt,
  }) =>
      Visit(
        id: id ?? this.id,
        imageURL: imageURL ?? this.imageURL,
        comments: comments ?? this.comments,
        clientId: clientId ?? this.clientId,
        objective: objective ?? this.objective,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
        prescription: prescription ?? this.prescription,
        observation: observation ?? this.observation,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt ?? this.createdAt,
      );

  static Visit fromJson(Map<String, Object?> json) => Visit(
        id: json[VisitFields.id] as int?,
        imageURL: json[VisitFields.imageURL] as String,
        comments: json[VisitFields.comments] as String,
        clientId: json[VisitFields.clientId] as String,
        objective: json[VisitFields.objective] as String,
        product: json[VisitFields.product] as String,
        quantity: json[VisitFields.quantity] as String,
        prescription: json[VisitFields.prescription] as String,
        observation: json[VisitFields.observation] as String,
        latitude: json[VisitFields.latitude] as String,
        longitude: json[VisitFields.longitude] as String,
        address: json[VisitFields.address] as String,
        isSynced: json[VisitFields.isSynced] == 1,
        createdAt: json[VisitFields.createdAt] as String,
      );

  Map<String, Object?> toJson() => {
        VisitFields.id: id,
        VisitFields.imageURL: imageURL,
        VisitFields.comments: comments,
        VisitFields.clientId: clientId,
        VisitFields.objective: objective,
        VisitFields.product: product,
        VisitFields.quantity: quantity,
        VisitFields.prescription: prescription,
        VisitFields.observation: observation,
        VisitFields.latitude: latitude,
        VisitFields.longitude: longitude,
        VisitFields.address: address,
        VisitFields.isSynced: isSynced ? 1 : 0,
        VisitFields.createdAt: createdAt,
      };
}
