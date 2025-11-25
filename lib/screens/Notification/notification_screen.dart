import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/models/notification_model.dart';

import '../../main.dart';
import 'notification_store.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _store = NotificationStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _store.pagingController.addPageRequestListener((pageKey) {
      _store.fetchNotifications(pageKey);
    });
  }

  @override
  void dispose() {
    _store.pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground!,
      appBar: appBar(context, language.lblNotifications),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Tabs
          // _buildCategoryTabs(),
          Divider(height: 0, thickness: 1, color: Colors.grey.shade300),
          8.height,

          // Notifications List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => _store.pagingController.refresh(),
              ),
              child: PagedListView<int, NotificationModel>(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                pagingController: _store.pagingController,
                builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
                  noItemsFoundIndicatorBuilder: (context) =>
                      noDataWidget(message: language.lblNoNotificationsFound),
                  itemBuilder: (context, notification, index) {
                    return _buildNotificationItem(notification);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Category Tabs
  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _store.categories.map((category) {
          bool isSelected = _store.selectedCategory == category;
          return GestureDetector(
            onTap: () {
              _store.selectedCategory = category;
              setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? appStore.appColorPrimary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? appStore.appColorPrimary
                      : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: appStore.appColorPrimary.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

/*  /// Notifications List
  Widget _buildNotificationsList() {
    */ /*  List<NotificationModel> filteredNotifications =
        _store.selectedCategory == "All"
            ? notifications
            : notifications
                .where((notification) =>
                    notification.category == _store.selectedCategory)
                .toList();

    if (filteredNotifications.isEmpty) {
      return const Center(
        child: Text(
          "No notifications in this category.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }*/ /*



    return ListView.builder(
      itemCount: filteredNotifications.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemBuilder: (context, index) {
        final item = filteredNotifications[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildLeadingIcon(item.category),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: boldTextStyle(size: 16),
                        overflow: TextOverflow.ellipsis),
                    4.height,
                    Text(item.description,
                        style: secondaryTextStyle(size: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    6.height,
                    Text(item.time,
                        style:
                            secondaryTextStyle(size: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }*/

  _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLeadingIcon(notification.type.toString()),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.type == 'Chat'
                      ? notification.data!.title.toString()
                      : notification.type.toString(),
                  style: primaryTextStyle(size: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                4.height,
                Text(notification.data!.message ?? 'N/A',
                    style: secondaryTextStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                6.height,
                Text(
                  notification.createdAtHuman.toString(),
                  style: secondaryTextStyle(size: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Leading Icon based on Category
  Widget _buildLeadingIcon(String category) {
    IconData icon;
    Color color;

    switch (category) {
      case "Attendance":
        icon = Icons.access_time_filled;
        color = Colors.orangeAccent;
        break;
      case "Chat":
        icon = Icons.chat_bubble_outline;
        color = Colors.blueAccent;
        break;
      case "Approvals":
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      default:
        icon = Icons.notifications_active_outlined;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      radius: 28,
      child: Icon(icon, color: color, size: 28),
    );
  }
}
