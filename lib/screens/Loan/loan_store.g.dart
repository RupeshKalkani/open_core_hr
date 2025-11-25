// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoanStore on LoanStoreBase, Store {
  late final _$pagingControllerAtom =
      Atom(name: 'LoanStoreBase.pagingController', context: context);

  @override
  PagingController<int, LoanRequestModel> get pagingController {
    _$pagingControllerAtom.reportRead();
    return super.pagingController;
  }

  @override
  set pagingController(PagingController<int, LoanRequestModel> value) {
    _$pagingControllerAtom.reportWrite(value, super.pagingController, () {
      super.pagingController = value;
    });
  }

  late final _$statusesAtom =
      Atom(name: 'LoanStoreBase.statuses', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: 'LoanStoreBase.isLoading', context: context);

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

  late final _$fetchLoanRequestsAsyncAction =
      AsyncAction('LoanStoreBase.fetchLoanRequests', context: context);

  @override
  Future<void> fetchLoanRequests(int pageKey) {
    return _$fetchLoanRequestsAsyncAction
        .run(() => super.fetchLoanRequests(pageKey));
  }

  late final _$cancelLoanAsyncAction =
      AsyncAction('LoanStoreBase.cancelLoan', context: context);

  @override
  Future<void> cancelLoan(int id) {
    return _$cancelLoanAsyncAction.run(() => super.cancelLoan(id));
  }

  @override
  String toString() {
    return '''
pagingController: ${pagingController},
statuses: ${statuses},
isLoading: ${isLoading}
    ''';
  }
}
