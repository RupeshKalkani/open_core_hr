import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/Calendar/calendar_store.dart'; // Adjust import path
import 'package:open_core_hr/screens/Calendar/widgets/event_add_edit_sheet.dart'; // Create this widget
import 'package:open_core_hr/screens/Calendar/widgets/event_view_sheet.dart'; // Create this widget
import 'package:open_core_hr/utils/app_widgets.dart'; // Your common widgets
import 'package:table_calendar/table_calendar.dart';

import '../../main.dart'; // For language, appStore etc.
import '../../models/calendar_event_model.dart'; // Event model

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarStore _store = CalendarStore();

  @override
  void initState() {
    super.initState();
    _store.init(); // Fetch initial data
  }

  // Function to show event details bottom sheet
  void _showEventDetails(CalendarEventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to take more height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EventViewSheet(
        event: event,
        store: _store,
        onEdit: _showAddEditSheet,
      ), // Pass event and store
    );
  }

  // Function to show add/edit bottom sheet
  void _showAddEditSheet({DateTime? selectedDate, CalendarEventModel? event}) {
    if (event != null) {
      _store.prepareEditEvent(event); // Prepare store for editing
    } else {
      _store.prepareAddEvent(selectedDate); // Prepare store for adding
    }

    EventAddEditSheet(store: _store).launch(context).then((value) {
      if (value == true) {
        // Check if sheet indicated success
        _store.onPageChanged(_store.focusedDay);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Calendar', hideBack: true),
      body: Observer(
        // Observe store changes
        builder: (_) => Column(
          children: [
            TableCalendar<CalendarEventModel>(
              firstDay: DateTime.utc(2010, 1, 1), // Adjust range as needed
              lastDay: DateTime.utc(2040, 12, 31),
              focusedDay: _store.focusedDay,
              selectedDayPredicate: (day) => isSameDay(_store.selectedDay, day),
              rangeStartDay: _store.rangeStart,
              rangeEndDay: _store.rangeEnd,
              calendarFormat: _store.calendarFormat,
              rangeSelectionMode: RangeSelectionMode
                  .toggledOff, // Or toggledOn if you need range selection
              eventLoader: _store.getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday, // Or sunday
              calendarStyle: CalendarStyle(
                // Customize appearance if needed
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: appStore.appColorPrimary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: appStore.appColorPrimary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                  formatButtonVisible: true, // Show Month/Week toggle
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: appStore.appColorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  formatButtonTextStyle:
                      primaryTextStyle(color: appStore.appColorPrimary)),
              onDaySelected: _store.onDaySelected,
              onRangeSelected: _store.onRangeSelected,
              onFormatChanged: _store.onFormatChanged,
              onPageChanged: _store.onPageChanged,
              // --- Builder for event markers ---
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      // Example marker: dot below date
                      right: 1,
                      bottom: 1,
                      child: _buildEventsMarker(date, events),
                    );
                  }
                  return null;
                },
              ),
              // --- Handle tapping on a day with events ---
              // Note: onDaySelected is already handled. You might want to show
              // a list below the calendar for the selected day's events instead
              // of relying solely on markers. Or handle tap on markers.
            ),
            const Divider(),
            // --- List of events for the selected day ---
            Expanded(
              child: _store.isLoading && _store.selectedDayEvents.isEmpty
                  ? loadingWidgetMaker() // Show loading indicator
                  : _store.selectedDayEvents.isEmpty
                      ? Center(
                          child: Text(
                              'No events for the selected date')) // Show no events message
                      : ListView.builder(
                          itemCount: _store.selectedDayEvents.length,
                          itemBuilder: (context, index) {
                            final event = _store.selectedDayEvents[index];
                            return ListTile(
                              leading: Icon(Icons.circle,
                                  size: 12, color: _getEventColor(event)),
                              title: Text(event.title ?? 'No Title'),
                              subtitle: Text(DateFormat.jm()
                                      .format(event.start!) + // Format time
                                  (event.end != null
                                      ? ' - ${DateFormat.jm().format(event.end!)}'
                                      : '')),
                              onTap: () => _showEventDetails(
                                  event), // Show details on tap
                              dense: true,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appStore.appColorPrimary,
        onPressed: () => _showAddEditSheet(
            selectedDate:
                _store.selectedDay ?? DateTime.now()), // Open add sheet
        label: Row(
          children: [
            Icon(Icons.add, color: white),
            5.width,
            Text(language.lblCreate, style: primaryTextStyle(color: white))
          ],
        ),
      ),
    );
  }

  // Helper to build event markers (e.g., dots)
  Widget _buildEventsMarker(DateTime date, List<CalendarEventModel> events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appStore
            .appColorPrimary, // Use a consistent color or based on events
      ),
      width: 5.0,
      height: 5.0,
    );
  }

  // Helper to get event color for list tile
  Color _getEventColor(CalendarEventModel event) {
    final manualColorHex = event.color;
    final manualColor = event.color;
    final eventType = event.eventType;
    String? typeColorHex =
        _store.eventTypeColors[eventType ?? '']; // Access store map

    Color finalColor = Colors.grey.shade600; // Default

    try {
      String? colorToParse = manualColor != null && manualColor.isNotEmpty
          ? manualColor
          : typeColorHex;
      if (colorToParse != null && colorToParse.isNotEmpty) {
        // Ensure # prefix and correct length
        colorToParse =
            colorToParse.startsWith('#') ? colorToParse : '#$colorToParse';
        if (colorToParse.length == 7) {
          // #RRGGBB
          final colorValue = int.parse(colorToParse.substring(1), radix: 16);
          finalColor = Color(colorValue | 0xFF000000); // Add alpha
        } else if (colorToParse.length == 4) {
          // #RGB
          final r = colorToParse[1];
          final g = colorToParse[2];
          final b = colorToParse[3];
          final colorValue = int.parse('$r$r$g$g$b$b', radix: 16);
          finalColor = Color(colorValue | 0xFF000000);
        }
      }
    } catch (e) {
      log("Error parsing color for event ${event.id}: $e");
      // Keep default grey if parsing fails
    }
    return finalColor;
  }
}
