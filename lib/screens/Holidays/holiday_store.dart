import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';

import '../../main.dart';
import '../../models/holiday_model.dart';

part 'holiday_store.g.dart';

class HolidayStore = HolidayStoreBase with _$HolidayStore;

abstract class HolidayStoreBase with Store {
  static const pageSize = 10;

  final TextEditingController yearFilterController = TextEditingController();

  final PagingController<int, HolidayModel> pagingController =
      PagingController(firstPageKey: 0);

  @observable
  int? yearFilter;

  Future<void> fetchHolidays(int pageKey) async {
    try {
      var result = await apiService.getHolidays(
          skip: pageKey,
          take: pageSize,
          year: yearFilter ?? DateTime.now().year);
      if (result != null) {
        final isLastPage = result.totalCount < pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(result.values);
        } else {
          final nextPageKey = pageKey + result.values.length;
          pagingController.appendPage(result.values, nextPageKey);
        }
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}
