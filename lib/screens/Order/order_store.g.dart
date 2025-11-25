// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderStore on OrderStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'OrderStoreBase.isLoading', context: context);

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

  late final _$isOrderCountLoadingAtom =
      Atom(name: 'OrderStoreBase.isOrderCountLoading', context: context);

  @override
  bool get isOrderCountLoading {
    _$isOrderCountLoadingAtom.reportRead();
    return super.isOrderCountLoading;
  }

  @override
  set isOrderCountLoading(bool value) {
    _$isOrderCountLoadingAtom.reportWrite(value, super.isOrderCountLoading, () {
      super.isOrderCountLoading = value;
    });
  }

  late final _$isOrdersHistoryLoadingAtom =
      Atom(name: 'OrderStoreBase.isOrdersHistoryLoading', context: context);

  @override
  bool get isOrdersHistoryLoading {
    _$isOrdersHistoryLoadingAtom.reportRead();
    return super.isOrdersHistoryLoading;
  }

  @override
  set isOrdersHistoryLoading(bool value) {
    _$isOrdersHistoryLoadingAtom
        .reportWrite(value, super.isOrdersHistoryLoading, () {
      super.isOrdersHistoryLoading = value;
    });
  }

  late final _$isSalesTargetLoadingAtom =
      Atom(name: 'OrderStoreBase.isSalesTargetLoading', context: context);

  @override
  bool get isSalesTargetLoading {
    _$isSalesTargetLoadingAtom.reportRead();
    return super.isSalesTargetLoading;
  }

  @override
  set isSalesTargetLoading(bool value) {
    _$isSalesTargetLoadingAtom.reportWrite(value, super.isSalesTargetLoading,
        () {
      super.isSalesTargetLoading = value;
    });
  }

  late final _$dateFilterAtom =
      Atom(name: 'OrderStoreBase.dateFilter', context: context);

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
      Atom(name: 'OrderStoreBase.pagingController', context: context);

  @override
  PagingController<int, OrderModel> get pagingController {
    _$pagingControllerAtom.reportRead();
    return super.pagingController;
  }

  @override
  set pagingController(PagingController<int, OrderModel> value) {
    _$pagingControllerAtom.reportWrite(value, super.pagingController, () {
      super.pagingController = value;
    });
  }

  late final _$getProductCategoriesAsyncAction =
      AsyncAction('OrderStoreBase.getProductCategories', context: context);

  @override
  Future<dynamic> getProductCategories() {
    return _$getProductCategoriesAsyncAction
        .run(() => super.getProductCategories());
  }

  late final _$getProductsAsyncAction =
      AsyncAction('OrderStoreBase.getProducts', context: context);

  @override
  Future<dynamic> getProducts(int categoryId) {
    return _$getProductsAsyncAction.run(() => super.getProducts(categoryId));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isOrderCountLoading: ${isOrderCountLoading},
isOrdersHistoryLoading: ${isOrdersHistoryLoading},
isSalesTargetLoading: ${isSalesTargetLoading},
dateFilter: ${dateFilter},
pagingController: ${pagingController}
    ''';
  }
}
