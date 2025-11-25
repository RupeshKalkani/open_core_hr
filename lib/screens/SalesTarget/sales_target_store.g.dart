// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_target_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SalesTargetStore on SalesTargetStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'SalesTargetStoreBase.isLoading', context: context);

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

  late final _$yearFilterAtom =
      Atom(name: 'SalesTargetStoreBase.yearFilter', context: context);

  @override
  int? get yearFilter {
    _$yearFilterAtom.reportRead();
    return super.yearFilter;
  }

  @override
  set yearFilter(int? value) {
    _$yearFilterAtom.reportWrite(value, super.yearFilter, () {
      super.yearFilter = value;
    });
  }

  late final _$getSalesTargetsAsyncAction =
      AsyncAction('SalesTargetStoreBase.getSalesTargets', context: context);

  @override
  Future<dynamic> getSalesTargets() {
    return _$getSalesTargetsAsyncAction.run(() => super.getSalesTargets());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
yearFilter: ${yearFilter}
    ''';
  }
}
