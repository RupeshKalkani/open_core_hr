// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LeaveStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LeaveStore on LeaveStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'LeaveStoreBase.isLoading', context: context);

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

  late final _$pagingControllerAtom =
      Atom(name: 'LeaveStoreBase.pagingController', context: context);

  @override
  PagingController<int, LeaveRequestModel> get pagingController {
    _$pagingControllerAtom.reportRead();
    return super.pagingController;
  }

  @override
  set pagingController(PagingController<int, LeaveRequestModel> value) {
    _$pagingControllerAtom.reportWrite(value, super.pagingController, () {
      super.pagingController = value;
    });
  }

  late final _$selectedStatusAtom =
      Atom(name: 'LeaveStoreBase.selectedStatus', context: context);

  @override
  String? get selectedStatus {
    _$selectedStatusAtom.reportRead();
    return super.selectedStatus;
  }

  @override
  set selectedStatus(String? value) {
    _$selectedStatusAtom.reportWrite(value, super.selectedStatus, () {
      super.selectedStatus = value;
    });
  }

  late final _$statusesAtom =
      Atom(name: 'LeaveStoreBase.statuses', context: context);

  @override
  ObservableList<String> get statuses {
    _$statusesAtom.reportRead();
    return super.statuses;
  }

  @override
  set statuses(ObservableList<String> value) {
    _$statusesAtom.reportWrite(value, super.statuses, () {
      super.statuses = value;
    });
  }

  late final _$fetchLeaveRequestsAsyncAction =
      AsyncAction('LeaveStoreBase.fetchLeaveRequests', context: context);

  @override
  Future<void> fetchLeaveRequests(int pageKey) {
    return _$fetchLeaveRequestsAsyncAction
        .run(() => super.fetchLeaveRequests(pageKey));
  }

  late final _$cancelLeaveAsyncAction =
      AsyncAction('LeaveStoreBase.cancelLeave', context: context);

  @override
  Future<bool> cancelLeave() {
    return _$cancelLeaveAsyncAction.run(() => super.cancelLeave());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
pagingController: ${pagingController},
selectedStatus: ${selectedStatus},
statuses: ${statuses}
    ''';
  }
}
