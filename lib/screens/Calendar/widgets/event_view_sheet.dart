import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/calendar_event_model.dart';
import 'package:open_core_hr/screens/Calendar/calendar_store.dart'; // Adjust path
import 'package:open_core_hr/utils/app_widgets.dart'; // Your common widgets
import 'package:table_calendar/table_calendar.dart';

import '../../../main.dart'; // For language, appStore

class EventViewSheet extends StatelessWidget {
  final CalendarEventModel event;
  final CalendarStore store;
  final Function({CalendarEventModel event}) onEdit;

  const EventViewSheet(
      {super.key,
      required this.event,
      required this.store,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Helper to format dates/times nicely
    String formatEventTime(DateTime? start, DateTime? end, bool? allDay) {
      if (start == null) return 'N/A';
      // Use local time for display
      start = start.toLocal();
      end = end?.toLocal();

      if (allDay == true) {
        // Check if start and end fall on the same day (ignoring time) for "All Day" display
        if (end != null && !isSameDay(start, end)) {
          // If it spans multiple days, show range
          return '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end)} (All Day)';
        } else {
          // Single all-day event
          return '${DateFormat.yMMMd().format(start)} (All Day)';
        }
      }
      // Not All Day - include time
      String startTime = DateFormat.jm().format(start); // Time only
      String startDate = DateFormat.yMMMd().format(start); // Date only

      if (end == null) {
        return '$startDate, $startTime'; // Event with start time only
      }

      String endTime = DateFormat.jm().format(end);
      String endDate = DateFormat.yMMMd().format(end);

      if (isSameDay(start, end)) {
        return '$startDate, $startTime - $endTime'; // Same day
      } else {
        return '$startDate, $startTime - $endDate, $endTime'; // Spans across midnight
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important for bottom sheet
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event.title ?? 'Event Details',
                  style: boldTextStyle(size: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 24),

          // Details List
          _buildDetailRow(
              Icons.label_outline, "Type", event.eventType ?? 'N/A'),
          _buildDetailRow(Icons.access_time, "Time",
              formatEventTime(event.start, event.end, event.allDay)),
          if (event.clientName != null &&
              event.clientName!.isNotEmpty) // Show Client if present
            _buildDetailRow(
                Icons.business_center_outlined, "Client", event.clientName!),
          if (event.location != null && event.location!.isNotEmpty)
            _buildDetailRow(
                Icons.location_on_outlined, "Location", event.location!),
          if (event.meetingLink != null &&
              event.meetingLink!.isNotEmpty) // Show Meeting Link if present
            _buildDetailRow(Icons.link, "Meeting Link", event.meetingLink!,
                isLink: true), // Make it clickable
          if (event.description != null && event.description!.isNotEmpty)
            _buildDetailRow(
                Icons.notes_outlined, "Description", event.description!),

          // Attendee List
          if (event.attendees != null && event.attendees!.isNotEmpty) ...[
            16.height,
            Text('Attendees', style: boldTextStyle()),
            8.height,
            ConstrainedBox(
              // Limit height if list is long
              constraints: BoxConstraints(maxHeight: 150),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: event.attendees!.length,
                itemBuilder: (ctx, index) {
                  final attendee = event.attendees![index];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(attendee.avatar ??
                          ''), // Handle potential null avatar
                      onBackgroundImageError:
                          (_, __) {}, // Prevent crash on error
                      child: attendee.avatar == null
                          ? Text(
                              (attendee.name?.isNotEmpty ?? false)
                                  ? attendee.name![0].toUpperCase()
                                  : '?',
                              style: primaryTextStyle(color: white),
                            )
                          : null,
                    ),
                    title:
                        Text(attendee.name ?? 'N/A', style: primaryTextStyle()),
                    subtitle: Text(attendee.email ?? 'N/A',
                        style: secondaryTextStyle()),
                  );
                },
              ),
            )
          ],

          // Buttons
          32.height,
          Row(
            children: [
              AppButton(
                // Use your AppButton style
                color: Colors.red, // Or theme danger color
                text: 'Delete',
                textColor: Colors.white,
                width: 100,
                shapeBorder: buildButtonCorner(),
                onTap: () async {
                  // Show confirmation dialog
                  bool? confirm = await showConfirmDialogCustom(
                    context,
                    title: 'Confirm Delete',
                    positiveText: language.lblYes,
                    negativeText: language.lblNo,
                    dialogType: DialogType.CONFIRMATION,
                    onAccept: (BuildContext) async {
                      Navigator.pop(context); // Close view sheet first
                      bool deleted = await store.deleteEvent(event.id!);
                    },
                  );
                },
              ).expand(),
              16.width,
              AppButton(
                // Use your AppButton style
                color: appStore.appColorPrimary,
                text: 'Edit',
                textColor: Colors.white,
                width: 100,
                shapeBorder: buildButtonCorner(),
                onTap: () {
                  Navigator.pop(context);
                  // ---- CORRECTED CALL ----
                  onEdit(event: event); // Call the passed-in callback function
                },
              ).expand(),
            ],
          )
        ],
      ),
    );
  }

  // Helper to build detail rows
  Widget _buildDetailRow(IconData icon, String label, String value,
      {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          12.width,
          Expanded(
            // Allow label and value to take space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: secondaryTextStyle(size: 13)),
                4.height,
                if (isLink)
                  InkWell(
                    onTap: () => store
                        .launchExternalUrl(value), // Use helper from ApiService
                    child: Text(value,
                        style: primaryTextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline)),
                  )
                else
                  Text(value, style: primaryTextStyle(size: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
