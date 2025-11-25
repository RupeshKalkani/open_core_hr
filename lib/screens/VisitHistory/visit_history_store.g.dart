// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VisitHistoryStore on VisitHistoryStoreBase, Store {
  late final _$dateFilterAtom =
      Atom(name: 'VisitHistoryStoreBase.dateFilter', context: context);

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

  late final _$pagingControllerAtom =
      Atom(name: 'VisitHistoryStoreBase.pagingController', context: context);

  @override
  PagingController<int, VisitModel> get pagingController {
    _$pagingControllerAtom.reportRead();
    return super.pagingController;
  }

  @override
  set pagingController(PagingController<int, VisitModel> value) {
    _$pagingControllerAtom.reportWrite(value, super.pagingController, () {
      super.pagingController = value;
    });
  }

  late final _$fetchVisitsAsyncAction =
      AsyncAction('VisitHistoryStoreBase.fetchVisits', context: context);

  @override
  Future<void> fetchVisits(int pageKey) {
    return _$fetchVisitsAsyncAction.run(() => super.fetchVisits(pageKey));
  }

  @override
  String toString() {
    return '''
dateFilter: ${dateFilter},
pagingController: ${pagingController}
    ''';
  }
}
