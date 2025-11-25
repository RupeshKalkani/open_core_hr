// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AttendanceHistoryStore on AttendanceHistoryStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'AttendanceHistoryStoreBase.isLoading', context: context);

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

  late final _$startRangeAtom =
      Atom(name: 'AttendanceHistoryStoreBase.startRange', context: context);

  @override
  String? get startRange {
    _$startRangeAtom.reportRead();
    return super.startRange;
  }

  @override
  set startRange(String? value) {
    _$startRangeAtom.reportWrite(value, super.startRange, () {
      super.startRange = value;
    });
  }

  late final _$endRangeAtom =
      Atom(name: 'AttendanceHistoryStoreBase.endRange', context: context);

  @override
  String? get endRange {
    _$endRangeAtom.reportRead();
    return super.endRange;
  }

  @override
  set endRange(String? value) {
    _$endRangeAtom.reportWrite(value, super.endRange, () {
      super.endRange = value;
    });
  }

  late final _$pagingControllerAtom = Atom(
      name: 'AttendanceHistoryStoreBase.pagingController', context: context);

  @override
  PagingController<int, AttendanceHistoryModel> get pagingController {
    _$pagingControllerAtom.reportRead();
    return super.pagingController;
  }

  @override
  set pagingController(PagingController<int, AttendanceHistoryModel> value) {
    _$pagingControllerAtom.reportWrite(value, super.pagingController, () {
      super.pagingController = value;
    });
  }

  late final _$getAttendanceHistoryAsyncAction = AsyncAction(
      'AttendanceHistoryStoreBase.getAttendanceHistory',
      context: context);

  @override
  Future<dynamic> getAttendanceHistory(int pageKey) {
    return _$getAttendanceHistoryAsyncAction
        .run(() => super.getAttendanceHistory(pageKey));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
startRange: ${startRange},
endRange: ${endRange},
pagingController: ${pagingController}
    ''';
  }
}
