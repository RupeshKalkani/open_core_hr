import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/user.dart'; // Your User model
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../models/Client/client_model.dart';
import '../../models/calendar_event_model.dart'; // Import the event model

part 'calendar_store.g.dart'; // Run build_runner

class CalendarStore = CalendarStoreBase with _$CalendarStore;

abstract class CalendarStoreBase with Store {
  @observable
  bool isLoading = false;

  // Using LinkedHashMap for event storage, allows efficient lookup by day
  @observable
  ObservableMap<DateTime, List<CalendarEventModel>> eventsMap = ObservableMap();

  @observable
  DateTime focusedDay = DateTime.now();

  @observable
  DateTime? selectedDay;

  @observable
  DateTime? rangeStart; // For range selection if needed

  @observable
  DateTime? rangeEnd; // For range selection if needed

  @observable
  CalendarFormat calendarFormat = CalendarFormat.month;

  @observable
  ObservableList<User> userList =
      ObservableList(); // For attendee selection dropdown/search

// Use Enum values directly as strings or create a dedicated Enum in Dart
  @observable
  ObservableList<String> eventTypes = ObservableList.of([
    'Meeting', 'Training', 'Leave', 'Holiday', 'Deadline',
    'Company Event', 'Interview', 'Onboarding Session', 'Performance Review',
    'Client Appointment', 'Other'
    // Add all cases from App\Enums\EventType
  ]);

  // Map for default colors (keys should match Enum values)
  final Map<String, String> eventTypeColors = {
    'Meeting': '#007bff',
    'Training': '#ffc107',
    'Leave': '#6c757d',
    'Holiday': '#28a745',
    'Deadline': '#dc3545',
    'Company Event': '#17a2b8',
    'Interview': '#6f42c1',
    'Onboarding Session': '#fd7e14',
    'Performance Review': '#20c997',
    'Client Appointment': '#6610f2',
    'Other': '#6c757d'
  };
  final String defaultEventColor = '#6c757d';

  // Define Fixed Colors
  @observable
  ObservableList<String> fixedColors = ObservableList.of(
      ['#007bff', '#28a745', '#ffc107', '#dc3545', '#6f42c1']);

  // Form State Observables (for Add/Edit Sheet)
  @observable
  int? editingEventId; // To know if editing or adding

  @observable
  String selectedEventType = '';

  @observable
  String? selectedColor = ''; // Empty string for default/type color

  @observable
  DateTime? selectedStartDate;

  @observable
  DateTime? selectedEndDate;

  @observable
  bool isAllDay = false;

  @observable
  ObservableList<User> selectedAttendees = ObservableList();

  @observable
  ClientModel? selectedClient; // New: Store selected client object

  // Form Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController meetingLinkController = TextEditingController();

  // ---- Computed ----
  @computed
  List<CalendarEventModel> get selectedDayEvents {
    return getEventsForDay(selectedDay ?? focusedDay);
  }

  @computed
  bool get isClientAppointmentSelected {
    return selectedEventType == 'Client Appointment'; // Match Enum value string
  }

  // ---- Actions ----

  @action
  void onDaySelected(DateTime selected, DateTime focused) {
    if (!isSameDay(selectedDay, selected)) {
      selectedDay = selected;
      focusedDay = focused; // Update focused day as well
      rangeStart = null; // Clear range selection
      rangeEnd = null;
    }
  }

  @action
  void onRangeSelected(DateTime? start, DateTime? end, DateTime focused) {
    selectedDay = null; // Clear day selection
    focusedDay = focused;
    rangeStart = start;
    rangeEnd = end;
  }

  @action
  void onFormatChanged(CalendarFormat format) {
    if (calendarFormat != format) {
      calendarFormat = format;
    }
  }

  @action
  void onPageChanged(DateTime focused) {
    focusedDay = focused;
    // Fetch events for the new visible month/week
    // Determine the range based on the current format
    DateTime firstDay, lastDay;
    if (calendarFormat == CalendarFormat.month) {
      firstDay = DateTime(focused.year, focused.month, 1);
      lastDay = DateTime(focused.year, focused.month + 1, 0);
    } else if (calendarFormat == CalendarFormat.week) {
      // Calculate week boundaries based on focusedDay
      int weekday = focused.weekday; // Monday=1, Sunday=7
      firstDay = focused.subtract(Duration(days: weekday - 1));
      lastDay = focused.add(Duration(days: 7 - weekday));
    } else {
      // twoWeeks format if used, adjust as needed
      firstDay = DateTime(
          focused.year, focused.month, 1); // Default to month for other formats
      lastDay = DateTime(focused.year, focused.month + 1, 0);
    }
    // Add buffer days if needed for events spanning across month boundaries shown in view
    fetchEvents(
        firstDay.subtract(Duration(days: 7)), lastDay.add(Duration(days: 7)));
  }

