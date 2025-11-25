import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:open_core_hr/models/attendance_history_model.dart';

part 'attendance_history_store.g.dart';

class AttendanceHistoryStore = AttendanceHistoryStoreBase
    with _$AttendanceHistoryStore;

abstract class AttendanceHistoryStoreBase with Store {
  static const pageSize = 10;

  @observable
  bool isLoading = false;

  @observable
  String? startRange;

  @observable
  String? endRange;

  TextEditingController dateRangeController = TextEditingController();

  @observable
  PagingController<int, AttendanceHistoryModel> pagingController =
      PagingController(firstPageKey: 0);

  @action
  Future getAttendanceHistory(int pageKey) async {
    isLoading = true;
    try {
      var result = await apiService.getAttendanceHistory(
        skip: pageKey,
        take: pageSize,
        startDate: startRange,
        endDate: endRange,
      );

      if (result != null) {
        final isLastPage = result.totalCount! < pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(result.values!);
        } else {
          pagingController.appendPage(
              result.values!, pageKey + result.values!.length);
        }
      }
      isLoading = false;
    } catch (error) {
      log('Error: $error');
      pagingController.error = error;
    }
  }
}
