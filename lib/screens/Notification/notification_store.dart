import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/notification_model.dart';

import '../../main.dart';

part 'notification_store.g.dart';

class NotificationStore = NotificationStoreBase with _$NotificationStore;

abstract class NotificationStoreBase with Store {
  String selectedCategory = "All";
  final List<String> categories = [
    "All",
    "Attendance",
    "Chat",
    "Approvals",
    "Others"
  ];

  static const pageSize = 10;

  @observable
  PagingController<int, NotificationModel> pagingController =
      PagingController(firstPageKey: 0);

  @action
  Future<void> fetchNotifications(int pageKey) async {
    try {
      var result = await apiService.getNotifications(
        skip: pageKey,
        take: pageSize,
      );

      if (result != null && result.values != null) {
        // Check if it's the last page
        final isLastPage = result.values!.length < pageSize;

        if (isLastPage) {
          pagingController.appendLastPage(result.values!);
        } else {
          // Calculate the next page key
          pagingController.appendPage(
            result.values!,
            pageKey + result.values!.length,
          );
        }
      } else {
        // No data returned from the API
        pagingController.appendLastPage([]);
      }
    } catch (e) {
      log('Error fetching notifications: $e');
      pagingController.error = e;
    }
  }
}
