// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HolidayStore on HolidayStoreBase, Store {
  late final _$yearFilterAtom =
      Atom(name: 'HolidayStoreBase.yearFilter', context: context);

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

  @override
  String toString() {
    return '''
yearFilter: ${yearFilter}
    ''';
  }
}
