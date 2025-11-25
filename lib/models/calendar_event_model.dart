// Model representing the structure returned by the API's getAll method
class CalendarEventModel {
  int? id;
  String? title;
  String? description;
  DateTime? start; // Changed from String to DateTime for easier handling
  DateTime? end; // Changed from String to DateTime
  bool? allDay;
  String? color; // Manual color override (#hex)
  String? eventType; // Enum value as string (e.g., 'Client Appointment')
  String? location;
  String? meetingLink; // New field
  int? clientId; // New field
  String? clientName; // New field
  DateTime? createdAt; // Changed from String
  DateTime? updatedAt; // Changed from String
  EventCreator? createdBy;
  List<EventAttendee>? attendees;
  String? tenantId;
  List<int>? attendeeIds; // Helper from original parsing, maybe keep

  CalendarEventModel({
    this.id,
    this.title,
    this.description,
    this.start,
    this.end,
    this.allDay,
    this.color,
    this.eventType,
    this.location,
    this.meetingLink,
    this.clientId,
    this.clientName,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.attendees,
    this.tenantId,
    this.attendeeIds,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse dates
    DateTime? _parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString)
            .toLocal(); // Parse ISO string and convert to local
      } catch (e) {
        print("Error parsing date: $dateString - $e");
        return null;
      }
    }

    return CalendarEventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      start: _parseDate(json['start']), // Parse ISO string from API
      end: _parseDate(json['end']), // Parse ISO string from API
      allDay: json['allDay'],
      color: json['color'],
      eventType: json['eventType'],
      location: json['location'],
      meetingLink: json['meetingLink'], // New field
      clientId: json['clientId'], // New field
      clientName: json['clientName'], // New field
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      createdBy: json['createdBy'] != null
          ? EventCreator.fromJson(json['createdBy'])
          : null,
      attendees: json['attendees'] != null
          ? List<EventAttendee>.from(
              json['attendees'].map((x) => EventAttendee.fromJson(x)))
          : [],
      tenantId: json['tenantId'],
      // Keep attendeeIds if still useful, though attendees list is preferred
      attendeeIds: json['attendeeIds'] != null
          ? List<int>.from(json['attendeeIds'])
          : [],
    );
  }
}

// Simple model for creator info if needed
class EventCreator {
  int? id;
  String? name;

  EventCreator({this.id, this.name});

  factory EventCreator.fromJson(Map<String, dynamic> json) {
    return EventCreator(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Simple model for attendee info from API response
class EventAttendee {
  int? id;
  String? name;
  String? email;
  String? avatar; // URL

  EventAttendee({this.id, this.name, this.email, this.avatar});

  factory EventAttendee.fromJson(Map<String, dynamic> json) {
    return EventAttendee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'], // Expecting full URL from API mapping
    );
  }
}
