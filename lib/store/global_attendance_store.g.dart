// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_attendance_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GlobalAttendanceStore on GlobalAttendanceStoreBase, Store {
  Computed<bool>? _$isKillDeviceComputed;

  @override
  bool get isKillDevice =>
      (_$isKillDeviceComputed ??= Computed<bool>(() => super.isKillDevice,
              name: 'GlobalAttendanceStoreBase.isKillDevice'))
          .value;
  Computed<bool>? _$isNewComputed;

  @override
  bool get isNew => (_$isNewComputed ??= Computed<bool>(() => super.isNew,
          name: 'GlobalAttendanceStoreBase.isNew'))
      .value;
  Computed<bool>? _$isCheckedInComputed;

  @override
  bool get isCheckedIn =>
      (_$isCheckedInComputed ??= Computed<bool>(() => super.isCheckedIn,
              name: 'GlobalAttendanceStoreBase.isCheckedIn'))
          .value;
  Computed<bool>? _$isLateComputed;

  @override
  bool get isLate => (_$isLateComputed ??= Computed<bool>(() => super.isLate,
          name: 'GlobalAttendanceStoreBase.isLate'))
      .value;
  Computed<bool>? _$isCheckedOutComputed;

  @override
  bool get isCheckedOut =>
      (_$isCheckedOutComputed ??= Computed<bool>(() => super.isCheckedOut,
              name: 'GlobalAttendanceStoreBase.isCheckedOut'))
          .value;
  Computed<String>? _$trackedHoursComputed;

  @override
  String get trackedHours =>
      (_$trackedHoursComputed ??= Computed<String>(() => super.trackedHours,
              name: 'GlobalAttendanceStoreBase.trackedHours'))
          .value;
  Computed<String>? _$travelledDistanceComputed;

  @override
  String get travelledDistance => (_$travelledDistanceComputed ??=
          Computed<String>(() => super.travelledDistance,
              name: 'GlobalAttendanceStoreBase.travelledDistance'))
      .value;
  Computed<bool>? _$isSiteEmployeeComputed;

  @override
  bool get isSiteEmployee =>
      (_$isSiteEmployeeComputed ??= Computed<bool>(() => super.isSiteEmployee,
              name: 'GlobalAttendanceStoreBase.isSiteEmployee'))
          .value;
  Computed<String>? _$siteNameComputed;

  @override
  String get siteName =>
      (_$siteNameComputed ??= Computed<String>(() => super.siteName,
              name: 'GlobalAttendanceStoreBase.siteName'))
          .value;
  Computed<AttendanceType>? _$attendanceTypeComputed;

  @override
  AttendanceType get attendanceType => (_$attendanceTypeComputed ??=
          Computed<AttendanceType>(() => super.attendanceType,
              name: 'GlobalAttendanceStoreBase.attendanceType'))
      .value;
  Computed<bool>? _$isOnBreakComputed;

  @override
  bool get isOnBreak =>
      (_$isOnBreakComputed ??= Computed<bool>(() => super.isOnBreak,
              name: 'GlobalAttendanceStoreBase.isOnBreak'))
          .value;
  Computed<DateTime>? _$breakStartAtComputed;

  @override
  DateTime get breakStartAt =>
      (_$breakStartAtComputed ??= Computed<DateTime>(() => super.breakStartAt,
              name: 'GlobalAttendanceStoreBase.breakStartAt'))
          .value;
  Computed<String>? _$shiftStartAtComputed;

  @override
  String get shiftStartAt =>
      (_$shiftStartAtComputed ??= Computed<String>(() => super.shiftStartAt,
              name: 'GlobalAttendanceStoreBase.shiftStartAt'))
          .value;
  Computed<String>? _$shiftEndAtComputed;

  @override
  String get shiftEndAt =>
      (_$shiftEndAtComputed ??= Computed<String>(() => super.shiftEndAt,
              name: 'GlobalAttendanceStoreBase.shiftEndAt'))
          .value;

  late final _$isInOutBtnLoadingAtom = Atom(
      name: 'GlobalAttendanceStoreBase.isInOutBtnLoading', context: context);

  @override
  bool get isInOutBtnLoading {
    _$isInOutBtnLoadingAtom.reportRead();
    return super.isInOutBtnLoading;
  }

  @override
  set isInOutBtnLoading(bool value) {
    _$isInOutBtnLoadingAtom.reportWrite(value, super.isInOutBtnLoading, () {
      super.isInOutBtnLoading = value;
    });
  }

  late final _$isBreakBtnLoadingAtom = Atom(
      name: 'GlobalAttendanceStoreBase.isBreakBtnLoading', context: context);

  @override
  bool get isBreakBtnLoading {
    _$isBreakBtnLoadingAtom.reportRead();
    return super.isBreakBtnLoading;
  }

  @override
  set isBreakBtnLoading(bool value) {
    _$isBreakBtnLoadingAtom.reportWrite(value, super.isBreakBtnLoading, () {
      super.isBreakBtnLoading = value;
    });
  }

  late final _$currentStatusAtom =
      Atom(name: 'GlobalAttendanceStoreBase.currentStatus', context: context);

  @override
  StatusResponse? get currentStatus {
    _$currentStatusAtom.reportRead();
    return super.currentStatus;
  }

  @override
  set currentStatus(StatusResponse? value) {
    _$currentStatusAtom.reportWrite(value, super.currentStatus, () {
      super.currentStatus = value;
    });
  }

  late final _$isVisitsCountLoadingAtom = Atom(
      name: 'GlobalAttendanceStoreBase.isVisitsCountLoading', context: context);

  @override
  bool get isVisitsCountLoading {
    _$isVisitsCountLoadingAtom.reportRead();
    return super.isVisitsCountLoading;
  }

  @override
  set isVisitsCountLoading(bool value) {
    _$isVisitsCountLoadingAtom.reportWrite(value, super.isVisitsCountLoading,
        () {
      super.isVisitsCountLoading = value;
    });
  }

  late final _$validateQrCodeAsyncAction =
      AsyncAction('GlobalAttendanceStoreBase.validateQrCode', context: context);

  @override
  Future<bool> validateQrCode(String qrCode) {
    return _$validateQrCodeAsyncAction.run(() => super.validateQrCode(qrCode));
  }

  late final _$validateDynamicQrCodeAsyncAction = AsyncAction(
      'GlobalAttendanceStoreBase.validateDynamicQrCode',
      context: context);

  @override
  Future<bool> validateDynamicQrCode(String qrCode) {
    return _$validateDynamicQrCodeAsyncAction
        .run(() => super.validateDynamicQrCode(qrCode));
  }

  late final _$validateIpAddressAsyncAction = AsyncAction(
      'GlobalAttendanceStoreBase.validateIpAddress',
      context: context);

  @override
  Future<bool> validateIpAddress() {
    return _$validateIpAddressAsyncAction.run(() => super.validateIpAddress());
  }

  late final _$startStopBreakAsyncAction =
      AsyncAction('GlobalAttendanceStoreBase.startStopBreak', context: context);

  @override
  Future<bool> startStopBreak() {
    return _$startStopBreakAsyncAction.run(() => super.startStopBreak());
  }

  late final _$validateGeofenceAsyncAction = AsyncAction(
      'GlobalAttendanceStoreBase.validateGeofence',
      context: context);

  @override
  Future<bool> validateGeofence() {
    return _$validateGeofenceAsyncAction.run(() => super.validateGeofence());
  }

  late final _$setEarlyCheckoutReasonAsyncAction = AsyncAction(
      'GlobalAttendanceStoreBase.setEarlyCheckoutReason',
      context: context);

  @override
  Future<bool> setEarlyCheckoutReason(String reason) {
    return _$setEarlyCheckoutReasonAsyncAction
        .run(() => super.setEarlyCheckoutReason(reason));
  }

  late final _$checkInOutAsyncAction =
      AsyncAction('GlobalAttendanceStoreBase.checkInOut', context: context);

  @override
  Future<dynamic> checkInOut(AttendanceStatus status,
      {String? lateCheckInReason}) {
    return _$checkInOutAsyncAction.run(
        () => super.checkInOut(status, lateCheckInReason: lateCheckInReason));
  }

  late final _$refreshVisitsCountAsyncAction = AsyncAction(
      'GlobalAttendanceStoreBase.refreshVisitsCount',
      context: context);

  @override
  Future refreshVisitsCount() {
    return _$refreshVisitsCountAsyncAction
        .run(() => super.refreshVisitsCount());
  }

  late final _$GlobalAttendanceStoreBaseActionController =
      ActionController(name: 'GlobalAttendanceStoreBase', context: context);

  @override
  void setCurrentStatus(StatusResponse status) {
    final _$actionInfo = _$GlobalAttendanceStoreBaseActionController
        .startAction(name: 'GlobalAttendanceStoreBase.setCurrentStatus');
    try {
      return super.setCurrentStatus(status);
    } finally {
      _$GlobalAttendanceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isInOutBtnLoading: ${isInOutBtnLoading},
isBreakBtnLoading: ${isBreakBtnLoading},
currentStatus: ${currentStatus},
isVisitsCountLoading: ${isVisitsCountLoading},
isKillDevice: ${isKillDevice},
isNew: ${isNew},
isCheckedIn: ${isCheckedIn},
isLate: ${isLate},
isCheckedOut: ${isCheckedOut},
trackedHours: ${trackedHours},
travelledDistance: ${travelledDistance},
isSiteEmployee: ${isSiteEmployee},
siteName: ${siteName},
attendanceType: ${attendanceType},
isOnBreak: ${isOnBreak},
breakStartAt: ${breakStartAt},
shiftStartAt: ${shiftStartAt},
shiftEndAt: ${shiftEndAt}
    ''';
  }
}
