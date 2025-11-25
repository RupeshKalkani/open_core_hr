import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart'; // Use a multi-select package
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/user.dart'; // Your User model
import 'package:open_core_hr/screens/Calendar/calendar_store.dart'; // Adjust path
import 'package:open_core_hr/utils/app_widgets.dart'; // Your common widgets

import '../../../main.dart';
import '../../../models/Client/client_model.dart';
import '../../Client/client_search.dart'; // For language, appStore

class EventAddEditSheet extends StatefulWidget {
  final CalendarStore store;

  const EventAddEditSheet({super.key, required this.store});

  @override
  State<EventAddEditSheet> createState() => _EventAddEditSheetState();
}

class _EventAddEditSheetState extends State<EventAddEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late CalendarStore _store; // Use widget.store

  @override
  void initState() {
    super.initState();
    _store = widget.store;
    // Initialize controllers with store values (happens when sheet is built)
    _store.titleController.text =
        _store.titleController.text; // No-op just to show pattern
    _store.locationController.text = _store.locationController.text;
    _store.descriptionController.text = _store.descriptionController.text;
  }

  // --- Open Client Search Screen ---
  Future<void> _openClientSearch() async {
    // Hide keyboard if open
    hideKeyboard(context);
    // Launch the client search screen and wait for result
    var result = await const ClientSearch()
        .launch(context); // Assuming ClientSearch returns ClientModel
    if (result != null && result is ClientModel) {
      // Update the store with the selected client
      _store.setSelectedClient(result);
    }
  }

  // --- Date/Time Picker Logic ---
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _store.selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101), // Adjust range
      helpText: 'Start Time',
      confirmText: language.lblOk,
      cancelText: language.lblCancel,
    );
    if (picked != null) {
      TimeOfDay? pickedTime;
      // If not all day, show time picker
      if (!_store.isAllDay) {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(
              _store.selectedStartDate ?? DateTime.now()),
          helpText: 'Start Time',
          confirmText: language.lblOk,
          cancelText: language.lblCancel,
        );
      }
      // Combine date and time (or use midnight if all day / time cancelled)
      final DateTime finalDateTime = DateTime(picked.year, picked.month,
          picked.day, pickedTime?.hour ?? 0, pickedTime?.minute ?? 0);
      _store.setStartDate(finalDateTime); // Update store
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime initial =
        _store.selectedEndDate ?? _store.selectedStartDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate:
          _store.selectedStartDate ?? DateTime(2000), // Ensure end >= start
      lastDate: DateTime(2101), helpText: 'End Date',
      confirmText: language.lblOk, cancelText: language.lblCancel,
    );
    if (picked != null) {
      TimeOfDay? pickedTime;
      if (!_store.isAllDay) {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initial),
          helpText: 'End Time',
          confirmText: language.lblOk,
          cancelText: language.lblCancel,
        );
      }
      final DateTime finalDateTime = DateTime(picked.year, picked.month,
          picked.day, pickedTime?.hour ?? 0, pickedTime?.minute ?? 0);
      _store.setEndDate(finalDateTime); // Update store
    }
  }

  // --- Color Picker Widget ---
  Widget _buildColorSelector() {
    return Observer(
        builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Color',
                    style: secondaryTextStyle()), // Assuming localization
                8.height,
                Wrap(
                  // Use Wrap for horizontal layout
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    // Default/Type Color Option
                    _buildColorRadio('',
                        isDefault: true), // Empty value for default
                    // Fixed Color Options
                    ..._store.fixedColors
                        .map((colorHex) => _buildColorRadio(colorHex))
                        .toList(),
                  ],
                ),
              ],
            ));
  }

  Widget _buildColorRadio(String colorHex, {bool isDefault = false}) {
    Color color = Colors.transparent;
    bool isSelected = _store.selectedColor == colorHex;

    if (!isDefault) {
      try {
        final colorValue = int.parse(colorHex.replaceAll('#', ''), radix: 16);
        color = Color(colorValue | 0xFF000000);
      } catch (e) {
        color = Colors.grey;
      } // Fallback color
    }

    return InkWell(
      onTap: () => _store.setSelectedColor(colorHex),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isDefault ? null : color,
          shape: BoxShape.circle,
          border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDefault ? Colors.grey : color),
              width: isSelected ? 3 : (isDefault ? 1 : 0)),
          gradient: isDefault
              ? const LinearGradient(
                  colors: [Colors.black26, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)
              : null,
        ),
        child: isDefault && !isSelected
            ? const Icon(Icons.block, size: 16, color: Colors.grey)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          context, _store.editingEventId != null ? 'Edit Event' : 'Add Event'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Fields using Observer for reactivity
                TextFormField(
                  controller: _store.titleController,
                  decoration:
                      newEditTextDecoration(Icons.title, language.lblTitle),
                  style: primaryTextStyle(),
                  validator: (s) =>
                      s.isEmptyOrNull ? 'Title is required' : null,
                ),
                16.height,

                Observer(
                    builder: (_) => DropdownButtonFormField<String>(
                          value: _store.eventTypes
                                  .contains(_store.selectedEventType)
                              ? _store.selectedEventType
                              : null, // Handle initial/invalid state
                          items: _store.eventTypes
                              .map((type) => DropdownMenuItem(
                                  value: type, child: Text(type)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) _store.selectedEventType = value;
                          },
                          decoration: newEditTextDecoration(
                              Icons.category_outlined, language.lblType),
                          style: primaryTextStyle(),
                          validator: (s) => s == null || s.isEmpty
                              ? 'Event type is required'
                              : null,
                        )),
                16.height,
                // Client Selection (Conditional)
                Observer(builder: (_) {
                  if (!_store.isClientAppointmentSelected)
                    return SizedBox.shrink(); // Hide if not client appointment

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Client*",
                          style:
                              secondaryTextStyle()), // Label for client section
                      4.height,
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: boxDecorationWithRoundedCorners(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _store.selectedClient?.name ??
                                    "Tap to select client...", // Show selected or placeholder
                                style: primaryTextStyle(
                                    color: _store.selectedClient == null
                                        ? Colors.grey.shade600
                                        : null),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.search, color: appStore.appColorPrimary),
                          ],
                        ),
                      ).onTap(() {
                        _openClientSearch(); // Open the search screen on tap
                      }),
                      // Hidden input simulation or validation based on _store.selectedClient
                      if (_store.isClientAppointmentSelected &&
                          _store.selectedClient == null)
                        Text("Client is required for this event type",
                                style: secondaryTextStyle(
                                    color: Colors.red, size: 12))
                            .paddingTop(4),
                      16.height,
                    ],
                  );
                }),
                16.height,
                Row(
                  children: [
                    Observer(
                        builder: (_) => TextFormField(
                              controller: TextEditingController(
                                  text: _store.selectedStartDate != null
                                      ? DateFormat('yyyy-MM-dd HH:mm')
                                          .format(_store.selectedStartDate!)
                                      : ''),
                              readOnly: true,
                              onTap: () => _selectStartDate(context),
                              decoration: newEditTextDecoration(
                                  Icons.calendar_today, 'Start Date'),
                              style: primaryTextStyle(),
                              validator: (s) => s.isEmptyOrNull
                                  ? 'Start date is required'
                                  : null,
                            )).expand(),
                    16.width,
                    Observer(
                        builder: (_) => TextFormField(
                              controller: TextEditingController(
                                  text: _store.selectedEndDate != null
                                      ? DateFormat('yyyy-MM-dd HH:mm')
                                          .format(_store.selectedEndDate!)
                                      : ''),
                              readOnly: true,
                              onTap: () => _selectEndDate(context),
                              decoration: newEditTextDecoration(
                                  Icons.calendar_today, 'End Date'),
                              style: primaryTextStyle(),
                            )).expand(),
                  ],
                ),
                16.height,

                Observer(
                    builder: (_) => CheckboxListTile(
                          title: Text('All day event'),
                          value: _store.isAllDay,
                          onChanged: (val) => _store.toggleAllDay(val ?? false),
                          contentPadding: EdgeInsets.zero,
                          activeColor: appStore.appColorPrimary,
                        )),
                16.height,

                // Attendee MultiSelect (Using multi_select_flutter package example)
                Observer(
                    builder: (_) => MultiSelectDialogField<User>(
                          items: _store.userList
                              .map((user) =>
                                  MultiSelectItem(user, user.fullName))
                              .toList(),
                          initialValue: _store.selectedAttendees
                              .toList(), // Needs to be List<User>
                          title: Text('Attendees'),
                          searchable: true,
                          buttonText: Text('Select Attendees'),
                          buttonIcon: Icon(Icons.people_outline),
                          chipDisplay: MultiSelectChipDisplay(
                            // Display selected items as chips
                            items: _store.selectedAttendees
                                .map((user) =>
                                    MultiSelectItem(user, user.fullName))
                                .toList(),
                            onTap: (value) {
                              _store.selectedAttendees.remove(value);
                            },
                          ),
                          onConfirm: (results) {
                            _store.updateSelectedAttendees(results);
                          },
                        )),

                16.height,
                TextFormField(
                  controller: _store.locationController,
                  decoration: newEditTextDecoration(
                      Icons.location_on_outlined, language.lblLocation),
                  style: primaryTextStyle(),
                ),
                16.height,
                TextFormField(
                  controller: _store.descriptionController,
                  decoration: newEditTextDecoration(
                    Icons.notes_outlined,
                    language.lblDescription,
                  ), // Using asLabel for multiline
                  maxLines: 3,
                  style: primaryTextStyle(),
                ),
                16.height,

                // Color Selector Widget
                _buildColorSelector(),
                32.height,

                // Submit Button
                Observer(
                  builder: (_) => AppButton(
                    text: _store.editingEventId != null
                        ? 'Update'
                        : language.lblSubmit,
                    color: appStore.appColorPrimary,
                    textColor: Colors.white,
                    width: context.width(), // Full width
                    shapeBorder: buildButtonCorner(),
                    enabled: !_store.isLoading, // Disable when loading
                    onTap: () async {
                      if (_formKey.currentState!.validate() &&
                          !_store.isLoading) {
                        // Re-validate client selection specifically
                        if (_store.isClientAppointmentSelected &&
                            _store.selectedClient == null) {
                          toast("Client is required for Client Appointments.");
                          return;
                        }
                        hideKeyboard(context);
                        bool success = await _store.saveEvent();
                        if (success && context.mounted) {
                          Navigator.pop(context, true);
                        } // Close sheet on success
                      } else if (!_store.isLoading) {
                        toast("Please fill all required fields.");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
