// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatListStore on ChatListStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'ChatListStoreBase.isLoading', context: context);

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

  late final _$chatsAtom =
      Atom(name: 'ChatListStoreBase.chats', context: context);

  @override
  ObservableList<Chat> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(ObservableList<Chat> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
    });
  }

  late final _$fetchPaginatedUsersAsyncAction =
      AsyncAction('ChatListStoreBase.fetchPaginatedUsers', context: context);

  @override
  Future<List<User>> fetchPaginatedUsers(int skip, int take) {
    return _$fetchPaginatedUsersAsyncAction
        .run(() => super.fetchPaginatedUsers(skip, take));
  }

  late final _$fetchChatsAsyncAction =
      AsyncAction('ChatListStoreBase.fetchChats', context: context);

  @override
  Future<void> fetchChats() {
    return _$fetchChatsAsyncAction.run(() => super.fetchChats());
  }

  late final _$addChatAsyncAction =
      AsyncAction('ChatListStoreBase.addChat', context: context);

  @override
  Future<void> addChat(Chat chat) {
    return _$addChatAsyncAction.run(() => super.addChat(chat));
  }

  late final _$ChatListStoreBaseActionController =
      ActionController(name: 'ChatListStoreBase', context: context);

  @override
  void searchChats(String query) {
    final _$actionInfo = _$ChatListStoreBaseActionController.startAction(
        name: 'ChatListStoreBase.searchChats');
    try {
      return super.searchChats(query);
    } finally {
      _$ChatListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
chats: ${chats}
    ''';
  }
}