  @action
  Future<void> fetchEvents(DateTime firstDay, DateTime lastDay) async {
    isLoading = true;
    try {
      var result = await apiService.getEvents(firstDay, lastDay);
      // Group events by date for table_calendar's eventLoader
      final Map<DateTime, List<CalendarEventModel>> groupedEvents = {};
      for (var event in result) {
        if (event.start != null) {
          // Normalize date to midnight UTC for reliable map keys
          DateTime dateKey = DateTime.utc(
              event.start!.year, event.start!.month, event.start!.day);
          if (groupedEvents[dateKey] == null) {
            groupedEvents[dateKey] = [];
          }
          groupedEvents[dateKey]!.add(event);

          // Handle multi-day events if necessary, adding to subsequent days
          if (event.end != null && !isSameDay(event.start, event.end)) {
            DateTime currentDay = event.start!.add(Duration(days: 1));
            while (currentDay.isBefore(event.end!) ||
                isSameDay(currentDay, event.end)) {
              DateTime nextDateKey = DateTime.utc(
                  currentDay.year, currentDay.month, currentDay.day);
              if (groupedEvents[nextDateKey] == null) {
                groupedEvents[nextDateKey] = [];
              }
              // Avoid adding duplicates if already processed
              if (!groupedEvents[nextDateKey]!.any((e) => e.id == event.id)) {
                groupedEvents[nextDateKey]!.add(event);
              }
              currentDay = currentDay.add(Duration(days: 1));
            }
          }
        }
      }
      eventsMap = ObservableMap.of(LinkedHashMap.from(groupedEvents));
    } catch (error) {
      log('Error fetching events: $error');
      // Show error to user?
    } finally {
      isLoading = false;
    }
  }

