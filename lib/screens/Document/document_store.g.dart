// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DocumentStore on DocumentStoreBase, Store {
  late final _$pagingControllerAtom =
      Atom(name: 'DocumentStoreBase.pagingController', context: context);

  @override
  PagingController<int, DocumentRequestModel> get pagingController {
    _$pagingControllerAtom.reportRead();
    return super.pagingController;
  }

  @override
  set pagingController(PagingController<int, DocumentRequestModel> value) {
    _$pagingControllerAtom.reportWrite(value, super.pagingController, () {
      super.pagingController = value;
    });
  }

  late final _$isDownloadLoadingAtom =
      Atom(name: 'DocumentStoreBase.isDownloadLoading', context: context);

  @override
  bool get isDownloadLoading {
    _$isDownloadLoadingAtom.reportRead();
    return super.isDownloadLoading;
  }

  @override
  set isDownloadLoading(bool value) {
    _$isDownloadLoadingAtom.reportWrite(value, super.isDownloadLoading, () {
      super.isDownloadLoading = value;
    });
  }

  late final _$statusesAtom =
      Atom(name: 'DocumentStoreBase.statuses', context: context);

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

  late final _$dateFilterControllerAtom =
      Atom(name: 'DocumentStoreBase.dateFilterController', context: context);

  @override
  TextEditingController get dateFilterController {
    _$dateFilterControllerAtom.reportRead();
    return super.dateFilterController;
  }

  @override
  set dateFilterController(TextEditingController value) {
    _$dateFilterControllerAtom.reportWrite(value, super.dateFilterController,
        () {
      super.dateFilterController = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'DocumentStoreBase.isLoading', context: context);

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

  late final _$documentRequestsAtom =
      Atom(name: 'DocumentStoreBase.documentRequests', context: context);

  @override
  List<DocumentRequestModel> get documentRequests {
    _$documentRequestsAtom.reportRead();
    return super.documentRequests;
  }

  @override
  set documentRequests(List<DocumentRequestModel> value) {
    _$documentRequestsAtom.reportWrite(value, super.documentRequests, () {
      super.documentRequests = value;
    });
  }

  late final _$fetchDocumentRequestsAsyncAction =
      AsyncAction('DocumentStoreBase.fetchDocumentRequests', context: context);

  @override
  Future<void> fetchDocumentRequests(int pageKey) {
    return _$fetchDocumentRequestsAsyncAction
        .run(() => super.fetchDocumentRequests(pageKey));
  }

  late final _$sendDocumentRequestAsyncAction =
      AsyncAction('DocumentStoreBase.sendDocumentRequest', context: context);

  @override
  Future<bool> sendDocumentRequest() {
    return _$sendDocumentRequestAsyncAction
        .run(() => super.sendDocumentRequest());
  }

  late final _$getDocumentTypesAsyncAction =
      AsyncAction('DocumentStoreBase.getDocumentTypes', context: context);

  @override
  Future<dynamic> getDocumentTypes() {
    return _$getDocumentTypesAsyncAction.run(() => super.getDocumentTypes());
  }

  late final _$getDocumentFileUrlAsyncAction =
      AsyncAction('DocumentStoreBase.getDocumentFileUrl', context: context);

  @override
  Future<dynamic> getDocumentFileUrl(int id) {
    return _$getDocumentFileUrlAsyncAction
        .run(() => super.getDocumentFileUrl(id));
  }

  late final _$cancelDocumentRequestAsyncAction =
      AsyncAction('DocumentStoreBase.cancelDocumentRequest', context: context);

  @override
  Future<bool> cancelDocumentRequest(int id) {
    return _$cancelDocumentRequestAsyncAction
        .run(() => super.cancelDocumentRequest(id));
  }

  @override
  String toString() {
    return '''
pagingController: ${pagingController},
isDownloadLoading: ${isDownloadLoading},
statuses: ${statuses},
dateFilterController: ${dateFilterController},
isLoading: ${isLoading},
documentRequests: ${documentRequests}
    ''';
  }
}
