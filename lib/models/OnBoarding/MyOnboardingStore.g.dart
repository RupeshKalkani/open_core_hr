// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyOnboardingStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyOnboardingStore on MyOnboardingStoreBase, Store {
  late final _$checklistItemsAtom =
      Atom(name: 'MyOnboardingStoreBase.checklistItems', context: context);

  @override
  ObservableList<MyChecklistItemModel> get checklistItems {
    _$checklistItemsAtom.reportRead();
    return super.checklistItems;
  }

  @override
  set checklistItems(ObservableList<MyChecklistItemModel> value) {
    _$checklistItemsAtom.reportWrite(value, super.checklistItems, () {
      super.checklistItems = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'MyOnboardingStoreBase.isLoading', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: 'MyOnboardingStoreBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchChecklistAsyncAction =
      AsyncAction('MyOnboardingStoreBase.fetchChecklist', context: context);

  @override
  Future<void> fetchChecklist() {
    return _$fetchChecklistAsyncAction.run(() => super.fetchChecklist());
  }

  late final _$updateStatusAsyncAction =
      AsyncAction('MyOnboardingStoreBase.updateStatus', context: context);

  @override
  Future<bool> updateStatus(int checklistItemId, String newStatus,
      {String? employeeNotes}) {
    return _$updateStatusAsyncAction.run(() => super.updateStatus(
        checklistItemId, newStatus,
        employeeNotes: employeeNotes));
  }

  late final _$uploadFileAsyncAction =
      AsyncAction('MyOnboardingStoreBase.uploadFile', context: context);

  @override
  Future<bool> uploadFile(int checklistItemId, String filePath) {
    return _$uploadFileAsyncAction
        .run(() => super.uploadFile(checklistItemId, filePath));
  }

  @override
  String toString() {
    return '''
checklistItems: ${checklistItems},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
