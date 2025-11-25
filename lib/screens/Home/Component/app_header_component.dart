import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_constants.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/screens/Account/account_screen.dart';

import '../../../main.dart';
import '../../Notification/notification_screen.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  void initState() {
    super.initState();
    //_fetchUserStatus();
  }

  Future<void> _fetchUserStatus() async {
    await appStore.fetchUserStatus(null);
    setState(() {});
  }

  void _updateUserStatus(String newStatus) async {
    await appStore.updateUserStatus(newStatus);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'profile',
                child: GestureDetector(
                  onTap: () {
                    AccountScreen().launch(context);
                  },
                  child: profileImageWidget(),
                ),
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*   Text(
                    'Welcome Back!',
                    style: boldTextStyle(size: 14),
                  ),*/
                  Row(
                    children: [
                      Text(
                        sharedHelper.getFullName(),
                        style: primaryTextStyle(size: 18),
                      ),
                      //2.width,
                      // const Icon(Icons.keyboard_arrow_down_rounded, size: 18)
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Text(
                        getStringAsync(designationPref),
                        style: secondaryTextStyle(size: 14),
                      ),
                    ],
                  ),
                ],
              ).onTap(() {
                // _showStatusChangePopup(context);
              }),
            ],
          ),

          const Spacer(),

          // Settings Icon
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () {
              NotificationScreen().launch(context);
            },
          ),
        ],
      ),
    );
  }

  /// Helper Widget: Status Dot
  Widget _buildStatusDot(String status) {
    final Map<String, Color> statusColors = {
      'online': Colors.green,
      'offline': Colors.grey,
      'busy': Colors.red,
      'away': Colors.orange,
      'on_call': Colors.blueAccent,
      'do_not_disturb': Colors.purple,
      'on_leave': Colors.teal,
      'on_meeting': Colors.cyan,
      'unknown': Colors.grey,
    };

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: statusColors[status] ?? Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Popup for Status Change
  void _showStatusChangePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Change Status', style: boldTextStyle(size: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: appStore.statuses.map((status) {
              return ListTile(
                leading: _buildStatusDot(status),
                title: Text(status.capitalizeFirstLetter(),
                    style: primaryTextStyle(size: 14)),
                onTap: () {
                  _updateUserStatus(status);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
