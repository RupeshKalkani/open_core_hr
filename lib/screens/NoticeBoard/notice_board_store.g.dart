// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_board_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NoticeBoardStore on NoticeBoardStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'NoticeBoardStoreBase.isLoading', context: context);

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

  late final _$noticesAtom =
      Atom(name: 'NoticeBoardStoreBase.notices', context: context);

  @override
  ObservableList<NoticeModel> get notices {
    _$noticesAtom.reportRead();
    return super.notices;
  }

  @override
  set notices(ObservableList<NoticeModel> value) {
    _$noticesAtom.reportWrite(value, super.notices, () {
      super.notices = value;
    });
  }

  late final _$getNoticeBoardAsyncAction =
      AsyncAction('NoticeBoardStoreBase.getNoticeBoard', context: context);

  @override
  Future getNoticeBoard() {
    return _$getNoticeBoardAsyncAction.run(() => super.getNoticeBoard());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
notices: ${notices}
    ''';
  }
}
