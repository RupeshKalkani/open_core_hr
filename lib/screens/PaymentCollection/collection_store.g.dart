// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CollectionStore on CollectionStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'CollectionStoreBase.isLoading', context: context);

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

  late final _$dateFilterAtom =
      Atom(name: 'CollectionStoreBase.dateFilter', context: context);

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

  late final _$createCollectionAsyncAction =
      AsyncAction('CollectionStoreBase.createCollection', context: context);

  @override
  Future<bool> createCollection() {
    return _$createCollectionAsyncAction.run(() => super.createCollection());
  }

  late final _$fetchPaymentCollectionsAsyncAction = AsyncAction(
      'CollectionStoreBase.fetchPaymentCollections',
      context: context);

  @override
  Future<void> fetchPaymentCollections(int pageKey) {
    return _$fetchPaymentCollectionsAsyncAction
        .run(() => super.fetchPaymentCollections(pageKey));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
dateFilter: ${dateFilter}
    ''';
  }
}