  // Helper to launch URLs (e.g., meeting links)
  Future<void> launchExternalUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      toast("No URL provided.");
      return;
    }
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      toast("Could not launch URL: $urlString");
    }
  }

  // Helper for table_calendar's eventLoader
  List<CalendarEventModel> getEventsForDay(DateTime day) {
    // Normalize the lookup key
    DateTime dateKey = DateTime.utc(day.year, day.month, day.day);
    return eventsMap[dateKey] ?? [];
  }

  // Load users for attendee selection
  @action
  Future<void> loadUsersForSelection() async {
    // You might want pagination or search here if the user list is large
    try {
      isLoading = true; // Use a different loading flag if needed
      var users = await apiService.getUsersForSelection(
          take: 200); // Fetch a reasonable number
      userList = ObservableList.of(users);
    } catch (e) {
      log("Error loading users: $e");
      toast("Could not load users for attendee selection.");
    } finally {
      isLoading = false;
    }
  }

  // Prepare store for adding a new event
  @action
  void prepareAddEvent([DateTime? selectedDate]) {
    editingEventId = null;
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    meetingLinkController.clear(); // Clear new field
    selectedEventType = eventTypes.isNotEmpty ? eventTypes.first : '';
    selectedColor = '';
    selectedStartDate = selectedDate ?? DateTime.now();
    // Set default end time (e.g., 1 hour after start)
    selectedEndDate = selectedDate?.add(const Duration(hours: 1)) ??
        DateTime.now().add(const Duration(hours: 1));
    isAllDay = selectedDate != null &&
        selectedDate.hour == 0 &&
        selectedDate.minute == 0;
    selectedAttendees.clear();
    selectedClient = null; // Clear selected client
  }

  // Prepare store for editing an existing event
  @action
  void prepareEditEvent(CalendarEventModel event) {
    editingEventId = event.id;
    titleController.text = event.title ?? '';
    descriptionController.text = event.description ?? '';
    locationController.text = event.location ?? '';
    meetingLinkController.text = event.meetingLink ?? ''; // Set meeting link
    selectedEventType =
        event.eventType ?? (eventTypes.isNotEmpty ? eventTypes.first : '');
    selectedColor = event.color ?? '';
    selectedStartDate = event.start;
    selectedEndDate = event.end;
    isAllDay = event.allDay ?? false;
    selectedAttendees = ObservableList.of(userList
        .where((u) => event.attendees?.any((att) => att.id == u.id) ?? false));
    // Set selected client for edit
    if (event.clientId != null && event.clientName != null) {
      // Create a temporary ClientModel or ensure userList contains ClientModel
      // If ClientSearch returns ClientModel, we can use it
      selectedClient = ClientModel(
          id: event.clientId,
          name: event.clientName); // Basic client model for display
    } else {
      selectedClient = null;
    }
  }

  // --- CRUD Actions ---

  @action
  Future<bool> saveEvent() async {
    isLoading = true;
    bool success = false;
    try {
      // Basic validation
      if (titleController.text.trim().isEmpty) {
        throw Exception('Title is required.');
      }
      if (selectedEventType.isEmpty) {
        throw Exception('Event Type is required.');
      }
      if (selectedStartDate == null) {
        throw Exception('Start Date is required.');
      }

      // Additional validation for client if type requires it
      if (isClientAppointmentSelected && selectedClient == null) {
        throw Exception('Client is required for Client Appointments.');
      }

      Map<String, dynamic> payload = {
        'eventTitle': titleController.text.trim(),
        'eventType': selectedEventType,
        'eventStart': selectedStartDate!.toIso8601String(),
        'eventEnd': (selectedEndDate != null && !isAllDay)
            ? selectedEndDate!.toIso8601String()
            : null,
        'allDay': isAllDay,
        'color': selectedColor,
        'attendeeIds': selectedAttendees.map((u) => u.id).toList(),
        'clientId': selectedClient?.id, // Send client ID
        'eventLocation': locationController.text.trim(),
        'eventDescription': descriptionController.text.trim(),
        'meetingLink': meetingLinkController.text.trim(), // Send meeting link
      };

      CalendarEventModel? result;
      if (editingEventId != null) {
        // Update
        result = await apiService.updateEvent(editingEventId!, payload);
      } else {
        // Create
        result = await apiService.createEvent(payload);
      }

      if (result != null) {
        toast(editingEventId != null
            ? 'Event updated successfully'
            : 'Event created successfully'); // Use localization
        success = true;
        // Refresh events for the current view
        onPageChanged(focusedDay); // Refetch based on focused day
      }
      editingEventId = null; // Reset editing state
    } catch (e) {
      log("Error saving event: $e");
      toast(e.toString()); // Show error message
      success = false;
    } finally {
      isLoading = false;
    }
    return success;
  }

  @action
  Future<bool> deleteEvent(int eventId) async {
    isLoading = true;
    bool success = false;
    try {
      success = await apiService.deleteEvent(eventId);
      if (success) {
        toast('Event deleted'); // Use localization
        // Refresh events
        onPageChanged(focusedDay);
      }
    } catch (e) {
      log("Error deleting event: $e");
      toast(e.toString());
      success = false;
    } finally {
      isLoading = false;
    }
    return success;
  }

  // Action to handle color selection from fixed choices
  @action
  void setSelectedColor(String? color) {
    selectedColor = color ?? ''; // Store empty string for default
  }

  // Action to set start date from picker
  @action
  void setStartDate(DateTime date) {
    selectedStartDate = date;
    // Optional: Adjust end date if it's before new start date
    if (selectedEndDate != null && selectedEndDate!.isBefore(date)) {
      selectedEndDate = date;
    }
  }

  // Action to set end date from picker
  @action
  void setEndDate(DateTime date) {
    selectedEndDate = date;
    // Optional: Adjust start date if it's after new end date
    if (selectedStartDate != null && selectedStartDate!.isAfter(date)) {
      selectedStartDate = date;
    }

    log('LLL: selected end date: ' + selectedEndDate.toString());
    log('LLL: is before: ' + selectedEndDate!.isBefore(date).toString());
  }

  @action
  void setSelectedClient(ClientModel? client) {
    // New action
    selectedClient = client;
  }

  @action
  void setSelectedEventType(String? type) {
    // New action
    if (type != null) {
      selectedEventType = type;
      // Clear client if type is not Client Appointment
      if (!isClientAppointmentSelected) {
        selectedClient = null;
      }
    }
  }

  // Action to toggle All Day
  @action
  void toggleAllDay(bool value) {
    isAllDay = value;
    // When toggling All Day OFF, ensure end date isn't null or same as start IF start exists
    if (!value && selectedStartDate != null) {
      if (selectedEndDate == null ||
          selectedEndDate!.isBefore(selectedStartDate!) ||
          isSameDay(selectedStartDate, selectedEndDate)) {
        // Set default end time (e.g., 1 hour after start) if it's invalid or same day
        selectedEndDate = selectedStartDate!.add(const Duration(hours: 1));
      }
    }
    // No need to clear time part when toggling OFF
    log("Toggled All Day: $isAllDay, Start: $selectedStartDate, End: $selectedEndDate"); // Log state after toggle
  }

  // Action to update selected attendees list
  @action
  void updateSelectedAttendees(List<User> attendees) {
    selectedAttendees = ObservableList.of(attendees);
  }

  // ---- Init ----
  void init() {
    final now = DateTime.now();
    // Use UTC for range boundaries consistent with event grouping keys
    final firstDayOfMonth = DateTime.utc(now.year, now.month, 1);
    final lastDayOfMonth = DateTime.utc(now.year, now.month + 1,
        0); // Day 0 of next month is last day of current
    fetchEvents(firstDayOfMonth.subtract(Duration(days: 7)),
        lastDayOfMonth.add(Duration(days: 7)));
    loadUsersForSelection();
    // Set default event type
    selectedEventType = eventTypes.isNotEmpty ? eventTypes.first : '';
  }
}
