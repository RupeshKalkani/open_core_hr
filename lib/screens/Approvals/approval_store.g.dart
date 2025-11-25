// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ApprovalStore on ApprovalStoreBase, Store {
  late final _$leavePagingControllerAtom =
      Atom(name: 'ApprovalStoreBase.leavePagingController', context: context);

  @override
  PagingController<int, ApprovalRequestModel> get leavePagingController {
    _$leavePagingControllerAtom.reportRead();
    return super.leavePagingController;
  }

  @override
  set leavePagingController(PagingController<int, ApprovalRequestModel> value) {
    _$leavePagingControllerAtom.reportWrite(value, super.leavePagingController,
        () {
      super.leavePagingController = value;
    });
  }

  late final _$expensePagingControllerAtom =
      Atom(name: 'ApprovalStoreBase.expensePagingController', context: context);

  @override
  PagingController<int, ApprovalRequestModel> get expensePagingController {
    _$expensePagingControllerAtom.reportRead();
    return super.expensePagingController;
  }

  @override
  set expensePagingController(
      PagingController<int, ApprovalRequestModel> value) {
    _$expensePagingControllerAtom
        .reportWrite(value, super.expensePagingController, () {
      super.expensePagingController = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'ApprovalStoreBase.isLoading', context: context);

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

  late final _$selectedStatusAtom =
      Atom(name: 'ApprovalStoreBase.selectedStatus', context: context);

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

  late final _$dateFilterAtom =
      Atom(name: 'ApprovalStoreBase.dateFilter', context: context);

  @override
  String get dateFilter {
    _$dateFilterAtom.reportRead();
    return super.dateFilter;
  }

  @override
  set dateFilter(String value) {
    _$dateFilterAtom.reportWrite(value, super.dateFilter, () {
      super.dateFilter = value;
    });
  }

  late final _$fetchLeaveRequestsAsyncAction =
      AsyncAction('ApprovalStoreBase.fetchLeaveRequests', context: context);

  @override
  Future<void> fetchLeaveRequests(int pageKey) {
    return _$fetchLeaveRequestsAsyncAction
        .run(() => super.fetchLeaveRequests(pageKey));
  }

  late final _$takeActionAsyncAction =
      AsyncAction('ApprovalStoreBase.takeAction', context: context);

  @override
  Future<bool> takeAction(String type, int id, String action,
      {String? approvedAmount, String? comments}) {
    return _$takeActionAsyncAction.run(() => super.takeAction(type, id, action,
        approvedAmount: approvedAmount, comments: comments));
  }

  late final _$fetchExpenseRequestsAsyncAction =
      AsyncAction('ApprovalStoreBase.fetchExpenseRequests', context: context);

  @override
  Future<void> fetchExpenseRequests(int pageKey) {
    return _$fetchExpenseRequestsAsyncAction
        .run(() => super.fetchExpenseRequests(pageKey));
  }

  late final _$refreshAllAsyncAction =
      AsyncAction('ApprovalStoreBase.refreshAll', context: context);

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  @override
  String toString() {
    return '''
leavePagingController: ${leavePagingController},
expensePagingController: ${expensePagingController},
isLoading: ${isLoading},
selectedStatus: ${selectedStatus},
dateFilter: ${dateFilter}
    ''';
  }
}
