import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';

import '../../main.dart';
import '../../models/Visit/visit_model.dart';

part 'visit_history_store.g.dart';

class VisitHistoryStore = VisitHistoryStoreBase with _$VisitHistoryStore;

abstract class VisitHistoryStoreBase with Store {
  static const int pageSize = 10;

  final TextEditingController dateFilterController = TextEditingController();

  @observable
  String dateFilter = '';

  @observable
  PagingController<int, VisitModel> pagingController =
      PagingController(firstPageKey: 0);

  @action
  Future<void> fetchVisits(int pageKey) async {
    try {
      var result = await apiService.getVisitsHistory(
        skip: pageKey,
        take: pageSize,
        date: dateFilterController.text,
      );
      if (result != null) {
        final isLastPage = result.values!.length < pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(result.values!);
        } else {
          final nextPageKey = pageKey + result.values!.length;
          pagingController.appendPage(result.values!, nextPageKey);
        }
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}
