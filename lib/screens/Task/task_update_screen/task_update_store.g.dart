// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_update_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TaskUpdateStore on TaskUpdateStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'TaskUpdateStoreBase.isLoading', context: context);

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

  late final _$fileNameAtom =
      Atom(name: 'TaskUpdateStoreBase.fileName', context: context);

  @override
  String get fileName {
    _$fileNameAtom.reportRead();
    return super.fileName;
  }

  @override
  set fileName(String value) {
    _$fileNameAtom.reportWrite(value, super.fileName, () {
      super.fileName = value;
    });
  }

  late final _$filePathAtom =
      Atom(name: 'TaskUpdateStoreBase.filePath', context: context);

  @override
  String get filePath {
    _$filePathAtom.reportRead();
    return super.filePath;
  }

  @override
  set filePath(String value) {
    _$filePathAtom.reportWrite(value, super.filePath, () {
      super.filePath = value;
    });
  }

  late final _$getTaskUpdatedAsyncAction =
      AsyncAction('TaskUpdateStoreBase.getTaskUpdated', context: context);

  @override
  Future<dynamic> getTaskUpdated(int taskId) {
    return _$getTaskUpdatedAsyncAction.run(() => super.getTaskUpdated(taskId));
  }

  late final _$sendMessageAsyncAction =
      AsyncAction('TaskUpdateStoreBase.sendMessage', context: context);

  @override
  Future<bool> sendMessage(String message) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(message));
  }

  late final _$shareLocationAsyncAction =
      AsyncAction('TaskUpdateStoreBase.shareLocation', context: context);

  @override
  Future<dynamic> shareLocation() {
    return _$shareLocationAsyncAction.run(() => super.shareLocation());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
fileName: ${fileName},
filePath: ${filePath}
    ''';
  }
}
