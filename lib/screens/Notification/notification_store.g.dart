// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificationStore on NotificationStoreBase, Store {
  late final _$pagingControllerAtom =
      Atom(name: 'NotificationStoreBase.pagingController', context: context);

  @override
  PagingController<int, NotificationModel> get pagingController {
    _$pagingControllerAtom.reportRead();
    return super.pagingController;
  }

  @override
  set pagingController(PagingController<int, NotificationModel> value) {
    _$pagingControllerAtom.reportWrite(value, super.pagingController, () {
      super.pagingController = value;
    });
  }

  late final _$fetchNotificationsAsyncAction =
      AsyncAction('NotificationStoreBase.fetchNotifications', context: context);

  @override
  Future<void> fetchNotifications(int pageKey) {
    return _$fetchNotificationsAsyncAction
        .run(() => super.fetchNotifications(pageKey));
  }

  @override
  String toString() {
    return '''
pagingController: ${pagingController}
    ''';
  }
}
