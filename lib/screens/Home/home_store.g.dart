// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$isOrderCountLoadingAtom =
      Atom(name: 'HomeStoreBase.isOrderCountLoading', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: 'HomeStoreBase.isLoading', context: context);

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

  late final _$initAsyncAction =
      AsyncAction('HomeStoreBase.init', context: context);

  @override
  Future<dynamic> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  @override
  String toString() {
    return '''
isOrderCountLoading: ${isOrderCountLoading},
isLoading: ${isLoading}
    ''';
  }
}
