import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/leave_request_model.dart';

part 'LeaveStore.g.dart';

class LeaveStore = LeaveStoreBase with _$LeaveStore;

abstract class LeaveStoreBase with Store {
  static const pageSize = 10;

  int? id;

  @observable
  bool isLoading = false;

  @observable
  PagingController<int, LeaveRequestModel> pagingController =
      PagingController(firstPageKey: 0);

  @observable
  String? selectedStatus;

  @observable
  ObservableList<String> statuses = ObservableList.of([
    'approved',
    'rejected',
    'cancelled',
    'pending',
  ]);

  @action
  Future<void> fetchLeaveRequests(int pageKey) async {
    try {
      var result = await apiService.getLeaveRequests(
        skip: pageKey,
        take: pageSize,
        status: selectedStatus,
      );

      if (result != null) {
        final isLastPage = result.totalCount < pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(result.values);
        } else {
          pagingController.appendPage(
              result.values, pageKey + result.values.length);
        }
      }
    } catch (error) {
      log('Error: $error');
      pagingController.error = error;
    }
  }

  @action
  Future<bool> cancelLeave() async {
    isLoading = true;

    var result = await apiService.cancelLeaveRequest(id!);
    if (result) {
      toast(language.lblLeaveRequestCancelledSuccessfully);
    }

    isLoading = false;

    return result;
  }
}
