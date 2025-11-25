import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/Approval/approval_request_model.dart';

part 'approval_store.g.dart';

class ApprovalStore = ApprovalStoreBase with _$ApprovalStore;

abstract class ApprovalStoreBase with Store {
  static const pageSize = 10;

  @observable
  PagingController<int, ApprovalRequestModel> leavePagingController =
      PagingController(firstPageKey: 0);

  @observable
  PagingController<int, ApprovalRequestModel> expensePagingController =
      PagingController(firstPageKey: 0);

  @observable
  bool isLoading = false;

  @observable
  String? selectedStatus;

  // (Optional) A date filter text controller if you need to filter by date.
  @observable
  String dateFilter = '';

  @action
  Future<void> fetchLeaveRequests(int pageKey) async {
    try {
      var result = await apiService.getLeaveRequestsForApprovals(
        skip: pageKey,
        take: pageSize,
        status: selectedStatus,
        date: dateFilter,
      );

      if (result != null) {
        final isLastPage = result.totalCount < pageSize;
        List<ApprovalRequestModel> items = result.values
            .map<ApprovalRequestModel>(
                (json) => ApprovalRequestModel.fromJson(json.toJson(), 'leave'))
            .toList();
        if (isLastPage) {
          leavePagingController.appendLastPage(items);
        } else {
          final nextPageKey = pageKey + items.length;
          leavePagingController.appendPage(items, nextPageKey);
        }
      }
    } catch (error) {
      leavePagingController.error = error;
    }
  }

  @action
  Future<bool> takeAction(String type, int id, String action,
      {String? approvedAmount, String? comments}) async {
    isLoading = true;
    toast(type);
    try {
      Map req = {
        'id': id,
        'status': action,
      };

      if (approvedAmount != null) {
        req['approvedAmount'] = approvedAmount;
      }

      if (comments != null) {
        req['comments'] = comments;
      }

      if (type == 'leave') {
        var result = await apiService.takeLeaveActionForApproval(req);
        isLoading = false;
        return result;
      } else if (type == 'expense') {
        var result = await apiService.takeExpenseActionForApproval(req);
        isLoading = false;
        return result;
      }

      isLoading = false;
      return false;
    } catch (error) {
      isLoading = false;
      print('Error taking action: $error');
      return false;
    }
  }

  @action
  Future<void> fetchExpenseRequests(int pageKey) async {
    try {
      var result = await apiService.getExpenseRequestsForApprovals(
        skip: pageKey,
        take: pageSize,
        status: selectedStatus,
        date: dateFilter,
      );

      if (result != null) {
        final isLastPage = result.totalCount < pageSize;
        List<ApprovalRequestModel> items = result.values
            .map<ApprovalRequestModel>((json) =>
                ApprovalRequestModel.fromJson(json.toJson(), 'expense'))
            .toList();
        if (isLastPage) {
          expensePagingController.appendLastPage(items);
        } else {
          final nextPageKey = pageKey + items.length;
          expensePagingController.appendPage(items, nextPageKey);
        }
      }
    } catch (error) {
      expensePagingController.error = error;
    }
  }

  @action
  Future<void> refreshAll() async {
    leavePagingController.refresh();
    expensePagingController.refresh();
  }
}
