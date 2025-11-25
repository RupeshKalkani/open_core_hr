// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on ChatStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'ChatStoreBase.isLoading', context: context);

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

  late final _$userIdAtom =
      Atom(name: 'ChatStoreBase.userId', context: context);

  @override
  int? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$pagingControllerAtom =
      Atom(name: 'ChatStoreBase.pagingController', context: context);

  @override
  PagingController<int, ChatMessage> get pagingController {
    _$pagingControllerAtom.reportRead();
    return super.pagingController;
  }

  @override
  set pagingController(PagingController<int, ChatMessage> value) {
    _$pagingControllerAtom.reportWrite(value, super.pagingController, () {
      super.pagingController = value;
    });
  }

  late final _$fetchMessagesAsyncAction =
      AsyncAction('ChatStoreBase.fetchMessages', context: context);

  @override
  Future<void> fetchMessages(int pageKey, int chatId) {
    return _$fetchMessagesAsyncAction
        .run(() => super.fetchMessages(pageKey, chatId));
  }

  late final _$sendMessageAsyncAction =
      AsyncAction('ChatStoreBase.sendMessage', context: context);

  @override
  Future<void> sendMessage(int chatId, String content,
      {String type = 'text', bool isForward = false}) {
    return _$sendMessageAsyncAction.run(() =>
        super.sendMessage(chatId, content, type: type, isForward: isForward));
  }

  late final _$sendAttachmentAsyncAction =
      AsyncAction('ChatStoreBase.sendAttachment', context: context);

  @override
  Future<bool> sendAttachment(int chatId, String filePath, String type) {
    return _$sendAttachmentAsyncAction
        .run(() => super.sendAttachment(chatId, filePath, type));
  }

  late final _$fetchNewMessagesAsyncAction =
      AsyncAction('ChatStoreBase.fetchNewMessages', context: context);

  @override
  Future<void> fetchNewMessages() {
    return _$fetchNewMessagesAsyncAction.run(() => super.fetchNewMessages());
  }

  late final _$forwardFileAsyncAction =
      AsyncAction('ChatStoreBase.forwardFile', context: context);

  @override
  Future<dynamic> forwardFile(int chatId, int messageId) {
    return _$forwardFileAsyncAction
        .run(() => super.forwardFile(chatId, messageId));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
userId: ${userId},
pagingController: ${pagingController}
    ''';
  }
}
