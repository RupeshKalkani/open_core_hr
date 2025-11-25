class HolidayModel {
  final int id;
  final String name;
  final String date;
  final String createdAt;
  final String updatedAt;

  HolidayModel({
    required this.id,
    required this.name,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
        id: json['id'],
        name: json['name'],
        date: json['date'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );
}

class HolidayModelResponse {
  final int totalCount;
  final List<HolidayModel> values;

  HolidayModelResponse({
    required this.totalCount,
    required this.values,
  });

  factory HolidayModelResponse.fromJson(Map<String, dynamic> json) =>
      HolidayModelResponse(
        totalCount: json['totalCount'],
        values: (json['values'] as List)
            .map((item) => HolidayModel.fromJson(item))
            .toList(),
      );
}
