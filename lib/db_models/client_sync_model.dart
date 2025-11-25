const String clientSyncTable = 'clientSync';

class ClientSyncFields {
  static final List<String> values = [
    /// Add all fields
    id, name, address, latitude, longitude, phoneNumber, remarks, email, city,
    domain, product, lastOrderedDate, quantityOrdered, isSynced, createdAt
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String address = 'address';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String phoneNumber = 'phoneNumber';
  static const String remarks = 'remarks';
  static const String email = 'email';
  static const String city = 'city';
  static const String domain = 'domain';
  static const String lastOrderedDate = 'lastOrderedDate';
  static const String quantityOrdered = 'quantityOrdered';
  static const String product = 'product';
  static const String isSynced = 'isSynced';
  static const String createdAt = 'createdAt';
}

class ClientSync {
  final int? id;
  final String name;
  final String address;
  final String latitude;
  final String longitude;
  final String phoneNumber;
  final String email;
  final String city;
  final String product;
  final int domain;
  final String lastOrderedDate;
  final int quantityOrdered;
  final String remarks;
  final bool isSynced;
  final String createdAt;

  const ClientSync({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.city,
    required this.product,
    required this.remarks,
    required this.domain,
    required this.lastOrderedDate,
    required this.quantityOrdered,
    required this.isSynced,
    required this.createdAt,
  });

  ClientSync copy({
    int? id,
    String? name,
    String? address,
    String? latitude,
    String? longitude,
    String? phoneNumber,
    String? email,
    String? city,
    String? product,
    String? remarks,
    int? domain,
    String? lastOrderedDate,
    int? quantityOrdered,
    bool? isSynced,
    String? createdAt,
  }) =>
      ClientSync(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        city: city ?? this.city,
        product: product ?? this.product,
        remarks: remarks ?? this.remarks,
        domain: domain ?? this.domain,
        lastOrderedDate: lastOrderedDate ?? this.lastOrderedDate,
        quantityOrdered: quantityOrdered ?? this.quantityOrdered,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt ?? this.createdAt,
      );

  static ClientSync fromJson(Map<String, Object?> json) => ClientSync(
        id: json[ClientSyncFields.id] as int?,
        name: json[ClientSyncFields.name] as String,
        address: json[ClientSyncFields.address] as String,
        latitude: json[ClientSyncFields.latitude] as String,
        longitude: json[ClientSyncFields.longitude] as String,
        phoneNumber: json[ClientSyncFields.phoneNumber] as String,
        remarks: json[ClientSyncFields.remarks] as String,
        email: json[ClientSyncFields.email] as String,
        city: json[ClientSyncFields.city] as String,
        product: json[ClientSyncFields.product] as String,
        domain: json[ClientSyncFields.domain] as int,
        lastOrderedDate: json[ClientSyncFields.lastOrderedDate] as String,
        quantityOrdered: json[ClientSyncFields.quantityOrdered] as int,
        isSynced: json[ClientSyncFields.isSynced] == 1,
        createdAt: json[ClientSyncFields.createdAt] as String,
      );

  Map<String, Object?> toJson() => {
        ClientSyncFields.id: id,
        ClientSyncFields.name: name,
        ClientSyncFields.address: address,
        ClientSyncFields.latitude: latitude,
        ClientSyncFields.longitude: longitude,
        ClientSyncFields.phoneNumber: phoneNumber,
        ClientSyncFields.email: email,
        ClientSyncFields.city: city,
        ClientSyncFields.product: product,
        ClientSyncFields.remarks: remarks,
        ClientSyncFields.domain: domain,
        ClientSyncFields.lastOrderedDate: lastOrderedDate,
        ClientSyncFields.quantityOrdered: quantityOrdered,
        ClientSyncFields.isSynced: isSynced ? 1 : 0,
        ClientSyncFields.createdAt: createdAt,
      };
}
