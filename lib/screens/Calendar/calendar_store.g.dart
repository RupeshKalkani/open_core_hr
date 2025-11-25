// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CalendarStore on CalendarStoreBase, Store {
  Computed<List<CalendarEventModel>>? _$selectedDayEventsComputed;

  @override
  List<CalendarEventModel> get selectedDayEvents =>
      (_$selectedDayEventsComputed ??= Computed<List<CalendarEventModel>>(
              () => super.selectedDayEvents,
              name: 'CalendarStoreBase.selectedDayEvents'))
          .value;
  Computed<bool>? _$isClientAppointmentSelectedComputed;

  @override
  bool get isClientAppointmentSelected =>
      (_$isClientAppointmentSelectedComputed ??= Computed<bool>(
              () => super.isClientAppointmentSelected,
              name: 'CalendarStoreBase.isClientAppointmentSelected'))
          .value;

  late final _$isLoadingAtom =
      Atom(name: 'CalendarStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$eventsMapAtom =
      Atom(name: 'CalendarStoreBase.eventsMap', context: context);

  @override
  ObservableMap<DateTime, List<CalendarEventModel>> get eventsMap {
    _$eventsMapAtom.reportRead();
    return super.eventsMap;
  }

  @override
  set eventsMap(ObservableMap<DateTime, List<CalendarEventModel>> value) {
    _$eventsMapAtom.reportWrite(value, super.eventsMap, () {
      super.eventsMap = value;
    });
  }

  late final _$focusedDayAtom =
      Atom(name: 'CalendarStoreBase.focusedDay', context: context);

  @override
  DateTime get focusedDay {
    _$focusedDayAtom.reportRead();
    return super.focusedDay;
  }

  @override
  set focusedDay(DateTime value) {
    _$focusedDayAtom.reportWrite(value, super.focusedDay, () {
      super.focusedDay = value;
    });
  }

  late final _$selectedDayAtom =
      Atom(name: 'CalendarStoreBase.selectedDay', context: context);

  @override
  DateTime? get selectedDay {
    _$selectedDayAtom.reportRead();
    return super.selectedDay;
  }

  @override
  set selectedDay(DateTime? value) {
    _$selectedDayAtom.reportWrite(value, super.selectedDay, () {
      super.selectedDay = value;
    });
  }

  late final _$rangeStartAtom =
      Atom(name: 'CalendarStoreBase.rangeStart', context: context);

  @override
  DateTime? get rangeStart {
    _$rangeStartAtom.reportRead();
    return super.rangeStart;
  }

  @override
  set rangeStart(DateTime? value) {
    _$rangeStartAtom.reportWrite(value, super.rangeStart, () {
      super.rangeStart = value;
    });
  }

  late final _$rangeEndAtom =
      Atom(name: 'CalendarStoreBase.rangeEnd', context: context);

  @override
  DateTime? get rangeEnd {
    _$rangeEndAtom.reportRead();
    return super.rangeEnd;
  }

  @override
  set rangeEnd(DateTime? value) {
    _$rangeEndAtom.reportWrite(value, super.rangeEnd, () {
      super.rangeEnd = value;
    });
  }

  late final _$calendarFormatAtom =
      Atom(name: 'CalendarStoreBase.calendarFormat', context: context);

  @override
  CalendarFormat get calendarFormat {
    _$calendarFormatAtom.reportRead();
    return super.calendarFormat;
  }

  @override
  set calendarFormat(CalendarFormat value) {
    _$calendarFormatAtom.reportWrite(value, super.calendarFormat, () {
      super.calendarFormat = value;
    });
  }

  late final _$userListAtom =
      Atom(name: 'CalendarStoreBase.userList', context: context);

  @override
  ObservableList<User> get userList {
    _$userListAtom.reportRead();
    return super.userList;
  }

  @override
  set userList(ObservableList<User> value) {
    _$userListAtom.reportWrite(value, super.userList, () {
      super.userList = value;
    });
  }

  late final _$eventTypesAtom =
      Atom(name: 'CalendarStoreBase.eventTypes', context: context);

  @override
  ObservableList<String> get eventTypes {
    _$eventTypesAtom.reportRead();
    return super.eventTypes;
  }

  @override
  set eventTypes(ObservableList<String> value) {
    _$eventTypesAtom.reportWrite(value, super.eventTypes, () {
      super.eventTypes = value;
    });
  }

  late final _$fixedColorsAtom =
      Atom(name: 'CalendarStoreBase.fixedColors', context: context);

  @override
  ObservableList<String> get fixedColors {
    _$fixedColorsAtom.reportRead();
    return super.fixedColors;
  }

  @override
  set fixedColors(ObservableList<String> value) {
    _$fixedColorsAtom.reportWrite(value, super.fixedColors, () {
      super.fixedColors = value;
    });
  }

  late final _$editingEventIdAtom =
      Atom(name: 'CalendarStoreBase.editingEventId', context: context);

  @override
  int? get editingEventId {
    _$editingEventIdAtom.reportRead();
    return super.editingEventId;
  }

  @override
  set editingEventId(int? value) {
    _$editingEventIdAtom.reportWrite(value, super.editingEventId, () {
      super.editingEventId = value;
    });
  }

  late final _$selectedEventTypeAtom =
      Atom(name: 'CalendarStoreBase.selectedEventType', context: context);

  @override
  String get selectedEventType {
    _$selectedEventTypeAtom.reportRead();
    return super.selectedEventType;
  }

  @override
  set selectedEventType(String value) {
    _$selectedEventTypeAtom.reportWrite(value, super.selectedEventType, () {
      super.selectedEventType = value;
    });
  }

  late final _$selectedColorAtom =
      Atom(name: 'CalendarStoreBase.selectedColor', context: context);

  @override
  String? get selectedColor {
    _$selectedColorAtom.reportRead();
    return super.selectedColor;
  }

  @override
  set selectedColor(String? value) {
    _$selectedColorAtom.reportWrite(value, super.selectedColor, () {
      super.selectedColor = value;
    });
  }

  late final _$selectedStartDateAtom =
      Atom(name: 'CalendarStoreBase.selectedStartDate', context: context);

  @override
  DateTime? get selectedStartDate {
    _$selectedStartDateAtom.reportRead();
    return super.selectedStartDate;
  }

  @override
  set selectedStartDate(DateTime? value) {
    _$selectedStartDateAtom.reportWrite(value, super.selectedStartDate, () {
      super.selectedStartDate = value;
    });
  }

  late final _$selectedEndDateAtom =
      Atom(name: 'CalendarStoreBase.selectedEndDate', context: context);

  @override
  DateTime? get selectedEndDate {
    _$selectedEndDateAtom.reportRead();
    return super.selectedEndDate;
  }

  @override
  set selectedEndDate(DateTime? value) {
    _$selectedEndDateAtom.reportWrite(value, super.selectedEndDate, () {
      super.selectedEndDate = value;
    });
  }

  late final _$isAllDayAtom =
      Atom(name: 'CalendarStoreBase.isAllDay', context: context);

  @override
  bool get isAllDay {
    _$isAllDayAtom.reportRead();
    return super.isAllDay;
  }

  @override
  set isAllDay(bool value) {
    _$isAllDayAtom.reportWrite(value, super.isAllDay, () {
      super.isAllDay = value;
    });
  }

  late final _$selectedAttendeesAtom =
      Atom(name: 'CalendarStoreBase.selectedAttendees', context: context);

  @override
  ObservableList<User> get selectedAttendees {
    _$selectedAttendeesAtom.reportRead();
    return super.selectedAttendees;
  }

  @override
  set selectedAttendees(ObservableList<User> value) {
    _$selectedAttendeesAtom.reportWrite(value, super.selectedAttendees, () {
      super.selectedAttendees = value;
    });
  }

  late final _$selectedClientAtom =
      Atom(name: 'CalendarStoreBase.selectedClient', context: context);

  @override
  ClientModel? get selectedClient {
    _$selectedClientAtom.reportRead();
    return super.selectedClient;
  }

  @override
  set selectedClient(ClientModel? value) {
    _$selectedClientAtom.reportWrite(value, super.selectedClient, () {
      super.selectedClient = value;
    });
  }

  late final _$fetchEventsAsyncAction =
      AsyncAction('CalendarStoreBase.fetchEvents', context: context);

  @override
  Future<void> fetchEvents(DateTime firstDay, DateTime lastDay) {
    return _$fetchEventsAsyncAction
        .run(() => super.fetchEvents(firstDay, lastDay));
  }

  late final _$loadUsersForSelectionAsyncAction =
      AsyncAction('CalendarStoreBase.loadUsersForSelection', context: context);

  @override
  Future<void> loadUsersForSelection() {
    return _$loadUsersForSelectionAsyncAction
        .run(() => super.loadUsersForSelection());
  }

  late final _$saveEventAsyncAction =
      AsyncAction('CalendarStoreBase.saveEvent', context: context);

  @override
  Future<bool> saveEvent() {
    return _$saveEventAsyncAction.run(() => super.saveEvent());
  }

  late final _$deleteEventAsyncAction =
      AsyncAction('CalendarStoreBase.deleteEvent', context: context);

  @override
  Future<bool> deleteEvent(int eventId) {
    return _$deleteEventAsyncAction.run(() => super.deleteEvent(eventId));
  }

  late final _$CalendarStoreBaseActionController =
      ActionController(name: 'CalendarStoreBase', context: context);

  @override
  void onDaySelected(DateTime selected, DateTime focused) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.onDaySelected');
    try {
      return super.onDaySelected(selected, focused);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onRangeSelected(DateTime? start, DateTime? end, DateTime focused) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.onRangeSelected');
    try {
      return super.onRangeSelected(start, end, focused);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onFormatChanged(CalendarFormat format) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.onFormatChanged');
    try {
      return super.onFormatChanged(format);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onPageChanged(DateTime focused) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.onPageChanged');
    try {
      return super.onPageChanged(focused);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void prepareAddEvent([DateTime? selectedDate]) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.prepareAddEvent');
    try {
      return super.prepareAddEvent(selectedDate);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void prepareEditEvent(CalendarEventModel event) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.prepareEditEvent');
    try {
      return super.prepareEditEvent(event);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedColor(String? color) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.setSelectedColor');
    try {
      return super.setSelectedColor(color);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartDate(DateTime date) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.setStartDate');
    try {
      return super.setStartDate(date);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndDate(DateTime date) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.setEndDate');
    try {
      return super.setEndDate(date);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedClient(ClientModel? client) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.setSelectedClient');
    try {
      return super.setSelectedClient(client);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedEventType(String? type) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.setSelectedEventType');
    try {
      return super.setSelectedEventType(type);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleAllDay(bool value) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.toggleAllDay');
    try {
      return super.toggleAllDay(value);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSelectedAttendees(List<User> attendees) {
    final _$actionInfo = _$CalendarStoreBaseActionController.startAction(
        name: 'CalendarStoreBase.updateSelectedAttendees');
    try {
      return super.updateSelectedAttendees(attendees);
    } finally {
      _$CalendarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
eventsMap: ${eventsMap},
focusedDay: ${focusedDay},
selectedDay: ${selectedDay},
rangeStart: ${rangeStart},
rangeEnd: ${rangeEnd},
calendarFormat: ${calendarFormat},
userList: ${userList},
eventTypes: ${eventTypes},
fixedColors: ${fixedColors},
editingEventId: ${editingEventId},
selectedEventType: ${selectedEventType},
selectedColor: ${selectedColor},
selectedStartDate: ${selectedStartDate},
selectedEndDate: ${selectedEndDate},
isAllDay: ${isAllDay},
selectedAttendees: ${selectedAttendees},
selectedClient: ${selectedClient},
selectedDayEvents: ${selectedDayEvents},
isClientAppointmentSelected: ${isClientAppointmentSelected}
    ''';
  }
}
