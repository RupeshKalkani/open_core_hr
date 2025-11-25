// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewChatStore on NewChatStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'NewChatStoreBase.isLoading', context: context);

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

  late final _$isSearchActiveAtom =
      Atom(name: 'NewChatStoreBase.isSearchActive', context: context);

  @override
  bool get isSearchActive {
    _$isSearchActiveAtom.reportRead();
    return super.isSearchActive;
  }

  @override
  set isSearchActive(bool value) {
    _$isSearchActiveAtom.reportWrite(value, super.isSearchActive, () {
      super.isSearchActive = value;
    });
  }

  late final _$searchResultsAtom =
      Atom(name: 'NewChatStoreBase.searchResults', context: context);

  @override
  ObservableList<User> get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(ObservableList<User> value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  late final _$fetchPaginatedUsersAsyncAction =
      AsyncAction('NewChatStoreBase.fetchPaginatedUsers', context: context);

  @override
  Future<List<User>> fetchPaginatedUsers(int skip) {
    return _$fetchPaginatedUsersAsyncAction
        .run(() => super.fetchPaginatedUsers(skip));
  }

  late final _$searchUsersAsyncAction =
      AsyncAction('NewChatStoreBase.searchUsers', context: context);

  @override
  Future<void> searchUsers(String query) {
    return _$searchUsersAsyncAction.run(() => super.searchUsers(query));
  }

  late final _$createGroupChatAsyncAction =
      AsyncAction('NewChatStoreBase.createGroupChat', context: context);

  @override
  Future<Chat> createGroupChat(String groupName, List<int> userIds) {
    return _$createGroupChatAsyncAction
        .run(() => super.createGroupChat(groupName, userIds));
  }

  late final _$initiateChatAsyncAction =
      AsyncAction('NewChatStoreBase.initiateChat', context: context);

  @override
  Future<Chat?> initiateChat(int userId) {
    return _$initiateChatAsyncAction.run(() => super.initiateChat(userId));
  }

  late final _$NewChatStoreBaseActionController =
      ActionController(name: 'NewChatStoreBase', context: context);

  @override
  void setSearchActive(bool isActive) {
    final _$actionInfo = _$NewChatStoreBaseActionController.startAction(
        name: 'NewChatStoreBase.setSearchActive');
    try {
      return super.setSearchActive(isActive);
    } finally {
      _$NewChatStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSearch() {
    final _$actionInfo = _$NewChatStoreBaseActionController.startAction(
        name: 'NewChatStoreBase.clearSearch');
    try {
      return super.clearSearch();
    } finally {
      _$NewChatStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isSearchActive: ${isSearchActive},
searchResults: ${searchResults}
    ''';
  }
}
